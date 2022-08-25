Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BE15A058E
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiHYBSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHYBSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:18:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B557B4A9;
        Wed, 24 Aug 2022 18:18:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzQNCuQQvwdSvvPZpLXrf8n6Jcgkj9K8zrKeyYLnOGbX2m2jAKd5hRcVLWeQHptW8RAi3ugM/md5lLXf5MFWVvYBH4/W7NLA/1QCn0hLca0AICxmNSAMrtp4Gd7dQ/qL5ZfcQkNLNwTTq28K6Cz9zz4nTHFOethgp2RFSebgIkLK6P0rJi2NF4OCRAiQ18cuOre4A94gpd6LJZ5qBnYdw8IbvXbQ9kpQ9I/i0nfX8pUw8xbH2ezkdcnztyk+gBiTlyj/EozeKga93e+8jygFHEWtt94AEz8ZWY/UBtAEyLC/qzhkvWB8cOYr+TZzsv8dl2M5ALs6bMP+/9IEXF+FSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kbtWYVg6y24o9bTZhF2pmpKFfOI/P54E54qIc0Gwhs=;
 b=lGNP6RUEjYuteqaykCk+LcU9G4neC5GQYdB2gvPw0Od8Z6c7z08FhDSSFgRQdj8eSB74RimO2ZEnWHPLoZoSp681PaIWfRcL+O7TuCPCnU6IE0VqLFk9Cezq2Mklvix8QRs2qSuFix9MDL+BBZ8hqSlgNgaKH+qKTvv6zMkNDLvzvbLWlIOwOanmeuhtkybBOYH6AX8KeFfCU++CSE2At9A65BGoWwV3qkpxold+FosAbmAMrYdxjBOZv+VBML7zmhecaP9rB8hrJQoGMQV3Eh4bHdZOnbcZ0x0e/UoqZvapOvxuir79XItO66TJKSjvqV53EOQ5ObRc5tdzF5fVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kbtWYVg6y24o9bTZhF2pmpKFfOI/P54E54qIc0Gwhs=;
 b=Yhcjhmm7LUVDycRi2D2QOMlzFm2HBaPrWb6NYZraaZq4KiErjEpNyA1158xQJjlUqIzH67RLjrXxXOmgfQrOXRYnE+EQMu6P3pdax+Xz4gMSOQhD3ObgN3sM4jBllGIvJjVctZbMONTAMNGhELBHG7tLuoovBBlx4jZZrb08mYOkqEWN8zigwsnLmkeMaa2xI/YgOXNz6M3wYdvWXaP/hpcVSrfjTnddPQFP7M0Fy2Ks7n2anrocX9QmcASQRUY/DM+KO0abrtF5sqrri+dc79KNFykQPUXfclAJp6kcjYDqbftf7RHfWsw3S7tL0iAm2Xy5ErDtDtW+1zYodbqZqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CY4PR1201MB0054.namprd12.prod.outlook.com (2603:10b6:910:1a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 01:18:29 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Thu, 25 Aug 2022
 01:18:29 +0000
References: <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
 <Yv1BJKb5he3dOHdC@xz-m1.local>
 <87czcyawl6.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <Yv5QXkS4Bm9pTBeG@xz-m1.local>
 <874jy9aqts.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <87czcqiecd.fsf@nvdebian.thelocal> <YwaJSBnp2eyMlkjw@xz-m1.local>
 <YwaOpj54/qUb5fXa@xz-m1.local>
User-agent: mu4e 1.6.9; emacs 27.1
From:   Alistair Popple <apopple@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Date:   Thu, 25 Aug 2022 10:42:41 +1000
In-reply-to: <YwaOpj54/qUb5fXa@xz-m1.local>
Message-ID: <87o7w9f7dp.fsf@nvdebian.thelocal>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0333.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::8) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d803f3bf-9e52-44d2-61bf-08da8637b7fe
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0054:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QiH7Nc43RZIpxMEnGZTDM3OmdpGEMXBrxoJm5uxlf5TDPj/AnsVl/X6rF8/FJTaXMKYgHJw2u9Tv62p4CG1yCEe+yhmUIY02NVZHfOmnpi1G9RwwUpm2AD7Wmy6kkUDV5C7D/RNBSGDr4aZCdVj60hK2L7eRKNtcYc3PZe5JlwWtQxPMXh3PAao4u40NoGTofctqt5QttQBiBgbQBNkQVquOW+v37iRI9SjfWh/f1EDv9ld4BmqBlSU0wCrS/M811AGsrhPwqYZyf4T4gvHu8rxM09bPuXXAJNeKrIgdy5+lySXj9GyFixLidjnHr8CZKkBf7Qfbf0gUbDNZFxt8AIZC4OpYjdy/X6/czX5FXvnryZTWOMY9mrQcWpRRNTNGIgHRDUXP06O8DrKLkFo7I8w/UkM6C+WLkx0UcY7V0MwQvqLUsowSOklEcV92gyxmz+rl25U6DCEnX0uxcpSPb2jgr1xAe5ZtOPcHa4NKrlDVmwuySLQBUVJFzi1OGjHL0GKbGZVu9Pq9rTXEBNG39/PTUmK4Tqm7M54l4h7qzeBeAh55Nbir2LXQCnHjjdPKICrVvY7Dbld2qn9P7kvzxYdzl7MgrqYtXX9GO42/LsMpd4mv0punSD+P1yYS3zsTDMjzSBVEl19Boe3m8jsoGzOVbG/0DypjaFODCIGL7fLyTBpzdI9uvj6vF+FFDOy3ayAA5GVCbQeH9Rz8smYwuS0qd9Uz7jFRcNmmvPTQ7FEMTuWZet7Nb3JTBvUH97kHGVpQnnbOrmEdIABs6q5UVEJZHDqFb0F0joKI8MpfkXCYsxGC6BawrzstBR0VCXwK5TP/YMBR2IbU9Yl/KCCRUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(83380400001)(8676002)(4326008)(66946007)(66556008)(66476007)(2906002)(6506007)(478600001)(6512007)(6666004)(38100700002)(6486002)(6916009)(316002)(5660300002)(7416002)(9686003)(41300700001)(186003)(26005)(86362001)(54906003)(8936002)(966005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yD4Gt1lYZJk33EAoutDzQgJ/QI1UXDZxECzy/0jW7uD7A6W98It0tdkRfhjo?=
 =?us-ascii?Q?GWkF1uSRF7p/4fK/ENbNDJpIo/w+Ib6toqw/jhUukx30zLvk2yd/Zry9WRyH?=
 =?us-ascii?Q?QkbcofZ6LQRf7trSaZHPBkN5bbhjtRMCV7L+Bn0DSTirzbWyLwGRtZSp2XtL?=
 =?us-ascii?Q?uJv35NM+gc+ZNl6oAOc8O1Retjx5m+KvGrfjit+GAspm5VlONGeV/TfnxhXb?=
 =?us-ascii?Q?OuA9I5xw2d5tImhvv5VlOKnZg3XjJHbnY7xpggERpthmhn4/KKLR9LRleDaO?=
 =?us-ascii?Q?+vodHgD8iGxcMoYaijG+zXWtsDZA6XX35j+C7JhQZvAwQvk3eTNQvj3/S8V0?=
 =?us-ascii?Q?3rTCX55V0a27/r9E3xO0T/ihUAdgfpSELA+7ePfnYIy0+50V1k1jDVOECF6u?=
 =?us-ascii?Q?MGvtFpIS2dOI3dlzvS58IHe7gHV+kj0IDP1n4ivVxSmjVuEw8ohUkmV2rcFd?=
 =?us-ascii?Q?4NzOCCzd50TDfuVNrn4DuNfgRWr5QNOGr6irXr8ccJ/LlpmGd75qNxbHKQwJ?=
 =?us-ascii?Q?Uj9yH6VbvlxsXSveY1plXz3uVQl1nfM2OwtwRRt3gDS37aGqcDvb3lQKRb8a?=
 =?us-ascii?Q?3cS8NnDsO5hArs9Htoglie6HLPgXoVeDI2ywAFfGElr1XKigII79un43QFCN?=
 =?us-ascii?Q?0B+GzA9XAeVId0uwN5wULn9jMZ4bkG5fEUgMyOEmSRdzeUiER3OSXb6tQSR6?=
 =?us-ascii?Q?BcNNpVZR/Jhjb3ABVV9+9/TIzrCaxc+GorpKtfhpp1ogZrP6L1It9546v1fW?=
 =?us-ascii?Q?NT091nEg7OfWNpV82lDF1QI2q2PVw//JlEJv6VO0jXKHyIHEJ+6z87oEmg4J?=
 =?us-ascii?Q?SrqGDV67GAELVMn8wNt9U+5USSGqmStMt9P8tYxtIeK1EKlvRAoA4H/JKKtK?=
 =?us-ascii?Q?z8P5BIOFqbZDY5WAvm5WLfbaVlTMWkQ//zK33YIpdxeZxhT+ct3MPw8QFDsr?=
 =?us-ascii?Q?9GHSGR1Nta8PaV7XqP3DiLGD8z925USCSBghNKPN7vil7QqWIuSIctxKBMpG?=
 =?us-ascii?Q?eFXXMrrrCKvOS3r6uTtIucBDafT8j+VP2Jgt0DYXnqS7KwPln/XoiVliRo40?=
 =?us-ascii?Q?gsavbNfxCFHtWUkFSQZX+zt2e5Mk1GwWJPuYUTVWMtJ994//GD9KqoHrMyuP?=
 =?us-ascii?Q?m2v0GBGCz1+xNArL1c3XHHCspShf9jYWWbUptQyfss3sGuGeCZEUQmOLcIMU?=
 =?us-ascii?Q?RhQSZnGs7jZmvevAtdGXUmE5SFun22w6dsLqmzw0uMO3Sgfm6XH/JOmkK6Cg?=
 =?us-ascii?Q?RkfZZX500LS5rdP+u7AbrF1Th2DrR4ibPptJ/boij9nhMuOX7e+ORdBVk11J?=
 =?us-ascii?Q?lhiloDQOeWQIBOPGNDWZXsJo3mfQG+0jHxPcDHnZPyyxeqX7fpI68u8Zc6U6?=
 =?us-ascii?Q?pJ83Fv+EimXTLIXCpYIYPfXvdH3U+YIOU4udHZzhWdcBGax/+bpLnggPcrTV?=
 =?us-ascii?Q?fSi6wvYexWtlZXQTTBhlhOV/wVAqiz2CD48Qb4ArgRXlzrxnw8ta7ebGckhI?=
 =?us-ascii?Q?W7SBtwKxyUJnpHSqaqy4HcoFEqGcdJMfACAOnfVBzX1EkR6LsrCLfp5b8d8m?=
 =?us-ascii?Q?PgV3gLCSzmQeAgXLdeYnq1V2J05qHdDcff9G4iS7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d803f3bf-9e52-44d2-61bf-08da8637b7fe
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 01:18:29.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bc2OVoeoJgLt54oIGMZjzRGJLjh+U2HppAqbGKvgdr3eiO6BcCTp48rVxaEsvZt5r8St+T8paDP2hUoYrjZctw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0054
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

> On Wed, Aug 24, 2022 at 04:25:44PM -0400, Peter Xu wrote:
>> On Wed, Aug 24, 2022 at 11:56:25AM +1000, Alistair Popple wrote:
>> > >> Still I don't know whether there'll be any side effect of having stall tlbs
>> > >> in !present ptes because I'm not familiar enough with the private dev swap
>> > >> migration code.  But I think having them will be safe, even if redundant.
>> >
>> > What side-effect were you thinking of? I don't see any issue with not
>> > TLB flushing stale device-private TLBs prior to the migration because
>> > they're not accessible anyway and shouldn't be in any TLB.
>>
>> Sorry to be misleading, I never meant we must add them.  As I said it's
>> just that I don't know the code well so I don't know whether it's safe to
>> not have it.
>>
>> IIUC it's about whether having stall system-ram stall tlb in other
>> processor would matter or not here.  E.g. some none pte that this code
>> collected (boosted both "cpages" and "npages" for a none pte) could have
>> stall tlb in other cores that makes the page writable there.
>
> For this one, let me give a more detailed example.

Thanks, I would have been completely lost about what you were talking
about without this :-)

> It's about whether below could happen:
>
>        thread 1                thread 2                 thread 3
>        --------                --------                 --------
>                           write to page P (data=P1)
>                             (cached TLB writable)
>   zap_pte_range()
>     pgtable lock
>     clear pte for page P
>     pgtable unlock
>     ...
>                                                      migrate_vma_collect
>                                                        pte none, npages++, cpages++
>                                                        allocate device page
>                                                        copy data (with P1)
>                                                        map pte as device swap
>                           write to page P again
>                           (data updated from P1->P2)
>   flush tlb
>
> Then at last from processor side P should have data P2 but actually from
> device memory it's P1. Data corrupt.

In the above scenario migrate_vma_collect_pmd() will observe pte_none.
This will mark the src_pfn[] array as needing a new zero page which will
be installed by migrate_vma_pages()->migrate_vma_insert_page().

So there is no data to be copied hence there can't be any data
corruption. Remember these are private anonymous pages, so any
zap_pte_range() indicates the data is no longer needed (eg.
MADV_DONTNEED).

>>
>> When I said I'm not familiar with the code, it's majorly about one thing I
>> never figured out myself, in that migrate_vma_collect_pmd() has this
>> optimization to trylock on the page, collect if it succeeded:
>>
>>   /*
>>    * Optimize for the common case where page is only mapped once
>>    * in one process. If we can lock the page, then we can safely
>>    * set up a special migration page table entry now.
>>    */
>>    if (trylock_page(page)) {
>>           ...
>>    } else {
>>           put_page(page);
>>           mpfn = 0;
>>    }
>>
>> But it's kind of against a pure "optimization" in that if trylock failed,
>> we'll clear the mpfn so the src[i] will be zero at last.  Then will we
>> directly give up on this page, or will we try to lock_page() again
>> somewhere?

That comment is out dated. We used to try locking the page again but
that was removed by ab09243aa95a ("mm/migrate.c: remove
MIGRATE_PFN_LOCKED"). See
https://lkml.kernel.org/r/20211025041608.289017-1-apopple@nvidia.com

Will post a clean-up for it.

>> The future unmap op is also based on this "cpages", not "npages":
>>
>> 	if (args->cpages)
>> 		migrate_vma_unmap(args);
>>
>> So I never figured out how this code really works.  It'll be great if you
>> could shed some light to it.
>>
>> Thanks,
>>
>> --
>> Peter Xu
