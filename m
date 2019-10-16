Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE9CDA115
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394031AbfJPWTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394933AbfJPVyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:12 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B837521925;
        Wed, 16 Oct 2019 21:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262851;
        bh=6EyxsEqBJ2oOZtJcJw9OqpnSifZ1fmKpzk8Q4zKakk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baCBaLWv5SyZqr2mZ1kuaEJ39NoRcXZs47dh8zWQJgZl4SqJddayMqUT3kPxJ2g9v
         LaGnoIC/0miq+EFUjDltKq3axR9cRvBk/NzRM7Egd+vMsm3s2Z3hf+1iRd1+ij5us9
         y9lHFzAcgLCOSnntdW6Bv7yC7lNUydJdSbcKdIC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Druzhinin <igor.druzhinin@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/92] xen/pci: reserve MCFG areas earlier
Date:   Wed, 16 Oct 2019 14:49:51 -0700
Message-Id: <20191016214815.145078382@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
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
index 7494dbeb4409c..db58aaa4dc598 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -29,6 +29,8 @@
 #include "../pci/pci.h"
 #ifdef CONFIG_PCI_MMCONFIG
 #include <asm/pci_x86.h>
+
+static int xen_mcfg_late(void);
 #endif
 
 static bool __read_mostly pci_seg_supported = true;
@@ -40,7 +42,18 @@ static int xen_add_device(struct device *dev)
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
@@ -213,7 +226,7 @@ static int __init register_xen_pci_notifier(void)
 arch_initcall(register_xen_pci_notifier);
 
 #ifdef CONFIG_PCI_MMCONFIG
-static int __init xen_mcfg_late(void)
+static int xen_mcfg_late(void)
 {
 	struct pci_mmcfg_region *cfg;
 	int rc;
@@ -252,8 +265,4 @@ static int __init xen_mcfg_late(void)
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



