Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9673C14D
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 04:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbfFKCkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 22:40:15 -0400
Received: from ozlabs.ru ([107.173.13.209]:45294 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390244AbfFKCkO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 22:40:14 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 22:40:14 EDT
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 57A47AE80040;
        Mon, 10 Jun 2019 22:31:08 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Russell Currey <ruscur@russell.cc>, stable@vger.kernel.org
Subject: [PATCH kernel] powerpc/powernv/ioda: Fix race in TCE level allocation
Date:   Tue, 11 Jun 2019 12:31:03 +1000
Message-Id: <20190611023103.86977-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pnv_tce() returns a pointer to a TCE entry and originally a TCE table
would be pre-allocated. For the default case of 2GB window the table
needs only a single level and that is fine. However if more levels are
requested, it is possible to get a race when 2 threads want a pointer
to a TCE entry from the same page of TCEs.

This adds a spinlock to handle the race. The alloc==true case is not
possible in the real mode so spinlock is safe for KVM as well.

CC: stable@vger.kernel.org # v4.19+
Fixes: a68bd1267b72 ("powerpc/powernv/ioda: Allocate indirect TCE levels on demand")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

This fixes EEH's from
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=110810


---
 arch/powerpc/include/asm/iommu.h              |  1 +
 arch/powerpc/platforms/powernv/pci-ioda-tce.c | 21 ++++++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 2c1845e5e851..1825b4cc0097 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -111,6 +111,7 @@ struct iommu_table {
 	struct iommu_table_ops *it_ops;
 	struct kref    it_kref;
 	int it_nid;
+	spinlock_t it_lock;
 };
 
 #define IOMMU_TABLE_USERSPACE_ENTRY_RO(tbl, entry) \
diff --git a/arch/powerpc/platforms/powernv/pci-ioda-tce.c b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
index e28f03e1eb5e..9a19d61e2b12 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda-tce.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
@@ -29,6 +29,7 @@ void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 	tbl->it_size = tce_size >> 3;
 	tbl->it_busno = 0;
 	tbl->it_type = TCE_PCI;
+	spin_lock_init(&tbl->it_lock);
 }
 
 static __be64 *pnv_alloc_tce_level(int nid, unsigned int shift)
@@ -60,18 +61,22 @@ static __be64 *pnv_tce(struct iommu_table *tbl, bool user, long idx, bool alloc)
 		unsigned long tce;
 
 		if (tmp[n] == 0) {
-			__be64 *tmp2;
-
 			if (!alloc)
 				return NULL;
 
-			tmp2 = pnv_alloc_tce_level(tbl->it_nid,
-					ilog2(tbl->it_level_size) + 3);
-			if (!tmp2)
-				return NULL;
+			spin_lock(&tbl->it_lock);
+			if (tmp[n] == 0) {
+				__be64 *tmp2;
 
-			tmp[n] = cpu_to_be64(__pa(tmp2) |
-					TCE_PCI_READ | TCE_PCI_WRITE);
+				tmp2 = pnv_alloc_tce_level(tbl->it_nid,
+						ilog2(tbl->it_level_size) + 3);
+				if (tmp2)
+					tmp[n] = cpu_to_be64(__pa(tmp2) |
+						TCE_PCI_READ | TCE_PCI_WRITE);
+			}
+			spin_unlock(&tbl->it_lock);
+			if (tmp[n] == 0)
+				return NULL;
 		}
 		tce = be64_to_cpu(tmp[n]);
 
-- 
2.17.1

