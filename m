Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5FB2B63EB
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbgKQNmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732391AbgKQNmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DD48207BC;
        Tue, 17 Nov 2020 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620554;
        bh=3yvRMyzPZQ+0Tc7FTTr2JpOJiux30auAJEcJFZJKoEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBaN8BXBhFs5FzlSSun8s0oHbmSl22/fYXv+W+PMFx5wvqVCu39o0SzYS8ig3ygEu
         3sa3ewrSSlHui44X/KxLEcRnsud2/KfkSXEQZljFb2naILuoFeGqmmPTo8cIRrD5kK
         tqa85Lr3aoElPnrt9IJK+ZI1xER+rpzSdZsN4YxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 251/255] null_blk: Fix scheduling in atomic with zoned mode
Date:   Tue, 17 Nov 2020 14:06:31 +0100
Message-Id: <20201117122151.147477699@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit e1777d099728a76a8f8090f89649aac961e7e530 upstream.

Commit aa1c09cb65e2 ("null_blk: Fix locking in zoned mode") changed
zone locking to using the potentially sleeping wait_on_bit_io()
function. This is acceptable when memory backing is enabled as the
device queue is in that case marked as blocking, but this triggers a
scheduling while in atomic context with memory backing disabled.

Fix this by relying solely on the device zone spinlock for zone
information protection without temporarily releasing this lock around
null_process_cmd() execution in null_zone_write(). This is OK to do
since when memory backing is disabled, command processing does not
block and the memory backing lock nullb->lock is unused. This solution
avoids the overhead of having to mark a zoned null_blk device queue as
blocking when memory backing is unused.

This patch also adds comments to the zone locking code to explain the
unusual locking scheme.

Fixes: aa1c09cb65e2 ("null_blk: Fix locking in zoned mode")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/block/null_blk.h       |    1 +
 drivers/block/null_blk_zoned.c |   31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -44,6 +44,7 @@ struct nullb_device {
 	unsigned int nr_zones;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
+	spinlock_t zone_lock;
 	unsigned long *zone_locks;
 
 	unsigned long size; /* device size in MB */
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -46,10 +46,20 @@ int null_init_zoned_dev(struct nullb_dev
 	if (!dev->zones)
 		return -ENOMEM;
 
-	dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
-	if (!dev->zone_locks) {
-		kvfree(dev->zones);
-		return -ENOMEM;
+	/*
+	 * With memory backing, the zone_lock spinlock needs to be temporarily
+	 * released to avoid scheduling in atomic context. To guarantee zone
+	 * information protection, use a bitmap to lock zones with
+	 * wait_on_bit_lock_io(). Sleeping on the lock is OK as memory backing
+	 * implies that the queue is marked with BLK_MQ_F_BLOCKING.
+	 */
+	spin_lock_init(&dev->zone_lock);
+	if (dev->memory_backed) {
+		dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
+		if (!dev->zone_locks) {
+			kvfree(dev->zones);
+			return -ENOMEM;
+		}
 	}
 
 	if (dev->zone_nr_conv >= dev->nr_zones) {
@@ -118,12 +128,16 @@ void null_free_zoned_dev(struct nullb_de
 
 static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
 {
-	wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	if (dev->memory_backed)
+		wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	spin_lock_irq(&dev->zone_lock);
 }
 
 static inline void null_unlock_zone(struct nullb_device *dev, unsigned int zno)
 {
-	clear_and_wake_up_bit(zno, dev->zone_locks);
+	spin_unlock_irq(&dev->zone_lock);
+	if (dev->memory_backed)
+		clear_and_wake_up_bit(zno, dev->zone_locks);
 }
 
 int null_report_zones(struct gendisk *disk, sector_t sector,
@@ -233,7 +247,12 @@ static blk_status_t null_zone_write(stru
 		if (zone->cond != BLK_ZONE_COND_EXP_OPEN)
 			zone->cond = BLK_ZONE_COND_IMP_OPEN;
 
+		if (dev->memory_backed)
+			spin_unlock_irq(&dev->zone_lock);
 		ret = null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
+		if (dev->memory_backed)
+			spin_lock_irq(&dev->zone_lock);
+
 		if (ret != BLK_STS_OK)
 			break;
 


