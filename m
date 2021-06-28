Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B7F3B618B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhF1OgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235024AbhF1Oep (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81FB861C85;
        Mon, 28 Jun 2021 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890617;
        bh=LJLpET3dPdDd1QY1F/vPl2uENiMf7V+LvERm/aLbD/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ET7+p7LwTXDTp3azwGc35/AJHiu+6dUB0OnfjUXfHBA0YGrvEcNQMXcYFP/BWVMmr
         KRGFOghaIRxQ/11GM/E+pbCUWQ/8BaR1LBFLny59nXFgup53+OZZeBO+W8Dm3Wy3G3
         r5mgdclQZy4nJaku2nbGJ/iW7tYhRP9vIKoC5CddRnElRf3eve9unYbpcawPyB6ATc
         aXdxdAdda01LlFGfu3xe/aU12UMO6u+AsDFQ4LcTO0woii6JkbvgnJvP1b7KADH3Yf
         sLdCQez0c3enrhiZOBse7hKyz1t8RPm7QrnZj/t5S+rPUi3SuAcKBM61VTTGuNZp4Z
         eWU4n0cyySz7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haibo Chen <haibo.chen@nxp.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/71] spi: spi-nxp-fspi: move the register operation after the clock enable
Date:   Mon, 28 Jun 2021 10:29:04 -0400
Message-Id: <20210628143004.32596-12-sashal@kernel.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit f422316c8e9d3c4aff3c56549dfb44a677d02f14 ]

Move the register operation after the clock enable, otherwise system
will stuck when this driver probe.

Fixes: 71d80563b076 ("spi: spi-nxp-fspi: fix fspi panic by unexpected interrupts")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://lore.kernel.org/r/1623317073-25158-1-git-send-email-haibo.chen@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index efd9e908e224..36a44a837031 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -975,12 +975,6 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		goto err_put_ctrl;
 	}
 
-	/* Clear potential interrupts */
-	reg = fspi_readl(f, f->iobase + FSPI_INTR);
-	if (reg)
-		fspi_writel(f, reg, f->iobase + FSPI_INTR);
-
-
 	/* find the resources - controller memory mapped space */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "fspi_mmap");
 	f->ahb_addr = devm_ioremap_resource(dev, res);
@@ -1012,6 +1006,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		goto err_put_ctrl;
 	}
 
+	/* Clear potential interrupts */
+	reg = fspi_readl(f, f->iobase + FSPI_INTR);
+	if (reg)
+		fspi_writel(f, reg, f->iobase + FSPI_INTR);
+
 	/* find the irq */
 	ret = platform_get_irq(pdev, 0);
 	if (ret < 0)
-- 
2.30.2

