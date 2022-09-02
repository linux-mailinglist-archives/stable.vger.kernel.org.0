Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3005AA480
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 02:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiIBAgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 20:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbiIBAgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 20:36:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2589956BBA;
        Thu,  1 Sep 2022 17:36:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPjy/YOSM4krJjxO3w1/EglK30Cq/Ngf51FwvzNnWoiyE2T3DGXnMgmOsqVaq3W2w+YpEIXBev0bjvDW052PqBklXzTzyusKNNL9oHzUSOJzHApktO4sd2j7PLYeXt4F2pv+5F6NuYKpLF2oq4oMAeT94mN9RyZIYhOpiK4XIvgsRHWjYlrL2B3nkJsZVM1pM/oPgF0lLz0heHnSNNFC4KqYiXbQrHYtRB5ECQtDLhjRe1lJR81Wt+1GZnp5DoicB/yCvzHkpvbxBs23WCZef0Q15qriX09s2ZcKJ5g0L+dErziU1n0F7Sc5/TC2Oj4EteIepT5KHk7tIEALyG2KJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBq7JTG8UcLfh2/v7e/GA0COLHpr5d4BKHxKbsKdJWY=;
 b=NEladrlR2qzjwcHS/WlO3VQXyAeVFLGM8BGZYq/MHKN6bG+xvwAlMnQ0tvPp8da1lQKib0d4BAWXd6j4AtlqWb5YN1C58RfVP73lVAgF8xCkXiAY4fw8+nhgHqNd+oCB9FhoBBdI6CHH6nI9KUhdKT8PH0QKfgRBpcwm8HperzqmSQF4tvRhNvsGr0SaOJHZYcyK99SgLlUFitBs05X4BmcEE1FK6ZJrz1cpkIh6Lc65CL/7N5pSYee2jHIirB5NGd0ofBuFuvjShYQaehcW9euKTkGCdRvJp3MfwVSGUOEgwRppfjznvpufUEDDI870B5rp5BpUGJuavAzHnemVbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBq7JTG8UcLfh2/v7e/GA0COLHpr5d4BKHxKbsKdJWY=;
 b=mDDhRsyAv5BeFKpCGuvg1hSydXNrVviq1v9hovieaAney46FD/ZHPOHc5XHtxags7FgnH1Ouaqhdbipw0ZwQpKgoUOVJBVe1UbFKJ+0sBFMKKImULJpKMmRlnB1Lb46BfuGBpggWM+vD/fn7nLa8ttmh8cHpaEtigHXEcpspyoNuRwgmZzJGPLn4dnkXJ6p3wBWpEkLRGcHnEX0GIunH1nbqNgQS+wKZXVeJXM4tmOhaft9ApEHElQOKNtH0Z6cgENkDLSWr/9wpwqL5f9e1TODS3cI5FZfIEN9MiKAywpmxQg0fIUgHe6CA1du9qz52BK21J47FEmVQBcmvXr0yMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 00:36:28 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 00:36:28 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Alistair Popple <apopple@nvidia.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: [PATCH v4 2/4] mm/migrate_device.c: Add missing flush_cache_page()
Date:   Fri,  2 Sep 2022 10:35:52 +1000
Message-Id: <5676f30436ab71d1a587ac73f835ed8bd2113ff5.1662078528.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
References: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::23) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 490f612b-ec56-46fc-cd5d-08da8c7b2c6b
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svMKKubL4qq1pI5f17ewmn6YTLoyd/xR4UXUuo3MIs8fpU00cQi8E0RaUtX2sMpEd3vTXmi6vXVaCtKlCCfuL2Oh1amT4CAvhoFE0X/yxnsuqjB+cqefS3Tb9dFhnWYYEfwdCmhvrYY67295nSv1DyaMUKX7Iq398/KZhrCIlYt4fU5dHLozLzvAgOhEwk8/UqYOs7cK+sV5EhC13hjula0AYlGe4slBIWganW4dFZtz3rG4bpOLaMic/RXuKfDgvstteOU/tm1XXqLGqXaJ2VRU6BHPRQ+symCSG9Ti7Z81B88sCGxW1sbBYLxZ69mE9WRN7GGIPAs5nMSGqtpFZgiSDzvOMM1e1wbd8mJXAcss1YNM7FiOEa8MpweJbuaoBgnWUDH3OwfJy7iSoJPdUvybi701LkLkFUkEcnsBaZ0fLSdl8efOPahQPIp+KWpjW9wxjZqSeUZSxXNL4kCsmekX95sJvzBwh4yr4LIuqelkqnXpZblggorOlgmxNODbebpMqgyKdgODW2G7r3AXEjoPQ8pkmkkLmdw97pSZ6ExMfY/ksCktiYF/HtDUMmyC8dF7UjNbQYzKtVW0Y6p4OP/LWF2aoS+LHRxwRsQLtznEXb4Ks2pLfdCbJg7jR/gfKjsA3ekQivG7WP4Mug8+qdWkTRHdUMOQXk5TG8ZuqoaBDdE2ZvEDugAulgj5A12bHutxORaGYhk1EZ0MpzKfVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(83380400001)(38100700002)(66556008)(66946007)(66476007)(8676002)(4326008)(54906003)(316002)(2906002)(7416002)(4744005)(8936002)(5660300002)(6506007)(6512007)(26005)(186003)(2616005)(478600001)(41300700001)(6666004)(6486002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?236XCLhMfKzBKE+M4Vk88cHmtZs7H9OBEE6zxBZwSRUm9hX5ZwXnoUvoDMf4?=
 =?us-ascii?Q?sQHeig5A0d3D1zRbs5oow52t56gLkkMG9Tn0P8vAU+SdY5vOrZSYuvDftCjQ?=
 =?us-ascii?Q?YWAzIzkF48a7k9n4wGemZsMeCT080tVQ9rO60nu75+BPuFtPzBTx3L1Wwgbh?=
 =?us-ascii?Q?DCAmwiGSnvjZFjctlrxqsf92kFooAJ5if3638gDP8C4yQyjueB4S9MWEaO7o?=
 =?us-ascii?Q?lmWTaRshCQ1Sh5MjOdO/0qCoR+wObVsIE7Fs4pB+rCeqLMRIQMjTgOHF2HQW?=
 =?us-ascii?Q?h9Ep+ztBcLvkytS7ABwVjSOY7PUtQhjf2Rme0xuLXfSGWiEUpJyFqx5Oanqi?=
 =?us-ascii?Q?Cs8BDIOnx2oHt5OR4CzAZv1Fz6gGp8ApCW77WA5j5Zv+lSjsYuOgkQYAf0sl?=
 =?us-ascii?Q?SbajbxYLefG9ZeSg2YZ3QKg3B8r0p8A8qpctdufr1ewqPpoZ74GYLnrWlIX3?=
 =?us-ascii?Q?ZOhmuBm7YS3Q8T887Cdcca3AixrL5/FyllVQ+545vx4vgldbDW3EAzOOa2aJ?=
 =?us-ascii?Q?gd/0JiTZKO8A7OTtdPpFB2VbsyBm2/ZYrgCSTAz87J1s/vI/TwfBJy3TxZJB?=
 =?us-ascii?Q?gLcIxQBZRGYNXG0IJ3yTG4iqNQPKVKJtWDs4KE9O7h+IsUK9Lto+sO5tuhvW?=
 =?us-ascii?Q?rp9HA6B2aw/WduPJGLtRtNBoR2iFPcgpUiT9qwqcum/cNmSJ05MOVCUjLwvx?=
 =?us-ascii?Q?L7ivI/nJF/ezyGs17uPJtUN6IsF+obT5wOtLxVzyNxIGyU9pCy3caNKr0AzF?=
 =?us-ascii?Q?gMDVn3k06GivZm5i4d/tAmgnqzEMuuMVFwWVc+kbuPqQOYKPZvxXMdL5gXF5?=
 =?us-ascii?Q?zTKP2VkBhwS/xYm3qGBWzu/jLYvQ2kCg6HydexVTqGlhXrUE5kKmJRE9npQq?=
 =?us-ascii?Q?0N/wKoEKpimKFSCfm0uXM14bJAydi0qYHjAfmb1w5RdhKZ6Y3voyscbbzbq7?=
 =?us-ascii?Q?3fylpiinMuDkVo8CJMcsnBXYTbzhTCSzKjZpcUbQydDztbsgLzJ1ktlLQTck?=
 =?us-ascii?Q?k2HUoXsK7KxFCG3vFaoMX9Ixbisq9zBEla0sZLjsxB/o5yRta6QeN8ZTXMB6?=
 =?us-ascii?Q?xB/SWgkwTTFQ4vqsnjareu8bqRG0d1RNYVd1g1qT9TCY+rZdulLrV6IkBMkP?=
 =?us-ascii?Q?uejXGNZr5WM3Dp56iIQIrJRhEmEcUfVBl6vz6MIlbi6CXIi417WVo0I8MBTK?=
 =?us-ascii?Q?lDT/uVzYIrkLWZ/gLrE9M5270HDwnJW4J5P9eZPnfV5jZOUbepaQkzHfJdW7?=
 =?us-ascii?Q?kQWuuJPucYxjgxo+N9ehI8sez6YojKuazHImnPHVj67zm0Hpmdk0KdN4nrwI?=
 =?us-ascii?Q?LKeUr7UfNZ6f2p4szDQKNUIvxZrHqdJ9GcZHI9fNx2+aqNqOxyIRGqdV9FJK?=
 =?us-ascii?Q?n4N4TSeDDYGsUsKRRhq+Psg5zsyj3kpv+w/hjH98ZrpweQPgbggkm0pimhzA?=
 =?us-ascii?Q?uoE7VsSyP9Ne3RWfz5tYUD6mOOxPsYPoNfSxn6hRuWGJJqn848URBjPagHzF?=
 =?us-ascii?Q?N4mBbOyQGR74djd88Q6weqNxQvvj+ylNPxFjCMffjdqtErMOe9s5wgWrdDh5?=
 =?us-ascii?Q?cQMVmmbpBhWGJ9Yue7w5gM8mONuoT+LRZqmru+/Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490f612b-ec56-46fc-cd5d-08da8c7b2c6b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 00:36:28.1881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPqO3ZNFmxVy8krYKt2oNJSeakaO/db5aSVpR7Qq6pW6b0mjEIjzZiDcUgcLZrdvkoaeveSLVsAIW3H72CXMwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5086
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently we only call flush_cache_page() for the anon_exclusive case,
however in both cases we clear the pte so should flush the cache.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Cc: stable@vger.kernel.org

---

New for v4
---
 mm/migrate_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 6a5ef9f..4cc849c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -193,9 +193,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
 				ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
-- 
git-series 0.9.1
