Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8867940935D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240913AbhIMOVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240784AbhIMOQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE91561B01;
        Mon, 13 Sep 2021 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540681;
        bh=2HqpvZymOdCHaQf2VAqiXp2GlpNsxp2W56uhyfMbyRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KD1r+s7gAjj4IIWI51sOeVDA+JAy0LiF5Oin+0h6inqgJlGbt8T8nrnt72JfB9/Iv
         JxR1xG6dspbwQviI/jcgBWREcFGOEgpcPfzabY4pmMe7NEQ0lYhAGxl6RpzeTZeIjk
         UNxI/lpCZPRnxeuyZoj/yo57xXNaQG3eTnTzXX3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+bea44a5189836d956894@syzkaller.appspotmail.com
Subject: [PATCH 5.13 292/300] fuse: truncate pagecache on atomic_o_trunc
Date:   Mon, 13 Sep 2021 15:15:53 +0200
Message-Id: <20210913131119.213277668@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
@@ -198,12 +198,11 @@ void fuse_finish_open(struct inode *inod
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
 
@@ -211,10 +210,14 @@ void fuse_finish_open(struct inode *inod
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


