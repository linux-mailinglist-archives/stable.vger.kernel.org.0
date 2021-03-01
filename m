Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C42E3284AF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhCAQkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:40:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhCAQc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:32:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2AA464F70;
        Mon,  1 Mar 2021 16:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615898;
        bh=87jKld7AmQdJn4kxHXTqOJYAO+4A2BTYGY6SdrnOY7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0WZRnxgxVb7XGQjQVrQG6+wSzBatVnQl3eDv075FUZCdMzSA7dkh2gB9x5o1jbAQ
         r+I08t4QRVoPsiRuVUdrTIDMSR+QalOwNgogcvdI+iSxYr0mpaPm5nIN60v+sIR1xt
         ZoQgYgKY9rp5AvTnGBM01ZHH6NK4GRdLTuwTXz0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leif Liddy <leif.liddy@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/134] spi: pxa2xx: Fix the controller numbering for Wildcat Point
Date:   Mon,  1 Mar 2021 17:12:50 +0100
Message-Id: <20210301161016.948803340@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 54c5d3bfb0cfb7b31259765524567871dee11615 ]

Wildcat Point has two SPI controllers and added one is actually second one.
Fix the numbering by adding the description of the first one.

Fixes: caba248db286 ("spi: spi-pxa2xx-pci: Add ID and driver type for WildcatPoint PCH")
Cc: Leif Liddy <leif.liddy@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210208163816.22147-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx-pci.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
index 58d2d48e16a53..c37e35aeafa44 100644
--- a/drivers/spi/spi-pxa2xx-pci.c
+++ b/drivers/spi/spi-pxa2xx-pci.c
@@ -21,7 +21,8 @@ enum {
 	PORT_BSW1,
 	PORT_BSW2,
 	PORT_CE4100,
-	PORT_LPT,
+	PORT_LPT0,
+	PORT_LPT1,
 };
 
 struct pxa_spi_info {
@@ -48,8 +49,10 @@ static struct dw_dma_slave bsw1_rx_param = { .src_id = 7 };
 static struct dw_dma_slave bsw2_tx_param = { .dst_id = 8 };
 static struct dw_dma_slave bsw2_rx_param = { .src_id = 9 };
 
-static struct dw_dma_slave lpt_tx_param = { .dst_id = 0 };
-static struct dw_dma_slave lpt_rx_param = { .src_id = 1 };
+static struct dw_dma_slave lpt1_tx_param = { .dst_id = 0 };
+static struct dw_dma_slave lpt1_rx_param = { .src_id = 1 };
+static struct dw_dma_slave lpt0_tx_param = { .dst_id = 2 };
+static struct dw_dma_slave lpt0_rx_param = { .src_id = 3 };
 
 static bool lpss_dma_filter(struct dma_chan *chan, void *param)
 {
@@ -158,12 +161,19 @@ static struct pxa_spi_info spi_info_configs[] = {
 		.num_chipselect = 1,
 		.max_clk_rate = 50000000,
 	},
-	[PORT_LPT] = {
+	[PORT_LPT0] = {
 		.type = LPSS_LPT_SSP,
 		.port_id = 0,
 		.setup = lpss_spi_setup,
-		.tx_param = &lpt_tx_param,
-		.rx_param = &lpt_rx_param,
+		.tx_param = &lpt0_tx_param,
+		.rx_param = &lpt0_rx_param,
+	},
+	[PORT_LPT1] = {
+		.type = LPSS_LPT_SSP,
+		.port_id = 1,
+		.setup = lpss_spi_setup,
+		.tx_param = &lpt1_tx_param,
+		.rx_param = &lpt1_rx_param,
 	},
 };
 
@@ -251,8 +261,9 @@ static const struct pci_device_id pxa2xx_spi_pci_devices[] = {
 	{ PCI_VDEVICE(INTEL, 0x2290), PORT_BSW1 },
 	{ PCI_VDEVICE(INTEL, 0x22ac), PORT_BSW2 },
 	{ PCI_VDEVICE(INTEL, 0x2e6a), PORT_CE4100 },
-	{ PCI_VDEVICE(INTEL, 0x9ce6), PORT_LPT },
-	{ },
+	{ PCI_VDEVICE(INTEL, 0x9ce5), PORT_LPT0 },
+	{ PCI_VDEVICE(INTEL, 0x9ce6), PORT_LPT1 },
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, pxa2xx_spi_pci_devices);
 
-- 
2.27.0



