Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B462A513B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgKCUiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729926AbgKCUiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0F622226;
        Tue,  3 Nov 2020 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435902;
        bh=TGK7mlkgXeQrAwCff9wzdMptFHOXgl4dBH+2QcBAUJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wV5GV/tPFNw6WjaOnAYdD8/GQBG76ykwXn4c/3vtuTI4xxcqm+5nxezpP6b1hhkYd
         uS7kJQVx+bHH6i81Jb9VhZSDVcjBT65TlK/hRpeIAyVEGw+Xa9kprRXzdnGZx+AnJK
         lhiosYgpdraexBJ1vQWQbRl8p10xGM6KD8iV19dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 033/391] afs: Fix where page->private is set during write
Date:   Tue,  3 Nov 2020 21:31:24 +0100
Message-Id: <20201103203349.971130227@linuxfoundation.org>
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

[ Upstream commit f792e3ac82fe2c6c863e93187eb7ddfccab68fa7 ]

In afs, page->private is set to indicate the dirty region of a page.  This
is done in afs_write_begin(), but that can't take account of whether the
copy into the page actually worked.

Fix this by moving the change of page->private into afs_write_end().

Fixes: 4343d00872e1 ("afs: Get rid of the afs_writeback record")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 7fae9f8b38eb3..f28d85c38cd89 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -135,23 +135,8 @@ try_again:
 		if (!test_bit(AFS_VNODE_NEW_CONTENT, &vnode->flags) &&
 		    (to < f || from > t))
 			goto flush_conflicting_write;
-		if (from < f)
-			f = from;
-		if (to > t)
-			t = to;
-	} else {
-		f = from;
-		t = to;
 	}
 
-	priv = (unsigned long)t << AFS_PRIV_SHIFT;
-	priv |= f;
-	trace_afs_page_dirty(vnode, tracepoint_string("begin"),
-			     page->index, priv);
-	if (PagePrivate(page))
-		set_page_private(page, priv);
-	else
-		attach_page_private(page, (void *)priv);
 	*_page = page;
 	_leave(" = 0");
 	return 0;
@@ -185,6 +170,9 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	struct key *key = afs_file_key(file);
+	unsigned long priv;
+	unsigned int f, from = pos & (PAGE_SIZE - 1);
+	unsigned int t, to = from + copied;
 	loff_t i_size, maybe_i_size;
 	int ret;
 
@@ -216,6 +204,29 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 		SetPageUptodate(page);
 	}
 
+	if (PagePrivate(page)) {
+		priv = page_private(page);
+		f = priv & AFS_PRIV_MAX;
+		t = priv >> AFS_PRIV_SHIFT;
+		if (from < f)
+			f = from;
+		if (to > t)
+			t = to;
+		priv = (unsigned long)t << AFS_PRIV_SHIFT;
+		priv |= f;
+		set_page_private(page, priv);
+		trace_afs_page_dirty(vnode, tracepoint_string("dirty+"),
+				     page->index, priv);
+	} else {
+		f = from;
+		t = to;
+		priv = (unsigned long)t << AFS_PRIV_SHIFT;
+		priv |= f;
+		attach_page_private(page, (void *)priv);
+		trace_afs_page_dirty(vnode, tracepoint_string("dirty"),
+				     page->index, priv);
+	}
+
 	set_page_dirty(page);
 	if (PageDirty(page))
 		_debug("dirtied");
-- 
2.27.0



