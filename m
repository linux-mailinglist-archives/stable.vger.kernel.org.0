Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DEE3600A8
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 05:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhDODx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 23:53:29 -0400
Received: from mail-mw2nam08on2050.outbound.protection.outlook.com ([40.107.101.50]:5358
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbhDODx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 23:53:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PltAuT/k5+9lBI6qE4ebJHvFNIS9xiu5ie7/aIUypS/8v9MBrr35kOdBWjlrH96oq0x3iITzsSVoVTIpOLZE4Br4XVNXs2v6ApgNYrzjJZEx2eieegDnI93yV8xbBrnWc+nOkdRHEhczevGtXtBB5r7faRqT0H+rZal+0qYRFC2peLTxhGlNM9iv10UKFVdFSIRdgHEl1t7OAW4rkOqZ3WENJsBCL5K4NTgL+pBcJzN+VmghzVdpYkakjw0ooz6htIiFpdciNj6fNibke2XoUpgx3MCPDpUH/G31uXDdTX+1qGucb7pZDTLZdVSYfLGeOQdhwd6llkDYM3UA8JpXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4s1pRAytZ4H4ND4at+80EUM+H3QMa/WP26gzpGTXYVE=;
 b=RQYXNnmjj8HxW1yj6cGybdamsVxpVva2txfWEV67LUNMp1pGw7vYh3egffc+wbF5epc23bH0W8VM6quDSLUGGkV9zVwn1+5+OGCdQvBj/hhicxLU2G6Cu9hapJgC6i8DKQj9cYBNs6lJiiJt9mTJyOiCjHoL3ZdCjPzyCZCs5I0Q+lNW0lowI4+ANZoWDUQ65rK82oE0iMym3aCN6Y0xgiH2ayWlGSEQSks+NR5scb0MnRLrfyOqXmCWsz2iLgy+askPT63qxGFAaVn1MuXHYslujOmDaMPI/2K0WZgGRUooDHnSUvMgYzwX772+u8vY9VQA6bv0bgsKWO9cPQ9JZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4s1pRAytZ4H4ND4at+80EUM+H3QMa/WP26gzpGTXYVE=;
 b=Ypdh2UedvDsfgiv/1Ijr5lWYyLvqzIDIAgFVDCpinj0XAGSCgh4L4FoOb3dt41xXGx0ZZJwrnL1yJAoMQmPj1N/X4y2qeve/BAFuafiqkwYNAXGIFZKjd6o5Shgfd1Oy+fExdbFXUkSU+biZZ/Eg5CcnPkvDpTFkFqKP9aGSnR4=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB2726.namprd12.prod.outlook.com (2603:10b6:a03:66::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 03:53:01 +0000
Received: from BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c]) by BYAPR12MB3238.namprd12.prod.outlook.com
 ([fe80::5870:fcd6:b13a:c49c%5]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 03:53:00 +0000
From:   Prike Liang <Prike.Liang@amd.com>
To:     linux-nvme@lists.infradead.org, Chaitanya.Kulkarni@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        Prike Liang <Prike.Liang@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 1/2] PCI: add AMD PCIe quirk for nvme shutdown opt
Date:   Thu, 15 Apr 2021 11:52:04 +0800
Message-Id: <1618458725-17164-1-git-send-email-Prike.Liang@amd.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [180.167.199.189]
X-ClientProxiedBy: HK0PR01CA0070.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::34) To BYAPR12MB3238.namprd12.prod.outlook.com
 (2603:10b6:a03:13b::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prike.amd.com (180.167.199.189) by HK0PR01CA0070.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 03:52:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9480b971-1324-4254-6977-08d8ffc1f6a0
X-MS-TrafficTypeDiagnostic: BYAPR12MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB2726B38FF505084B823A0DBCFB4D9@BYAPR12MB2726.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: agTFSk7zdXanVpLRisZhyNhnUHGY86pN0QITSPFNH84sbNiOgOBBIOPKgTy0H1n+qbsATeksxEZtCC90sFy05AvHKv2SK2UTwxS21aFLgnPCenaaj+BaAuo7PwYsNNIjR2m4VIgjsAjUTnhYSolWQHdEgwdfS8G4Z6RB190a3erhyT2PzcZDjgkQeUS/4kzqgW2tn+7rQ+60BIsewRUxK/fgQHEv8ljS4JxSIauJ6kiX0cgiBvHE94TSkJ3lhldXYpKAyt/+FdGGkvvtulAX//sCSnlRZlNYBdRypvZelQsjg/0n7r58jNHfoAAkG9zpk5X8V3kZJ2e4L0QVLV/75u7t5D1LAXpHx223t9nhrR3BUw/JNa8EchRqajh86s3FmL7LKbeNR9k8FvUhJ40CkCCUSfACglo9JXViL278HVEFwTkAlPZFCOxAF6CRozEs6FkzFHVyFr4G5/8s8xMoJkGT/cRVgark8ov2ZmfzGuWy/b8ano+HLcmsJuXIbHoLAZuzvWbzZIrwPv4teBfdlUoTqK7Qimq4N6l3kuBe25ElR+87++Kic+dCtpC01VceYBiFkzYiFVptpl5XtW2Jc5dMqMlCgDwaNdwrdQV8Z1BtW0ydkyM915Iji5IcTZBIxhynNYOsjQO41jZxsbfRWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(5660300002)(6486002)(316002)(478600001)(4326008)(8936002)(86362001)(16526019)(956004)(66946007)(83380400001)(2616005)(66556008)(66476007)(38350700002)(186003)(38100700002)(36756003)(6666004)(54906003)(52116002)(8676002)(26005)(2906002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iaoQ9um2QRzkQt+Gm7HdcjOkMJEJJZ7a2HM8lOYYb82UllYnmQfF6atd9rBg?=
 =?us-ascii?Q?hCQwExVAEE3f/Pl2d9ewKB2229ppGq84amxcVpANj42TrAJsMPL4pnv6qqlc?=
 =?us-ascii?Q?jFR+n1I7hyG3w8UEzlMnM90sNLHMayUfudXk2uRgpQY3Mth2d6VcoKf0f2q6?=
 =?us-ascii?Q?eFhfeJBXLV2ddnWohQhV+UE9Qglbdc7mLi1MFwwA2Y84Eub5RStE8nGEVi6l?=
 =?us-ascii?Q?UA9h9v8e9mMBuWv3fw1NPE2P69MkSidV5nUKb53usq5JDB7PjSgD1jLfpnRk?=
 =?us-ascii?Q?9z+PgefhAnj+W4I8LcFQdIuJihNRQtGx7EIMlloGqVpirTJ4UvG7RVcV3CXo?=
 =?us-ascii?Q?BZSrFuLnDJ4vNLVgp4YuS4aCvomv8wl6oiw+Mr7mxmp41uTpRkMRg1P6oD1H?=
 =?us-ascii?Q?UKqQIEt2G+7yfzAMYbwDaaoBhi7lwOdLrTWuOjA1zGeupG8XUTDxKu5p9WNb?=
 =?us-ascii?Q?tvhMZBhfKSxnDMcF7eusphfr2wBmigT12CqUZ/wyU/I2/mFyIJ75MqeUL+Ls?=
 =?us-ascii?Q?kqGvwjjdPLaeieT9C8xEMn0vvDhXOLLZuhQCBZ6XOYAL43Rbjzdw/ThJipEu?=
 =?us-ascii?Q?W2dEt7reeGUGWW6PBQEYDEfs2A+mxMu796ACzYl5wgbxvyv0rZfDfzUKXmFE?=
 =?us-ascii?Q?xvYWbGuy6c8EkogWxELmKZEb0zhLm4cgahUNQwgKCqzicqoLCSDLYSXPDSBY?=
 =?us-ascii?Q?z2S7edGKJg7FfjRyRf4MCEnrYuBaS0bCzVDxvY3GpAqt1o+I2x6OMrdWnfZB?=
 =?us-ascii?Q?nnKiC6o8uKQVropznEvU4ilEx16eRasAqFplft+ubx2kjIw4VrXm18P2y7Iw?=
 =?us-ascii?Q?G35lEQ6TUoimV4hAfpTcRAmKiqpsh9QWvEQny2NtM2cX+T0UplOChjTlyhUm?=
 =?us-ascii?Q?nzJkq9qI6DINdiAY6dZgCHKnt0dGaB4WpBpRPSofEtPtRRrDw7URWjscYcTe?=
 =?us-ascii?Q?RVNR7jkGyA51xixmdpnGulKywKmXAASIbkxTfTCUirZtMb072Q2J+c0zH9kw?=
 =?us-ascii?Q?wovdDAUVegW/nsnIkcO+5+wmLocLSgDmzKKIyVpdT7RdS7LSzvaOOsCuAmhO?=
 =?us-ascii?Q?r7X97bea2PwzQGM9+tV9W0jied3TzoBGdcPtE6je2rIs3yfVNA/rB60qxVPB?=
 =?us-ascii?Q?cCJMhSv+4tDTl3tDRlD6j4k5fLvAfhNh/7VZ8mSNH2ffwZSZVlRqr9BKFnPR?=
 =?us-ascii?Q?QR2UCCiSHgK1XeZyMQwKFhf+L8UJn/qBbGB721R2V4l/HibVPU/1zG7Lr2aL?=
 =?us-ascii?Q?GdklJ+h9P0t6mtnU3H73od3Q4OSMtWGNF9QvLxgAF/wajhmg8J9B7+RAwbQR?=
 =?us-ascii?Q?P+FfnphqbPhxxpnTREtJzO07?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9480b971-1324-4254-6977-08d8ffc1f6a0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3238.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 03:53:00.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbOa+OQDfxLSnhmHxKcloTmXTE4C92fT4nT21kiK8JJtOvRDg/RQNiO5kfzG//n+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2726
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

