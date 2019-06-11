Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317653C32C
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 07:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390485AbfFKFIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 01:08:45 -0400
Received: from ozlabs.ru ([107.173.13.209]:55931 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390539AbfFKFIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 01:08:45 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 95A5DAE80040;
        Tue, 11 Jun 2019 01:08:41 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Reza Arbab <arbab@linux.ibm.com>,
        Sam Bobroff <sbobroff@linux.ibm.com>,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Oliver O'Halloran <oohall@gmail.com>,
        Russell Currey <ruscur@russell.cc>, stable@vger.kernel.org
Subject: [PATCH kernel v2] powerpc/powernv/ioda: Fix race in TCE level allocation
Date:   Tue, 11 Jun 2019 15:08:38 +1000
Message-Id: <20190611050838.124094-1-aik@ozlabs.ru>
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

This adds cmpxchg to handle the race. Note that once a TCE is non-zero,
it cannot become zero again.

CC: stable@vger.kernel.org # v4.19+
Fixes: a68bd1267b72 ("powerpc/powernv/ioda: Allocate indirect TCE levels on demand")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

The race occurs about 30 times in the first 3 minutes of copying files
via rsync and that's about it.

This fixes EEH's from
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=110810

---
Changes:
v2:
* replaced spin_lock with cmpxchg+readonce
---
 arch/powerpc/platforms/powernv/pci-ioda-tce.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda-tce.c b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
index e28f03e1eb5e..8d6569590161 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda-tce.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
@@ -48,6 +48,9 @@ static __be64 *pnv_alloc_tce_level(int nid, unsigned int shift)
 	return addr;
 }
 
+static void pnv_pci_ioda2_table_do_free_pages(__be64 *addr,
+		unsigned long size, unsigned int levels);
+
 static __be64 *pnv_tce(struct iommu_table *tbl, bool user, long idx, bool alloc)
 {
 	__be64 *tmp = user ? tbl->it_userspace : (__be64 *) tbl->it_base;
@@ -57,9 +60,9 @@ static __be64 *pnv_tce(struct iommu_table *tbl, bool user, long idx, bool alloc)
 
 	while (level) {
 		int n = (idx & mask) >> (level * shift);
-		unsigned long tce;
+		unsigned long oldtce, tce = be64_to_cpu(READ_ONCE(tmp[n]));
 
-		if (tmp[n] == 0) {
+		if (!tce) {
 			__be64 *tmp2;
 
 			if (!alloc)
@@ -70,10 +73,15 @@ static __be64 *pnv_tce(struct iommu_table *tbl, bool user, long idx, bool alloc)
 			if (!tmp2)
 				return NULL;
 
-			tmp[n] = cpu_to_be64(__pa(tmp2) |
-					TCE_PCI_READ | TCE_PCI_WRITE);
+			tce = __pa(tmp2) | TCE_PCI_READ | TCE_PCI_WRITE;
+			oldtce = be64_to_cpu(cmpxchg(&tmp[n], 0,
+					cpu_to_be64(tce)));
+			if (oldtce) {
+				pnv_pci_ioda2_table_do_free_pages(tmp2,
+					ilog2(tbl->it_level_size) + 3, 1);
+				tce = oldtce;
+			}
 		}
-		tce = be64_to_cpu(tmp[n]);
 
 		tmp = __va(tce & ~(TCE_PCI_READ | TCE_PCI_WRITE));
 		idx &= ~mask;
-- 
2.17.1

