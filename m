Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752B664DCE9
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 15:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLOOdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 09:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiLOOdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 09:33:41 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EFA2E698;
        Thu, 15 Dec 2022 06:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1671114812;
        bh=1hQfulK9A1aJkYS8yYg0LQu+L75CXVVtpgoE15DiELU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=iORaxFcbToiCyVN/grObGSxhNyr+KeMyAxdw/OH7/FO92jimdrHIj2b/CBCnC0sxX
         ZfzvXsOlFPGuQsYEikSAZ/XGzlYwrWYc0Xd7n1hzSPh0kOxJgQ5g9Z66A9YVnphyRq
         tdg0JHeqGjE7ok1NWIfL+y5nadhdbZINvpzsjB/4Fiq+8M7Sm7GPWI4ODrjBb5q/OG
         faQqgD9FwXWWBiEo7rE+ouPw94Sg4QUSFguEKIbGriApXVsDp+jpLcnzNY65Xh+555
         Ejxt6xBDigAkGav3ycnt5R7c6BzDpYXLtl0ZP/bLprRUk4ABnwW6rlyscmoSXXx4hL
         fB6q7L8EWAAJg==
Received: from [172.16.0.118] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NXvqJ1M1wzbKV;
        Thu, 15 Dec 2022 09:33:32 -0500 (EST)
Message-ID: <72a402db-b156-74ff-2241-a018cd8ee885@efficios.com>
Date:   Thu, 15 Dec 2022 09:33:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC PATCH] mm/mempolicy: Fix memory leak in
 set_mempolicy_home_node system call
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
 <Y5rR9n5HSvlATV5A@dhcp22.suse.cz>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <Y5rR9n5HSvlATV5A@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-15 02:51, Michal Hocko wrote:
> On Wed 14-12-22 17:21:10, Mathieu Desnoyers wrote:
>> When encountering any vma in the range with policy other than MPOL_BIND
>> or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
>> on the policy just allocated with mpol_dup().
>>
>> This allows arbitrary users to leak kernel memory.
>>
>> Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>> Cc: Ben Widawsky <ben.widawsky@intel.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Feng Tang <feng.tang@intel.com>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: Mike Kravetz <mike.kravetz@oracle.com>
>> Cc: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Huang Ying <ying.huang@intel.com>
>> Cc: <linux-api@vger.kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: stable@vger.kernel.org # 5.17+
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks for catching this!
> 
> Btw. looking at the code again it seems rather pointless to duplicate
> the policy just to throw it away anyway. A slightly bigger diff but this
> looks more reasonable to me. What do you think? I can also send it as a
> clean up on top of your fix.

I think it would be best if this comes as a cleanup on top of my fix. 
The diff is larger than the minimal change needed to fix the leak in 
stable branches.

Your approach looks fine, except for the vma_policy(vma) -> old change 
already spotted by Aneesh.

Thanks,

Mathieu

> ---
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 61aa9aedb728..918cdc8a7f0c 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1489,7 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>   {
>   	struct mm_struct *mm = current->mm;
>   	struct vm_area_struct *vma;
> -	struct mempolicy *new;
> +	struct mempolicy *new. *old;
>   	unsigned long vmstart;
>   	unsigned long vmend;
>   	unsigned long end;
> @@ -1521,30 +1521,28 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>   		return 0;
>   	mmap_write_lock(mm);
>   	for_each_vma_range(vmi, vma, end) {
> -		vmstart = max(start, vma->vm_start);
> -		vmend   = min(end, vma->vm_end);
> -		new = mpol_dup(vma_policy(vma));
> -		if (IS_ERR(new)) {
> -			err = PTR_ERR(new);
> -			break;
> -		}
> -		/*
> -		 * Only update home node if there is an existing vma policy
> -		 */
> -		if (!new)
> -			continue;
> -
>   		/*
>   		 * If any vma in the range got policy other than MPOL_BIND
>   		 * or MPOL_PREFERRED_MANY we return error. We don't reset
>   		 * the home node for vmas we already updated before.
>   		 */
> -		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
> +		old = vma_policy(vma);
> +		if (!old)
> +			continue;
> +		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
>   			err = -EOPNOTSUPP;
>   			break;
>   		}
>   
> +		new = mpol_dup(vma_policy(vma));
> +		if (IS_ERR(new)) {
> +			err = PTR_ERR(new);
> +			break;
> +		}
> +
>   		new->home_node = home_node;
> +		vmstart = max(start, vma->vm_start);
> +		vmend   = min(end, vma->vm_end);
>   		err = mbind_range(mm, vmstart, vmend, new);
>   		mpol_put(new);
>   		if (err)

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

