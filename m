Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C549581B6B
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 22:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbiGZU7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 16:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiGZU7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 16:59:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC88839BA9
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 13:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QAnvL5oncRdjzvBQjlGnzs2EEMrRWNPr9X8Sxhe5tvEAm5kaoSwoDsPxw2UmoHkCtYWjDBTn1P/FNVsazean+2Q3aS9Qi02ueJ0J6As+iXXBPwUM45cpKuJkH8KicfH/Wy7kuRArCiF1pGxZpczdBiwrTgkGNyeYWpZ7iBSa+L3vG9++h/ZCC7IoTmZkCyR2wA7JHGMb2uT7gfjBItyJe4O3eXdBPjiXSYgQvn4WjV3YG2DPpT7NJpuHcF8KPi0bBOQdJmdmE3Z3MQSGolc+otR6GQT1ZWWJUrLBDR2HsxU7o0wKWcWL9lUFpCPmfX5OjXvJIgWAa1NeqojsCLUuRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHsU0PFk8YfYxbklCSLlCXmyuVdNEJrCtdAB3lsHLa8=;
 b=iST9bPPSRUdgh83Pb7zTMT3Dqu4bRp39JgDUtzqceM8kqKZlEihqOYSuvmt9VMVmmhV0/9O70iWvIrY7x3Cy349hSF/F8DiDg/BxHmqMqNtzH25KoSUyrgj9PPRcCdvID0aXk+Kjn20w9znIiE78s/utNcEuHpcjRxo/mW2UEMOFjN8H9z6sgHZc36QBkYdwGUNFY5SntORO+huMvo4Fcw/UKD3l/PQfU1PaEcEz4ei8zk5ECO1oqXX+xIyt85l+HmDwoYvawdfSd7TErM38Grd6kY0A2VPHBlphlhh1AxM7DKr0lOuk87zmuVeaUad9hJwaE7m6Kl7DP1htsyjvGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHsU0PFk8YfYxbklCSLlCXmyuVdNEJrCtdAB3lsHLa8=;
 b=rWDMWnIcQNn+c6/9umy8O4dvMD3zoAIxcfjX7U5bUXEw805aM19f9SO09pUnA4b36QAfnNCtC1mSQbogP+NAryUgbj01Scr1eOdk7N94nAlkFS5OtrZnR+taRNvE9WGhHJlzgOUzfPMds4TtzgEJ1VrS6tYrpVjEbw3gFI2FCJyMG1gN+XCVgyvtu36Qo5gVj6CL9pWgaR5cAZflAq+jiREjs9LkH7KEmvHipck2QImao06s6vrIDyCjnexjx4grMKZrqGz/p388Eo8qU/YgifCqeD+LJwfi3YSU5WpnWpiVQXskgZYh4WjpJoC1Y1+GA5Oh4mgvD/DSQzKAfkL2ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BN8PR12MB4787.namprd12.prod.outlook.com (2603:10b6:408:a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Tue, 26 Jul
 2022 20:59:09 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::ad32:9c8c:9142:df53]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::ad32:9c8c:9142:df53%4]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 20:59:09 +0000
Message-ID: <e70ef86f-eb72-0fd8-9ed9-fca267cb1c26@nvidia.com>
Date:   Tue, 26 Jul 2022 13:59:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/2] mm/hmm: fault non-owner device private entries
Content-Language: en-US
To:     Ralph Campbell <rcampbell@nvidia.com>, linux-mm@kvack.org
Cc:     Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20220725183615.4118795-1-rcampbell@nvidia.com>
 <20220725183615.4118795-2-rcampbell@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20220725183615.4118795-2-rcampbell@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63c038c8-d3b1-47ba-4b52-08da6f49af2b
X-MS-TrafficTypeDiagnostic: BN8PR12MB4787:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koJS1MMlKDz30LfpBtV6sEIgxIqdckNxyzr7Mi2eO5Mk6LpYvWGa/+o+NxscTHLTESs6krYzb+UI5LjgI93wqGDsra66d9BemAIPrUlUU1PCyqOIT0Z7wPdI+7fWvY/WClRNC+6VuX7G0Y6D16xGK8dx16kjYOg5W21Ghee6tew/un9H6bhhcEuRTJikaFy+xm234QV4u86xmTUBqyThsmRoxQFSrTg5jTxhp/apgh1H9wkkIj95xCr3aCuDuSY1ZnZtTVwbxa9j5fHodiOKwJFuWFpQQ0A2hzFiHmZC3NMwoOQWyCimaQ/o476+zgbzHbBeC+A3IwxZ9Dx2BjYv1pJyi0F4GQ8NzYNaTmFGUqsgg1R/4q+S09Y4Mznhi/k2S//8EqJzXJJVgKeQBBrc7SMHa0Gwbcc4W+Et7JKmJ9fn5WV5rL7oKp5wL4WwCkX/NGZan1DKI967712RcyzELLNPWwUZ/GvmSA1+RSnEGEPGd3/8A+FdXFKSbcsd69golKhIY9Ao1eyJem+5W2LDaH/dreHa/uvKC6SlMnLE/pvHGCLpDkgqoR8up6lLIiJtZxrIrTf4xvrgSPSc15i7JZIideG/WjFhfvI0isLDCjo2rCT/6pp+oFgj6qpgwkpUQhWJxluC66I7UvvkRK3nYs3yWuDC3L8wcu9NdLHQFE32wwF4WjN3SdmCv47Kr9bCzR6AyeNkpFMByaQop5NEG01xiWgvK6sl86pfWEnx1EK34p1zr5EBN3v1HgyKQ9qFWw171uK3uiTQAcB1Ulp8rvuUOlUeFlH7s/ZPNfnluJZhZZVvDb3NifT8o1kpAAc1tpcGcuVb95dEBOmZl+FyEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(2616005)(316002)(8936002)(83380400001)(36756003)(41300700001)(31686004)(2906002)(5660300002)(38100700002)(478600001)(6666004)(6486002)(26005)(54906003)(6512007)(86362001)(31696002)(186003)(8676002)(66476007)(4326008)(66556008)(53546011)(66946007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVczbkdTeGJ1b05SeFNxSUNSNVpMTFpBNUpZMGdVYTZJRitGaFhjZm1kRWtU?=
 =?utf-8?B?cTZQa08xd2Njdlg1dzZZdWxRbWY3b2thS0ZDK0MvMk9kRzNGVGVJWCsxaFRV?=
 =?utf-8?B?b1pRdTV3RmxJRGp3S2EvQTZrNTRhQTdLNWdxdVJNZ1VPTjZRRGxaQjNwWVVy?=
 =?utf-8?B?b3BWSFdkbVhUeHduQVpDMmQ1aVZsSTJvK0htc1ZSQ1pjSW9qeW9KQUgyOFVy?=
 =?utf-8?B?eEthT2o5WmczdldTVG5kcktkYS8vZnRHaUc4SUdwd2N5cTlFNUdQR2hoaEJo?=
 =?utf-8?B?czY2VTFVdnpmcTF0OXpVdHIyZE4zbklTbXB1UU43bGJBNmRNRTZrRjNvcDBi?=
 =?utf-8?B?aEEwRWxTeVh6VXEydEV0OFBGcmxkeDRWb3JXVWJTbFNob3VLcHN5aEJ1OEpv?=
 =?utf-8?B?SkFmTHFUNmcrZHJPM05kVW9iVWR1U3lZRFptckNkTFJvY2FEZnlEU1M0SWhq?=
 =?utf-8?B?bVltbWUyR1FnVE5hU3RkSWRBa1A1Snl4RzJLT3B6TXNVU0Y1OUFSUFBMTTNo?=
 =?utf-8?B?MGRONXpycWtNRG9FcEpzM0NDV3ZVd2wySDdXTnprbklWS1VTK0hTYXdLcER0?=
 =?utf-8?B?eTd4RlpOd0pqa25qM2R3QStzelorZnM5c1FBQ2NUZzEvbExWcmhKVEx3L2VQ?=
 =?utf-8?B?djhLK1RyOVpBSFNlaEN4ZEk2U3lxekFha3kva1lGekJrRE4rQW5RdmlvMG1G?=
 =?utf-8?B?bHBDdC8rL2tFcThyamo1RWJ4SDk4WHZtTXNXR2Q3TFF6WE5KcTFpMFdDY0l1?=
 =?utf-8?B?TGg2eHU1TlpZS3FvQ0FRbFR2R0EyMkRMR0VnWldQMHJaT0E4TEF5WVpzZ0I5?=
 =?utf-8?B?M2RDTUdzbTVaL1AwdlpTait6Ukc3T3BYNVBldUx3M2szVnB2SEs0MDUxWTRs?=
 =?utf-8?B?VWdEVFJJWERuOGhpakJraXozcWlEYlpaL3EwRDVtd1IzZnlIQm55cWRIQ1ht?=
 =?utf-8?B?dFZxVXo5ajNJY1dBV0t0elJlQ0pJb2E3ZG9uQVZvVVFqRUR6cG5oeW1Ramhx?=
 =?utf-8?B?SGd6R3I3QTIvTnl3bWhJVnNQYU50Yk1tOFhyWlBYako2WHFaZmdJdmhOUVZN?=
 =?utf-8?B?SEQyNSs4VUhXa3p3UlMxSFpSM1o0TnY0UG9oTURzTkVjRzg0QTFzREpFUGY3?=
 =?utf-8?B?T05JV0xaenVFeHVqalhEM1FYQVVDNkZVRGlsRFNBc0NDeFNWNmJnYyt3MFpi?=
 =?utf-8?B?aUtsZER6Q3ZuSzFZK3NhR3BkRjhWRzdqRkgrOVFYb1pQdVhhbEFJM0hlblI5?=
 =?utf-8?B?R05wOVl1Z3A2WWFUakZ1SzVuUnJnRks3SGlrT0psT002aE9oQVJaWGVydEpT?=
 =?utf-8?B?UVJCWTJUWGh3R1hwQmlvMUpnd1FreTNhYWE3K0pzNDFNSzFhbVVmbnB1a2tX?=
 =?utf-8?B?SFZvVWJwdTdEbDBJNzA2MHFDK2FTR0g5ZktRenJlNm42TzFhRDhHakxZZVQ2?=
 =?utf-8?B?TUhQVUR1bmg0cjFYNWFIQlh3NkFlVzR4bDNYV2dZZnhjcWV2RUVDdktDeENs?=
 =?utf-8?B?Myt2aVBNK2R1a2RBSXJ5Y2VNUTFMelpxbE0wQjU3U0VKM3EvdWM2Q2w2ZHpv?=
 =?utf-8?B?TS9aWFptdjlLNmJiZmRyeHN2M2JOVGd0Q0xxcGNLOW1nUEpHOGV2TG1NbjBh?=
 =?utf-8?B?cEw0SU9WWi9SNmI1emdYcE1ZWmliUXRTeE4yazBLZlB6LzUyM00zeUFPK2tL?=
 =?utf-8?B?SjBYQmlLdEFqcUE1TFJGM3BZa1FVUGlmVUVoTlhvSkpJQ1pnWXN6S1gxUWJD?=
 =?utf-8?B?N2ZRb2ZTcDdlcS95NW5QT0dMcmM3RDNzYk1MM2dXdjJtYkF6cVlLZ2FtbHFp?=
 =?utf-8?B?QlZXSjJPdWdtUG9POHF5dk5VeThhZHBGa1kzc282aHlKVVIwNjJHeTdRV0lS?=
 =?utf-8?B?Z1FSV1FubUVLc0twdkV2cWlVaDV5MjZsQ2svcytJdHZ5OWhHalcyS29MVXUr?=
 =?utf-8?B?Zk1rbDh2WlBYK1FRSHEvS2g2ODFUdklsd3hnSmN5RWYwMk9jTFlTbjFEK0VR?=
 =?utf-8?B?UzVYRlNuUGo1RTR2Smp5Vjdxd1FQUW9TTTk1U3dEZE9OaE1LWlF2c1ZvbGNF?=
 =?utf-8?B?VTBOSklJbWVDaFoyNU1lSG1SSHJBM1NVMVZtTUR3R1VlK3M4T0FoRzR1YmJN?=
 =?utf-8?Q?6aMULMrUk1suYQEavva/t+0wn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c038c8-d3b1-47ba-4b52-08da6f49af2b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 20:59:09.2855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HW4t6u+IbQvlumBi8FjFBIpw0SW96fdORICaZCtm02EHm6rrQnizxr7LRGIi92NMzL3hcal2qXX40CLxfnbcGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4787
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/25/22 11:36, Ralph Campbell wrote:
> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
> device private PTE is found, the hmm_range::dev_private_owner page is
> used to determine if the device private page should not be faulted in.
> However, if the device private page is not owned by the caller,
> hmm_range_fault() returns an error instead of calling migrate_to_ram()
> to fault in the page.

Hi Ralph,

Just for our future sanity when trying to read through the log,
it's best to describe the problem, and then describe the fix. The
text above does not makes it quite difficult to tell if it refers to
the pre-patch or post-patch code.

Also, a higher-level description of what this enables is good to have.

thanks,
-- 
John Hubbard
NVIDIA
> 
> Cc: stable@vger.kernel.org
> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reported-by: Felix Kuehling <felix.kuehling@amd.com>
> ---
>   mm/hmm.c | 19 ++++++++-----------
>   1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 3fd3242c5e50..f2aa63b94d9b 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -212,14 +212,6 @@ int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>   		unsigned long end, unsigned long hmm_pfns[], pmd_t pmd);
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> -static inline bool hmm_is_device_private_entry(struct hmm_range *range,
> -		swp_entry_t entry)
> -{
> -	return is_device_private_entry(entry) &&
> -		pfn_swap_entry_to_page(entry)->pgmap->owner ==
> -		range->dev_private_owner;
> -}
> -
>   static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
>   						 pte_t pte)
>   {
> @@ -252,10 +244,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>   		swp_entry_t entry = pte_to_swp_entry(pte);
>   
>   		/*
> -		 * Never fault in device private pages, but just report
> -		 * the PFN even if not present.
> +		 * Don't fault in device private pages owned by the caller,
> +		 * just report the PFN.
>   		 */
> -		if (hmm_is_device_private_entry(range, entry)) {
> +		if (is_device_private_entry(entry) &&
> +		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
> +		    range->dev_private_owner) {
>   			cpu_flags = HMM_PFN_VALID;
>   			if (is_writable_device_private_entry(entry))
>   				cpu_flags |= HMM_PFN_WRITE;
> @@ -273,6 +267,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>   		if (!non_swap_entry(entry))
>   			goto fault;
>   
> +		if (is_device_private_entry(entry))
> +			goto fault;
> +
>   		if (is_device_exclusive_entry(entry))
>   			goto fault;
>   

