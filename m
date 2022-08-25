Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA615A1C6E
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 00:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243479AbiHYWcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 18:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbiHYWcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 18:32:46 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E2CB99DA;
        Thu, 25 Aug 2022 15:32:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/uq88gTbDDROC4Kr3RrNQMSaJTA6kBZXsWxN0/pLp6lSX1v+S8K40Q1Q3F63jZUD7GF/TdGpDp/pgcq/+9MRvegmklJsr2Qsw1rK3HJyf+HOegaF108cCQnOVFjCB9MGjRWyr3mnMIA2v3xiLwW9/5asBnZTrzyGMccsiU3H5W+FvqJ3pCTRXwPlvfDqjPT15U2QIEv7KcW82DxOfp5k4hJmHbNizn9tqrTf7SGVJppnYgy10b8lWNQQaXriBWJrK1+hgXh3dmFnWJG/NVvH8diFxV28DMfoq2f2GbSm8wj5D4x9g/BjD2uUR79zKHULmaY5J54hXFr+/z/izjshg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ziMC0qCBgdNVn5q+E4uF89/5eUGzQr5+ydXPVJ805ew=;
 b=ecIv0GIO5Vcas3qAlWzrjb2T/zdB0JHsZEOndmT6YW6hgytFfYMC/WSY9PvcQw6ZgQnOptZtP4RpSG/o7xV/cwkj9Z84m5j6k6kfNQkY4agPNO5ub6LHGE6SFFJIcnOhwyoUfp1s7b10hVBZ3TF2decD5Y4UpbKU+redPRcPOyCjoaS4yNHbVKe6HudpUAU3grbJfjXjjWn4LEzR/pv77fBVnzTzyHbzqv9xPmlBKspUf7FkSZ/4xQr14iR2nxsEBKc9nxo9p6zFzDq8tqAlmrw38WQJs/Q0CiO471ePdJJZf/WMZzo51oeZ1oAbGsAxjKnmzazdZbhVKYxeO0KqmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziMC0qCBgdNVn5q+E4uF89/5eUGzQr5+ydXPVJ805ew=;
 b=NlK7RPc+GFQonHtML2thMQFpcbH4o3/JqaT4W3h5eSr9IeBb2XUlp1QNeK5MEJZnSZujxH9jKOD+3psN5cL58LOmpP07gWN1f9mBWL/teWKY1utJl+xatxnfJb0JpLxRQy49srh1lWmDLY8cUvyw8LjhMXXK2YA0FMJzfAd89VDeqBWliZEhxHjmwKAAvKzrGS7ltTkZfy+41TxdxKExUjZ253h7Ip2HSdGwQe57UMuvZjFcYr5wS+pHQZRZGlEzr/DApIL4Fn5DePdLKX0kVglTMR2p2zLVE7YieH4jp3MIhAIHOW3Z5wP05cZnSyI7SybLviubbfbPH316jC+D3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 25 Aug
 2022 22:32:43 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Thu, 25 Aug 2022
 22:32:42 +0000
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local>
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
Date:   Fri, 26 Aug 2022 08:21:44 +1000
In-reply-to: <YwZGHyYJiJ+CGLn2@xz-m1.local>
Message-ID: <8735dkeyyg.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::20) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f6800b6-7b04-4304-6c0d-08da86e9b987
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3bAfEkdX6FoiTUnFv6JVDg4x2ElBr0D6GpaYpfrFQBZl8fzkWJyeWvKzy3pIrGwsYJecjsi1lDbI0PTpk0y6pVQR9Wb/X+YwxCCYgFv4dc3JTz6QCqnTxo3p6czHuiQcQenHtMKSOZbRWkF20x5sfZb1PpB8gy68NWP3YfQ3lGFfdw9xkUDLUR7nKGq+yK+wHL53sA2XzGDw5IpcwU5KkDq6r/e2SYroZcFnCY/koxOjI0HSg+0c7zD64Abg7AZ4/I081Lm5gNpfU3cdpuy4ybE1u7LRcvYebYKlW5jBBG0AQzAFu0ZBMXWw9cikqdr8c7Fr0KGxN0tObIuX6olNwspJb233kmNh3VHu6+TUP88VfCGRT9U64pfBjhb11M/aVhDUD5wJHQUqWu8yr6k75TCZY+MJHgt43mBiG//+CV775OPRgZAqCovWTmDMbAoezfMLaeXwlsHv6fLEMREOpS/4L+1jVIbBQmbvTutniYs2STO3cs7gXyQDRtJ3w5YyeXBEUINeQCsKXtfXMeKfhE9HScoPpBBZGVmnaGxtcsfgIlPh4bvvAZjSlhdZFKNWaMwz6xGMcFQFvxQqBGPu2BM4GGpSvWHFonKRG25YxDbhjHY0Jz8EgZWjEoq/9QCh24s16dbaGxG1qwIUrCS6QRHpaR2FtSNsfvHddZ1KDHgKPqRJEkzxX9ZufVKQmr0Fn24vsduaIAwGLJcwtNdIpJLgK0REItzs7GaOQtu6MS5DUbVAFZPZbhJoEEe/qy1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(66946007)(2906002)(66556008)(5660300002)(7416002)(8936002)(4326008)(8676002)(9686003)(316002)(41300700001)(186003)(86362001)(54906003)(26005)(6512007)(6916009)(6486002)(83380400001)(38100700002)(66476007)(478600001)(6506007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0yy1SiHHLlkMwvsKFTCwuE15jRufQq+uqOdWBfsH/perbl4u0kEevjwZ75Rw?=
 =?us-ascii?Q?znyMv8jCOI+kMr3EH6RVEKBR0mUv2MVXJ+bqQKqcwl/6DGRERiLxc1LbVh/M?=
 =?us-ascii?Q?OsLfAJc+oiuke5Yti80dFroT7L4G+de0AhRXS7d5z9SCq/osFD3IIH44lEKs?=
 =?us-ascii?Q?G1ppZ0tgrOT1dDCTNx667q06OPHNF7uT5zrN3shLWwlhaIASdaGfJ/BPpFMd?=
 =?us-ascii?Q?k6D7n1nusZdSaETiGvbKG4N4pQlrBGVoz5GhH8OE7eYpZeVy1ozWZ4M79OPt?=
 =?us-ascii?Q?2oBdsJSF9PBkvdaeVFxFhFjfAgb6Hjz+s84t9QOoOWXoVn2p6Llscqp2x3AD?=
 =?us-ascii?Q?ji9efmNXzNTtJEQIOUKpNDMaTpDo6T367s812dtI7Wwtx/aCgM9PeREfBTVI?=
 =?us-ascii?Q?DgbhfhyUdavJVcfziata9B2Ucjb/N8bfkbW25vdZFFjAG/fvpavzxQY9RGq8?=
 =?us-ascii?Q?xGsVvtt1J2aN26JzBBumsxiv3uBqp1JQ9CKiu4T98r78wTb4PWzowaiikFu8?=
 =?us-ascii?Q?+LY6ejQ5OR/Tb7PB6wEmELWc6LO2IZ7RgkcluVitdEyE46R7MfVtPgwf1vIZ?=
 =?us-ascii?Q?UI6zXb4RjV62taubbmc1XU19ma9zWko0ytNV6XRsCTLC+ikJCJESI0s+0/YU?=
 =?us-ascii?Q?kPUuRjAU8xODbNsT/f4pQ/J1f8RX6PNdWqjLWJdp6+i9hL4Aa/eh2TbF4b8v?=
 =?us-ascii?Q?7qJzw5rE5+ex0JBM9BH9PFI49czZTfx22XRGLcptWnp4LxJW3TmW67UWdid+?=
 =?us-ascii?Q?HlwF+zpJHRTCIcTadMqn0yWEiBcnpO8wWcGQ27rb3SJQz1jpmzPFGISqpDe0?=
 =?us-ascii?Q?4fEEECIUU8vkVt26P4j5szzCYiWxCeVZIEZiAGW9MTrRjaYSWvwaeRopeBZl?=
 =?us-ascii?Q?4BNN7zT8NPf6WfOssrH/OF2j4R+sdI+M+DQoZpZGBRB2jQS/hQN3bcSXlgVa?=
 =?us-ascii?Q?BrAN2XjN1+89BmtU35Lk9LfOvncneMhGmDAlp9u77he9PD0704AYmGRJSHj4?=
 =?us-ascii?Q?IVVdxjWdPcPSIAB8VxGuBRcjKnQjKbyKrnn98foBXYHaM+MBBpvT0EhLwroT?=
 =?us-ascii?Q?5wKIgM6CKS8riYCkT+O62H/DygGTHjSphU6lSbkVPdMaJHwVYj8JD9MNej9l?=
 =?us-ascii?Q?e7FP9DyKq5xi7jq8AeLrZgv3hJ7avpekk1YOr4Q/mPFtndRs9Nvc4IY7A3dE?=
 =?us-ascii?Q?gUpyKfEpKavydnRp8DmQWw1XKf7Y/b5oRHLCi8LP/gqNKW9C/aCse2Ahspdh?=
 =?us-ascii?Q?8IcJ5CZBgKSZDmhvy7NGahOoYFFBy7eeWyH4jY9hjBrt5zTZBhJJupGTIE4d?=
 =?us-ascii?Q?A37M9AIKRxrjbtzCArUPTJ9FlR4ABwoQ2SwAkIbQ8WpmKq7Dn24POmpReNmF?=
 =?us-ascii?Q?gkek4IFy+YKSh0SqXco4bQD8Iz9U8+8KMyjMSViP2ajB6GDidyOor/BS+6Yl?=
 =?us-ascii?Q?u19ddwFvkOv5uOvVNE56mJlmQtdSuidXPX8XsnuA31hgxIYK+itjsQCFMZr9?=
 =?us-ascii?Q?DyIMnleT2t3CEOojLUbq40Gj6EnBlZ9FZccqKFmpciLvD9fDrUvsL42vB6uE?=
 =?us-ascii?Q?0+BPMfUS62hApep1221ZJ+KdZ7+Tp42u1Pi9RToX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6800b6-7b04-4304-6c0d-08da86e9b987
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 22:32:42.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vz73pxQJFLuv4xLUqao+n7xyMLwi+md3/kc871FN/31+9ADN3BQ6+uqsITTTn+Z/DYPyf1/aObjvntyRhJHVcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Peter Xu <peterx@redhat.com> writes:

> On Wed, Aug 24, 2022 at 01:03:38PM +1000, Alistair Popple wrote:
>> migrate_vma_setup() has a fast path in migrate_vma_collect_pmd() that
>> installs migration entries directly if it can lock the migrating page.
>> When removing a dirty pte the dirty bit is supposed to be carried over
>> to the underlying page to prevent it being lost.
>>
>> Currently migrate_vma_*() can only be used for private anonymous
>> mappings. That means loss of the dirty bit usually doesn't result in
>> data loss because these pages are typically not file-backed. However
>> pages may be backed by swap storage which can result in data loss if an
>> attempt is made to migrate a dirty page that doesn't yet have the
>> PageDirty flag set.
>>
>> In this case migration will fail due to unexpected references but the
>> dirty pte bit will be lost. If the page is subsequently reclaimed data
>> won't be written back to swap storage as it is considered uptodate,
>> resulting in data loss if the page is subsequently accessed.
>>
>> Prevent this by copying the dirty bit to the page when removing the pte
>> to match what try_to_migrate_one() does.
>>
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> Acked-by: Peter Xu <peterx@redhat.com>
>> Reported-by: Huang Ying <ying.huang@intel.com>
>> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
>> Cc: stable@vger.kernel.org
>>
>> ---
>>
>> Changes for v3:
>>
>>  - Defer TLB flushing
>>  - Split a TLB flushing fix into a separate change.
>>
>> Changes for v2:
>>
>>  - Fixed up Reported-by tag.
>>  - Added Peter's Acked-by.
>>  - Atomically read and clear the pte to prevent the dirty bit getting
>>    set after reading it.
>>  - Added fixes tag
>> ---
>>  mm/migrate_device.c |  9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 6a5ef9f..51d9afa 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -7,6 +7,7 @@
>>  #include <linux/export.h>
>>  #include <linux/memremap.h>
>>  #include <linux/migrate.h>
>> +#include <linux/mm.h>
>>  #include <linux/mm_inline.h>
>>  #include <linux/mmu_notifier.h>
>>  #include <linux/oom.h>
>> @@ -196,7 +197,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  			anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
>>  			if (anon_exclusive) {
>>  				flush_cache_page(vma, addr, pte_pfn(*ptep));
>> -				ptep_clear_flush(vma, addr, ptep);
>> +				pte = ptep_clear_flush(vma, addr, ptep);
>>
>>  				if (page_try_share_anon_rmap(page)) {
>>  					set_pte_at(mm, addr, ptep, pte);
>> @@ -206,11 +207,15 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  					goto next;
>>  				}
>>  			} else {
>> -				ptep_get_and_clear(mm, addr, ptep);
>> +				pte = ptep_get_and_clear(mm, addr, ptep);
>>  			}
>
> I remember that in v2 both flush_cache_page() and ptep_get_and_clear() are
> moved above the condition check so they're called unconditionally.  Could
> you explain the rational on why it's changed back (since I think v2 was the
> correct approach)?

Mainly because I agree with your original comments, that it would be
better to keep the batching of TLB flushing if possible. After the
discussion I don't think there is any issues with HW pte dirty bits
here. There are already other cases where HW needs to get that right
anyway (eg. zap_pte_range).

> The other question is if we want to split the patch, would it be better to
> move the tlb changes to patch 1, and leave the dirty bit fix in patch 2?

Isn't that already the case? Patch 1 moves the TLB flush before the PTL
as suggested, patch 2 atomically copies the dirty bit without changing
any TLB flushing.

>>
>>  			migrate->cpages++;
>>
>> +			/* Set the dirty flag on the folio now the pte is gone. */
>> +			if (pte_dirty(pte))
>> +				folio_mark_dirty(page_folio(page));
>> +
>>  			/* Setup special migration page table entry */
>>  			if (mpfn & MIGRATE_PFN_WRITE)
>>  				entry = make_writable_migration_entry(
>> --
>> git-series 0.9.1
>>
