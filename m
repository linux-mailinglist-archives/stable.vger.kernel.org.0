Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D595BD182
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiISP5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 11:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiISP5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 11:57:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF65910544;
        Mon, 19 Sep 2022 08:57:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhOOe4EiocUMCCZso36NSn+Zfmq3nMqD32PTQRKA0iWo47o+gvvizRH9MGPFnZovYQ9HwxQjWhk2RjhvVFjx1asflbdWQHTmEj1/A+Yn4gprUEzLTHAf7Fg9gO33MyB8lI3JYDTX+Ojw+V+db2uW1O5QggQTxEWwftbEnGGsv189xRNymyKjvSSjYhhusUm9gWSBnHf/pLR9SVM2GsmEbp2+5DTxpuzFmSaWW0x8zGkQRSHvsVQqOFmUQeThBu4++xU1mf332kUQfhikYGskkmxBGSNkJ8wvBcmhI6zp36gWu8LTNkWna4VjOvNtNtE/nUeYTDfNuz6e3cniNfawrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzcmikmZ3O8qk+Tp6UNoyLo2uEXUGdDF7nXUHRdSzwE=;
 b=JPWxPLA1HenoJ8G4KSMPSOqwgdRR3mkm0mnd0nWKy2oMEqE7Q5+SOqtY51c1gT9uAnR6Uq5wzOScLYNyVd+TZ5ZmkPdiyqm/d9iTieN1udgDG8LtbDXda58u8+aRCgfMUP7sIVoiPSchwy99DO9/lBXV2ri1y9tJgFPRO09vZOapvYhGF7sYH1yNfjyOrTn1zlJ4dg2GRTOAM5XqXWUF613Tk5UnM45logWtig7L5wqbW/+X7rejHE8zlGjuBbeb5z2aUDcgce5hOc5wBXJWw/pgBAg1gq6A4a6+JxGB4quw8fzuiIm9abFjlohz8Pc6PHapUbRaVjjxgA7oYTQe1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzcmikmZ3O8qk+Tp6UNoyLo2uEXUGdDF7nXUHRdSzwE=;
 b=Vsq1N/Lpi4NblSl4prSdcqn7QbVFPMnWs6f8Krqsjgj2szuSw7uyl4nWPTXEuEcfpwlvkmp7+Crz+XOgn2jhF9U1vuJtD800naeQLQhNEr8V/72rCqkILkrcS1/idgzp0T7nQ68m3dCf4r08hvaNM0/pIHEBqwOxfAVrx4mOmfs=
Received: from MW4PR03CA0175.namprd03.prod.outlook.com (2603:10b6:303:8d::30)
 by DS7PR12MB6358.namprd12.prod.outlook.com (2603:10b6:8:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Mon, 19 Sep
 2022 15:57:15 +0000
Received: from CO1NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::a5) by MW4PR03CA0175.outlook.office365.com
 (2603:10b6:303:8d::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Mon, 19 Sep 2022 15:57:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT085.mail.protection.outlook.com (10.13.174.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 15:57:14 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 19 Sep
 2022 10:57:06 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     <iommu@lists.linux.dev>, <joro@8bytes.org>
CC:     <robin.murphy@arm.com>, <suravee.suthikulpanit@amd.com>,
        <vasant.hegde@amd.com>, Mike Day <michael.day@amd.com>,
        <linux-acpi@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options
Date:   Mon, 19 Sep 2022 10:56:38 -0500
Message-ID: <20220919155638.391481-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220919155638.391481-1-kim.phillips@amd.com>
References: <20220919155638.391481-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT085:EE_|DS7PR12MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 4404d3c7-6259-440a-e4b9-08da9a579f34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wa8FvQun4ezEBUVy3t3T12UsaTQn2R+Zy0iQZAWgka11og+LKz1zkGzCrpLk6F+CnkQHarHBwHyXmiDI8ynL1X5jGexvY46369OQ9Y5J7DlG+ozxniKliOzf+41bxoWSHwAA0htrYqdxdPe2XqM1AN9OZPXVptDci8NhnAGXiKjCXHGD5u9yWUaZycnaqUcABxk096UlzjLzrzaENdhHmOHKhKFZMzyWStC+ckkGmvsZcbekwar4EwO+2ILj4qAO7o5WFmn10f8qzcocbO2ONUnzBnfaP9w4YONuGJbr+Hrrcg8d0eymw1yo7Ci4bdqbcbCyejHT9/DOhF3kCDIZMt1H+8PNUTY8ptZSx7mGOhA29WMucXbjElMFv3RR48X6byFf13VpmFtgeE2QHsNP22qnVnLgpFcN+uoYEiYjswWZUhVnDxKE+SftO4CBG0ycmC7gUsSsmCKLo0hYE+sH5/TFuzyjrMK60gEgOtKr4jcrOqRx1ncJyY9Layh2vfg/1JB5wDGpDrpVj+bLCRKr4/346R+guLm8w+6jM58pAhxevBgQxQknkk6gOWpdEz9ZiaunxR3MbMjfe2X6rG1hjawAv1DlzHPfc0LiNsSI1bYkyB5bKeM2GrcLeJ/fFTcySzblp9zSjwLj85WliSyUqD5PX7Xa2YgVIS54ZlsW2MDosH+Qg6VtilOGrIyxjKgc5iOd5s2jcDaarfmXWwmdqTiMNg58rQXp6ZDRwJrZYDSkai41M4Tg2+isYQbPm01Y9OX9btfbBqVkKXl0JX/PrnwTx0fIFR2nsSBMzJwCN9p43pW0xUgNBo6Yb3C8SjxnjvvZOFGCVFDK5ZhJApByNA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(36860700001)(44832011)(4326008)(36756003)(478600001)(110136005)(966005)(70206006)(70586007)(54906003)(41300700001)(7696005)(6666004)(86362001)(2616005)(8936002)(82310400005)(81166007)(26005)(356005)(336012)(40460700003)(16526019)(83380400001)(5660300002)(40480700001)(82740400003)(8676002)(316002)(186003)(1076003)(47076005)(426003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 15:57:14.8347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4404d3c7-6259-440a-e4b9-08da9a579f34
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6358
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
v2:
 - Address Robin Murphy's comment:  Have deprecated users see:
   "option format deprecated; use ivrs_ioapic=%d@%04x:%02x:%02x.%d instead"
 - Fix cut-n-paste bug: ivrs_ioapic= -> ivrs_hpet=

 .../admin-guide/kernel-parameters.txt         | 27 +++++--
 drivers/iommu/amd/init.c                      | 79 +++++++++++++------
 2 files changed, 76 insertions(+), 30 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d7f30902fda0..77f780ad343e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2294,7 +2294,13 @@
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
@@ -2306,7 +2312,13 @@
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
@@ -2317,15 +2329,20 @@
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
index ef0e1a4b5a11..6601b677c250 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3385,18 +3385,24 @@ static int __init parse_amd_iommu_options(char *str)
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
@@ -3417,18 +3423,24 @@ static int __init parse_ivrs_ioapic(char *str)
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
@@ -3449,19 +3461,36 @@ static int __init parse_ivrs_hpet(char *str)
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
2.34.1

