Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECE93285A6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbhCAQ4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235770AbhCAQto (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:49:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1206964FA9;
        Mon,  1 Mar 2021 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616371;
        bh=xAfh6t1SZ2YwzAW9Vc/pETSDP+jeZsVe8cqm2NHfAhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQj9GFfIVprgH+wpHzLfG/YBrHz/eEopE7+YUmyy4ySjCy22qEY5tkXsiKfo7sICS
         y3LWp27rsk0KP84aX9Oh/q7X0popcRUy9eNu6sTdE89hXOuU/H+CWVi1RG5Lwx5s4c
         9+jWqHOvyKWFqoVogpfwIPN/jQutTyZulVFzoUw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leif Liddy <leif.liddy@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/176] spi: pxa2xx: Fix the controller numbering for Wildcat Point
Date:   Mon,  1 Mar 2021 17:12:51 +0100
Message-Id: <20210301161025.850953684@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 869f188b02eb3..1736a48bbccec 100644
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
@@ -55,8 +56,10 @@ static struct dw_dma_slave bsw1_rx_param = { .src_id = 7 };
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
@@ -182,12 +185,19 @@ static struct pxa_spi_info spi_info_configs[] = {
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
 
@@ -281,8 +291,9 @@ static const struct pci_device_id pxa2xx_spi_pci_devices[] = {
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



