Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3499B66C5FD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbjAPQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbjAPQMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2FE26581
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB7961037
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8C0C433D2;
        Mon, 16 Jan 2023 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885259;
        bh=UtzZ7sKrXlpANP1aVLRNhwcdJU0FG67zA3zf8ai7jjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0MoAe2AXQmr1gtuJ4p/Bwo0k00WdI7G6kamnLxVNtRYN8McXTZwQx/xpxEf35PLe
         1f9AIzQ1Y1YkpuFB/q7lgAiE6mWQLUVFYTUUatrR+RmZVJyNaN4SYq1cNMJSsjZR/f
         EfSBZCBAYk4UJQXfzHLE2GsnjD0PPjGNEPkcTsFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kim Phillips <kim.phillips@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/64] iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options
Date:   Mon, 16 Jan 2023 16:51:26 +0100
Message-Id: <20230116154744.284423151@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 1198d2316dc4265a97d0e8445a22c7a6d17580a4 ]

Currently, these options cause the following libkmod error:

libkmod: ERROR ../libkmod/libkmod-config.c:489 kcmdline_parse_result: \
	Ignoring bad option on kernel command line while parsing module \
	name: 'ivrs_xxxx[XX:XX'

Fix by introducing a new parameter format for these options and
throw a warning for the deprecated format.

Users are still allowed to omit the PCI Segment if zero.

Adding a Link: to the reason why we're modding the syntax parsing
in the driver and not in libkmod.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-modules/20200310082308.14318-2-lucas.demarchi@intel.com/
Reported-by: Kim Phillips <kim.phillips@amd.com>
Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lore.kernel.org/r/20220919155638.391481-2-kim.phillips@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         | 27 +++++--
 drivers/iommu/amd/init.c                      | 79 +++++++++++++------
 2 files changed, 76 insertions(+), 30 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ce93bb358bc1..eb437d659f2c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2105,7 +2105,13 @@
 			Provide an override to the IOAPIC-ID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
 			By default, PCI segment is 0, and can be omitted.
-			For example:
+
+			For example, to map IOAPIC-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_ioapic=10@0001:00:14.0
+
+			Deprecated formats:
 			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
 			  write the parameter as:
 				ivrs_ioapic[10]=00:14.0
@@ -2117,7 +2123,13 @@
 			Provide an override to the HPET-ID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
 			By default, PCI segment is 0, and can be omitted.
-			For example:
+
+			For example, to map HPET-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_hpet=10@0001:00:14.0
+
+			Deprecated formats:
 			* To map HPET-ID decimal 0 to PCI device 00:14.0
 			  write the parameter as:
 				ivrs_hpet[0]=00:14.0
@@ -2128,15 +2140,20 @@
 	ivrs_acpihid	[HW,X86-64]
 			Provide an override to the ACPI-HID:UID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
 
 			For example, to map UART-HID:UID AMD0020:0 to
 			PCI segment 0x1 and PCI device ID 00:14.5,
 			write the parameter as:
-				ivrs_acpihid[0001:00:14.5]=AMD0020:0
+				ivrs_acpihid=AMD0020:0@0001:00:14.5
 
-			By default, PCI segment is 0, and can be omitted.
-			For example, PCI device 00:14.5 write the parameter as:
+			Deprecated formats:
+			* To map UART-HID:UID AMD0020:0 to PCI segment is 0,
+			  PCI device ID 00:14.5, write the parameter as:
 				ivrs_acpihid[00:14.5]=AMD0020:0
+			* To map UART-HID:UID AMD0020:0 to PCI segment 0x1 and
+			  PCI device ID 00:14.5, write the parameter as:
+				ivrs_acpihid[0001:00:14.5]=AMD0020:0
 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joydev/joystick.rst.
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 85370f305aa8..ce822347f747 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3051,18 +3051,24 @@ static int __init parse_amd_iommu_options(char *str)
 static int __init parse_ivrs_ioapic(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	int ret, id, i;
+	int id, i;
 	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-	if (ret != 4) {
-		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_ioapic%s\n", str);
-			return 1;
-		}
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
+
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_ioapic%s option format deprecated; use ivrs_ioapic=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_ioapic%s\n", str);
+	return 1;
+
+found:
 	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
 			str);
@@ -3083,18 +3089,24 @@ static int __init parse_ivrs_ioapic(char *str)
 static int __init parse_ivrs_hpet(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	int ret, id, i;
+	int id, i;
 	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-	if (ret != 4) {
-		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_hpet%s\n", str);
-			return 1;
-		}
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
+
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_hpet%s option format deprecated; use ivrs_hpet=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_hpet%s\n", str);
+	return 1;
+
+found:
 	if (early_hpet_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early HPET map overflow - ignoring ivrs_hpet%s\n",
 			str);
@@ -3115,19 +3127,36 @@ static int __init parse_ivrs_hpet(char *str)
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	char *hid, *uid, *p;
+	char *hid, *uid, *p, *addr;
 	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
-	int ret, i;
-
-	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
-	if (ret != 4) {
-		ret = sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
-			return 1;
+	int i;
+
+	addr = strchr(str, '@');
+	if (!addr) {
+		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
+		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
+			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
+				str, acpiid, seg, bus, dev, fn);
+			goto found;
 		}
+		goto not_found;
 	}
 
+	/* We have the '@', make it the terminator to get just the acpiid */
+	*addr++ = 0;
+
+	if (sscanf(str, "=%s", acpiid) != 1)
+		goto not_found;
+
+	if (sscanf(addr, "%x:%x.%x", &bus, &dev, &fn) == 3 ||
+	    sscanf(addr, "%x:%x:%x.%x", &seg, &bus, &dev, &fn) == 4)
+		goto found;
+
+not_found:
+	pr_err("Invalid command line: ivrs_acpihid%s\n", str);
+	return 1;
+
+found:
 	p = acpiid;
 	hid = strsep(&p, ":");
 	uid = p;
-- 
2.35.1



