Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72A113E0ED
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgAPQqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:46:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbgAPQqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:46:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC222081E;
        Thu, 16 Jan 2020 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193191;
        bh=4h3DkzSaclz8Yq3IfZOqDEUESWUJ+zaHTz04Uj0KSZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r890BBkYTT7C68sCS67Hjv5sTO1J93nfb/UjISN4wr71jXhMoGHlOEhnbzLFPwMKm
         npwpgB4ORtoobdluxbH8pYjFXMj2Pkw0kQsnHllvPuklxEOZeBw83qrQJcYwVSCr3p
         VQaZXf6wVr2HdjSmiSy3iihs9mhsD9k/H08wvs8Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 043/205] PCI: aardvark: Fix PCI_EXP_RTCTL register configuration
Date:   Thu, 16 Jan 2020 11:40:18 -0500
Message-Id: <20200116164300.6705-43-sashal@kernel.org>
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

[ Upstream commit c0f05a6ab52535c1bf5f43272eede3e11c5701a5 ]

PCI_EXP_RTCTL is used to activate PME interrupt only, so writing into it
should not modify other interrupts' mask. The ISR mask polarity was also
inverted, when PCI_EXP_RTCTL_PMEIE is set PCIE_MSG_PM_PME_MASK mask bit
should actually be cleared.

Fixes: 8a3ebd8de328 ("PCI: aardvark: Implement emulated root PCI bridge config space")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index fe471861f801..97245e076548 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -428,7 +428,7 @@ advk_pci_bridge_emul_pcie_conf_read(struct pci_bridge_emul *bridge,
 
 	case PCI_EXP_RTCTL: {
 		u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG);
-		*value = (val & PCIE_MSG_PM_PME_MASK) ? PCI_EXP_RTCTL_PMEIE : 0;
+		*value = (val & PCIE_MSG_PM_PME_MASK) ? 0 : PCI_EXP_RTCTL_PMEIE;
 		return PCI_BRIDGE_EMUL_HANDLED;
 	}
 
@@ -478,10 +478,15 @@ advk_pci_bridge_emul_pcie_conf_write(struct pci_bridge_emul *bridge,
 			advk_pcie_wait_for_retrain(pcie);
 		break;
 
-	case PCI_EXP_RTCTL:
-		new = (new & PCI_EXP_RTCTL_PMEIE) << 3;
-		advk_writel(pcie, new, PCIE_ISR0_MASK_REG);
+	case PCI_EXP_RTCTL: {
+		/* Only mask/unmask PME interrupt */
+		u32 val = advk_readl(pcie, PCIE_ISR0_MASK_REG) &
+			~PCIE_MSG_PM_PME_MASK;
+		if ((new & PCI_EXP_RTCTL_PMEIE) == 0)
+			val |= PCIE_MSG_PM_PME_MASK;
+		advk_writel(pcie, val, PCIE_ISR0_MASK_REG);
 		break;
+	}
 
 	case PCI_EXP_RTSTA:
 		new = (new & PCI_EXP_RTSTA_PME) >> 9;
-- 
2.20.1

