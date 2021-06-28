Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06F73B5FE2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhF1OVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232601AbhF1OVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2408561C7D;
        Mon, 28 Jun 2021 14:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889920;
        bh=zGkdKxRdBQp1OrncasTOEjRRrb+RuldE4DcSQnlrAQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouTlP1KcLmsTNiltgfDoRT8PbUd6cxLoYP8StCluLkNPlel6a+D7Mudi19a7vPDxA
         0BBZFr2lRXPUA7h2socpo1wRP6d1MLZIzxxF+qJSX56ZpZD7f0SQUv82SUJHdhCmd/
         gSZnE9faiCEkxdJkYwZB1x8lunGx0UTBXJzqM3NaB5slEfROePmOkhTBca4dnN4cU+
         yUgHQwbehk4W+X5poo4+Gi53ucTJJDa7rKcybEKev76gmN+YSWgQ6JMheLPd2/IqzG
         kcHn2tanG70wLvDldDJ7c3CWYol6JalwUnrhaEEsVcMdBTj9fIlAyoLWVeL4ECT0oF
         st7HdiCa9Yz4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haibo Chen <haibo.chen@nxp.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 011/110] spi: spi-nxp-fspi: move the register operation after the clock enable
Date:   Mon, 28 Jun 2021 10:16:49 -0400
Message-Id: <20210628141828.31757-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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

