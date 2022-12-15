Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7340264E1A7
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 20:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiLOTRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 14:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiLOTQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 14:16:36 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9285F396DC;
        Thu, 15 Dec 2022 11:16:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kY8YxhLZ/s7NSlBOBVhHC1apxw5pzVJmoxB/ebma+bQO5LgZ4mWGkM59HGXNq6tDUS6/r1AfjxQvqs4z3m8rsxLWfN4ZEJNl02vy+LFlnJlg8+Ly0SagkrKxc9dqRfidmQmOO6rji3mZcxj1n/xl+qGNaYDMMLsu4unJwBd3eMUBtALcLbGY7qQzVZ4jVM1dONejl7LrKzMWpckw5xBvOQgOmam5WhiwQLJ+bJ4olIzVHzOT4ihIADcXOxQUq89s/LIXIwJZkh4DjthEKCcwGi/B5PGT7iQegO6TtTnTjKqmX4chNPCEVC9tkvwLRJUbSNIXNNqB+aJyn4PMc2rQcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKV1mNoprL/sMayTX60gSb0wkWjN1K2SbLfP+Cw+2VI=;
 b=guZs9MhO72m4uc5AZdStbfXYrX8KR0icsWGFjh2AKiDQuo85ZCRNQ7ODpy3qSOO9Edh4oQ0BppluKuUNp+BVLpcNV3e8YXPrku2598rULTpeF4aHyhekHbVuyoFot7cZvZ0tzRzdFdpiaMNY5lNcbs82YVgEOSjq0k4FGkCwr8PYmBPBxYBTcjppWwIX8MvkNiwV+TNsplgmw4A/qqmYTtUSyR4i2r1ez5Uj9OdxYhQ1Pun/I7NHRqQu2vpSmUma59N9fmHIQ1hMSi4cIoUQkvSVfBjykOPWy3K7r/TNlhjTA6+P/nHhKlGyLEWFVBO572LkTF30gLrW6Md+Q2Q3Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKV1mNoprL/sMayTX60gSb0wkWjN1K2SbLfP+Cw+2VI=;
 b=BNYQs+bywSnQ9XlTyHBRnpS+dkth8AG5k2BaXxGJ6jIm0dD0QuBa8HFeyQ5hsVcr0HggMfCGYiH76rv5M6mVeF0EtQMIlfXUOIrpWp0Vts1lAMahSVaJNz8jBSgSS7eyGuX5JEn1N75du91WvEOxAgjZQOorBmOkq2v5gOJh/E0=
Received: from DM6PR07CA0115.namprd07.prod.outlook.com (2603:10b6:5:330::6) by
 PH7PR12MB8154.namprd12.prod.outlook.com (2603:10b6:510:2b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 19:16:33 +0000
Received: from DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::fb) by DM6PR07CA0115.outlook.office365.com
 (2603:10b6:5:330::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12 via Frontend
 Transport; Thu, 15 Dec 2022 19:16:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT108.mail.protection.outlook.com (10.13.172.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.12 via Frontend Transport; Thu, 15 Dec 2022 19:16:32 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 15 Dec
 2022 13:16:31 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <rafael@kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC:     <anson.tsao@amd.com>, <ben@bcheng.me>, <paul@zogpog.com>,
        <bilkow@tutanota.com>, <Shyam-sundar.S-k@amd.com>,
        <stable@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+
Date:   Thu, 15 Dec 2022 13:16:16 -0600
Message-ID: <20221215191617.1438-3-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221215191617.1438-1-mario.limonciello@amd.com>
References: <20221215191617.1438-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT108:EE_|PH7PR12MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: 28538afb-ca4e-4229-b7b7-08daded0e077
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kE2tQkXGoO/tiOIQAjfnvi3V3k+FNzN8x9meKkgkrhyDz0qu8+W/Ho3Gf2qT0coGVClTyvlm9DZapaEsh/Cq6OGBs/7PVzeVun6KjiMxkoVrghepuZXxJ1kHm/iDUcHKDIR7N+GDG1mohJnUFvFk18dp8xMGf0pKUswPVjzMGHGolKgbaG+xvKLp2oSTTa9yvKR7vrlmBtTymP5na2vMZ3A+f3r6AXNXxUrp0d5SnK/zHLB3pG/StgyUEWD0gGeuV06LM3QfRhMO3eD9LhIesUuoP6SyJGpQU3LFP0tPuIpigiYgjwJTysHKRM4bhlsc8iPJPyAHIRw6iax6del2rXytMhdZLU2fC8hfjIfrevipXGspKk3VJTgEAReyVhhwf/hP9lP2EUNm0V+3SsGDzzxzzF3j04xAGmRsvFsFKVDpIEE1ThYk5UMuCrvA59p/V5Qg5SrOn45o7lSJNqa7uCextGP4yRQ/Lmgk3tJZhYzgDglrIx29yaw7ubmvFksNvrHdLMgYYlQLWUWA8gsCAV0B+nhK5J2gPuPdV1ca2YuGkMO3gA+FHoHcVpBqc8ovBmzlhZxWD2s8Cb8l+r2++yyKp9Sip5hzMuQ7817o2pliGGC+GsqruYAAd7yJgAvyTp/iDssCiNy+XH1BVRnxe87m4gflN+k0uKVdOXM2Niq//SLBU5iNOvPl6uGY7+4Z411lsZTwUknTJspPWbfhmPolm0r3mIwnrRlzLoeCYjxJNzgz63vCG5foAnn3Xh9TX0K1U2Io0TfFLP0GXhmBSxTP7OT2ToO/N8H1HYpPEYMQd3k+ihC7/i8zbQ4cFC1t
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(54906003)(110136005)(2906002)(8936002)(336012)(1076003)(41300700001)(8676002)(2616005)(70586007)(70206006)(36860700001)(5660300002)(40480700001)(47076005)(316002)(426003)(36756003)(83380400001)(44832011)(7416002)(40460700003)(4326008)(86362001)(82310400005)(478600001)(6666004)(26005)(186003)(82740400003)(45080400002)(7696005)(16526019)(966005)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:16:32.6071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28538afb-ca4e-4229-b7b7-08daded0e077
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After we introduced a module parameter and quirk infrastructure for
picking the Microsoft GUID over the SOC vendor GUID we discovered
that lots and lots of systems are getting this wrong.

The table continues to grow, and is becoming unwieldy.

We don't really have any benefit to forcing vendors to populate the
AMD GUID. This is just extra work, and more and more vendors seem
to mess it up.  As the Microsoft GUID is used by Windows as well,
it's very likely that it won't be messed up like this.

So drop all the quirks forcing it and the Rembrandt behavior. This
means that Cezanne or later effectively only run the Microsoft GUID
codepath with the exception of HP Elitebook 8*5 G9.

Fixes: fd894f05cf30 ("ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt")
Cc: stable@vger.kernel.org # 6.1
Reported-by: Benjamin Cheng <ben@bcheng.me>
Reported-by: bilkow@tutanota.com
Reported-by: Paul <paul@zogpog.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2292
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216768
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/acpi/x86/s2idle.c | 87 ++-------------------------------------
 1 file changed, 3 insertions(+), 84 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 422415cb14f4..c7afce465a07 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -28,10 +28,6 @@ static bool sleep_no_lps0 __read_mostly;
 module_param(sleep_no_lps0, bool, 0644);
 MODULE_PARM_DESC(sleep_no_lps0, "Do not use the special LPS0 device interface");
 
-static bool prefer_microsoft_dsm_guid __read_mostly;
-module_param(prefer_microsoft_dsm_guid, bool, 0644);
-MODULE_PARM_DESC(prefer_microsoft_dsm_guid, "Prefer using Microsoft GUID in LPS0 device _DSM evaluation");
-
 static const struct acpi_device_id lps0_device_ids[] = {
 	{"PNP0D80", },
 	{"", },
@@ -369,27 +365,15 @@ static int validate_dsm(acpi_handle handle, const char *uuid, int rev, guid_t *d
 }
 
 struct amd_lps0_hid_device_data {
-	const unsigned int rev_id;
 	const bool check_off_by_one;
-	const bool prefer_amd_guid;
 };
 
 static const struct amd_lps0_hid_device_data amd_picasso = {
-	.rev_id = 0,
 	.check_off_by_one = true,
-	.prefer_amd_guid = false,
 };
 
 static const struct amd_lps0_hid_device_data amd_cezanne = {
-	.rev_id = 0,
 	.check_off_by_one = false,
-	.prefer_amd_guid = false,
-};
-
-static const struct amd_lps0_hid_device_data amd_rembrandt = {
-	.rev_id = 2,
-	.check_off_by_one = false,
-	.prefer_amd_guid = true,
 };
 
 static const struct acpi_device_id amd_hid_ids[] = {
@@ -397,7 +381,6 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{"AMD0005",	(kernel_ulong_t)&amd_picasso,	},
 	{"AMDI0005",	(kernel_ulong_t)&amd_picasso,	},
 	{"AMDI0006",	(kernel_ulong_t)&amd_cezanne,	},
-	{"AMDI0007",	(kernel_ulong_t)&amd_rembrandt,	},
 	{}
 };
 
@@ -407,68 +390,7 @@ static int lps0_prefer_amd(const struct dmi_system_id *id)
 	rev_id = 2;
 	return 0;
 }
-
-static int lps0_prefer_microsoft(const struct dmi_system_id *id)
-{
-	pr_debug("Preferring Microsoft GUID.\n");
-	prefer_microsoft_dsm_guid = true;
-	return 0;
-}
-
 static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
-	{
-		/*
-		 * ASUS TUF Gaming A17 FA707RE
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216101
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS TUF Gaming A17"),
-		},
-	},
-	{
-		/* ASUS ROG Zephyrus G14 (2022) */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Zephyrus G14 GA402"),
-		},
-	},
-	{
-		/*
-		 * Lenovo Yoga Slim 7 Pro X 14ARH7
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216473 : 82V2
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216438 : 82TL
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "82"),
-		},
-	},
-	{
-		/*
-		 * ASUSTeK COMPUTER INC. ROG Flow X13 GV301RE_GV301RE
-		 * https://gitlab.freedesktop.org/drm/amd/-/issues/2148
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow X13 GV301"),
-		},
-	},
-	{
-		/*
-		 * ASUSTeK COMPUTER INC. ROG Flow X16 GV601RW_GV601RW
-		 * https://gitlab.freedesktop.org/drm/amd/-/issues/2148
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow X16 GV601"),
-		},
-	},
 	{
 		/*
 		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
@@ -504,16 +426,14 @@ static int lps0_device_attach(struct acpi_device *adev,
 		if (dev_id->id[0])
 			data = (const struct amd_lps0_hid_device_data *) dev_id->driver_data;
 		else
-			data = &amd_rembrandt;
-		rev_id = data->rev_id;
+			data = &amd_cezanne;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID_AMD, rev_id, &lps0_dsm_guid);
 		if (lps0_dsm_func_mask > 0x3 && data->check_off_by_one) {
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
 					  ACPI_LPS0_DSM_UUID_AMD, lps0_dsm_func_mask);
-		} else if (lps0_dsm_func_mask_microsoft > 0 && data->prefer_amd_guid &&
-				!prefer_microsoft_dsm_guid) {
+		} else if (lps0_dsm_func_mask_microsoft > 0 && rev_id) {
 			lps0_dsm_func_mask_microsoft = -EINVAL;
 			acpi_handle_debug(adev->handle, "_DSM Using AMD method\n");
 		}
@@ -521,8 +441,7 @@ static int lps0_device_attach(struct acpi_device *adev,
 		rev_id = 1;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID, rev_id, &lps0_dsm_guid);
-		if (!prefer_microsoft_dsm_guid)
-			lps0_dsm_func_mask_microsoft = -EINVAL;
+		lps0_dsm_func_mask_microsoft = -EINVAL;
 	}
 
 	if (lps0_dsm_func_mask < 0 && lps0_dsm_func_mask_microsoft < 0)
-- 
2.34.1

