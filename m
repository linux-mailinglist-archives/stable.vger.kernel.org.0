Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C4F6A32E6
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 17:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBZQos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 11:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjBZQor (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 11:44:47 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7705CA07
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 08:44:45 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so2467335wmi.3
        for <stable@vger.kernel.org>; Sun, 26 Feb 2023 08:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ocj2R23WDknAZNtiIVt3IW9MrBrM5xCTWqwgy1N+IqI=;
        b=TMYvOa2MEdtxVrJma4tnZyGFUMCuBCIu3k7h9+WtXgzPzpbJ5z/YUgJpWMA/oZEo5N
         mgFpcmPwCDagOB96K2BJxXbI5Qj29zVzCtlTIZk7SdkH3OF5I+dvSxPOULIz2P6BOrow
         vG+P/b3jJ3TSwWpTyJw9ILd3eoBOquR+TCJw+L2J6Q05gR+4gonZS+lxCMFDjvfOHtsV
         XtnNJr5KzncWJ0ZjaTRhM6pJAqbuaDbyMda4QhyUTD6XjzUD50zMRCqarZZzuAVjjVFr
         ccIJ6qZRrqZx89W755bONFXWL7Ek9hMQGQRtUw8pjchlPi2j/krcTENFAlkdTzU29dNn
         ZNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ocj2R23WDknAZNtiIVt3IW9MrBrM5xCTWqwgy1N+IqI=;
        b=D19G00UytES2S/+FINBdblAZr6XkG5hY4m1ptN0YbrwW7EiUIybdCODkmUOW+gGRaC
         BHy2sDO7X9BbM8E3bJ8EHl71qtc251z8ATd2iAP8byOrAd1ybNZmnMUQDGX7BVJumTrz
         Qr/NxqFow9YOamRHNEugAaixKfhutQKLOGQbqnMYjXtwnsOMxJcRcSjSie+e6FT2dRBX
         ZzxIBibkmzHou93m5gQ4BM2n3cwuyuLRkobbxRnQ6Bx3MJ0J99PiJEKRNg38fsLxPLAG
         ybPjI38D86sdjKFDGl9Vb9YF5/LY29OgFMgTBVF7+Vu/At/pNm0uwxHJXEBdERpA+Viu
         yelw==
X-Gm-Message-State: AO0yUKVhPq0gZME9e53T0YImHiS/JXhI8poGEHtq1dwhCjZQqKdq62Xy
        3F1o7OfVM/u1YuRaDbe5RUmMfwQe/Y91cxa6
X-Google-Smtp-Source: AK7set85WMifA8RqMsuFmKb2O6ubbft7kyOg7T5hC17Bm/ZgEXzhLVpiF0wESGHsFa+iTUW5VOVqPQ==
X-Received: by 2002:a05:600c:358f:b0:3eb:3300:1d13 with SMTP id p15-20020a05600c358f00b003eb33001d13mr4728730wmq.14.1677429884420;
        Sun, 26 Feb 2023 08:44:44 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id p20-20020a05600c359400b003daf7721bb3sm10560323wmq.12.2023.02.26.08.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 08:44:44 -0800 (PST)
Date:   Sun, 26 Feb 2023 17:44:42 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Sergey Matyukevich <geomatsi@gmail.com>
Cc:     linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Zong Li <zong.li@sifive.com>, Guo Ren <guoren@kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] riscv: asid: Fixup stale TLB entry cause application
 crash
Message-ID: <20230226164442.lqrmpkwsaqj3og7x@orel>
References: <20230226150137.1919750-1-geomatsi@gmail.com>
 <20230226150137.1919750-3-geomatsi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226150137.1919750-3-geomatsi@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 26, 2023 at 06:01:37PM +0300, Sergey Matyukevich wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> After use_asid_allocator is enabled, the userspace application will
> crash by stale TLB entries. Because only using cpumask_clear_cpu without
> local_flush_tlb_all couldn't guarantee CPU's TLB entries were fresh.
> Then set_mm_asid would cause the user space application to get a stale
> value by stale TLB entry, but set_mm_noasid is okay.
> 
> Here is the symptom of the bug:
> unhandled signal 11 code 0x1 (coredump)
>    0x0000003fd6d22524 <+4>:     auipc   s0,0x70
>    0x0000003fd6d22528 <+8>:     ld      s0,-148(s0) # 0x3fd6d92490
> => 0x0000003fd6d2252c <+12>:    ld      a5,0(s0)
> (gdb) i r s0
> s0          0x8082ed1cc3198b21       0x8082ed1cc3198b21
> (gdb) x /2x 0x3fd6d92490
> 0x3fd6d92490:   0xd80ac8a8      0x0000003f
> The core dump file shows that register s0 is wrong, but the value in
> memory is correct. Because 'ld s0, -148(s0)' used a stale mapping entry
> in TLB and got a wrong result from an incorrect physical address.
> 
> When the task ran on CPU0, which loaded/speculative-loaded the value of
> address(0x3fd6d92490), then the first version of the mapping entry was
> PTWed into CPU0's TLB.
> When the task switched from CPU0 to CPU1 (No local_tlb_flush_all here by
> asid), it happened to write a value on the address (0x3fd6d92490). It
> caused do_page_fault -> wp_page_copy -> ptep_clear_flush ->
> ptep_get_and_clear & flush_tlb_page.
> The flush_tlb_page used mm_cpumask(mm) to determine which CPUs need TLB
> flush, but CPU0 had cleared the CPU0's mm_cpumask in the previous
> switch_mm. So we only flushed the CPU1 TLB and set the second version
> mapping of the PTE. When the task switched from CPU1 to CPU0 again, CPU0
> still used a stale TLB mapping entry which contained a wrong target
> physical address. It raised a bug when the task happened to read that
> value.
> 
>    CPU0                               CPU1
>    - switch 'task' in
>    - read addr (Fill stale mapping
>      entry into TLB)
>    - switch 'task' out (no tlb_flush)
>                                       - switch 'task' in (no tlb_flush)
>                                       - write addr cause pagefault
>                                         do_page_fault() (change to
>                                         new addr mapping)
>                                           wp_page_copy()
>                                             ptep_clear_flush()
>                                               ptep_get_and_clear()
>                                               & flush_tlb_page()
>                                         write new value into addr
>                                       - switch 'task' out (no tlb_flush)
>    - switch 'task' in (no tlb_flush)
>    - read addr again (Use stale
>      mapping entry in TLB)
>      get wrong value from old phyical
>      addr, BUG!
> 
> The solution is to keep all CPUs' footmarks of cpumask(mm) in switch_mm,
> which could guarantee to invalidate all stale TLB entries during TLB
> flush.
> 
> Fixes: 65d4b9c53017 ("RISC-V: Implement ASID allocator")
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Tested-by: Zong Li <zong.li@sifive.com>
> Tested-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
> Cc: Anup Patel <apatel@ventanamicro.com>
> Cc: Palmer Dabbelt <palmer@rivosinc.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  arch/riscv/mm/context.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
> index 7acbfbd14557..0f784e3d307b 100644
> --- a/arch/riscv/mm/context.c
> +++ b/arch/riscv/mm/context.c
> @@ -205,12 +205,24 @@ static void set_mm_noasid(struct mm_struct *mm)
>  	local_flush_tlb_all();
>  }
>  
> -static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
> +static inline void set_mm(struct mm_struct *prev,
> +			  struct mm_struct *next, unsigned int cpu)
>  {
> -	if (static_branch_unlikely(&use_asid_allocator))
> -		set_mm_asid(mm, cpu);
> -	else
> -		set_mm_noasid(mm);
> +	/*
> +	 * The mm_cpumask indicates which harts' TLBs contain the virtual
> +	 * address mapping of the mm. Compared to noasid, using asid
> +	 * can't guarantee that stale TLB entries are invalidated because
> +	 * the asid mechanism wouldn't flush TLB for every switch_mm for
> +	 * performance. So when using asid, keep all CPUs footmarks in
> +	 * cpumask() until mm reset.
> +	 */
> +	cpumask_set_cpu(cpu, mm_cpumask(next));
> +	if (static_branch_unlikely(&use_asid_allocator)) {
> +		set_mm_asid(next, cpu);
> +	} else {
> +		cpumask_clear_cpu(cpu, mm_cpumask(prev));
> +		set_mm_noasid(next);
> +	}
>  }
>  
>  static int __init asids_init(void)
> @@ -264,7 +276,8 @@ static int __init asids_init(void)
>  }
>  early_initcall(asids_init);
>  #else
> -static inline void set_mm(struct mm_struct *mm, unsigned int cpu)
> +static inline void set_mm(struct mm_struct *prev,
> +			  struct mm_struct *next, unsigned int cpu)
>  {
>  	/* Nothing to do here when there is no MMU */
>  }
> @@ -317,10 +330,7 @@ void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>  	 */
>  	cpu = smp_processor_id();
>  
> -	cpumask_clear_cpu(cpu, mm_cpumask(prev));
> -	cpumask_set_cpu(cpu, mm_cpumask(next));
> -
> -	set_mm(next, cpu);
> +	set_mm(prev, next, cpu);
>  
>  	flush_icache_deferred(next, cpu);
>  }
> -- 
> 2.39.2
>

This is identical to what I reviewed before, so my r-b could have been
kept, anyway here it is again

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
