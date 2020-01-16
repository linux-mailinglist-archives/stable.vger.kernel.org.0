Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211DD13E0E8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgAPQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbgAPQq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1886207FF;
        Thu, 16 Jan 2020 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193186;
        bh=VpWBzokLYVSk39keM5udmQS/+os7biQGZY9AGCnt9qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2/VnR9xjWPXQcXgrV7LZxxDM7FGompgYvdCHpF6Zc7FKOuxS56AxvS48THJeMdpb
         x0bApVgehh19Fr/8hrqWxLVPgyFm20NMbYnlBkWjoSUeNi6GdIDQVHn58OTH7ZWXrk
         V+c4j2WWlJ/6u2Dmsh6HEAWpsakPIOZq6QqWvNWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Remi Pommarel <repk@triplefau.lt>, Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 042/205] PCI: aardvark: Use LTSSM state to build link training flag
Date:   Thu, 16 Jan 2020 11:40:17 -0500
Message-Id: <20200116164300.6705-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 364b3f1ff8f096d45f042a9c85daf7a1fc78413e ]

Aardvark's PCI_EXP_LNKSTA_LT flag in its link status register is not
implemented and does not reflect the actual link training state (the
flag is always set to 0). In order to support link re-training feature
this flag has to be emulated. The Link Training and Status State
Machine (LTSSM) flag in Aardvark LMI config register could be used as
a link training indicator. Indeed if the LTSSM is in L0 or upper state
then link training has completed (see [1]).

Unfortunately because after asking a link retraining it takes a while
for the LTSSM state to become less than 0x10 (due to L0s to recovery
state transition delays), LTSSM can still be in L0 while link training
has not finished yet. So this waits for link to be in recovery or lesser
state before returning after asking for a link retrain.

[1] "PCI Express Base Specification", REV. 4.0
    PCI Express, February 19 2014, Table 4-14

Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Tested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 29 ++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index fc0fe4d4de49..fe471861f801 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -180,6 +180,8 @@
 #define LINK_WAIT_MAX_RETRIES		10
 #define LINK_WAIT_USLEEP_MIN		90000
 #define LINK_WAIT_USLEEP_MAX		100000
+#define RETRAIN_WAIT_MAX_RETRIES	10
+#define RETRAIN_WAIT_USLEEP_US		2000
 
 #define MSI_IRQ_NUM			32
 
@@ -239,6 +241,17 @@ static int advk_pcie_wait_for_link(struct advk_pcie *pcie)
 	return -ETIMEDOUT;
 }
 
+static void advk_pcie_wait_for_retrain(struct advk_pcie *pcie)
+{
+	size_t retries;
+
+	for (retries = 0; retries < RETRAIN_WAIT_MAX_RETRIES; ++retries) {
+		if (!advk_pcie_link_up(pcie))
+			break;
+		udelay(RETRAIN_WAIT_USLEEP_US);
+	}
+}
+
 static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 {
 	u32 reg;
@@ -426,11 +439,20 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
+	case PCI_EXP_LNKCTL: {
+		/* u32 contains both PCI_EXP_LNKCTL and PCI_EXP_LNKSTA */
+		u32 val = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg) &
+			~(PCI_EXP_LNKSTA_LT << 16);
+		if (!advk_pcie_link_up(pcie))
+			val |= (PCI_EXP_LNKSTA_LT << 16);
+		*value = val;
+		return PCI_BRIDGE_EMUL_HANDLED;
+	}
+
 	case PCI_CAP_LIST_ID:
 	case PCI_EXP_DEVCAP:
 	case PCI_EXP_DEVCTL:
 	case PCI_EXP_LNKCAP:
-	case PCI_EXP_LNKCTL:
 		*value = advk_readl(pcie, PCIE_CORE_PCIEXP_CAP + reg);
 		return PCI_BRIDGE_EMUL_HANDLED;
 	default:
@@ -447,8 +469,13 @@ advk_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 
 	switch (reg) {
 	case PCI_EXP_DEVCTL:
+		advk_writel(pcie, new, PCIE_CORE_PCIEXP_CAP + reg);
+		break;
+
 	case PCI_EXP_LNKCTL:
 		advk_writel(pcie, new, PCIE_CORE_PCIEXP_CAP + reg);
+		if (new & PCI_EXP_LNKCTL_RL)
+			advk_pcie_wait_for_retrain(pcie);
 		break;
 
 	case PCI_EXP_RTCTL:
-- 
2.20.1

