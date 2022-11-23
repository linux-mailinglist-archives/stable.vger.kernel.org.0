Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5198563586F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbiKWJ50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiKWJ4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:56:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0361BE86
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39726B81EF3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A136BC433C1;
        Wed, 23 Nov 2022 09:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197087;
        bh=EtWEte110S74mdIMehHy8unJmOtPf/aahiqpujklPsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSRRYAi/YvCQ+oM6caUVFn+YaCena1dknyli21gOeoWzVQN4iAVZ9Cpp4REAnSgjA
         nQfG7JKdQKHUrkXIS04xK4qAbBQYM39EiPMKl0exi2KbIPE72fRH4OdQ9S82Hq6Z7p
         LxuR2ixzqBzMH6oG4x3N02C9BNaGkliMJIoofcO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 194/314] block: make dma_alignment a stacking queue_limit
Date:   Wed, 23 Nov 2022 09:50:39 +0100
Message-Id: <20221123084634.338028118@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c964d62f5cab7b43dd0534f22a96eab386c6ec5d ]

Device mappers had always been getting the default 511 dma mask, but
the underlying device might have a larger alignment requirement. Since
this value is used to determine alloweable direct-io alignment, this
needs to be a stackable limit.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221110184501.2451620-2-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 86e4d3e8d183 ("dm-crypt: provide dma_alignment limit in io_hints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c       |  1 -
 block/blk-settings.c   |  8 +++++---
 include/linux/blkdev.h | 15 ++++++++-------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 651057c4146b..2fbdf17f2206 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -426,7 +426,6 @@ struct request_queue *blk_alloc_queue(int node_id, bool alloc_srcu)
 				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
 		goto fail_stats;
 
-	blk_queue_dma_alignment(q, 511);
 	blk_set_default_limits(&q->limits);
 	q->nr_requests = BLKDEV_DEFAULT_RQ;
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8bb9eef5310e..4949ed3ce7c9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -57,6 +57,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
+	lim->dma_alignment = 511;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -600,6 +601,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
+	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
 
 	/* Set non-power-of-2 compatible chunk_sectors boundary */
 	if (b->chunk_sectors)
@@ -773,7 +775,7 @@ EXPORT_SYMBOL(blk_queue_virt_boundary);
  **/
 void blk_queue_dma_alignment(struct request_queue *q, int mask)
 {
-	q->dma_alignment = mask;
+	q->limits.dma_alignment = mask;
 }
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 
@@ -795,8 +797,8 @@ void blk_queue_update_dma_alignment(struct request_queue *q, int mask)
 {
 	BUG_ON(mask > PAGE_SIZE);
 
-	if (mask > q->dma_alignment)
-		q->dma_alignment = mask;
+	if (mask > q->limits.dma_alignment)
+		q->limits.dma_alignment = mask;
 }
 EXPORT_SYMBOL(blk_queue_update_dma_alignment);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b13fdd34a7..79624711fda7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -311,6 +311,13 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
+
+	/*
+	 * Drivers that set dma_alignment to less than 511 must be prepared to
+	 * handle individual bvec's that are not a multiple of a SECTOR_SIZE
+	 * due to possible offsets.
+	 */
+	unsigned int		dma_alignment;
 };
 
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
@@ -456,12 +463,6 @@ struct request_queue {
 	unsigned long		nr_requests;	/* Max # of requests */
 
 	unsigned int		dma_pad_mask;
-	/*
-	 * Drivers that set dma_alignment to less than 511 must be prepared to
-	 * handle individual bvec's that are not a multiple of a SECTOR_SIZE
-	 * due to possible offsets.
-	 */
-	unsigned int		dma_alignment;
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct blk_crypto_profile *crypto_profile;
@@ -1311,7 +1312,7 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
-	return q ? q->dma_alignment : 511;
+	return q ? q->limits.dma_alignment : 511;
 }
 
 static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
-- 
2.35.1



