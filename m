Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98CD2DA08A
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440560AbgLNTbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:31:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502182AbgLNRgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:36:06 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Han Xu <han.xu@nxp.com>,
        Ran Wang <ran.wang_1@nxp.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/36] spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts
Date:   Mon, 14 Dec 2020 18:27:58 +0100
Message-Id: <20201214172544.004193533@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 28ae5229f889f..efd9e908e2248 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -948,6 +948,7 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct nxp_fspi *f;
 	int ret;
+	u32 reg;
 
 	ctlr = spi_alloc_master(&pdev->dev, sizeof(*f));
 	if (!ctlr)
@@ -974,6 +975,12 @@ static int nxp_fspi_probe(struct platform_device *pdev)
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
 	f->ahb_addr = devm_ioremap_resource(dev, res);
-- 
2.27.0



