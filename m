Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB14620DF32
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbgF2UdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732325AbgF2TZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD56253A6;
        Mon, 29 Jun 2020 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445272;
        bh=FErfLAtSgFwdrckrYiDutcgWgLZ2rUZ1zmULEUoVWeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZH0839D1CFQqk2LHe1n0u/A2yUnGqlOlM7xyz9P2d9Y96cn3p3cEQXyCc5/m7EgSg
         Jx2jOv53qk3Yglb9Hd2QvXwHtaCFETEswZxHVQwWqFVcD8xwS00kx++IoYAzmdVaIJ
         K7qwxX68XkHYXg5SCwaEl0DHVYbKmMYflZTSU548=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Aditya Paluri <Venkata.AdityaPaluri@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/191] PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port
Date:   Mon, 29 Jun 2020 11:37:47 -0400
Message-Id: <20200629154007.2495120-52-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
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
index 3008bba360f35..ec6f6213960b4 100644
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

