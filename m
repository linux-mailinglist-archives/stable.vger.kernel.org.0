Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8EF38302F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhEQOZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239212AbhEQOWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7125161285;
        Mon, 17 May 2021 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260714;
        bh=PEOqu0ZRJMUuDv4a3XyK6Or/hZs8JcJHsqf8AyVV0Yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9FQ/E+o+ZQZMiUwRbbOagMhU3RXd1fv2yktkCQyOTsb1F8tOVnDb8yKyWO1cjyIn
         T8rF9jQkgGvENL6Qjb+mSyhf6hXN2VT4hmDjs8GLtWnNUtqVGbFv6z1Qf8QxTJ/dK/
         tRttw6Gd04JX2WJ8ROe0MZG8r9ininTbWcEpEkHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Quinlan <jim2101024@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 206/363] PCI: brcmstb: Use reset/rearm instead of deassert/assert
Date:   Mon, 17 May 2021 16:01:12 +0200
Message-Id: <20210517140309.546556088@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 69c999222cc8..08bc788d9422 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1148,6 +1148,7 @@ static int brcm_pcie_suspend(struct device *dev)
 
 	brcm_pcie_turn_off(pcie);
 	ret = brcm_phy_stop(pcie);
+	reset_control_rearm(pcie->rescal);
 	clk_disable_unprepare(pcie->clk);
 
 	return ret;
@@ -1163,9 +1164,13 @@ static int brcm_pcie_resume(struct device *dev)
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
@@ -1180,14 +1185,16 @@ static int brcm_pcie_resume(struct device *dev)
 
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
@@ -1197,7 +1204,7 @@ static void __brcm_pcie_remove(struct brcm_pcie *pcie)
 	brcm_msi_remove(pcie);
 	brcm_pcie_turn_off(pcie);
 	brcm_phy_stop(pcie);
-	reset_control_assert(pcie->rescal);
+	reset_control_rearm(pcie->rescal);
 	clk_disable_unprepare(pcie->clk);
 }
 
@@ -1278,13 +1285,13 @@ static int brcm_pcie_probe(struct platform_device *pdev)
 		return PTR_ERR(pcie->perst_reset);
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



