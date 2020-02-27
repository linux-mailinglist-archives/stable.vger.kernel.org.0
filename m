Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA02E171F29
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732876AbgB0OBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732873AbgB0OBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489292073D;
        Thu, 27 Feb 2020 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812069;
        bh=KqhDusmnOr0PMzX6nhRhCjvLTXSYqGhmCiQq3z60Vno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHjTFWLWxT/84DYgiDvHTfUIzr/2kMeBHofi6GYONvXrwOv5nm7ovbACAa7H5MD7Y
         QkaBFrmpTyFSzFciUZn1ASiwGnoJZK7h584q6P7DLddh1zMeXFNCRaVELgvC+H9V7M
         tUFeTlprU/qx2GbdH0ddZY2Kxo5kGUkmE71o8PXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.14 211/237] ext4: fix a data race in EXT4_I(inode)->i_disksize
Date:   Thu, 27 Feb 2020 14:37:05 +0100
Message-Id: <20200227132311.734338280@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

commit 35df4299a6487f323b0aca120ea3f485dfee2ae3 upstream.

EXT4_I(inode)->i_disksize could be accessed concurrently as noticed by
KCSAN,

 BUG: KCSAN: data-race in ext4_write_end [ext4] / ext4_writepages [ext4]

 write to 0xffff91c6713b00f8 of 8 bytes by task 49268 on cpu 127:
  ext4_write_end+0x4e3/0x750 [ext4]
  ext4_update_i_disksize at fs/ext4/ext4.h:3032
  (inlined by) ext4_update_inode_size at fs/ext4/ext4.h:3046
  (inlined by) ext4_write_end at fs/ext4/inode.c:1287
  generic_perform_write+0x208/0x2a0
  ext4_buffered_write_iter+0x11f/0x210 [ext4]
  ext4_file_write_iter+0xce/0x9e0 [ext4]
  new_sync_write+0x29c/0x3b0
  __vfs_write+0x92/0xa0
  vfs_write+0x103/0x260
  ksys_write+0x9d/0x130
  __x64_sys_write+0x4c/0x60
  do_syscall_64+0x91/0xb47
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 read to 0xffff91c6713b00f8 of 8 bytes by task 24872 on cpu 37:
  ext4_writepages+0x10ac/0x1d00 [ext4]
  mpage_map_and_submit_extent at fs/ext4/inode.c:2468
  (inlined by) ext4_writepages at fs/ext4/inode.c:2772
  do_writepages+0x5e/0x130
  __writeback_single_inode+0xeb/0xb20
  writeback_sb_inodes+0x429/0x900
  __writeback_inodes_wb+0xc4/0x150
  wb_writeback+0x4bd/0x870
  wb_workfn+0x6b4/0x960
  process_one_work+0x54c/0xbe0
  worker_thread+0x80/0x650
  kthread+0x1e0/0x200
  ret_from_fork+0x27/0x50

 Reported by Kernel Concurrency Sanitizer on:
 CPU: 37 PID: 24872 Comm: kworker/u261:2 Tainted: G        W  O L 5.5.0-next-20200204+ #5
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
 Workqueue: writeback wb_workfn (flush-7:0)

Since only the read is operating as lockless (outside of the
"i_data_sem"), load tearing could introduce a logic bug. Fix it by
adding READ_ONCE() for the read and WRITE_ONCE() for the write.

Signed-off-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/r/1581085751-31793-1-git-send-email-cai@lca.pw
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2867,7 +2867,7 @@ static inline void ext4_update_i_disksiz
 		     !inode_is_locked(inode));
 	down_write(&EXT4_I(inode)->i_data_sem);
 	if (newsize > EXT4_I(inode)->i_disksize)
-		EXT4_I(inode)->i_disksize = newsize;
+		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2564,7 +2564,7 @@ update_disksize:
 	 * truncate are avoided by checking i_size under i_data_sem.
 	 */
 	disksize = ((loff_t)mpd->first_page) << PAGE_SHIFT;
-	if (disksize > EXT4_I(inode)->i_disksize) {
+	if (disksize > READ_ONCE(EXT4_I(inode)->i_disksize)) {
 		int err2;
 		loff_t i_size;
 


