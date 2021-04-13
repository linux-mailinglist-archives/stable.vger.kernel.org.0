Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C935D7C7
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 08:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbhDMGLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 02:11:40 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:1026
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229748AbhDMGLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 02:11:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3fqowOnBaj9k6oWjcDVG3CPOD7H0zCOHdrzDTI7gLprv5N8I/ckklIT6Rdhmua9RQGh6eknI4JYukB9U261nNMA1UiMlzLJmFcHesl0tbdW19sUozzpr6E0jPvXwlf/8hm5RtGD/yIptULnmKjREmTyTwQNA/AnPmXNpMkxABmMRGlVfN5Ji7FKBZUMbbILRH6FEr3hfNOFC1rlcLmLHl4pg4BF7bGXGaDhD8gb/zh0rwiB2pVM9bWVZQYiEOcXda3a8GsGsYqWETcltrkb7hGTfIY1YOeIowBCd7vt642WbSQEkyGUMH1+A/HQj/dugikMUOhhlB+NCyZK7CQXPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fKrs3S3sa7vwTlMQXTmJAUaxnPH6Jg1QCfV6J40iNY=;
 b=BqR3/82vMfXNTGlH9OyTFgJ5DPmdz+PBn+H72pTmsPuo/v3cU9zQ8WKdax1zMZCb/CMHMDqTWJ355hzL872AYuMZl58Fmx/LsOxBX3cJu7f7tEHv41qLK9WQMkG+QwfzzS+G8Gan5/gqVkdJccWm/o/TTnCeRyiqN+H2QR2XSJvgt8JqfcuDCw2frHqABDGYZDDwWCBDBhYPceBIyLcGXaMDAXoumA9/pPC1mcDMwtutDE/IerZiRKTANdX+jbQ0V8LVp9XF0JqrKs9b0d+5OSy7gHuXm/SMlNbYl1Pm35Lw9qMOwfRgZA4OUzw8oIIHWTz8oLfUTxqQ7LI61HUV0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2fKrs3S3sa7vwTlMQXTmJAUaxnPH6Jg1QCfV6J40iNY=;
 b=dJrQPeimRuIE1RJaw/9y8jzqmRuSZJCncf3YoyRpdNtrs2fzapPK2XcAUP6pPCy8oR9s1gyUDufOeudlATB0f7Ih3y35TL0DsP4dQRGwLWI95B/AE1vVhoM+qNd+3ANXN30j0UtQrwKNXfcqRI+Mf0O66+fuKGvjeaEzd2rbuUc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2838.namprd12.prod.outlook.com (2603:10b6:a03:6f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Tue, 13 Apr
 2021 06:11:16 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 06:11:16 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Alexander.Deucher@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH] nvme: put some AMD PCIE downstream NVME device to simple suspend/resume path
Date:   Tue, 13 Apr 2021 14:10:21 +0800
Message-Id: <1618294221-11528-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:203:d0::12) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR04CA0002.apcprd04.prod.outlook.com (2603:1096:203:d0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 06:11:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64403e08-3f0e-46c5-c200-08d8fe42f205
X-MS-TrafficTypeDiagnostic: BYAPR12MB2838:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB2838E3A4AD8151D87C93AB48FB4F9@BYAPR12MB2838.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ognt7XDdYEh8QZjdLGFDAxMNB4W+GYY4LYdy/5UbeFCVVE4MIGJ/VdKfTC5SXghuePYv42asycQMxJ9ldKTnK5uImto97sonRMmj8ZM7wFMH2lECnjl5+thJKjOPDS6MM98Bp8PHKLcEy7oOui2U/AgLmqQB3a+3Gl0PMnZ8xULiRjreDIpOblI7vxktxqe2Gb3WYadg0XR0Ev+1S1kOw+ZZ4miVbazVcGp+eTGoILLY4Q7rGrgaA15YCmeWIIi0xme1yQiww/91qSzrz+BvsIejq1/p0LkAcS0J2/NivZYXBEWt+fHAoeUUYQnIqm3zcJpgTmZp/uaHRdoEg/xpAKvZft8q99VF+6n12LNkff+Eu/7pr4OQvjmt2VIAgZnM6AetUtBbBCuMW9QOA7WCRCDzjYeFFG1ziwgw6Z8t4knlbeZ6UH0ff/45JwxbLYJM+hmfHrCfN6J3XpPP1VlrFJsVKYXoA/QjtBFhBMtnPUzT4iveDuBLUAy3ZzP+SHrk843tGurPMtPzC6xZdztIQ9p4oBgup7VQtExDhSz9N3ystRnAi969I2HdVAUM0zs8wmAeGm1C8kIZyuO3Yw2gW4hD0LUX2RIhajlnPd9kcFcJ6rXyKlSLxUBysROEkNhEVSU/oIo/DxahKP3Ek0NVkhNUH7Pn/tovdwsKoTxy+EM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(8676002)(5660300002)(478600001)(38100700002)(8936002)(316002)(83380400001)(15650500001)(186003)(2616005)(16526019)(66476007)(956004)(26005)(2906002)(52116002)(36756003)(7696005)(6666004)(66946007)(66556008)(38350700002)(54906003)(4326008)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/aCYs2ahSsOVW4abTNru6l8dtA7STkD7JEZFvZBshCwBN62mk/R3yW5EpYA3?=
 =?us-ascii?Q?0imbV5fvxBcBINoJrPvP4I1HgoA+84Jv1M3Iy4/zPJP4t/H/v18d2dL04Xyd?=
 =?us-ascii?Q?6yLNsoKv6nVZ6KxaMwAfOppDXjJh+2ZkRZejYErmU05lbNZo3tfdVN7rqtFy?=
 =?us-ascii?Q?7oCEWl/ReTcJi36KLHGA1I7e3V4K44dpG9nnUG8EXD1FIJeSsPLhlguUT6i2?=
 =?us-ascii?Q?sSXa7/mM2wuOHr/dQt3GEJTwXHB8efL3M0vl1nIvWutZZPQItktLJWbXwZo3?=
 =?us-ascii?Q?qc6pr6lTostUzf9KXYBqyETCSW1qKqSiI/PXic0eQuKMg+yqfR402wk1dm+X?=
 =?us-ascii?Q?9v34hNvvLvdwhSSAhb/J+TMDp6Usqx+34++cqDF/j1l38w+CB7yabPZaBUZI?=
 =?us-ascii?Q?Gd0wEOkfkk6JabC/UfR5k3vm2v+o30KmlGVlbOUzyj+F6bQYgA70BtR7m592?=
 =?us-ascii?Q?6h+nVpcMrIwhpetGtyODdzzXjWKmMFLjwRzwSGk/xEZMvpRHRF5t3Em/IxGf?=
 =?us-ascii?Q?YQxIEqoVJhYCZbomn2sze9JbUrjZ5KpAu9F+IjHiZKykT2ZEEuoCGjR89Lea?=
 =?us-ascii?Q?CN/PVQGzTDfz76mUJ0pL3k8pPAFoQglWRHLfzQWd5crb8lp7CpSxN8jNhxRZ?=
 =?us-ascii?Q?wvVytHE/C2MiKCKq80FeOcS6++oy4Wx74osrYo1CcWhb3gnxHkYNxIpYiNuT?=
 =?us-ascii?Q?X66Qv16ZOskhLzOi7RLqQGuOn0Us8S86mR7tw279gyQKVWFVX1TyQjyONr2z?=
 =?us-ascii?Q?RhQ5MeLaeKTgNrNxgwbrU/m1PaB5f5kY31WDmcaB9Gbc6O0XE0Fr5UyXaAO3?=
 =?us-ascii?Q?7LaR1Q+ww7X1UHIY5iTBwVVKq2xZMC6c988IbACMnpcbj2B1eYT85gdHZGpc?=
 =?us-ascii?Q?QP75gZC6ylclD+E8S2p0AfTcA90Bz9LRi3kmfyWCQ3YjGtIn2waeG3r/yp5Q?=
 =?us-ascii?Q?80UE2htTHohlPxzdls4g8dsdaZF9YjBuefNl/wLASfpngC4cHdzHUySulhuC?=
 =?us-ascii?Q?8xvI1/Qwef3EWWb++qFJO88hSTmW0CvqUDGqxiHaFGFbgnbArOVwakzvHcR4?=
 =?us-ascii?Q?NogaZ3KlazpB67qfWi54cGwphssbg/RrwUl2o5UOQQ1QUgQxckyJjLkHqyF2?=
 =?us-ascii?Q?g/22giwqtatE3TzxPJKdJlU3GxebSwGND3jaFRRngPtnnOCiQg8uqMMokK6u?=
 =?us-ascii?Q?kPNq8Vx/6RIQnZZ12q8shpa2stC6Zs2p5jD1GyDX3gYFt5B/r0jVEjd6H2is?=
 =?us-ascii?Q?jzJOzcPHLAzB9A8jb/5U5vQ2Xp/k02GhPbI2JeYxQeGaEQiEiYt8fKaSqAPM?=
 =?us-ascii?Q?S6KAwg4vHG03MVu6MtFoznQV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64403e08-3f0e-46c5-c200-08d8fe42f205
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 06:11:15.8453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/p3EEHiM+iwXC6XUVrGvX3IFgIXdCWAPEJWcBACvOMAA1Xj02iEt0kM1Yg3lSm1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2838
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
 drivers/pci/quirks.c    | 11 +++++++++++
 include/linux/pci.h     |  2 ++
 include/linux/pci_ids.h |  2 ++
 4 files changed, 20 insertions(+)

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
index 653660e3..b7e19bb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -312,6 +312,17 @@ static void quirk_nopciamd(struct pci_dev *dev)
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
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CZN_RP, quirk_amd_nvme_fixup);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_RN_RP, quirk_amd_nvme_fixup);
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
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d8156a5..7f6340c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -602,6 +602,8 @@
 #define PCI_DEVICE_ID_AMD_HUDSON2_SMBUS		0x780b
 #define PCI_DEVICE_ID_AMD_HUDSON2_IDE		0x780c
 #define PCI_DEVICE_ID_AMD_KERNCZ_SMBUS  0x790b
+#define PCI_DEVICE_ID_AMD_CZN_RP	0x1630
+#define PCI_DEVICE_ID_AMD_RN_RP		PCI_DEVICE_ID_AMD_CZN_RP
 
 #define PCI_VENDOR_ID_TRIDENT		0x1023
 #define PCI_DEVICE_ID_TRIDENT_4DWAVE_DX	0x2000
-- 
2.7.4

