Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACA19604A
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 22:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgC0VQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 17:16:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:7152 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgC0VQT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 17:16:19 -0400
IronPort-SDR: g+lgqZGcwJ6k9p0wm5HVYOdx96f4e41rmUbciPgegZmRw78Z/h16vbxxW/1OGU7Gw7ZvytOpq6
 U/R4TaSEL73g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2020 14:16:19 -0700
IronPort-SDR: rV7hqmr13pWJuQkiYhYbSJXKKHrwVG0cAM+xP1wWQgv8sVrOS6I1VcXCqR+FEJ6aezxiHIIFZq
 bKkm1znzny2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,313,1580803200"; 
   d="scan'208";a="282971379"
Received: from otc-nc-03.jf.intel.com ([10.54.39.25])
  by fmsmga002.fm.intel.com with ESMTP; 27 Mar 2020 14:16:18 -0700
From:   Ashok Raj <ashok.raj@intel.com>
To:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Cc:     Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] pci: Fixes MaxPayloadSize (MPS) programming for RCiEP devices.
Date:   Fri, 27 Mar 2020 14:16:15 -0700
Message-Id: <1585343775-4019-1-git-send-email-ashok.raj@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Root Complex Integrated devices (RCiEP) do not have a Root Port before the
device. pci_configure_mps() should simply stick the max value for MaxPayload
size in Device Control, and for MaxReadReq. Unless pcie=pcie_bus-peer2peer
is used in kernel commandline PCIE_BUS_PEER2PEER.

When MPS is configured lower, it could result in reduced performance.

Fixes: 9dae3a97297f ("PCI: Move MPS configuration check to pci_configure_device()")
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: Ashok Raj <ashok.raj@intel.com>
---
 drivers/pci/probe.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index eeff8a07..a738b1c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1895,13 +1895,34 @@ static void pci_configure_mps(struct pci_dev *dev)
 	struct pci_dev *bridge = pci_upstream_bridge(dev);
 	int mps, mpss, p_mps, rc;
 
-	if (!pci_is_pcie(dev) || !bridge || !pci_is_pcie(bridge))
+	if (!pci_is_pcie(dev))
 		return;
 
 	/* MPS and MRRS fields are of type 'RsvdP' for VFs, short-circuit out */
 	if (dev->is_virtfn)
 		return;
 
+	/*
+	 * If this is a Root Complex Integrated Endpoint
+	 * Simply program the max value from DEVCAP. No additional
+	 * Lookup is necessary
+	 */
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_RC_END) {
+		if (pcie_bus_config == PCIE_BUS_PEER2PEER)
+			mps = 128;
+		else
+			mps = 128 << dev->pcie_mpss;
+		rc = pcie_set_mps(dev, mps);
+		if (rc) {
+			pci_warn(dev, "can't set Max Payload Size to %d; if necessary, use \"pci=pcie_bus_safe\" and report a bug\n",
+			 mps);
+			return;
+		}
+	}
+
+	if (!bridge || !pci_is_pcie(bridge))
+		return;
+
 	mps = pcie_get_mps(dev);
 	p_mps = pcie_get_mps(bridge);
 
-- 
2.7.4

