Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31DF43F7B
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfFMP5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731504AbfFMIug (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:50:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57D2A206BA;
        Thu, 13 Jun 2019 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415834;
        bh=AFgu04Zbf96syeKBYHFHJQ2mQ1uktfhWH+9WXFmKeSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysqnwwJmZEvy91fmh4S9TgNl5YFqdOxRIPhlsSXKEV4hmO7TNYpEZiADrusSc+l2j
         Fvn0InoV8bnxgit/m1CHUWoGDxtSqBuemdZg07fhdwwUeKbi09STyE/c4j6r1Mkgs9
         JGKAvgyQ18L5iiThtwcPNvOhxBBJtCeiLYLCAGbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hagbard Celine <hagbardcelin@gmail.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 122/155] f2fs: fix potential recursive call when enabling data_flush
Date:   Thu, 13 Jun 2019 10:33:54 +0200
Message-Id: <20190613075659.685100362@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 186857c5a14aee85cace2ae7a36c6e43b9d3c7a5 ]

As Hagbard Celine reported:

Hi, this is a long standing bug that I've hit before on older kernels,
but I was not able to get the syslog saved because of the nature of
the bug. This time I had booted form a pen-drive, and was able to save
the log to it's efi-partition.
What i did to trigger it was to create a partition and format it f2fs,
then mount it with options:
"rw,relatime,lazytime,background_gc=on,disable_ext_identify,discard,heap,user_xattr,inline_xattr,acl,inline_data,inline_dentry,flush_merge,data_flush,extent_cache,mode=adaptive,active_logs=6,whint_mode=fs-based,alloc_mode=default,fsync_mode=strict".
Then I unpacked a big .tar.xz to the partition (I used a
gentoo-stage3-tarball as I was in process of installing Gentoo).

Same options just without data_flush gives no problems.

Mar 20 20:54:01 usbgentoo kernel: FAT-fs (nvme0n1p4): Volume was not
properly unmounted. Some data may be corrupt. Please run fsck.
Mar 20 21:05:23 usbgentoo kernel: kworker/dying (1588) used greatest
stack depth: 12064 bytes left
Mar 20 21:06:40 usbgentoo kernel: BUG: stack guard page was hit at
00000000a4b0733c (stack is 0000000056016422..0000000096e7463f)
Mar 20 21:06:40 usbgentoo kernel: kernel stack overflow

......

Mar 20 21:06:40 usbgentoo kernel: Call Trace:
Mar 20 21:06:40 usbgentoo kernel:  read_node_page+0x71/0xf0
Mar 20 21:06:40 usbgentoo kernel:  ? xas_load+0x8/0x50
Mar 20 21:06:40 usbgentoo kernel:  __get_node_page+0x73/0x2a0
Mar 20 21:06:40 usbgentoo kernel:  f2fs_get_dnode_of_data+0x34e/0x580
Mar 20 21:06:40 usbgentoo kernel:  f2fs_write_inline_data+0x5e/0x2a0
Mar 20 21:06:40 usbgentoo kernel:  __write_data_page+0x421/0x690
Mar 20 21:06:40 usbgentoo kernel:  f2fs_write_cache_pages+0x1cf/0x460
Mar 20 21:06:40 usbgentoo kernel:  f2fs_write_data_pages+0x2b3/0x2e0
Mar 20 21:06:40 usbgentoo kernel:  ? f2fs_inode_chksum_verify+0x1d/0xc0
Mar 20 21:06:40 usbgentoo kernel:  ? read_node_page+0x71/0xf0
Mar 20 21:06:40 usbgentoo kernel:  do_writepages+0x3c/0xd0
Mar 20 21:06:40 usbgentoo kernel:  __filemap_fdatawrite_range+0x7c/0xb0
Mar 20 21:06:40 usbgentoo kernel:  f2fs_sync_dirty_inodes+0xf2/0x200
Mar 20 21:06:40 usbgentoo kernel:  f2fs_balance_fs_bg+0x2a3/0x2c0
Mar 20 21:06:40 usbgentoo kernel:  ? f2fs_inode_dirtied+0x21/0xc0
Mar 20 21:06:40 usbgentoo kernel:  f2fs_balance_fs+0xd6/0x2b0
Mar 20 21:06:40 usbgentoo kernel:  __write_data_page+0x4fb/0x690

......

Mar 20 21:06:40 usbgentoo kernel:  __writeback_single_inode+0x2a1/0x340
Mar 20 21:06:40 usbgentoo kernel:  ? soft_cursor+0x1b4/0x220
Mar 20 21:06:40 usbgentoo kernel:  writeback_sb_inodes+0x1d5/0x3e0
Mar 20 21:06:40 usbgentoo kernel:  __writeback_inodes_wb+0x58/0xa0
Mar 20 21:06:40 usbgentoo kernel:  wb_writeback+0x250/0x2e0
Mar 20 21:06:40 usbgentoo kernel:  ? 0xffffffff8c000000
Mar 20 21:06:40 usbgentoo kernel:  ? cpumask_next+0x16/0x20
Mar 20 21:06:40 usbgentoo kernel:  wb_workfn+0x2f6/0x3b0
Mar 20 21:06:40 usbgentoo kernel:  ? __switch_to_asm+0x40/0x70
Mar 20 21:06:40 usbgentoo kernel:  process_one_work+0x1f5/0x3f0
Mar 20 21:06:40 usbgentoo kernel:  worker_thread+0x28/0x3c0
Mar 20 21:06:40 usbgentoo kernel:  ? rescuer_thread+0x330/0x330
Mar 20 21:06:40 usbgentoo kernel:  kthread+0x10e/0x130
Mar 20 21:06:40 usbgentoo kernel:  ? kthread_create_on_node+0x60/0x60
Mar 20 21:06:40 usbgentoo kernel:  ret_from_fork+0x35/0x40

The root cause is that we run into an infinite recursive calling in
between f2fs_balance_fs_bg and writepage() as described below:

- f2fs_write_data_pages		--- A
 - __write_data_page
  - f2fs_balance_fs
   - f2fs_balance_fs_bg		--- B
    - f2fs_sync_dirty_inodes
     - filemap_fdatawrite
      - f2fs_write_data_pages	--- A
...
          - f2fs_balance_fs_bg	--- B
...

In order to fix this issue, let's detect such condition in __write_data_page()
and just skip calling f2fs_balance_fs() recursively.

Reported-by: Hagbard Celine <hagbardcelin@gmail.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 6 ++----
 fs/f2fs/data.c       | 3 ++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index a98e1b02279e..935ebdb9cf47 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1009,13 +1009,11 @@ retry:
 	if (inode) {
 		unsigned long cur_ino = inode->i_ino;
 
-		if (is_dir)
-			F2FS_I(inode)->cp_task = current;
+		F2FS_I(inode)->cp_task = current;
 
 		filemap_fdatawrite(inode->i_mapping);
 
-		if (is_dir)
-			F2FS_I(inode)->cp_task = NULL;
+		F2FS_I(inode)->cp_task = NULL;
 
 		iput(inode);
 		/* We need to give cpu to another writers. */
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d87dfa5aa112..9d3c11e09a03 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2038,7 +2038,8 @@ out:
 	}
 
 	unlock_page(page);
-	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode))
+	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
+					!F2FS_I(inode)->cp_task)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
-- 
2.20.1



