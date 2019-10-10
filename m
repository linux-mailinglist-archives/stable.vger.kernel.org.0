Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE47D2469
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbfJJIo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389027AbfJJIo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:44:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455D321929;
        Thu, 10 Oct 2019 08:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697094;
        bh=yEwwN4aCrDKN7M8R+26m8PSL7h3DXKhMA0QOudOPcF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnJYoE48+/WIbedbQcj9BuVdIAzri2S/fwr9A87MmvH4JUkiMGON57X/EXOyBVlPT
         LRo+n5Fe+qShuIgb7jNr4tqOH4z/cWPNsjZBVs/WwgbSz1tGut8348CGhPhSE2Qory
         heg5SA6fr+jXEJZmkgPIIyEGlsx7Fdk6qT9R2iS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 017/114] powerpc/powernv/ioda: Fix race in TCE level allocation
Date:   Thu, 10 Oct 2019 10:35:24 +0200
Message-Id: <20191010083552.110759758@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit 56090a3902c80c296e822d11acdb6a101b322c52 upstream.

pnv_tce() returns a pointer to a TCE entry and originally a TCE table
would be pre-allocated. For the default case of 2GB window the table
needs only a single level and that is fine. However if more levels are
requested, it is possible to get a race when 2 threads want a pointer
to a TCE entry from the same page of TCEs.

This adds cmpxchg to handle the race. Note that once TCE is non-zero,
it cannot become zero again.

Fixes: a68bd1267b72 ("powerpc/powernv/ioda: Allocate indirect TCE levels on demand")
CC: stable@vger.kernel.org # v4.19+
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190718051139.74787-2-aik@ozlabs.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda-tce.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/arch/powerpc/platforms/powernv/pci-ioda-tce.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
@@ -49,6 +49,9 @@ static __be64 *pnv_alloc_tce_level(int n
 	return addr;
 }
 
+static void pnv_pci_ioda2_table_do_free_pages(__be64 *addr,
+		unsigned long size, unsigned int levels);
+
 static __be64 *pnv_tce(struct iommu_table *tbl, bool user, long idx, bool alloc)
 {
 	__be64 *tmp = user ? tbl->it_userspace : (__be64 *) tbl->it_base;
@@ -58,9 +61,9 @@ static __be64 *pnv_tce(struct iommu_tabl
 
 	while (level) {
 		int n = (idx & mask) >> (level * shift);
-		unsigned long tce;
+		unsigned long oldtce, tce = be64_to_cpu(READ_ONCE(tmp[n]));
 
-		if (tmp[n] == 0) {
+		if (!tce) {
 			__be64 *tmp2;
 
 			if (!alloc)
@@ -71,10 +74,15 @@ static __be64 *pnv_tce(struct iommu_tabl
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


