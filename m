Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF65408A4A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 13:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbhIMLeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 07:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239499AbhIMLd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 07:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11ED60F44;
        Mon, 13 Sep 2021 11:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631532764;
        bh=V64J6fMSLOiTCS1YPQVv4OQRj5n46fopSv7zTGS1Qk0=;
        h=Subject:To:Cc:From:Date:From;
        b=EW51Ly6rsx4CTtqCbxZeels45RF0uVeav6luOab+P1YEg82ABaeBedRAq97o9PgW3
         5MCXi4NHU6E6S4OyLBajxOHcvmGvAhXOZYR5QOKunNHeDk7hySyBQoTkHvTKBWn9FF
         Yhm4Vy/Spq7o5aDexGdr5XtHDUMUFo3wW0jbO53Y=
Subject: FAILED: patch "[PATCH] fuse: truncate pagecache on atomic_o_trunc" failed to apply to 4.14-stable tree
To:     mszeredi@redhat.com, stable@vger.kernel.org,
        xieyongji@bytedance.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Sep 2021 13:32:24 +0200
Message-ID: <1631532744219248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 76224355db7570cbe6b6f75c8929a1558828dd55 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 17 Aug 2021 21:05:16 +0200
Subject: [PATCH] fuse: truncate pagecache on atomic_o_trunc

fuse_finish_open() will be called with FUSE_NOWRITE in case of atomic
O_TRUNC.  This can deadlock with fuse_wait_on_page_writeback() in
fuse_launder_page() triggered by invalidate_inode_pages2().

Fix by replacing invalidate_inode_pages2() in fuse_finish_open() with a
truncate_pagecache() call.  This makes sense regardless of FOPEN_KEEP_CACHE
or fc->writeback cache, so do it unconditionally.

Reported-by: Xie Yongji <xieyongji@bytedance.com>
Reported-and-tested-by: syzbot+bea44a5189836d956894@syzkaller.appspotmail.com
Fixes: e4648309b85a ("fuse: truncate pending writes on O_TRUNC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 97f860cfc195..5e5efb66c7d7 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -198,12 +198,11 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
-	if (!(ff->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_STREAM)
 		stream_open(inode, file);
 	else if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+
 	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
@@ -211,10 +210,14 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, 0);
 		spin_unlock(&fi->lock);
+		truncate_pagecache(inode, 0);
 		fuse_invalidate_attr(inode);
 		if (fc->writeback_cache)
 			file_update_time(file);
+	} else if (!(ff->open_flags & FOPEN_KEEP_CACHE)) {
+		invalidate_inode_pages2(inode->i_mapping);
 	}
+
 	if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
 		fuse_link_write_file(file);
 }

