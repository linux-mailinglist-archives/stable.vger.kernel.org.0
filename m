Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA4B73B6E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392272AbfGXUAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392266AbfGXUAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD2D621873;
        Wed, 24 Jul 2019 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998400;
        bh=xilmhM1s39Rgg2xFd6VWYxpecgNCzNRyz+zbv/QPNh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVWj2wie8ysqIHtzIbEXmAULebSwiaBKbYWmA53SY3ub5U4F3VeFtPBaoAFI+KBQx
         dLpAxpxANabzJ7TcWNSgUDM+FC+SQumGQ1aXSSqkY1zo8ZhGJJTBskPgI4mw2eLFbL
         h+l98LfkIqSp+v8lqxO7gfGkbS/xfztZS6JcLJ5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 353/371] powerpc/powernv: Fix stale iommu table base after VFIO
Date:   Wed, 24 Jul 2019 21:21:45 +0200
Message-Id: <20190724191750.413986568@linuxfoundation.org>
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

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit 5636427d087a55842c1a199dfb839e6545d30e5d upstream.

The powernv platform uses @dma_iommu_ops for non-bypass DMA. These ops
need an iommu_table pointer which is stored in
dev->archdata.iommu_table_base. It is initialized during
pcibios_setup_device() which handles boot time devices. However when a
device is taken from the system in order to pass it through, the
default IOMMU table is destroyed but the pointer in a device is not
updated; also when a device is returned back to the system, a new
table pointer is not stored in dev->archdata.iommu_table_base either.
So when a just returned device tries using IOMMU, it crashes on
accessing stale iommu_table or its members.

This calls set_iommu_table_base() when the default window is created.
Note it used to be there before but was wrongly removed (see "fixes").
It did not appear before as these days most devices simply use bypass.

This adds set_iommu_table_base(NULL) when a device is taken from the
system to make it clear that IOMMU DMA cannot be used past that point.

Fixes: c4e9d3c1e65a ("powerpc/powernv/pseries: Rework device adding to IOMMU groups")
Cc: stable@vger.kernel.org # v5.0+
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2459,6 +2459,14 @@ static long pnv_pci_ioda2_setup_default_
 	if (!pnv_iommu_bypass_disabled)
 		pnv_pci_ioda2_set_bypass(pe, true);
 
+	/*
+	 * Set table base for the case of IOMMU DMA use. Usually this is done
+	 * from dma_dev_setup() which is not called when a device is returned
+	 * from VFIO so do it here.
+	 */
+	if (pe->pdev)
+		set_iommu_table_base(&pe->pdev->dev, tbl);
+
 	return 0;
 }
 
@@ -2546,6 +2554,8 @@ static void pnv_ioda2_take_ownership(str
 	pnv_pci_ioda2_unset_window(&pe->table_group, 0);
 	if (pe->pbus)
 		pnv_ioda_setup_bus_dma(pe, pe->pbus);
+	else if (pe->pdev)
+		set_iommu_table_base(&pe->pdev->dev, NULL);
 	iommu_tce_table_put(tbl);
 }
 


