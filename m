Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0B035EAB5
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 04:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhDNCTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 22:19:47 -0400
Received: from mail-mw2nam12on2087.outbound.protection.outlook.com ([40.107.244.87]:36694
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231786AbhDNCTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 22:19:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erPzX+alOrJtEXPXIleky2r7D/T+BLrKPdW+71HiX+0gKHs5vbZpT47gHWATnB/m4QOvRGyGYFiqcv/PnHY/G61aGxOgU5lf0NZUTVDR4IeTbNpHwyOwTVL9obdx/KXp+Gm+hvqzWvpbnUCDqpzENgzeoA/8Z2RfZz8aMIPZLOwgODb51L5+Ckjf/S9g09wnOYLXEyLyY3Fot0+zoG979Ae1A05RB4XQNzYgdY1+2OHeGZFPLRqbFDBkDRjjj//24/oIoJgh8Jh0jFob5ah6cO5eZWGfuL8HbOTJAjNAxxeEEFy9JRdX//r+zIPmMCOrAdCJe6IRyfTa5kc0YeI7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0+GenC9OVs7q+KYOPFveEXUaSzADoNXDa3fm0o2HaI=;
 b=IFvWxaQ+xQTlMdxe++T/hzSSesAenwP+1hEIigUbf+mKh1LoLbIkCQpUp41gWFiSgrid+cltH4LMlVOMPhYe44iJaCd136XOOHDd+xSctox1Eh8ikbsDUtjfi4oYZEH0yNJZw1XJBVjm9ffG3t7KjvwMYtU8UJRm+JkznInHrP4wMK3VSGGl3OUKaFoos8qeC5e1RlrQpaEETl/cgrJFb72vZm+qYqUx8GIhcwqDhAiWlbvMcgUsvZs2VQZmwqTdCZpUvjmayPlOuD1BqwGRnuiAqAGmSVxRC5G9t0QrjXnl06neG2Fpz0j+4fN4ifMS9FGO4jYPVMyPh/72MfbiJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0+GenC9OVs7q+KYOPFveEXUaSzADoNXDa3fm0o2HaI=;
 b=aVVsqsZdOH5C/21b93f1kYRhwAKT5WTdKoMihMketJXwWIDF3sR7vPE96IPEc3RMp0RJ54GWG6RCY4vU5RAmTxXbRAEmnQyFZ90/eOM7zlIwv/5+DYYezKwEArwqg7d/IQyblKyFe7TqXjRhBCZWzbjG/w1qnqX0zXkfuezYZbE=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2600.namprd12.prod.outlook.com (2603:10b6:a03:69::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Wed, 14 Apr
 2021 02:19:24 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.022; Wed, 14 Apr 2021
 02:19:24 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, kbusch@kernel.org,
        Chaitanya.Kulkarni@wdc.com, gregkh@linuxfoundation.org,
        hch@infradead.org
Cc:     stable@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Alexander.Deucher@amd.com, Prike Liang <Prike.Liang@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Date:   Wed, 14 Apr 2021 10:18:13 +0800
Message-Id: <1618366694-14092-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HK2PR03CA0053.apcprd03.prod.outlook.com
 (2603:1096:202:17::23) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HK2PR03CA0053.apcprd03.prod.outlook.com (2603:1096:202:17::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.6 via Frontend Transport; Wed, 14 Apr 2021 02:19:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab16cfae-47de-4e25-edcc-08d8feebb88b
X-MS-TrafficTypeDiagnostic: BYAPR12MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB2600A109F1E4CD8CB49ED6C1FB4E9@BYAPR12MB2600.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ECQx7PG10tQkOR3vtpm9OrllPjvn/Dt1rfvevSYWgUn37pYY5zcgmhD5P1w5P9QnD38/G1f9z1PxtRI+LshEYXKj6a8ZdmhvpS/vQnX8ySZUp8t3Jmu482M8EgoEF+Khz/lpK88nLALcJDL3h9Xs1Qe8/hthqXCd/HEMcVfAAhuqjmaL4sJLojo7o+TUy+sTVfKrXBUmiTHE7y9h6ToihHhgyHGa95G7Ie2n/VgvKgqtKS/8cHv5Ib7/NhkEBJz1EMXyH3Dlsw7dzzQU9Bid1nzj3/pWSEEzQ7lurFOBzGVk8L8vfExEhYrNPvBSsTyw4q5RutzAeUCi1yrR5EqXdnFYYZaVjOH32jQaPg/CkGptP7elnSTkdt/RBL5yMdVTgZ97w9jyx9ytU9h87hn90etNfJborEkaPuh7N13lnV3WlXqKA2KXnEa7QhjgQj1P6AQm1hYTacxfaegVJq0hIQrxXjCh0SF4O6uwfe6CjWOPOTeDNqWIzxSJ6cKV4/6PENRWjOD31CbdX2VV8KbKXafZIJnjknTIDReMN6XMGCjcLsE+kVDB8vwWxEBtlJMFGh0dbIjTObBd3hj3//xU9t55tVYcZEWMnKNvAEv1Zi4gGi9j9ch0nyCv0eoezsfYVYEGikNXptxvfUjqG9UNHccz40lF/4fvU45OJxKqhk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(136003)(346002)(4326008)(6486002)(54906003)(5660300002)(38100700002)(26005)(83380400001)(36756003)(52116002)(186003)(66946007)(2906002)(16526019)(38350700002)(86362001)(478600001)(66556008)(8676002)(7696005)(6666004)(956004)(316002)(8936002)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/DTlwBftr64SMtPyJGDi4IeGC4SUP9x1YZ92LZ7InFTQGOzrwkaFq66vUm6W?=
 =?us-ascii?Q?gpIJRAmwW9KlFefgs0vSqhAfCorHHvew+P9ctqhEDPPOTJk/3zMIQFOwydu6?=
 =?us-ascii?Q?nl4fiNjNYVk1F+rbwg+8IPkqvvnChH1O3LCtg85kzvqNpzmaAUw62qi+Kn0q?=
 =?us-ascii?Q?IsvZRQMAonp+z2jY7+fqobsNFNlyxshTJ0iDX8ubthZbH+O6ZHVIP+Ipic5W?=
 =?us-ascii?Q?ugyC77w6EEf2jjojZ8BRP5U7BTy4S59z4LM9FAE1/W7cYBJZW8mCCgygHyMG?=
 =?us-ascii?Q?ze4DC1so6Cbxkug7/OY/tDJHWhSezGVoW8vSNa9WSsm1LapQEfm0ndTR6VwI?=
 =?us-ascii?Q?UpQgqmHqnZIUC1mNBgKuuGsZEaouCXJ0wyM2ubHxhFmk9iaA1c4KDBGZL0gd?=
 =?us-ascii?Q?LfL9dLsRBosWYtv5X++dCiEgmvFpATls2QMQVGWIeCnpE3RYwOYHv1emZLXU?=
 =?us-ascii?Q?1lnF8fAFvVseaEIrzn3ZnVz/tDD2+cvF+5H762VVOvp74jOkmBLVrfBqRI31?=
 =?us-ascii?Q?SIopptucdi84Y4MYk2u91LW6eAuehOK0LxiGgwui0Ir6UrBHL2oKuW5e+YIX?=
 =?us-ascii?Q?Mfqc7Z5S9AR9bQnlGGlD9WSIvn9GHPuE6fuES+RWMYl3cf1rbM/Q7YPRjF5x?=
 =?us-ascii?Q?zfoSckse3CfzSbY07stG8ujIC3gum5I43HtmdTab2xBdDTb3fMYgrTyGNv8H?=
 =?us-ascii?Q?WtWPh7QWtzEwol0iO0QwpWUeMF22KTsNWQVTCFkFD+IISCCNstw5mRQ/Ybyc?=
 =?us-ascii?Q?Y96eTq5PJLxZM32zayAPm4E0aFzKTpO7lJjvZ6glIqlJH5apM2pZ0kyS+63T?=
 =?us-ascii?Q?EAGCKv45KK+eE//JdDij/xIUHWUsDwKsu/0cm+g0f8ff+Fv8RAZADfQnx4Fd?=
 =?us-ascii?Q?Tj+Q6CNp/6RW1gZErM2ov4xGVrOsg769ylLacLo2Q/ejLaXGuh664WsHvRdR?=
 =?us-ascii?Q?RyCmucJDycWfeaIIGWExyNIDmrf91KiuuzTQqBVdA1vC4Ke9jmzjdMKXSDYH?=
 =?us-ascii?Q?Gzpcy1oXl95kX0d8x3RGNx5ThvnU5i3wsxdKs0IULEdXbyPJ2pT4YjGighXC?=
 =?us-ascii?Q?541eA6P8FDBTlThITZch9vyjlBjfEapGznA50AP1Mmqko/VbvmZtVNko7Nna?=
 =?us-ascii?Q?tX0mZ14YQy1+jBCU/VHMly2uSXuRf8Km/CEHiAOrM9n8zlab2RqSprRnqbC6?=
 =?us-ascii?Q?jpFdp3JcXQ85+rfs5rAKHk2gCkJyVxE40U1i+dGU85GJIhfzr86kVujNX61Z?=
 =?us-ascii?Q?quAWWgKHbN0xUtOCTCjlED5tReFHF/dpDozXeTHct1wlWhHZ1uNptDcS07t5?=
 =?us-ascii?Q?40IiPuD8clzanEEsaPk/YEpQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab16cfae-47de-4e25-edcc-08d8feebb88b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 02:19:24.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0rj+bEK1bWEmpyjtUe5JsNi+OSWu47dmXOKBsJNFSHFfeJn/toNz8HZ16Q5VFdN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2600
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

