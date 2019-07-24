Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60C473B6D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392265AbfGXUAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392144AbfGXT77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:59:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F1F9205C9;
        Wed, 24 Jul 2019 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998397;
        bh=rX1DHMvAoWXwOIi8d75uDBTkFbXucALJxOBfyN3Ut1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBw1188cdmsgj5Tqdup1bVohva76TjnQAord5Kbvt8JCTA4ERN3CaDOr/AaMxmpZF
         lF+FQrtXtSPniHqf4rQvLnlJHohn2hhKJWC8CBPMm0Vs/JV64Dh+C+Xlo44GHO1zdN
         TuE02A4VUzLJLzAAisaFyg8K5acfZ2q3+vkjyyJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 352/371] powerpc/powernv/npu: Fix reference leak
Date:   Wed, 24 Jul 2019 21:21:44 +0200
Message-Id: <20190724191750.325605471@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kurz <groug@kaod.org>

commit 02c5f5394918b9b47ff4357b1b18335768cd867d upstream.

Since 902bdc57451c, get_pci_dev() calls pci_get_domain_bus_and_slot(). This
has the effect of incrementing the reference count of the PCI device, as
explained in drivers/pci/search.c:

 * Given a PCI domain, bus, and slot/function number, the desired PCI
 * device is located in the list of PCI devices. If the device is
 * found, its reference count is increased and this function returns a
 * pointer to its data structure.  The caller must decrement the
 * reference count by calling pci_dev_put().  If no device is found,
 * %NULL is returned.

Nothing was done to call pci_dev_put() and the reference count of GPU and
NPU PCI devices rockets up.

A natural way to fix this would be to teach the callers about the change,
so that they call pci_dev_put() when done with the pointer. This turns
out to be quite intrusive, as it affects many paths in npu-dma.c,
pci-ioda.c and vfio_pci_nvlink2.c. Also, the issue appeared in 4.16 and
some affected code got moved around since then: it would be problematic
to backport the fix to stable releases.

All that code never cared for reference counting anyway. Call pci_dev_put()
from get_pci_dev() to revert to the previous behavior.

Fixes: 902bdc57451c ("powerpc/powernv/idoa: Remove unnecessary pcidev from pci_dn")
Cc: stable@vger.kernel.org # v4.16
Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/npu-dma.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/npu-dma.c
+++ b/arch/powerpc/platforms/powernv/npu-dma.c
@@ -31,9 +31,22 @@ static DEFINE_SPINLOCK(npu_context_lock)
 static struct pci_dev *get_pci_dev(struct device_node *dn)
 {
 	struct pci_dn *pdn = PCI_DN(dn);
+	struct pci_dev *pdev;
 
-	return pci_get_domain_bus_and_slot(pci_domain_nr(pdn->phb->bus),
+	pdev = pci_get_domain_bus_and_slot(pci_domain_nr(pdn->phb->bus),
 					   pdn->busno, pdn->devfn);
+
+	/*
+	 * pci_get_domain_bus_and_slot() increased the reference count of
+	 * the PCI device, but callers don't need that actually as the PE
+	 * already holds a reference to the device. Since callers aren't
+	 * aware of the reference count change, call pci_dev_put() now to
+	 * avoid leaks.
+	 */
+	if (pdev)
+		pci_dev_put(pdev);
+
+	return pdev;
 }
 
 /* Given a NPU device get the associated PCI device. */


