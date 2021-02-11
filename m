Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED24A3188C9
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhBKK4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:56:12 -0500
Received: from foss.arm.com ([217.140.110.172]:49784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhBKKxs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 05:53:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BD7E31B;
        Thu, 11 Feb 2021 02:52:43 -0800 (PST)
Received: from [10.37.8.13] (unknown [10.37.8.13])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE4FC3F73B;
        Thu, 11 Feb 2021 02:52:41 -0800 (PST)
Subject: Re: [PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero
 page
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Luis Machado <luis.machado@linaro.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>
References: <20210210180316.23654-1-catalin.marinas@arm.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <aa94d2b9-d2f1-04fd-7cfe-8a1ab078e5c3@arm.com>
Date:   Thu, 11 Feb 2021 10:56:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210210180316.23654-1-catalin.marinas@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/10/21 6:03 PM, Catalin Marinas wrote:
> The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
> page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
> page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
> -EIO.
> 
> A newly created (PROT_MTE) mapping points to the zero page which had its
> tags zeroed during cpu_enable_mte(). If there were no prior writes to
> this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
> page does not have the PG_mte_tagged flag set.
> 
> Set PG_mte_tagged on the zero page when its tags are cleared during
> boot. In addition, to avoid ptrace(PTRACE_PEEKMTETAGS) succeeding on
> !PROT_MTE mappings pointing to the zero page, change the
> __access_remote_tags() check to (vm_flags & VM_MTE) instead of
> PG_mte_tagged.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Will Deacon <will@kernel.org>
> Reported-by: Luis Machado <luis.machado@linaro.org>
> ---
> 
> The fix is actually checking VM_MTE instead of PG_mte_tagged in
> __access_remote_tags() but I added the WARN_ON(!PG_mte_tagged) and
> setting the flag on the zero page in case we break this assumption in
> the future.
> 
>  arch/arm64/kernel/cpufeature.c | 6 +-----
>  arch/arm64/kernel/mte.c        | 3 ++-
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e99eddec0a46..3e6331b64932 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1701,16 +1701,12 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
>  #ifdef CONFIG_ARM64_MTE
>  static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
>  {
> -	static bool cleared_zero_page = false;
> -
>  	/*
>  	 * Clear the tags in the zero page. This needs to be done via the
>  	 * linear map which has the Tagged attribute.
>  	 */
> -	if (!cleared_zero_page) {
> -		cleared_zero_page = true;
> +	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
>  		mte_clear_page_tags(lm_alias(empty_zero_page));
> -	}
>  
>  	kasan_init_hw_tags_cpu();
>  }
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index dc9ada64feed..80b62fe49dcf 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -329,11 +329,12 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
>  		 * would cause the existing tags to be cleared if the page
>  		 * was never mapped with PROT_MTE.
>  		 */
> -		if (!test_bit(PG_mte_tagged, &page->flags)) {
> +		if (!(vma->vm_flags & VM_MTE)) {
>  			ret = -EOPNOTSUPP;
>  			put_page(page);
>  			break;
>  		}
> +		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
>  

Nit: I would live a white line before WARN_ON_ONCE() to improve readability and
maybe transform it in WARN_ONCE() with a message (alternatively a comment on
top) based on what you are explaining in the commit message.

Otherwise:

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

>  		/* limit access to the end of the page */
>  		offset = offset_in_page(addr);
> 

-- 
Regards,
Vincenzo
