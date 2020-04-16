Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930EA1ACA1A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441566AbgDPNmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441551AbgDPNmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:42:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756DD214D8;
        Thu, 16 Apr 2020 13:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044559;
        bh=7W8SpPIOywJNExWL8DrXnjX+O9i7Fc36hKuhRdZJWF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwfYo/VoSKCP+nxd6TZCQKNBb5MOxaoLBuA1eQwlfIgv2IY0uKQudzaFqIf2P08lt
         AHtBv4OLeY+Z7JjLdftqzpRBMJn3gagEpNsbvc/zeVHNLvTnt/axT+vVn/I/+wk0Jg
         91XGjqnZXlbdalj/0wDoZar6WnRKmmkoGGp23xAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Fuchs <mklntf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/232] net: stmmac: platform: Fix misleading interrupt error msg
Date:   Thu, 16 Apr 2020 15:21:44 +0200
Message-Id: <20200416131317.722791864@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Fuchs <mklntf@gmail.com>

[ Upstream commit fc191af1bb0d069dc7e981076e8b80af21f1e61d ]

Not every stmmac based platform makes use of the eth_wake_irq or eth_lpi
interrupts. Use the platform_get_irq_byname_optional variant for these
interrupts, so no error message is displayed, if they can't be found.
Rather print an information to hint something might be wrong to assist
debugging on platforms which use these interrupts.

Signed-off-by: Markus Fuchs <mklntf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5150551c28be3..508325cc105d5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -663,16 +663,22 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 	 * In case the wake up interrupt is not passed from the platform
 	 * so the driver will continue to use the mac irq (ndev->irq)
 	 */
-	stmmac_res->wol_irq = platform_get_irq_byname(pdev, "eth_wake_irq");
+	stmmac_res->wol_irq =
+		platform_get_irq_byname_optional(pdev, "eth_wake_irq");
 	if (stmmac_res->wol_irq < 0) {
 		if (stmmac_res->wol_irq == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
+		dev_info(&pdev->dev, "IRQ eth_wake_irq not found\n");
 		stmmac_res->wol_irq = stmmac_res->irq;
 	}
 
-	stmmac_res->lpi_irq = platform_get_irq_byname(pdev, "eth_lpi");
-	if (stmmac_res->lpi_irq == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	stmmac_res->lpi_irq =
+		platform_get_irq_byname_optional(pdev, "eth_lpi");
+	if (stmmac_res->lpi_irq < 0) {
+		if (stmmac_res->lpi_irq == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+		dev_info(&pdev->dev, "IRQ eth_lpi not found\n");
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	stmmac_res->addr = devm_ioremap_resource(&pdev->dev, res);
-- 
2.20.1



