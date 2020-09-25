Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFAC278624
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 13:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgIYLmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 07:42:07 -0400
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:10240
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728336AbgIYLmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 07:42:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs/gRDuQhOmRVRVVBjmLFa4utiX7sfr0ZXZq+v3bB7Ekik6ARkN72+2YkMSKTdF3PSH1tySVIKl/gywVuRFMPZF5Drvz/QDwWhnjlUoUgpBUzMUo5qsRRKlc46gGgm1+1NoZtd3I8hwuM2kDxKArM1ezbh3FKFM8QR2/O9bUjj55f6hC9yt2n2ioYneIOM/C2S+q7p7Hi6Q576r/vukUjz8MgX9cap+EES16LIPzMwO24evQF3+etL9qBjvrO7QaFv1HhP0/NqzBvYihRJKuza9JnABRWTAGgmZppm6/xS/AihJr3aSA9eBxjPpMYK+9u5JUvqonWoOvF+52xSohtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wotW7OAD+b+0Aqg26B4hnW2V+z/VAKpDbBpNI2yZjvE=;
 b=QI8iAP/lShptD7miJVNHexgLh1YMnh5CFY9+A8lufFq2rNwp0SSyJqQQ0SBdiZNnOpquFYdtK3qooOPP4pTfpCKHHxAN+HX+ZlQnlZzRyNrBzNAF/wt4wa0lizFW9BAtL4rvMgLxTk2pkTzGnzxxqJUPOigZFSIjcYe86rRtDZYESpoCOwEM/fnyYobrmL1NIhTY4HKmJLHmiXztnrA34sxokrU7g3NGRKHzG8k38Y+BD3JBpHvIBykgoaOxGeufbaHfkJHkKJZKHSfnZGRUP5WR/rsSPhSpWmSqkCXcjK+UgaP5cWQq1iavSuLMBa9a2L20/uNsEhewbzzq7JqKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wotW7OAD+b+0Aqg26B4hnW2V+z/VAKpDbBpNI2yZjvE=;
 b=yNu4P9L2Rr/svt04r7woGz4ODKsT6FL3wRA5Wa06bMrJMJ9EYzFqtObghnLX3KkTjzvUkbQ87xsF0dRw0D+UObaS9XDLY4mWVtv6uCok9t/cMtc4CcROOy1Gv8elMuva7U9P6HJtEb1Yv8FPseWgoeOzL6v7wNqr2qL1ciuKRUo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.20; Fri, 25 Sep 2020 11:41:55 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::48cf:d69:d457:1b1e%5]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 11:41:55 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, joro@8bytes.org,
        Jon.Grimm@amd.com, brijesh.singh@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE
Date:   Fri, 25 Sep 2020 11:45:05 +0000
Message-Id: <20200925114505.232280-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.78.2]
X-ClientProxiedBy: SN6PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:805:f2::39) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ethanolx5673host.amd.com (165.204.78.2) by SN6PR04CA0098.namprd04.prod.outlook.com (2603:10b6:805:f2::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 11:41:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: adc4c2b4-fec6-4be4-0c81-08d86148008f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4957855FEC25B727DF398B21F3360@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tH14XkrNkpmrmN2sBg00gJnpGQsA3H+FJf/HynTs3VBFPERR0Z9YI8GsINt/CJkjtPpwdpCj7OXd4ZhU4MQi0mTu+kJobdD7aGJQVaFAryKx3H6EJAru4AmoH4+J5riYyiUnLI7uzzK/enKwB7VU4Ay4d0PNgh3Hhd3sJ8xkeH+PQq3J9PND0gEsX7EqG/UP5FsqlJaECGIruBmTorIJrFAVb0abCdtkK7egvSiyWAOZmeN5BkNFpyvOraPn0p34U2cB/DK5XsXD0p4ocw+vRImx+NTsYQqpM8MCxHmWwAN5WDFn1c6colLaEKAg7Ne+9CbGtVJeHfdG4y0Zgz2anI2hRlXvdNEKsps9R+PCS1epj3a2PijXVLDSNTNOxefj81sB7BLr2Jye76kn3jEds0qeZI1zeF8iCfQst9FvvhVCQLFnjFhWch2FGcbI2uHQqvSFE8jrV7o3Cn9gdIt6mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(966005)(66476007)(66556008)(6666004)(66946007)(86362001)(478600001)(54906003)(8676002)(83380400001)(8936002)(1076003)(316002)(2906002)(52116002)(36756003)(5660300002)(4326008)(16526019)(6486002)(44832011)(26005)(2616005)(956004)(7696005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TwMn4aU3Mi3h53FZikBtS41rdmOSWL6u1X/pBuo1KtW3AOy42xqY1o9/3BfblWrNlF74wXbvgSzPh7ynHcYSAjgV0EhqNsLa4faRG2JlhrWmu1EecpMubtolSJS1S6gNoEWS2zz9gMYt9EvjFZlOnLqIvy1Gr/sHUL/5EJDg6k1TQnKe+x9Y9XzDKqOLzfSFxwo5ry8Ks1usQGRIKMY5jACjYK21hJ8OZigoIFrgMPi5TcGYK8PvH/y/v4pdygVSVreJ7WN7kZSPczfqQOsTNZEcqpdjpuPVY84PhcxWwJOO1W3qvVZmF0IO2L73KphlPI3DIZ2gaMetl7NKYI00J5g9TjYKe9jfXMlPYxhl5AGLGjSztkuWDKYptf/gYimtwfgPSPBWhSp+hOXFAYLdQPh8PkR4CtWZ99PPFO1g1kuA6qpwzvLBu2cyT8hdEwCvdNayQjc+AHkFZdfZfNjgTofL2iNqPktXrzQ57o/xiOo0HWUea0b8AjlMAnCDN4RK9WywR2MhVctnOJE7Mv6pYy4Fqle1MYOmdtUJvzsFxCPsl+Epx9/yIJRZcSqPgcnddu+kd3JKKFYN285HvjxotHNFP/PK5d2Jq/7sZVsAyeEttIiw3GnaR8C617enI0UJlABYTYv2DMxERQx7DKORHw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc4c2b4-fec6-4be4-0c81-08d86148008f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 11:41:55.0748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfr49A2C8Xq4WA5W/waCHyInsGuFHy0S1AEUDdKHNJ++fE0NtAVtQ/Dkmg6ymksbduoyvUN/Wn/hj66m8ceF8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When using 128-bit interrupt-remapping table entry (IRTE) (a.k.a GA mode),
current driver disables interrupt remapping when it updates the IRTE
so that the upper and lower 64-bit values can be updated safely.

However, this creates a small window, where the interrupt could
arrive and result in IO_PAGE_FAULT (for interrupt) as shown below.

  IOMMU Driver            Device IRQ
  ============            ===========
  irte.RemapEn=0
       ...
   change IRTE            IRQ from device ==> IO_PAGE_FAULT !!
       ...
  irte.RemapEn=1

This scenario has been observed when changing irq affinity on a system
running I/O-intensive workload, in which the destination APIC ID
in the IRTE is updated.

Instead, use cmpxchg_double() to update the 128-bit IRTE at once without
disabling the interrupt remapping. However, this means several features,
which require GA (128-bit IRTE) support will also be affected if cmpxchg16b
is not supported (which is unprecedented for AMD processors w/ IOMMU).

Cc: stable@vger.kernel.org
Fixes: 880ac60e2538 ("iommu/amd: Introduce interrupt remapping ops structure")
Reported-by: Sean Osborne <sean.m.osborne@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Erik Rockstrom <erik.rockstrom@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20200903093822.52012-3-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
Note: This patch is the back-port on top of the stable branch linux-5.4.y
for the upstream commit e52d58d54a32 ("iommu/amd: Use cmpxchg_double() when
updating 128-bit IRTE") since the original patch does not apply cleanly.

 drivers/iommu/Kconfig          |  2 +-
 drivers/iommu/amd_iommu.c      | 17 +++++++++++++----
 drivers/iommu/amd_iommu_init.c | 21 +++++++++++++++++++--
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 390568afee9f..fc0160e8ed33 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -138,7 +138,7 @@ config AMD_IOMMU
 	select PCI_PASID
 	select IOMMU_API
 	select IOMMU_IOVA
-	depends on X86_64 && PCI && ACPI
+	depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE
 	---help---
 	  With this option you can enable support for AMD IOMMU hardware in
 	  your system. An IOMMU is a hardware component which provides
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index fa91d856a43e..7b724f7b27a9 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3873,6 +3873,7 @@ static int alloc_irq_index(u16 devid, int count, bool align,
 static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
 			  struct amd_ir_data *data)
 {
+	bool ret;
 	struct irq_remap_table *table;
 	struct amd_iommu *iommu;
 	unsigned long flags;
@@ -3890,10 +3891,18 @@ static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
 
 	entry = (struct irte_ga *)table->table;
 	entry = &entry[index];
-	entry->lo.fields_remap.valid = 0;
-	entry->hi.val = irte->hi.val;
-	entry->lo.val = irte->lo.val;
-	entry->lo.fields_remap.valid = 1;
+
+	ret = cmpxchg_double(&entry->lo.val, &entry->hi.val,
+			     entry->lo.val, entry->hi.val,
+			     irte->lo.val, irte->hi.val);
+	/*
+	 * We use cmpxchg16 to atomically update the 128-bit IRTE,
+	 * and it cannot be updated by the hardware or other processors
+	 * behind us, so the return value of cmpxchg16 should be the
+	 * same as the old value.
+	 */
+	WARN_ON(!ret);
+
 	if (data)
 		data->ref = entry;
 
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 135ae5222cf3..31d7e2d4f304 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1522,7 +1522,14 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 			iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
 		else
 			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
-		if (((h->efr_attr & (0x1 << IOMMU_FEAT_GASUP_SHIFT)) == 0))
+
+		/*
+		 * Note: GA (128-bit IRTE) mode requires cmpxchg16b supports.
+		 * GAM also requires GA mode. Therefore, we need to
+		 * check cmpxchg16b support before enabling it.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_CX16) ||
+		    ((h->efr_attr & (0x1 << IOMMU_FEAT_GASUP_SHIFT)) == 0))
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
 		break;
 	case 0x11:
@@ -1531,8 +1538,18 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 			iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
 		else
 			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
-		if (((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0))
+
+		/*
+		 * Note: GA (128-bit IRTE) mode requires cmpxchg16b supports.
+		 * XT, GAM also requires GA mode. Therefore, we need to
+		 * check cmpxchg16b support before enabling them.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_CX16) ||
+		    ((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0)) {
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
+			break;
+		}
+
 		/*
 		 * Note: Since iommu_update_intcapxt() leverages
 		 * the IOMMU MMIO access to MSI capability block registers
-- 
2.17.1

