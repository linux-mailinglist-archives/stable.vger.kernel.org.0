Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98CFC6CB723
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 08:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjC1G1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 02:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjC1G0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 02:26:42 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709EC5273
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 23:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC2qo2y33AauT0iQmyCA30GXkJhn5bhl9YcfWkaMBqG9btrYayWwTGQz+iXB+zoxv4foaALy6EQ4QyOFZmNvSbRASQkzA61/+sthUK9c1NsnUvi6cLCNu+fqAKUSFLpjEyZOj7nKkw1HcuLsslxuBzb78EenYPJARBdO+07MnxEEgSFLJiA3i8VccQqYBSJtNA23nPeftWurvYlxRAmLoafEGTAtgwD5nnbTulTG4TisfH7gWVuTMFemHTsC8nVrXma6oEeDSjoIDDq0Aanm9os66FDFihQtkI3n5LOU+kHaRI9zDqSJyV8mood+UlkTghQ9UX2b8TLoqPMInOrnYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpF3+qy6jfyQFV+3weve7RSDecBFU7BFMMViU38xUvg=;
 b=n/LOzjOe6QlbELyDivSm9/EH5WF1PQQqfAD6Tmzdh3K9GELh90C/oCBosRwKoKVMSM/6Y0OV6k2EuEF9OuU6KCf3+UZeHzvo3fgC6BQQFCjgMC1OcABks8+Fk3dlipC3NT5DyfJK/qFGmoXNSw1hrKmcdlBmY2NAQzpUPyWbFieDr6xF4lXUXdrbJOAfjSk5aNJ/GLqltkQFPxX4K+lWKJBxxvmv+Zzi2a993DEt34XJRKjB79gy2njFqk1TfleKAJB/uKZvmCmYk8ctEN7VI5CkU/li5GO3ydxeSLhl7jsnfGflYgm3SfJoMWy8wiWwjIAAFI54CsUDmbChDtwGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpF3+qy6jfyQFV+3weve7RSDecBFU7BFMMViU38xUvg=;
 b=K23JKNDBcaTKhlnAXsvh+7K33/3AvVZe6yc+oqNs0IHVdEuMuTPFzBZZSwp/52/bwww4fLPZPtOuVWwVcM87iQR2HZIzU5dE/cTFxgxYVNoflhF8d1uzHm4ElsrX5r/nhhFSYwkUXZsyXoTFWUJv0lbb39BTWgsiJPZ879QudIFOX2lnO6zpnXbl9AE9hq6PKgrZwRrZNVulR8sZ9Q6ppJ/GlTtRH5igtZ/HlwbowKSSwlielBPpMAMivxPGAF0PQEmTMdPHOSrfFjMFAcqhiuCKWMv4cqwr+kO/ZlyGoXiQIgvh01eUjzUWB2h6Is+3g4DHuIeAsDf9kT2z2OkQCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by SJ0PR12MB7007.namprd12.prod.outlook.com (2603:10b6:a03:486::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.26; Tue, 28 Mar
 2023 06:25:50 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::2dea:daa3:6051:1f43]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::2dea:daa3:6051:1f43%8]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 06:25:50 +0000
Message-ID: <538f85fc-3cc7-de5c-131e-ba776d5f35b5@nvidia.com>
Date:   Mon, 27 Mar 2023 23:25:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] mm: Take a page reference when removing device exclusive
 entries
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
References: <20230328021434.292971-1-apopple@nvidia.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20230328021434.292971-1-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::19) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|SJ0PR12MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f846ee9-7a61-4d88-2655-08db2f55469f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bxPs4V2DYGmp/8HlFc+hLr7BZwRqfnPbJKvyCDHC56PnZB9pIMmtV9eYhxRHK9Xl1m871Fky6N8iijMMPqDiJMyQWh+r43aZSc0t002PinBGSmEtesDQx7AJhoepDxrkTZRo3v3ckjsehe/imNUqxCm8riY5btFDIu3BhERXtDZHMx5ADFmspccDUwnWCICBX/HbS0zoWpGko+/4UaNHIr9MqYO79QX76Gpczt7Mf3F9Y8pfFg8AGP4VRulIY96sjQO9/A2Oiv46NwgigDeNqSfX4L/ZmUbYePS8wO5lu3sIrf/fhRmFfTOWlQ+GG2PUaoBjJn9Q2ArQ1By+Np0vf6DSPTniqXYFUPtv1ZfgbdZ0MDiXa5zGsTatXU6WSE1Nk74FCy37hYj8zEF9TxWTfwT/eFLNWOxXmBE7LqEyWJhYiCd9dvqv3LMRGQrC1NrvNthXpz4bco1snXIBEyfPypQWrFBa3NoFsvPVgH8J3Ggpia7FyVMf+umlpIFiFIO5QBKebD4SAXGIJ7Z6dezTCK/KOfTmsoF9QMmSDB9Rrcy+llbSdP57krCVWr96Nh4MhjoTvw2haQjlFOiNDkPbwlfqu9Su2w1sJNVj56mi3fqJ6Fp69OaSUGHu2UMLh4mg0G1wTVTjGEQthxS3pNEaVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(478600001)(66556008)(66946007)(38100700002)(2616005)(26005)(8936002)(5660300002)(36756003)(8676002)(31686004)(316002)(6512007)(86362001)(4326008)(2906002)(6486002)(83380400001)(41300700001)(31696002)(66476007)(186003)(6506007)(53546011)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHVsaFk1d0xudEdGMFQvdnpiK2NVMXg5eGlUZHloVjNQUm16UVR5U0pSREhi?=
 =?utf-8?B?cHZ6SFg2YXhpcEJsS0tGeDgrbVBYbHVlVWQ4MU4vbDVXS1dLbDdnTk9Gd21K?=
 =?utf-8?B?TE9RQjR0MGFwTmtrQXIxVkN6WnZGQk1ReWJYbGxKWk1nNmxZQ1N4MkpyOFlZ?=
 =?utf-8?B?V2p4VVdtbHJpeS9CcjRPZktGTkVrQlVGbXZQL3VZRWhsTDVHTEZkY1hwZHJ1?=
 =?utf-8?B?bVdFdlphT3JJdTdMWEpueEEvSENjRGpvTEx0b2lJTTlYeEdqc05UZktBN05Z?=
 =?utf-8?B?aUxSMnpRa0x4YjVNS21oR1pjdWVTbUN0ZXNHYzE3dkVvNVUvWTU0TUFEZFZV?=
 =?utf-8?B?YVUzcnczTWlQNm1CSDNwN2o5SjM5UlFjRHE4RW9odWlnNUdtN3RWQXVYaVpW?=
 =?utf-8?B?Unp1SEVJVnJBSlZtNndkUDFuMFJHUDc5M1JkeGZmU25ndnRTa1VtZGJmVkxa?=
 =?utf-8?B?elhyZlV5clFQdjdEcTRQdTRuYm5aNkFSVlBDVWFONFp4ZjZsRVBXdm4xejlL?=
 =?utf-8?B?Q0xlYytybEJNMjMyVUlZMzBaQnV0ckxMTHZNMmNhWUdFRnZzVmZaMHFyTXZu?=
 =?utf-8?B?cGdLak1FRnlSRVJIdTV5alcxZmlCZUJpellpRFNMYmc0Y0VIU2xCdnpuRzhP?=
 =?utf-8?B?eGlqTE5Fa2wwUDdBa25FN3hnZ2lEWTFWT3kveUhnNXJjUHhXUExaZEYwSVMx?=
 =?utf-8?B?NlhPUDdmdW5HMnFMQnRDVGxrdk5vblh5MWt3Sm83VzN1NGVsNVV0QmthVk0r?=
 =?utf-8?B?K3JiK0hBNUlsa2I3SkZ4cjZ6VUd1T0NqanFHeTFZS0M4OWw0VVhnRjBHNFRP?=
 =?utf-8?B?K3JQR3NmaUNyaVVFcFZ1K0xsTEtpc0RGb21nblhUeENaVU80ZUI3c0RLcm9p?=
 =?utf-8?B?VXZuempXOWl0akRZWUFkaE9QV2pxZEtnREZSdnFPZjRLaWQ2V3VFQ2gzSzU1?=
 =?utf-8?B?YnBlMkRqd1BFdDVqbFQ5Mm5aMDllOXRpMWNIZUNjYVBsWkhUYlFOUEw3UDFD?=
 =?utf-8?B?RjdrZlhrVUZHMHRld1dFOVNFVEI1anh0b2JkNGM1WWFtQjQzYkVScHBGZXJI?=
 =?utf-8?B?ZU91TVQvUXRJSlNTTktBUzBuR21Kbm10UTRnbUxQQjR0NkVZajI5L1VKYlBR?=
 =?utf-8?B?eDV1TXlQbVY3dEd1VktLbGtwanNma3BiY3A4d3lHaUROWm1vem9pdERWUjBz?=
 =?utf-8?B?NHhTV1lSU1IzM09tMzh2K0p2Z1drTnFqbi85WHd3aUJpa21kOTRXWjV3TTNq?=
 =?utf-8?B?aW5IUHVya04vamIxOVZValNRWGhuWVhRbHlkKzYvemJvYXMzRmFKSjVFT0xV?=
 =?utf-8?B?UlN5MFJlbVlETVIwYmNOa0RMTitKT0xIc2lTeGl3U01MVVZnbEY1VTRIcjcv?=
 =?utf-8?B?cjd5QnJCdzFwbWxoMDhxM3F2WVl6OG40Y2lOZDNhNkc0RzVmb2xVTWYwOFFs?=
 =?utf-8?B?eUVMK1FNUE05Z1o2MWlGTG5lQlFheHpVS2JITDFnVHpLVGd0eXJtQzRJNDJ2?=
 =?utf-8?B?RzVjUVdQaEhUamZnUmZ4R1F5MjBNNk1GTXBkVkwzT0IyZG1pT1BBMFlPajY3?=
 =?utf-8?B?cWRNaVk4RE1mR0UraEViSUc1WDF6Q05FekpvTFc4WHoxMUYzWVJ1VFc0c2ty?=
 =?utf-8?B?UDhTWFo0R0E1R0FTRVBDeHBqcUNRclE1eWVmcnVFNE1iZFNUZWVTbjJJcUZH?=
 =?utf-8?B?aUUxZUdFZWtacFlzUWV3UWhrcmhJeWQ0Y1BYUUdvZHNJcFg0RFBNOFBEVjN3?=
 =?utf-8?B?WjBQbE9RVThIMzEzb2VsVkFubzZwNDU4ZHZISktPaFhaV1BlYmJzbzhXcXA1?=
 =?utf-8?B?Y01pOVk2bWU1czlnTkpRTTFXb3Y5REhTRjFFR1JObGdmdEk5cVZ1WnlhTlRQ?=
 =?utf-8?B?cjBZcDhkSjk3UUR3bVVuemROZ3FlbXoyc1hBSXEyZjloV2EvMXp0UmxUV09z?=
 =?utf-8?B?WGZBV1NCQVBTck1XRkZvV3ZZcFB2cmlZcGdlVzVOUnlrV0lBL1B3TkQrYXND?=
 =?utf-8?B?Mm84WnhsU2k0ZGNuMTRvbnFPQmczelVlY0VKSmh4MjFVYytjckQxQ0l4MVVn?=
 =?utf-8?B?WlMxWFhzL0pnYy8wUW5sOCtVSkgreHBDZlB0K2ErQ3FDQXMzbHIzRW1Ga1pX?=
 =?utf-8?Q?9tH6ha/lrgcLyB4w0XY02OYbk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f846ee9-7a61-4d88-2655-08db2f55469f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 06:25:50.7521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfkHawQXIF0GU/zDWV8hHnlP4ohKg+vyr2sRuYpMFqS9A2IChA6zlMpZTlxN12UWXVwcdU5ndTjc61rFsi1ofw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7007
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/27/23 19:14, Alistair Popple wrote:
> Device exclusive page table entries are used to prevent CPU access to
> a page whilst it is being accessed from a device. Typically this is
> used to implement atomic operations when the underlying bus does not
> support atomic access. When a CPU thread encounters a device exclusive
> entry it locks the page and restores the original entry after calling
> mmu notifiers to signal drivers that exclusive access is no longer
> available.
> 
> The device exclusive entry holds a reference to the page making it
> safe to access the struct page whilst the entry is present. However
> the fault handling code does not hold the PTL when taking the page
> lock. This means if there are multiple threads faulting concurrently
> on the device exclusive entry one will remove the entry whilst others
> will wait on the page lock without holding a reference.
> 
> This can lead to threads locking or waiting on a page with a zero
> refcount. Whilst mmap_lock prevents the pages getting freed via
> munmap() they may still be freed by a migration. This leads to

An important point! So I'm glad that you wrote it here clearly.

> warnings such as PAGE_FLAGS_CHECK_AT_FREE due to the page being locked
> when the refcount drops to zero. Note that during removal of the
> device exclusive entry the PTE is currently re-checked under the PTL
> so no futher bad page accesses occur once it is locked.

Maybe change that last sentence to something like this:

"Fix this by taking a page reference before starting to remove a device
exclusive pte. This is done safely in a lock-free way by first getting a
reference via get_page_unless_zero(), and then re-checking after
acquiring the PTL, that the page is the correct one."

?

...well, maybe that's not all that much help. But it does at least
provide the traditional description of what the patch *does*, at
the end of the commit description. But please treat this as just
an optional suggestion.

> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
> Cc: stable@vger.kernel.org
> ---
>  mm/memory.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

On the patch process, I see that this applies to linux-stable's 6.1.y
branch. I'd suggest two things:

1) Normally, what I've seen done is to post against either the current
top of tree linux.git, or else against one of the mm-stable branches.
And then after it's accepted, create a version for -stable. 

2) Either indicate in the cover letter (or after the ---) which branch
or commit this applies to, or let git format-patch help by passing in
the base commit via --base. That will save "some people" (people like
me) from having to guess, if they want to apply the patch locally and
poke around at it.

Anyway, all of the above are just little documentation and process
suggestions, but the patch itself looks great, so please feel free to
add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 8c8420934d60..b499bd283d8e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3623,8 +3623,19 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct mmu_notifier_range range;
>  
> -	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
> +	/*
> +	 * We need a page reference to lock the page because we don't
> +	 * hold the PTL so a racing thread can remove the
> +	 * device-exclusive entry and unmap the page. If the page is
> +	 * free the entry must have been removed already.
> +	 */
> +	if (!get_page_unless_zero(vmf->page))
> +		return 0;
> +
> +	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
> +		put_page(vmf->page);
>  		return VM_FAULT_RETRY;
> +	}
>  	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
>  				vma->vm_mm, vmf->address & PAGE_MASK,
>  				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
> @@ -3637,6 +3648,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>  
>  	pte_unmap_unlock(vmf->pte, vmf->ptl);
>  	folio_unlock(folio);
> +	put_page(vmf->page);
>  
>  	mmu_notifier_invalidate_range_end(&range);
>  	return 0;


