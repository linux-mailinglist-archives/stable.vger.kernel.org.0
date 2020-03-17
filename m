Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46E18810E
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgCQLMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgCQLMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:12:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1FD20735;
        Tue, 17 Mar 2020 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443529;
        bh=UWFV8+U9wMHUFK72MiBkyIfm7IytvMt4ap0HCa0loR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbN/+Bjx6ujMzh3rMaACpJobhu0Ci47IYaZng/9ep9pC2uot/+60fOV2WN6VRR2BY
         SepkRuUCxHp6mxXySmdJD3qxm9fTtBc9ExLu/7VTizAYjMoJ9h0Gw8S1MzXsV++c84
         EN5vTigq8oSRZrPEkrXFeTFwh1paUED7r0WBkruk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 095/151] block: Fix partition support for host aware zoned block devices
Date:   Tue, 17 Mar 2020 11:55:05 +0100
Message-Id: <20200317103333.201614552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit b53df2e7442c73a932fb74228147fb946e531585 upstream.

Commit b72053072c0b ("block: allow partitions on host aware zone
devices") introduced the helper function disk_has_partitions() to check
if a given disk has valid partitions. However, since this function result
directly depends on the disk partition table length rather than the
actual existence of valid partitions in the table, it returns true even
after all partitions are removed from the disk. For host aware zoned
block devices, this results in zone management support to be kept
disabled even after removing all partitions.

Fix this by changing disk_has_partitions() to walk through the partition
table entries and return true if and only if a valid non-zero size
partition is found.

Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
Cc: stable@vger.kernel.org # 5.5
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/block/genhd.c b/block/genhd.c
index ff6268970ddc..9c2e13ce0d19 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -301,6 +301,42 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 }
 EXPORT_SYMBOL_GPL(disk_map_sector_rcu);
 
+/**
+ * disk_has_partitions
+ * @disk: gendisk of interest
+ *
+ * Walk through the partition table and check if valid partition exists.
+ *
+ * CONTEXT:
+ * Don't care.
+ *
+ * RETURNS:
+ * True if the gendisk has at least one valid non-zero size partition.
+ * Otherwise false.
+ */
+bool disk_has_partitions(struct gendisk *disk)
+{
+	struct disk_part_tbl *ptbl;
+	int i;
+	bool ret = false;
+
+	rcu_read_lock();
+	ptbl = rcu_dereference(disk->part_tbl);
+
+	/* Iterate partitions skipping the whole device at index 0 */
+	for (i = 1; i < ptbl->len; i++) {
+		if (rcu_dereference(ptbl->part[i])) {
+			ret = true;
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(disk_has_partitions);
+
 /*
  * Can be deleted altogether. Later.
  *
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6fbe58538ad6..07dc91835b98 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -245,18 +245,6 @@ static inline bool disk_part_scan_enabled(struct gendisk *disk)
 		!(disk->flags & GENHD_FL_NO_PART_SCAN);
 }
 
-static inline bool disk_has_partitions(struct gendisk *disk)
-{
-	bool ret = false;
-
-	rcu_read_lock();
-	if (rcu_dereference(disk->part_tbl)->len > 1)
-		ret = true;
-	rcu_read_unlock();
-
-	return ret;
-}
-
 static inline dev_t disk_devt(struct gendisk *disk)
 {
 	return MKDEV(disk->major, disk->first_minor);
@@ -298,6 +286,7 @@ extern void disk_part_iter_exit(struct disk_part_iter *piter);
 
 extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 					     sector_t sector);
+bool disk_has_partitions(struct gendisk *disk);
 
 /*
  * Macros to operate on percpu disk statistics:


