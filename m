Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD682428F4C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbhJKN5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238009AbhJKNzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B5E6610F8;
        Mon, 11 Oct 2021 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960362;
        bh=TXMSdc1/XdOM5D8HWd0/lYf9pbPZNvd50KJLdmgDpHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvLZZJmBu1e5d3JvEYviFTkafT1DylN+6JOzBUbqEKFdUviuVAxcDnK5+FiMIBphi
         3QlWl5EuNl73PSY/tFxFiAwwKJIdJhCc9A5cN6l2NfRF3nRcltZGhOssx4QK3zLsKW
         p0mzRnfXJ9e71WVFvdO2IWvwnUGTZtEcIqX5KAG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Hewitt <christianshewitt@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 08/83] mmc: meson-gx: do not use memcpy_to/fromio for dram-access-quirk
Date:   Mon, 11 Oct 2021 15:45:28 +0200
Message-Id: <20211011134508.641812403@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 8a38a4d51c5055d0201542e5ea3c0cb287f6e223 upstream.

The memory at the end of the controller only accepts 32bit read/write
accesses, but the arm64 memcpy_to/fromio implementation only uses 64bit
(which will be split into two 32bit access) and 8bit leading to incomplete
copies to/from this memory when the buffer is not multiple of 8bytes.

Add a local copy using writel/readl accesses to make sure we use the right
memory access width.

The switch to memcpy_to/fromio was done because of 285133040e6c
("arm64: Import latest memcpy()/memmove() implementation"), but using memcpy
worked before since it mainly used 32bit memory acceses.

Fixes: 103a5348c22c ("mmc: meson-gx: use memcpy_to/fromio for dram-access-quirk")
Reported-by: Christian Hewitt <christianshewitt@gmail.com>
Suggested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210928073652.434690-1-narmstrong@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |   73 ++++++++++++++++++++++++++++++++--------
 1 file changed, 59 insertions(+), 14 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -735,7 +735,7 @@ static void meson_mmc_desc_chain_transfe
 	writel(start, host->regs + SD_EMMC_START);
 }
 
-/* local sg copy to buffer version with _to/fromio usage for dram_access_quirk */
+/* local sg copy for dram_access_quirk */
 static void meson_mmc_copy_buffer(struct meson_host *host, struct mmc_data *data,
 				  size_t buflen, bool to_buffer)
 {
@@ -753,21 +753,27 @@ static void meson_mmc_copy_buffer(struct
 	sg_miter_start(&miter, sgl, nents, sg_flags);
 
 	while ((offset < buflen) && sg_miter_next(&miter)) {
-		unsigned int len;
+		unsigned int buf_offset = 0;
+		unsigned int len, left;
+		u32 *buf = miter.addr;
 
 		len = min(miter.length, buflen - offset);
+		left = len;
 
-		/* When dram_access_quirk, the bounce buffer is a iomem mapping */
-		if (host->dram_access_quirk) {
-			if (to_buffer)
-				memcpy_toio(host->bounce_iomem_buf + offset, miter.addr, len);
-			else
-				memcpy_fromio(miter.addr, host->bounce_iomem_buf + offset, len);
+		if (to_buffer) {
+			do {
+				writel(*buf++, host->bounce_iomem_buf + offset + buf_offset);
+
+				buf_offset += 4;
+				left -= 4;
+			} while (left);
 		} else {
-			if (to_buffer)
-				memcpy(host->bounce_buf + offset, miter.addr, len);
-			else
-				memcpy(miter.addr, host->bounce_buf + offset, len);
+			do {
+				*buf++ = readl(host->bounce_iomem_buf + offset + buf_offset);
+
+				buf_offset += 4;
+				left -= 4;
+			} while (left);
 		}
 
 		offset += len;
@@ -819,7 +825,11 @@ static void meson_mmc_start_cmd(struct m
 		if (data->flags & MMC_DATA_WRITE) {
 			cmd_cfg |= CMD_CFG_DATA_WR;
 			WARN_ON(xfer_bytes > host->bounce_buf_size);
-			meson_mmc_copy_buffer(host, data, xfer_bytes, true);
+			if (host->dram_access_quirk)
+				meson_mmc_copy_buffer(host, data, xfer_bytes, true);
+			else
+				sg_copy_to_buffer(data->sg, data->sg_len,
+						  host->bounce_buf, xfer_bytes);
 			dma_wmb();
 		}
 
@@ -838,12 +848,43 @@ static void meson_mmc_start_cmd(struct m
 	writel(cmd->arg, host->regs + SD_EMMC_CMD_ARG);
 }
 
+static int meson_mmc_validate_dram_access(struct mmc_host *mmc, struct mmc_data *data)
+{
+	struct scatterlist *sg;
+	int i;
+
+	/* Reject request if any element offset or size is not 32bit aligned */
+	for_each_sg(data->sg, sg, data->sg_len, i) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)) ||
+		    !IS_ALIGNED(sg->length, sizeof(u32))) {
+			dev_err(mmc_dev(mmc), "unaligned sg offset %u len %u\n",
+				data->sg->offset, data->sg->length);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static void meson_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct meson_host *host = mmc_priv(mmc);
 	bool needs_pre_post_req = mrq->data &&
 			!(mrq->data->host_cookie & SD_EMMC_PRE_REQ_DONE);
 
+	/*
+	 * The memory at the end of the controller used as bounce buffer for
+	 * the dram_access_quirk only accepts 32bit read/write access,
+	 * check the aligment and length of the data before starting the request.
+	 */
+	if (host->dram_access_quirk && mrq->data) {
+		mrq->cmd->error = meson_mmc_validate_dram_access(mmc, mrq->data);
+		if (mrq->cmd->error) {
+			mmc_request_done(mmc, mrq);
+			return;
+		}
+	}
+
 	if (needs_pre_post_req) {
 		meson_mmc_get_transfer_mode(mmc, mrq);
 		if (!meson_mmc_desc_chain_mode(mrq->data))
@@ -988,7 +1029,11 @@ static irqreturn_t meson_mmc_irq_thread(
 	if (meson_mmc_bounce_buf_read(data)) {
 		xfer_bytes = data->blksz * data->blocks;
 		WARN_ON(xfer_bytes > host->bounce_buf_size);
-		meson_mmc_copy_buffer(host, data, xfer_bytes, false);
+		if (host->dram_access_quirk)
+			meson_mmc_copy_buffer(host, data, xfer_bytes, false);
+		else
+			sg_copy_from_buffer(data->sg, data->sg_len,
+					    host->bounce_buf, xfer_bytes);
 	}
 
 	next_cmd = meson_mmc_get_next_command(cmd);


