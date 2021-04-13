Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF2F35DC23
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbhDMKGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:06:06 -0400
Received: from mail-co1nam11on2043.outbound.protection.outlook.com ([40.107.220.43]:39552
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230381AbhDMKGF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 06:06:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YV2sRzkWc3fYrVRHhLf4Jvc5dmJFd0nVmxsUySuEEWWpndSS+WjT41qWPyQAUba981uUyX53rDm4Kc6/tOdd94Pfwzxg4MAPB/Oq4lsCXokC5tq/HfEqN3TRcmLmFvf8AbxvPL4tSM/btkEasOMSTMznII3rgLS6dlO91W/cH1FMLUefCCn/CCUNczSwCcmuAaDoCKPSpXFa1NAG5EgCMC3cdfXoCaWkAm1FMPlGPCs1q6x1oal9i5asMkpFfs61EeW8Ie7mHlj57K56s9C364LiM4Sabehx0HMEqTtbNZ57ijxB7SsXZpS6DzyyLJYLNED4m/0OOSHsolWw9VYocw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iXExUsuKImsbZEO0Vr3ZlyhpYDO0jH0zZPj19c/gos=;
 b=cEPJIjL5MHQleXjxkNLJ6lR5AJGg7BzRl/XKteOxPBcpieaMbY//eLo4VJyqj3RiC1+Z1RUxUkxivhW/j60rl4jgI1pn/uIzz9me5o50OxC+pTF1m4Kc+23ZHxsBZhkwaffacbS3Nw3Xj0xooiediC7Dxn0d5dczBGYji45nknUcAyRkFtq6suRfeHb//La7t94uRJ8q/rViw3eqa4aP6U+F2irwjWadnZ8QL2KiKkuy4SA/MTHKPIvQeo8Tjq3dv996I9iqqx5SHYYjCzCNAlRpz0knWmhgWd5l43BP/tLo9Gey2Po3Bb62m5rtvMSXnTEJAbdOrEHFjnerf4dk9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iXExUsuKImsbZEO0Vr3ZlyhpYDO0jH0zZPj19c/gos=;
 b=ckayYmQ2Mft2szdsW63AHouMKfBCKjfXpb+VLLP5KjbpnEpnM2SxEZuaHRSn4YKEXJDkBgfPv+DtOR1nsdGItXxY83phTms79/NXpDlBExG3BE9Zjct0bwhTO6ZqPblZYW+gh8qyzclU8aQmJbMd+WoR2d15LS0QgPOuO0WIZ0k=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4836.namprd12.prod.outlook.com (2603:10b6:a03:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 10:05:43 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 10:05:43 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com, Prike Liang <Prike.Liang@amd.com>
Subject: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple suspend/resume path
Date:   Tue, 13 Apr 2021 18:04:49 +0800
Message-Id: <1618308289-12929-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HK2PR02CA0196.apcprd02.prod.outlook.com
 (2603:1096:201:21::32) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HK2PR02CA0196.apcprd02.prod.outlook.com (2603:1096:201:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 10:05:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbe21ba6-4bd2-468a-634f-08d8fe63b2e1
X-MS-TrafficTypeDiagnostic: BY5PR12MB4836:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB48364A5263BF6DC08787C55BFB4F9@BY5PR12MB4836.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSzZocaLTBjfcHbCCcrgBbb3sJAUdcWM42h7JCBjxmrH5e8zA5nb/immKbrwx0G2IPFbFNcSpdIyvX5vfzeByORPBW773DZE6bZei1pSArXurcG3brNwWJbTC4Hw4DoODehqZVkCrz9TO+rNTG+h/8fYKfMgn5Cj0A7sG2POat8gqr/uWT8FgDProGN4iakudo1MTcK8l5YNLF7Fvl17EB/8VSRcngK0xJEYA6SsfZ553Vuyih+VqmmuMyq61TqMYlzQocB4Lhy1X7w8xVLr7yjNc4FDa8VeYxTKoOtay5E11uywvcXfDCBS50FCMiz5qPoizfzcpLlybpC3XufNWdlEVshbyL2boKng3dm9UuXyrVySIuUM2mP1ZFNk6zMpHoiKAsDFB0hJrECZvSypq5TyV5dLCGQES/VKTmr1ElWBTsPqtGz2fqlHIU45jwxgS6vEbBbGkeb/PoX6Mw/BqZAYFSJfLHbMPoZ+pNqacfWFm9VXoWCqqTGlDPR70R1/7WOrQCvqhjHQR6l8KmdsJZf6oeq+Nq+nE/huKj4WxbH1L/wBUYnJH69cGOPmvET+f0pmzVxI/3c8fAkRC1zH1rlWpN6nhFDv3vGvbz9acqts45Il4DjsAkTGtr2WdDwh+qpJexpgsDydyMoBG+yVq8ImrYXp+MQMNzuWdOnbalc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(26005)(186003)(8676002)(16526019)(66556008)(66946007)(478600001)(316002)(15650500001)(38350700002)(2906002)(86362001)(8936002)(36756003)(38100700002)(5660300002)(52116002)(66476007)(6486002)(83380400001)(4326008)(2616005)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wm5trOoAM1Nq0tbStht8Yqe4qxzH6u8StZQKQhZOM75gtTKsdR60mrCmcBce?=
 =?us-ascii?Q?8NKlux2qGyfMqcCrmO2dgwB0ziSAee1Z+Pt4QMzeiUkTMQnbXmA4JjjzDNNA?=
 =?us-ascii?Q?g1kI4DK6bd5ZCc/5fYDo26kX0oO6yiULP32StEn0mk8yCGgtYc6WFsqAntil?=
 =?us-ascii?Q?+8+YJZEI7IE1QXBARLpC9lUV5qLu1lRTZVQALzhpxzfXS0UR92A5n1EvkHAX?=
 =?us-ascii?Q?23UL2fcq1vn0kYWSkJwgEFs7vphxayqKTweZO5n3+oaKc8i73E1EWJlR+dTy?=
 =?us-ascii?Q?OfJ/sLYs2xuP1FEaqrau4mtxbRz9AWy4UzIA9a/uDYMFTqxYmZTUvcTt9oRr?=
 =?us-ascii?Q?xE1/ZA0NAWobVatiqi72CIRpN4LqUcpg1RmKOcDdeBxEY7zPlJFVj+WmLZUe?=
 =?us-ascii?Q?1UsaCykGk3ilYKe7VCrYjO1yQIBdHOpOgX+3xNhA56VTlwIQ5KqB2ya3MPH4?=
 =?us-ascii?Q?2q+FCkawjpeNbMmNDV74NNYBhLiMwcseIuWZdpgcBxxvQczKFlU7Q3UIDNa8?=
 =?us-ascii?Q?kpaWaUAfTbDQGqfER5P3m4LijFKP4ryXNvsEcReienHb8LLFZC8X0BQ8Fg5F?=
 =?us-ascii?Q?MAbqAexVNJ4gBR7RbAg6gyBYgubiqa9A5Q+rqxjIhsj25wSRHEXrp6mkFvxE?=
 =?us-ascii?Q?196oSTAwvZM/qeOhMWW/SHVsQ39DQ64lg442onDisc2SgWKQqtI/R5yHk5XE?=
 =?us-ascii?Q?xAWbkeEfMPkWwbwDEAxXGGmTX/aEHCk3VhazaxNXvSLhUbQavqUaFpdQ/rE4?=
 =?us-ascii?Q?noeg7rF9KI03QV1z7ea9YREpVSgowJCwwQVj05TRz8DWpR35yar5SWoG3Prs?=
 =?us-ascii?Q?uQB5+sChgswBor71R279EGMSocahGkRgNuL4YOQRtudrABgbWyXrEYlztja0?=
 =?us-ascii?Q?QFD+ZrAQHVH3AifFOD1zONbjuaOCs7ohg13BfO3wfvcH06GTpbfwaBUcyTrG?=
 =?us-ascii?Q?kourfFWKNRLpp0Q2Z88NWP2GDzZDb5WCWZ3/Jtbxb7E/ntEE/E7MGdv+8d8K?=
 =?us-ascii?Q?ztQo86P1zwcrEWJA4Yy7maKYQUU8fZlPogn/sOJyWwsIwshfMrduTaVShRAO?=
 =?us-ascii?Q?oHXe51/J9Eh4L258QINICDiP1Y9GKfgwBweXEvJjtjqODwjzcwUsz10OrInj?=
 =?us-ascii?Q?y05SGCuUR6Ry7+qF2r/TIsqUGkM01epNDrZxKYTFDgipoiWueGms6s+y3A8l?=
 =?us-ascii?Q?wbIlbEMYXa/7PaXOy88HPAHS7sSsfJHv524e8lhiVDUQKe5EbUU1A7KshswA?=
 =?us-ascii?Q?xo+xXt7fUJypW3fN87Q/tXgGneEMDTRJl5yRlB50znHtqLs7v3aSefespUvV?=
 =?us-ascii?Q?QrMhVBuUtubBYlQx0b5dFv8b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe21ba6-4bd2-468a-634f-08d8fe63b2e1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 10:05:43.1836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oO+2NEa9PVWMi3G7QW+bscvORe1XrimBLCu28S9H2A7oe2AXJvlTSvkXb+i+e6q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4836
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The NVME device pluged in some AMD PCIE root port will resume timeout
from s2idle which caused by NVME power CFG lost in the SMU FW restore.
This issue can be workaround by using PCIe power set with simple
suspend/resume process path instead of APST. In the onwards ASIC will
try do the NVME shutdown save and restore in the BIOS and still need PCIe
power setting to resume from RTD3 for s2idle.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org> # 5.11+
---
 drivers/nvme/host/pci.c |  5 +++++
 drivers/pci/quirks.c    | 10 ++++++++++
 include/linux/pci.h     |  2 ++
 3 files changed, 17 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4..dd46d9e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2832,6 +2832,7 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 {
 	struct acpi_device *adev;
 	struct pci_dev *root;
+	struct pci_dev *rdev;
 	acpi_handle handle;
 	acpi_status status;
 	u8 val;
@@ -2845,6 +2846,10 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	if (!root)
 		return false;
 
+	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
+	if (rdev->dev_flags & PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)
+		return NVME_QUIRK_SIMPLE_SUSPEND;
+
 	adev = ACPI_COMPANION(&root->dev);
 	if (!adev)
 		return false;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3..f95c8b2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -312,6 +312,16 @@ static void quirk_nopciamd(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,	PCI_DEVICE_ID_AMD_8151_0,	quirk_nopciamd);
 
+static void quirk_amd_nvme_fixup(struct pci_dev *dev)
+{
+	struct pci_dev *rdev;
+
+	dev->dev_flags |= PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND;
+	pci_info(dev, "AMD simple suspend opt enabled\n");
+
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1630, quirk_amd_nvme_fixup);
+
 /* Triton requires workarounds to be used by the drivers */
 static void quirk_triton(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 53f4904..a6e1b1b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -227,6 +227,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_NO_FLR_RESET = (__force pci_dev_flags_t) (1 << 10),
 	/* Don't use Relaxed Ordering for TLPs directed at this device */
 	PCI_DEV_FLAGS_NO_RELAXED_ORDERING = (__force pci_dev_flags_t) (1 << 11),
+	/* AMD simple suspend opt quirk */
+	PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND = (__force pci_dev_flags_t) (1 << 12),
 };
 
 enum pci_irq_reroute_variant {
-- 
2.7.4

