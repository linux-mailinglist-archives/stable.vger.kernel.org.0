Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918CA1FE0BF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731884AbgFRBuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731255AbgFRB1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3233C21D7F;
        Thu, 18 Jun 2020 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443649;
        bh=kQxud7MSwkmirSk8sl1Z6U/M4EKYnQvsC+GuLnHvsI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fh/1bsQASezuocS2xTKMXq2INjT3crYvwIGnooAKL6OlObmjH+F3kRTMJ6gqYDacP
         jG3OnNhZR4G6PZmfCjXp74sN+cNxr1/MSK9wrxmNHlatzivGiUswIypYC9kW6x/cmk
         UOj4Ay8nrIIklkTpiIzhAsMu7DOAA+qdDIOqlSgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Aditya Paluri <Venkata.AdityaPaluri@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 070/108] PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port
Date:   Wed, 17 Jun 2020 21:25:22 -0400
Message-Id: <20200618012600.608744-70-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 7b38fd9760f51cc83d80eed2cfbde8b5ead9e93a ]

Except for Endpoints, we enable PTM at enumeration-time.  Previously we did
not account for the fact that Switch Downstream Ports are not permitted to
have a PTM capability; their PTM behavior is controlled by the Upstream
Port (PCIe r5.0, sec 7.9.16).  Since Downstream Ports don't have a PTM
capability, we did not mark them as "ptm_enabled", which meant that
pci_enable_ptm() on an Endpoint failed because there was no PTM path to it.

Mark Downstream Ports as "ptm_enabled" if their Upstream Port has PTM
enabled.

Fixes: eec097d43100 ("PCI: Add pci_enable_ptm() for drivers to enable PTM on endpoints")
Reported-by: Aditya Paluri <Venkata.AdityaPaluri@synopsys.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/ptm.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index 3008bba360f3..ec6f6213960b 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -47,10 +47,6 @@ void pci_ptm_init(struct pci_dev *dev)
 	if (!pci_is_pcie(dev))
 		return;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_PTM);
-	if (!pos)
-		return;
-
 	/*
 	 * Enable PTM only on interior devices (root ports, switch ports,
 	 * etc.) on the assumption that it causes no link traffic until an
@@ -60,6 +56,23 @@ void pci_ptm_init(struct pci_dev *dev)
 	     pci_pcie_type(dev) == PCI_EXP_TYPE_RC_END))
 		return;
 
+	/*
+	 * Switch Downstream Ports are not permitted to have a PTM
+	 * capability; their PTM behavior is controlled by the Upstream
+	 * Port (PCIe r5.0, sec 7.9.16).
+	 */
+	ups = pci_upstream_bridge(dev);
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM &&
+	    ups && ups->ptm_enabled) {
+		dev->ptm_granularity = ups->ptm_granularity;
+		dev->ptm_enabled = 1;
+		return;
+	}
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_PTM);
+	if (!pos)
+		return;
+
 	pci_read_config_dword(dev, pos + PCI_PTM_CAP, &cap);
 	local_clock = (cap & PCI_PTM_GRANULARITY_MASK) >> 8;
 
@@ -69,7 +82,6 @@ void pci_ptm_init(struct pci_dev *dev)
 	 * the spec recommendation (PCIe r3.1, sec 7.32.3), select the
 	 * furthest upstream Time Source as the PTM Root.
 	 */
-	ups = pci_upstream_bridge(dev);
 	if (ups && ups->ptm_enabled) {
 		ctrl = PCI_PTM_CTRL_ENABLE;
 		if (ups->ptm_granularity == 0)
-- 
2.25.1

