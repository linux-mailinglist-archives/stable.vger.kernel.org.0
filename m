Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4053B372F
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbfIPJfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 05:35:23 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10277 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPJfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 05:35:22 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d7f575e0000>; Mon, 16 Sep 2019 02:35:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Sep 2019 02:35:22 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Sep 2019 02:35:22 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 09:35:21 +0000
Received: from hqnvemgw02.nvidia.com (172.16.227.111) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 16 Sep 2019 09:35:21 +0000
Received: from audio.nvidia.com (Not Verified[10.24.34.185]) by hqnvemgw02.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d7f57570001>; Mon, 16 Sep 2019 02:35:21 -0700
From:   Sameer Pujar <spujar@nvidia.com>
To:     <vkoul@kernel.org>, <jonathanh@nvidia.com>, <ldewangan@nvidia.com>
CC:     <thierry.reding@gmail.com>, <dmaengine@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Sameer Pujar <spujar@nvidia.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v4] dmaengine: tegra210-adma: fix transfer failure
Date:   Mon, 16 Sep 2019 15:05:13 +0530
Message-ID: <1568626513-16541-1-git-send-email-spujar@nvidia.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568626526; bh=yn402LhGq+LGf2jBBD6XRdkwq6zDz49QEZEqe7x2nDo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:Content-Type;
        b=hGZKCCS7PtXyzXg1PLI35HgXV7jDggyPw1Wa77oyAW2cdeS1ZSESzPHWjvLyjB8oh
         Fnuhpwp6ArLph0VenP9ZJCPaM2JIZ2Z/cUSkTO3pSzVpWd8qk8EbEDL7VjY4uRv86q
         hYaNRYlfLmI0aw4ovQcQmF/sttf11uC/gn+JYDg4YZQDdEDIKeeU5kgpUvdz9PC55I
         QJZ0mb5IStMqZqcusV8d5utEQjxaA9YJ/vW0HEY4St9HqznWh6doRwtQKOhnXFpy0O
         T1cAg5ibNFyzALlrCQcw8P1GfRzUqOiR/qCc5YPbkUK518loTTmpIEZ/G40FI/K3Dk
         ooBc4Hz2p3w+Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From Tegra186 onwards OUTSTANDING_REQUESTS field is added in channel
configuration register(bits 7:4) which defines the maximum number of reads
from the source and writes to the destination that may be outstanding at
any given point of time. This field must be programmed with a value
between 1 and 8. A value of 0 will prevent any transfers from happening.

Thus added 'has_outstanding_reqs' bool member in chip data structure and is
set to false for Tegra210, since the field is not applicable. For Tegra186
it is set to true and channel configuration is updated with maximum
outstanding requests.

Fixes: 433de642a76c ("dmaengine: tegra210-adma: add support for Tegra186/Tegra194")
Cc: stable@vger.kernel.org

Signed-off-by: Sameer Pujar <spujar@nvidia.com>
---
 drivers/dma/tegra210-adma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index 5f8adf5..6e12685 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -40,6 +40,7 @@
 #define ADMA_CH_CONFIG_MAX_BURST_SIZE                   16
 #define ADMA_CH_CONFIG_WEIGHT_FOR_WRR(val)		((val) & 0xf)
 #define ADMA_CH_CONFIG_MAX_BUFS				8
+#define TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(reqs)	(reqs << 4)
 
 #define ADMA_CH_FIFO_CTRL				0x2c
 #define TEGRA210_ADMA_CH_FIFO_CTRL_TXSIZE(val)		(((val) & 0xf) << 8)
@@ -77,6 +78,7 @@ struct tegra_adma;
  * @ch_req_tx_shift: Register offset for AHUB transmit channel select.
  * @ch_req_rx_shift: Register offset for AHUB receive channel select.
  * @ch_base_offset: Register offset of DMA channel registers.
+ * @has_outstanding_reqs: If DMA channel can have outstanding requests.
  * @ch_fifo_ctrl: Default value for channel FIFO CTRL register.
  * @ch_req_mask: Mask for Tx or Rx channel select.
  * @ch_req_max: Maximum number of Tx or Rx channels available.
@@ -95,6 +97,7 @@ struct tegra_adma_chip_data {
 	unsigned int ch_req_max;
 	unsigned int ch_reg_size;
 	unsigned int nr_channels;
+	bool has_outstanding_reqs;
 };
 
 /*
@@ -594,6 +597,8 @@ static int tegra_adma_set_xfer_params(struct tegra_adma_chan *tdc,
 			 ADMA_CH_CTRL_FLOWCTRL_EN;
 	ch_regs->config |= cdata->adma_get_burst_config(burst_size);
 	ch_regs->config |= ADMA_CH_CONFIG_WEIGHT_FOR_WRR(1);
+	if (cdata->has_outstanding_reqs)
+		ch_regs->config |= TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(8);
 	ch_regs->fifo_ctrl = cdata->ch_fifo_ctrl;
 	ch_regs->tc = desc->period_len & ADMA_CH_TC_COUNT_MASK;
 
@@ -778,6 +783,7 @@ static const struct tegra_adma_chip_data tegra210_chip_data = {
 	.ch_req_tx_shift	= 28,
 	.ch_req_rx_shift	= 24,
 	.ch_base_offset		= 0,
+	.has_outstanding_reqs	= false,
 	.ch_fifo_ctrl		= TEGRA210_FIFO_CTRL_DEFAULT,
 	.ch_req_mask		= 0xf,
 	.ch_req_max		= 10,
@@ -792,6 +798,7 @@ static const struct tegra_adma_chip_data tegra186_chip_data = {
 	.ch_req_tx_shift	= 27,
 	.ch_req_rx_shift	= 22,
 	.ch_base_offset		= 0x10000,
+	.has_outstanding_reqs	= true,
 	.ch_fifo_ctrl		= TEGRA186_FIFO_CTRL_DEFAULT,
 	.ch_req_mask		= 0x1f,
 	.ch_req_max		= 20,
-- 
2.7.4

