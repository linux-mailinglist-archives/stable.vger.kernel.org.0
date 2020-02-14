Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD115F2CF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgBNPvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730645AbgBNPu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD8E22086A;
        Fri, 14 Feb 2020 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695458;
        bh=cu42WR0+nAkoUL15PmaEvSuhaBtJYzUD+mU1TS5OD/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUYHSakplW+L7PPowLaAe+j51BYPw9amWIB2pz3L7sX7rm5ilDmq94ehRcirOoB6z
         a8KScFBeheNPoX1ifRI3RiiMPVUvwaQG4fA1t6+ZqmvtLPlaXrPeiPwjbk+P7+HFR/
         9hcQDH6Vuq0oEPXNxESd05vPTE9ZaI2ZFwYCF4q0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.5 096/542] powerpc/powernv/ioda: Fix ref count for devices with their own PE
Date:   Fri, 14 Feb 2020 10:41:28 -0500
Message-Id: <20200214154854.6746-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit 05dd7da76986937fb288b4213b1fa10dbe0d1b33 ]

The pci_dn structure used to store a pointer to the struct pci_dev, so
taking a reference on the device was required. However, the pci_dev
pointer was later removed from the pci_dn structure, but the reference
was kept for the npu device.
See commit 902bdc57451c ("powerpc/powernv/idoa: Remove unnecessary
pcidev from pci_dn").

We don't need to take a reference on the device when assigning the PE
as the struct pnv_ioda_pe is cleaned up at the same time as
the (physical) device is released. Doing so prevents the device from
being released, which is a problem for opencapi devices, since we want
to be able to remove them through PCI hotplug.

Now the ugly part: nvlink npu devices are not meant to be
released. Because of the above, we've always leaked a reference and
simply removing it now is dangerous and would likely require more
work. There's currently no release device callback for nvlink devices
for example. So to be safe, this patch leaks a reference on the npu
device, but only for nvlink and not opencapi.

Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191121134918.7155-2-fbarrat@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 4374836b033b4..67b836f102402 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1062,14 +1062,13 @@ static struct pnv_ioda_pe *pnv_ioda_setup_dev_PE(struct pci_dev *dev)
 		return NULL;
 	}
 
-	/* NOTE: We get only one ref to the pci_dev for the pdn, not for the
-	 * pointer in the PE data structure, both should be destroyed at the
-	 * same time. However, this needs to be looked at more closely again
-	 * once we actually start removing things (Hotplug, SR-IOV, ...)
+	/* NOTE: We don't get a reference for the pointer in the PE
+	 * data structure, both the device and PE structures should be
+	 * destroyed at the same time. However, removing nvlink
+	 * devices will need some work.
 	 *
 	 * At some point we want to remove the PDN completely anyways
 	 */
-	pci_dev_get(dev);
 	pdn->pe_number = pe->pe_number;
 	pe->flags = PNV_IODA_PE_DEV;
 	pe->pdev = dev;
@@ -1084,7 +1083,6 @@ static struct pnv_ioda_pe *pnv_ioda_setup_dev_PE(struct pci_dev *dev)
 		pnv_ioda_free_pe(pe);
 		pdn->pe_number = IODA_INVALID_PE;
 		pe->pdev = NULL;
-		pci_dev_put(dev);
 		return NULL;
 	}
 
@@ -1205,6 +1203,14 @@ static struct pnv_ioda_pe *pnv_ioda_setup_npu_PE(struct pci_dev *npu_pdev)
 	struct pci_controller *hose = pci_bus_to_host(npu_pdev->bus);
 	struct pnv_phb *phb = hose->private_data;
 
+	/*
+	 * Intentionally leak a reference on the npu device (for
+	 * nvlink only; this is not an opencapi path) to make sure it
+	 * never goes away, as it's been the case all along and some
+	 * work is needed otherwise.
+	 */
+	pci_dev_get(npu_pdev);
+
 	/*
 	 * Due to a hardware errata PE#0 on the NPU is reserved for
 	 * error handling. This means we only have three PEs remaining
@@ -1228,7 +1234,6 @@ static struct pnv_ioda_pe *pnv_ioda_setup_npu_PE(struct pci_dev *npu_pdev)
 			 */
 			dev_info(&npu_pdev->dev,
 				"Associating to existing PE %x\n", pe_num);
-			pci_dev_get(npu_pdev);
 			npu_pdn = pci_get_pdn(npu_pdev);
 			rid = npu_pdev->bus->number << 8 | npu_pdn->devfn;
 			npu_pdn->pe_number = pe_num;
-- 
2.20.1

