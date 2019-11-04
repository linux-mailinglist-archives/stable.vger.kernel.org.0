Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B420DEEE30
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390508AbfKDWKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390504AbfKDWKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:10:11 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A57C120650;
        Mon,  4 Nov 2019 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905410;
        bh=4evb73l0lxzxtEelxA/HONgL9oWxq4l3Vpph6+gsftU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQ/fWChI7+k20OZ22P9J3YNZPcuLJLcqAFr0UFztVXiShqROkQ/CpZdbOqIkvz3BL
         nr6XSaFoMPcIonPJA7PHGqJ+W6WAcZIg10g1zuBCbjapb/K2AuXnGu/M+Rkb3l2flY
         C2KryJQgKOLNUAwhnKSrxBLjITZvoPXRAcZliYP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.3 134/163] dmaengine: tegra210-adma: fix transfer failure
Date:   Mon,  4 Nov 2019 22:45:24 +0100
Message-Id: <20191104212150.048352178@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit 9ec691f48b5ef741a48af8932ccaec859c67e8f1 upstream.

>From Tegra186 onwards OUTSTANDING_REQUESTS field is added in channel
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
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/1568626513-16541-1-git-send-email-spujar@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/tegra210-adma.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -40,6 +40,7 @@
 #define ADMA_CH_CONFIG_MAX_BURST_SIZE                   16
 #define ADMA_CH_CONFIG_WEIGHT_FOR_WRR(val)		((val) & 0xf)
 #define ADMA_CH_CONFIG_MAX_BUFS				8
+#define TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(reqs)	(reqs << 4)
 
 #define ADMA_CH_FIFO_CTRL				0x2c
 #define TEGRA210_ADMA_CH_FIFO_CTRL_OFLWTHRES(val)	(((val) & 0xf) << 24)
@@ -85,6 +86,7 @@ struct tegra_adma;
  * @ch_req_tx_shift: Register offset for AHUB transmit channel select.
  * @ch_req_rx_shift: Register offset for AHUB receive channel select.
  * @ch_base_offset: Register offset of DMA channel registers.
+ * @has_outstanding_reqs: If DMA channel can have outstanding requests.
  * @ch_fifo_ctrl: Default value for channel FIFO CTRL register.
  * @ch_req_mask: Mask for Tx or Rx channel select.
  * @ch_req_max: Maximum number of Tx or Rx channels available.
@@ -103,6 +105,7 @@ struct tegra_adma_chip_data {
 	unsigned int ch_req_max;
 	unsigned int ch_reg_size;
 	unsigned int nr_channels;
+	bool has_outstanding_reqs;
 };
 
 /*
@@ -602,6 +605,8 @@ static int tegra_adma_set_xfer_params(st
 			 ADMA_CH_CTRL_FLOWCTRL_EN;
 	ch_regs->config |= cdata->adma_get_burst_config(burst_size);
 	ch_regs->config |= ADMA_CH_CONFIG_WEIGHT_FOR_WRR(1);
+	if (cdata->has_outstanding_reqs)
+		ch_regs->config |= TEGRA186_ADMA_CH_CONFIG_OUTSTANDING_REQS(8);
 	ch_regs->fifo_ctrl = cdata->ch_fifo_ctrl;
 	ch_regs->tc = desc->period_len & ADMA_CH_TC_COUNT_MASK;
 
@@ -786,6 +791,7 @@ static const struct tegra_adma_chip_data
 	.ch_req_tx_shift	= 28,
 	.ch_req_rx_shift	= 24,
 	.ch_base_offset		= 0,
+	.has_outstanding_reqs	= false,
 	.ch_fifo_ctrl		= TEGRA210_FIFO_CTRL_DEFAULT,
 	.ch_req_mask		= 0xf,
 	.ch_req_max		= 10,
@@ -800,6 +806,7 @@ static const struct tegra_adma_chip_data
 	.ch_req_tx_shift	= 27,
 	.ch_req_rx_shift	= 22,
 	.ch_base_offset		= 0x10000,
+	.has_outstanding_reqs	= true,
 	.ch_fifo_ctrl		= TEGRA186_FIFO_CTRL_DEFAULT,
 	.ch_req_mask		= 0x1f,
 	.ch_req_max		= 20,


