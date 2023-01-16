Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD366C5FC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjAPQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjAPQMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:12:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB942A9B8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55A65B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F03C433D2;
        Mon, 16 Jan 2023 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885257;
        bh=9yUbqhO6HDPS1BlPTIuWkk18+nDnbezK4s38zw/kmYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iodd7vTUSC+JPwjWQNd1O1YhnB4HtFEf0MuAcLGE/onFj+gmhbK/vVsEH+Ji3taEp
         7rmi0f6d83ndyONiXx3/TtB9hSshc8eTYyC47QCZWPsjTMk21EBKKyqxIStoD8Tj1u
         Ac5Y+cvM5SDYGPmoyJUWP1/PeGaOsI83EJG8Lwe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasant Hegde <vasant.hegde@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/64] iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands
Date:   Mon, 16 Jan 2023 16:51:25 +0100
Message-Id: <20230116154744.254125014@linuxfoundation.org>
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

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit bbe3a106580c21bc883fb0c9fa3da01534392fe8 ]

By default, PCI segment is zero and can be omitted. To support system
with non-zero PCI segment ID, modify the parsing functions to allow
PCI segment ID.

Co-developed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20220706113825.25582-33-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 1198d2316dc4 ("iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         | 34 ++++++++++----
 drivers/iommu/amd/init.c                      | 44 ++++++++++++-------
 2 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f577c29f2093..ce93bb358bc1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2103,23 +2103,39 @@
 
 	ivrs_ioapic	[HW,X86-64]
 			Provide an override to the IOAPIC-ID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map IOAPIC-ID decimal 10 to
-			PCI device 00:14.0 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+			For example:
+			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
+			  write the parameter as:
 				ivrs_ioapic[10]=00:14.0
+			* To map IOAPIC-ID decimal 10 to PCI segment 0x1 and
+			  PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=0001:00:14.0
 
 	ivrs_hpet	[HW,X86-64]
 			Provide an override to the HPET-ID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map HPET-ID decimal 0 to
-			PCI device 00:14.0 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
+			For example:
+			* To map HPET-ID decimal 0 to PCI device 00:14.0
+			  write the parameter as:
 				ivrs_hpet[0]=00:14.0
+			* To map HPET-ID decimal 10 to PCI segment 0x1 and
+			  PCI device 00:14.0 write the parameter as:
+				ivrs_ioapic[10]=0001:00:14.0
 
 	ivrs_acpihid	[HW,X86-64]
 			Provide an override to the ACPI-HID:UID<->DEVICE-ID
-			mapping provided in the IVRS ACPI table. For
-			example, to map UART-HID:UID AMD0020:0 to
-			PCI device 00:14.5 write the parameter as:
+			mapping provided in the IVRS ACPI table.
+
+			For example, to map UART-HID:UID AMD0020:0 to
+			PCI segment 0x1 and PCI device ID 00:14.5,
+			write the parameter as:
+				ivrs_acpihid[0001:00:14.5]=AMD0020:0
+
+			By default, PCI segment is 0, and can be omitted.
+			For example, PCI device 00:14.5 write the parameter as:
 				ivrs_acpihid[00:14.5]=AMD0020:0
 
 	js=		[HW,JOY] Analog joystick
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 310ab24d003a..85370f305aa8 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -85,6 +85,10 @@
 #define ACPI_DEVFLAG_ATSDIS             0x10000000
 
 #define LOOP_TIMEOUT	2000000
+
+#define IVRS_GET_SBDF_ID(seg, bus, dev, fd)	(((seg & 0xffff) << 16) | ((bus & 0xff) << 8) \
+						 | ((dev & 0x1f) << 3) | (fn & 0x7))
+
 /*
  * ACPI table definitions
  *
@@ -3046,15 +3050,17 @@ static int __init parse_amd_iommu_options(char *str)
 
 static int __init parse_ivrs_ioapic(char *str)
 {
-	unsigned int bus, dev, fn;
+	u32 seg = 0, bus, dev, fn;
 	int ret, id, i;
-	u16 devid;
+	u32 devid;
 
 	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-
 	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_ioapic%s\n", str);
-		return 1;
+		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
+		if (ret != 5) {
+			pr_err("Invalid command line: ivrs_ioapic%s\n", str);
+			return 1;
+		}
 	}
 
 	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
@@ -3063,7 +3069,7 @@ static int __init parse_ivrs_ioapic(char *str)
 		return 1;
 	}
 
-	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 
 	cmdline_maps			= true;
 	i				= early_ioapic_map_size++;
@@ -3076,15 +3082,17 @@ static int __init parse_ivrs_ioapic(char *str)
 
 static int __init parse_ivrs_hpet(char *str)
 {
-	unsigned int bus, dev, fn;
+	u32 seg = 0, bus, dev, fn;
 	int ret, id, i;
-	u16 devid;
+	u32 devid;
 
 	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-
 	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_hpet%s\n", str);
-		return 1;
+		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
+		if (ret != 5) {
+			pr_err("Invalid command line: ivrs_hpet%s\n", str);
+			return 1;
+		}
 	}
 
 	if (early_hpet_map_size == EARLY_MAP_SIZE) {
@@ -3093,7 +3101,7 @@ static int __init parse_ivrs_hpet(char *str)
 		return 1;
 	}
 
-	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 
 	cmdline_maps			= true;
 	i				= early_hpet_map_size++;
@@ -3106,15 +3114,18 @@ static int __init parse_ivrs_hpet(char *str)
 
 static int __init parse_ivrs_acpihid(char *str)
 {
-	u32 bus, dev, fn;
+	u32 seg = 0, bus, dev, fn;
 	char *hid, *uid, *p;
 	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
 	int ret, i;
 
 	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
 	if (ret != 4) {
-		pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
-		return 1;
+		ret = sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid);
+		if (ret != 5) {
+			pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
+			return 1;
+		}
 	}
 
 	p = acpiid;
@@ -3136,8 +3147,7 @@ static int __init parse_ivrs_acpihid(char *str)
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
-	early_acpihid_map[i].devid =
-		((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+	early_acpihid_map[i].devid = IVRS_GET_SBDF_ID(seg, bus, dev, fn);
 	early_acpihid_map[i].cmd_line	= true;
 
 	return 1;
-- 
2.35.1



