Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4085059561B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbiHPJYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiHPJYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:24:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290F5CE0;
        Tue, 16 Aug 2022 00:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbvwQRhRR2sYWcZSCas9exarK4xqZsQVMdtJhRIy9lPquDPTRWsqxhw7AoG9uYBWtWnfdqHuBS3KgGfNbpDIweqyaQCyRkVW3Z4Q4jvRjz5cJmHUOpzPC3KAapTbEUDRod+U0WLaTeaYAMqWp6TtPixIiC7yC0MH6PRCSIrKwiJNlHXTKqxYL03CHzbkWioz8y8ZROhTLHzWaG36gmPDe07snbxBE7V7LP+Bh9NikevzBUowY8D0SI2v/DK8VPkM5wEAdNnqeBbeZeFY1wdyyNO/18c6zmqWc0XWF3b7yE8RpVA5wsUfOHH9jpmJlJJJveRzsTyFybuspnIfolFpgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=waSfMD6qsphw2cX5HGkypazcjFvvcW4hCWPFSOkVK0s=;
 b=Xv/jg4N2TXxOIRllyBVn+vrEpJ921RU4+XO7olh+UFW6rhGWAZABGdolF7ocT3PX+FCJUbx35spI7o4dAmrShN7pM8cSKdvQQPHQ+w9sAq5brNJWw6QxHfkJUEoWBRYfr3IsKhbFhHrQEs2mgp5w6cVhS6LtRyVab73YdBsEN+wsK6VDBp038KuGAmhoRiukb7CMZTXjtQI3UApixL729r5eVW7/a96FVSQpf8W+kp40apdzQcviS4CdmILwwL+d/yFXIVdyZCtCvYTT7S1CXXq/ni+JYVBzynljKsVv9YznVmvTAkg+AJ5NpUS+sga1OzQqo83qaogcvWMzcBqgbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=waSfMD6qsphw2cX5HGkypazcjFvvcW4hCWPFSOkVK0s=;
 b=oDQvPvfdIi1EjLEfz69F657n3IXyy/KZthLotyAQoyfPuKOMnoJL+JHdNhR6zxqfJAZn/6TeEzXMwKMbaf/siR3iEVYI0FZJFxFmdzV9Ilnf1HR4ztNLpemkhYVjCz+27gszlhBV3FUqritOAvvMxJ7A5A3R3XEBg5+xNH5/G+7lQXLPc8VyD/Kbyo5jMftA6cG+ewpPgwPKwFybE5vM+30dLg92V/wOlm5+EBVl/D1K7bcLzNikUeKn14XxPqTxXdybx8puE7IUW3psV8/ZG5nAvQUTb9BsofYWoYSxSLMtu5esESyv7By9b+jBaYyOHRKO9UlvQyZFRmNwmKsAqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BL0PR12MB4722.namprd12.prod.outlook.com (2603:10b6:208:8c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Tue, 16 Aug
 2022 07:39:48 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7%5]) with mapi id 15.20.5504.027; Tue, 16 Aug 2022
 07:39:48 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
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
        Alistair Popple <apopple@nvidia.com>,
        Peter Xu <peterx@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Tue, 16 Aug 2022 17:39:24 +1000
Message-Id: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:a03:333::20) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07719a87-772e-44be-62f2-08da7f5a7ef5
X-MS-TrafficTypeDiagnostic: BL0PR12MB4722:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Mtyg40FfAVXCx7GenpQt9aVwTc1TKFZrcE4wv7Fz0NMVMk+KfJg5U9biPtCON4eP82gbizmUlbfIES3JoXkFzfi53nKfVfraGZwQH5ufe3NtEhz66BoxIVG0kHigrUAqo26v5MF+EWMNviFgCpp/BYrMbHitwS2ddZfD/EfKYKQCMZ46IOZtBRVejGOJMpqqpspDluUf8ik5q/xPWlBdHyK16gC+ebHziW41vieHj1XXODLCR3CH0VMTXSxD7tlPiO4C80L4xdtV/I1Fy2wRrP3Ne2jVRG2PbUubQrTUYEGbE5WaHKQXmJpuF081DEtUvHBPU9u+jE4uL1zd6zL/A97sJCz+vjcV62W1HFbyDiHtpfOuEz9wyiTSq96nmaURJYPPBe6B3ula5a0+rdxTCN2fCb9dZJgyQROP5qbam1qAcCQGhYkg459MwS4Z2CT9kgTP1OB/3MnB5dNjBPO07EsbwDdnxYJL/vqCSgxTmgZtzqt7fiVE1i6Esx32gLReNS8nRRvV3B41Rlq+Myk8iT7E5mJLS7l9iHjKzHCBp6kv0WqIOfOhUJMe3VjYrSZRUWezBpAFDDHmFB+7tBHK8NKJQ+fS1FcxDM8gKPhiYHbdJNf7Cc4xDWxAyjlQtdeuG9/4xFGBvg8Tx3CqPUm7cIJP2Aak0L3CbcbJtAgbD1kjYt/MlUWuBw8fd5po5e/QpIFuZvR5b/TnmXM/Io3YvShf9K4n3BeVluvjCTgBltCS8YKeQeAwSQyq1RTfI4Y5djBxF3v9u9S00Aui3EJrmKmgmXdZrCbC2LtRLDcDw4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(186003)(38100700002)(2616005)(5660300002)(8936002)(7416002)(66946007)(4326008)(6486002)(8676002)(66476007)(66556008)(478600001)(83380400001)(6512007)(6666004)(26005)(2906002)(41300700001)(316002)(86362001)(54906003)(6506007)(36756003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OGVN7n2W7iglX1nV+3XwRdGtzWRvPJka5/0RqqiPqZVYBRdY+V+oye897wb/?=
 =?us-ascii?Q?USzHM4U8WpZlIojJAl5g2bsNbJ5MjwusO730aoQxVo14rBqdD9kGTZ3DMeb4?=
 =?us-ascii?Q?PxenRvtpe3zXgpCWt5sK6flHp6ifFkYb0wfpF4MjB1xqUbWtPBIUSTCmR75Y?=
 =?us-ascii?Q?xOYvC4/fOJ++vjB2mCycp0kpr9PgaEsz7VKKEORAIBz6XpvrCQewbojGPNto?=
 =?us-ascii?Q?CZjl2B7bXBxP45/E2Mx8Q0zBc8VU9XeSRwW23ZvKeKtJolhx5zEOcLOqaMlz?=
 =?us-ascii?Q?QeOKmWOdtGbRE4xjUzgfvkZxwlJfLR53LXOiKxi3b90xPVg3eQ+D4GfABg+l?=
 =?us-ascii?Q?71kUkM7J5PUkuQTeHcU7plOOsQcE9fTdtCoGlsabZNlF9fovYr4RpPmPaqYT?=
 =?us-ascii?Q?AHi3A5FYWoesB7LUiriqgh4I7+0Yejt7rpMhc2tpF4cBt3P4gSGh/u46ZtoK?=
 =?us-ascii?Q?jOTzkm/76vMed/uQ0zQLju2w23G/OO5ruAEwsaazLyPMAD/Iub9iTTBjUVIV?=
 =?us-ascii?Q?ZtMI/WcMZXWt8FpCCdrBUuht2VLbEu9qRLkVnvlFBKdT6/cVQc2RTXrvhVCz?=
 =?us-ascii?Q?W1oL12tYNTon7H4Jsg/D2jTexX2RClzesT53R7uyu1LmGcuWeCLIPfPdO6hU?=
 =?us-ascii?Q?bVBfBgZRMHJTm0UxKovWjn+ISLf4wJnwfke+u47f4nJaD32tZiF9ELIZjixY?=
 =?us-ascii?Q?xnJUb/RWJ3FPfXq9pf8K3AtRu8s03Mztd4H8mWVHboEZTUwumfU5oo6Sg+Ks?=
 =?us-ascii?Q?sn+q8sxXz1tZtzLKPfEOHK+vII1VcEreAF0Kxv3p5LoK1a2IebATRGHm02nA?=
 =?us-ascii?Q?TIAJIvZZo2UWQaT3Nz3SBa6T1cL4r821D550xvoP/d3S+9R1i7ZWA++4GGvC?=
 =?us-ascii?Q?EL6lcfGzVsUp49sxyIGWsYj5q26QszrJlCvQGmn0jZ7e/rb5rNakZ0yv0U53?=
 =?us-ascii?Q?wx/a2bQ4ApaJ0fQDcgBHv2d35QxcPg4z7ZOuWX4fiJsUN+K4AIiN4IP4yvMR?=
 =?us-ascii?Q?pmFxLU3+nWoXChgilDaEzMhO3xbm2lLJAifC0Xv78e+ubCWzLYr2lqP36jCj?=
 =?us-ascii?Q?XQ4EGA5KFh6kmGFFnDtf5yrnmoXZRrEWkP3i0CCzmqrErWQCNng1iOdj4i2U?=
 =?us-ascii?Q?i5nGmJoAyqW6kx1rsXsZLc3qrBYvOlwZlLI1KuJHICt5JzcbAeSwMqz2lbcr?=
 =?us-ascii?Q?uUz15yZy1EDaeSqseqa4d+C4+Ic48bHwPDlULEbvZulgzNN7CXAZ/hhIao6n?=
 =?us-ascii?Q?cY3foIg/xOUzySKSzeBpWpX78xCxTr6XD91ZNOn3NBxWAqtHA4dUQ2B8ygPn?=
 =?us-ascii?Q?i237yiCoNrVb6lZ0OXWgpMSTKr2IIPl2/nvifpas3I2KC3KSsW9pah3UX7ev?=
 =?us-ascii?Q?yiqbeiVznnBowYzl78POt3umtnDhkfvgsuXCZNVMBRhl3rN2ea43mVZzqgXr?=
 =?us-ascii?Q?yxvIO5fHCdYLCbL+E1Z54j4vv8x3r4jpjz2QqdCg9SzKyDqfMRRwztKQOH6x?=
 =?us-ascii?Q?/RQylKxUCtkKKUBLKVC8r2mH8XmI8SENV0VFOD86cME3u3jwrWRWo+w4OHe0?=
 =?us-ascii?Q?E9Od7FnFxvj5gyoh0mj2EAa8+QosKdBhfM8mhuRl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07719a87-772e-44be-62f2-08da7f5a7ef5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 07:39:48.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PiK60TEN8R6uB4XT1pHCuAfm+yhtMaEB4ASHtIH6sbvQsQ35AoIq6dYWyIH4BxZdyMUBgXWKZhx9T9v2sHwOrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4722
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
installs migration entries directly if it can lock the migrating page.
When removing a dirty pte the dirty bit is supposed to be carried over
to the underlying page to prevent it being lost.

Currently migrate_vma_*() can only be used for private anonymous
mappings. That means loss of the dirty bit usually doesn't result in
data loss because these pages are typically not file-backed. However
pages may be backed by swap storage which can result in data loss if an
attempt is made to migrate a dirty page that doesn't yet have the
PageDirty flag set.

In this case migration will fail due to unexpected references but the
dirty pte bit will be lost. If the page is subsequently reclaimed data
won't be written back to swap storage as it is considered uptodate,
resulting in data loss if the page is subsequently accessed.

Prevent this by copying the dirty bit to the page when removing the pte
to match what try_to_migrate_one() does.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Peter Xu <peterx@redhat.com>
Reported-by: Huang Ying <ying.huang@intel.com>
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Cc: stable@vger.kernel.org

---

Changes for v2:

 - Fixed up Reported-by tag.
 - Added Peter's Acked-by.
 - Atomically read and clear the pte to prevent the dirty bit getting
   set after reading it.
 - Added fixes tag
---
 mm/migrate_device.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 27fb37d..e2d09e5 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -7,6 +7,7 @@
 #include <linux/export.h>
 #include <linux/memremap.h>
 #include <linux/migrate.h>
+#include <linux/mm.h>
 #include <linux/mm_inline.h>
 #include <linux/mmu_notifier.h>
 #include <linux/oom.h>
@@ -61,7 +62,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	struct migrate_vma *migrate = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
+	unsigned long addr = start;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
@@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			bool anon_exclusive;
 			pte_t swp_pte;
 
+			flush_cache_page(vma, addr, pte_pfn(*ptep));
+			pte = ptep_clear_flush(vma, addr, ptep);
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				flush_cache_page(vma, addr, pte_pfn(*ptep));
-				ptep_clear_flush(vma, addr, ptep);
-
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
 					unlock_page(page);
@@ -205,12 +205,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					mpfn = 0;
 					goto next;
 				}
-			} else {
-				ptep_get_and_clear(mm, addr, ptep);
 			}
 
 			migrate->cpages++;
 
+			/* Set the dirty flag on the folio now the pte is gone. */
+			if (pte_dirty(pte))
+				folio_mark_dirty(page_folio(page));
+
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
 				entry = make_writable_migration_entry(
@@ -242,9 +244,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			 */
 			page_remove_rmap(page, vma, false);
 			put_page(page);
-
-			if (pte_present(pte))
-				unmapped++;
 		} else {
 			put_page(page);
 			mpfn = 0;
@@ -257,10 +256,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(ptep - 1, ptl);
 
-	/* Only flush the TLB if we actually modified any entries */
-	if (unmapped)
-		flush_tlb_range(walk->vma, start, end);
-
 	return 0;
 }
 

base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
-- 
git-series 0.9.1
