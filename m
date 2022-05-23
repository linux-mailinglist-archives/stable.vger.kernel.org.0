Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722B1531713
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbiEWRdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbiEWRag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DEC54014;
        Mon, 23 May 2022 10:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD1B60919;
        Mon, 23 May 2022 17:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E818C385A9;
        Mon, 23 May 2022 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326708;
        bh=MyMO1r+t/9l7ZlDEEqZOpYQ/cN0Efzy960/m/gIuCQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qObh/lOPHe6X8qbLpereKNU2fjbG4oUoPPdqua0UpUMmPCHRT7Pw+xD/XTqAGmSd
         c/dxL92dNSooVjHGFdMAQafv2Kf3VH4rBqJK9sh31XIIhx5uas4estR+SCR2rzpD4V
         y3DYipOMIjgM5am8lAYjjUTRSZnLsooT3E6RO1Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Richter <rrichter@amd.com>,
        Terry Bowman <terry.bowman@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 015/158] Watchdog: sp5100_tco: Enable Family 17h+ CPUs
Date:   Mon, 23 May 2022 19:02:52 +0200
Message-Id: <20220523165833.161809742@linuxfoundation.org>
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

commit 826270373f17fd8ebd10753ca0a5fd2ceb1dc38e upstream.

The driver currently uses a CPU family match of 17h to determine
EFCH_PM_DECODEEN_WDT_TMREN register support. This family check will not
support future AMD CPUs and instead will require driver updates to add
support.

Remove the family 17h family check and add a check for SMBus PCI
revision ID 0x51 or greater. The MMIO access method has been available
since at least SMBus controllers using PCI revision 0x51. This revision
check will support family 17h and future AMD processors including EFCH
functionality without requiring driver changes.

Co-developed-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Tested-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220202153525.1693378-5-terry.bowman@amd.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/sp5100_tco.c |   16 ++++------------
 drivers/watchdog/sp5100_tco.h |    1 +
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -87,6 +87,10 @@ static enum tco_reg_layout tco_reg_layou
 	    dev->revision < 0x40) {
 		return sp5100;
 	} else if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	    sp5100_tco_pci->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
+	    sp5100_tco_pci->revision >= AMD_ZEN_SMBUS_PCI_REV) {
+		return efch_mmio;
+	} else if (dev->vendor == PCI_VENDOR_ID_AMD &&
 	    ((dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS &&
 	     dev->revision >= 0x41) ||
 	    (dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
@@ -459,18 +463,6 @@ static int sp5100_tco_setupdevice(struct
 		break;
 	case efch:
 		dev_name = SB800_DEVNAME;
-		/*
-		 * On Family 17h devices, the EFCH_PM_DECODEEN_WDT_TMREN bit of
-		 * EFCH_PM_DECODEEN not only enables the EFCH_PM_WDT_ADDR memory
-		 * region, it also enables the watchdog itself.
-		 */
-		if (boot_cpu_data.x86 == 0x17) {
-			val = sp5100_tco_read_pm_reg8(EFCH_PM_DECODEEN);
-			if (!(val & EFCH_PM_DECODEEN_WDT_TMREN)) {
-				sp5100_tco_update_pm_reg8(EFCH_PM_DECODEEN, 0xff,
-							  EFCH_PM_DECODEEN_WDT_TMREN);
-			}
-		}
 		val = sp5100_tco_read_pm_reg8(EFCH_PM_DECODEEN);
 		if (val & EFCH_PM_DECODEEN_WDT_TMREN)
 			mmio_addr = EFCH_PM_WDT_ADDR;
--- a/drivers/watchdog/sp5100_tco.h
+++ b/drivers/watchdog/sp5100_tco.h
@@ -89,3 +89,4 @@
 #define EFCH_PM_ACPI_MMIO_PM_ADDR	(EFCH_PM_ACPI_MMIO_ADDR +	\
 					 EFCH_PM_ACPI_MMIO_PM_OFFSET)
 #define EFCH_PM_ACPI_MMIO_PM_SIZE	8
+#define AMD_ZEN_SMBUS_PCI_REV		0x51


