Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FFB3B60DA
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhF1Oa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234449AbhF1O3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B34261C92;
        Mon, 28 Jun 2021 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890381;
        bh=zGkdKxRdBQp1OrncasTOEjRRrb+RuldE4DcSQnlrAQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvElLrG4vG7D682BFlCfZYmRoI0TWuxUB9fuIk+rQHrG5Jfq16xS9bVe742sz+V2e
         7zt4ptUWgasNVxwXyY/YReRM+D74O+oNVfpLEJ3pBOjDix3BsgmiayIrebI+hbnnfS
         RKKC3JjF1nQU6Plv1hsPQCxhmSRXKC35kpV4CEV6cwj4p/Lce1rgRAD3lEW9Lm/483
         IBwOOMBbuIfESXqsHjwT8umsSzsYrzximFnNgSP/4SKw5cC1iUi/DrBf6Yrsta+4Hp
         7Am9BBgSm+PnR4U7ikjUIkkszr/65X1EvyXAaG720URRD3WSfTvjpM5NVAi5tw82A4
         aM7A4q442vNyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haibo Chen <haibo.chen@nxp.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/101] spi: spi-nxp-fspi: move the register operation after the clock enable
Date:   Mon, 28 Jun 2021 10:24:39 -0400
Message-Id: <20210628142607.32218-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
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
index ab9035662717..bcc0b5a3a459 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1033,12 +1033,6 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		goto err_put_ctrl;
 	}
 
-	/* Clear potential interrupts */
-	reg = fspi_readl(f, f->iobase + FSPI_INTR);
-	if (reg)
-		fspi_writel(f, reg, f->iobase + FSPI_INTR);
-
-
 	/* find the resources - controller memory mapped space */
 	if (is_acpi_node(f->dev->fwnode))
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -1076,6 +1070,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		}
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

