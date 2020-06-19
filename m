Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067D620110E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393659AbgFSP24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393650AbgFSP2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:28:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDF721941;
        Fri, 19 Jun 2020 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580534;
        bh=eSdH4ZAfWrNI/AJwttCSABF3KDnoMDsC/kislijVpgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzVCTmtXRDfayRCooykMbriRHxyEqnuX1bnQk7Yjl+iteZrzCGssqSF5l1ODl8PXZ
         a6X2LLfLXXvctpe0tf9tmUo/TzPfE2BWUo89dAO+PWKOPF+kjymvmM91XIg7vEiLXy
         IDjA0xf2GuC4eaEpfaR4oI17cEgAsWXkWgALm1nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Darrel Goeddel <dgoeddel@forcepoint.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Romil Sharma <rsharma@forcepoint.com>,
        Sasha Levin <sashal@kernel.org>,
        Mark Scott <mscott@forcepoint.com>
Subject: [PATCH 5.7 287/376] PCI: Add ACS quirk for Intel Root Complex Integrated Endpoints
Date:   Fri, 19 Jun 2020 16:33:25 +0200
Message-Id: <20200619141723.918159003@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit 3247bd10a4502a3075ce8e1c3c7d31ef76f193ce ]

All Intel platforms guarantee that all root complex implementations must
send transactions up to IOMMU for address translations. Hence for Intel
RCiEP devices, we can assume some ACS-type isolation even without an ACS
capability.

>From the Intel VT-d spec, r3.1, sec 3.16 ("Root-Complex Peer to Peer
Considerations"):

  When DMA remapping is enabled, peer-to-peer requests through the
  Root-Complex must be handled as follows:

  - The input address in the request is translated (through first-level,
    second-level or nested translation) to a host physical address (HPA).
    The address decoding for peer addresses must be done only on the
    translated HPA. Hardware implementations are free to further limit
    peer-to-peer accesses to specific host physical address regions (or
    to completely disallow peer-forwarding of translated requests).

  - Since address translation changes the contents (address field) of
    the PCI Express Transaction Layer Packet (TLP), for PCI Express
    peer-to-peer requests with ECRC, the Root-Complex hardware must use
    the new ECRC (re-computed with the translated address) if it
    decides to forward the TLP as a peer request.

  - Root-ports, and multi-function root-complex integrated endpoints, may
    support additional peer-to-peer control features by supporting PCI
    Express Access Control Services (ACS) capability. Refer to ACS
    capability in PCI Express specifications for details.

Since Linux didn't give special treatment to allow this exception, certain
RCiEP MFD devices were grouped in a single IOMMU group. This doesn't permit
a single device to be assigned to a guest for instance.

In one vendor system: Device 14.x were grouped in a single IOMMU group.

  /sys/kernel/iommu_groups/5/devices/0000:00:14.0
  /sys/kernel/iommu_groups/5/devices/0000:00:14.2
  /sys/kernel/iommu_groups/5/devices/0000:00:14.3

After this patch:

  /sys/kernel/iommu_groups/5/devices/0000:00:14.0
  /sys/kernel/iommu_groups/5/devices/0000:00:14.2
  /sys/kernel/iommu_groups/6/devices/0000:00:14.3 <<< new group

14.0 and 14.2 are integrated devices, but legacy end points, whereas 14.3
was a PCIe-compliant RCiEP.

  00:14.3 Network controller: Intel Corporation Device 9df0 (rev 30)
    Capabilities: [40] Express (v2) Root Complex Integrated Endpoint, MSI 00

This permits assigning this device to a guest VM.

[bhelgaas: drop "Fixes" tag since this doesn't fix a bug in that commit]
Link: https://lore.kernel.org/r/1590699462-7131-1-git-send-email-ashok.raj@intel.com
Tested-by: Darrel Goeddel <dgoeddel@forcepoint.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Mark Scott <mscott@forcepoint.com>,
Cc: Romil Sharma <rsharma@forcepoint.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 226a4c5b2b7a..5067562924f0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4682,6 +4682,20 @@ static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
 }
 
+static int pci_quirk_rciep_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	/*
+	 * Intel RCiEP's are required to allow p2p only on translated
+	 * addresses.  Refer to Intel VT-d specification, r3.1, sec 3.16,
+	 * "Root-Complex Peer to Peer Considerations".
+	 */
+	if (pci_pcie_type(dev) != PCI_EXP_TYPE_RC_END)
+		return -ENOTTY;
+
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+}
+
 static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	/*
@@ -4764,6 +4778,7 @@ static const struct pci_dev_acs_enabled {
 	/* I219 */
 	{ PCI_VENDOR_ID_INTEL, 0x15b7, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_INTEL, 0x15b8, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_quirk_rciep_acs },
 	/* QCOM QDF2xxx root ports */
 	{ PCI_VENDOR_ID_QCOM, 0x0400, pci_quirk_qcom_rp_acs },
 	{ PCI_VENDOR_ID_QCOM, 0x0401, pci_quirk_qcom_rp_acs },
-- 
2.25.1



