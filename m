Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16ACD73CA3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404908AbfGXUKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405008AbfGXT6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:58:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD4F021873;
        Wed, 24 Jul 2019 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998330;
        bh=+l/JtDVZXE7La4+a5A8W23d/csoG77VgDQf98Ngqo68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkcyJyubaQ46EazFId6nUeGV1F/ngL0qr3mA7tm/p4Qzd7qTBgtESLkxys6q1pqU8
         /Mol3eOIqJBYgxmygh7HZJvFigZ4hoAyJ+LZKzeUrVYHvU1CBOWUO3xCS2QsuPE/Ph
         +6lKtPKrhsAJ65EEXFiK7OjNQz4+Lk7BgFZlTydU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.1 327/371] block: Fix potential overflow in blk_report_zones()
Date:   Wed, 24 Jul 2019 21:21:19 +0200
Message-Id: <20190724191748.443843713@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 113ab72ed4794c193509a97d7c6d32a6886e1682 upstream.

For large values of the number of zones reported and/or large zone
sizes, the sector increment calculated with

blk_queue_zone_sectors(q) * n

in blk_report_zones() loop can overflow the unsigned int type used for
the calculation as both "n" and blk_queue_zone_sectors() value are
unsigned int. E.g. for a device with 256 MB zones (524288 sectors),
overflow happens with 8192 or more zones reported.

Changing the return type of blk_queue_zone_sectors() to sector_t, fixes
this problem and avoids overflow problem for all other callers of this
helper too. The same change is also applied to the bdev_zone_sectors()
helper.

Fixes: e76239a3748c ("block: add a report_zones method")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-zoned.c      |    2 +-
 include/linux/blkdev.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -69,7 +69,7 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_u
 static inline unsigned int __blkdev_nr_zones(struct request_queue *q,
 					     sector_t nr_sectors)
 {
-	unsigned long zone_sectors = blk_queue_zone_sectors(q);
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
 
 	return (nr_sectors + zone_sectors - 1) >> ilog2(zone_sectors);
 }
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -662,7 +662,7 @@ static inline bool blk_queue_is_zoned(st
 	}
 }
 
-static inline unsigned int blk_queue_zone_sectors(struct request_queue *q)
+static inline sector_t blk_queue_zone_sectors(struct request_queue *q)
 {
 	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
 }
@@ -1400,7 +1400,7 @@ static inline bool bdev_is_zoned(struct
 	return false;
 }
 
-static inline unsigned int bdev_zone_sectors(struct block_device *bdev)
+static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 


