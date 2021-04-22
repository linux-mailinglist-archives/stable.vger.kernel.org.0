Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3B93676BA
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 03:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhDVBUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 21:20:02 -0400
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:38746
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234970AbhDVBUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 21:20:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaEakwv3hDAXv/X5cDq15D6fC+nV7pyJ+RYfRW6srMre7qGCcwyuyDpjNNsca8SxjW+nQDpl0b4FPMz+dZkT4L7goFtMVEpbFNVMubzOq4XObMr4EtOA+Sth/7l6eIgvYitJ/oJikIlKIe5uLQGNb3WdWj0MkmbLCG2H9CoIMcYVqEq5J0fM23wN7/nht5wOcWGy50Q2cexiksIbIJ1IJIJvaq9+R76R4n4a+R7pklr0IoM5qleq12Q/7ptlLwh+lmZKlBTFg64elO+HwxVDR/IOvtSuE7gJPZ5U8vM5rYi7Tz45BUanc3E891m88HYj1mzeaMvxXofhabaDKkWWPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWncXXwH6G1UOyXKgg+0sAQp/8KYVF8utZLKFfh0cLA=;
 b=aiJnySp5v1BVNL88J60roQsrfsLfwSetz8bDxoTGk4NTJE6LmqvheLlnVmemaFbwA5lEvv39U+fpz2RiNELFSmBEmrcbvSpXCeMtWlO00okGtk8s3h6aly9ZEqBfaERuy4nS3wJ3ciO4qlnwe+LaVdfENqoD39ZkvV1+wdMu5yYZRettxLMVUcMmFRVVb/InN7anYufPQbq5DCDpujkPWqQWAcgt1Dg3UL6oudrxEV/EH6jFZoJhrzDtn/u2X7SXO+v3gOYnSxKIY5+b953iqayhtgVTwQRvmXLddg+7nL2J/Aj9Ped96jhTPkHRbhSZovxOh9eDGYVTI0ImLmLqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWncXXwH6G1UOyXKgg+0sAQp/8KYVF8utZLKFfh0cLA=;
 b=FaHgyG6vJtoTblW1BCMtshd8ZmsUq74ZYiz1tICxoXxvmOGdU//Gbf57C/05XHI6A8/ZMEjO/DcPl8uBYnf6DimC0TBuK4gzgLTqG4UKGvF6rP6BbVBgG33tmkffNsmVdHbaF13G0jQOh0ZKhQY2jYwdMEw8Qr1yWZFJCLtPZds=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BY5PR12MB3713.namprd12.prod.outlook.com (2603:10b6:a03:1a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 01:19:27 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 01:19:26 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        hch@infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Shyam-sundar.S-k@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v5 2/2] nvme-pci: add AMD PCIe quirk for simple suspend/resume
Date:   Thu, 22 Apr 2021 09:19:06 +0800
Message-Id: <1619054346-4566-3-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619054346-4566-1-git-send-email-Prike.Liang@amd.com>
References: <1619054346-4566-1-git-send-email-Prike.Liang@amd.com>
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:203:c9::7) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0020.apcprd03.prod.outlook.com (2603:1096:203:c9::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4087.16 via Frontend Transport; Thu, 22 Apr 2021 01:19:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88f2ca99-9845-425f-40b7-08d9052caba0
X-MS-TrafficTypeDiagnostic: BY5PR12MB3713:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB3713E9BBF1A5D2F86FBD72EDFB469@BY5PR12MB3713.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ju16tvgnUQcczwCR2frCindUC/q4Q4oUkc+tuxiUAYkVCC+OAXfWrHTYvPiJSXxAscKZDn3mx8iUsvzHOrXljkQCkJyAlAhKfLCftrPBwlbdg6MPa5cYA4Y4tm0XYRTERL8m/pwsGabdr5hQaJQrMGToZhUs7PKLoPniVGtTRjwsWaQoayJdTMpZ1A6bGyWV5o65fP6/FqA/3oxmexoD4Q4Wbm9fIvfEYqU4fv8ZAJEubgnZz1WUgvPMRuve7gmnFJ3jmCC0ZeFnKkVCnXR48a9+BivWSSqzljuosa5IwLWDMXvwFZvkvYgEZJXsPjGsMY0Ob3qQqdIu++YuVmuvQ/VVBLOYrAQBJOeaU5lCoVNLJWPLigfWIkX7g0qV4ZKalYchgkpxBDGJtoaLCsEiRbX+Jd6Hl0N2wMDjYAmLVkrzk+OkuXCgQ1CT92G5C+e7P+D5B4/8Lir1oOEN5OYvTekof7Y5Lx7uCn7oQTlYw8Q9GUeu81buPCgCkYUejHKQ/td5DPyLtTkU68nsvAjeLrNt4o9TmM+AEj8F0pcHgV5qU8DKm5qY9uOY6C4HPWAQLmt5IhwQEGmDvmuD51Xawh4WMboGEM58SilTOh98lyfGX/hl3GVu0v6Lx9eoNSsVrJeQdaAaqZ/fCri8NYJQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(83380400001)(4326008)(8676002)(478600001)(316002)(66946007)(8936002)(2906002)(36756003)(86362001)(54906003)(38100700002)(16526019)(15650500001)(186003)(2616005)(5660300002)(956004)(38350700002)(26005)(6486002)(52116002)(7696005)(6666004)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iPiwb3nHSIFOonDHKtu9VzLawQJBArIAuRngpRVv3jdyRT8cIT1tbS7DRwda?=
 =?us-ascii?Q?FPaWSxdu/1jGiaQDM2BqVZi4cpr0ncRJI7GLBPpjTMMr2gpzrsHY4fSrbIdf?=
 =?us-ascii?Q?3INsi55M98hZUPyi8s0C96ogSkJ9XKuQ4oj49kYqwlJasekW0S5Kt8vW/EHR?=
 =?us-ascii?Q?xSsLvUffkegcAhMLQ/629UjJ3ifAFgPs+n6aYSuRXtrqjkPpVeLJyOK2OPvG?=
 =?us-ascii?Q?6Z9kLnLljm1WVVREz2UCLY8tle9VFKh46wDjZ5e0arKpxrbS9jLMiMdPJKmH?=
 =?us-ascii?Q?T7/+hkL4XkpZYTuWZ5n9Dk6uEOIMecugb5+gv7V65pywy3XzdoLf69LmN19N?=
 =?us-ascii?Q?I/HpcikWCp0JH+7d/kxKsysJwXRXlYsBN5heAKj3/qGxyJhho0azYQiZ/6Y8?=
 =?us-ascii?Q?YXmJvWtAVAQgPz/qePVWo6oFJlE4gvrU5V9Dn7iwHnZf6PjJjzbqutraJtar?=
 =?us-ascii?Q?th+sJxdhMZ97JFwQtJIeE+fpPd+YG/NFzKzzE019p1tsV+PJP0w0HrJbr8Od?=
 =?us-ascii?Q?1Nyy6UOOE3iR9FJ2QJ+kfsFPZqgxhmo8n0uDINEgJqCyBCeGiXo4k4YDhsll?=
 =?us-ascii?Q?hYvSvpgyydxX3yyONO3DW0a6IakumEK4aNw8tV843F2o9WEzf4pzkrdp+g8C?=
 =?us-ascii?Q?U5deKSnxwGBTMlPQOP1PDZA90TLyi3DciV6vFpmqyCuRW6Z+axGs6r8RlShs?=
 =?us-ascii?Q?e9KVEciX8nQ4wIDiSFni1Z0Dfh6JNspR/BWG6edcfQvuQ/6b9aj/HQi8xIAd?=
 =?us-ascii?Q?q+pm1U/W6EQrt834vrS6l7tAMi4QALzwVQg/r24UNIy26NMBk3EMJIo1aUk4?=
 =?us-ascii?Q?CHWO5ilBB3CrbThVj+M50RHQh0zaJOjC4F281KSjZKorgkeOaSEPKue7qZJe?=
 =?us-ascii?Q?maZSf/RRnY+K6RH8kt227TOq2aLzlQXeCe7vv/whM29OSsuX/jj+Ue1Ahlh6?=
 =?us-ascii?Q?kkC+t8XL0QpU0SrOu2kIuPHegoqn3/27FkAf3q2Qoft5V6qftzSA9ZnviD+k?=
 =?us-ascii?Q?lNAssr0Yz/FkaEKSgFidPpZbW+k5I/iuL2YJViFl65JnVxCmCZ0cflABw/Ds?=
 =?us-ascii?Q?XeQEPbx5CUYMxXOtstuFflvE8hI9iXQ31k5kGiTpHLR4CKZjkh+Q/SjQFC8T?=
 =?us-ascii?Q?1o+VK0v6XogB+atEp283D9LXsc1w45H8u4aDnIT3I7b7etP5sYfzpSYsjjJU?=
 =?us-ascii?Q?Qn7y/wQhkbWW0ecAW10UYXYkhJuXL2av+R5kNBFOYNYlZOEQCRYT/YYnCzj1?=
 =?us-ascii?Q?+uuxK/VK+jtNHiyF3H2TgnAqQo8bDb991+vHTTMi1UYSyR5eyR0afcA20T60?=
 =?us-ascii?Q?fFLKL0b5E3BzMlxfhsilfJvp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f2ca99-9845-425f-40b7-08d9052caba0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 01:19:26.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QA++AM5HEA0wj9+lPjNVWjDn2qZP9Dg10HDUMeW0Yv+Ex4ftviapp21ZrHf1jlD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3713
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the NVMe controller default suspend-resume seems only save/restore the
NVMe link state by APST opt and the NVMe remains in D0 during this time.
Then the NVMe device will be shutdown by SMU firmware in the s2idle entry
and then will lost the NVMe power context during s2idle resume.Finally,
the NVMe command queue request will be processed abnormally and result
in access timeout.This issue can be settled by using PCIe power set with
simple suspend-resume process path instead of APST get/set opt.

This patch is updating the nvme_acpi_storage_d3() with previously
added quirk.

Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Suggested-by: Keith Busch <kbusch@kernel.org>
Acked-by: Keith Busch <kbusch@kernel.org>
---
Changes in v2:
Fix the patch format and check chip root complex DID instead of PCIe RP
to avoid the storage device plugged in internal PCIe RP by USB adaptor.

Changes in v3:
According to Christoph Hellwig do NVME PCIe related identify opt better in
PCIe quirk driver rather than in NVME module.

Changes in v4:
Split the fix to PCIe and NVMe part and then call the pci_dev_put() put
the device reference count and finally refine the commit info.

Changes in v5:
According to Christoph Hellwig and Keith Busch better use a passthrough device(bus)
gloable flag to identify the NVMe shutdown opt rather than look up the device BDF.
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4..617256e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2836,6 +2836,8 @@ static bool nvme_acpi_storage_d3(struct pci_dev *dev)
 	acpi_status status;
 	u8 val;
 
+	if (dev->bus->bus_flags & PCI_BUS_FLAGS_DISABLE_ON_S2I)
+		return true;
 	/*
 	 * Look for _DSD property specifying that the storage device on the port
 	 * must use D3 to support deep platform power savings during
-- 
2.7.4

