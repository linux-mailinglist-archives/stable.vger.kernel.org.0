Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBB75A1DF5
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 03:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbiHZBIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 21:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbiHZBIo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 21:08:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A693C990E;
        Thu, 25 Aug 2022 18:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIBD362/Zb78OAtCxDtaG7LMRt1wrbK6GbtEnyDelUr3CzUDuEjM3mbELyvHykMArhWhb0l1XP1dRhXbc3VZswEp5c/GEveGo/ROrjXKsD+kDLRusA+BgxaN417sceZoaENpyq8uU5J/+8U0cCSpz1SlsuSvKhKhPK6cxaqnVvqhVUOHN8tOBiPgYaG7HeSe/2xuLjCj56KnQigAmPFU4WKVq+q4YKjUzCQVn7BoBVoBHSr7tzfu2e6NzupcdUSXBgk/hU/co9o3FXYCpFr+XyFJ9TDbwjMAjNy8kOY5K7EP+lTAxky0L+vGincIfLG3TI051Fxb2V2H0Kq5mjmuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+tsnzi8owMIdv397wQRjub9rX/SsgNUxtwmZwRQMFM=;
 b=nDDR9p2V1lfaLSJca8AtB0qX6K+CM8SAKRd4fn29GxSdzo/tnHG95jKyNDqtc0HE3ChU1QkUZlr+up5FvJVxEXt9MRt8ZggEB2IR9wURvPr9UtFf12Ip8hGgJfGMLVFW0hSuB6yV/HfBJZu8wK6E/wV3A35l+MzY6YrDhXFZa8tW4l2NZH/9LmJWd5HrynlAyu+Y6/p0Q6Tw1IMRybF+QZ9dgtEUzbZtwDCCid8i3Kh91qsAAETCOR3k7owkleXvsARbQbNXXAkxeiDcxtBtw/8ZSpdEWFaRXmqB8NNRjXur+uyaltZDgHD+mKClJfCmYRF/UctXrv/pSLSx3OhY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+tsnzi8owMIdv397wQRjub9rX/SsgNUxtwmZwRQMFM=;
 b=fTPqr0EiN8h9U/IYqmLXgl3OCTnLpz5/a1DEto2LHPPhdMKACMqNGSrujjAwCmz0mUuuj9kDWrmgwKBq3I/u5fpE1Cplpppe7c5BO9QUCmb+C/8fXjuN20G1DCZjNUY2TtO9oT0pyeHq2T4aBjq5f/W+H18g3HH0VgLAtyeEcrgFw2WJj2yr4WaVrtJeVysjdrByr3KuUEC3l7VVCgpXrh/IeutAv1vlVLaS9jHnMqR3RvT9i7YqL86dfHhOzHDPnZLhThBtdwfso57K6T9UBwug5K85Tjx10+O4Dg92mRWtyfpUVkMMB3i8766PzF8HOvqe26aV2TBLOXAgrmJIzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MW3PR12MB4393.namprd12.prod.outlook.com (2603:10b6:303:2c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 01:08:39 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Fri, 26 Aug 2022
 01:08:39 +0000
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local> <8735dkeyyg.fsf@nvdebian.thelocal>
 <YwgFRLn43+U/hxwt@xz-m1.local>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        Nadav Amit <nadav.amit@gmail.com>,
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
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Fri, 26 Aug 2022 11:02:58 +1000
In-reply-to: <YwgFRLn43+U/hxwt@xz-m1.local>
Message-ID: <8735dj7qwb.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a52f51e-0914-43d6-da85-08da86ff82b2
X-MS-TrafficTypeDiagnostic: MW3PR12MB4393:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMFmQdbeXKq7H2FUDnKOyI1N0hfcog6srvkVeim7SqCMUp428WyMeIu35DpGGMYI/iJX5/nUc+/9Icg4ba+sG8Zg0Cfbl75mdE4Da4e/CPTsJx0cMA+9kDOp04uOptxUuxLTBVaPlx8W7WQCmrnZcN/Hny7qAnqpz3+JWJHSQqbbYMQ+1tpP2VzbydTwM/QFj9Nz/kWLZJvPKvYt+YbiuDWpdKBaqbTlVvFfrhIhlzJAq0GFR5IBrf7GYTQXSY4s79Um7sg7sYD/bdWGoOTYWIO3Z4+6m4gzRiS2DE1t6GyQLeLqB7S4FHLdpNDzwY/uYr8OsqFG/z0HnDtmM2jTutjFPC/sKRdzFjpDffAwnDGJrvy1bDuiDPD+RNjBfhlWrwqU2HsdriVn7X31Z/AoFqu0mt46h5cLEnqcYEcV/x3cTNWKZE3szabmR8pnEvrZ4lGEafia49YwccHemsHKqVl0ioaLL52Mx54W4yRA721SpwPioFm9GmtiNYG30qGCGyWrhQV3MVeYoF9s8UjP/PrQ1Q/TgwcRTyylqLII58dESkQMQu7WkQZcjejAl1teWwJGWQNvLN3nPXOTOlwmfHXJ4tHNtSnMEcU8NP0/Fd3byxX8FCm7gqxSbwAP9Q6XoMDbWNl27QgGeqsk+JwTLE9EO5ItAsKTVysj8aqYc5UXOZWPIPZLOapu06OnpmRoC/0A7l8rYT0S08N0V2Mu23/Ok2Vb7rznwFC1JlukPUTgWXZ4ucaTeku8GJcRxtEX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(41300700001)(66556008)(66476007)(66946007)(38100700002)(86362001)(4326008)(8676002)(26005)(6512007)(83380400001)(5660300002)(9686003)(6486002)(478600001)(6506007)(316002)(6666004)(6916009)(54906003)(2906002)(7416002)(186003)(8936002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BniX23DdU3sPpsptGJ7+j3q5K/CAZ9Su+99jHA9eF9OfvcTRWrZd/88dzrOC?=
 =?us-ascii?Q?pPb2moDLtzyRoC+xiXJXzuY3z+j02UUpbdIMUmTIKvlYml/lUNiSjDTWVpj2?=
 =?us-ascii?Q?zvSrRFadlUm7yCC1xL6Y76Xdo4hwnSdBUhl/lWRaHk99QAekn+Y5xhkRwrHw?=
 =?us-ascii?Q?C8J1036+5B05sqsPFYGgwrp8iHX9MS/Gwrb8USyHU33CFjG7plfk6fjaWmNs?=
 =?us-ascii?Q?DkDpmsjpjnby10iQzznFJHYfGggow700+UhtS0vSPbF+9WFwUE7uGY/yS9NH?=
 =?us-ascii?Q?lI2WwqsmnufTM4wAdq/T8G3HPOJMi0hBwBIR2StWzIrU+9VeHlKdrO3hgRWA?=
 =?us-ascii?Q?l8y0ziLIQEpeeoEpb39eYlGSzXrORBHWg+ppC0I5vO6DkPqYaOldGst65p6Y?=
 =?us-ascii?Q?tcCLKmZCeo4in+bnXOVE0E35PG+x+UFEiXX6fn8vfL5yKVnoWsaNwtFmAXtd?=
 =?us-ascii?Q?xoT+IakdetZ7ytZVYAhU7K0HslCPgM5A8EFZyY0PvNlhCjAf5DmZs2m0Nk1J?=
 =?us-ascii?Q?q2HmBuA/OBgekb4M65lEdaQJX/v3crv8UzX2C+4dA/QJAeRDNz+Ru6SAE53A?=
 =?us-ascii?Q?MSXMx78y6DmodltvYKu8ZN5HFz7DyaPrPfDqjJjHkOO/t/AyizRdK186/Z5q?=
 =?us-ascii?Q?bgN29eM/HAZNE4bpmzAUie5q1BHGmaV9LYWtM/hmpLOQDyRRsCuEcNfDdyRJ?=
 =?us-ascii?Q?ho2ISe62b6WVtrH0WGwHZpsbVFXmQZEIxmQ6lAlPHGpaHl0X4cKFSy0ARsko?=
 =?us-ascii?Q?xrRvF7o55DYxnp9ga7VANfxHVcc7shfs5ZQv0A7v7mU4422x/RxEqxMPKp2z?=
 =?us-ascii?Q?6BYxupV7eG+HfigszTS/iRdd2DZTOc9pZlomGyXv8HJODtZNsNtk2/aM16+B?=
 =?us-ascii?Q?jeVIF/nk1fJpKy7ugyC30p6GOONVDr4RFteE6nQO5E/e4L9qTbUUJTtkluoA?=
 =?us-ascii?Q?w8rUpS9cGtapKzhWjhUSCrsmbS+XkP8MwJDVwTq67j9RVuU9rokZ7g8rvai1?=
 =?us-ascii?Q?ozpMN0DDhha+ZbUQAoKeCi+zAI4Spdo0wV+yrN6STQJhuc80kUQGbCwCZIzx?=
 =?us-ascii?Q?/prRLzl2m9rAy3Hk3TmyL0t7ZlHOqRaPgTumrD9f1YlScdqQeYD7dO7X4hfj?=
 =?us-ascii?Q?6JkkvkK0rIx6EITaOU6efyoto98tXIS6gC2GWl6hwmdV9h7Di6uAaYCkNCn2?=
 =?us-ascii?Q?3loX1r9NLOkAnKvyhGWO6PZQiMDytP/qzOA3ItfNl9jNEX5vo6s0RgKdoTen?=
 =?us-ascii?Q?oys9vtFmWWGyVPnYwKtqhVMcw1Ab0edA8vDmDjfxkjgufgpaN4qBSApwEsn9?=
 =?us-ascii?Q?k25LB5e7S1DDTeYWAG7iqK64KqwUZK+QFBGus4q34P+d7Un2m8HaZd00SyrX?=
 =?us-ascii?Q?AzD9crJ5KjARtTQnthkpVYrQSAkIOV0UtcejlDQBLzFkLa6faKsa2fp3ONCT?=
 =?us-ascii?Q?+vLR4RHHk7zFR54fOFYwNQqC2Z48tWHTsQwKH8mBYtlOs1XOkObyNspud7fM?=
 =?us-ascii?Q?f+8eyF2oVfkKJQRK6O3MZder2dbMapvDHUY6BFqm0QH2nqF2lTtCi1eg1tSp?=
 =?us-ascii?Q?db244kL/pdu0u8o64QKSETp7d48YnjERWV7Yo/sY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a52f51e-0914-43d6-da85-08da86ff82b2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 01:08:39.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EtD2xPZGUpWGkAhStvutdlQA1ogSenEuh0r+PAx0wsxhyy8pOGNca05Ywjt2qeQ8qNuqfsxtDDLGbIrYlJaq8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4393
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter Xu <peterx@redhat.com> writes:

> On Fri, Aug 26, 2022 at 08:21:44AM +1000, Alistair Popple wrote:
>>
>> Peter Xu <peterx@redhat.com> writes:
>>
>> > On Wed, Aug 24, 2022 at 01:03:38PM +1000, Alistair Popple wrote:
>> >> migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
>> >> installs migration entries directly if it can lock the migrating page.
>> >> When removing a dirty pte the dirty bit is supposed to be carried over
>> >> to the underlying page to prevent it being lost.
>> >>
>> >> Currently migrate_vma_*() can only be used for private anonymous
>> >> mappings. That means loss of the dirty bit usually doesn't result in
>> >> data loss because these pages are typically not file-backed. However
>> >> pages may be backed by swap storage which can result in data loss if an
>> >> attempt is made to migrate a dirty page that doesn't yet have the
>> >> PageDirty flag set.
>> >>
>> >> In this case migration will fail due to unexpected references but the
>> >> dirty pte bit will be lost. If the page is subsequently reclaimed data
>> >> won't be written back to swap storage as it is considered uptodate,
>> >> resulting in data loss if the page is subsequently accessed.
>> >>
>> >> Prevent this by copying the dirty bit to the page when removing the pte
>> >> to match what try_to_migrate_one() does.
>> >>
>> >> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> >> Acked-by: Peter Xu <peterx@redhat.com>
>> >> Reported-by: Huang Ying <ying.huang@intel.com>
>> >> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
>> >> Cc: stable@vger.kernel.org
>> >>
>> >> ---
>> >>
>> >> Changes for v3:
>> >>
>> >>  - Defer TLB flushing
>> >>  - Split a TLB flushing fix into a separate change.
>> >>
>> >> Changes for v2:
>> >>
>> >>  - Fixed up Reported-by tag.
>> >>  - Added Peter's Acked-by.
>> >>  - Atomically read and clear the pte to prevent the dirty bit getting
>> >>    set after reading it.
>> >>  - Added fixes tag
>> >> ---
>> >>  mm/migrate_device.c |  9 +++++++--
>> >>  1 file changed, 7 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> >> index 6a5ef9f..51d9afa 100644
>> >> --- a/mm/migrate_device.c
>> >> +++ b/mm/migrate_device.c
>> >> @@ -7,6 +7,7 @@
>> >>  #include <linux/export.h>
>> >>  #include <linux/memremap.h>
>> >>  #include <linux/migrate.h>
>> >> +#include <linux/mm.h>
>> >>  #include <linux/mm_inline.h>
>> >>  #include <linux/mmu_notifier.h>
>> >>  #include <linux/oom.h>
>> >> @@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>> >>  			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
>> >>  			if (anon_exclusive) {
>> >>  				flush_cache_page(vma, addr, pte_pfn(*ptep));
>> >> -				ptep_clear_flush(vma, addr, ptep);
>> >> +				pte = ptep_clear_flush(vma, addr, ptep);
>> >>
>> >>  				if (page_try_share_anon_rmap(page)) {
>> >>  					set_pte_at(mm, addr, ptep, pte);
>> >> @@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>> >>  					goto next;
>> >>  				}
>> >>  			} else {
>> >> -				ptep_get_and_clear(mm, addr, ptep);
>> >> +				pte = ptep_get_and_clear(mm, addr, ptep);
>> >>  			}
>> >
>> > I remember that in v2 both flush_cache_page() and ptep_get_and_clear() are
>> > moved above the condition check so they're called unconditionally.  Could
>> > you explain the rational on why it's changed back (since I think v2 was the
>> > correct approach)?
>>
>> Mainly because I agree with your original comments, that it would be
>> better to keep the batching of TLB flushing if possible. After the
>> discussion I don't think there is any issues with HW pte dirty bits
>> here. There are already other cases where HW needs to get that right
>> anyway (eg. zap_pte_range).
>
> Yes tlb batching was kept, thanks for doing that way.  Though if only apply
> patch 1 we'll have both ptep_clear_flush() and batched flush which seems to
> be redundant.
>
>>
>> > The other question is if we want to split the patch, would it be better to
>> > move the tlb changes to patch 1, and leave the dirty bit fix in patch 2?
>>
>> Isn't that already the case? Patch 1 moves the TLB flush before the PTL
>> as suggested, patch 2 atomically copies the dirty bit without changing
>> any TLB flushing.
>
> IMHO it's cleaner to have patch 1 fix batch flush, replace
> ptep_clear_flush() with ptep_get_and_clear() and update pte properly.

Which ptep_clear_flush() are you referring to? This one?

			if (anon_exclusive) {
				flush_cache_page(vma, addr, pte_pfn(*ptep));
				ptep_clear_flush(vma, addr, ptep);

My understanding is that we need to do a flush for anon_exclusive.

> No strong opinions on the layout, but I still think we should drop the
> redundant ptep_clear_flush() above, meanwhile add the flush_cache_page()
> properly for !exclusive case too.

Good point, we need flush_cache_page() for !exclusive. Will add.

> Thanks,
