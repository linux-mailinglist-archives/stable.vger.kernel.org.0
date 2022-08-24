Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0F959FA0B
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbiHXMcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiHXMcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:32:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D78CE36;
        Wed, 24 Aug 2022 05:32:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gc+IBxx0E3WCWBxJjYExGCnWRNYdakLJbbCFxWmCaEWZIJ/y3UwneVP14toW9SIaa9P1ixvA6cpHZX9sf1pamQHi+M8dqrbVeKnNf5K++QVL678bwjiZoJ1LBEnr+eIa0HXNfoo7MZAV/+OlGlGVeh/P+T+Wp9Z/I7vOy2jii/WxketvuAkQ9g+I0fuyQPVMtSLirzJ+XgB9ZWZOli3eTXJKjYSQuzQWU+8Kh0he2iM5PPTd2Um+V/Z1j9HvRdgPaAo9guFUBGdF2woRk+y15KND5IfOIIde/1SX2nKVSgVWTlwJaV/CDtUC72HfUglc4YL1DegttY0ZjsUMukOzJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e88QVK5EFcxXqJH/C8u99XCZLs8Jcvr7euw/BNb4f4E=;
 b=T87AtKiLoAzP9k3EovNNCa7eoyaoWMDVIbyg0xtqF/LBrkxiyKeT9VF0nTGnlK9baCcXsVL+41v5JpIKyydsCFRnuNKwvzNx1fKUfwG/uBXEkyoJC1cVp2hf77sywEdrIopf8Kdebj41c2qNPWINqeAroRaL4O7c6n8pWP2iQWqxd17j8IoprGNIALzx7EKrd1FN1s84WcbGE4xohoV6GFsBBTBT33F75Lt/8KqlOTU1c3wmTU/1/gHZMvzD9utG3bhTlxP6eLjOtbTV57ZBKImZ2ecR31QUKWuqnti1BmVy/1UJQwqFRUjr6JDV52K6kA1kUpmvMYpPVynidbubNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e88QVK5EFcxXqJH/C8u99XCZLs8Jcvr7euw/BNb4f4E=;
 b=WVXOMY3x6/s1La05AZrXCVf87qiGrPug+Fw0ICTJH/ywebacWg3jxBf0M5xSg/2q+ruuXsnYuUGlI+QugcLIyrcmvwyJ3A3JS99bp7DckHQ6qzj6sjwzHYS3e41OgOdmFsQMScEO9xn0TZp9g0RggagmirZTsTMPPnS431px06FgMxx4/W5VBs/DmGmEbP0EWSXoHPDwzeq+DisUTNhxBDLYR3LD8FeefqhjYpIoHstKgyPeIbXmuQQ9LZISFv8jRbPZnTkM891NAgVInuG/mZ/B+4uEvTQaC1R7mKCtIiXzDbNm924pKTtYVsxJaXLWGYU3lBnor7541o9pBsDvxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH7PR12MB7137.namprd12.prod.outlook.com (2603:10b6:510:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 24 Aug
 2022 12:32:44 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 12:32:44 +0000
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <86b0622d-06eb-cfab-2ff1-8a0eaf823f8a@redhat.com>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/migrate_device.c: Flush TLB while holding PTL
Date:   Wed, 24 Aug 2022 22:26:22 +1000
In-reply-to: <86b0622d-06eb-cfab-2ff1-8a0eaf823f8a@redhat.com>
Message-ID: <87wnaxg6u4.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0043.namprd08.prod.outlook.com
 (2603:10b6:a03:117::20) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4b23b68-83a4-4bc7-bf62-08da85ccbeac
X-MS-TrafficTypeDiagnostic: PH7PR12MB7137:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKq4uhE83YJ0VmMaX8W+fCTIEd5vDRlDW8wCDucOMEwJ0ITvZGnnnf2sGu5QnC7Knp94HCwibScOMIavYNCDI3tmBFQfy1EGkNn3CegPrEW1tP99LLJBHzONXm8WBK5pLx6QVJy3C8SHxUHL0y7SG0XIhIxRzamzPiEa84CMgptepqDfchY0va4pweR7PkCL8pufMPkkivZlsvV+f0B/NimnChsJkBBqXL0Yj6bRV6f3MP5hMheihNsSys+cJG48z8AkhDc0IbdXUdcjnAJQmzHV5VuN5dlAngtK1oWvNJ1ZGm8pm3yN1WuUtTRv6PQDQ2XpWOPA5j9M+SPGih06SFo0lJI5nZefXVezl6Zp2kr1hAXPPnxoZn/wikMvHh6/8XMXM4hLyXdVv+HlPNfIpaVQnSFWrC8rxy+UK2qwC3nOudkADtU056WL0PpDrm4Xh4wR7dqp6GuPeASfkgl1jvvfVicg9SPp70ONx4Jql0mF5deyIDLwJdZ88xdQNieNsMXtDmxCtVIm0DmlU1x817e7ZJBVGG3UmieTlBlWS7xwJ69vgMOFbZqfUA9Ffd1/V2TAoPNT5X+JfLB5Z/sfLSBEJdLYRQGdGQPNIoccZ9mVl8C9bLAogIqi0RE/avuHmELO0Yzl8DeQJMYHh/cEpI3yXjmU9zOOkcGbEPM5BBT69KwMFSrrPuswu6Sap0XPzug+/MlatfNsXDzfF3GiMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(6666004)(6506007)(53546011)(478600001)(86362001)(83380400001)(6512007)(9686003)(26005)(41300700001)(186003)(6486002)(66946007)(316002)(6916009)(66556008)(4326008)(54906003)(8676002)(38100700002)(66476007)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nrp9m7rkp9uWwmTz/7UM6zwnWQxzFw+SUMRQMovFFhmZKK/Gk9IzoyGbU0NB?=
 =?us-ascii?Q?iO13pTbuxc3SPkXjTCTIdQZdjlOf28kk0POZwVKha16+BSAGBkF1/mRH4XPe?=
 =?us-ascii?Q?NIx5HTf0lv8rmGiJMriLIIi+KYfIoZdZupjHm5C43dEH2QaQcA4jIYslawKc?=
 =?us-ascii?Q?Lqrld0cfB/OeritXNA3pLICZPSSm3zl+m+3FlnAn/aYJx+0lB4aBFyEzj6SE?=
 =?us-ascii?Q?3rJ+0RCnidLQVHxkOvSz+QY9ELb6dF2VHZ4Cial9NMpkVYC7N82X48kAjFfd?=
 =?us-ascii?Q?42YautEJmysLqwy4lr1bY3C0ymlcphvxlWgxuVFz5S0OHfpOdwmKNDmeoKrE?=
 =?us-ascii?Q?nFq2bNYlwJq0IuA1prtfkn5a1n52FrgBmCxQRRELkeIe3feXT2Jb0xtvys4T?=
 =?us-ascii?Q?g+1PGJFyi9sgQKv+qh+TpfQqi4VgJyJ2RkAE1HjpzH7nzZRnH7/abUAadfSG?=
 =?us-ascii?Q?neF4Cmw6jes/lClDdjZGhZ29YVimJtiDL0rn269kaIJE9FDWsxvsU8UFN9/D?=
 =?us-ascii?Q?5rxj8IcWMaNRj5JGL/nbHIES2CpSpjEUlzfAIERltEJE0wtj3kRFAQzjjmnh?=
 =?us-ascii?Q?UxmT31bw3/KKLOpNzHK/krg45ZzrbSjoMXsHlRx24LiYvigtff+TgWhaxwyd?=
 =?us-ascii?Q?FQuhIea2zPfqRSqOV9m88haT9Ju4CPZVoe8rjPwAGcNs51AGtC5cFn8YMK39?=
 =?us-ascii?Q?qjsKMrW+Fv85Jwe5JTtGD/UTzFwOVXm0uW+PBmjdQ6ajaou7JILC6Evlj4qj?=
 =?us-ascii?Q?QwePwhKCwtCvM6cgyPDWWp4Z4jhkMwm6g78FGZniAo+K7agglJKzkvw0O1Lm?=
 =?us-ascii?Q?ySTwsFKgxrnzMUORwrpCAM4pSTzj5af+yEjy1Tw2G+ru+OpTmjBxaLnGWjEr?=
 =?us-ascii?Q?vhpWNtn3KaQazCbHZ7iXCGIKMF9Tsdl4Hygkf7EVGD9cjGJLdgbO6lm24w7r?=
 =?us-ascii?Q?cZ11Zc3oTskHOFQ13hUpPvkJOD2VUPDLyGZYMUkPmHkNtLe5+kBOF5gpfyn5?=
 =?us-ascii?Q?XEuntg+I7A4dknAz+JryGq34vJnPfLARtxPa1smdCgBuw/K83SBtDQG1Cwqy?=
 =?us-ascii?Q?KF3UOCL0FqpTNZ6sF0q8EftETSTuCGdFIMPAJNcITAar6jx8F4H6aPPzGU67?=
 =?us-ascii?Q?x9ZXxgxDFioboDgpBgeM5Xx9maAtFgkuhATE2/ZxOKfo9eAb9wAMqngYN605?=
 =?us-ascii?Q?DKSaKOjVYlr2TgeWPmYtuYB5CW+zZTS2zx5HMW1pM9Aqeqzj+KcQfpYYZrew?=
 =?us-ascii?Q?lCx7WhsCUrXHR9TVEFyxLl4IE4w8Pl2T7tX6BDd2/Pgh0A/1po/GE/i/LFDt?=
 =?us-ascii?Q?UM0ga2H8j5E/navkER8VWu44SQQTh1zs1a2yV/He/ETceHtpYBcc9OPzr1TL?=
 =?us-ascii?Q?q26ArkBVZNvhisCIplEeTK8sZ4dbNaxPtaXoFFF7KuPnMrodXSlveKPSf+vj?=
 =?us-ascii?Q?82lRQeq730y7SutvFINREN2CF0UAZgCeytDVw4SfG5YWIgJnldCpChaBwQHA?=
 =?us-ascii?Q?1QKGMYVv72ZD+U+STocmKNVLgZQ/SXU94GAc2rRji08G7EtUdp6+/y1vZkVQ?=
 =?us-ascii?Q?h2GT2xO54zWLsM9CRlqA33eqTYcKT7ysMNYg6e/F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b23b68-83a4-4bc7-bf62-08da85ccbeac
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 12:32:44.7036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ol5j39ZR6j8LpcT0RkTuGPjfJN3VDhy7lT7DdkBnjV4GN2sbo3rdbSOY4/txl2nDWmYNyoYrHxrNJ+IxxwT33A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7137
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


David Hildenbrand <david@redhat.com> writes:

> On 24.08.22 05:03, Alistair Popple wrote:
>> When clearing a PTE the TLB should be flushed whilst still holding the
>> PTL to avoid a potential race with madvise/munmap/etc. For example
>> consider the following sequence:
>>
>>   CPU0                          CPU1
>>   ----                          ----
>>
>>   migrate_vma_collect_pmd()
>>   pte_unmap_unlock()
>>                                 madvise(MADV_DONTNEED)
>>                                 -> zap_pte_range()
>>                                 pte_offset_map_lock()
>>                                 [ PTE not present, TLB not flushed ]
>>                                 pte_unmap_unlock()
>>                                 [ page is still accessible via stale TLB ]
>>   flush_tlb_range()
>>
>> In this case the page may still be accessed via the stale TLB entry
>> after madvise returns. Fix this by flushing the TLB while holding the
>> PTL.
>>
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> Reported-by: Nadav Amit <nadav.amit@gmail.com>
>> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
>> Cc: stable@vger.kernel.org
>>
>> ---
>>
>> Changes for v3:
>>
>>  - New for v3
>> ---
>>  mm/migrate_device.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 27fb37d..6a5ef9f 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -254,13 +254,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>  		migrate->dst[migrate->npages] = 0;
>>  		migrate->src[migrate->npages++] = mpfn;
>>  	}
>> -	arch_leave_lazy_mmu_mode();
>> -	pte_unmap_unlock(ptep - 1, ptl);
>>
>>  	/* Only flush the TLB if we actually modified any entries */
>>  	if (unmapped)
>>  		flush_tlb_range(walk->vma, start, end);
>>
>> +	arch_leave_lazy_mmu_mode();
>> +	pte_unmap_unlock(ptep - 1, ptl);
>> +
>>  	return 0;
>>  }
>>
>>
>> base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
>
> I'm not a TLB-flushing expert, but this matches my understanding (and a
> TLB flushing Linux documentation I stumbled over some while ago but
> cannot quickly find).
>
> In the ordinary try_to_migrate_one() path, flushing would happen via
> ptep_clear_flush() (just like we do for the anon_exclusive case here as
> well), correct?

Correct.
