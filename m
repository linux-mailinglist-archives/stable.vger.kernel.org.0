Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7638835EF6B
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 10:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhDNITg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 04:19:36 -0400
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:37382
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231825AbhDNITf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 04:19:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4957qEXXukOQOlU6cOnJOTy9j1mQGNfiGPEmts9RyztgHup/ZMjLKwKz1r+05pFRdn5xob+r4tkaDLRCFQbb8Bb8WSg2wdyEXolVsDVE3RQ1VE1A1BxuWe8HTLMzMNsQcUdi0SssLV5wpN2mnvMABpTIOHMKo3TBNEOgjgRwBAn9oqPF/h6jfh2Tz7eE5uobQ8bsJSpcpncEoK3rtU/hcwrxCU80dJvdKX2rINiLyKRFQMIgjN7qnmXCmjOAImIxX2Zcx+zWPUlsQYnagLRwYrkcPgZ4VoO0AVZZ+PMlX0AoiQXYhUi9pv6mWUIUR9DzRxT8kjmQmiDOkeRwQqMhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y//vnIUvlvvWm21fg5vX7QaGA4aXgJvdI0f2Nzq+ehw=;
 b=LYqCYQSHQWQTIfMCGktO/ZL/34KbxHw9qfHuX1eTkCCqHPwYNis5tHa5kP3iyKrIptpuqpROwzlZJBg2r5r0AO/tytGgmrbpApvCVtChwrqRuk6xw1mV+7PwyaRccw1U/hiRzQj/TThFBfY2bi4iAL6tz5d8hhNWXZpspBxemEmX3hrybLUJgawlmBOTScoCXVl+kSAOMSlOBp1UUAr7Zh5dKMDG6lOFgUwhyUXc/+OeUF1Lt5SR2eXLY5cFWebgpKIQMMAeKv123n13jh1Ew0QVYmPJALEyP8jjdc3O0buY7OvNwnfOFZOe8UpVGw8j4HzjhPBdqGavHOchJ50/Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y//vnIUvlvvWm21fg5vX7QaGA4aXgJvdI0f2Nzq+ehw=;
 b=OUpSnNYmI2cMtsufvO7OjLTG9OETI8WnEN8DshTvsRVou7M7YEVk0vEMmXbOhOFHCj6zxlb1EWOeNToYivBoFR4cejgnPg9qiGbS6vw3wAsBIjIkvsrSoBz6VLr1zwh42STtd+ZtKJ32AZaqwvD0OfJ3Rszhe2YGHoB1AED/uN8=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 08:19:10 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 08:19:10 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org
Cc:     stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Date:   Wed, 14 Apr 2021 16:18:01 +0800
Message-Id: <1618388281-15629-2-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
References: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0005.apcprd03.prod.outlook.com
 (2603:1096:203:c8::10) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0005.apcprd03.prod.outlook.com (2603:1096:203:c8::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.6 via Frontend Transport; Wed, 14 Apr 2021 08:18:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 288cc7d9-10c9-4000-ceaf-08d8ff1df67a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB31920D6B858DCDC095358F2BFB4E9@BYAPR12MB3192.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZxaUDFfwUTnBK7qQuCvuGWlfHFmgiHjRFq56m2KsDMmXl8wXRsCvGdm3c+uGzVXo3sRTKOYk8KW4qklxGG2glAm6RKXC7MHtvZ7KZAmnecxMP19UWmHqHilZwF0LNe/H5sqSUNSkAnE1N2OV71TjAD+3h9yehSlhMD28Rjoc9OHRqJnmzI7W1RsohQn8SRa+1mGParRJsfMdSgoIYXDJz/o/GTm7REq4SifdbBwGDcRuMyKIfXb4LznOVofOSIOKKyV016cI3e7X4AhS92Vk2urfvxZ8zX/J9vhfR02bH+PdxvlwqFdfCb9aQhUtylTbFOMG+f2a6LUSfM29Ztw4iQg2QfL8rGrdhe8nlCSTS1ISUO7xn4W/8WMHLcckh45e3U2+h/JkEhhgsZ7FFrBPvky/IQ5RTkYjtMjNWNJ/ojmuoJkA0/0xlZxK3o2iPdyvBNW9LKhp4QD+vYTx+ndynXexn7HABbir2HDbGHGAao6+KY2i9dQoAGPjXuVY2vAJZdcbap7/G6AaIfTNa8kt1Yi/GFxYsbmHvGQub6f5uX/IRiyVr77C9C/k0xfNCicL8pWOYJM2l3qVFxbLt+JWd1q73KMBEBjdT7tksTu92rINyWDsi2WwGugMv19JvRjBhq5wuB1U07s/X7F3MLjVP0UpxmgcIlql9f8v7cQaco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39850400004)(83380400001)(8936002)(38350700002)(38100700002)(86362001)(6666004)(478600001)(316002)(5660300002)(8676002)(15650500001)(52116002)(66476007)(66556008)(26005)(66946007)(7696005)(6486002)(54906003)(36756003)(4326008)(186003)(16526019)(2906002)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QOc4kLUQMlUzaa/3+gCQcg9w2bSrtbP9na9qPbd8rasSvtv0BP+j/9cVPEM+?=
 =?us-ascii?Q?mhIA//pLiVlnFBBTKvsk+rIVsGHmX/5eLXNAiuzn8prFBpotOEA8w7J+BaJH?=
 =?us-ascii?Q?g3iuVW0jmMAE1KfDSWHJUH03cUMYqEkQucMnRKa5hss6T2oiJM8fVnZ/80UV?=
 =?us-ascii?Q?Bh+sodXOgxyVaRNqZNfAg4n59FXD9dr1MwoWRIGlTMMPcj1XEgc9Z7+Lf2uK?=
 =?us-ascii?Q?fZe0prmpeQEulr+kSBKxHDbh5bObVwcuFLMkf9mi5gPjwbJiOlwymKrdVMyP?=
 =?us-ascii?Q?Bfevgv2Kkyvl7b2D/bTf41yQ+bPh6zqXdVo1GQK7J2vmSu+UQjnuxv/e8IZo?=
 =?us-ascii?Q?7qj3jaLX0Kox4gaHv7NDyNRG5Hq1UHBPqitWfQve9IGASuQ/gqtl/oLFCgFU?=
 =?us-ascii?Q?sAPK92De/fvmPVCy2JrFT80+FBlxlzxB/MpAjeBlN9l/U85qS6pblxC1+NOc?=
 =?us-ascii?Q?9L2zApvur2T1UcY+Dukld2tpowuMU70LVn+ChN01O97lujVJEdHTYEnRt7RF?=
 =?us-ascii?Q?Qxu07dg3lfda9IRwIA8KALrHQuXCq2sCif3U8aOGBGkfyf5S9bfR0meVh8bz?=
 =?us-ascii?Q?Nnmjc7WTxJRWXgg1oHQ/c6p/E8aQmB6I0BSuiEs/Qr+ytJTA9bTewOUqXmhM?=
 =?us-ascii?Q?sA/Bz9QOH2VBcX9EN/WfzGqC9CdfRf1YVZEj4dYEPlD6LmW7dFyjuDM4dxZM?=
 =?us-ascii?Q?EsL678IxXJI7MiVsR0HSnkVjRlgsJkvQ2CQfX9hJG71gDYGAKzFXAatQA6KL?=
 =?us-ascii?Q?chpz4UL1Jj62EfccWXAECofBOTqLciXQ3Pg6ld3vlWIcJRSdXmw9HN89pgxp?=
 =?us-ascii?Q?QSu2fXC8oVE33/0VFz+Gw3dm4XcpFu9/Imyf73I67l6e5C1O0boMZ1omcSyk?=
 =?us-ascii?Q?xc82PAaKzRs4KfyRZtYK0dwDTMYtnNkSLazlW5FffN1RvEQQORem2zGgrfK1?=
 =?us-ascii?Q?JVBdjq5T/fpQwGpWmeBRjWgIj5g8xA2F7NVUF06fqlMmBd/XBIKCuUJJJddA?=
 =?us-ascii?Q?2JYbvW8BDlHhcMc+Z0M+1nRlitXhgjAcPty9w9xQ8WlmBTWEbsrRSxiQ/bvi?=
 =?us-ascii?Q?sxJtYILRjWlfoVnRTSwSJYBFBvD5FNTWG6yp8ZOUhb0cRKnH+hBzO4qToC+c?=
 =?us-ascii?Q?0a6hB/jcqVyPzmNuu5n9CmwbF755Jm7WwZjQAKgKBXxu1epGCtw0ZPG6Jaj2?=
 =?us-ascii?Q?pNrzUZjXoVAHpU5hPsgo0bWm7l0PBzIF1vpn0yiKfDrXQsySZ0N0IUjJSgl4?=
 =?us-ascii?Q?PxVYh5rlh9CdQkwYVX/WkoZmO8csx3gwvJZlJo0hnqaDBQ7MrVsv8wJb8NHV?=
 =?us-ascii?Q?33AUvUz/Sj0SAJwRdaC/O4V7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288cc7d9-10c9-4000-ceaf-08d8ff1df67a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 08:19:02.9231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8R3kgiYF/rDJMWElgTCwFH+oJXsHtBV2LVW9zligkUY3yQaMVvcOGJL7zFe07IJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3192
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

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org> # 5.11+
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

