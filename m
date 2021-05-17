Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E7F383553
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbhEQPRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242336AbhEQPPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0ED460724;
        Mon, 17 May 2021 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261949;
        bh=i8IpQUcvNWy8sZGn7jfatMstwo5siFDdk/sfgaBBklU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR8r2/uLQOTi2Qz/vVMPDOLPNXFhy6X9ttVgX0HI9ASGuj8g1hse+9FR9Ec9uckSK
         4NU5zXQ21v6th8sVSl4oyjgTcZHaHg5C/oMp2z5HvU32a74qSKq7poiNEtla/8oy53
         RpBv+6KLbEuABJmjr60dfvsJtT3uCham17+Q3jKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 191/329] PCI: brcmstb: Use reset/rearm instead of deassert/assert
Date:   Mon, 17 May 2021 16:01:42 +0200
Message-Id: <20210517140308.591400393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Quinlan <jim2101024@gmail.com>

[ Upstream commit bb610757fcd74558ad94fe19993fd4470208dd02 ]

The Broadcom STB PCIe RC uses a reset control "rescal" for certain chips.
The "rescal" implements a "pulse reset" so using assert/deassert is wrong
for this device.  Instead, we use reset/rearm.  We need to use rearm so
that we can reset it after a suspend/resume cycle; w/o using "rearm", the
"rescal" device will only ever fire once.

Of course for suspend/resume to work we also need to put the reset/rearm
calls in the suspend and resume routines.

Fixes: 740d6c3708a9 ("PCI: brcmstb: Add control of rescal reset")
Link: https://lore.kernel.org/r/20210430152156.21162-4-jim2101024@gmail.com
Signed-off-by: Jim Quinlan <jim2101024@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index d41257f43a8f..7cbd56d8a5ff 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1127,6 +1127,7 @@ static int brcm_pcie_suspend(struct device *dev)
 
 	brcm_pcie_turn_off(pcie);
 	ret = brcm_phy_stop(pcie);
+	reset_control_rearm(pcie->rescal);
 	clk_disable_unprepare(pcie->clk);
 
 	return ret;
@@ -1142,9 +1143,13 @@ static int brcm_pcie_resume(struct device *dev)
 	base = pcie->base;
 	clk_prepare_enable(pcie->clk);
 
+	ret = reset_control_reset(pcie->rescal);
+	if (ret)
+		goto err_disable_clk;
+
 	ret = brcm_phy_start(pcie);
 	if (ret)
-		goto err;
+		goto err_reset;
 
 	/* Take bridge out of reset so we can access the SERDES reg */
 	pcie->bridge_sw_init_set(pcie, 0);
@@ -1159,14 +1164,16 @@ static int brcm_pcie_resume(struct device *dev)
 
 	ret = brcm_pcie_setup(pcie);
 	if (ret)
-		goto err;
+		goto err_reset;
 
 	if (pcie->msi)
 		brcm_msi_set_regs(pcie->msi);
 
 	return 0;
 
-err:
+err_reset:
+	reset_control_rearm(pcie->rescal);
+err_disable_clk:
 	clk_disable_unprepare(pcie->clk);
 	return ret;
 }
@@ -1176,7 +1183,7 @@ static void __brcm_pcie_remove(struct brcm_pcie *pcie)
 	brcm_msi_remove(pcie);
 	brcm_pcie_turn_off(pcie);
 	brcm_phy_stop(pcie);
-	reset_control_assert(pcie->rescal);
+	reset_control_rearm(pcie->rescal);
 	clk_disable_unprepare(pcie->clk);
 }
 
@@ -1251,13 +1258,13 @@ static int brcm_pcie_probe(struct platform_device *pdev)
 		return PTR_ERR(pcie->rescal);
 	}
 
-	ret = reset_control_deassert(pcie->rescal);
+	ret = reset_control_reset(pcie->rescal);
 	if (ret)
 		dev_err(&pdev->dev, "failed to deassert 'rescal'\n");
 
 	ret = brcm_phy_start(pcie);
 	if (ret) {
-		reset_control_assert(pcie->rescal);
+		reset_control_rearm(pcie->rescal);
 		clk_disable_unprepare(pcie->clk);
 		return ret;
 	}
-- 
2.30.2



