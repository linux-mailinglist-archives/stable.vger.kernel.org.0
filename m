Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74131411891
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhITPqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:46:18 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:39465 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241973AbhITPqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 11:46:17 -0400
Received: by mail-wr1-f45.google.com with SMTP id u15so31007281wru.6
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 08:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YGsOk2OEhsovLA7k2C5YxUeFl0p36FmotCF7AE5mcM4=;
        b=vqt0EqYA6kBKKE0Uezio8T0oMRZQsLMfSIEUXiROT8qHCKZdJSCSXkOnChfNFUKnZv
         TNitClMgRlVvm0rzc/EjGD3ZkdPjiXWG9j/nGQ0TE32kFrvvS/MiWC6x1twYTc5B+FOT
         CuiKNBdw991Th7UIkTMZyihzv2mWQscP2dY+F/plcRpa/2JbnL45Vg/wChUnENxH99dp
         dQSHGOnQsAMfReiK2tfnBXPf5zbfdQW949UnwLc9Zdn9kFAxRgRLMzbQlt9qBBQykDS0
         0lu/gD7khGSIIo6BxLsHPtGfbN3sN4m+3yysCnS9vF3K/B7zYXYjdKZok51g92/sCiUP
         0sKw==
X-Gm-Message-State: AOAM532umYfoIK/5rqWC//TGJonMBnuMLmOPRFjQai7GnNISEycdjahy
        sG417gQpU6lnO7a/PV95RjQ=
X-Google-Smtp-Source: ABdhPJyPQ/tQ1Pp7zV9Edejy9WmqRix/6mslm2u9MTOhCtaqWHVkDSRV0Nvwz3f+4/G/LnOa1gjyUg==
X-Received: by 2002:a05:600c:40c4:: with SMTP id m4mr29660873wmh.100.1632152690018;
        Mon, 20 Sep 2021 08:44:50 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id i2sm15893045wrq.78.2021.09.20.08.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 08:44:49 -0700 (PDT)
Date:   Mon, 20 Sep 2021 15:44:47 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     wei.liu@kernel.org, mikelley@microsoft.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/hyperv: remove on-stack cpumask from"
 failed to apply to 5.14-stable tree
Message-ID: <20210920154447.gess7eb3qho6s2ax@liuwe-devbox-debian-v2>
References: <1632128215208163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1632128215208163@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 20, 2021 at 10:56:55AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

There is one prerequisite patch for this patch.  I can backport both to
all relevant stable branches, but I would like to know how you would
like to receive backport patches. Several git bundles to stable@?
Several two-patch series to stable@? I can also give you several tags /
branches to pull from if you like.

Thanks,
Wei.

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From dfb5c1e12c28e35e4d4e5bc8022b0e9d585b89a7 Mon Sep 17 00:00:00 2001
> From: Wei Liu <wei.liu@kernel.org>
> Date: Fri, 10 Sep 2021 18:57:14 +0000
> Subject: [PATCH] x86/hyperv: remove on-stack cpumask from
>  hv_send_ipi_mask_allbutself
> 
> It is not a good practice to allocate a cpumask on stack, given it may
> consume up to 1 kilobytes of stack space if the kernel is configured to
> have 8192 cpus.
> 
> The internal helper functions __send_ipi_mask{,_ex} need to loop over
> the provided mask anyway, so it is not too difficult to skip `self'
> there. We can thus do away with the on-stack cpumask in
> hv_send_ipi_mask_allbutself.
> 
> Adjust call sites of __send_ipi_mask as needed.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Michael Kelley <mikelley@microsoft.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Fixes: 68bb7bfb7985d ("X86/Hyper-V: Enable IPI enlightenments")
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/r/20210910185714.299411-3-wei.liu@kernel.org
> 
> diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
> index 90e682a92820..32a1ad356c18 100644
> --- a/arch/x86/hyperv/hv_apic.c
> +++ b/arch/x86/hyperv/hv_apic.c
> @@ -99,7 +99,8 @@ static void hv_apic_eoi_write(u32 reg, u32 val)
>  /*
>   * IPI implementation on Hyper-V.
>   */
> -static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector)
> +static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector,
> +		bool exclude_self)
>  {
>  	struct hv_send_ipi_ex **arg;
>  	struct hv_send_ipi_ex *ipi_arg;
> @@ -123,7 +124,10 @@ static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector)
>  
>  	if (!cpumask_equal(mask, cpu_present_mask)) {
>  		ipi_arg->vp_set.format = HV_GENERIC_SET_SPARSE_4K;
> -		nr_bank = cpumask_to_vpset(&(ipi_arg->vp_set), mask);
> +		if (exclude_self)
> +			nr_bank = cpumask_to_vpset_noself(&(ipi_arg->vp_set), mask);
> +		else
> +			nr_bank = cpumask_to_vpset(&(ipi_arg->vp_set), mask);
>  	}
>  	if (nr_bank < 0)
>  		goto ipi_mask_ex_done;
> @@ -138,15 +142,25 @@ static bool __send_ipi_mask_ex(const struct cpumask *mask, int vector)
>  	return hv_result_success(status);
>  }
>  
> -static bool __send_ipi_mask(const struct cpumask *mask, int vector)
> +static bool __send_ipi_mask(const struct cpumask *mask, int vector,
> +		bool exclude_self)
>  {
> -	int cur_cpu, vcpu;
> +	int cur_cpu, vcpu, this_cpu = smp_processor_id();
>  	struct hv_send_ipi ipi_arg;
>  	u64 status;
> +	unsigned int weight;
>  
>  	trace_hyperv_send_ipi_mask(mask, vector);
>  
> -	if (cpumask_empty(mask))
> +	weight = cpumask_weight(mask);
> +
> +	/*
> +	 * Do nothing if
> +	 *   1. the mask is empty
> +	 *   2. the mask only contains self when exclude_self is true
> +	 */
> +	if (weight == 0 ||
> +	    (exclude_self && weight == 1 && cpumask_test_cpu(this_cpu, mask)))
>  		return true;
>  
>  	if (!hv_hypercall_pg)
> @@ -172,6 +186,8 @@ static bool __send_ipi_mask(const struct cpumask *mask, int vector)
>  	ipi_arg.cpu_mask = 0;
>  
>  	for_each_cpu(cur_cpu, mask) {
> +		if (exclude_self && cur_cpu == this_cpu)
> +			continue;
>  		vcpu = hv_cpu_number_to_vp_number(cur_cpu);
>  		if (vcpu == VP_INVAL)
>  			return false;
> @@ -191,7 +207,7 @@ static bool __send_ipi_mask(const struct cpumask *mask, int vector)
>  	return hv_result_success(status);
>  
>  do_ex_hypercall:
> -	return __send_ipi_mask_ex(mask, vector);
> +	return __send_ipi_mask_ex(mask, vector, exclude_self);
>  }
>  
>  static bool __send_ipi_one(int cpu, int vector)
> @@ -208,7 +224,7 @@ static bool __send_ipi_one(int cpu, int vector)
>  		return false;
>  
>  	if (vp >= 64)
> -		return __send_ipi_mask_ex(cpumask_of(cpu), vector);
> +		return __send_ipi_mask_ex(cpumask_of(cpu), vector, false);
>  
>  	status = hv_do_fast_hypercall16(HVCALL_SEND_IPI, vector, BIT_ULL(vp));
>  	return hv_result_success(status);
> @@ -222,20 +238,13 @@ static void hv_send_ipi(int cpu, int vector)
>  
>  static void hv_send_ipi_mask(const struct cpumask *mask, int vector)
>  {
> -	if (!__send_ipi_mask(mask, vector))
> +	if (!__send_ipi_mask(mask, vector, false))
>  		orig_apic.send_IPI_mask(mask, vector);
>  }
>  
>  static void hv_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  {
> -	unsigned int this_cpu = smp_processor_id();
> -	struct cpumask new_mask;
> -	const struct cpumask *local_mask;
> -
> -	cpumask_copy(&new_mask, mask);
> -	cpumask_clear_cpu(this_cpu, &new_mask);
> -	local_mask = &new_mask;
> -	if (!__send_ipi_mask(local_mask, vector))
> +	if (!__send_ipi_mask(mask, vector, true))
>  		orig_apic.send_IPI_mask_allbutself(mask, vector);
>  }
>  
> @@ -246,7 +255,7 @@ static void hv_send_ipi_allbutself(int vector)
>  
>  static void hv_send_ipi_all(int vector)
>  {
> -	if (!__send_ipi_mask(cpu_online_mask, vector))
> +	if (!__send_ipi_mask(cpu_online_mask, vector, false))
>  		orig_apic.send_IPI_all(vector);
>  }
>  
> 
