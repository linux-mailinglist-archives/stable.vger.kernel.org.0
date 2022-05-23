Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B20531BFB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbiEWRan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243010AbiEWR2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC8A8E191;
        Mon, 23 May 2022 10:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E5A060B2C;
        Mon, 23 May 2022 17:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDA3C385A9;
        Mon, 23 May 2022 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326702;
        bh=Zc9iKb/8Gq+aQuRrHFAmmzOPypg+HrcmHQUblhe2SBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/nFSg8euwF4qUIdM04RoGhlSrYoCGhTtaP4nzvRwBJcV1/uHZ2/mJ3x+Nk2DW3EJ
         g9D9epEgAcmn/y/xeibbCw8KtUqCuORnLaJ0d2k1Q/KReo7thzSxJibWedXyypklv0
         /DeESKoxB5uCU5oGW6hMrKbawtXSGTqXv9PkxKW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 013/158] Watchdog: sp5100_tco: Refactor MMIO base address initialization
Date:   Mon, 23 May 2022 19:02:50 +0200
Message-Id: <20220523165832.803150124@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Terry Bowman <terry.bowman@amd.com>

commit 1f182aca230086d4a4469c0f9136a6ea762d6385 upstream.

Combine MMIO base address and alternate base address detection. Combine
based on layout type. This will simplify the function by eliminating
a switch case.

Move existing request/release code into functions. This currently only
supports port I/O request/release. The move into a separate function
will make it ready for adding MMIO region support.

Co-developed-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220202153525.1693378-3-terry.bowman@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sp5100_tco.c |  155 +++++++++++++++++++++---------------------
 drivers/watchdog/sp5100_tco.h |    1 
 2 files changed, 82 insertions(+), 74 deletions(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -223,6 +223,55 @@ static u32 sp5100_tco_read_pm_reg32(u8 i
 	return val;
 }
 
+static u32 sp5100_tco_request_region(struct device *dev,
+				     u32 mmio_addr,
+				     const char *dev_name)
+{
+	if (!devm_request_mem_region(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE,
+				     dev_name)) {
+		dev_dbg(dev, "MMIO address 0x%08x already in use\n", mmio_addr);
+		return 0;
+	}
+
+	return mmio_addr;
+}
+
+static u32 sp5100_tco_prepare_base(struct sp5100_tco *tco,
+				   u32 mmio_addr,
+				   u32 alt_mmio_addr,
+				   const char *dev_name)
+{
+	struct device *dev = tco->wdd.parent;
+
+	dev_dbg(dev, "Got 0x%08x from SBResource_MMIO register\n", mmio_addr);
+
+	if (!mmio_addr && !alt_mmio_addr)
+		return -ENODEV;
+
+	/* Check for MMIO address and alternate MMIO address conflicts */
+	if (mmio_addr)
+		mmio_addr = sp5100_tco_request_region(dev, mmio_addr, dev_name);
+
+	if (!mmio_addr && alt_mmio_addr)
+		mmio_addr = sp5100_tco_request_region(dev, alt_mmio_addr, dev_name);
+
+	if (!mmio_addr) {
+		dev_err(dev, "Failed to reserve MMIO or alternate MMIO region\n");
+		return -EBUSY;
+	}
+
+	tco->tcobase = devm_ioremap(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE);
+	if (!tco->tcobase) {
+		dev_err(dev, "MMIO address 0x%08x failed mapping\n", mmio_addr);
+		devm_release_mem_region(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE);
+		return -ENOMEM;
+	}
+
+	dev_info(dev, "Using 0x%08x for watchdog MMIO address\n", mmio_addr);
+
+	return 0;
+}
+
 static int sp5100_tco_timer_init(struct sp5100_tco *tco)
 {
 	struct watchdog_device *wdd = &tco->wdd;
@@ -264,6 +313,7 @@ static int sp5100_tco_setupdevice(struct
 	struct sp5100_tco *tco = watchdog_get_drvdata(wdd);
 	const char *dev_name;
 	u32 mmio_addr = 0, val;
+	u32 alt_mmio_addr = 0;
 	int ret;
 
 	/* Request the IO ports used by this driver */
@@ -282,11 +332,32 @@ static int sp5100_tco_setupdevice(struct
 		dev_name = SP5100_DEVNAME;
 		mmio_addr = sp5100_tco_read_pm_reg32(SP5100_PM_WATCHDOG_BASE) &
 								0xfffffff8;
+
+		/*
+		 * Secondly, find the watchdog timer MMIO address
+		 * from SBResource_MMIO register.
+		 */
+
+		/* Read SBResource_MMIO from PCI config(PCI_Reg: 9Ch) */
+		pci_read_config_dword(sp5100_tco_pci,
+				      SP5100_SB_RESOURCE_MMIO_BASE,
+				      &val);
+
+		/* Verify MMIO is enabled and using bar0 */
+		if ((val & SB800_ACPI_MMIO_MASK) == SB800_ACPI_MMIO_DECODE_EN)
+			alt_mmio_addr = (val & ~0xfff) + SB800_PM_WDT_MMIO_OFFSET;
 		break;
 	case sb800:
 		dev_name = SB800_DEVNAME;
 		mmio_addr = sp5100_tco_read_pm_reg32(SB800_PM_WATCHDOG_BASE) &
 								0xfffffff8;
+
+		/* Read SBResource_MMIO from AcpiMmioEn(PM_Reg: 24h) */
+		val = sp5100_tco_read_pm_reg32(SB800_PM_ACPI_MMIO_EN);
+
+		/* Verify MMIO is enabled and using bar0 */
+		if ((val & SB800_ACPI_MMIO_MASK) == SB800_ACPI_MMIO_DECODE_EN)
+			alt_mmio_addr = (val & ~0xfff) + SB800_PM_WDT_MMIO_OFFSET;
 		break;
 	case efch:
 		dev_name = SB800_DEVNAME;
@@ -305,87 +376,23 @@ static int sp5100_tco_setupdevice(struct
 		val = sp5100_tco_read_pm_reg8(EFCH_PM_DECODEEN);
 		if (val & EFCH_PM_DECODEEN_WDT_TMREN)
 			mmio_addr = EFCH_PM_WDT_ADDR;
+
+		val = sp5100_tco_read_pm_reg8(EFCH_PM_ISACONTROL);
+		if (val & EFCH_PM_ISACONTROL_MMIOEN)
+			alt_mmio_addr = EFCH_PM_ACPI_MMIO_ADDR +
+				EFCH_PM_ACPI_MMIO_WDT_OFFSET;
 		break;
 	default:
 		return -ENODEV;
 	}
 
-	/* Check MMIO address conflict */
-	if (!mmio_addr ||
-	    !devm_request_mem_region(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE,
-				     dev_name)) {
-		if (mmio_addr)
-			dev_dbg(dev, "MMIO address 0x%08x already in use\n",
-				mmio_addr);
-		switch (tco->tco_reg_layout) {
-		case sp5100:
-			/*
-			 * Secondly, Find the watchdog timer MMIO address
-			 * from SBResource_MMIO register.
-			 */
-			/* Read SBResource_MMIO from PCI config(PCI_Reg: 9Ch) */
-			pci_read_config_dword(sp5100_tco_pci,
-					      SP5100_SB_RESOURCE_MMIO_BASE,
-					      &mmio_addr);
-			if ((mmio_addr & (SB800_ACPI_MMIO_DECODE_EN |
-					  SB800_ACPI_MMIO_SEL)) !=
-						  SB800_ACPI_MMIO_DECODE_EN) {
-				ret = -ENODEV;
-				goto unreg_region;
-			}
-			mmio_addr &= ~0xFFF;
-			mmio_addr += SB800_PM_WDT_MMIO_OFFSET;
-			break;
-		case sb800:
-			/* Read SBResource_MMIO from AcpiMmioEn(PM_Reg: 24h) */
-			mmio_addr =
-				sp5100_tco_read_pm_reg32(SB800_PM_ACPI_MMIO_EN);
-			if ((mmio_addr & (SB800_ACPI_MMIO_DECODE_EN |
-					  SB800_ACPI_MMIO_SEL)) !=
-						  SB800_ACPI_MMIO_DECODE_EN) {
-				ret = -ENODEV;
-				goto unreg_region;
-			}
-			mmio_addr &= ~0xFFF;
-			mmio_addr += SB800_PM_WDT_MMIO_OFFSET;
-			break;
-		case efch:
-			val = sp5100_tco_read_pm_reg8(EFCH_PM_ISACONTROL);
-			if (!(val & EFCH_PM_ISACONTROL_MMIOEN)) {
-				ret = -ENODEV;
-				goto unreg_region;
-			}
-			mmio_addr = EFCH_PM_ACPI_MMIO_ADDR +
-				    EFCH_PM_ACPI_MMIO_WDT_OFFSET;
-			break;
-		}
-		dev_dbg(dev, "Got 0x%08x from SBResource_MMIO register\n",
-			mmio_addr);
-		if (!devm_request_mem_region(dev, mmio_addr,
-					     SP5100_WDT_MEM_MAP_SIZE,
-					     dev_name)) {
-			dev_dbg(dev, "MMIO address 0x%08x already in use\n",
-				mmio_addr);
-			ret = -EBUSY;
-			goto unreg_region;
-		}
+	ret = sp5100_tco_prepare_base(tco, mmio_addr, alt_mmio_addr, dev_name);
+	if (!ret) {
+		/* Setup the watchdog timer */
+		tco_timer_enable(tco);
+		ret = sp5100_tco_timer_init(tco);
 	}
 
-	tco->tcobase = devm_ioremap(dev, mmio_addr, SP5100_WDT_MEM_MAP_SIZE);
-	if (!tco->tcobase) {
-		dev_err(dev, "failed to get tcobase address\n");
-		ret = -ENOMEM;
-		goto unreg_region;
-	}
-
-	dev_info(dev, "Using 0x%08x for watchdog MMIO address\n", mmio_addr);
-
-	/* Setup the watchdog timer */
-	tco_timer_enable(tco);
-
-	ret = sp5100_tco_timer_init(tco);
-
-unreg_region:
 	release_region(SP5100_IO_PM_INDEX_REG, SP5100_PM_IOPORTS_SIZE);
 	return ret;
 }
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -58,6 +58,7 @@
 #define SB800_PM_WATCHDOG_SECOND_RES	GENMASK(1, 0)
 #define SB800_ACPI_MMIO_DECODE_EN	BIT(0)
 #define SB800_ACPI_MMIO_SEL		BIT(1)
+#define SB800_ACPI_MMIO_MASK		GENMASK(1, 0)
 
 #define SB800_PM_WDT_MMIO_OFFSET	0xB00
 


