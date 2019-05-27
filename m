Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0395A2AE72
	for <lists+stable@lfdr.de>; Mon, 27 May 2019 08:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfE0GRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 02:17:20 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44059 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfE0GRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 02:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1558937840; x=1590473840;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pOJ3/T0shzbdDbuIZNzFVwGe9sMZ7wyJYAi2Lv5hTNg=;
  b=DjhqDsfvIzbL57wYTYLo9g2zEU4EBnmGgJMhEL1jjvxOPF/61Blo20aY
   Fm9R3e2RW9IKxMFjLk2f9yJ3QCoy8/1Zl21z03HdRMPvxfvAw0bHPGx23
   enwynclzratbVLtFaSK9WMPtkb6j+2A2SF9tlQTFtBnSSQgeogHoWwRzg
   TtEwA/Ipyi2BHex+zj49U9xUOSbgYU8maJ09WPKohupZ10aLBf5Q6ZwbU
   u6RqXU6tO7dTviulLQAuCtrYmwL++Sa6e3OGNfbJgACvhIbEkWmezlgP/
   HYwTBwzLxvRTTCYDVqnnBoziKfiUJF8mFfjtH6BC3tGKMcY9TZfjqZj3d
   A==;
X-IronPort-AV: E=Sophos;i="5.60,518,1549900800"; 
   d="scan'208";a="110392730"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2019 14:17:20 +0800
IronPort-SDR: 75RUH1PDQXHKLoYIMYsIbH0nPM0vYXo/wYZV81NcrUtvy9QX07u+DrTYRWANWj4jaXdHkiI8j1
 PTh0ECBtcbl4Rp8lC/ypPYQWelFQrNrI1cT40vP1WApXbfVxdts1upuZlxRrhmZPlDEjaTRGA/
 4I3pIDACLYCx/3jh0dhh+j1t22m2PfhPzK1RSj2TAKGuL4sCUKs7v5uT1P6Tq5CPachj++Gegb
 kg8eduFLr0PLzEiGLZFCp+Gk9TRCiMe8ddfEzsdWK3GO2bbbdSqvdRcx4wv6l3ebycrbXkw5AQ
 chUxcwvm7KbMEhPZzTjnEacE
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 26 May 2019 22:54:55 -0700
IronPort-SDR: du80PQdqlSNJ99MK0jzERJs6d3j6a9ezktha5dlv2kXSAYYUNeNvy9E+VobLgHX0avK+lzXdu1
 4KoDBcnuJYprS56zYYkdqOXlWrjGEPLa+FFCb7TQQ9TvLKN0T82IkCBIpUhoiTPwAg3jO2Neh4
 jqkEvJH6XUNT1/4EIcnlw4IBqTDYaTAwAU+JANonkJQIvT+ZMyvZA7iI/taynQdVpJ1Wc4rcmf
 Dsi+DdwU0AKMjYIyreHkV8BvXbp56WLaiOEJX/njfQedEbCN+vmhVaplsHIhUuAm2ISzqGdf0g
 5bE=
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 May 2019 23:17:19 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: Fix use of number of devices
Date:   Mon, 27 May 2019 15:17:16 +0900
Message-Id: <20190527061717.3202-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0916878da355650d7e77104a7ac0fa1784eca852 upstream.
Backport for 4.14.y stable tree.

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
Cc: <stable@vger.kernel.org> #4.14.y
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    | 17 +++++++++++------
 fs/f2fs/f2fs.h    | 11 +++++++++++
 fs/f2fs/file.c    |  2 +-
 fs/f2fs/gc.c      |  2 +-
 fs/f2fs/segment.c |  6 +++---
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3d37124eb63e..113d1cd55119 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -133,12 +133,14 @@ struct block_device *f2fs_target_device(struct f2fs_sb_info *sbi,
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
@@ -152,6 +154,9 @@ int f2fs_target_device_index(struct f2fs_sb_info *sbi, block_t blkaddr)
 {
 	int i;
 
+	if (!f2fs_is_multi_device(sbi))
+		return 0;
+
 	for (i = 0; i < sbi->s_ndevs; i++)
 		if (FDEV(i).start_blk <= blkaddr && FDEV(i).end_blk >= blkaddr)
 			return i;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 634165fb64f1..406d93b51a0b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1167,6 +1167,17 @@ static inline bool time_to_inject(struct f2fs_sb_info *sbi, int type)
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
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5f549bc4e097..1b1792199445 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2407,7 +2407,7 @@ static int f2fs_ioc_flush_device(struct file *filp, unsigned long arg)
 							sizeof(range)))
 		return -EFAULT;
 
-	if (sbi->s_ndevs <= 1 || sbi->s_ndevs - 1 <= range.dev_num ||
+	if (!f2fs_is_multi_device(sbi) || sbi->s_ndevs - 1 <= range.dev_num ||
 			sbi->segs_per_sec != 1) {
 		f2fs_msg(sbi->sb, KERN_WARNING,
 			"Can't flush %u in %d for segs_per_sec %u != 1\n",
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index f22884418e92..ceb6023786bd 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1111,7 +1111,7 @@ void build_gc_manager(struct f2fs_sb_info *sbi)
 				BLKS_PER_SEC(sbi), (main_count - resv_count));
 
 	/* give warm/cold data area from slower device */
-	if (sbi->s_ndevs && sbi->segs_per_sec == 1)
+	if (f2fs_is_multi_device(sbi) && sbi->segs_per_sec == 1)
 		SIT_I(sbi)->last_victim[ALLOC_NEXT] =
 				GET_SEGNO(sbi, FDEV(0).end_blk) + 1;
 }
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 5c698757e116..70bd15cadb44 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -495,7 +495,7 @@ static int submit_flush_wait(struct f2fs_sb_info *sbi)
 	int ret = __submit_flush_wait(sbi, sbi->sb->s_bdev);
 	int i;
 
-	if (!sbi->s_ndevs || ret)
+	if (!f2fs_is_multi_device(sbi) || ret)
 		return ret;
 
 	for (i = 1; i < sbi->s_ndevs; i++) {
@@ -1050,7 +1050,7 @@ static int __queue_discard_cmd(struct f2fs_sb_info *sbi,
 
 	trace_f2fs_queue_discard(bdev, blkstart, blklen);
 
-	if (sbi->s_ndevs) {
+	if (f2fs_is_multi_device(sbi)) {
 		int devi = f2fs_target_device_index(sbi, blkstart);
 
 		blkstart -= FDEV(devi).start_blk;
@@ -1283,7 +1283,7 @@ static int __f2fs_issue_discard_zone(struct f2fs_sb_info *sbi,
 	block_t lblkstart = blkstart;
 	int devi = 0;
 
-	if (sbi->s_ndevs) {
+	if (f2fs_is_multi_device(sbi)) {
 		devi = f2fs_target_device_index(sbi, blkstart);
 		blkstart -= FDEV(devi).start_blk;
 	}
-- 
2.21.0

