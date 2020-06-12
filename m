Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34B21F7AA3
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 17:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgFLPUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 11:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgFLPUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 11:20:53 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C06C03E96F;
        Fri, 12 Jun 2020 08:20:52 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x22so5696383lfd.4;
        Fri, 12 Jun 2020 08:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uU8wuKx8q16hr+N4pD656D/ncTAnO8D0+HBS47NTVlk=;
        b=CMbX/XIOibfeHFK0ZrIL9r0jaGmNrMWtt0AsoMiJ+m2Dfln/Hq/FsvamCrgjvPPi47
         rNnB+U8rucjYWkr0HS7GI9xbfyS9StZNTg4T/fF/5fsZFQcKz+QkfJD1wyNDQcHNIix1
         IQLQLTO8yxKi1i3jfIg3WY+MLlBkHMQBl00Hf6h/kBUjQ5JwcOUbtsaVMi4ERgTgl4o4
         7vQP1FuU9FU0wmsBDaqIjyPp8hGaYCO7Gon8At8osU38M6diG0ph1Qfo9gHO7z6iWM/s
         WReL4w0hQcB+yKCvJb+wgc/GsRtoj+bzeWDaK8RjjRlK2gV51QWdTHbGrSqV5rCAonHm
         FUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uU8wuKx8q16hr+N4pD656D/ncTAnO8D0+HBS47NTVlk=;
        b=TmMr1MVyhW8KfM4BOXvxMkcPQIHlaUzKgoO9AXuFfuYGcwS9FccAAdP0fwMIVQytV1
         JtAFVG2hA2d0U6GCgIDsBD8oLp9kwAVA5rPVR4K329hB3vQCd4JjBhdkeNnMFDdHyN8Y
         weO4OJxiv/kt2yFqeH4uX3wp8ID6vL1k7wLiQMu39hDZp2fMkmYHd/fyzkpGaI1VFwpf
         1tGynhL1Suj3SZjEbXOQ0v1yyPob9fcDPb1qvS2uKdT501fTDBuPGy0YmP4xE2RQt6eE
         emWkGz+EKsNLJgJ1rdFaDHBSyqlOlZ7BtPzLgH2Ls7Ym4GpyDfpgiC78R2b5CDNbaPv0
         3Qsw==
X-Gm-Message-State: AOAM531XtNmQmo4WCk50ermXSbrV+O+dfO1IIzLxQZoN8EyDGrt5ww4P
        AEhQWmWWWQtmrp3iBqlSmTQRNNd5
X-Google-Smtp-Source: ABdhPJz65emQ8x+AkxyvE8yGEA4d1ei1exd+Pf2EKZFz36XiLi75TAboMpZIiXvssKJbEkLWBmFDww==
X-Received: by 2002:a19:356:: with SMTP id 83mr7181307lfd.179.1591975251131;
        Fri, 12 Jun 2020 08:20:51 -0700 (PDT)
Received: from [192.168.2.145] (79-139-237-54.dynamic.spd-mgts.ru. [79.139.237.54])
        by smtp.googlemail.com with ESMTPSA id a16sm1739308ljb.107.2020.06.12.08.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 08:20:50 -0700 (PDT)
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
 <1fe9cd2d-50a2-aae5-95fa-0329acce4c4c@gmail.com>
 <6ee48145-7315-4283-ae56-fbf00b00f16b@nvidia.com>
 <57264acd-2623-9e9f-53c6-3b4cd3991315@gmail.com>
Message-ID: <ce82c0c9-2396-136c-a4d5-e5530295e593@gmail.com>
Date:   Fri, 12 Jun 2020 18:20:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <57264acd-2623-9e9f-53c6-3b4cd3991315@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

17.12.2019 17:28, Dmitry Osipenko пишет:
> 17.12.2019 17:19, Jon Hunter пишет:
>>
>> On 10/12/2019 20:29, Dmitry Osipenko wrote:
>>> 10.12.2019 22:28, Dmitry Osipenko пишет:
>>>> Hello Jon,
>>>>
>>>> 10.12.2019 13:37, Jon Hunter пишет:
>>>>> The suspend entry and exit code for 32-bit Tegra devices assumes that
>>>>> the PLLM (which is used to provide the clock for external memory)
>>>>> is always enabled on entry to suspend. Hence, the current code always
>>>>> disables the PLLM on entry to suspend and re-enables the PLLM on exit
>>>>> from suspend.
>>>>>
>>>>> Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
>>>>> ("memory: tegra: Add EMC (external memory controller) driver"), which is
>>>>> used to scale the EMC frequency, PLLM may not be the current clock
>>>>> source for the EMC on entry to suspend and hence may not be enabled.
>>>>> Always enabling the PLLM on exit from suspend can cause the actual
>>>>> status on the PLL to be different from that reported by the common clock
>>>>> framework.
>>>>>
>>>>> On kernels prior to v4.5, the code to set the rate of the PLLM had a
>>>>> test to verify if the PLL was enabled and if the PLL was enabled,
>>>>> setting the rate would fail. Since commit 267b62a96951
>>>>> ("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
>>>>> enabled was removed.
>>>>>
>>>>> With these earlier kernels, if the PLLM is disabled on entering suspend
>>>>> and the EMC driver attempts to set the parent of the EMC clock to the
>>>>> PLLM on exiting suspend, then the set rate for the PLLM will fail and in
>>>>> turn cause the resume to fail.
>>>>>
>>>>> We should not be re-enabling the PLLM on resume from suspend unless it
>>>>> was enabled on entry to suspend. Therefore, fix this by saving the state
>>>>> of PLLM on entry to suspend and only re-enable it, if it was already
>>>>> enabled.
>>>>>
>>>>> Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
>>>>> Cc: stable@vger.kernel.org
>>>>>
>>>>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>>>>> ---
>>>>>  arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
>>>>>  1 file changed, 27 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
>>>>> index 3341a12bbb9c..c2f0793a424f 100644
>>>>> --- a/arch/arm/mach-tegra/sleep-tegra30.S
>>>>> +++ b/arch/arm/mach-tegra/sleep-tegra30.S
>>>>> @@ -337,26 +337,42 @@ ENTRY(tegra30_lp1_reset)
>>>>>  	add	r1, r1, #2
>>>>>  	wait_until r1, r7, r3
>>>>>  
>>>>> -	/* enable PLLM via PMC */
>>>>> +	/* restore PLLM state */
>>>>>  	mov32	r2, TEGRA_PMC_BASE
>>>>> +	adr	r7, tegra_pllm_status
>>>>> +	ldr	r1, [r7]
>>>>> +	cmp	r2, #(1 << 12)
>>>>> +	bne	_skip_pllm
>>>>> +
>>>>>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>>  	orr	r1, r1, #(1 << 12)
>>>>>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>>  
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, 0
>>>>> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>>>> +
>>>>> +_skip_pllm:
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, 0
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, 0
>>>>>  
>>>>>  	b	_pll_m_c_x_done
>>>>>  
>>>>>  _no_pll_iddq_exit:
>>>>> -	/* enable PLLM via PMC */
>>>>> +	/* restore PLLM state */
>>>>>  	mov32	r2, TEGRA_PMC_BASE
>>>>> +	adr	r7, tegra_pllm_status
>>>>> +	ldr	r1, [r7]
>>>>> +	cmp	r2, #(1 << 12)
>>>>> +	bne	_skip_pllm_no_iddq
>>>>> +
>>>>>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>>  	orr	r1, r1, #(1 << 12)
>>>>>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>>  
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, CLK_RESET_PLLM_MISC
>>>>> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>>>> +
>>>>> +_skip_pllm_no_iddq:
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, CLK_RESET_PLLC_MISC
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, CLK_RESET_PLLX_MISC
>>>>>  
>>>>> @@ -364,7 +380,6 @@ _pll_m_c_x_done:
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLP_BASE, CLK_RESET_PLLP_MISC
>>>>>  	pll_enable r1, r0, CLK_RESET_PLLA_BASE, CLK_RESET_PLLA_MISC
>>>>>  
>>>>> -	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>>>>  	pll_locked r1, r0, CLK_RESET_PLLP_BASE
>>>>>  	pll_locked r1, r0, CLK_RESET_PLLA_BASE
>>>>>  	pll_locked r1, r0, CLK_RESET_PLLC_BASE
>>>>> @@ -526,6 +541,8 @@ __no_dual_emc_chanl:
>>>>>  ENDPROC(tegra30_lp1_reset)
>>>>>  
>>>>>  	.align	L1_CACHE_SHIFT
>>>>> +tegra_pllm_status:
>>>>> +	.word	0
>>>>>  tegra30_sdram_pad_address:
>>>>>  	.word	TEGRA_EMC_BASE + EMC_CFG				@0x0
>>>>>  	.word	TEGRA_EMC_BASE + EMC_ZCAL_INTERVAL			@0x4
>>>>> @@ -624,10 +641,14 @@ tegra30_switch_cpu_to_clk32k:
>>>>>  	add	r1, r1, #2
>>>>>  	wait_until r1, r7, r9
>>>>
>>>>
>>>>> -	/* disable PLLM via PMC in LP1 */
>>>>> +	/* disable PLLM, if enabled, via PMC in LP1 */
>>>>> +	adr	r1, tegra_pllm_status
>>>>>  	ldr	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>>>> -	bic	r0, r0, #(1 << 12)
>>>>> -	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>>>> +	and	r2, r0, #(1 << 12)
>>>>> +	str     r2, [r1]
>>>>> +	cmp	r2, #(1 << 12)
>>>>> +	biceq	r0, r0, #(1 << 12)
>>>>> +	streq	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>>>>  
>>>>>  	/* disable PLLP, PLLA, PLLC and PLLX */
>>>>>  	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
>>>>
>>>> PLLM's enable-status could be defined either by PMC or CaR. Thus at
>>>> first you need to check whether PMC overrides CaR's enable and then
>>>> judge the enable state based on PMC or CaR state respectively.
>>>>
>>>
>>> Actually, now I think that it doesn't make sense to check PMC WB0 state
>>> at all. IIUC, PLLM's state of the WB0 register defines whether Boot ROM
>>> should enable PLLM on resume from suspend. Thus it will be correct to
>>> check only the CaR's enable-state of PLLM.
>>
>> Thanks for pointing this out and sorry for the delay. However, I am not
>> sure I agree that we should not check this at all. If the override bit
>> is set, then we do want to check the state from the PMC register and if
>> it is not then we should just use the PLLM register itself.
> 
> Sorry if I wasn't clear.. my point is that the PMC's override register
> bit doesn't reflect the PLLM's enable-state. The PLLM could be disabled
> while PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE bit is set.
> 
> The CaR's PLLM enable-state reflects the actual hardware state. At least
> that's what I see on T30.
> 
>>> Looks like it is a bit of nonsense that clk_pll_is_enabled() checks
>>> PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE for judging of the enable-state. This
>>> is not the first time I'm getting confused by it, perhaps will be
>>> worthwhile to clean up that part of the clk driver's code (if I'm not
>>> missing something).
>>
>> That code looks fine to me. I just think this code entering and exiting
>> suspend needs to be fixed. I will re-work this fix.

Hello, Jon! Do you have any plans to continue working on this patch? A
day ago I sent out patch that improves PLLM handling within the clk
driver [1], will be great if the resume from suspend could be improved
as well! :)

[1]
https://patchwork.ozlabs.org/project/linux-tegra/patch/20200610163738.29304-1-digetx@gmail.com/
