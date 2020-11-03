Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3C2A52AD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgKCUwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732033AbgKCUwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15B8D2071E;
        Tue,  3 Nov 2020 20:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436724;
        bh=qel/IkwRvO6XCYXxbcDTBAZGsaf0ynC01QjhCLa9Pxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=feT9GuMeXHBNWY1DGYwf9451evkE3OY5AVfceaf5ofJErxeShmKLcwUQ6BqT2TXwZ
         4bmhZlMOKhalPsSKXSnl21Ko7CdPVcXTVV4olpV+bWyRLeZZynogoUWdA3hHB8rk1v
         rF7meHGyn8nmx8bNCK38EBWBLAlIqEJDY2/njZcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 374/391] null_blk: synchronization fix for zoned device
Date:   Tue,  3 Nov 2020 21:37:05 +0100
Message-Id: <20201103203412.385651316@linuxfoundation.org>
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

From: Kanchan Joshi <joshi.k@samsung.com>

commit 35bc10b2eafbb701064b94f283b77c54d3304842 upstream.

Parallel write,read,zone-mgmt operations accessing/altering zone state
and write-pointer may get into race. Avoid the situation by using a new
spinlock for zoned device.
Concurrent zone-appends (on a zone) returning same write-pointer issue
is also avoided using this lock.

Cc: stable@vger.kernel.org
Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/null_blk.h       |    1 +
 drivers/block/null_blk_zoned.c |   22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -44,6 +44,7 @@ struct nullb_device {
 	unsigned int nr_zones;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
+	spinlock_t zone_lock;
 
 	unsigned long size; /* device size in MB */
 	unsigned long completion_nsec; /* time in ns to complete a request */
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -45,6 +45,7 @@ int null_init_zoned_dev(struct nullb_dev
 	if (!dev->zones)
 		return -ENOMEM;
 
+	spin_lock_init(&dev->zone_lock);
 	if (dev->zone_nr_conv >= dev->nr_zones) {
 		dev->zone_nr_conv = dev->nr_zones - 1;
 		pr_info("changed the number of conventional zones to %u",
@@ -131,8 +132,11 @@ int null_report_zones(struct gendisk *di
 		 * So use a local copy to avoid corruption of the device zone
 		 * array.
 		 */
+		spin_lock_irq(&dev->zone_lock);
 		memcpy(&zone, &dev->zones[first_zone + i],
 		       sizeof(struct blk_zone));
+		spin_unlock_irq(&dev->zone_lock);
+
 		error = cb(&zone, i, data);
 		if (error)
 			return error;
@@ -277,18 +281,28 @@ static blk_status_t null_zone_mgmt(struc
 blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
 				    sector_t sector, sector_t nr_sectors)
 {
+	blk_status_t sts;
+	struct nullb_device *dev = cmd->nq->dev;
+
+	spin_lock_irq(&dev->zone_lock);
 	switch (op) {
 	case REQ_OP_WRITE:
-		return null_zone_write(cmd, sector, nr_sectors, false);
+		sts = null_zone_write(cmd, sector, nr_sectors, false);
+		break;
 	case REQ_OP_ZONE_APPEND:
-		return null_zone_write(cmd, sector, nr_sectors, true);
+		sts = null_zone_write(cmd, sector, nr_sectors, true);
+		break;
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		return null_zone_mgmt(cmd, op, sector);
+		sts = null_zone_mgmt(cmd, op, sector);
+		break;
 	default:
-		return null_process_cmd(cmd, op, sector, nr_sectors);
+		sts = null_process_cmd(cmd, op, sector, nr_sectors);
 	}
+	spin_unlock_irq(&dev->zone_lock);
+
+	return sts;
 }


