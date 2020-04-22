Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A7C1B3D0B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgDVKLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbgDVKLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56CF20857;
        Wed, 22 Apr 2020 10:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550268;
        bh=PfcOuRsi6E6+of7na+MjH2JgzM0JTZvYIlLx0ckO/aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIGKpEut7bVUnvzQpuOAINeWCJCsP+1ksVq8PVEZFHbCe5uVz/cgXQm4d01BsyBUh
         jIgC8zGRcaxLUDfrnSmlSJZXs6YkDRO8meiyTf2SzPulssQgEjDgYDDOOBBkGCfrH8
         8MoP+kCYwhTfOAUlu6VP5JxR2k0cvwg64DHKzQEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 077/199] ext4: fix a data race at inode->i_blocks
Date:   Wed, 22 Apr 2020 11:56:43 +0200
Message-Id: <20200422095105.834027843@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 28936b62e71e41600bab319f262ea9f9b1027629 upstream.

inode->i_blocks could be accessed concurrently as noticed by KCSAN,

 BUG: KCSAN: data-race in ext4_do_update_inode [ext4] / inode_add_bytes

 write to 0xffff9a00d4b982d0 of 8 bytes by task 22100 on cpu 118:
  inode_add_bytes+0x65/0xf0
  __inode_add_bytes at fs/stat.c:689
  (inlined by) inode_add_bytes at fs/stat.c:702
  ext4_mb_new_blocks+0x418/0xca0 [ext4]
  ext4_ext_map_blocks+0x1a6b/0x27b0 [ext4]
  ext4_map_blocks+0x1a9/0x950 [ext4]
  _ext4_get_block+0xfc/0x270 [ext4]
  ext4_get_block_unwritten+0x33/0x50 [ext4]
  __block_write_begin_int+0x22e/0xae0
  __block_write_begin+0x39/0x50
  ext4_write_begin+0x388/0xb50 [ext4]
  ext4_da_write_begin+0x35f/0x8f0 [ext4]
  generic_perform_write+0x15d/0x290
  ext4_buffered_write_iter+0x11f/0x210 [ext4]
  ext4_file_write_iter+0xce/0x9e0 [ext4]
  new_sync_write+0x29c/0x3b0
  __vfs_write+0x92/0xa0
  vfs_write+0x103/0x260
  ksys_write+0x9d/0x130
  __x64_sys_write+0x4c/0x60
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 read to 0xffff9a00d4b982d0 of 8 bytes by task 8 on cpu 65:
  ext4_do_update_inode+0x4a0/0xf60 [ext4]
  ext4_inode_blocks_set at fs/ext4/inode.c:4815
  ext4_mark_iloc_dirty+0xaf/0x160 [ext4]
  ext4_mark_inode_dirty+0x129/0x3e0 [ext4]
  ext4_convert_unwritten_extents+0x253/0x2d0 [ext4]
  ext4_convert_unwritten_io_end_vec+0xc5/0x150 [ext4]
  ext4_end_io_rsv_work+0x22c/0x350 [ext4]
  process_one_work+0x54f/0xb90
  worker_thread+0x80/0x5f0
  kthread+0x1cd/0x1f0
  ret_from_fork+0x27/0x50

 4 locks held by kworker/u256:0/8:
  #0: ffff9a025abc4328 ((wq_completion)ext4-rsv-conversion){+.+.}, at: process_one_work+0x443/0xb90
  #1: ffffab5a862dbe20 ((work_completion)(&ei->i_rsv_conversion_work)){+.+.}, at: process_one_work+0x443/0xb90
  #2: ffff9a025a9d0f58 (jbd2_handle){++++}, at: start_this_handle+0x1c1/0x9d0 [jbd2]
  #3: ffff9a00d4b985d8 (&(&ei->i_raw_lock)->rlock){+.+.}, at: ext4_do_update_inode+0xaa/0xf60 [ext4]
 irq event stamp: 3009267
 hardirqs last  enabled at (3009267): [<ffffffff980da9b7>] __find_get_block+0x107/0x790
 hardirqs last disabled at (3009266): [<ffffffff980da8f9>] __find_get_block+0x49/0x790
 softirqs last  enabled at (3009230): [<ffffffff98a0034c>] __do_softirq+0x34c/0x57c
 softirqs last disabled at (3009223): [<ffffffff97cc67a2>] irq_exit+0xa2/0xc0

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 65 PID: 8 Comm: kworker/u256:0 Tainted: G L 5.6.0-rc2-next-20200221+ #7
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
 Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work [ext4]

The plain read is outside of inode->i_lock critical section which
results in a data race. Fix it by adding READ_ONCE() there.

Link: https://lore.kernel.org/r/20200222043258.2279-1-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4981,7 +4981,7 @@ static int ext4_inode_blocks_set(handle_
 				struct ext4_inode_info *ei)
 {
 	struct inode *inode = &(ei->vfs_inode);
-	u64 i_blocks = inode->i_blocks;
+	u64 i_blocks = READ_ONCE(inode->i_blocks);
 	struct super_block *sb = inode->i_sb;
 
 	if (i_blocks <= ~0U) {


