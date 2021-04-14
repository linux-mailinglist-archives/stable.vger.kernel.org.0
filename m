Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE735EF6A
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 10:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhDNITf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 04:19:35 -0400
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:37382
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232542AbhDNITe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 04:19:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9Qcv/XWi91TguM3DxpLQji+PbMUJ9Arx4ZLVUEnnEhsnpzqjdy4KKCLp72N1pQ60anErr8z2cCswR8Mrwem5xmAKn/Be2yGC3VVtmZRrl6I+OEyHLHn3SNiVL7tYObVT68Eg/MboA/SPq8p5VhyC19KXCZXnUF1RujmDme3HcknxEgx4pMGMO7C7ptGlromylJBxZx6eA3IpSl6GYETSvLIyAQPFpPqKaB+Lpa85HwLlxZhGeBg00Pke1NOkMnxXUNBlBE3vL5f/E5tAWqSuZE9JZG5FRhNV92kfn/OEdTiFoG7jIKjYGGvBzhLzanA2hvy8zQGllLy8nY9bz3C8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0+GenC9OVs7q+KYOPFveEXUaSzADoNXDa3fm0o2HaI=;
 b=lDH8X/w09cl/GSiZdk5xclLqRByxXtK777vBEfa7ryVZx+qF2FVZ1pk/YNW5uWp3TZvxBh/EDwl1xdrvzM9uLPcFgn0kLV3vgzyBr1MYvGvrrpw0kopuMzRIQacP5i2jRLQmeMWiUizfr3XxKJxTNYn6Eyo4nQFIhaUv3eF31Y8zMfkVNn+SKndIpxY0TUm8BB+aC2KRhgb3vfyU5FD6S+o3MM2LhIe+Xz0TWnDuWlwe7mPHEJtj4islAj5jgfKAyhWdtPZG6qGZtML6cZgABJCNaeG7veZ097IAFBMK5Cs/A1/VgujRp1G8WbV1UV0hGmFVCY6xeyUMvzG69z88mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0+GenC9OVs7q+KYOPFveEXUaSzADoNXDa3fm0o2HaI=;
 b=RnDDrwxjzqhHQOPRtwa/WtFDk5trUJ1ZIOlB6TTNm3NmE0I8GQ0HmYlIctqK+lo6XT7ZiC4hDkoI0BhBaziiOfaT0dtb1UNZ7SBK7cG4cyEUjSjwAHm/GM4GkEhTlHnbZtxwin+jCOR1TR3c9Xw3CG3fw9xgaD32TT3zPZSK5uc=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 08:18:59 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 08:18:59 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org
Cc:     stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Date:   Wed, 14 Apr 2021 16:18:00 +0800
Message-Id: <1618388281-15629-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HKAPR03CA0005.apcprd03.prod.outlook.com
 (2603:1096:203:c8::10) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HKAPR03CA0005.apcprd03.prod.outlook.com (2603:1096:203:c8::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.6 via Frontend Transport; Wed, 14 Apr 2021 08:18:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efe9eaf8-fe17-4438-f2c5-08d8ff1df470
X-MS-TrafficTypeDiagnostic: BYAPR12MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB3192AA38A1F0026B2AFFDAECFB4E9@BYAPR12MB3192.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83nWr8f5TC/Ps4493F/bNsCy+LSdRzaw657LzNhJhj/rstM3RV4Ct8Yc/HWHA94fRMn6l7p8W1v4YqOICKQEThpQ1euhoKaJpR6Dl01NdAWnCzRcO2N/xmF+/lnL2tBjN72mER3r4hq71f4YvO3Bf9QnZ7gC4cykjpV+As9wjNZZ9K7EL6FqKXKyoa7BbodV38dXGX0/DRPnF60C+hOzcUXDCujWdkVFRRi4HEYdw7tWKzaexbebFeDoGMEY0nmYmZPG1wrmwYXjAwdhgPtk6y6DOkokmVn7Ay1AcaNbhUqsQ87omMwgisnwNwK0FR8TQIS0uHhgHvEk+S6a6BaIZhq3GcbbKAeiomspqvePTfjJtfkOFPHB4C+eWzM0ikAmMlZw8oPFeX6mIg2pxG6+250/G+8Cijp+QggWTVhDfghEBvnJCYuKmtZtkoHCO3HbdlZa00BYAPYsY4rUnovPylPPKy1BLWsSp6iCJ6Qn2qfP7a2AuaAoHY9aIOY9d4iIjj0k6dxU+x71TIu63ZKAmAGaT3JF7+bQb8L3Poe6cfi9yQVN4XwxrDhqh2lrwjwAjsjb7/CNUSDA1ISidwdKbFiWYBWH+lJhM0BmWXiQA88bZsXTr7dD1YMZXsCBZRequXxAPM2RzEJafH6QfPqrQVkGs7XFcWm8NI1btUVB9pg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39850400004)(83380400001)(8936002)(38350700002)(38100700002)(86362001)(6666004)(478600001)(316002)(5660300002)(8676002)(52116002)(66476007)(66556008)(26005)(66946007)(7696005)(6486002)(54906003)(36756003)(4326008)(186003)(16526019)(2906002)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BsXEwe+QGKwogGJVhW8agLk8G+ZHz3SwZqO6TrDK1LE5RCnyM6Y9EvFGSl8Q?=
 =?us-ascii?Q?6uhSl1ZO2xUsDNDT7kBPeuy/3Pe+tvT0ENXz+krwzfJ41J+tlq/hiEKtU9s/?=
 =?us-ascii?Q?tIH2R5H1mJiHeVuGDC2wcE56dZOB6N+49VjiTbV5QCoUngoIwPqxop4uzJPZ?=
 =?us-ascii?Q?6wmHaqENijocbxnmb9w/UWjWPNDqKQgTIQbh7DPTRlyoRF3snQMNDEA+z6Zi?=
 =?us-ascii?Q?yJY1MdmCASghPC9wY5PuishkKnUu7gg2pkpox2HFic3W4UNXdyU++ZgC682g?=
 =?us-ascii?Q?jcCYrRRLRRueg/Agj8xhfViFe+HznL+o1Byhc0K0CnBnZx7eIAB/iiPOwqds?=
 =?us-ascii?Q?J5mvir0XnxGFmyziGMWiL9VgoUXIuCSH7WKYNQGwYOGsd4fX2j7AMeD5Yptf?=
 =?us-ascii?Q?MH+3y6rKhbVelvzayGwUZMhyewLDh5vDiHveFckSJ5kmAK/EJz3qVwHIS6DP?=
 =?us-ascii?Q?0s7Q4oXCab0SqraivqNF6JXZuJllx2Z0OpLuatKKSK/6Npkd40fuHLpFoWdu?=
 =?us-ascii?Q?GVmUyiHRmtj43nS5ckUfnuRJr4FFdBRqI+YLiK096qTKXDV/AvEdvt7lKTDH?=
 =?us-ascii?Q?NIGibqR2U/qVJolhpuiJEsYkglAuQxxZvXRn45xZf9vgt+i4i0pJfPAAfJaU?=
 =?us-ascii?Q?wjW+6w9KgBzq1bp1wTMmo8IoYR6BKDc1Fyx8TrVVeP2iwiEWeKTQfJXRjmyk?=
 =?us-ascii?Q?wEeI8+wC5FH+VboamstKWcuFVwOc9O+T9iZFuIcx7PdmrpUc4icVx//saE84?=
 =?us-ascii?Q?JE55Mdr7+IzWPJmP6we6DfYrdF9yrBSMD2B1q2d4JTg4SECvd+d7q5qJDWnv?=
 =?us-ascii?Q?Xx8NFRmHAXX8UnNGN32JMkIH0vUOKSHF/T3lvc5aBWybNwRKJJbYtC6ooO20?=
 =?us-ascii?Q?iySRs9/UJMqal9URjTbfoYGtywRjKi2f2/MYz4YBfaRxO2GNWSTUtc657jBb?=
 =?us-ascii?Q?mrrnVKwm3UG6tpYVGp7uyH+HCN5KWFd19nyZqt6+4xtJ99iq+Ma9tkXTs6RM?=
 =?us-ascii?Q?GOTNTXEZaRm3bzPN7Id495u+Qb6tPmoaXGCRdWLphh0LCZmKRpnauS8qC9ZE?=
 =?us-ascii?Q?ECQieh4VCR3uJxPlMgu1Dt8J0jdr/oAAkRURCAOwYRwQOJmoIfLb/+KsrhwB?=
 =?us-ascii?Q?mghjc0dYGgR9KmrDi1cXeB3HAF/3N5vHaIEM+8hqddTceTojoYSLeRByfdb+?=
 =?us-ascii?Q?cZNyx3CNn2HYdj80oyYm83ZuutvWl9MaHff45u4Tnz9zGuaJiphycIYQzIwN?=
 =?us-ascii?Q?WIDlgw24JxMAIqNJqKNW/wqyfn7Ie9h8uK4xu5rwGyOqgZOXOjaI4gQLjZ8X?=
 =?us-ascii?Q?J1YlXdfrXbfUIuV0dEQaV3fD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efe9eaf8-fe17-4438-f2c5-08d8ff1df470
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 08:18:59.5441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1fzvaVXw3uxXqE7wDwcxdoxWhLG1PnG1Q+EdPmQZ3MEfeLwHipuFhrz69/4VLa5b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3192
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The NVME device pluged in some AMD PCIE root port will resume timeout
from s2idle which caused by NVME power CFG lost in the SMU FW restore.
This issue can be workaround by using PCIe power set with simple
suspend/resume process path instead of APST. In the onwards ASIC will
try do the NVME shutdown save and restore in the BIOS and still need PCIe
power setting to resume from RTD3 for s2idle.

In this preparation patch add a PCIe quirk for the AMD.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
[ck: split patches for nvme and pcie]
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: <stable@vger.kernel.org> # 5.11+
---
 drivers/pci/quirks.c | 10 ++++++++++
 include/linux/pci.h  |  2 ++
 2 files changed, 12 insertions(+)

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

