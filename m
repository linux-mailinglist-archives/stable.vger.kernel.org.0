Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BEC1EA40
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 10:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfEOIhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 04:37:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54769 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbfEOIhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 04:37:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D2CAC2469A;
        Wed, 15 May 2019 04:37:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 15 May 2019 04:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=F0vMys
        9jNbb4EiMvDQUCsWdo4sEEjeiDKyI2gpv1MbY=; b=V+hF6QDscgNm0nBpjnFwde
        YVTIWB3itsF/tG3ZZWA+kYghkT9VALds5HaOVs63BFoyXGoITeaHnlwmm85GT6/6
        alp6qYIAC3has0hQeQ3ynsRfKAPWZik6YOD4Xqee8yzOYTl3DHzHVeWpy/iNAWcm
        fphLsemMkABgzKhM56413pgVV7T3RYRZDa44M/xjhZPwD6qiOlSQBxH32bdiSLKW
        GpREaM+pN7XOnXjdZNzq+a6gCCYUfj3y5JXV3quV5HWG8nQ4HeNARCKQJ8SuQGB/
        wP2B4G+/B/47Nujh+Ao0RPZ+nzBjAkqhQXu19sPcAuZfb9BKwaueUCgV+XdV4qrw
        ==
X-ME-Sender: <xms:v8_bXNEKn7CmNNFSn_k-F-ESS9SJkvU1lTumC1tDMyVWwmxKuMhvUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleekgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:v8_bXLTe4TcH93KNgelF2RcJ5YRpPcS5Gg8ejopnnPPi44jSnXq7iA>
    <xmx:v8_bXBF2ybyLcMAUw22AWUGHmGivS-oBd1HbheSSVo9IaPTR9HgvhQ>
    <xmx:v8_bXP89G9PxdjrZao3ExtPuO3P0USAV_mzcsPUtoo9U0Lzbib5O-g>
    <xmx:v8_bXHAxaHfKCpFsi32xsbDcLVS5l3G4n2KB4LN2SQc9r1H-NWnGtg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9B7880066;
        Wed, 15 May 2019 04:37:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: Fix use of number of devices" failed to apply to 4.14-stable tree
To:     damien.lemoal@wdc.com, jaegeuk@kernel.org, stable@vger.kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 May 2019 10:37:17 +0200
Message-ID: <155790943718636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 0916878da355650d7e77104a7ac0fa1784eca852 Mon Sep 17 00:00:00 2001
From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Sat, 16 Mar 2019 09:13:06 +0900
Subject: [PATCH] f2fs: Fix use of number of devices

For a single device mount using a zoned block device, the zone
information for the device is stored in the sbi->devs single entry
array and sbi->s_ndevs is set to 1. This differs from a single device
mount using a regular block device which does not allocate sbi->devs
and sets sbi->s_ndevs to 0.

However, sbi->s_devs == 0 condition is used throughout the code to
differentiate a single device mount from a multi-device mount where
sbi->s_ndevs is always larger than 1. This results in problems with
single zoned block device volumes as these are treated as multi-device
mounts but do not have the start_blk and end_blk information set. One
of the problem observed is skipping of zone discard issuing resulting in
write commands being issued to full zones or unaligned to a zone write
pointer.

Fix this problem by simply treating the cases sbi->s_ndevs == 0 (single
regular block device mount) and sbi->s_ndevs == 1 (single zoned block
device mount) in the same manner. This is done by introducing the
helper function f2fs_is_multi_device() and using this helper in place
of direct tests of sbi->s_ndevs value, improving code readability.

Fixes: 7bb3a371d199 ("f2fs: Fix zoned block device support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9727944139f2..d87dfa5aa112 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -220,12 +220,14 @@ struct block_device *f2fs_target_device(struct f2fs_sb_info *sbi,
 	struct block_device *bdev = sbi->sb->s_bdev;
 	int i;
 
-	for (i = 0; i < sbi->s_ndevs; i++) {
-		if (FDEV(i).start_blk <= blk_addr &&
-					FDEV(i).end_blk >= blk_addr) {
-			blk_addr -= FDEV(i).start_blk;
-			bdev = FDEV(i).bdev;
-			break;
+	if (f2fs_is_multi_device(sbi)) {
+		for (i = 0; i < sbi->s_ndevs; i++) {
+			if (FDEV(i).start_blk <= blk_addr &&
+			    FDEV(i).end_blk >= blk_addr) {
+				blk_addr -= FDEV(i).start_blk;
+				bdev = FDEV(i).bdev;
+				break;
+			}
 		}
 	}
 	if (bio) {
@@ -239,6 +241,9 @@ int f2fs_target_device_index(struct f2fs_sb_info *sbi, block_t blkaddr)
 {
 	int i;
 
+	if (!f2fs_is_multi_device(sbi))
+		return 0;
+
 	for (i = 0; i < sbi->s_ndevs; i++)
 		if (FDEV(i).start_blk <= blkaddr && FDEV(i).end_blk >= blkaddr)
 			return i;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 87f75ebd2fd6..7bea1bc6589f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1366,6 +1366,17 @@ static inline bool time_to_inject(struct f2fs_sb_info *sbi, int type)
 }
 #endif
 
+/*
+ * Test if the mounted volume is a multi-device volume.
+ *   - For a single regular disk volume, sbi->s_ndevs is 0.
+ *   - For a single zoned disk volume, sbi->s_ndevs is 1.
+ *   - For a multi-device volume, sbi->s_ndevs is always 2 or more.
+ */
+static inline bool f2fs_is_multi_device(struct f2fs_sb_info *sbi)
+{
+	return sbi->s_ndevs > 1;
+}
+
 /* For write statistics. Suppose sector size is 512 bytes,
  * and the return value is in kbytes. s is of struct f2fs_sb_info.
  */
@@ -3615,7 +3626,7 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 
 	if (f2fs_post_read_required(inode))
 		return true;
-	if (sbi->s_ndevs)
+	if (f2fs_is_multi_device(sbi))
 		return true;
 	/*
 	 * for blkzoned device, fallback direct IO to buffered IO, so
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5742ab8b57dc..30d49467578e 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2573,7 +2573,7 @@ static int f2fs_ioc_flush_device(struct file *filp, unsigned long arg)
 							sizeof(range)))
 		return -EFAULT;
 
-	if (sbi->s_ndevs <= 1 || sbi->s_ndevs - 1 <= range.dev_num ||
+	if (!f2fs_is_multi_device(sbi) || sbi->s_ndevs - 1 <= range.dev_num ||
 			__is_large_section(sbi)) {
 		f2fs_msg(sbi->sb, KERN_WARNING,
 			"Can't flush %u in %d for segs_per_sec %u != 1\n",
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 195cf0f9d9ef..ab764bd106de 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1346,7 +1346,7 @@ void f2fs_build_gc_manager(struct f2fs_sb_info *sbi)
 	sbi->gc_pin_file_threshold = DEF_GC_FAILED_PINNED_FILES;
 
 	/* give warm/cold data area from slower device */
-	if (sbi->s_ndevs && !__is_large_section(sbi))
+	if (f2fs_is_multi_device(sbi) && !__is_large_section(sbi))
 		SIT_I(sbi)->last_victim[ALLOC_NEXT] =
 				GET_SEGNO(sbi, FDEV(0).end_blk) + 1;
 }
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index aa7fe79b62b2..ddfa2eb7ec58 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -580,7 +580,7 @@ static int submit_flush_wait(struct f2fs_sb_info *sbi, nid_t ino)
 	int ret = 0;
 	int i;
 
-	if (!sbi->s_ndevs)
+	if (!f2fs_is_multi_device(sbi))
 		return __submit_flush_wait(sbi, sbi->sb->s_bdev);
 
 	for (i = 0; i < sbi->s_ndevs; i++) {
@@ -648,7 +648,8 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi, nid_t ino)
 		return ret;
 	}
 
-	if (atomic_inc_return(&fcc->queued_flush) == 1 || sbi->s_ndevs > 1) {
+	if (atomic_inc_return(&fcc->queued_flush) == 1 ||
+	    f2fs_is_multi_device(sbi)) {
 		ret = submit_flush_wait(sbi, ino);
 		atomic_dec(&fcc->queued_flush);
 
@@ -754,7 +755,7 @@ int f2fs_flush_device_cache(struct f2fs_sb_info *sbi)
 {
 	int ret = 0, i;
 
-	if (!sbi->s_ndevs)
+	if (!f2fs_is_multi_device(sbi))
 		return 0;
 
 	for (i = 1; i < sbi->s_ndevs; i++) {
@@ -1369,7 +1370,7 @@ static int __queue_discard_cmd(struct f2fs_sb_info *sbi,
 
 	trace_f2fs_queue_discard(bdev, blkstart, blklen);
 
-	if (sbi->s_ndevs) {
+	if (f2fs_is_multi_device(sbi)) {
 		int devi = f2fs_target_device_index(sbi, blkstart);
 
 		blkstart -= FDEV(devi).start_blk;
@@ -1732,7 +1733,7 @@ static int __f2fs_issue_discard_zone(struct f2fs_sb_info *sbi,
 	block_t lblkstart = blkstart;
 	int devi = 0;
 
-	if (sbi->s_ndevs) {
+	if (f2fs_is_multi_device(sbi)) {
 		devi = f2fs_target_device_index(sbi, blkstart);
 		blkstart -= FDEV(devi).start_blk;
 	}
@@ -3089,7 +3090,7 @@ static void update_device_state(struct f2fs_io_info *fio)
 	struct f2fs_sb_info *sbi = fio->sbi;
 	unsigned int devidx;
 
-	if (!sbi->s_ndevs)
+	if (!f2fs_is_multi_device(sbi))
 		return;
 
 	devidx = f2fs_target_device_index(sbi, fio->new_blkaddr);

