Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0BE5AA484
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 02:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiIBAgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 20:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiIBAgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 20:36:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C605458089;
        Thu,  1 Sep 2022 17:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyRNPuo8BsJxh3UwMs9ULm0BsFDlOM2TYFOWHMSsw5NwNPY0IMRhCLZp7OV98Cgcf3Sb90do8k+FtEKWE+t7/jMwpIE5Afk5oP4N8RcVSRw/2uNdSIvooYpjZYdk4nPzIcdpKQ1o0XFKEmlm0ObHFDMyUyGc5MRHMbYAMvk/22fr0zfs+iVdfA2KY6zvAgLT3f659Wk5djMJY53LHuw/JGDZOYq9mrvDeUN/IjSJrMevudGvS5MJa5w5MHtQ8oQr4pfEX1Y2hCLou5/lNOyYbWMXEWA8hzFD1SGci2nNbB/u5WomX4ovt9qblkx59usvgeR6nLmBesdv0tdLuph+ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwIh+pOb9F/V8uLUX51TWSv/dWZCwxq39gA4eUPAYA8=;
 b=Nf/boYf/2hlUhJv1TvkLWTUBZD0fLK2zv49JdnBIEKFqEAylr4j6iBVl+14TICvjmBDO+oGOEUMpP9W8L38AJGFK/+T6Ts3f8ZFrbVHbvi33CmvEf+J60pYqpgpVBHQvS3q0zDsw+pAc+qA5iRXst7iPDPGrZRntRv5LHnqMP8gXrdEV/ZqJKu+agOU5nA3M9OuWnv/oa1R8ORZhTkguXllQ/uOkew7DiwG1wicBdBCYHx4SOc04nKR2ZATkj5r6KA3s+1C7mIti8AWvR9A2JJ0i9RPX5a8MdZv+7LqxfeMedxEh4IVAlHW4kCdMpSHbUy9MdZpL3M0PW00kLGlbKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwIh+pOb9F/V8uLUX51TWSv/dWZCwxq39gA4eUPAYA8=;
 b=TrY5Mr8GXMp9HYqiKUyb4oycuSNS1NtfoLL0oGPOnTlg13FpnuzZjzu1b/nHLdGx73JU7KK2TR1GIlnLHgdX2y7y6LB9NE+AVbYZ7lGwb26dNHz3VfrD1OxSyS/tqqeTWTrNnap1buF8/iF49dcredTxi9j5h1j6cS84px6Wy3GbZq9f0zo/rDosthnVYk9pwfXLZ3dmiEcQKg0mVBiTxrlKZvcwMBjS2PttblH3ZxEGIrwrh0nMoIlTVBPbIHP12+oNOuPyx6v1b3HyW/mwVqZl8a9y8sSPTsOXHko5+2gkxVuU3Lpl3IzS+srrrUX0SY5Ps0ZEoj6Mm2JqhO0ytg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 00:36:31 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 00:36:31 +0000
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
        linuxppc-dev@lists.ozlabs.org,
        "Huang, Ying" <ying.huang@intel.com>, stable@vger.kernel.org
Subject: [PATCH v4 3/4] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Fri,  2 Sep 2022 10:35:53 +1000
Message-Id: <dd48e4882ce859c295c1a77612f66d198b0403f9.1662078528.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
References: <9f801e9d8d830408f2ca27821f606e09aa856899.1662078528.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::25) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcd364d0-3f4a-4cde-5cf9-08da8c7b2e6c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cfe6lMeUMqzm4nHn05cTv+vP4h9ov4y7IhKdGY3FSHyQmhLJU/tEHpGzwfloEykUMGTK0nP35QggRydqTfVxnGNZNt/2goZY68L1ZEi96i1tuFSmQQfyFdtmFYxUeA0z3fe+ZMIutH0HACEICG2J4Kvh0mykKvEFXqaAE1aLX5Hya/bJPi2BJ5UV132vnr14wCoNiws/dF4Ltqq9tcMx8fj5YR9O7lCCQ5KEfcx4ngbWyVq5e5xvbVOTNy0AQRJ0T1Ur6uRJEKHjsLBC0NL6DVq1qjd46OjOBkb74DI+LwCC71n1UVMQr9xz3KuZie4w4VXfMPOuGiV67rrQO2X8JWioQctUvPAPFUKqCMM/kqEDH+dgatN/lOmv5IfnLkpXoprLjcArEHlhHZzXdPH8gzSS5iAqP9zpZbMvLDNk9PBLAMJ4kB3KMMD6sQECsvHlXTASd5u6BiJ6KGWH6HtVl8EuWsgd2x7KWtxA0c6G2sRcZn8iJxRPL1gA2xcdGjBJVvxDvmk03NmFFMs28exDBxOytElfanyeqeSEERKrXyqEyBhwZJCLut+jVVhAdBbqtmcKO6xCzX1uDXcIAEC/uqskSNdCaUnLWgoDO1nOP3H5GP0lh9XWPDeDfxsNxDipEYSLuwpSRswnIE6y5ZHPgAV6Rb41ACKJFp9FYDmbaZD7RtZDiOj0XiY1iFFmJRXBQo0o0dw1iUgvXcKmSLHrmxEGotMDE9WJgjWXXGi/P9hLexKnSOG26cow6j6rXEOrMZPo7LemuhaQ7S32/hqiJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(83380400001)(38100700002)(66556008)(66946007)(66476007)(8676002)(4326008)(54906003)(316002)(2906002)(7416002)(8936002)(5660300002)(6506007)(6512007)(26005)(186003)(2616005)(478600001)(41300700001)(6666004)(6486002)(86362001)(36756003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MFnSiP0zUD6MrqST28fik/XxHwucyB1dUytDDNcKBt8SU5ZN+TenQEG64ONn?=
 =?us-ascii?Q?0EVb1jg4G0UNgWRnXjQ9sJd1wy87R3U/4cmwUqLOt1wnz036T00HgB/kzq8r?=
 =?us-ascii?Q?s9QYEVry5VGgZoCyv85Yqp4kbVnDhyvUWVmQbdArWmkeG2+hiaZrrMeQGWRr?=
 =?us-ascii?Q?E1TWzlwhNO/YYP7k0i48mBYH6EbTZ66gSBdb2h42FV2xpBzS2utvtX2VZLOJ?=
 =?us-ascii?Q?MQBXBhGRZzncwu2sTRLEol8OPQQiPon1GEABpu3WLdFEdNa3LkoQEFAvjuX+?=
 =?us-ascii?Q?upnbW/rj6L/sUhQfBXoPq8BEEwPGCoiUxyKqSv2/EPa459lId6hu+Vt8odH2?=
 =?us-ascii?Q?TVx/iMLjghkT2IHDjE9eIgOAK7aNb2E9U2LB94CJthdLQztVSwRAT5/2wXTO?=
 =?us-ascii?Q?Bh7KQfmAU9AOY0PDXtN7hBmXRQXMexiW0d4g3CdmkGUBJkXGHwVdIySC+HGC?=
 =?us-ascii?Q?HcNvqwndzfB9eL0hJ/v0e3MMU7sTW3Qg0Bpu3pGaB92P9NVZTNpSVVKN+KGM?=
 =?us-ascii?Q?+g7UGERXRmfRbyv8aSQ9POiWjVmEdPIBaKjElOSCOEtozS6/qJKUJtXnLrHi?=
 =?us-ascii?Q?MjKHb9ALNTqRbdk2eSf+vi0kxb5LuKGfGJgMZim0xiS6w1TDHqXeQErf+BG3?=
 =?us-ascii?Q?2hIs/azobiTwbXzxbaCHeMzIiMgbt0UdXT9hnzKJ/jeJwLX9iYXlDzCxv8Up?=
 =?us-ascii?Q?WkkJcKHTxsYOOtMVYwAwRmNQtbACHai0l6x4ix//M51lQKxgJCA48JwMBw82?=
 =?us-ascii?Q?MhS/nXV/rqYI+RcVEotXFD7XA1ISRNbrL748V6XuVJrGYO+P3Nu7zD4Y7OT8?=
 =?us-ascii?Q?osibTaP/Dh9M0uIMKIGWw2sf4VK4cXxeo8py67JJe2TRvDrVQ+o9/RAM6XZB?=
 =?us-ascii?Q?hEsXyLQfpC0h1XSFg+8YPeEFHttM7Q4muCwz5ECQDkk2O9gZTxnJLy3eBYPf?=
 =?us-ascii?Q?Osk7XEeRmc+RCl/iq0vQpjmu/oG2k1NOI1os6z5Cz9GD2usvc72pOt2ZvFY+?=
 =?us-ascii?Q?xL9HZTeyOXuj3Mx/wxxLZ1hI9iRuK//Hu6fIrzkfFZhwqLIDqbTWhHFhRGLj?=
 =?us-ascii?Q?Pto1F5kFPVv55c3ys4JkAdDt7yFX8lJsqYUn0t5Ko2akxCJ4aI/ITpkPIljq?=
 =?us-ascii?Q?Yybnj/tE+Ts5Fm6js2QWj5cDiVQuIk2oBlYSbfjZFVcDCuzd1VHD719UZp5h?=
 =?us-ascii?Q?KzVLU+7jYUrWoEM1s76GsuzQtydsTESLBn2vVnkaTSnn0S7u90aP0nfvpOWi?=
 =?us-ascii?Q?glyEZ3fL+ipdd+Ol0+lXEC6HTaUjR29SmfdkaNfnaqg0LQ2GeBNjpSM32Hqe?=
 =?us-ascii?Q?VNWaBTO7kyrphv9M7HD2lWwVHkrMP3tVYat4gkQbFGwsTuKJP9+7hV2Q/EFd?=
 =?us-ascii?Q?aRje8IwmxRyy/4bU8OB7Ru6wqZtSwHoep21xr5NCdh8Jaro1zyaXAqD1XDdI?=
 =?us-ascii?Q?lAoK3GOlciStn3sLHB1t6RQ//+wcwfBFdQ421UwtrtDGLCa92NyfRT65JY/P?=
 =?us-ascii?Q?J5LaH7OJunTFKZcWQOJYtiiTqR2r5afM/YpPZazeoGK8BzErSvfsIaIjrRI6?=
 =?us-ascii?Q?mOYRNhYDbJplpz7M6Ur7SdXBOT6/4DWji7vyCi11?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd364d0-3f4a-4cde-5cf9-08da8c7b2e6c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 00:36:31.6253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBV+rry+eVaQm7aVmbUrtq0rMRhX+Hsg2Bao59cCMzDoHEP50twrnE6DyZ/T35dJ9eOKoKLjnbwTvsbOmkN2Jw==
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
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: "Huang, Ying" <ying.huang@intel.com>
Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
Cc: stable@vger.kernel.org

---

Changes for v4:

 - Added Reviewed-by

Changes for v3:

 - Defer TLB flushing
 - Split a TLB flushing fix into a separate change.

Changes for v2:

 - Fixed up Reported-by tag.
 - Added Peter's Acked-by.
 - Atomically read and clear the pte to prevent the dirty bit getting
   set after reading it.
 - Added fixes tag
---
 mm/migrate_device.c |  9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 4cc849c..dbf6c7a 100644
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
@@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			flush_cache_page(vma, addr, pte_pfn(*ptep));
 			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
 			if (anon_exclusive) {
-				ptep_clear_flush(vma, addr, ptep);
+				pte = ptep_clear_flush(vma, addr, ptep);
 
 				if (page_try_share_anon_rmap(page)) {
 					set_pte_at(mm, addr, ptep, pte);
@@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					goto next;
 				}
 			} else {
-				ptep_get_and_clear(mm, addr, ptep);
+				pte = ptep_get_and_clear(mm, addr, ptep);
 			}
 
 			migrate->cpages++;
 
+			/* Set the dirty flag on the folio now the pte is gone. */
+			if (pte_dirty(pte))
+				folio_mark_dirty(page_folio(page));
+
 			/* Setup special migration page table entry */
 			if (mpfn & MIGRATE_PFN_WRITE)
 				entry = make_writable_migration_entry(
-- 
git-series 0.9.1
