Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95C53600A9
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 05:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhDODx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 23:53:29 -0400
Received: from mail-mw2nam08on2050.outbound.protection.outlook.com ([40.107.101.50]:5358
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229763AbhDODx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 23:53:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwHZDV3P1TFibenUmAg6fnpzO/EZHZPlFzuByM97AALwOdTPvenVkLOjCvCEHerTE4mGQVkLTNkPOac+/ElZwsSc0e2UPLN0xMUkHFmvfW8RP3cfoIbmIWTkld7W/LN5hwPNxRYE4Ohei0nULIyfd0PPyw9jN5UibrESSQ/quU5yxQHkL6++/1xj+okU93xHC27eXY1AaKxVZhL9FxgpSbx8QMSksW0Y5wkbuAgWlDOKJhR+bsXRZy23H9CXHnDFybpDgDc5jC+NsWNSHrH8RIyRRJM5woFr+fHz1hS94p+r3PCIUMVXH82a6+zXhZ3majUfE2x152rAmT4vOQTYpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJJBn48Maq50eEGcFsEgh1EH2D5EBbS4q1+jrTKn6CE=;
 b=lGntDcm562yTngY6juQLil+XBNcyIgfoixm+DPQpj/pkyOgrouTHZdLgVZNGlO6Ty56iP3zdvEyabFL5tFpVZqidPgoC7hxRUmqus170Fj668i+HZ4X/CtFGqJrg6ry5ihkUY6ttS5a9qkAA+BMN9/hWquml5+ZMMMAysGsL6NUwN9rusG3WXB+oNOUduJ7lBnjEZDqcHg/6cDtrzwiFwlQCa1sO6m+olCLptcYSiZQ6K9KBgmTX8RiEJp8ecphgu3iN3csA6bjl8CXAUxYJ2OWDR4z35F0OScYjhtwur5lD2KJe4Wb3cWB+DxKNGBIp2/Mw/oqxvnGgGjeXsqdVsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJJBn48Maq50eEGcFsEgh1EH2D5EBbS4q1+jrTKn6CE=;
 b=ajxwrixcSsZAUjxZ/lTGoldNM7e2BnzRMKC8yIrUCgyODX50T76L3gG5HxeWCgZOvh0GwTjTR9eHJizwrjezfTfhSkVcYvkBBuEGsUvBtmypbiLeal3S7KBeRWmw+/35pLksvbGQHsG4WsAQ499u4p7TdVTO6oGDNkLYsmP9iRM=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2726.namprd12.prod.outlook.com (2603:10b6:a03:66::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 03:53:03 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 03:53:03 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Prike Liang <Prike.Liang@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Date:   Thu, 15 Apr 2021 11:52:05 +0800
Message-Id: <1618458725-17164-2-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
References: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HK0PR01CA0070.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::34) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HK0PR01CA0070.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 03:53:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67965976-58cf-4c17-6dc2-08d8ffc1f85b
X-MS-TrafficTypeDiagnostic: BYAPR12MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB2726D11080765FC063770833FB4D9@BYAPR12MB2726.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7vZ7a04wgY61Fjbg/v7Q/HHmQnsEKEXifhve4sQfnOEYBtL7A+c06aZNBbFlz5rUvCLyXk3idzUCchU/xdCe3lyhAiwrefhgO7jvBeF2vF93ujrgM1eYwPVsb89UmUUDCyyACHHk1FfJjgCtoKO1jFdIflWpbn6Na7OLP2ONNZi7cQv/Kn8OjqXbmBBMzcyu0+Zp8rI1CHU2AybrJiPUvBb7J28ovxl4jzWlQnWy/vqq1CorSbnyCJA+EHOvMi6xf0UR8XrODG+FIi+EnEBJdpdBezMmUta/tXXzVDBTbP6bOMurqjyesJpmmLE39eYF9mi+0+Z3GSbYwl9tiysllyuPS3snfjMrPyJ2pmKQnx5kEnJ/bdQTVyLTpnGr0RpmgsoMnTXaJtsyicH5O/El2FdvP7bTj3Hk7XgeYCEGTxLoi7ryMDZlk4KGnjZSO9Gqf1fNZuGZcLCcvIwNgI4SlxC/yxDzKDXV3Eh19eUkhxmax/aCDvMeGaRuEqgbTmB1qO70T4tWwc0LPncfBZFVqyiV6GgkeyG+JF3kooYTHMa08bZ68txn+wauv03QlLJy/PkexkA49DJMLuhSxz+vY4XfppTA5lOyLdie4vGaDkFKZ/mAAV+XTISgFxKtq8Ld2pePoc3uwWAvIKvoZnqawJjTMzHghCzpBp0OkbBAt4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(5660300002)(6486002)(316002)(478600001)(4326008)(15650500001)(8936002)(86362001)(16526019)(956004)(66946007)(83380400001)(2616005)(66556008)(66476007)(38350700002)(186003)(38100700002)(36756003)(54906003)(52116002)(8676002)(26005)(2906002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7YtEVvLHoVchexzWCsFR+j3p3Rj3MZIKe4osh5YAZBH3xotlJvShOVESF2gj?=
 =?us-ascii?Q?WdQJJ4//uTXw6Ta0IRX/Dpw6v3Dm3c9cUAvaJu+ms1Ln/1yUcBqsR8Sb4yN5?=
 =?us-ascii?Q?kBVwITFeLf1y9FDgPXjSNmH+b1QYujLXgKtwX7GawVeSOmDYfiH4D8KYsf8Z?=
 =?us-ascii?Q?bgcViIcZKt3tBme5x+53NQ46fUL+sN5CGU3i0XXJ3ZM8cYRqfWGblRlXxg4R?=
 =?us-ascii?Q?eqnLV6z2tkpZ29/InPXxlGcNn+zNoPfHgCdaVR9GdpCaodFtacy5kL6ZCsEe?=
 =?us-ascii?Q?1tMSc0zp/U3ZeQjNL7RgV2Cc/ftWEJMOGtEjtnj/huMgJkHs9GPudpkkZPjq?=
 =?us-ascii?Q?eMnxV8nHhEsxtHu3RVFcNpLB3bHz2LXaYxXBKT6YGcAcIJ2s8lWNX1CSqKx7?=
 =?us-ascii?Q?V1Lo+m4uND1SvMgflPGqonwDUe22EZAXW7bIjWp9aUd5YIwgR1opuPAizCcZ?=
 =?us-ascii?Q?LPt0mLB7C6asXL4ZcIF+xT+P0JqLDqtqIQ2XrRz+afK9tnJOCOOTOANzi6hJ?=
 =?us-ascii?Q?TYr6quGxR7MrmpHo6T97C5M5POc4tQu+ZcrLgavHJRMMmOMbtMc1rrKMhwQ/?=
 =?us-ascii?Q?EN7G01a/wd8NQaEEYvz6HKm/otSOa7z7pw30EP1thlMIskFYj/L2KuzIDsZt?=
 =?us-ascii?Q?b6sYzKo5ulV5kC4SDB6fODxLcjJU5EkWj2wuOA2xIrED4jZvzBSoyjktwCgT?=
 =?us-ascii?Q?lbUl47CdH+6ca/vY5oxk1Y0jMRTzJZrfq97YRpUCVJvM/rxGkYUzq1Q34OK0?=
 =?us-ascii?Q?SzPRJcLOkB0YgBqg3kaHInk3/4wAg82CtQO4DzqAkIefUbjltfGpifBZ6rMT?=
 =?us-ascii?Q?GEvfJg/TXivYPNGBNH+aj+M6EIDcFgPTSjNY94aEkclHs3e14NXBCS7MCCaq?=
 =?us-ascii?Q?rd3ZLk7Vvz1nmrdo3/wz2rNTkSx2th3jKROQXDerxplzA1yQBjPJO/qRyRc9?=
 =?us-ascii?Q?wvaQyvpj0erPWHGXNCYR1tUQBcLBPZu1I/bA6kJ8qBTvICCtI1/PdNAsG26l?=
 =?us-ascii?Q?gQKys5F5RGNTxBXTQ7e52eKFU6TM7nXjFctlObLgaXlzdv5VhdylI5J6kzsG?=
 =?us-ascii?Q?+mu5ma6i9y21D7Qwp53nkHoRZP8V4OmCT/LIp6qFiCntCoteljXQ/vywtRid?=
 =?us-ascii?Q?FcLUB8QMP8yFrY7cihW3P4ng2LNLIXQREbeOdH4b4azg1luQ6X5AqKKbJirm?=
 =?us-ascii?Q?MtAeYcPEhDbkefA5RHczr0HozeYcG/Jms6TDEk7qoOBgfs77NiqeJ2HRwGEj?=
 =?us-ascii?Q?72SlyPY/lKpOJRYR/UAWNuxP7a7W3yzPuKWmQC+zBTS8I5uAjGQJdkfztLIr?=
 =?us-ascii?Q?d82Rxgi0J7PK3+W/DmJ1npil?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67965976-58cf-4c17-6dc2-08d8ffc1f85b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 03:53:03.5196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rxLYCDHEZfUbsFcdyX5CDA5bvHpGjx7lndAJJCl8+t9IWWIHepWUfDw+iPnEU4DM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2726
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The NVME device pluged in some AMD PCIE root port will resume timeout
from s2idle which caused by NVME power CFG lost in the SMU FW restore.
This issue can be workaround by using PCIe power set with simple
suspend/resume process path instead of APST. In the onwards ASIC will
try do the NVME shutdown save and restore in the BIOS and still need
PCIe power setting to resume from RTD3 for s2idle.

Update the nvme_acpi_storage_d3() _with previously added quirk.

Cc: <stable@vger.kernel.org> # 5.11+
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
Changes in v2:
Fix the patch format and check chip root complex DID instead of PCIe RP
to avoid the storage device plugged in internal PCIe RP by USB adaptor.

Changes in v3:
According to Christoph Hellwig do NVME PCIe related identify opt better
in PCIe quirk driver rather than in NVME module.

Changes in v4:
Split the fix to PCIe and NVMe part and then call the pci_dev_put() put
the device reference count and finally refine the commit info.
---
 drivers/nvme/host/pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4..ce9f42b 100644
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
@@ -2845,6 +2846,12 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	if (!root)
 		return false;
 
+	rdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0, 0));
+	if (rdev && (rdev->dev_flags & PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND)) {
+		pci_dev_put(rdev);
+		return true;
+	}
+
 	adev = ACPI_COMPANION(&root->dev);
 	if (!adev)
 		return false;
-- 
2.7.4

