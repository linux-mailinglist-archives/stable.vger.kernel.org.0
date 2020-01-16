Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC20013FD4C
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387565AbgAPXYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:24:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387458AbgAPXYX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:24:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BDA20748;
        Thu, 16 Jan 2020 23:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217062;
        bh=G7Vn/wR8G1zNHog83gz8Z834b+7wTpHqWwsVwuhIQrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1fa8Cp4msOqOzy5P50B/qgB/wmfdgkCuCkhkhssxAkDbMH4Uw/dJUr2FUDthCOjX
         b6J4EsLFJXc45y/yGwVUizv6BsWfB7XmGaRT2++RaDqLnH2gL8slA4OXqBz0o5DVVb
         Kb6epHA+62a76RaV3H+yzPILHT2j2s7QGxOfdyao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 5.4 132/203] PCI: aardvark: Use LTSSM state to build link training flag
Date:   Fri, 17 Jan 2020 00:17:29 +0100
Message-Id: <20200116231756.662872344@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

commit 364b3f1ff8f096d45f042a9c85daf7a1fc78413e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/pci-aardvark.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -180,6 +180,8 @@
 #define LINK_WAIT_MAX_RETRIES		10
 #define LINK_WAIT_USLEEP_MIN		90000
 #define LINK_WAIT_USLEEP_MAX		100000
+#define RETRAIN_WAIT_MAX_RETRIES	10
+#define RETRAIN_WAIT_USLEEP_US		2000
 
 #define MSI_IRQ_NUM			32
 
@@ -239,6 +241,17 @@ static int advk_pcie_wait_for_link(struc
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
@@ -426,11 +439,20 @@ advk_pci_bridge_emul_pcie_conf_read(stru
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
@@ -447,8 +469,13 @@ advk_pci_bridge_emul_pcie_conf_write(str
 
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


