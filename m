Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0502CD809
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436744AbgLCNht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436508AbgLCNaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:15 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ran Wang <ran.wang_1@nxp.com>, Han Xu <han.xu@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 21/39] spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts
Date:   Thu,  3 Dec 2020 08:28:15 -0500
Message-Id: <20201203132834.930999-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Wang <ran.wang_1@nxp.com>

[ Upstream commit 71d80563b0760a411cd90a3680536f5d887fff6b ]

Given the case that bootloader(such as UEFI)'s FSPI driver might not
handle all interrupts before loading kernel, those legacy interrupts
would assert immidiately once kernel's FSPI driver enable them. Further,
if it was FSPI_INTR_IPCMDDONE, the irq handler nxp_fspi_irq_handler()
would call complete(&f->c) to notify others. However, f->c might not be
initialized yet at that time, then cause kernel panic.

Of cause, we should fix this issue within bootloader. But it would be
better to have this pacth to make dirver more robust (by clearing all
interrupt status bits before enabling interrupts).

Suggested-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Link: https://lore.kernel.org/r/20201123025715.14635-1-ran.wang_1@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 1ccda82da2063..158e09470898b 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -991,6 +991,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct nxp_fspi *f;
 	int ret;
+	u32 reg;
 
 	ctlr = spi_alloc_master(&pdev->dev, sizeof(*f));
 	if (!ctlr)
@@ -1017,6 +1018,12 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		goto err_put_ctrl;
 	}
 
+	/* Clear potential interrupts */
+	reg = fspi_readl(f, f->iobase + FSPI_INTR);
+	if (reg)
+		fspi_writel(f, reg, f->iobase + FSPI_INTR);
+
+
 	/* find the resources - controller memory mapped space */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "fspi_mmap");
 	if (!res) {
-- 
2.27.0

