Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F365A1C8B
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 00:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239595AbiHYWlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 18:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiHYWlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 18:41:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A88BBA74;
        Thu, 25 Aug 2022 15:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcEYXVO5Vre9dIk+gq6Ih37L8zZLpY1Il5NHSkY6WwgTbdzfG53pxmvG3zzM1pLglnnt4NG51wuT7QMwZdoEbCkc/6Z8xE8Yr6GDeBdf/h3tcgGAqlRUVeTsdGBtbU6V+mwCyPPK8Jcq1jHZOhsEjrl3Q7q+3mOOPUk/+9BmVBeNs0VogMyHwlrEOYWgBp1vdRl7YuPbf/q/TxqA7LmplKRgFKI29dvqAmmtEZeIxT33WX20CQmN6gC7hGc7boUSjL2oMaYyvstm/bDntGJCawIwhC8TkGDXni825iMVZGvthHn+txljOhixLOKrK9415zTAZ/yDsg64hv+ggAfvEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CIN6DAWYQ9C+JYmfYGAD/VPgDKboMHGBef1MQTeg3g=;
 b=TLwhB19n8WKZC9pI9YcpPdA7umMpSofRQUd04NAqJdvymzZVwpFmnxRBpDHYuERWLRsFMEptKK5/5ZT1h1Ual+xDSqMicyoZi0iD4Cx7jrzGRb1x4Iy97aB/Itbmm4pGGINnHN+aTqxlHIWYTEuyfX3A51paxC2Oz5KEx/wRQtlBwJB518s1C+b4oUW4lTz0TVqfbeTSUdys3/En3MgWki7aUkTDFTzL3qRUsk2WrpCobrC3GvC7UPruuTU2p5K3XGiFlIvOnJjyQhebH9w+64v5c737jAo/RTSmAepOzq2sdyev0XUfwQnY34DzIBFCf4/MLPtbaBsCN9cEZHmp7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CIN6DAWYQ9C+JYmfYGAD/VPgDKboMHGBef1MQTeg3g=;
 b=ook0gwfruuFSCvRA5mF48POqpHEXNGsSNl1dFJiVRCuoaTO0QDmQcOZypplldFy8rBYZhxVPiNHFmW0F6IPQWThl3+N6o4YtdBSX6h6RyCjl0NBNt5mBE7uLdmVZo6aKS1dejJCYEv34IEKqxL1pu5uG/ynxTobaiF0vQbEYfFb5KRB8xzqSuE+dFmZ6BCdVk2BhEk9HaBC5ZjZ3C9Cz9wO/zboT4X8Wj3sAq6KojLoiMKW60U79lBNfJ14N/MKlE/3bvCQsZaAuWbfntC2sh4p/bINQNiAJQPw05H1SIObjngXWhSXKAiMF4a8JHZ1moU34b8wHqZ7j4qxkZzJwqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB6260.namprd12.prod.outlook.com (2603:10b6:208:3e4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 22:41:16 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Thu, 25 Aug 2022
 22:41:15 +0000
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <87sfll2jfc.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org,
        Peter Xu <peterx@redhat.com>,
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
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/migrate_device.c: Flush TLB while holding PTL
Date:   Fri, 26 Aug 2022 08:35:17 +1000
In-reply-to: <87sfll2jfc.fsf@yhuang6-desk2.ccr.corp.intel.com>
Message-ID: <87y1vcdjzs.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::45) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a622565-6fb0-4c48-2d9e-08da86eaeb10
X-MS-TrafficTypeDiagnostic: IA1PR12MB6260:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: siqsX9Ci/wJ0E1aSrSFI/ZVBgN3qbW0+tB0GtpWpOckH+jxtnm/aiDD8SxKSY0h/yrqezQ1iPak9lvTVxMOKh4dFrveSKi/R7neVKOLYa4lxyAqSgwiuHlZssuxQkxb8eBaFdc9Ufaa2kwmZkZB8AL2E6fDk3qUCIaR4/r+FQ15Qd42KRKJ6cgvpkApCwTVoLrWIvHLsck4uMMYxSSoBt4pD8HHdqtIGTGHJ/4DOquH0kFLfR8PCwNjM1BeFCiy3ntPIeQHaoLy3C33i/UCbFQ9vOoWfHp62MR+K6FkSFQhDLabXoSr0mrO63oBYkizbxkOLIc24VkEs1PzHS72h8BE9bBzHOgazrD3mb4Ixez3SbncFOkEnQgacLNufG073QCPU6jqoYOokFBO8Dbq5u95OUMjIQrN3BoIUOf1sQBB77alIPR7EHQIrY2q3DjKDyj8ghtisLCDwENMDSiaNxNIHqPL9HUXQYrGtSA8UokNN4lrn+M+yutoTm3ioqMeKtpCHZRmE5wJatlBCQEo7Bg8oN1DDrq0RqXXNLZt5Xt+MF17ynYbM4w6P/nQ6LBrcQA0wXSPtTFl0rZ9P2la9XIlGz0hmzmgn/vjUc80xNy3ee8yrGRXJH3hHnoEEe6yQuoR05a75gHYNK6G5wBrf/+iRVnCDGDH2Ez+QRv9dTifFrSynA4GsSKwOvY4JA8KhVKDtl+UtrH7/eVIR18gXpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(38100700002)(9686003)(6512007)(2906002)(26005)(316002)(54906003)(6916009)(478600001)(8936002)(66476007)(7416002)(6506007)(41300700001)(5660300002)(8676002)(4326008)(6486002)(66946007)(66556008)(83380400001)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r893OG9ygKNzN2up24zbhYc8RInHvN2H7wU9DSFms5L3An8jdj7k2IyleZ5J?=
 =?us-ascii?Q?gv+kh5alLwdqnmPoMyzxDskJi2ErVc60dehoc1ISMxvGOVLSLKaH5awXkJO3?=
 =?us-ascii?Q?i0Yc0GYP8ljBjAR1Uj8NsTKUnzAZuuP4HmwCDNRX2nj7gXbhPGDHw6FMioTi?=
 =?us-ascii?Q?AK4bQsteq9vv+bZFRCPiPBhIHcJEDpQfv60/GeUmHs7qv0hnKqqF3f2JtzqA?=
 =?us-ascii?Q?kMWV2r+Nqu+oHTqjfKl8UgWKm4lkcXQnvbHt+9iGclelHLbbhTGDVaORoyqt?=
 =?us-ascii?Q?Bs2425H4DFyKv3a+Cja4KEcB6OZKrWbQXgzdvnZ/Pz4+GHC/F+Z8kJk88Wy8?=
 =?us-ascii?Q?AgxG+7e1WOgz1n/nJn5b+Z8DYnGN9iExi0iLGN59mSYod4jkiFS3a/mbjuvb?=
 =?us-ascii?Q?Ku+LuNOjMDr5f1UjE0p6Giejfaf1K94I+3gvw9fBYK9LCeWnVlN55ZZTl2dU?=
 =?us-ascii?Q?mj+zWThegAydK2SSlnPsYZDeY6qcS7BnDKfUO2C9yKLmCxLWd45KqkFkl3Av?=
 =?us-ascii?Q?l2YyA+K/iDF+/uDyA8K6grqr1PShymCcJU05PyBWAzBBkutI11fcFtEwBRW0?=
 =?us-ascii?Q?wml3a1cGYYFRNpinA4Q6HVOaouqu10JLezZmhcHKbvCzU/pwjBp63S8ixdO3?=
 =?us-ascii?Q?kBl88I4AGvEnJ5iB7h3qzB/4F1KalMq4lKLKGN3fg4RvFmWgaAEL1qjVc9Mp?=
 =?us-ascii?Q?3T0kfLpTduUC/r0CY4SliwdjjYLZgVdVzxGQ+agQhlVXgZrJhvGyIhw6DibF?=
 =?us-ascii?Q?0FanOExcwuQKbaW1LBI4kvBGZDrCBqdoZwznhlB0b9Dm5xHH7e1KKSeWqYer?=
 =?us-ascii?Q?oGP5AU5pD/0yWsdO79f+5jZas44+CIBZUuWuFuzwsNDbHwUsW7XbK1fKB4sh?=
 =?us-ascii?Q?EiAomwPeUmwo+NAGznQWQZoOXF7gQrYkGbET5w15+V+u1Iha6FZPQ+CTXUlT?=
 =?us-ascii?Q?SCgUdFJ1/q+u1y0jXXnP5h1t0RE9l5/SBpppGiL7OlhMaXVc8P1DYPqMXEvy?=
 =?us-ascii?Q?as73wwpyahy35RuMfz93c0xkDDeYcmd/XqE9oOXAFVa/QInpZnnoKSzivLwA?=
 =?us-ascii?Q?CAW8Wi9G1nMmoxHRlzWV/XQIawiPa8PHw6r31aboLvmjPvJiKphhO6+vF2X/?=
 =?us-ascii?Q?acwtlaLFhq6nB/8dCK2TqY+aMjnN79BbWxwS3d4CIWAocxHiqsQuIOZO2iLv?=
 =?us-ascii?Q?rrCUMAwDqN29fi83RVSPJ9YXyhybw5XWSQfrktlazCpcekJKOTOw0VlWwq2s?=
 =?us-ascii?Q?wq5pTMUuYABZSRdxMG2sxlA0VakidILJyJvYOrYR+/A6u0In1ZhD2K1YOzWj?=
 =?us-ascii?Q?y9x1YmLM/kGEuf5G5FvnqGGw9Df2PazNGnt7jGWet6gKdE51E6zmd7NoGELF?=
 =?us-ascii?Q?Wb+rlYQ9JtZuJ7vZHTbdERxp4S7jvcJy86WURJ90668nDhP2vRoByG8zPPp5?=
 =?us-ascii?Q?+Gyx4/p8hhrXp0Q0970e7C/D9NSGKWCpoWgTPvTsJUVwupaCMYTnd672vnEf?=
 =?us-ascii?Q?hQO45MLwH+gO5Jk0K5uhB1G2IAPWa47t82CIN2OVkaIKG3NkI2dok/oFQs0n?=
 =?us-ascii?Q?gDf3RqxLepKrPcLv3PlPSO2dnyW/VJRCpr122+Au?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a622565-6fb0-4c48-2d9e-08da86eaeb10
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 22:41:15.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hmqGuo5IQY/6Kbecx+DeOq6YMKU7xro6BJgjwxiZnvOgaUGrnezMDjXcUtfSpxP0cWGFz13vh8lhtoiyymwV4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6260
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


"Huang, Ying" <ying.huang@intel.com> writes:

> Alistair Popple <apopple@nvidia.com> writes:
>
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
>
> It appears that we can increase "unmapped" only if ptep_get_and_clear()
> is used?

In other words you mean we only need to increase unmapped if pte_present
&& !anon_exclusive?

Agree, that's a good optimisation to make. However I'm just trying to
solve a data corruption issue (not dirtying the page) here, so will post
that as a separate optimisation patch. Thanks.

 - Alistair

> Best Regards,
> Huang, Ying
>
>> +	arch_leave_lazy_mmu_mode();
>> +	pte_unmap_unlock(ptep - 1, ptl);
>> +
>>  	return 0;
>>  }
>>
>>
>> base-commit: ffcf9c5700e49c0aee42dcba9a12ba21338e8136
