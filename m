Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9882ED2597
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbfJJJBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388391AbfJJIlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:41:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 685C521D56;
        Thu, 10 Oct 2019 08:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696903;
        bh=+mT8/3hA2cfjUIcBsN2OvGqB9yxy2MWscjrV4RnpD/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riaZ+ndGaWUXxAGdfoASXtzIKEOUvCEk8Ft1Ixm28Idx8lqcQdzlpp7cmUkvCGTEV
         U3kv0Bk4ysFApawiOm7l1he+6s0mPyYWqiEBWDUdKjs6yngZCcUoXlzQJ54OL//dZb
         MTa2zZ63Mq6v8PNt1Kf07V8vekrO75SeWDmuXNzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Druzhinin <igor.druzhinin@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 096/148] xen/pci: reserve MCFG areas earlier
Date:   Thu, 10 Oct 2019 10:35:57 +0200
Message-Id: <20191010083617.094504480@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Druzhinin <igor.druzhinin@citrix.com>

[ Upstream commit a4098bc6eed5e31e0391bcc068e61804c98138df ]

If MCFG area is not reserved in E820, Xen by default will defer its usage
until Dom0 registers it explicitly after ACPI parser recognizes it as
a reserved resource in DSDT. Having it reserved in E820 is not
mandatory according to "PCI Firmware Specification, rev 3.2" (par. 4.1.2)
and firmware is free to keep a hole in E820 in that place. Xen doesn't know
what exactly is inside this hole since it lacks full ACPI view of the
platform therefore it's potentially harmful to access MCFG region
without additional checks as some machines are known to provide
inconsistent information on the size of the region.

Now xen_mcfg_late() runs after acpi_init() which is too late as some basic
PCI enumeration starts exactly there as well. Trying to register a device
prior to MCFG reservation causes multiple problems with PCIe extended
capability initializations in Xen (e.g. SR-IOV VF BAR sizing). There are
no convenient hooks for us to subscribe to so register MCFG areas earlier
upon the first invocation of xen_add_device(). It should be safe to do once
since all the boot time buses must have their MCFG areas in MCFG table
already and we don't support PCI bus hot-plug.

Signed-off-by: Igor Druzhinin <igor.druzhinin@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pci.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index 3eeb9bea76300..224df03ce42e3 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -17,6 +17,8 @@
 #include "../pci/pci.h"
 #ifdef CONFIG_PCI_MMCONFIG
 #include <asm/pci_x86.h>
+
+static int xen_mcfg_late(void);
 #endif
 
 static bool __read_mostly pci_seg_supported = true;
@@ -28,7 +30,18 @@ static int xen_add_device(struct device *dev)
 #ifdef CONFIG_PCI_IOV
 	struct pci_dev *physfn = pci_dev->physfn;
 #endif
-
+#ifdef CONFIG_PCI_MMCONFIG
+	static bool pci_mcfg_reserved = false;
+	/*
+	 * Reserve MCFG areas in Xen on first invocation due to this being
+	 * potentially called from inside of acpi_init immediately after
+	 * MCFG table has been finally parsed.
+	 */
+	if (!pci_mcfg_reserved) {
+		xen_mcfg_late();
+		pci_mcfg_reserved = true;
+	}
+#endif
 	if (pci_seg_supported) {
 		struct {
 			struct physdev_pci_device_add add;
@@ -201,7 +214,7 @@ static int __init register_xen_pci_notifier(void)
 arch_initcall(register_xen_pci_notifier);
 
 #ifdef CONFIG_PCI_MMCONFIG
-static int __init xen_mcfg_late(void)
+static int xen_mcfg_late(void)
 {
 	struct pci_mmcfg_region *cfg;
 	int rc;
@@ -240,8 +253,4 @@ static int __init xen_mcfg_late(void)
 	}
 	return 0;
 }
-/*
- * Needs to be done after acpi_init which are subsys_initcall.
- */
-subsys_initcall_sync(xen_mcfg_late);
 #endif
-- 
2.20.1



