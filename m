Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7681EF85
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbfEOLbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732904AbfEOLbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64B8D206BF;
        Wed, 15 May 2019 11:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919899;
        bh=5+tZVK5k6ZBOA+SFlbpZWDP69vDwGPROBIcoj7L1uPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOyysHrT9XjdLyW4MfSUFWbLGsUJwDf5BY3mFzFNiJAKYMs5N/iZrCnF949AKZLbC
         V/QUiIW09vWpN2xcw95Sz2QOcGZiqoWE27cHDFmVF9bKoQ05Zsga/AhSU95VoQdsSZ
         kR7D8pgi01f6P4mu/KXyFdnObzTaLLjL/AKUu0O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.0 137/137] f2fs: Fix use of number of devices
Date:   Wed, 15 May 2019 12:56:58 +0200
Message-Id: <20190515090703.797875513@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 0916878da355650d7e77104a7ac0fa1784eca852 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/data.c    |   17 +++++++++++------
 fs/f2fs/f2fs.h    |   13 ++++++++++++-
 fs/f2fs/file.c    |    2 +-
 fs/f2fs/gc.c      |    2 +-
 fs/f2fs/segment.c |   13 +++++++------
 5 files changed, 32 insertions(+), 15 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -218,12 +218,14 @@ struct block_device *f2fs_target_device(
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
@@ -237,6 +239,9 @@ int f2fs_target_device_index(struct f2fs
 {
 	int i;
 
+	if (!f2fs_is_multi_device(sbi))
+		return 0;
+
 	for (i = 0; i < sbi->s_ndevs; i++)
 		if (FDEV(i).start_blk <= blkaddr && FDEV(i).end_blk >= blkaddr)
 			return i;
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1364,6 +1364,17 @@ static inline bool time_to_inject(struct
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
@@ -3612,7 +3623,7 @@ static inline bool f2fs_force_buffered_i
 
 	if (f2fs_post_read_required(inode))
 		return true;
-	if (sbi->s_ndevs)
+	if (f2fs_is_multi_device(sbi))
 		return true;
 	/*
 	 * for blkzoned device, fallback direct IO to buffered IO, so
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2570,7 +2570,7 @@ static int f2fs_ioc_flush_device(struct
 							sizeof(range)))
 		return -EFAULT;
 
-	if (sbi->s_ndevs <= 1 || sbi->s_ndevs - 1 <= range.dev_num ||
+	if (!f2fs_is_multi_device(sbi) || sbi->s_ndevs - 1 <= range.dev_num ||
 			__is_large_section(sbi)) {
 		f2fs_msg(sbi->sb, KERN_WARNING,
 			"Can't flush %u in %d for segs_per_sec %u != 1\n",
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1346,7 +1346,7 @@ void f2fs_build_gc_manager(struct f2fs_s
 	sbi->gc_pin_file_threshold = DEF_GC_FAILED_PINNED_FILES;
 
 	/* give warm/cold data area from slower device */
-	if (sbi->s_ndevs && !__is_large_section(sbi))
+	if (f2fs_is_multi_device(sbi) && !__is_large_section(sbi))
 		SIT_I(sbi)->last_victim[ALLOC_NEXT] =
 				GET_SEGNO(sbi, FDEV(0).end_blk) + 1;
 }
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -576,7 +576,7 @@ static int submit_flush_wait(struct f2fs
 	int ret = 0;
 	int i;
 
-	if (!sbi->s_ndevs)
+	if (!f2fs_is_multi_device(sbi))
 		return __submit_flush_wait(sbi, sbi->sb->s_bdev);
 
 	for (i = 0; i < sbi->s_ndevs; i++) {
@@ -644,7 +644,8 @@ int f2fs_issue_flush(struct f2fs_sb_info
 		return ret;
 	}
 
-	if (atomic_inc_return(&fcc->queued_flush) == 1 || sbi->s_ndevs > 1) {
+	if (atomic_inc_return(&fcc->queued_flush) == 1 ||
+	    f2fs_is_multi_device(sbi)) {
 		ret = submit_flush_wait(sbi, ino);
 		atomic_dec(&fcc->queued_flush);
 
@@ -750,7 +751,7 @@ int f2fs_flush_device_cache(struct f2fs_
 {
 	int ret = 0, i;
 
-	if (!sbi->s_ndevs)
+	if (!f2fs_is_multi_device(sbi))
 		return 0;
 
 	for (i = 1; i < sbi->s_ndevs; i++) {
@@ -1359,7 +1360,7 @@ static int __queue_discard_cmd(struct f2
 
 	trace_f2fs_queue_discard(bdev, blkstart, blklen);
 
-	if (sbi->s_ndevs) {
+	if (f2fs_is_multi_device(sbi)) {
 		int devi = f2fs_target_device_index(sbi, blkstart);
 
 		blkstart -= FDEV(devi).start_blk;
@@ -1714,7 +1715,7 @@ static int __f2fs_issue_discard_zone(str
 	block_t lblkstart = blkstart;
 	int devi = 0;
 
-	if (sbi->s_ndevs) {
+	if (f2fs_is_multi_device(sbi)) {
 		devi = f2fs_target_device_index(sbi, blkstart);
 		blkstart -= FDEV(devi).start_blk;
 	}
@@ -3071,7 +3072,7 @@ static void update_device_state(struct f
 	struct f2fs_sb_info *sbi = fio->sbi;
 	unsigned int devidx;
 
-	if (!sbi->s_ndevs)
+	if (!f2fs_is_multi_device(sbi))
 		return;
 
 	devidx = f2fs_target_device_index(sbi, fio->new_blkaddr);


