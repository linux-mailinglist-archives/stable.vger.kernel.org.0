Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B144A65F4FB
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 21:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbjAEULj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 15:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjAEULi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 15:11:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF5BDFB2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:11:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EU8DWGiA4JV8qBCeiSRdfbYGLGMYLDQruAAU4MAwxB1moIlfxJteqK3tuir79jg0/cAJtT9/GdJ0opy9iu/m3rNSH5J9Cgc2TVuIE8xdu5pyGkISEZ9i0oaF0h2anf0lu8oDu0jZKazAXhPUChmZG969GMCEG7w0DIyewzu1pk3N06RtPB5SAZqnWAwhAtw1CWh+xzV9Cdf1gCtwjSWMuupTEJDASCKrJz50oVnhLaofyWJNEOu6zDKzRCIaq1QFtbIFoKVyGPkmiArwx3OZVxtJwqieCjXQP9Bp7fAICWCTiAzxfcBxeNLm0H8lFW+f+1mP+C8qsPJDxuLLaVxpJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcvGsrbXCM8ZxieicHPsncX0BA31G49JGM9EJDgvh+o=;
 b=Rfuz+AYhBSZHICN4uoYv/ENulipOWD90f+5Geaychge/4to1P2YLWjU/ud7c4zVu0YXI2syh7t19uXiQdhWz3lVyFOHdEhMey79s88RBasHl04OUk8rmeBR9mWrNGU77EfopAHXXZqEArZP8NU1qj351LDip5dyEiE4GOdiNb2yvKri7fkkdjyyhp/YVyTratbS/lIF2H7G/Jax4JMWPRpz5Hur5HBcdRGIbkw/qvghdo82eDkGKJPCUX/dzVV89V/oyFaQyXYHvuRBveCwvNg8Ftu89aIbdB0lJlwKiFnjJqW28BOPt2OOZfZsb/qG9/AXVOWH05hi4xarvRgrBzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcvGsrbXCM8ZxieicHPsncX0BA31G49JGM9EJDgvh+o=;
 b=QNCF5CqkLvY1BHXC2ZXu89Kxo8bPdSH0TPtWrpMMcUwz/+Q2Y10hZAsruEucf2a2KpdkDLawcKjABlgV2nMprl++EnE1McthGILGT9KI/OEkwkBmgbm04wPE8OcqweTGhaZ7ETsTb34L/u+rZXv84XmcbD9RNhFAVFw42chu5AY=
Received: from CY5PR18CA0014.namprd18.prod.outlook.com (2603:10b6:930:5::13)
 by PH0PR12MB7077.namprd12.prod.outlook.com (2603:10b6:510:21d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 20:11:34 +0000
Received: from CY4PEPF0000C972.namprd02.prod.outlook.com
 (2603:10b6:930:5:cafe::91) by CY5PR18CA0014.outlook.office365.com
 (2603:10b6:930:5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 20:11:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C972.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Thu, 5 Jan 2023 20:11:34 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 5 Jan
 2023 14:11:33 -0600
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15.y] Revert "ACPI: PM: Add support for upcoming AMD uPEP HID AMDI007"
Date:   Thu, 5 Jan 2023 14:10:50 -0600
Message-ID: <20230105201050.20602-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C972:EE_|PH0PR12MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: 241987d9-e723-483d-4dec-08daef590b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGlEZhy5bbQnmfwxppY878hV863aVLG0XZo/a7uBc/EMtdjTeTG+qUCzIObQg06hR+EuywdI5DiGubSHVoNB/7d9NVu5SvcODB6AXh7O1uo4HOkEMhuz7uUmaPlFAPeMuVg1L1KZk5SJlRPRQ30184On5k5DcLNfkDwm0bp2EvxLSCOOCqjJgk4HwWwVyNiFp7FUqTeJf9Bh75Bh1E4RkhzkOjhL6wnimU2JDrau74KdAeyirQ8Yj0t4nze36n1iGe2GbRg7vYDlueebIwKKgqviCNGaP1mk3hj9egnY1ykj72vie0qslEp+zmQr7c8dg3VxpXTeG2XU8rTptMi5SIdllhQ7sTHVbNYn9Y5h3Rn26g+DAVoq8dgDK92RK9t7xQM8ah/grnei+5oiaVr0XpiAxXhxVmz31Hmd6HaQESnrgJf7oSwyHj3SHT9XmKAn4tEwnRMANrFTIRO5O8DBWuBhK44GZ8goqty4qwPPtjn8Uz1K41OH+6HsQ0C4UCRpC9ykGst2TTMP7H5c9qmapaLMQX+Dwp4yUZtRmiKADT1ORt7nS/UO01ZKCrcL1Qs11mnMqaG4Xsg251cxlKgkb8hr0NN+1nm89YT1fVTbNdWRFczULl6TQfoimZM4OvVsyp7hdRNXjQ+fbf9tfk2zIzRTdN+ee3mIDWV0WHkJCyg9ecWaoKtmSa5dYKFX1nDtrETUX9gCY8ld0UEm3kJ2TP+7LS3TzD1k0lvGj3cI0hW5QVb8mlfRnJvaJg/X4LawpiihyYd3hjJ8YiL7agq9RA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(26005)(5660300002)(186003)(16526019)(83380400001)(6666004)(36860700001)(44832011)(40480700001)(41300700001)(2906002)(426003)(336012)(47076005)(7696005)(81166007)(70206006)(70586007)(86362001)(45080400002)(8676002)(4326008)(40460700003)(2616005)(82310400005)(8936002)(82740400003)(1076003)(356005)(6916009)(966005)(316002)(36756003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 20:11:34.6192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 241987d9-e723-483d-4dec-08daef590b50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C972.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A number of AMD based Rembrandt laptops are not working properly in
suspend/resume.  This has been root caused to be from the BIOS
implementation not populating code for the AMD GUID in uPEP, but
instead only the Microsoft one.

In later kernels this has been fixed by using the Microsoft GUID
instead.

The following series of patches has fixed it in newer kernels:

commit ed470febf837 ("ACPI: PM: s2idle: Add support for upcoming AMD uPEP
HID AMDI008")
commit 1a2dcab517cb ("ACPI: PM: s2idle: Use LPS0 idle if
ACPI_FADT_LOW_POWER_S0 is unset")
commit 100a57379380 ("ACPI: x86: s2idle: Move _HID handling for AMD
systems into structures")
commit fd894f05cf30 ("ACPI: x86: s2idle: If a new AMD _HID is missing
assume Rembrandt")
commit a0bc002393d4 ("ACPI: x86: s2idle: Add module parameter to prefer
Microsoft GUID")
commit d0f61e89f08d ("ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming
A17 FA707RE")
commit ddeea2c3cb88 ("ACPI: x86: s2idle: Add a quirk for ASUS ROG
Zephyrus G14")
commit 888ca9c7955e ("ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7
Pro 14ARH7")
commit 631b54519e8e ("ACPI: x86: s2idle: Add a quirk for ASUSTeK
COMPUTER INC. ROG Flow X13")
commit 39f81776c680 ("ACPI: x86: s2idle: Fix a NULL pointer dereference")
commit 54bd1e548701 ("ACPI: x86: s2idle: Add another ID to
s2idle_dmi_table")
commit 577821f756cf ("ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP
Elitebook 865")
commit e6d180a35bc0 ("ACPI: x86: s2idle: Stop using AMD specific codepath
for Rembrandt+")

This is needlessly complex for 5.15.y though.  To accomplish the same
effective result revert commit f0c6225531e4 ("ACPI: PM: Add support for
upcoming AMD uPEP HID AMDI007") instead.

Link: https://lore.kernel.org/stable/MN0PR12MB61015DB3D6EDBFD841157918E2F59@MN0PR12MB6101.namprd12.prod.outlook.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/acpi/x86/s2idle.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index e0185e841b2a..2af1ae172102 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -378,16 +378,13 @@ static int lps0_device_attach(struct acpi_device *adev,
 		 * AMDI0006:
 		 * - should use rev_id 0x0
 		 * - function mask = 0x3: Should use Microsoft method
-		 * AMDI0007:
-		 * - Should use rev_id 0x2
-		 * - Should only use AMD method
 		 */
 		const char *hid = acpi_device_hid(adev);
-		rev_id = strcmp(hid, "AMDI0007") ? 0 : 2;
+		rev_id = 0;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID_AMD, rev_id, &lps0_dsm_guid);
 		lps0_dsm_func_mask_microsoft = validate_dsm(adev->handle,
-					ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
+					ACPI_LPS0_DSM_UUID_MICROSOFT, rev_id,
 					&lps0_dsm_guid_microsoft);
 		if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
 						 !strcmp(hid, "AMD0005") ||
@@ -395,9 +392,6 @@ static int lps0_device_attach(struct acpi_device *adev,
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
 					  ACPI_LPS0_DSM_UUID_AMD, lps0_dsm_func_mask);
-		} else if (lps0_dsm_func_mask_microsoft > 0 && !strcmp(hid, "AMDI0007")) {
-			lps0_dsm_func_mask_microsoft = -EINVAL;
-			acpi_handle_debug(adev->handle, "_DSM Using AMD method\n");
 		}
 	} else {
 		rev_id = 1;
-- 
2.34.1

