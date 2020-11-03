Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60E72A59AD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730046AbgKCWJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729919AbgKCUiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E2A1223AB;
        Tue,  3 Nov 2020 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435899;
        bh=stK+/aVtFkoEHCapqHEdcPR5CROo57/nfeCYpNTt55s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpLw9NQK1Y6xF2a5KyO7BARecv7Pwa54l+BWAEOl6Q66970fCb0+J2VGKjez7iPrY
         wLG8NxJMmZL1EOa9Rh1sbmRXcsLJsDe2dErWAqUD6WsQdQxsKWMaOapW7qkoofG3PW
         uMMrO7AzAqP/vCXtv7XjmdoxZ89VJ0oTR1WlCpek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Nick Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 032/391] afs: Fix page leak on afs_write_begin() failure
Date:   Tue,  3 Nov 2020 21:31:23 +0100
Message-Id: <20201103203349.918281557@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 21db2cdc667f744691a407105b7712bc18d74023 ]

Fix the leak of the target page in afs_write_begin() when it fails.

Fixes: 15b4650e55e0 ("afs: convert to new aops")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 02facb19a0f1d..7fae9f8b38eb3 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -76,7 +76,7 @@ static int afs_fill_page(struct afs_vnode *vnode, struct key *key,
  */
 int afs_write_begin(struct file *file, struct address_space *mapping,
 		    loff_t pos, unsigned len, unsigned flags,
-		    struct page **pagep, void **fsdata)
+		    struct page **_page, void **fsdata)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	struct page *page;
@@ -110,9 +110,6 @@ int afs_write_begin(struct file *file, struct address_space *mapping,
 		SetPageUptodate(page);
 	}
 
-	/* page won't leak in error case: it eventually gets cleaned off LRU */
-	*pagep = page;
-
 try_again:
 	/* See if this page is already partially written in a way that we can
 	 * merge the new write with.
@@ -155,6 +152,7 @@ try_again:
 		set_page_private(page, priv);
 	else
 		attach_page_private(page, (void *)priv);
+	*_page = page;
 	_leave(" = 0");
 	return 0;
 
@@ -164,17 +162,18 @@ try_again:
 flush_conflicting_write:
 	_debug("flush conflict");
 	ret = write_one_page(page);
-	if (ret < 0) {
-		_leave(" = %d", ret);
-		return ret;
-	}
+	if (ret < 0)
+		goto error;
 
 	ret = lock_page_killable(page);
-	if (ret < 0) {
-		_leave(" = %d", ret);
-		return ret;
-	}
+	if (ret < 0)
+		goto error;
 	goto try_again;
+
+error:
+	put_page(page);
+	_leave(" = %d", ret);
+	return ret;
 }
 
 /*
-- 
2.27.0



