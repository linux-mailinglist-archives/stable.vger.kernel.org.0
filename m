Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B6C64E212
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 20:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLOT7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 14:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLOT7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 14:59:45 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EC8537E4;
        Thu, 15 Dec 2022 11:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1671134382;
        bh=+8V4Xbe17KtPJZrpnDJiE7xrcUeg7ukGLgngnHFtEzE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hLTmS3Hy8cET5G/vEXbHoznchyAcWrhro1f3uhdrXrkfiXuqfzjuKBMGDc+NDbSU8
         bXYFfld0lCxVYO2VTQ3pLkB1bnKrvrLanAuE1t8bbHHyMcGkN0XIY0eoU4uPuvFYPn
         UkiDygOVbU/aIfxb0JRpUA9YNlcpast/NNuneACVLp4uQ+7dmDNSYXeHpwOnW3Nc98
         vYARm4y7r0TcIKDPcrSQstG+b4sQRkeUG0PBMtTmLb88oln7/GA5A8+JilY78Se49t
         Losshur3wV8qF8qTNBmnOU2KzHzk54dGOpOQgxU7V+DzbsU8MRY5mTMf3pRbTKr59/
         WrWc5mrbusM4Q==
Received: from [172.16.0.118] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NY33f2WVjzbdt;
        Thu, 15 Dec 2022 14:59:42 -0500 (EST)
Message-ID: <f04c3f76-9a7f-c48b-ec45-2099888016d7@efficios.com>
Date:   Thu, 15 Dec 2022 15:00:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] mm/mempolicy: do not duplicate policy if it is not
 applicable for set_mempolicy_home_node
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
 <72a402db-b156-74ff-2241-a018cd8ee885@efficios.com>
 <Y5sz3Ax+tONdWgbN@dhcp22.suse.cz>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <Y5sz3Ax+tONdWgbN@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-12-15 09:49, Michal Hocko wrote:
> On Thu 15-12-22 09:33:54, Mathieu Desnoyers wrote:
>> On 2022-12-15 02:51, Michal Hocko wrote:
> [...]
>>> Btw. looking at the code again it seems rather pointless to duplicate
>>> the policy just to throw it away anyway. A slightly bigger diff but this
>>> looks more reasonable to me. What do you think? I can also send it as a
>>> clean up on top of your fix.
>>
>> I think it would be best if this comes as a cleanup on top of my fix. The
>> diff is larger than the minimal change needed to fix the leak in stable
>> branches.
>>
>> Your approach looks fine, except for the vma_policy(vma) -> old change
>> already spotted by Aneesh.
> 
> This shouldn't have any real effect on the functionality. Anyway, here
> is a follow up cleanup:
> ---
>  From f3fdb6f65fa3977aab13378b8e299b168719577c Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.com>
> Date: Thu, 15 Dec 2022 15:41:27 +0100
> Subject: [PATCH] mm/mempolicy: do not duplicate policy if it is not applicable
>   for set_mempolicy_home_node
> 
> set_mempolicy_home_node tries to duplicate a memory policy before
> checking it whether it is applicable for the operation. There is
> no real reason for doing that and it might actually be a pointless
> memory allocation and deallocation exercise for MPOL_INTERLEAVE.
> 
> Not a big problem but we can do better. Simply check the policy before
> acting on it.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>   mm/mempolicy.c | 28 ++++++++++++----------------
>   1 file changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 02c8a712282f..becf41e10076 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1489,7 +1489,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>   {
>   	struct mm_struct *mm = current->mm;
>   	struct vm_area_struct *vma;
> -	struct mempolicy *new;
> +	struct mempolicy *new, *old;
>   	unsigned long vmstart;
>   	unsigned long vmend;
>   	unsigned long end;
> @@ -1521,31 +1521,27 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
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
> -			mpol_put(new);
> +		old = vma_policy(vma);
> +		if (!old)
> +			continue;
> +		if (old->mode != MPOL_BIND && old->mode != MPOL_PREFERRED_MANY) {
>   			err = -EOPNOTSUPP;
>   			break;
>   		}
> +		new = mpol_dup(old);
> +		if (IS_ERR(new)) {
> +			err = PTR_ERR(new);
> +			break;
> +		}
>   
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

