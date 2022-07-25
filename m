Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E379758040F
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbiGYSgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiGYSgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:36:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFBC12606
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw6jaLBw/ScrodPDbwbq1FaCl63G4+Bcdsc9J6k9LP94fYV99dhHbK0JU9gfiGOu0HFf+UcR1UL58BzN4cXdNJqKlmaGGhSp8Lw1IdorxlYN+fFwQP7BwuMABBRi54c2lv+3hLoEXomUAInad2ZalhYmEw2aenbFOMADQOuG1NTVN/yAJDxP98A8PEiUsrOlUYILXJtc2qbST5QGL/F+iSnlGy6UhASzpa0aY6hj5TCPOCAmpgLZkGxNW8lZAdduD2JKUJvwB06a6UDb2fd7lLMaKr698zl1PzugjegBTY1muNKlq2AE2piKOza92k/VkWwUlb0fOjx1IGYiOwzdtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oA4be4lqegBXYcIGFJn/IObTLbANwrurBB6qUQrxUms=;
 b=cgqZzmpb4nBcc5ZOg/nGxXI3wdtv7EOs31fmFxOPp8ukoYNH4Zw1QcdS7HNyBeyAU4h4NyfqDfDONmIWAiZ0syCbHBz2NN4blyp0lW0v6VL9ym3xuGj42mV1Ajvk3gV1/4ZmfU1MrimjlNsma0VZzhOGSaXo6rLXnndFVY0J0mCuTzI1N7MNlpd+163FTXfINXoyBd/H4kT1Oy0i2IMnTFVZy/pqWYipJzB6rbS3GJsitGcb94M8jkhPXElGasCw1RuQlCT4qCc+ZN6/vvFbnK2ulJT2V9FhJlbZ6Kq8UWqcoC4ZBYFCEkZSSP/DazbLziZku8KKfW55iWVAH0dwhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oA4be4lqegBXYcIGFJn/IObTLbANwrurBB6qUQrxUms=;
 b=Cfmf/vqgo7uaRE27EAJr1IsfyOclzGdBVjuLyNqdCLwy4NBbxyo+zVd7lR71pG82na8tnhvJvxF/7hp0e8aaXtXHEC4cZW4r5Pv4QIpwOh97Mwfv1/C+dNeXEjqaldwFklvUQSVeyb2CMvNSGTqAeDbyKocYzRtcUEpkGDEJKpEqSqdaLGhVkIrbRwNFwdI2+5ODZG+amKZg4UI0LNO+h3JvLjLPN6DCALC9wfKMfFGH26jC5kyDViPgJjgnkhhxXuOclNEi1Htqa11zT4bhABxWO/Clvsw/apS3RZQtrWtbXeIDNVdojc8RKH+dAomG8KZQPlmAUrT0c0dlwJoG/Q==
Received: from DM6PR01CA0022.prod.exchangelabs.com (2603:10b6:5:296::27) by
 BY5PR12MB3873.namprd12.prod.outlook.com (2603:10b6:a03:1a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Mon, 25 Jul
 2022 18:36:37 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::8e) by DM6PR01CA0022.outlook.office365.com
 (2603:10b6:5:296::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Mon, 25 Jul 2022 18:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 18:36:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 25 Jul 2022 18:36:36 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 25 Jul 2022 11:36:36 -0700
Received: from rcampbell-dev.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Mon, 25 Jul 2022 11:36:36 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/2] mm/hmm: fault non-owner device private entries
Date:   Mon, 25 Jul 2022 11:36:14 -0700
Message-ID: <20220725183615.4118795-2-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725183615.4118795-1-rcampbell@nvidia.com>
References: <20220725183615.4118795-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a00ba4d-4441-4b06-61a0-08da6e6c9b9f
X-MS-TrafficTypeDiagnostic: BY5PR12MB3873:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/XD7K03jBSHdSoJhOxrtdj2SH2gvpV3C0y3o4vKmI7RK1zuqJ2Cpy4ubxn4+QusJsvi8fpFrkVnP/oScqCGp6baK/9Cyqb4wGG6P7AERceFtv8hxN9LGBvMMGunmYocEr5jGuPUtREgDbINu7MinX+k0wmGSesMuktHH1SUNkNeWGNEiMYDG9zeC0FUlaHGyYsIfxUzlpGIK3UNnreSDLnfUXp8y/2GnmPv7eruUV8gaSPYXFv+hj4Rw8GG54900Rcp79cBHvm84dvr0Q+eByHjpiL0EK2ahKH0+e2bsiAJEwZKFSidjAg9n3A4n3enOBVBMyphFt6IoQlxa2HDv0rex++29H7sIV3XaQ4u2FHsIHIjOrJF/bQ7plim9GfVxfvFpMClM1ln7yYE5Y1ciq9JJpEpDs1HJRMZ2EvUHjz8ic72X+zVZ7EsL0zpHN6jf3I0LLixK1vkEVNIXs9/GHt1trY23CNe/SbXVNB/4Pa2LfERXGyi5DECss8u5rybX11Qgnhj4K0OQ8UNXGslcpAT/aM8TzfFgguWFeypwTlyFgid2HfGWDSTDw4Cx/MLgvlZ7JKANOGxPl6LCtn7BakUJtEwTaz5E7znAtMC+fOydmnKOaUNyTN1ZZYBQhGd5x3HMaYpFhyykphPel30xXAe9DwORw/w40zhb4S8toQoFbWMhVkrjLRKEix7uuZfBq/FWhxMdsfiUOGdG4cC9Nx9ikKKf1UQdyYzTCQI7oGmowlFIS5Rf19ymdhVH832pwKCKenJ1r7bZqxwU1vax8eimLxZDICa3PZhG+2c9XiUrJUrfGHsDerDqwMozbknSRsL6E38rU49iTT/LaESsQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(40470700004)(46966006)(1076003)(47076005)(4326008)(2616005)(70586007)(70206006)(426003)(8676002)(5660300002)(186003)(8936002)(336012)(54906003)(86362001)(36860700001)(6916009)(356005)(316002)(40480700001)(7696005)(36756003)(2906002)(82740400003)(6666004)(83380400001)(26005)(478600001)(81166007)(41300700001)(82310400005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 18:36:37.1533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a00ba4d-4441-4b06-61a0-08da6e6c9b9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3873
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
device private PTE is found, the hmm_range::dev_private_owner page is
used to determine if the device private page should not be faulted in.
However, if the device private page is not owned by the caller,
hmm_range_fault() returns an error instead of calling migrate_to_ram()
to fault in the page.

Cc: stable@vger.kernel.org
Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reported-by: Felix Kuehling <felix.kuehling@amd.com>
---
 mm/hmm.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 3fd3242c5e50..f2aa63b94d9b 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		unsigned long end, unsigned long hmm_pfns[], pmd_t pmd);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline bool hmm_is_device_private_entry(struct hmm_range *range,
-		swp_entry_t entry)
-{
-	return is_device_private_entry(entry) &&
-		pfn_swap_entry_to_page(entry)->pgmap->owner ==
-		range->dev_private_owner;
-}
-
 static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
 						 pte_t pte)
 {
@@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		/*
-		 * Never fault in device private pages, but just report
-		 * the PFN even if not present.
+		 * Don't fault in device private pages owned by the caller,
+		 * just report the PFN.
 		 */
-		if (hmm_is_device_private_entry(range, entry)) {
+		if (is_device_private_entry(entry) &&
+		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
+		    range->dev_private_owner) {
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
@@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_private_entry(entry))
+			goto fault;
+
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 
-- 
2.35.3

