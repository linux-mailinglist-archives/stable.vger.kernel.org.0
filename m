Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E732012D5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403995AbgFSPOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392321AbgFSPOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:14:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0357C206FA;
        Fri, 19 Jun 2020 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579679;
        bh=ByB9IenIoNleuTlJtrj9Ik5usSgTMC99u7MuaJbi6tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eP20uz2WT0KUIE6BR+33Riw2uegWSi0hSm2mQCYOXFv9sUR5LaIjrxQlNKgLrSUel
         VOtw2aanraU/+ID8OZzZJIhNZFKFOJCKJiHTCdKPLFRVAI7bfBHboycFkd3QeQXufn
         0i+o9YSPBpxKdVMb0IzCjuZorwmK21RQVzdoakAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 195/261] PCI: Program MPS for RCiEP devices
Date:   Fri, 19 Jun 2020 16:33:26 +0200
Message-Id: <20200619141659.241068983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

commit aa0ce96d72dd2e1b0dfd0fb868f82876e7790878 upstream.

Root Complex Integrated Endpoints (RCiEPs) do not have an upstream bridge,
so pci_configure_mps() previously ignored them, which may result in reduced
performance.

Instead, program the Max_Payload_Size of RCiEPs to the maximum supported
value (unless it is limited for the PCIE_BUS_PEER2PEER case).  This also
affects the subsequent programming of Max_Read_Request_Size because Linux
programs MRRS based on the MPS value.

Fixes: 9dae3a97297f ("PCI: Move MPS configuration check to pci_configure_device()")
Link: https://lore.kernel.org/r/1585343775-4019-1-git-send-email-ashok.raj@intel.com
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1889,13 +1889,33 @@ static void pci_configure_mps(struct pci
 	struct pci_dev *bridge = pci_upstream_bridge(dev);
 	int mps, mpss, p_mps, rc;
 
-	if (!pci_is_pcie(dev) || !bridge || !pci_is_pcie(bridge))
+	if (!pci_is_pcie(dev))
 		return;
 
 	/* MPS and MRRS fields are of type 'RsvdP' for VFs, short-circuit out */
 	if (dev->is_virtfn)
 		return;
 
+	/*
+	 * For Root Complex Integrated Endpoints, program the maximum
+	 * supported value unless limited by the PCIE_BUS_PEER2PEER case.
+	 */
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_RC_END) {
+		if (pcie_bus_config == PCIE_BUS_PEER2PEER)
+			mps = 128;
+		else
+			mps = 128 << dev->pcie_mpss;
+		rc = pcie_set_mps(dev, mps);
+		if (rc) {
+			pci_warn(dev, "can't set Max Payload Size to %d; if necessary, use \"pci=pcie_bus_safe\" and report a bug\n",
+				 mps);
+		}
+		return;
+	}
+
+	if (!bridge || !pci_is_pcie(bridge))
+		return;
+
 	mps = pcie_get_mps(dev);
 	p_mps = pcie_get_mps(bridge);
 


