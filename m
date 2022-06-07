Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4F754050E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345801AbiFGRVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346025AbiFGRUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:20:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5D6104CB2;
        Tue,  7 Jun 2022 10:20:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 400A6615D1;
        Tue,  7 Jun 2022 17:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCDFC385A5;
        Tue,  7 Jun 2022 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622405;
        bh=OiI0PmsJtqps+PkFB0TqTuCxhpCe5p17/wJXmiP1MZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+BjwnFj2++/cxyL+G6Wktw053jTORpccEeETDvH7ZtFjoCw60UOT1FibbM3SZuU8
         luKfzk4gs7lTFiy8++KyxR5MTTGU7FzG+m9XU/Z+CkpvPrnyXAVNuD+bYghOScgBTL
         LoS/mINTmkBAvMs0VWyJ/qT8CMcb7xJ8p1994XU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heming Zhao <heming.zhao@suse.com>, Song Liu <song@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/452] md/bitmap: dont set sb values if cant pass sanity check
Date:   Tue,  7 Jun 2022 18:58:24 +0200
Message-Id: <20220607164909.950864898@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit e68cb83a57a458b01c9739e2ad9cb70b04d1e6d2 ]

If bitmap area contains invalid data, kernel will crash then mdadm
triggers "Segmentation fault".
This is cluster-md speical bug. In non-clustered env, mdadm will
handle broken metadata case. In clustered array, only kernel space
handles bitmap slot info. But even this bug only happened in clustered
env, current sanity check is wrong, the code should be changed.

How to trigger: (faulty injection)

dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sda
dd if=/dev/zero bs=1M count=1 oflag=direct of=/dev/sdb
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm -Ss
echo aaa > magic.txt
 == below modifying slot 2 bitmap data ==
dd if=magic.txt of=/dev/sda seek=16384 bs=1 count=3 <== destroy magic
dd if=/dev/zero of=/dev/sda seek=16436 bs=1 count=4 <== ZERO chunksize
mdadm -A /dev/md0 /dev/sda /dev/sdb
 == kernel crashes. mdadm outputs "Segmentation fault" ==

Reason of kernel crash:

In md_bitmap_read_sb (called by md_bitmap_create), bad bitmap magic didn't
block chunksize assignment, and zero value made DIV_ROUND_UP_SECTOR_T()
trigger "divide error".

Crash log:

kernel: md: md0 stopped.
kernel: md/raid1:md0: not clean -- starting background reconstruction
kernel: md/raid1:md0: active with 2 out of 2 mirrors
kernel: dlm: ... ...
kernel: md-cluster: Joined cluster 44810aba-38bb-e6b8-daca-bc97a0b254aa slot 1
kernel: md0: invalid bitmap file superblock: bad magic
kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
kernel: md-cluster: Could not gather bitmaps from slot 2
kernel: divide error: 0000 [#1] SMP NOPTI
kernel: CPU: 0 PID: 1603 Comm: mdadm Not tainted 5.14.6-1-default
kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
kernel: RSP: 0018:ffffc22ac0843ba0 EFLAGS: 00010246
kernel: ... ...
kernel: Call Trace:
kernel:  ? dlm_lock_sync+0xd0/0xd0 [md_cluster 77fe..7a0]
kernel:  md_bitmap_copy_from_slot+0x2c/0x290 [md_mod 24ea..d3a]
kernel:  load_bitmaps+0xec/0x210 [md_cluster 77fe..7a0]
kernel:  md_bitmap_load+0x81/0x1e0 [md_mod 24ea..d3a]
kernel:  do_md_run+0x30/0x100 [md_mod 24ea..d3a]
kernel:  md_ioctl+0x1290/0x15a0 [md_mod 24ea....d3a]
kernel:  ? mddev_unlock+0xaa/0x130 [md_mod 24ea..d3a]
kernel:  ? blkdev_ioctl+0xb1/0x2b0
kernel:  block_ioctl+0x3b/0x40
kernel:  __x64_sys_ioctl+0x7f/0xb0
kernel:  do_syscall_64+0x59/0x80
kernel:  ? exit_to_user_mode_prepare+0x1ab/0x230
kernel:  ? syscall_exit_to_user_mode+0x18/0x40
kernel:  ? do_syscall_64+0x69/0x80
kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
kernel: RIP: 0033:0x7f4a15fa722b
kernel: ... ...
kernel: ---[ end trace 8afa7612f559c868 ]---
kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 44 ++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ea3130e11680..d377ea060925 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -639,14 +639,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
 	write_behind = le32_to_cpu(sb->write_behind);
 	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
-	/* Setup nodes/clustername only if bitmap version is
-	 * cluster-compatible
-	 */
-	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
-		nodes = le32_to_cpu(sb->nodes);
-		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
-				sb->cluster_name, 64);
-	}
 
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
@@ -668,6 +660,16 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto out;
 	}
 
+	/*
+	 * Setup nodes/clustername only if bitmap version is
+	 * cluster-compatible
+	 */
+	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
+		nodes = le32_to_cpu(sb->nodes);
+		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
+				sb->cluster_name, 64);
+	}
+
 	/* keep the array size field of the bitmap superblock up to date */
 	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
 
@@ -700,9 +702,9 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 
 out:
 	kunmap_atomic(sb);
-	/* Assigning chunksize is required for "re_read" */
-	bitmap->mddev->bitmap_info.chunksize = chunksize;
 	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
+		/* Assigning chunksize is required for "re_read" */
+		bitmap->mddev->bitmap_info.chunksize = chunksize;
 		err = md_setup_cluster(bitmap->mddev, nodes);
 		if (err) {
 			pr_warn("%s: Could not setup cluster service (%d)\n",
@@ -713,18 +715,18 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto re_read;
 	}
 
-
 out_no_sb:
-	if (test_bit(BITMAP_STALE, &bitmap->flags))
-		bitmap->events_cleared = bitmap->mddev->events;
-	bitmap->mddev->bitmap_info.chunksize = chunksize;
-	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
-	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
-	bitmap->mddev->bitmap_info.nodes = nodes;
-	if (bitmap->mddev->bitmap_info.space == 0 ||
-	    bitmap->mddev->bitmap_info.space > sectors_reserved)
-		bitmap->mddev->bitmap_info.space = sectors_reserved;
-	if (err) {
+	if (err == 0) {
+		if (test_bit(BITMAP_STALE, &bitmap->flags))
+			bitmap->events_cleared = bitmap->mddev->events;
+		bitmap->mddev->bitmap_info.chunksize = chunksize;
+		bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
+		bitmap->mddev->bitmap_info.max_write_behind = write_behind;
+		bitmap->mddev->bitmap_info.nodes = nodes;
+		if (bitmap->mddev->bitmap_info.space == 0 ||
+			bitmap->mddev->bitmap_info.space > sectors_reserved)
+			bitmap->mddev->bitmap_info.space = sectors_reserved;
+	} else {
 		md_bitmap_print_sb(bitmap);
 		if (bitmap->cluster_slot < 0)
 			md_cluster_stop(bitmap->mddev);
-- 
2.35.1



