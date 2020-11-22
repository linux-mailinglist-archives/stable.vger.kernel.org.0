Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A104F2BC471
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 08:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgKVHr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 02:47:58 -0500
Received: from ozlabs.ru ([107.174.27.60]:33690 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgKVHr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 02:47:58 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2020 02:47:57 EST
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 81FF8AE800EC;
        Sun, 22 Nov 2020 02:38:38 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org,
        =?UTF-8?q?Leonardo=20Augusto=20Guimar=C3=A3es=20Garcia?= 
        <lagarcia@br.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
        stable@vger.kernel.org
Subject: [PATCH kernel v2] powerpc/powernv/npu: Do not attempt NPU2 setup on POWER8NVL NPU
Date:   Sun, 22 Nov 2020 18:38:28 +1100
Message-Id: <20201122073828.15446-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We execute certain NPU2 setup code (such as mapping an LPID to a device
in NPU2) unconditionally if an Nvlink bridge is detected. However this
cannot succeed on POWER8NVL machines and errors appear in dmesg. This is
harmless as skiboot returns an error and the only place we check it is
vfio-pci but that code does not get called on P8+ either.

This adds a check if pnv_npu2_xxx helpers are called on a machine with
NPU2 which initializes pnv_phb::npu in pnv_npu2_init();
pnv_phb::npu==NULL on POWER8/NVL (Naples).

While at this, fix NULL derefencing in pnv_npu_peers_take_ownership/
pnv_npu_peers_release_ownership which occurs when GPUs on mentioned P8s
cause EEH which happens if "vfio-pci" disables devices using
the D3 power state; the vfio-pci's disable_idle_d3 module parameter
controls this and must be set on Naples. The EEH handling clears
the entire pnv_ioda_pe struct in pnv_ioda_free_pe() hence
the NULL derefencing. We cannot recover from that but at least we stop
crashing.

Tested on
- POWER9 pvr=004e1201, Ubuntu 19.04 host, Ubuntu 18.04 vm,
  NVIDIA GV100 10de:1db1 driver 418.39
- POWER8 pvr=004c0100, RHEL 7.6 host, Ubuntu 16.10 vm,
  NVIDIA P100 10de:15f9 driver 396.47

Fixes: 1b785611e119 ("powerpc/powernv/npu: Add release_ownership hook")
Cc: stable@vger.kernel.org # 5.0
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v2:
* added checks for !pe->table_group.ops and updated commit log
* added tested configurations
---
 arch/powerpc/platforms/powernv/npu-dma.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/npu-dma.c b/arch/powerpc/platforms/powernv/npu-dma.c
index abeaa533b976..b711dc3262a3 100644
--- a/arch/powerpc/platforms/powernv/npu-dma.c
+++ b/arch/powerpc/platforms/powernv/npu-dma.c
@@ -385,7 +385,8 @@ static void pnv_npu_peers_take_ownership(struct iommu_table_group *table_group)
 	for (i = 0; i < npucomp->pe_num; ++i) {
 		struct pnv_ioda_pe *pe = npucomp->pe[i];
 
-		if (!pe->table_group.ops->take_ownership)
+		if (!pe->table_group.ops ||
+		    !pe->table_group.ops->take_ownership)
 			continue;
 		pe->table_group.ops->take_ownership(&pe->table_group);
 	}
@@ -401,7 +402,8 @@ static void pnv_npu_peers_release_ownership(
 	for (i = 0; i < npucomp->pe_num; ++i) {
 		struct pnv_ioda_pe *pe = npucomp->pe[i];
 
-		if (!pe->table_group.ops->release_ownership)
+		if (!pe->table_group.ops ||
+		    !pe->table_group.ops->release_ownership)
 			continue;
 		pe->table_group.ops->release_ownership(&pe->table_group);
 	}
@@ -623,6 +625,11 @@ int pnv_npu2_map_lpar_dev(struct pci_dev *gpdev, unsigned int lparid,
 		return -ENODEV;
 
 	hose = pci_bus_to_host(npdev->bus);
+	if (hose->npu == NULL) {
+		dev_info_once(&npdev->dev, "Nvlink1 does not support contexts");
+		return 0;
+	}
+
 	nphb = hose->private_data;
 
 	dev_dbg(&gpdev->dev, "Map LPAR opalid=%llu lparid=%u\n",
@@ -670,6 +677,11 @@ int pnv_npu2_unmap_lpar_dev(struct pci_dev *gpdev)
 		return -ENODEV;
 
 	hose = pci_bus_to_host(npdev->bus);
+	if (hose->npu == NULL) {
+		dev_info_once(&npdev->dev, "Nvlink1 does not support contexts");
+		return 0;
+	}
+
 	nphb = hose->private_data;
 
 	dev_dbg(&gpdev->dev, "destroy context opalid=%llu\n",
-- 
2.17.1

