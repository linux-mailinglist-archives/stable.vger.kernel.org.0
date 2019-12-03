Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D27111E6C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfLCWzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:55:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbfLCWzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAA612053B;
        Tue,  3 Dec 2019 22:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413731;
        bh=AkmH7/23k2qjTXz17Saidwk9VDL7TkNqlVi282KJW4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLqk2UFaaQR6acGZfHCHkkUPiKFHi6zoPsNnaRILB27rCk3JMvZJXEmAjA4NxFcMD
         hs+GKOQ9LZnKmkpQnr05gfn/SkT/hayOyNQiei2JJZKeFCNHRRVmj4lAw1XQ45b33p
         ezRCFHgJvyIhgHUcP2U6GkEOO1uuwCteezKCToIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Christoph Hellwig <hch@lst.de>, Faiz Abbas <faiz_abbas@ti.com>,
        linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/321] mmc: core: align max segment size with logical block size
Date:   Tue,  3 Dec 2019 23:35:06 +0100
Message-Id: <20191203223439.627632861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



