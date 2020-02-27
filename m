Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810E01720DE
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgB0NqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730479AbgB0NqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:46:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C96F24688;
        Thu, 27 Feb 2020 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811170;
        bh=bIf95kZnLc3+y5zExJSXS8q9b3BILGJr9WtD4CXywB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpzdiX47vP8FRlExeKIS9zffatJMLitWRUskDG1MfuOt1ynZdXxoMrIOvrpW1ZpAC
         bJPIrI85vaAWv2E0er2MPAPx1Vv0yYDwamAe1hCdQWHGNfNq2w+JV7w6D/Fc2vixKH
         kTkDNHnMEPnHEsY/wR5nTe/wCmuyjYgF3clJXf+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 029/165] powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid PE number
Date:   Thu, 27 Feb 2020 14:35:03 +0100
Message-Id: <20200227132235.176134459@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 3b5b9997b331e77ce967eba2c4bc80dc3134a7fe ]

On pseries there is a bug with adding hotplugged devices to an IOMMU
group. For a number of dumb reasons fixing that bug first requires
re-working how VFs are configured on PowerNV. For background, on
PowerNV we use the pcibios_sriov_enable() hook to do two things:

  1. Create a pci_dn structure for each of the VFs, and
  2. Configure the PHB's internal BARs so the MMIO range for each VF
     maps to a unique PE.

Roughly speaking a PE is the hardware counterpart to a Linux IOMMU
group since all the devices in a PE share the same IOMMU table. A PE
also defines the set of devices that should be isolated in response to
a PCI error (i.e. bad DMA, UR/CA, AER events, etc). When isolated all
MMIO and DMA traffic to and from devicein the PE is blocked by the
root complex until the PE is recovered by the OS.

The requirement to block MMIO causes a giant headache because the P8
PHB generally uses a fixed mapping between MMIO addresses and PEs. As
a result we need to delay configuring the IOMMU groups for device
until after MMIO resources are assigned. For physical devices (i.e.
non-VFs) the PE assignment is done in pcibios_setup_bridge() which is
called immediately after the MMIO resources for downstream
devices (and the bridge's windows) are assigned. For VFs the setup is
more complicated because:

  a) pcibios_setup_bridge() is not called again when VFs are activated, and
  b) The pci_dev for VFs are created by generic code which runs after
     pcibios_sriov_enable() is called.

The work around for this is a two step process:

  1. A fixup in pcibios_add_device() is used to initialised the cached
     pe_number in pci_dn, then
  2. A bus notifier then adds the device to the IOMMU group for the PE
     specified in pci_dn->pe_number.

A side effect fixing the pseries bug mentioned in the first paragraph
is moving the fixup out of pcibios_add_device() and into
pcibios_bus_add_device(), which is called much later. This results in
step 2. failing because pci_dn->pe_number won't be initialised when
the bus notifier is run.

We can fix this by removing the need for the fixup. The PE for a VF is
known before the VF is even scanned so we can initialise
pci_dn->pe_number pcibios_sriov_enable() instead. Unfortunately,
moving the initialisation causes two problems:

  1. We trip the WARN_ON() in the current fixup code, and
  2. The EEH core clears pdn->pe_number when recovering a VF and
     relies on the fixup to correctly re-set it.

The only justification for either of these is a comment in
eeh_rmv_device() suggesting that pdn->pe_number *must* be set to
IODA_INVALID_PE in order for the VF to be scanned. However, this
comment appears to have no basis in reality. Both bugs can be fixed by
just deleting the code.

Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191028085424.12006-1-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c          |  6 ------
 arch/powerpc/platforms/powernv/pci-ioda.c | 19 +++++++++++++++----
 arch/powerpc/platforms/powernv/pci.c      |  4 ----
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 620e08d4eb6e2..adac3dee4c57e 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -520,12 +520,6 @@ static void *eeh_rmv_device(void *data, void *userdata)
 
 		pci_iov_remove_virtfn(edev->physfn, pdn->vf_index, 0);
 		edev->pdev = NULL;
-
-		/*
-		 * We have to set the VF PE number to invalid one, which is
-		 * required to plug the VF successfully.
-		 */
-		pdn->pe_number = IODA_INVALID_PE;
 #endif
 		if (rmv_data)
 			list_add(&edev->rmv_list, &rmv_data->edev_list);
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 3ec673b4ca6ce..b787a669a1e27 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1524,6 +1524,10 @@ static void pnv_ioda_setup_vf_PE(struct pci_dev *pdev, u16 num_vfs)
 
 	/* Reserve PE for each VF */
 	for (vf_index = 0; vf_index < num_vfs; vf_index++) {
+		int vf_devfn = pci_iov_virtfn_devfn(pdev, vf_index);
+		int vf_bus = pci_iov_virtfn_bus(pdev, vf_index);
+		struct pci_dn *vf_pdn;
+
 		if (pdn->m64_single_mode)
 			pe_num = pdn->pe_num_map[vf_index];
 		else
@@ -1536,13 +1540,11 @@ static void pnv_ioda_setup_vf_PE(struct pci_dev *pdev, u16 num_vfs)
 		pe->pbus = NULL;
 		pe->parent_dev = pdev;
 		pe->mve_number = -1;
-		pe->rid = (pci_iov_virtfn_bus(pdev, vf_index) << 8) |
-			   pci_iov_virtfn_devfn(pdev, vf_index);
+		pe->rid = (vf_bus << 8) | vf_devfn;
 
 		pe_info(pe, "VF %04d:%02d:%02d.%d associated with PE#%d\n",
 			hose->global_number, pdev->bus->number,
-			PCI_SLOT(pci_iov_virtfn_devfn(pdev, vf_index)),
-			PCI_FUNC(pci_iov_virtfn_devfn(pdev, vf_index)), pe_num);
+			PCI_SLOT(vf_devfn), PCI_FUNC(vf_devfn), pe_num);
 
 		if (pnv_ioda_configure_pe(phb, pe)) {
 			/* XXX What do we do here ? */
@@ -1556,6 +1558,15 @@ static void pnv_ioda_setup_vf_PE(struct pci_dev *pdev, u16 num_vfs)
 		list_add_tail(&pe->list, &phb->ioda.pe_list);
 		mutex_unlock(&phb->ioda.pe_list_mutex);
 
+		/* associate this pe to it's pdn */
+		list_for_each_entry(vf_pdn, &pdn->parent->child_list, list) {
+			if (vf_pdn->busno == vf_bus &&
+			    vf_pdn->devfn == vf_devfn) {
+				vf_pdn->pe_number = pe_num;
+				break;
+			}
+		}
+
 		pnv_pci_ioda2_setup_dma_pe(phb, pe);
 	}
 }
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 00dbf1e895a9d..2ed7627e991e0 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -856,16 +856,12 @@ void pnv_pci_dma_dev_setup(struct pci_dev *pdev)
 	struct pnv_phb *phb = hose->private_data;
 #ifdef CONFIG_PCI_IOV
 	struct pnv_ioda_pe *pe;
-	struct pci_dn *pdn;
 
 	/* Fix the VF pdn PE number */
 	if (pdev->is_virtfn) {
-		pdn = pci_get_pdn(pdev);
-		WARN_ON(pdn->pe_number != IODA_INVALID_PE);
 		list_for_each_entry(pe, &phb->ioda.pe_list, list) {
 			if (pe->rid == ((pdev->bus->number << 8) |
 			    (pdev->devfn & 0xff))) {
-				pdn->pe_number = pe->pe_number;
 				pe->pdev = pdev;
 				break;
 			}
-- 
2.20.1



