Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DE6593967
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242064AbiHOSmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243739AbiHOSlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218A33F310;
        Mon, 15 Aug 2022 11:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5F06B8107B;
        Mon, 15 Aug 2022 18:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0376AC433C1;
        Mon, 15 Aug 2022 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587890;
        bh=fTJ+GKFxExYByx+UhcUuaJl58FpKrzPcfiV0L275q5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7uuJ6R1UAJILWjtIoz1QAlHuUq8LlkoQHjG4EKb1l166TmzBaEfyhiX+CvByuRdn
         p2HP8Z6QzpQy5pDhm3LwrLLJplcgmzfWkgBJYXGNCepVl7RLxCc3NgIoU3a/rPcFQo
         hgH1Zwvan5WRI2IFqgNVF49ZLs+5czhvxR9IqGts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuai Xue <xueshuai@linux.alibaba.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/779] ACPI: APEI: explicit init of HEST and GHES in apci_init()
Date:   Mon, 15 Aug 2022 19:57:20 +0200
Message-Id: <20220815180345.647265939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit dc4e8c07e9e2f69387579c49caca26ba239f7270 ]

>From commit e147133a42cb ("ACPI / APEI: Make hest.c manage the estatus
memory pool") was merged, ghes_init() relies on acpi_hest_init() to manage
the estatus memory pool. On the other hand, ghes_init() relies on
sdei_init() to detect the SDEI version and (un)register events. The
dependencies are as follows:

    ghes_init() => acpi_hest_init() => acpi_bus_init() => acpi_init()
    ghes_init() => sdei_init()

HEST is not PCI-specific and initcall ordering is implicit and not
well-defined within a level.

Based on above, remove acpi_hest_init() from acpi_pci_root_init() and
convert ghes_init() and sdei_init() from initcalls to explicit calls in the
following order:

    acpi_hest_init()
    ghes_init()
        sdei_init()

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c    | 19 ++++++++-----------
 drivers/acpi/bus.c          |  2 ++
 drivers/acpi/pci_root.c     |  3 ---
 drivers/firmware/Kconfig    |  1 +
 drivers/firmware/arm_sdei.c | 13 ++-----------
 include/acpi/apei.h         |  4 +++-
 include/linux/arm_sdei.h    |  2 ++
 7 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0c8330ed1ffd..06b0184fa912 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1457,33 +1457,35 @@ static struct platform_driver ghes_platform_driver = {
 	.remove		= ghes_remove,
 };
 
-static int __init ghes_init(void)
+void __init ghes_init(void)
 {
 	int rc;
 
+	sdei_init();
+
 	if (acpi_disabled)
-		return -ENODEV;
+		return;
 
 	switch (hest_disable) {
 	case HEST_NOT_FOUND:
-		return -ENODEV;
+		return;
 	case HEST_DISABLED:
 		pr_info(GHES_PFX "HEST is not enabled!\n");
-		return -EINVAL;
+		return;
 	default:
 		break;
 	}
 
 	if (ghes_disable) {
 		pr_info(GHES_PFX "GHES is not enabled!\n");
-		return -EINVAL;
+		return;
 	}
 
 	ghes_nmi_init_cxt();
 
 	rc = platform_driver_register(&ghes_platform_driver);
 	if (rc)
-		goto err;
+		return;
 
 	rc = apei_osc_setup();
 	if (rc == 0 && osc_sb_apei_support_acked)
@@ -1494,9 +1496,4 @@ static int __init ghes_init(void)
 		pr_info(GHES_PFX "APEI firmware first mode is enabled by APEI bit.\n");
 	else
 		pr_info(GHES_PFX "Failed to enable APEI firmware first mode.\n");
-
-	return 0;
-err:
-	return rc;
 }
-device_initcall(ghes_init);
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 3500744e6862..fc9bb06d5411 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1340,6 +1340,8 @@ static int __init acpi_init(void)
 
 	pci_mmcfg_late_init();
 	acpi_iort_init();
+	acpi_hest_init();
+	ghes_init();
 	acpi_scan_init();
 	acpi_ec_init();
 	acpi_debugfs_init();
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index d7deedf3548e..223aa010dd8d 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -22,8 +22,6 @@
 #include <linux/slab.h>
 #include <linux/dmi.h>
 #include <linux/platform_data/x86/apple.h>
-#include <acpi/apei.h>	/* for acpi_hest_init() */
-
 #include "internal.h"
 
 #define ACPI_PCI_ROOT_CLASS		"pci_bridge"
@@ -938,7 +936,6 @@ struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 
 void __init acpi_pci_root_init(void)
 {
-	acpi_hest_init();
 	if (acpi_pci_disabled)
 		return;
 
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index cda7d7162cbb..97ce31e667fc 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -40,6 +40,7 @@ config ARM_SCPI_POWER_DOMAIN
 config ARM_SDE_INTERFACE
 	bool "ARM Software Delegated Exception Interface (SDEI)"
 	depends on ARM64
+	depends on ACPI_APEI_GHES
 	help
 	  The Software Delegated Exception Interface (SDEI) is an ARM
 	  standard for registering callbacks from the platform firmware
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index a7e762c352f9..1e1a51510e83 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -1059,14 +1059,14 @@ static bool __init sdei_present_acpi(void)
 	return true;
 }
 
-static int __init sdei_init(void)
+void __init sdei_init(void)
 {
 	struct platform_device *pdev;
 	int ret;
 
 	ret = platform_driver_register(&sdei_driver);
 	if (ret || !sdei_present_acpi())
-		return ret;
+		return;
 
 	pdev = platform_device_register_simple(sdei_driver.driver.name,
 					       0, NULL, 0);
@@ -1076,17 +1076,8 @@ static int __init sdei_init(void)
 		pr_info("Failed to register ACPI:SDEI platform device %d\n",
 			ret);
 	}
-
-	return ret;
 }
 
-/*
- * On an ACPI system SDEI needs to be ready before HEST:GHES tries to register
- * its events. ACPI is initialised from a subsys_initcall(), GHES is initialised
- * by device_initcall(). We want to be called in the middle.
- */
-subsys_initcall_sync(sdei_init);
-
 int sdei_event_handler(struct pt_regs *regs,
 		       struct sdei_registered_event *arg)
 {
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 680f80960c3d..a6ac2e8b72da 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -27,14 +27,16 @@ extern int hest_disable;
 extern int erst_disable;
 #ifdef CONFIG_ACPI_APEI_GHES
 extern bool ghes_disable;
+void __init ghes_init(void);
 #else
 #define ghes_disable 1
+static inline void ghes_init(void) { }
 #endif
 
 #ifdef CONFIG_ACPI_APEI
 void __init acpi_hest_init(void);
 #else
-static inline void acpi_hest_init(void) { return; }
+static inline void acpi_hest_init(void) { }
 #endif
 
 typedef int (*apei_hest_func_t)(struct acpi_hest_header *hest_hdr, void *data);
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 0a241c5c911d..14dc461b0e82 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -46,9 +46,11 @@ int sdei_unregister_ghes(struct ghes *ghes);
 /* For use by arch code when CPU hotplug notifiers are not appropriate. */
 int sdei_mask_local_cpu(void);
 int sdei_unmask_local_cpu(void);
+void __init sdei_init(void);
 #else
 static inline int sdei_mask_local_cpu(void) { return 0; }
 static inline int sdei_unmask_local_cpu(void) { return 0; }
+static inline void sdei_init(void) { }
 #endif /* CONFIG_ARM_SDE_INTERFACE */
 
 
-- 
2.35.1



