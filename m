Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A141119095
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 20:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLJT2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 14:28:24 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40752 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJT2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 14:28:24 -0500
Received: by mail-lj1-f195.google.com with SMTP id s22so21204036ljs.7;
        Tue, 10 Dec 2019 11:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:newsgroups:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KzrNKcEOiU1kNGyhfhhVTJTy6mwRVVvr+Rcn9qUurw8=;
        b=QNz7LqTYmVb9Aun7hEf0jLOYMlUfOiJuHQCLY3kkVkHM+T2cbdU3feFVwNjxfXYTx5
         6dX859cw10yoxlm375M6kKNRDA9uLd7wNnFtS4T8lQntSzd4PHol+m/6MpAzsAcdl8r3
         PoAAMrtynBsYvr4Mim7TnoL3Rh5i4MbCW/mXDpv++/UK0O8ojl2cYu1yYmWB0TG5z22R
         1IX3wuDmLuBYGM3/B5FKAVcK6edYkjGgMGrPXcMOwySXPzMaX3WLhwFKoCXgoVpJbqas
         ic5l6MR2VHaXdqKIwHDLHhkaLMdhlhqr9UPbISdjXyyiOjE4mGzE619pZ5FPG9eLD+Wb
         Tfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:newsgroups:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KzrNKcEOiU1kNGyhfhhVTJTy6mwRVVvr+Rcn9qUurw8=;
        b=VXVYyeflU13aLWEqUyrZ8bYqMxjvmjGdnq0KTdOGngFPn93kCydoSCca4IdexwNR6O
         +vhd8MLb/PsMnC67z+ijzczpeo7o3aS4mhWios78r2VhttjZUBIvKUPlKb3pjO3Qn/z+
         F2YzrAsHPkhi2MtKmCRvJXlgq5RBk7rIc5XB7YO0cT9F3gUXpziO+h3MX0+yxGMNr3sb
         Kho2en5yOiJZB/PT1GG0hjbDsEGqivdrcLZsPoMfCahbtgqZjC0VTR/Tz9quCagVmfop
         JNi4iaqSvwtrollODf7uLEfgm8DBWahlvnZlReybWuN22049W3k2j51F7TyUVDdVZ/g6
         5uCg==
X-Gm-Message-State: APjAAAVtduYfGcha7ztMqsiRNo80wg/lXprj0cYzYNObjaNoGcqzkRwA
        1BVZbQjWZhb/o1cc5qiXxpcBRVrU
X-Google-Smtp-Source: APXvYqyGNckK5y5s9f8Jo3dSVgNxZdC7RHTTL3IKb5a7ys0PqCMlBLRFvvJWSZCZJGsvb+557NSYEA==
X-Received: by 2002:a2e:91c1:: with SMTP id u1mr21608748ljg.181.1576006101841;
        Tue, 10 Dec 2019 11:28:21 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id c9sm2302940ljd.28.2019.12.10.11.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 11:28:21 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
To:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Newsgroups: gmane.linux.kernel.stable,gmane.linux.ports.arm.kernel,gmane.linux.ports.tegra
References: <20191210103708.7023-1-jonathanh@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
Date:   Tue, 10 Dec 2019 22:28:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210103708.7023-1-jonathanh@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Jon,

10.12.2019 13:37, Jon Hunter пишет:
> The suspend entry and exit code for 32-bit Tegra devices assumes that
> the PLLM (which is used to provide the clock for external memory)
> is always enabled on entry to suspend. Hence, the current code always
> disables the PLLM on entry to suspend and re-enables the PLLM on exit
> from suspend.
> 
> Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
> ("memory: tegra: Add EMC (external memory controller) driver"), which is
> used to scale the EMC frequency, PLLM may not be the current clock
> source for the EMC on entry to suspend and hence may not be enabled.
> Always enabling the PLLM on exit from suspend can cause the actual
> status on the PLL to be different from that reported by the common clock
> framework.
> 
> On kernels prior to v4.5, the code to set the rate of the PLLM had a
> test to verify if the PLL was enabled and if the PLL was enabled,
> setting the rate would fail. Since commit 267b62a96951
> ("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
> enabled was removed.
> 
> With these earlier kernels, if the PLLM is disabled on entering suspend
> and the EMC driver attempts to set the parent of the EMC clock to the
> PLLM on exiting suspend, then the set rate for the PLLM will fail and in
> turn cause the resume to fail.
> 
> We should not be re-enabling the PLLM on resume from suspend unless it
> was enabled on entry to suspend. Therefore, fix this by saving the state
> of PLLM on entry to suspend and only re-enable it, if it was already
> enabled.
> 
> Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
> index 3341a12bbb9c..c2f0793a424f 100644
> --- a/arch/arm/mach-tegra/sleep-tegra30.S
> +++ b/arch/arm/mach-tegra/sleep-tegra30.S
> @@ -337,26 +337,42 @@ ENTRY(tegra30_lp1_reset)
>  	add	r1, r1, #2
>  	wait_until r1, r7, r3
>  
> -	/* enable PLLM via PMC */
> +	/* restore PLLM state */
>  	mov32	r2, TEGRA_PMC_BASE
> +	adr	r7, tegra_pllm_status
> +	ldr	r1, [r7]
> +	cmp	r2, #(1 << 12)
> +	bne	_skip_pllm
> +
>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>  	orr	r1, r1, #(1 << 12)
>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>  
>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, 0
> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
> +
> +_skip_pllm:
>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, 0
>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, 0
>  
>  	b	_pll_m_c_x_done
>  
>  _no_pll_iddq_exit:
> -	/* enable PLLM via PMC */
> +	/* restore PLLM state */
>  	mov32	r2, TEGRA_PMC_BASE
> +	adr	r7, tegra_pllm_status
> +	ldr	r1, [r7]
> +	cmp	r2, #(1 << 12)
> +	bne	_skip_pllm_no_iddq
> +
>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>  	orr	r1, r1, #(1 << 12)
>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>  
>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, CLK_RESET_PLLM_MISC
> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
> +
> +_skip_pllm_no_iddq:
>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, CLK_RESET_PLLC_MISC
>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, CLK_RESET_PLLX_MISC
>  
> @@ -364,7 +380,6 @@ _pll_m_c_x_done:
>  	pll_enable r1, r0, CLK_RESET_PLLP_BASE, CLK_RESET_PLLP_MISC
>  	pll_enable r1, r0, CLK_RESET_PLLA_BASE, CLK_RESET_PLLA_MISC
>  
> -	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>  	pll_locked r1, r0, CLK_RESET_PLLP_BASE
>  	pll_locked r1, r0, CLK_RESET_PLLA_BASE
>  	pll_locked r1, r0, CLK_RESET_PLLC_BASE
> @@ -526,6 +541,8 @@ __no_dual_emc_chanl:
>  ENDPROC(tegra30_lp1_reset)
>  
>  	.align	L1_CACHE_SHIFT
> +tegra_pllm_status:
> +	.word	0
>  tegra30_sdram_pad_address:
>  	.word	TEGRA_EMC_BASE + EMC_CFG				@0x0
>  	.word	TEGRA_EMC_BASE + EMC_ZCAL_INTERVAL			@0x4
> @@ -624,10 +641,14 @@ tegra30_switch_cpu_to_clk32k:
>  	add	r1, r1, #2
>  	wait_until r1, r7, r9


> -	/* disable PLLM via PMC in LP1 */
> +	/* disable PLLM, if enabled, via PMC in LP1 */
> +	adr	r1, tegra_pllm_status
>  	ldr	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
> -	bic	r0, r0, #(1 << 12)
> -	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
> +	and	r2, r0, #(1 << 12)
> +	str     r2, [r1]
> +	cmp	r2, #(1 << 12)
> +	biceq	r0, r0, #(1 << 12)
> +	streq	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>  
>  	/* disable PLLP, PLLA, PLLC and PLLX */
>  	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]

PLLM's enable-status could be defined either by PMC or CaR. Thus at
first you need to check whether PMC overrides CaR's enable and then
judge the enable state based on PMC or CaR state respectively.
