Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DF82B6432
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732142AbgKQNig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731383AbgKQNia (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3778B207BC;
        Tue, 17 Nov 2020 13:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620309;
        bh=aYYzHOoCV6gCysEZbfGYvQNc1yvGfnQmzubeoEYDYII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tat+r/999pndcTJpP1QZ0cVVkJT+S0+fWI8EjG9qIhGs+9iwsJOl91cZQVdpslwo2
         7dYkRGb/rZnHa/iUT/ROXJEcx7ygyGx1+aLrJjvW9IAyOMXy9dEiR88de/MTJCHQzs
         G0yQfv4Oy/Gq+5R+XPCpnihwgTKIdeY9tg7g3BNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 175/255] afs: Fix afs_write_end() when called with copied == 0 [ver #3]
Date:   Tue, 17 Nov 2020 14:05:15 +0100
Message-Id: <20201117122147.442866855@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3ad216ee73abc554ed8f13f4f8b70845a7bef6da ]

When afs_write_end() is called with copied == 0, it tries to set the
dirty region, but there's no way to actually encode a 0-length region in
the encoding in page->private.

"0,0", for example, indicates a 1-byte region at offset 0.  The maths
miscalculates this and sets it incorrectly.

Fix it to just do nothing but unlock and put the page in this case.  We
don't actually need to mark the page dirty as nothing presumably
changed.

Fixes: 65dd2d6072d3 ("afs: Alter dirty range encoding in page->private")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 50371207f3273..c9195fc67fd8f 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -169,11 +169,14 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 	unsigned int f, from = pos & (PAGE_SIZE - 1);
 	unsigned int t, to = from + copied;
 	loff_t i_size, maybe_i_size;
-	int ret;
+	int ret = 0;
 
 	_enter("{%llx:%llu},{%lx}",
 	       vnode->fid.vid, vnode->fid.vnode, page->index);
 
+	if (copied == 0)
+		goto out;
+
 	maybe_i_size = pos + copied;
 
 	i_size = i_size_read(&vnode->vfs_inode);
-- 
2.27.0



