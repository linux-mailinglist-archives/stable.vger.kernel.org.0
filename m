Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6E35ED26
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 08:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349199AbhDNGVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 02:21:23 -0400
Received: from mail-dm6nam08on2072.outbound.protection.outlook.com ([40.107.102.72]:34624
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232405AbhDNGVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 02:21:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkvT1hi50rt6q8u8+91f8zJQsNXwVHpMJLrSfkM3F0OqpcmQRCCFLH67OWnuwAzo0V78PRXGmLWoOEb5Lq3gt0PJBvJgmUwb/CZRKfshuXQwY+jKs5DnyU+niooOA0caC4VU2KBeKWmFtqs6P0K6lLxB2W5Sh5Z9gMPM6SJWCkKKbfxmYq5PNlHur2ItRf9vrDU1N/i+XH9nADeuXvqin7udD6UX9pATyFuKgDhF3b2eVdIdr6uW2ugpj0jLijgOJAxfRab+jm7NBJh66kt/T9D+JV+zbQWvcKmVb3Gbf6PKwOiJMEhxzV5mn0fCVF7INY28IEGuBae3Qdn2JizJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFV35ulLXmKqON1fYsnVIFlLniFsuz9lXDl07Tqu+TU=;
 b=Z5ZuYv0vmVI68N85siFDgz6jJEfe+FfJoHZfIYmFJsOnhsbMiPh7kd/iopXeyCrIbS/k5UOTwLy/WDqSdr0QPb1iCZM2Gm71D5U9CLJ1uFHG0xVc+gAP6y/ZWrMdaRrewOGWpwuMYThsndNEU5MbztRRldsJDI3nqbniSHSDkeD7vS7WSrDNvA9AZC1XJHAcu3egrjO4LeBKuRaQG/BQrPYWnObKNL7sXgJ7BP6po2JlGXvFfNsYYUBcGqsOzaCDiksqAciejjNXQHkbDq0cKeECelv08Gwkcj2Icl6a977n0Kq204EGZakdE30+yUdC2V0d9KScbFo3NUEDQhBhcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFV35ulLXmKqON1fYsnVIFlLniFsuz9lXDl07Tqu+TU=;
 b=E5esHLPPp6YNPGSoEyDka5fqVcDZClED8OgR3nS4s4Q+QZ4E2hLL8uOlhMDgSMaeX4aqK4BFdbADZ54Tz8QGH6s5LLzzuBD3f/oEtYKI5QZxJ1FmKkdFu/56uUezU79eO7qPtZKGLnuy120fjUNDGzG21LUf72jLMDv6Oj/J1AY=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB4801.namprd12.prod.outlook.com (2603:10b6:a03:1b1::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 06:21:00 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 06:21:00 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, hch@infradead.org,
        gregkh@linuxfoundation.org
Cc:     Shyam-sundar.S-k@amd.com, Alexander.Deucher@amd.com,
        Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        "# 5 . 11+" <stable@vger.kernel.org>
Subject: [PATCH 2/2] nvme-pci: add AMD PCIe quirk for suspend/resume
Date:   Wed, 14 Apr 2021 14:20:00 +0800
Message-Id: <1618381200-14856-2-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618381200-14856-1-git-send-email-Prike.Liang@amd.com>
References: <1618381200-14856-1-git-send-email-Prike.Liang@amd.com>
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0021.apcprd03.prod.outlook.com
 (2603:1096:203:c9::8) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0021.apcprd03.prod.outlook.com (2603:1096:203:c9::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.6 via Frontend Transport; Wed, 14 Apr 2021 06:20:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b8f4283-6f45-4394-1ad6-08d8ff0d78e7
X-MS-TrafficTypeDiagnostic: BY5PR12MB4801:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB4801E1C0D9137BE90C805807FB4E9@BY5PR12MB4801.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0T3TubuBAKE3HJTYuB8M7ElrgpiDxCpWeJl+mu156DZIc5SU1nhn4xVlJNTbONnRUi0Her3vWL+9849iOWOdeqjFXWiwcCIE0uyDHV/U9O1ycYXC4CiU/BJWIq/sWwedIzf1caDBhjqhvK3UlnQX86ZRzXaFH5nO9wBmjNvgT4xv7JRk16yPWUFCK9zHfeMddOEkCbwj5ondfF9HOA6Hz0BLkZb19fAaLsRDYP4b/zlKt0FQ4C8I2E/K24JzkMC1TNIhcqK1+6tRiDkvRcms3CBW2GW6pBga6A6DPPowdbT9fafHYW8ZWxNNZk6bb+Vd8eB9lS/jxFDhlBvvKMIZ+UbYy7QLRHuSSrz9hHB7cMf1lMDK8B1UFa3rrypJt8PYOCFPkloubBSUhJGciPDjjTq7qg2JNSBLB/5wNpuiJ0L579aY+BOfRwoIKQIpmndDUQctesfby/3WAzHDJgQYjdl+s+/0SZOFjB7ILtj97jWf1efnI11jJh+oMrRQI3hHOVfULGkTlj2YYfJWZ0AFTyKJwB3/8Y79IMDxbt5GArr1v3EVb1OYu4RRWbCvHcX5kU/mQtYFbLRCRk4gZdDpLOR9HWvR8nAGbLoa+PG0c6ZIFSQmgGf9YiRrJvEFWiUXF9Lv+bVQvxKjLwWlpxGABtgi5VwqexMSIMtY29C4zig=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(7696005)(16526019)(6486002)(52116002)(316002)(2616005)(478600001)(36756003)(26005)(4326008)(54906003)(15650500001)(5660300002)(38350700002)(186003)(83380400001)(38100700002)(8936002)(6666004)(66946007)(86362001)(66556008)(2906002)(66476007)(956004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MDnh71aPHQ04LBcTPKTNBvNQr2i8LgoOxgy24OlRjGrqumubBKoFYe1xybv4?=
 =?us-ascii?Q?I95mVmtsZ4nJrfJR0zNW3w21X5GGU0QiLRI0XLFcDKzj1pOOCIZzzPmv4ihL?=
 =?us-ascii?Q?436FmfO/SpdiIMJPTXzMIC78y6b8p0ShmpWyIxlv2qXWaaZHndOBaZSncxJW?=
 =?us-ascii?Q?LdRoZs2Y+PJn5Q/aNTfEhokr5SBraa4ty3knDTpeudNKOnTLuUvXmInt/4c7?=
 =?us-ascii?Q?Eco2gvt88V+g60yeduOsgVtbIz/hGEyj4Q+wsmk+RimaIVuRSBhJpEdezcXO?=
 =?us-ascii?Q?oe64K4+6qCPvZb9qzUXvAUaRVNHFj/h7kGBU/LEwcgvv4bA5jqCoeNVvTvQb?=
 =?us-ascii?Q?bxZv41PTTghzto0Dk4JRVdvjBalG1w7MY527GspAIc4TtrOPc8tO2Nu7v9Lw?=
 =?us-ascii?Q?bDgiSORiihG8VJX3ZtYu0a39i+hFvXIuAqR3nxkaaWkoRNxD5xC6a7OUsTQq?=
 =?us-ascii?Q?poXX7rrkh43wSo1knd4YM5mZwfMahDtyzOUhG/fW72SgVZcwFB6YgqjQNdsj?=
 =?us-ascii?Q?6rb79iO7LBZor2SPQkQrXZ57+8EmZqNbm0yCrYB7HWNd+hiw36rTLPBeco+o?=
 =?us-ascii?Q?u4/vJNU04bnI3zBvHGD8bUW4X809Dw5VA4H6o8EWrB4rTzRC6RBooHvVh7j0?=
 =?us-ascii?Q?bXh6O3i55jUKpwKOkfkJcUnn13zzJBkD902Cqh0MMetUtV9k9Jv7EaZIMGtS?=
 =?us-ascii?Q?pmS7iadZtEZJNoS/cibLK++uZE0jiQIu4cWG/OmNeGnR7tI0lIbQna0C0uQl?=
 =?us-ascii?Q?s8zfClnAKn7GjWWc0k9CDCmxb7cJMgbXgQ+i+wcopAJsjtG1oF8oB9w0MypY?=
 =?us-ascii?Q?12aRW62W75WUzhL6ycCa458dAp0xJz5jNQ/v3u+f+mx49ImNQ6QC9KE00JwR?=
 =?us-ascii?Q?oF2+1vPAaCyu4R4AMVtJ9CcTJrCbAoHZcUykYMc5Ynirq0HTpAgLcUVE2uZr?=
 =?us-ascii?Q?QJyQjGjQikYfcDeabHZzkQmAS8lUZddh/Y7Bla+Dw21bRCygO8bOKfk8suo2?=
 =?us-ascii?Q?/5Z81ms92MJ4scWzUaHnlIDWFxLjRfs8d/phwZV2pwgE8grBQF7WxNFuO3JN?=
 =?us-ascii?Q?4EhiYH1A/XYTl5Z0OztECXnaR7q9Jtvkf3T9XvfrQjPwKbpOhqp6P07oVqxz?=
 =?us-ascii?Q?8tisDs/9d74lBG4VhA4gUqyrJ4po8bKmKrTh1AQUnGROkb+4kCr0S89FI3BO?=
 =?us-ascii?Q?Vpt+F9HWBhSgyKcL9nIm32ekus5qDy1MhsIJKTf7pQitM77R56Zc+ghWTWZi?=
 =?us-ascii?Q?l6aQARVz4nWgdAAJQ3nZZp/q81NH2dyINwAQDkCAZZARv1cQFScZBfW1aSs6?=
 =?us-ascii?Q?vwGLDuBw841XXm5cIRROtNBc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8f4283-6f45-4394-1ad6-08d8ff0d78e7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 06:21:00.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0R3XSSADjdfck5JBuXVpPjD9s5T4YeJcHDC89HOuG8aJMlMerwrxoKsTTVsw2zo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4801
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
 drivers/nvme/host/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4..5a9a192 100644
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
+	if (rdev && (rdev->dev_flags & PCI_DEV_FLAGS_AMD_NVME_SIMPLE_SUSPEND))
+		return NVME_QUIRK_SIMPLE_SUSPEND;
+
 	adev = ACPI_COMPANION(&root->dev);
 	if (!adev)
 		return false;
-- 
2.7.4

