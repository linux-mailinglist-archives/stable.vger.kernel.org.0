Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D465507B9B
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 23:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357885AbiDSVEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 17:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357740AbiDSVEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 17:04:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB2E31912;
        Tue, 19 Apr 2022 14:02:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyA23AaC6StVRi/5W6auNvCuKiiB6s13wHp8BDQuNaQ7jt41fIbsx2I0PUoXMEqsLiTaxgFjA6Gn7X4IwHTxLmNQWmMGszIwVmeTiXnWUKSSf2LLHuAt8M2HQGAOHYu6miVBhgM7yD9rRIednVpukvGDCI3wUScbBfMGYxwhGB6FUv3tgstHMERZU34rk4lXfXAskcNhZXinkBMQU9CSTRGHTPT6JJQkYP2ASql2tqFGdWx8v0ASDuYunf0624iwc9DBbrTPAJeMHgMaE5Is3p0tuTddIO/73ncAkf4rMC/qBdt040tzdYzpB0Aj6d/5SVHauTo5OuL7MdnB/kgkaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fs4MrWJWy3dy4g0QhSGSOCy6H+hqFDc2/g74NufnRlA=;
 b=Y0cSxcMH2o1Bhya+Fp9M1LmZRnF7JSOVc3Y4r+a5Y8fSlEi9KwNYSE404SFAsbp0+qPxJa8zx1SPOhIOKecUmTRgMPvlOTuCzUpab/OJPJR8+ogYjoKU9Q+TP4yH+bKvtBoBt+ZTqWKmm+HBtGWFXn9b2xmQeWR+gxfjYR7Gz7N8C1o4e6RJcPj3bLAGfL8HsFuGBfuDq61oHH5Nl3hmE2LphBkCvpmLaPVOjhKLStaGixgGOqsuWw/1PnQHeUxep9XhQvcuT3Xwv0Y410eQWzavBmfxSEIihwaGPR+1VET5mmjs4PgXWZ1TPBD7BrAzNp7uqdVBE3z9e0Z4y+NAKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fs4MrWJWy3dy4g0QhSGSOCy6H+hqFDc2/g74NufnRlA=;
 b=LWMGjd8sjGww32jzEB/n0bUTGYZH+EKlpkAElhd4bapfUHkxrLlerWmFBcATs64kpLxEWiyO5ecbXkPLF01gZUiy2+aQgo4yLqCzAmJiRTCL3kxCqb7Qys5iwEvB4jNtbqHI1FQ0poXTRFfWSH4vt9w+CMhBlKPn9BrKc40tSpOBvjb02OIVaI4d8+HbLR8oQO2usnm8uEvwd97srMV28aSelQlJR854fZOjvJabTDMqFkAgaLj2PKaOx9AsCOzUcmnIgcmlNAOxb6sZmS/XHLl4i6IWfRbAzMgzty/m9nKM7hVljIIdvo/st9CIpv6IPzNdTVxENnEDZBMzJDecPw==
Received: from BN9PR03CA0609.namprd03.prod.outlook.com (2603:10b6:408:106::14)
 by DM6PR12MB3178.namprd12.prod.outlook.com (2603:10b6:5:18d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 21:02:02 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::24) by BN9PR03CA0609.outlook.office365.com
 (2603:10b6:408:106::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Tue, 19 Apr 2022 21:02:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 21:02:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Apr
 2022 21:02:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 19 Apr
 2022 14:02:00 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 14:02:00 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@ziepe.ca>, <will@kernel.org>, <robin.murphy@arm.com>,
        <joro@8bytes.org>, <jean-philippe@linaro.org>
CC:     <jacob.jun.pan@linux.intel.com>, <baolu.lu@linux.intel.com>,
        <fenghua.yu@intel.com>, <rikard.falkeborn@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH] iommu/arm-smmu-v3: Fix size calculation in arm_smmu_mm_invalidate_range()
Date:   Tue, 19 Apr 2022 14:01:58 -0700
Message-ID: <20220419210158.21320-1-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b47da6ab-d5c4-4eb4-73c4-08da2247da1f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3178:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3178590E1C44EF9A0BE76CDEABF29@DM6PR12MB3178.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y2Rje5Gkj0JRq7fSsXy+oAop8ghaTHXKhXpSOlnUumNLhg1Li6WfZr9HkQoyPrdwLHhsvgw09s5JruDsoxZTG3n8efBiBDEmIF96kdBreOeeXRn+m3NgjZ1LKZXuI2wix3pXuNGNDAifnYdjrlaUCTjGHMIZyfIV7z6/gvYNQHOw7XK31HZDR1/9Xm/5Qek2ZjHcvPWbuVMW9Duu41VlSGYW3cW5wB9RxxrXPXWaZ/+hx32yspjgykSTz3dlI4uF4XjLlhDNof69gmAJEklGNCQLWQK3vWPjI6Nmk0Iez5BPN7dQQGj61ygkb7a+GC2n/r/Tr3TeR/nyJklBgWD0Oi/d8Vib8dYo3D3pLY5t+oeMEwS8WNXs00Rmr73bkmBK7BjphiIGGRS9nJOpm80eM+gIr61H37lAhkLsY8FSVsoy5zoI+hcjJB+EDlRfHzbfmhGzo35RlHLF5qPkVsiCq31aVJYwbsyyHakeBGTNpomvKjjmFAWy28Yhc4KC8r0myzPVOzm34VmGZrvv3nyK7jnJ22mqT+BnbEdpczytUpNbovlByQ2z/HnSXx1/u3Oz4Yb0tyE//H8hjy5OipFoX5fzkaXLcseqlR0X+saVr1Ol+uCT/JlucH+MwLcG3KYMEWtTzXJFYLs79tHFNqfBZqroks0G7rlEDgMLEJ70I0ffEcefDJnvwgmTR7yONxgeF1RBB3dtsnrExhzHTjS6X/ETHdCMCKaewwG3bCXp3Rk=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(1076003)(70586007)(47076005)(186003)(86362001)(26005)(8676002)(426003)(2906002)(70206006)(81166007)(83380400001)(36860700001)(4326008)(82310400005)(8936002)(36756003)(2616005)(336012)(5660300002)(7416002)(508600001)(356005)(7696005)(54906003)(110136005)(316002)(40460700003)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 21:02:02.1988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b47da6ab-d5c4-4eb4-73c4-08da2247da1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3178
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The arm_smmu_mm_invalidate_range function is designed to be called
by mm core for Shared Virtual Addressing purpose between IOMMU and
CPU MMU. However, the ways of two subsystems defining their "end"
addresses are slightly different. IOMMU defines its "end" address
using the last address of an address range, while mm core defines
that using the following address of an address range:

	include/linux/mm_types.h:
		unsigned long vm_end;
		/* The first byte after our end address ...

This mismatch resulted in an incorrect calculation for size so it
failed to be page-size aligned. Further, it caused a dead loop at
"while (iova < end)" check in __arm_smmu_tlb_inv_range function.

This patch fixes the issue by doing the calculation correctly.

Fixes: 2f7e8c553e98d ("iommu/arm-smmu-v3: Hook up ATC invalidation to mm ops")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 22ddd05bbdcd..c623dae1e115 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -183,7 +183,14 @@ static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
 {
 	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	size_t size = end - start + 1;
+	size_t size;
+
+	/*
+	 * The mm_types defines vm_end as the first byte after the end address,
+	 * different from IOMMU subsystem using the last address of an address
+	 * range. So do a simple translation here by calculating size correctly.
+	 */
+	size = end - start;
 
 	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
 		arm_smmu_tlb_inv_range_asid(start, size, smmu_mn->cd->asid,
-- 
2.17.1

