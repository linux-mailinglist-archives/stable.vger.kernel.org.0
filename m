Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2411674D9
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbgBUISG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:18:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbgBUISG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D7FF24689;
        Fri, 21 Feb 2020 08:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273085;
        bh=prr9loutUhzcxUyUY0QhUlgVNDxML2mvrs3HklSUOkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHpqt7vDWCd58s2CSHZ5mVlTiizI94zHtwaz/p/UVACEDNXGhSrnjnJB2z5Q5/KEw
         tJC8Ng8AWGqdvVDD5EEi1N9VA7Wb+8/kern1xeKlMaV73g/3xCzMUl521/RAgo54I+
         iJMSBdZ1MMP8uC2TdQ5L8X+nkGU57G8VvT8yO6WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/191] powerpc/iov: Move VF pdev fixup into pcibios_fixup_iov()
Date:   Fri, 21 Feb 2020 08:40:13 +0100
Message-Id: <20200221072256.370855841@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit 965c94f309be58fbcc6c8d3e4f123376c5970d79 ]

An ioda_pe for each VF is allocated in pnv_pci_sriov_enable() before
the pci_dev for the VF is created. We need to set the pe->pdev pointer
at some point after the pci_dev is created. Currently we do that in:

pcibios_bus_add_device()
	pnv_pci_dma_dev_setup() (via phb->ops.dma_dev_setup)
		/* fixup is done here */
		pnv_pci_ioda_dma_dev_setup() (via pnv_phb->dma_dev_setup)

The fixup needs to be done before setting up DMA for for the VF's PE,
but there's no real reason to delay it until this point. Move the
fixup into pnv_pci_ioda_fixup_iov() so the ordering is:

	pcibios_add_device()
		pnv_pci_ioda_fixup_iov() (via ppc_md.pcibios_fixup_sriov)

	pcibios_bus_add_device()
		...

This isn't strictly required, but it's a slightly more logical place
to do the fixup and it simplifies pnv_pci_dma_dev_setup().

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200110070207.439-4-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 29 +++++++++++++++++++----
 arch/powerpc/platforms/powernv/pci.c      | 14 -----------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 28adfe4dd04c5..ecd211c5f24a5 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -3015,9 +3015,6 @@ static void pnv_pci_ioda_fixup_iov_resources(struct pci_dev *pdev)
 	struct pci_dn *pdn;
 	int mul, total_vfs;
 
-	if (!pdev->is_physfn || pci_dev_is_added(pdev))
-		return;
-
 	pdn = pci_get_pdn(pdev);
 	pdn->vfs_expanded = 0;
 	pdn->m64_single_mode = false;
@@ -3092,6 +3089,30 @@ truncate_iov:
 		res->end = res->start - 1;
 	}
 }
+
+static void pnv_pci_ioda_fixup_iov(struct pci_dev *pdev)
+{
+	if (WARN_ON(pci_dev_is_added(pdev)))
+		return;
+
+	if (pdev->is_virtfn) {
+		struct pnv_ioda_pe *pe = pnv_ioda_get_pe(pdev);
+
+		/*
+		 * VF PEs are single-device PEs so their pdev pointer needs to
+		 * be set. The pdev doesn't exist when the PE is allocated (in
+		 * (pcibios_sriov_enable()) so we fix it up here.
+		 */
+		pe->pdev = pdev;
+		WARN_ON(!(pe->flags & PNV_IODA_PE_VF));
+	} else if (pdev->is_physfn) {
+		/*
+		 * For PFs adjust their allocated IOV resources to match what
+		 * the PHB can support using it's M64 BAR table.
+		 */
+		pnv_pci_ioda_fixup_iov_resources(pdev);
+	}
+}
 #endif /* CONFIG_PCI_IOV */
 
 static void pnv_ioda_setup_pe_res(struct pnv_ioda_pe *pe,
@@ -3985,7 +4006,7 @@ static void __init pnv_pci_init_ioda_phb(struct device_node *np,
 	ppc_md.pcibios_default_alignment = pnv_pci_default_alignment;
 
 #ifdef CONFIG_PCI_IOV
-	ppc_md.pcibios_fixup_sriov = pnv_pci_ioda_fixup_iov_resources;
+	ppc_md.pcibios_fixup_sriov = pnv_pci_ioda_fixup_iov;
 	ppc_md.pcibios_iov_resource_alignment = pnv_pci_iov_resource_alignment;
 	ppc_md.pcibios_sriov_enable = pnv_pcibios_sriov_enable;
 	ppc_md.pcibios_sriov_disable = pnv_pcibios_sriov_disable;
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index aa95b8e0f66ad..b6fa900af5da5 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -820,20 +820,6 @@ void pnv_pci_dma_dev_setup(struct pci_dev *pdev)
 {
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	struct pnv_phb *phb = hose->private_data;
-#ifdef CONFIG_PCI_IOV
-	struct pnv_ioda_pe *pe;
-
-	/* Fix the VF pdn PE number */
-	if (pdev->is_virtfn) {
-		list_for_each_entry(pe, &phb->ioda.pe_list, list) {
-			if (pe->rid == ((pdev->bus->number << 8) |
-			    (pdev->devfn & 0xff))) {
-				pe->pdev = pdev;
-				break;
-			}
-		}
-	}
-#endif /* CONFIG_PCI_IOV */
 
 	if (phb && phb->dma_dev_setup)
 		phb->dma_dev_setup(phb, pdev);
-- 
2.20.1



