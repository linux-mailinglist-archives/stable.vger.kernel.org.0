Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E66106141
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfKVFzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:55:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfKVFw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C5232068F;
        Fri, 22 Nov 2019 05:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401977;
        bh=AkmH7/23k2qjTXz17Saidwk9VDL7TkNqlVi282KJW4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnfRxW3Vw+L/z52IcCrpp/p5WO51yH3clAtrOLvbjOZ8j8TnLOAE2IRa1LuMeX9f0
         MfsFLTVa2W6nVKvhUsbsfdqcEJUj7SzhqYbOn0OwHDSCd14wocl8lL8RE/ouzMLj9E
         gUUjxJlj6ssTKVvQwNfZHjDCVIETmYE5vRoej29s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Christoph Hellwig <hch@lst.de>, Faiz Abbas <faiz_abbas@ti.com>,
        linux-block@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 196/219] mmc: core: align max segment size with logical block size
Date:   Fri, 22 Nov 2019 00:48:48 -0500
Message-Id: <20191122054911.1750-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c53336c8f5f29043fded57912cc06c24e12613d7 ]

Logical block size is the lowest possible block size that the storage
device can address. Max segment size is often related with controller's
DMA capability. And it is reasonable to align max segment size with
logical block size.

SDHCI sets un-aligned max segment size, and causes ADMA error, so
fix it by aligning max segment size with logical block size.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Faiz Abbas <faiz_abbas@ti.com>
Cc: linux-block@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 6 ------
 drivers/mmc/core/queue.c | 9 ++++++++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index eee004fb3c3e3..527ab15c421f9 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2384,12 +2384,6 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	snprintf(md->disk->disk_name, sizeof(md->disk->disk_name),
 		 "mmcblk%u%s", card->host->index, subname ? subname : "");
 
-	if (mmc_card_mmc(card))
-		blk_queue_logical_block_size(md->queue.queue,
-					     card->ext_csd.data_sector_size);
-	else
-		blk_queue_logical_block_size(md->queue.queue, 512);
-
 	set_capacity(md->disk, size);
 
 	if (mmc_host_cmd23(card->host)) {
diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 18aae28845ec9..becc6594a8a47 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -355,6 +355,7 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
 	u64 limit = BLK_BOUNCE_HIGH;
+	unsigned block_size = 512;
 
 	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
 		limit = (u64)dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
@@ -368,7 +369,13 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
 	blk_queue_max_hw_sectors(mq->queue,
 		min(host->max_blk_count, host->max_req_size / 512));
 	blk_queue_max_segments(mq->queue, host->max_segs);
-	blk_queue_max_segment_size(mq->queue, host->max_seg_size);
+
+	if (mmc_card_mmc(card))
+		block_size = card->ext_csd.data_sector_size;
+
+	blk_queue_logical_block_size(mq->queue, block_size);
+	blk_queue_max_segment_size(mq->queue,
+			round_down(host->max_seg_size, block_size));
 
 	INIT_WORK(&mq->recovery_work, mmc_mq_recovery_handler);
 	INIT_WORK(&mq->complete_work, mmc_blk_mq_complete_work);
-- 
2.20.1

