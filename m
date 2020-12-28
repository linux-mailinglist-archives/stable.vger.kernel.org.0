Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF54A2E4317
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392802AbgL1PaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405270AbgL1Nzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A89F20738;
        Mon, 28 Dec 2020 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163722;
        bh=vKJEEavUqiwWARyaFuY3POU2VLY36L6c7UMlIw4nYdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvvYo0uT29fGkdDEaT8I1YNC+J1+J79MIl0qmrp9OjYnJ6/dc5JBvUA3Qj1A6pQNO
         klBtBmPxvgBIXte4W4N16snvf/X8JRjnDLAL5SEpapihokBV/+TTt4P79c0fmsFe6p
         sEIyil4pZNtQKlBoEDp1MbB5H4hj6ZMewuWdwBbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 386/453] powerpc/powernv/npu: Do not attempt NPU2 setup on POWER8NVL NPU
Date:   Mon, 28 Dec 2020 13:50:22 +0100
Message-Id: <20201228124955.776411762@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit b1198a88230f2ce50c271e22b82a8b8610b2eea9 upstream.

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
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201122073828.15446-1-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/npu-dma.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/powernv/npu-dma.c
+++ b/arch/powerpc/platforms/powernv/npu-dma.c
@@ -384,7 +384,8 @@ static void pnv_npu_peers_take_ownership
 	for (i = 0; i < npucomp->pe_num; ++i) {
 		struct pnv_ioda_pe *pe = npucomp->pe[i];
 
-		if (!pe->table_group.ops->take_ownership)
+		if (!pe->table_group.ops ||
+		    !pe->table_group.ops->take_ownership)
 			continue;
 		pe->table_group.ops->take_ownership(&pe->table_group);
 	}
@@ -400,7 +401,8 @@ static void pnv_npu_peers_release_owners
 	for (i = 0; i < npucomp->pe_num; ++i) {
 		struct pnv_ioda_pe *pe = npucomp->pe[i];
 
-		if (!pe->table_group.ops->release_ownership)
+		if (!pe->table_group.ops ||
+		    !pe->table_group.ops->release_ownership)
 			continue;
 		pe->table_group.ops->release_ownership(&pe->table_group);
 	}
@@ -560,6 +562,11 @@ int pnv_npu2_map_lpar_dev(struct pci_dev
 		return -ENODEV;
 
 	hose = pci_bus_to_host(npdev->bus);
+	if (hose->npu == NULL) {
+		dev_info_once(&npdev->dev, "Nvlink1 does not support contexts");
+		return 0;
+	}
+
 	nphb = hose->private_data;
 
 	dev_dbg(&gpdev->dev, "Map LPAR opalid=%llu lparid=%u\n",
@@ -607,6 +614,11 @@ int pnv_npu2_unmap_lpar_dev(struct pci_d
 		return -ENODEV;
 
 	hose = pci_bus_to_host(npdev->bus);
+	if (hose->npu == NULL) {
+		dev_info_once(&npdev->dev, "Nvlink1 does not support contexts");
+		return 0;
+	}
+
 	nphb = hose->private_data;
 
 	dev_dbg(&gpdev->dev, "destroy context opalid=%llu\n",


