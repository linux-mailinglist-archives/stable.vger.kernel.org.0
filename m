Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD9113FE64
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404128AbgAPXco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:32:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404117AbgAPXco (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE57B206D9;
        Thu, 16 Jan 2020 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217563;
        bh=EpVEuEjNHEvdRZljTfcokTXZjZ3LzDAi6g23Wduz0kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrszRI5FlTb31/55c5xvoeMDUtQl1CqdndLuyLwhOmJMs2hNqpr/+X2BAegNLWWrQ
         ml0LRnIDaxzslY/LqAnptez21NIVHz4qngpFKmVaGKsI9ZJHi5BGC/I9GBcq0F0njc
         PEoiMijonZs7pdoUNFCJ3pGHn5C2xO4N22Arjy9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 49/71] powerpc/powernv: Disable native PCIe port management
Date:   Fri, 17 Jan 2020 00:18:47 +0100
Message-Id: <20200116231716.455904775@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

commit 9d72dcef891030545f39ad386a30cf91df517fb2 upstream.

On PowerNV the PCIe topology is (currently) managed by the powernv platform
code in Linux in cooperation with the platform firmware. Linux's native
PCIe port service drivers operate independently of both and this can cause
problems.

The main issue is that the portbus driver will conflict with the platform
specific hotplug driver (pnv_php) over ownership of the MSI used to notify
the host when a hotplug event occurs. The portbus driver claims this MSI on
behalf of the individual port services because the same interrupt is used
for hotplug events, PMEs (on root ports), and link bandwidth change
notifications. The portbus driver will always claim the interrupt even if
the individual port service drivers, such as pciehp, are compiled out.

The second, bigger, problem is that the hotplug port service driver
fundamentally does not work on PowerNV. The platform assumes that all
PCI devices have a corresponding arch-specific handle derived from the DT
node for the device (pci_dn) and without one the platform will not allow
a PCI device to be enabled. This problem is largely due to historical
baggage, but it can't be resolved without significant re-factoring of the
platform PCI support.

We can fix these problems in the interim by setting the
"pcie_ports_disabled" flag during platform initialisation. The flag
indicates the platform owns the PCIe ports which stops the portbus driver
from being registered.

This does have the side effect of disabling all port services drivers
that is: AER, PME, BW notifications, hotplug, and DPC. However, this is
not a huge disadvantage on PowerNV since these services are either unused
or handled through other means.

Fixes: 66725152fb9f ("PCI/hotplug: PowerPC PowerNV PCI hotplug driver")
Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191118065553.30362-1-oohall@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -1118,6 +1118,23 @@ void __init pnv_pci_init(void)
 	if (!firmware_has_feature(FW_FEATURE_OPAL))
 		return;
 
+#ifdef CONFIG_PCIEPORTBUS
+	/*
+	 * On PowerNV PCIe devices are (currently) managed in cooperation
+	 * with firmware. This isn't *strictly* required, but there's enough
+	 * assumptions baked into both firmware and the platform code that
+	 * it's unwise to allow the portbus services to be used.
+	 *
+	 * We need to fix this eventually, but for now set this flag to disable
+	 * the portbus driver. The AER service isn't required since that AER
+	 * events are handled via EEH. The pciehp hotplug driver can't work
+	 * without kernel changes (and portbus binding breaks pnv_php). The
+	 * other services also require some thinking about how we're going
+	 * to integrate them.
+	 */
+	pcie_ports_disabled = true;
+#endif
+
 	/* Look for IODA IO-Hubs. */
 	for_each_compatible_node(np, NULL, "ibm,ioda-hub") {
 		pnv_pci_init_ioda_hub(np);


