Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1945C0F6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244884AbhKXNM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:51572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348281AbhKXNKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:10:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5376124C;
        Wed, 24 Nov 2021 12:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757703;
        bh=ZhS+HnRqtyq2O0uva+2zYvxVji6GvXP1b7aJpOhv/hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRCA3wflKfJ4qJEaTK6nvgU0DzCuLXV1TPOek1K9uyq4fpIh5xj+tglF+TC2ONW0x
         9CdRAJyn3BYpvfhrV/hzmcmn8ncL/1wNhzk+8tfN9D9poR7LrDRQOX/g/lKsgbpJ2F
         G9UiuGew6rSYVmBZrRLnHaQH516JrKXcCw5i2VKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+bea44a5189836d956894@syzkaller.appspotmail.com
Subject: [PATCH 4.19 249/323] fuse: truncate pagecache on atomic_o_trunc
Date:   Wed, 24 Nov 2021 12:57:19 +0100
Message-Id: <20211124115727.311628203@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 76224355db7570cbe6b6f75c8929a1558828dd55 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -178,12 +178,11 @@ void fuse_finish_open(struct inode *inod
 
 	if (ff->open_flags & FOPEN_DIRECT_IO)
 		file->f_op = &fuse_direct_io_file_operations;
-	if (!(ff->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_inode_pages2(inode->i_mapping);
 	if (ff->open_flags & FOPEN_STREAM)
 		stream_open(inode, file);
 	else if (ff->open_flags & FOPEN_NONSEEKABLE)
 		nonseekable_open(inode, file);
+
 	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
@@ -191,10 +190,14 @@ void fuse_finish_open(struct inode *inod
 		fi->attr_version = ++fc->attr_version;
 		i_size_write(inode, 0);
 		spin_unlock(&fc->lock);
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


