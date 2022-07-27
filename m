Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C33581CA6
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 02:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiG0AIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 20:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiG0AIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 20:08:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E251F2A40F
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 17:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCjIa42huulyhT6q+hJlg4VIelmc86Rq80El65/TsKS31pnNvK/3z1lmzyo3RfylxJ70q3nYkqF1Rggda6q56U9EMyah44QJUrkshYHgUFBIwuTqTo6fZiRNYYpmN43OjT4fBuRAPy4jiAMcXr+5I+jTGYWgG/qod5VGJTMa0gPB0Ss4EjhxdimgGUJS8QPWxJMJRdWOm29oFVUYkvAqU8Z9Xwt0Ql9xUveqQMPHw/1TaDwOEba9S66Cp0ToP708XFhnK8E6HtgFOXM8Sn2of862f4pncahtSnJlXm99A7gKJknD5SXkZduNfaKZn/aprEy1bzPuk6YKzI1SsL63VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYfiUhNngmyYnKzZVuTZZbJMpXLp7p37StKkfp0cyCU=;
 b=bXlYaJhj0DJ2rAM3ib5vg+fQqOS93ZNbvhHpINEB9SB8oLaJu6yJgU05eh5pTnBlxgZw8p24EeEoEX6LBgl+Qea1XEKsVAmQKNL9cdjEfYihTHODEnJX6WxUZa9B4XRDkYEagpnEKSLwXxVmwKA6o6EFokHnBkfmCoiANzpnBQWwd6pVlWr0eS9sh05ApnVGGBIN7xtMFyvFOJy+gcPHfr2DAjwvvWkJvAZZUW+1pACijy+8hWk8hOR68dHZvn84xYECpi/pKWYTWe288Dqh3gLIcwG6RBE3N/FtQJgH3e6Qsi1ePaEHH6FzZJb4e7+v5lb692+Pn0s/k5Z1tLmD7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYfiUhNngmyYnKzZVuTZZbJMpXLp7p37StKkfp0cyCU=;
 b=eFI2mNzgioDP7rM+QZ59YO+vBVOvux4rcsO/h4X3WlW0OFega1FNUcWSKpxW86LihpCOSa4a9x5Y7UpAWvkWMfUwetlINzr04LaJLuxX6hXMcIGZU2fuCgWQsIzvQ38Cpz3dgqqrS7Df+3pK7PsqYk5r347VOtBocGrHlBtuqu5+t6ZGRXHE2Ug5+CHO55WUmrhK0RnwwnBcDZC6GFwGV9eT2IFbk3v9cn/7FZkFsgnTRTTznd1wxEntJkwD45F1jVCDigzyywf5H/aSOgER1A3OZKT5isXsRi468+CY/2IOjOeDZ1n2GE/Rkizk983i5XPMcgbDJtmd2XkOzsIWhg==
Received: from BN1PR10CA0015.namprd10.prod.outlook.com (2603:10b6:408:e0::20)
 by BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Wed, 27 Jul
 2022 00:08:46 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::6) by BN1PR10CA0015.outlook.office365.com
 (2603:10b6:408:e0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Wed, 27 Jul 2022 00:08:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 00:08:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 00:08:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 26 Jul 2022 17:08:45 -0700
Received: from rcampbell-dev.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 26 Jul 2022 17:08:45 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH v3 1/2] mm/hmm: fault non-owner device private entries
Date:   Tue, 26 Jul 2022 17:08:36 -0700
Message-ID: <20220727000837.4128709-2-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220727000837.4128709-1-rcampbell@nvidia.com>
References: <20220727000837.4128709-1-rcampbell@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04ca704c-acfc-4210-4eb2-08da6f642ca2
X-MS-TrafficTypeDiagnostic: BYAPR12MB3479:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpDIYDI9vRuU91KjE233rZEFjuRbNkAKa+Ja0oyosrRKDin6jUj3KB1IhlZ5wP2IAF74f7kw6WKo7eTovvpl+5Xvbs8ojgAlS88S//t22YDZaCfODvW3u/9fH9B466g8szTpIfcGuP5xEZPHJwp/xNdJFlfGuZd7YfwKyerebfwDnLq64aAlrrUiMCFAAjZo7s2+Q8BX9dXjJ6lN2oNo2JHnBbkqXCnfq4ml3EELn/LBVVo60rRDpEXq613fvf/T+GJPje708eJ7bQqjMmJaS+95mn+dP9KPBLNbTwTD28TxfgyG6aJb2IShxigjmxzQxXG0G+bi7KgPivjtnXEqf16iaE4uXWI6l3TEmxDFrcbIpRS6J54AE41D3WAfNcJq7Xve0yNrEOTCOxxSpiIbEuvrzv1xQB8cfXUQ91f8m7SbeslbwP6K5m0gAh9ZqQ/Q5TrWIUo/okdT/vQLwVJVDKGXAAhZYDTOjcXdoUhU6WYEmNw+xDWmbt0q2TD20k6cF0P062gwEmVDxp0TqCaP/Bv1peca9VR5noc0Cec1D68G2kiSSFwFkQdiWqPQbudefYr+nevH6F3imTgkboaPlbSncvnGayfWX6D7TyKtt0HGd2s4YHOeBJs0KziTc04g5PbjEwt2tYG1z0FVlynay3DWTqdc/bBPWnaIRqhCT7dYGbtdCv8z1fsBZG05zOXFZSTtEB6ChfZlUNPODO4y19+m+xEVreSnsrGCgzYCBGJr3a+ymzDAaoBW52nawOCLHx1l2Ys0xIMj2eBdp4zaWysZ4lxXGWglGRVvUHbxUsqjDAc4E8tt+0cPlmAdSB2zmEgSfVw1XinRWSz5C7rDRQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(36840700001)(46966006)(40470700004)(8676002)(82740400003)(40480700001)(70206006)(1076003)(36860700001)(81166007)(186003)(4326008)(70586007)(316002)(356005)(54906003)(6916009)(7696005)(2906002)(36756003)(86362001)(8936002)(41300700001)(6666004)(82310400005)(40460700003)(26005)(478600001)(2616005)(5660300002)(83380400001)(47076005)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 00:08:46.1031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ca704c-acfc-4210-4eb2-08da6f642ca2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3479
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

For example, if a page is migrated to GPU private memory and a RDMA fault
capable NIC tries to read the migrated page, without this patch it will
get an error. With this patch, the page will be migrated back to system
memory and the NIC will be able to read the data.

Cc: stable@vger.kernel.org
Fixes: 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reported-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

