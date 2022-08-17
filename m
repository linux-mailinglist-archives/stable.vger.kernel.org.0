Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23A25966F8
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 03:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbiHQBoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 21:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiHQBoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 21:44:23 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2040.outbound.protection.outlook.com [40.107.212.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4572C642FA;
        Tue, 16 Aug 2022 18:44:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv2cutvMAcI6qiZHb7pVBeD2nY8h9+/D9vs+5aoLajDocDTyMbhRDGrxQSvv7KYpHlSEThaWq1HQFcvyK1jVkE00HMuW2fifQpVIl5AA1FGvX/K9b/FQ3ujjWkqoe3AZoqND6fsIQb7hwEZhTbJ38R/g21ir04hfiJtprMKpjlZWdgnyvgib/1GiFh6HFGP238sTlL7H/xIO1VZYVp8jmRds4V9meEyOKWvwDjW+Rpm43HZG3J7LN2hCOl6nnWGujUbCFqntrUPnJV7b/xxObmIeTrEHFaOcOzzMrdZzD/CgeHXHtGUAZ+18o0gsh8XFAmc4eISk+EJkONIW2poEGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2TDiozEgU6VSWkCqyilCIWWGifAh5n5GLUxh9dm8mQ=;
 b=k/3jQso52YC94L4Yb7kKNO5XBQpoNZZlVVQSrkMSci2ByYltyhTJfVKrSq/tN/Iy3PrsQo6UipEWmaR2Czb9G+LownnWZ7NWr0yT/XIC/fu17sMh/1aDeBJ6OZpn9g/RVa2hG2ozTGw1t5RPvxInqzvMCI6zhIs3fvNGH26NapRX0zoHmLqTAfpjyh6Ju0k72KeBIpDb13ifneAJBKYvbrF3lA47nTOf3kObocBk0vLIfcBviB2QHsjK9iqA/n1J3b12xmIpM9q6wShh1LZ5yti2oTC98hvZm481rmyzlRuc0kYRLwGpA4oXATADpx3E7XqGnV0d1DPSL1ycEMamDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2TDiozEgU6VSWkCqyilCIWWGifAh5n5GLUxh9dm8mQ=;
 b=mGF2aT/qOcY/gwppjj87Oh5L7W7RDfM3eKn0+w6rcUP0slQLPxNawpJKHgD7/Vwpu+y1/ymTNe2T+t6hAks3WPHQn6LP0DOJ4Hm4ZxYxbX56V2rdg+0G+UvCmNlQudYbpJj7o+j38ZHOSolxIEWt2Wwj73EmJtSXHXHmoznhtl4YrMQIxgnppcGysk4ZMUVODFnecdkvcXRP7APKFVGgDVZU7H7Ab4YIjevclCgmcAg8KLShvfVEQWq6bEiWcs94TUeBpzZ2XTDH7woKNiCFIPhDOu51j1KMnSt+iiJQpgxT/CYVV52+5DE5892Q8ftpXVP/B6EwCwUfzCFfLK/ZFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB6424.namprd12.prod.outlook.com (2603:10b6:8:be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 01:44:20 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::eca6:a4a7:e2b2:27e7%5]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 01:44:20 +0000
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     huang ying <huang.ying.caritas@gmail.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
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
        Peter Xu <peterx@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        Huang Ying <ying.huang@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Wed, 17 Aug 2022 11:38:37 +1000
In-reply-to: <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
Message-ID: <875yirve32.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:a03:331::22) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a549e672-9f4a-40bb-ba94-08da7ff200d0
X-MS-TrafficTypeDiagnostic: DM4PR12MB6424:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXq997pTKIzZSH2S0v4czTtoN4EUlekEKalDTZqhcppiSqI5+pHHQSssuNQ2T+s/LOwIA8PLnhEl4JxJPmi93R4I3E0ClnGeoSdpb072BmQ4DnABGOO0LQeD443QJ31iL++O/v3Jp1uKJf11kZ7C/D4K+UE4a4zXQn5QRCsRLOIzRWbCJZ+Nkny9+PYHY4ivMY4r8t5Aod7smSmkOF0xTaNtegD8GeVIdmJZTNR+T3zRj7JEeoiCrCuamNIBGOA96qNp4eeReZd5wb1RbyCRnUZoDOytkCNagWWqmCG7cx7Uhni2c7/R6gsHjjNcZYIl6w7YyzX5C8Co8AyG5VZWQJhM+etKasHEaQeAWKrssKbzT5XBfvG3Jr89Gg1HHcgMaG2YLaHMODI/P68QxUNCwMi7zxZ1NQZJq87XWKw22uXwPZnqUSCzQzYfKn2Buf8sQCI8EKE8He/PdN7vdHMxwS6hjm/R+jgswoHdMpbBpuK6Apdj2Mc18emFSq425VoiT6D+tIUq0Ug0pPVJgYZzSUbiys/NvTKjjdU0+hKGmnzTCblqJLST4+jWnWvhlFAp1I6EPWhoZypWUb8jRMnWavGS5XuMXFzpcA+76nqK2Ken5J3HP6wM8dU8yEBJtuN18SaqCoBg8qJ86rZFyAQPaRZn4TSUX1CjYU5GbQpgUMtRpYnbKa4GND4fLm5vkLf93OgsYuoX3DcpDhYFky9Fna+g8xAt3faKZnKHXF2ONXfH9aLk9SOQhPS7AWAa3evkvNCOSdC79DMSU0hXAQDoTqRXKTYA+lSsAUkXrQFyM3k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(38100700002)(54906003)(316002)(83380400001)(41300700001)(2906002)(7416002)(8936002)(6506007)(5660300002)(26005)(6666004)(4326008)(8676002)(66476007)(66946007)(66556008)(6512007)(6486002)(53546011)(9686003)(6916009)(186003)(478600001)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v/xiVGCNzzzDpzj8GtGQOJgrBvBSeRIL+lXNSCicApkk1ThZSNfe5+bAZB/j?=
 =?us-ascii?Q?KWbVSyR7zMvjIuXuZkCoCZa4d21DZGMju6t+ptwmY7esHH9JHHqVgP/xAGFM?=
 =?us-ascii?Q?jiDNdZEtb54qZpw4XJlcnoN2/z47ueGwasXs1I1PD2AVI2th/4RpSP9obyaQ?=
 =?us-ascii?Q?R9yagzggKAIb8N2pkaccsxrcjwHZWGF3CXFsIsKwG2yfnLpwmBONjgzAiCL1?=
 =?us-ascii?Q?UPg0RhV9W4WUqNll6f1U4DMGkc8RA3TH6aUHUwt9kqm31bhY8l09wwTET+dT?=
 =?us-ascii?Q?zg3pryJ6lNAtoxzK8eBLUl3Zd7EiUYlb0ulXf1pOGJbCe5a2sDKhH/x609+J?=
 =?us-ascii?Q?LvlPWv2dMIXjNhUPYDq0rYILYVaXdWj8pTXTqXscIVvp8ny9Kj/thsnVIpUx?=
 =?us-ascii?Q?VrcDqrJ4R6UsT85GtgLisGnW7AEfGT1es1DE0W48Ezn2LkJgyhGMYk6tuEUU?=
 =?us-ascii?Q?5mMh5B/OXthqm0ieV0z3dFi2d0lMk2BTxpKMNilHElxKZTW6WDUWMrm3nQWT?=
 =?us-ascii?Q?SJX28aAzgN1wGrjgq4Mb0On7qdOTeADsmBk73sYPnOzyQ3L24Gi1iViWagTj?=
 =?us-ascii?Q?f6IJyaXwzQOs83MilDxne4ELjt7P9m5rdpjDpKKmwMP1aqscDj8SDcfevcyj?=
 =?us-ascii?Q?a1VNakbQJ2bMfuGZKkLA9adrA6Yq72ASyVqrWbVNwO9wAmJBxC4/YqAfp7nh?=
 =?us-ascii?Q?XoeSlxTC/wPmTsdsHltSs/ZMd9Fiot1Pb+JeJu7Oci2JSb4MF/wNQihbuEgK?=
 =?us-ascii?Q?V6FBh/dNSg7i4U6FX/EzrtpJAXvRfup3K3D04Y38pLwOYUcgkhJT+jPVacV3?=
 =?us-ascii?Q?VO/R3RxOLP1LOoY4nC/9vXPWWBFOQe4mcXDLeLqZAGeA5l5D3/++9EzR5J16?=
 =?us-ascii?Q?Zp2A9ldlgWHHx64Ljs2X0gZgSf75jkPMxjbYAs3CR2R4/3QSsbfRVLIMmWck?=
 =?us-ascii?Q?85m3nhOY2Zy0OML/u7tVtpfr4sMTgnaSjzdCYLjlv6fwFjJil3P4djJKSJjz?=
 =?us-ascii?Q?MUkphp1UsR+hkodc45qRnBHx6l9BdEBJ4Vs+2ROS6mGpfZWCbo8Hj3N4oXqo?=
 =?us-ascii?Q?BgCxKTiKHomcmPlbsIi/86atkWJd8YQYQ0wMsSp0mk1Y0W1bsAz0+gap8b4N?=
 =?us-ascii?Q?cSF9F0aBSJM9k8Mt2RpahlvVGrQjQx9gBLahOixaVYLozKTXhTPi2+3MopIO?=
 =?us-ascii?Q?qZ1OP+C0yIzjAfLGrEHc6CvJsw2rtQDFxQ6Z1SrDy0IKBMiynNMNJO8ITa7m?=
 =?us-ascii?Q?TkeP29lkm+NRn5gAQfG1C3PVg/OtxgHkhAfly7bOgmO/MO+6GsbBzQmevri5?=
 =?us-ascii?Q?uOE/PCwMDGwV5c4j33VPT9NBKuTpcBWNkWkgSNAoeWzHIYvZnWQ9l/uBQFKV?=
 =?us-ascii?Q?CVOYik9NW3VFFF7hU+v3EvMBIDlH8qXlKq7w6V0ZX1fZD6yr0tZmFwAaJGAD?=
 =?us-ascii?Q?Yow3G3Q61x22Qbuj+TtFZMmiQNFlMCSA1WGxnsfQnqIT4Nt3i/FmMIZQ9Aol?=
 =?us-ascii?Q?jK/9NlEXXF0632lMmjWC81eDPYyIK2U1EA6OpeP32hEsMFcg+8pM3zfaq4xP?=
 =?us-ascii?Q?eTIdJcaS+cwfM88CXlV7B+VqUUzd1qRebANxyJAw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a549e672-9f4a-40bb-ba94-08da7ff200d0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 01:44:20.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCREEzhSsNR5waYvCWkyRcTipiY7s/VK7c56COJdBYUV4JWGdeGJgQzKbkC0WBktGzUSv+iMTdYIcscWE54vhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6424
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


huang ying <huang.ying.caritas@gmail.com> writes:

> On Tue, Aug 16, 2022 at 3:39 PM Alistair Popple <apopple@nvidia.com> wrote:
>>
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
>> Changes for v2:
>>
>>  - Fixed up Reported-by tag.
>>  - Added Peter's Acked-by.
>>  - Atomically read and clear the pte to prevent the dirty bit getting
>>    set after reading it.
>>  - Added fixes tag
>> ---
>>  mm/migrate_device.c | 21 ++++++++-------------
>>  1 file changed, 8 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 27fb37d..e2d09e5 100644
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
>> @@ -61,7 +62,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>         struct migrate_vma *migrate = walk->private;
>>         struct vm_area_struct *vma = walk->vma;
>>         struct mm_struct *mm = vma->vm_mm;
>> -       unsigned long addr = start, unmapped = 0;
>> +       unsigned long addr = start;
>>         spinlock_t *ptl;
>>         pte_t *ptep;
>>
>> @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>                         bool anon_exclusive;
>>                         pte_t swp_pte;
>>
>> +                       flush_cache_page(vma, addr, pte_pfn(*ptep));
>> +                       pte = ptep_clear_flush(vma, addr, ptep);
>
> Although I think it's possible to batch the TLB flushing just before
> unlocking PTL.  The current code looks correct.

I think you might be right but I'd rather deal with batch TLB flushing
as a separate change that implements it for normal migration as well
given we don't seem to do it there either.

> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

Thanks.

> Best Regards,
> Huang, Ying
>
>>                         anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
>>                         if (anon_exclusive) {
>> -                               flush_cache_page(vma, addr, pte_pfn(*ptep));
>> -                               ptep_clear_flush(vma, addr, ptep);
>> -
>>                                 if (page_try_share_anon_rmap(page)) {
>>                                         set_pte_at(mm, addr, ptep, pte);
>>                                         unlock_page(page);
>> @@ -205,12 +205,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>                                         mpfn = 0;
>>                                         goto next;
>>                                 }
>> -                       } else {
>> -                               ptep_get_and_clear(mm, addr, ptep);
>>                         }
>>
>>                         migrate->cpages++;
>>
>> +                       /* Set the dirty flag on the folio now the pte is gone. */
>> +                       if (pte_dirty(pte))
>> +                               folio_mark_dirty(page_folio(page));
>> +
>>                         /* Setup special migration page table entry */
>>                         if (mpfn & MIGRATE_PFN_WRITE)
>>                                 entry = make_writable_migration_entry(
>> @@ -242,9 +244,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>                          */
>>                         page_remove_rmap(page, vma, false);
>>                         put_page(page);
>> -
>> -                       if (pte_present(pte))
>> -                               unmapped++;
>>                 } else {
>>                         put_page(page);
>>                         mpfn = 0;
>> @@ -257,10 +256,6 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>         arch_leave_lazy_mmu_mode();
>>         pte_unmap_unlock(ptep - 1, ptl);
>>
>> -       /* Only flush the TLB if we actually modified any entries */
>> -       if (unmapped)
>> -               flush_tlb_range(walk->vma, start, end);
>> -
>>         return 0;
>>  }
>>
>>
>> base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
>> --
>> git-series 0.9.1
>>
