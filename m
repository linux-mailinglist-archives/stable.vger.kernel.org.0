Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CCE1AF07A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgDROtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgDROn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:43:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9B4C22240;
        Sat, 18 Apr 2020 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221006;
        bh=oBDpPo5r7BnQud5hg5Ni8kM1Rsc27eJkjugY81+CtPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dG60jycwDjX2U96AZIAD06NnFfbTGgPF0E+M/SGDsU/tu9nkDt3VUPBOmDF+qhPDD
         oy9LMArJupVNgDYx/EwAq0LVXGeMv3uZ3b+cLK8UeXpUvH9yqsIOY2f8o7e8lNP12H
         9Vevjf9SlhN1DwMW025WBUMmQpZ2jbJeHUGanPSo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 47/47] PCI/ASPM: Allow re-enabling Clock PM
Date:   Sat, 18 Apr 2020 10:42:27 -0400
Message-Id: <20200418144227.9802-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144227.9802-1-sashal@kernel.org>
References: <20200418144227.9802-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 35efea32b26f9aacc99bf07e0d2cdfba2028b099 ]

Previously Clock PM could not be re-enabled after being disabled by
pci_disable_link_state() because clkpm_capable was reset.  Change this by
adding a clkpm_disable field similar to aspm_disable.

Link: https://lore.kernel.org/r/4e8a66db-7d53-4a66-c26c-f0037ffaa705@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 1117b25fbe0bb..2948f86d88969 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -67,6 +67,7 @@ struct pcie_link_state {
 	u32 clkpm_capable:1;		/* Clock PM capable? */
 	u32 clkpm_enabled:1;		/* Current Clock PM state */
 	u32 clkpm_default:1;		/* Default Clock PM state by BIOS */
+	u32 clkpm_disable:1;		/* Clock PM disabled */
 
 	/* Exit latencies */
 	struct aspm_latency latency_up;	/* Upstream direction exit latency */
@@ -164,8 +165,11 @@ static void pcie_set_clkpm_nocheck(struct pcie_link_state *link, int enable)
 
 static void pcie_set_clkpm(struct pcie_link_state *link, int enable)
 {
-	/* Don't enable Clock PM if the link is not Clock PM capable */
-	if (!link->clkpm_capable)
+	/*
+	 * Don't enable Clock PM if the link is not Clock PM capable
+	 * or Clock PM is disabled
+	 */
+	if (!link->clkpm_capable || link->clkpm_disable)
 		enable = 0;
 	/* Need nothing if the specified equals to current state */
 	if (link->clkpm_enabled == enable)
@@ -195,7 +199,8 @@ static void pcie_clkpm_cap_init(struct pcie_link_state *link, int blacklist)
 	}
 	link->clkpm_enabled = enabled;
 	link->clkpm_default = enabled;
-	link->clkpm_capable = (blacklist) ? 0 : capable;
+	link->clkpm_capable = capable;
+	link->clkpm_disable = blacklist ? 1 : 0;
 }
 
 static bool pcie_retrain_link(struct pcie_link_state *link)
@@ -1106,10 +1111,9 @@ static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 		link->aspm_disable |= ASPM_STATE_L1;
 	pcie_config_aspm_link(link, policy_to_aspm_state(link));
 
-	if (state & PCIE_LINK_STATE_CLKPM) {
-		link->clkpm_capable = 0;
-		pcie_set_clkpm(link, 0);
-	}
+	if (state & PCIE_LINK_STATE_CLKPM)
+		link->clkpm_disable = 1;
+	pcie_set_clkpm(link, policy_to_clkpm_state(link));
 	mutex_unlock(&aspm_lock);
 	if (sem)
 		up_read(&pci_bus_sem);
-- 
2.20.1

