Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDE073973
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbfGXTkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389592AbfGXTkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:40:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450C6214AF;
        Wed, 24 Jul 2019 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997212;
        bh=Bo/InIWzF2Z+oXTCu/zsd3Dkx6gyNsZ97JeFWHs8Bwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDRvVjMcaL7mYxM/lLOMC60o7vj1nTmKTfgs3ycsHm/V8rlkYrLDt3g4lX5GYM70u
         V1sgKu3kbfn1/JWPB9f3ytzy7JlwHaMN7oSATXRxAdXTgRAOm4uep1pZVDniqLC9gN
         srHZV+MVz4OTKz55sPCPwmZuFC2k29pRYwHqVC+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 360/413] block: Fix potential overflow in blk_report_zones()
Date:   Wed, 24 Jul 2019 21:20:51 +0200
Message-Id: <20190724191801.341984023@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
@@ -70,7 +70,7 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_u
 static inline unsigned int __blkdev_nr_zones(struct request_queue *q,
 					     sector_t nr_sectors)
 {
-	unsigned long zone_sectors = blk_queue_zone_sectors(q);
+	sector_t zone_sectors = blk_queue_zone_sectors(q);
 
 	return (nr_sectors + zone_sectors - 1) >> ilog2(zone_sectors);
 }
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -681,7 +681,7 @@ static inline bool blk_queue_is_zoned(st
 	}
 }
 
-static inline unsigned int blk_queue_zone_sectors(struct request_queue *q)
+static inline sector_t blk_queue_zone_sectors(struct request_queue *q)
 {
 	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
 }
@@ -1429,7 +1429,7 @@ static inline bool bdev_is_zoned(struct
 	return false;
 }
 
-static inline unsigned int bdev_zone_sectors(struct block_device *bdev)
+static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 


