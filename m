Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F2115E817
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393691AbgBNQ5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404526AbgBNQRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5B62468E;
        Fri, 14 Feb 2020 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697058;
        bh=8InE86H468oaSvZmmcITyyVP/obxoGRHX02l4sK1+fQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4SPFqwT7vhsoGmjAMBTr5KPhwsjXdc26hf08qp5sDbGwYlsVC3/IMwl6zavPzDsQ
         vSj0UNhZF/ntP5AKwOZTnylFOWFnbnatvAheJx8oOViFgGfz8KfNLWN1zQh/B7p8a3
         rLJoNXiefttcXvYwKSM2JMDJ4assR2h2hzRp36N4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver O'Halloran <oohall@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 017/186] powerpc/powernv/iov: Ensure the pdn for VFs always contains a valid PE number
Date:   Fri, 14 Feb 2020 11:14:26 -0500
Message-Id: <20200214161715.18113-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 470284f9e4f66..5a48c93aaa1b3 100644
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
index d3d5796f7df60..36ef504eeab32 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1523,6 +1523,10 @@ static void pnv_ioda_setup_vf_PE(struct pci_dev *pdev, u16 num_vfs)
 
 	/* Reserve PE for each VF */
 	for (vf_index = 0; vf_index < num_vfs; vf_index++) {
+		int vf_devfn = pci_iov_virtfn_devfn(pdev, vf_index);
+		int vf_bus = pci_iov_virtfn_bus(pdev, vf_index);
+		struct pci_dn *vf_pdn;
+
 		if (pdn->m64_single_mode)
 			pe_num = pdn->pe_num_map[vf_index];
 		else
@@ -1535,13 +1539,11 @@ static void pnv_ioda_setup_vf_PE(struct pci_dev *pdev, u16 num_vfs)
 		pe->pbus = NULL;
 		pe->parent_dev = pdev;
 		pe->mve_number = -1;
-		pe->rid = (pci_iov_virtfn_bus(pdev, vf_index) << 8) |
-			   pci_iov_virtfn_devfn(pdev, vf_index);
+		pe->rid = (vf_bus << 8) | vf_devfn;
 
 		pe_info(pe, "VF %04d:%02d:%02d.%d associated with PE#%x\n",
 			hose->global_number, pdev->bus->number,
-			PCI_SLOT(pci_iov_virtfn_devfn(pdev, vf_index)),
-			PCI_FUNC(pci_iov_virtfn_devfn(pdev, vf_index)), pe_num);
+			PCI_SLOT(vf_devfn), PCI_FUNC(vf_devfn), pe_num);
 
 		if (pnv_ioda_configure_pe(phb, pe)) {
 			/* XXX What do we do here ? */
@@ -1555,6 +1557,15 @@ static void pnv_ioda_setup_vf_PE(struct pci_dev *pdev, u16 num_vfs)
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
index 961c131a5b7e8..844ca1886063b 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -978,16 +978,12 @@ void pnv_pci_dma_dev_setup(struct pci_dev *pdev)
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

