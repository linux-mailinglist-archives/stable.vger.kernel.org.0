Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190813B6188
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhF1OgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234962AbhF1Oe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2ABA161C7D;
        Mon, 28 Jun 2021 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890612;
        bh=7C1LewhcSGIs0mAnyQRfCnCq0VUIGywhRLjh1YXWsnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFqtT2vi7Apvl/j7splGVWO5HPhrIL/GO5J9lI37LhMCpHop4NiSpO+4xkiAgu8pS
         yet6ohbpSbCVIr0epy1cejmXQBHu9sV5gBuAAyAAChJAVAyF8WIeWFUmNotLeXlxE5
         GjXFmiEPSjUxNdhM/7FHg1xj+8DmQfhK0y+F8my2gNu8nIEz2jYRyIO0+5+tmKs17v
         9GAvUCaqHjieRDDEMUDYUo0fOa2jb5iPY2maYeav40/rZBFGkrOCs8hK/UvYBEjift
         jgHyf7nzex7eVecTDalHMmVouZ9D16HnEEh0d1ryUlDGDeEFobv9gmes97Ao1YJ2Cv
         HTq8+iIJKJ8xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 07/71] mmc: meson-gx: use memcpy_to/fromio for dram-access-quirk
Date:   Mon, 28 Jun 2021 10:29:00 -0400
Message-Id: <20210628143004.32596-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 103a5348c22c3fca8b96c735a9e353b8a0801842 upstream.

It has been reported that usage of memcpy() to/from an iomem mapping is invalid,
and a recent arm64 memcpy update [1] triggers a memory abort when dram-access-quirk
is used on the G12A/G12B platforms.

This adds a local sg_copy_to_buffer which makes usage of io versions of memcpy
when dram-access-quirk is enabled.

[1] 285133040e6c ("arm64: Import latest memcpy()/memmove() implementation")

Fixes: acdc8e71d9bb ("mmc: meson-gx: add dram-access-quirk")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20210609150230.9291-1-narmstrong@baylibre.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c | 50 +++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 545c3f2f8a06..a3e3b274f0ea 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -166,6 +166,7 @@ struct meson_host {
 
 	unsigned int bounce_buf_size;
 	void *bounce_buf;
+	void __iomem *bounce_iomem_buf;
 	dma_addr_t bounce_dma_addr;
 	struct sd_emmc_desc *descs;
 	dma_addr_t descs_dma_addr;
@@ -737,6 +738,47 @@ static void meson_mmc_desc_chain_transfer(struct mmc_host *mmc, u32 cmd_cfg)
 	writel(start, host->regs + SD_EMMC_START);
 }
 
+/* local sg copy to buffer version with _to/fromio usage for dram_access_quirk */
+static void meson_mmc_copy_buffer(struct meson_host *host, struct mmc_data *data,
+				  size_t buflen, bool to_buffer)
+{
+	unsigned int sg_flags = SG_MITER_ATOMIC;
+	struct scatterlist *sgl = data->sg;
+	unsigned int nents = data->sg_len;
+	struct sg_mapping_iter miter;
+	unsigned int offset = 0;
+
+	if (to_buffer)
+		sg_flags |= SG_MITER_FROM_SG;
+	else
+		sg_flags |= SG_MITER_TO_SG;
+
+	sg_miter_start(&miter, sgl, nents, sg_flags);
+
+	while ((offset < buflen) && sg_miter_next(&miter)) {
+		unsigned int len;
+
+		len = min(miter.length, buflen - offset);
+
+		/* When dram_access_quirk, the bounce buffer is a iomem mapping */
+		if (host->dram_access_quirk) {
+			if (to_buffer)
+				memcpy_toio(host->bounce_iomem_buf + offset, miter.addr, len);
+			else
+				memcpy_fromio(miter.addr, host->bounce_iomem_buf + offset, len);
+		} else {
+			if (to_buffer)
+				memcpy(host->bounce_buf + offset, miter.addr, len);
+			else
+				memcpy(miter.addr, host->bounce_buf + offset, len);
+		}
+
+		offset += len;
+	}
+
+	sg_miter_stop(&miter);
+}
+
 static void meson_mmc_start_cmd(struct mmc_host *mmc, struct mmc_command *cmd)
 {
 	struct meson_host *host = mmc_priv(mmc);
@@ -780,8 +822,7 @@ static void meson_mmc_start_cmd(struct mmc_host *mmc, struct mmc_command *cmd)
 		if (data->flags & MMC_DATA_WRITE) {
 			cmd_cfg |= CMD_CFG_DATA_WR;
 			WARN_ON(xfer_bytes > host->bounce_buf_size);
-			sg_copy_to_buffer(data->sg, data->sg_len,
-					  host->bounce_buf, xfer_bytes);
+			meson_mmc_copy_buffer(host, data, xfer_bytes, true);
 			dma_wmb();
 		}
 
@@ -950,8 +991,7 @@ static irqreturn_t meson_mmc_irq_thread(int irq, void *dev_id)
 	if (meson_mmc_bounce_buf_read(data)) {
 		xfer_bytes = data->blksz * data->blocks;
 		WARN_ON(xfer_bytes > host->bounce_buf_size);
-		sg_copy_from_buffer(data->sg, data->sg_len,
-				    host->bounce_buf, xfer_bytes);
+		meson_mmc_copy_buffer(host, data, xfer_bytes, false);
 	}
 
 	next_cmd = meson_mmc_get_next_command(cmd);
@@ -1179,7 +1219,7 @@ static int meson_mmc_probe(struct platform_device *pdev)
 		 * instead of the DDR memory
 		 */
 		host->bounce_buf_size = SD_EMMC_SRAM_DATA_BUF_LEN;
-		host->bounce_buf = host->regs + SD_EMMC_SRAM_DATA_BUF_OFF;
+		host->bounce_iomem_buf = host->regs + SD_EMMC_SRAM_DATA_BUF_OFF;
 		host->bounce_dma_addr = res->start + SD_EMMC_SRAM_DATA_BUF_OFF;
 	} else {
 		/* data bounce buffer */
-- 
2.30.2

