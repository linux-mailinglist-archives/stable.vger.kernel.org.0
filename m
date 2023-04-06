Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30AB6D8E35
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 06:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbjDFEFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 00:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDFEFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 00:05:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C22902F;
        Wed,  5 Apr 2023 21:05:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GU4amnxqQKXP1mM86KLuB3mLjmjbnTEd49v1audCFGxmrsjejbz8W8PjNKh4sLlvSGtenbaXHiBRIwiwcHsaMLcA5/ivGqzQoyVgw49a/Gkzl3yrT7nQwb81vhOrpdx3jIgt92nT90j/gJtBupGBMR6ZNPyLuqfYrLDv1dz6+UKly1/5AiqbhSilROqmCdFcmfc8bzeCagO4Fso0IuZNV372jMUF1h5ZgUSJsYDaiu2VD8UlzE41Dp+fPClLt69pgg3R+e9CJ3n+oDy2DwmA38wVgHvND6znL2fxLVd5B7cxRGGl8G7qEywhW6/wD0AjgbUUETrKDrCzUkY9eJl3kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alrwpWzokdohJKiHFc8dXD2lvbqGD0Er9G1lfYJ1zxg=;
 b=JLn2yT5GYLh/V0tciIbD1fYE0mirBUDGp73AXf+LeBvtJirhwdYWeqUpSPfNKfxIj0CeVn+9RD64pySAKnyA2/UIMJqPLTaqYaACyWzCHR6IKZ0cPhvYxHsBtFmYA0aCk/AYvY3+BEFiqbtyfcH7KtnlHzAdvmNvV3xncCEIdEYetHvcHehoeak1u8Jo4QKTkZUt2oAv+wqVhVvv+WnH5oOBry2Y2EGMx5YouemlvIIpdiunzGA08tFPiTG4hCRkx0J4S4hRXCuJ45UXaNZsMHa/UJ3PYpH4cWZjfrTsdlJl5OLTO21n6uEWTLmZ6RE34o0LvHxw0hS70di1PfGthQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alrwpWzokdohJKiHFc8dXD2lvbqGD0Er9G1lfYJ1zxg=;
 b=d8Va2jKEZBLmNqGP4yF8p7fX/ef9F0jzrXzGTLvDdMOFtwSlXkFkAbkZ6ryTVDXfnper1LOX0thsMJ4XX7YcNB+evjz2TwApfvTnBZtydOFZdXQki2/0edgK3U5VRiQcid661MZEsWa1i4Wq2LIZv/+7OKmKT8vXla8m6ZGEcDzXstz+9pQwRhvS/wVWYKEi8oinFWGW0wEpgD6qD4HrLKAyicGuDDKn9PoXVn2xttUolWxe3Q/ZBUg70xscRKzsANvKMhSEBynoujHCpfpdon7RjOjs5WtTHwKaaHdacDk3eVA9TSZQim7V/P4IbSwsC1pcXRVv/oh1uFHgDYhcXQ==
Received: from MW4PR03CA0261.namprd03.prod.outlook.com (2603:10b6:303:b4::26)
 by CY5PR12MB6598.namprd12.prod.outlook.com (2603:10b6:930:42::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 04:05:19 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::a8) by MW4PR03CA0261.outlook.office365.com
 (2603:10b6:303:b4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 04:05:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Thu, 6 Apr 2023 04:05:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 21:05:17 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 21:05:17 -0700
Received: from blueforge.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 21:05:17 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        John Hubbard <jhubbard@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private pages
Date:   Wed, 5 Apr 2023 21:05:15 -0700
Message-ID: <20230406040515.383238-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|CY5PR12MB6598:EE_
X-MS-Office365-Filtering-Correlation-Id: 815de773-0bf1-411d-c1ee-08db365422f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PBhc6zrjkfU1ffSCFTZo+l9bY9R4+anZMP8PKXCgC0h1TTz8YTSO7DFwxFNll2cDDdTQDKr+/6ugilCyPqAm91BbF5+Jeqdu2UPvbEFe/bwkK3xNNEoDqOAQHV6RA7WaqT4La7gvo8pvRsg8BCn1Y1KQz0QMtYz1rH8foM47TYhA0CJE1He2kdNYVOPV7IHWuwmOFGlMA90pI9bQtD0/WmozAGlz9zLpbOskpZYkUkwKJG8YP6o7qL6p0xmn69y0s3jfNyxjpf/hpxeU1VLGZFQMenb4P48kyWZw6CKEpsaRbJcZsasApBOJm64SxjkGvDevKETfLZh1d6dywqIC6SSzvowxkm0dpIgYuI2R6Wp2duyDq4QH9+SrRDpZ9jMe/VG2j6ZS5P36nr+y/QkfQCcDqYsMhVISKmeW5GexBWga8ZeBsU875+43KaEHNt3kAx/mhOiGcmkf/C/oLfJ63HkFdGUyDiz027exYyBTOuyEM2O8ZJkI4s0bRPOujideWWp2FboUNsjzzIbs+5acXkqapxi2dhIkpEYBlwRTwQs4CNZM50OEfKYfsLxWP5GQphbZpsdMoucNMbBTFcQiL4FPJFzj5msMMs6MKq35Cwc7LgcHHcd5gMqaBrNTVyE/j1NBXhNNgbDr5gsl4L3uH36BDZpgMqfyhqoeN3jzrNIJ01MFTVpoIL/H2u6noaDgf+fN2WI6HLsOjNqpXaPi/9vHQQdHhihLggEwjTzoUgkzg73g6yr8sOPZn7w8HlVB
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199021)(46966006)(36840700001)(40470700004)(36860700001)(82740400003)(356005)(7636003)(1076003)(7696005)(47076005)(2616005)(26005)(336012)(186003)(83380400001)(2906002)(7416002)(36756003)(426003)(5660300002)(40460700003)(70206006)(86362001)(316002)(54906003)(8676002)(8936002)(478600001)(41300700001)(40480700001)(82310400005)(4326008)(6916009)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 04:05:19.4025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 815de773-0bf1-411d-c1ee-08db365422f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6598
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Although CONFIG_DEVICE_PRIVATE and hmm_range_fault() and related
functionality was first developed on x86, it also works on arm64.
However, when trying this out on an arm64 system, it turns out that
there is a massive slowdown during the setup and teardown phases.

This slowdown is due to lots of calls to WARN_ON()'s that are checking
for pages that are out of the physical range for the CPU. However,
that's a design feature of device private pages: they are specfically
chosen in order to be outside of the range of the CPU's true physical
pages.

x86 doesn't have this warning. It only checks that pages are properly
aligned. I've shown a comparison below between x86 (which works well)
and arm64 (which has these warnings).

memunmap_pages()
  pageunmap_range()
    if (pgmap->type == MEMORY_DEVICE_PRIVATE)
      __remove_pages()
        __remove_section()
          sparse_remove_section()
            section_deactivate()
              depopulate_section_memmap()
                /* arch/arm64/mm/mmu.c */
                vmemmap_free()
                {
                  WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
                  ...
                }

                /* arch/x86/mm/init_64.c */
                vmemmap_free()
                {
                  VM_BUG_ON(!PAGE_ALIGNED(start));
                  VM_BUG_ON(!PAGE_ALIGNED(end));
                  ...
                }

So, the warning is a false positive for this case. Therefore, skip the
warning if CONFIG_DEVICE_PRIVATE is set.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
cc: <stable@vger.kernel.org>
---
 arch/arm64/mm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6f9d8898a025..d5c9b611a8d1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1157,8 +1157,10 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
+/* Device private pages are outside of the CPU's physical page range. */
+#ifndef CONFIG_DEVICE_PRIVATE
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
-
+#endif
 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
 		return vmemmap_populate_basepages(start, end, node, altmap);
 	else
@@ -1169,8 +1171,10 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap)
 {
+/* Device private pages are outside of the CPU's physical page range. */
+#ifndef CONFIG_DEVICE_PRIVATE
 	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
-
+#endif
 	unmap_hotplug_range(start, end, true, altmap);
 	free_empty_tables(start, end, VMEMMAP_START, VMEMMAP_END);
 }
-- 
2.40.0

