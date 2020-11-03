Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B352A5145
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgKCUjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730046AbgKCUi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8368822226;
        Tue,  3 Nov 2020 20:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435937;
        bh=ZLhE3GD/bPjDSWizsa/2eDscOTKpt0/k2QrU1UvS2EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROc15n5rXCcdonaDQjPFB1bGNvjPd2snBuWt9jxF0PoIZZsQDT7BcsudOqFNuou5p
         3CYzIErrJu2hvzXdKu+r96C4Rwris90TITTZgQJouFZxW3oXSyRINOPIaqYtgNhrBl
         vMNWN96H+h3QCwUGsArMSvRA48YZrvFFIqJhunSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, 5kft <5kft@5kft.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 046/391] f2fs: allocate proper size memory for zstd decompress
Date:   Tue,  3 Nov 2020 21:31:37 +0100
Message-Id: <20201103203350.677434569@linuxfoundation.org>
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

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 0e2b7385cb59e566520cfd0a04b4b53bc9461e98 ]

As 5kft <5kft@5kft.org> reported:

 kworker/u9:3: page allocation failure: order:9, mode:0x40c40(GFP_NOFS|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
 CPU: 3 PID: 8168 Comm: kworker/u9:3 Tainted: G         C        5.8.3-sunxi #trunk
 Hardware name: Allwinner sun8i Family
 Workqueue: f2fs_post_read_wq f2fs_post_read_work
 [<c010d6d5>] (unwind_backtrace) from [<c0109a55>] (show_stack+0x11/0x14)
 [<c0109a55>] (show_stack) from [<c056d489>] (dump_stack+0x75/0x84)
 [<c056d489>] (dump_stack) from [<c0243b53>] (warn_alloc+0xa3/0x104)
 [<c0243b53>] (warn_alloc) from [<c024473b>] (__alloc_pages_nodemask+0xb87/0xc40)
 [<c024473b>] (__alloc_pages_nodemask) from [<c02267c5>] (kmalloc_order+0x19/0x38)
 [<c02267c5>] (kmalloc_order) from [<c02267fd>] (kmalloc_order_trace+0x19/0x90)
 [<c02267fd>] (kmalloc_order_trace) from [<c047c665>] (zstd_init_decompress_ctx+0x21/0x88)
 [<c047c665>] (zstd_init_decompress_ctx) from [<c047e9cf>] (f2fs_decompress_pages+0x97/0x228)
 [<c047e9cf>] (f2fs_decompress_pages) from [<c045d0ab>] (__read_end_io+0xfb/0x130)
 [<c045d0ab>] (__read_end_io) from [<c045d141>] (f2fs_post_read_work+0x61/0x84)
 [<c045d141>] (f2fs_post_read_work) from [<c0130b2f>] (process_one_work+0x15f/0x3b0)
 [<c0130b2f>] (process_one_work) from [<c0130e7b>] (worker_thread+0xfb/0x3e0)
 [<c0130e7b>] (worker_thread) from [<c0135c3b>] (kthread+0xeb/0x10c)
 [<c0135c3b>] (kthread) from [<c0100159>]

zstd may allocate large size memory for {,de}compression, it may cause
file copy failure on low-end device which has very few memory.

For decompression, let's just allocate proper size memory based on current
file's cluster size instead of max cluster size.

Reported-by: 5kft <5kft@5kft.org>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 7 ++++---
 fs/f2fs/f2fs.h     | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 1dfb126a0cb20..1cd4b3f9c9f8c 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -382,16 +382,17 @@ static int zstd_init_decompress_ctx(struct decompress_io_ctx *dic)
 	ZSTD_DStream *stream;
 	void *workspace;
 	unsigned int workspace_size;
+	unsigned int max_window_size =
+			MAX_COMPRESS_WINDOW_SIZE(dic->log_cluster_size);
 
-	workspace_size = ZSTD_DStreamWorkspaceBound(MAX_COMPRESS_WINDOW_SIZE);
+	workspace_size = ZSTD_DStreamWorkspaceBound(max_window_size);
 
 	workspace = f2fs_kvmalloc(F2FS_I_SB(dic->inode),
 					workspace_size, GFP_NOFS);
 	if (!workspace)
 		return -ENOMEM;
 
-	stream = ZSTD_initDStream(MAX_COMPRESS_WINDOW_SIZE,
-					workspace, workspace_size);
+	stream = ZSTD_initDStream(max_window_size, workspace, workspace_size);
 	if (!stream) {
 		printk_ratelimited("%sF2FS-fs (%s): %s ZSTD_initDStream failed\n",
 				KERN_ERR, F2FS_I_SB(dic->inode)->sb->s_id,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d9e52a7f3702f..98c4b166f192b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1394,7 +1394,7 @@ struct decompress_io_ctx {
 #define NULL_CLUSTER			((unsigned int)(~0))
 #define MIN_COMPRESS_LOG_SIZE		2
 #define MAX_COMPRESS_LOG_SIZE		8
-#define MAX_COMPRESS_WINDOW_SIZE	((PAGE_SIZE) << MAX_COMPRESS_LOG_SIZE)
+#define MAX_COMPRESS_WINDOW_SIZE(log_size)	((PAGE_SIZE) << (log_size))
 
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
-- 
2.27.0



