Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E621E33A4
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbgEZXWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 19:22:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46946 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbgEZXWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 19:22:39 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2020 19:22:38 EDT
Received: by one.firstfloor.org (Postfix, from userid 503)
        id 65ECC86865; Wed, 27 May 2020 01:14:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1590534866;
        bh=XaqawHi8JwkBz2bthuRUNzJQekD3MBDj3VptsVzVMO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCtzM4cn1tNLYX8frSXM61tLCVHthkhmK+doC3ZwMN7P75Aha/fYCnehj391s5sBn
         9zo8RYaJm0+MHkvOJgVCJQ7N7G0IN0jiM2IbA5WjxfUvRerSBR019ow17e/K8imQYB
         h9Z9QKKtP8bzUN6N2bQvdTqUBeeZkuoizeFDri2E=
Date:   Tue, 26 May 2020 16:14:25 -0700
From:   Andi Kleen <andi@firstfloor.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        Andi Kleen <ak@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1] x86: Pin cr4 FSGSBASE
Message-ID: <20200526231423.qcsolcpll534sgro@two.firstfloor.org>
References: <20200526052848.605423-1-andi@firstfloor.org>
 <202005260935.EB11D3EB7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005260935.EB11D3EB7@keescook>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> And if this is going to be more permanent, we can separate the mask
> (untested):

The FSGSBASE one should not be permanent, it will be replaced
with the full FSGSBASE patches that set that bit correctly.

I was a bit wary of enforcing it for all bits, there might be other
CR4 bits which have benign uses. But I guess the risk of breaking
something there is low.

-Andi


> 
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index bed0cb83fe24..ead64f7420a5 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -347,6 +347,8 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
>  	cr4_clear_bits(X86_CR4_UMIP);
>  }
>  
> +static const unsigned long cr4_pinned_mask =
> +	X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP | X86_CR4_FSGSBASE;
>  static DEFINE_STATIC_KEY_FALSE_RO(cr_pinning);
>  static unsigned long cr4_pinned_bits __ro_after_init;
>  
> @@ -371,20 +373,20 @@ EXPORT_SYMBOL(native_write_cr0);
>  
>  void native_write_cr4(unsigned long val)
>  {
> -	unsigned long bits_missing = 0;
> +	unsigned long bits_changed = 0;
>  
>  set_register:
>  	asm volatile("mov %0,%%cr4": "+r" (val), "+m" (cr4_pinned_bits));
>  
>  	if (static_branch_likely(&cr_pinning)) {
> -		if (unlikely((val & cr4_pinned_bits) != cr4_pinned_bits)) {
> -			bits_missing = ~val & cr4_pinned_bits;
> -			val |= bits_missing;
> +		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
> +			bits_changed = ~val & cr4_pinned_mask;
> +			val = (val & ~cr4_pinned_mask) | cr4_pinned_bits;
>  			goto set_register;
>  		}
>  		/* Warn after we've set the missing bits. */
> -		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
> -			  bits_missing);
> +		WARN_ONCE(bits_changed, "pinned CR4 bits changed: %lx!?\n",
> +			  bits_changed);
>  	}
>  }
>  EXPORT_SYMBOL(native_write_cr4);
> @@ -396,7 +398,7 @@ void cr4_init(void)
>  	if (boot_cpu_has(X86_FEATURE_PCID))
>  		cr4 |= X86_CR4_PCIDE;
>  	if (static_branch_likely(&cr_pinning))
> -		cr4 |= cr4_pinned_bits;
> +		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
>  
>  	__write_cr4(cr4);
>  
> @@ -411,10 +413,7 @@ void cr4_init(void)
>   */
>  static void __init setup_cr_pinning(void)
>  {
> -	unsigned long mask;
> -
> -	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
> -	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
> +	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & cr4_pinned_mask;
>  	static_key_enable(&cr_pinning.key);
>  }
>  
> 
> -- 
> Kees Cook
> 
