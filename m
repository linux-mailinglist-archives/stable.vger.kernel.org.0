Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863D8122EAE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 15:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbfLQO2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 09:28:13 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45849 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728903AbfLQO2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 09:28:13 -0500
Received: by mail-lj1-f193.google.com with SMTP id j26so2038936ljc.12;
        Tue, 17 Dec 2019 06:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vk7ni/PqrPUTZjj6Kf0gRjET4D/e5zlH4n0cpw8x2OM=;
        b=o47fXkjALqz4rl5PO30XgOGI+1aJQyxmjTcJzaa75KqVxZQ8OvnXdS4bp/muyjXfq6
         +Q+hVoUpjIBzMZR/dJ8tTGNbodcjDAvRLLRHn/+1kWntm/gP4EI04o+U6BxZc5vAdlmx
         9Kua9Fb7A8hqXqKXQE/U7TNT7oojkZoTXs2K2xFmL81+OemZJrGNXJ5+VXRyPOWkIJDd
         Js/Fit/gQ4iwL/bU2QCY1RvuM/VZloJ2Qp4Z9bM9FrL63PPQy0yfQ7AFeszybDaezq8X
         ZUrBOt5O+A4eJPIkFLUgE4Jp2iDj/DAI3AXcWZXvlPkEa/Oh+fJQf9CpEYLiXLrZzihl
         s3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vk7ni/PqrPUTZjj6Kf0gRjET4D/e5zlH4n0cpw8x2OM=;
        b=NmwGIjtWx+DioA/PLQy4/TehQIejQdxASaEJrnRD54m8c6dyvbuUR0ULQe/a4fl3mP
         loqFFBulXYYZZVsdTJY63amqh2sfbhNHc2PnZII3oFFM8fVRw3+wzhjBmIfd+OfGqlAN
         arcZZb7gB6tL9pwkYmGBERvScCxTgTW4kw4y6Yd7p1BNRrfb4FzYnGBBVfw7Mg5XqR67
         nWuushDT3wu3e2ZqTDe9SCkatIt6KwhMfXEzO0+pjOPmMzQ5HyNwG2cgieqNhl0dC79N
         L55aXhDgk6AFKCXRhcZGFgANTS6GBLpTpexxbuBEtBIq3zcEyLkpYWZipgfEvdHOGGWn
         c+aA==
X-Gm-Message-State: APjAAAW3MZf6thuUFGgm1E56TNQzSBk7LOmlMPKfvP38cCHe2OP75B/x
        f0OZFqSZwXhw2Z+zWyvW+vQ=
X-Google-Smtp-Source: APXvYqx9Yu+YCch0Clt7jQ2sGxMLQC73A43RH+34NZSNGonEedW1jGzJxy5aLY3sXFM0+bViyRljOg==
X-Received: by 2002:a2e:9008:: with SMTP id h8mr3452969ljg.217.1576592889463;
        Tue, 17 Dec 2019 06:28:09 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id g14sm12752266ljj.37.2019.12.17.06.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 06:28:08 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
To:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
 <1fe9cd2d-50a2-aae5-95fa-0329acce4c4c@gmail.com>
 <6ee48145-7315-4283-ae56-fbf00b00f16b@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <57264acd-2623-9e9f-53c6-3b4cd3991315@gmail.com>
Date:   Tue, 17 Dec 2019 17:28:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6ee48145-7315-4283-ae56-fbf00b00f16b@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

17.12.2019 17:19, Jon Hunter пишет:
> 
> On 10/12/2019 20:29, Dmitry Osipenko wrote:
>> 10.12.2019 22:28, Dmitry Osipenko пишет:
>>> Hello Jon,
>>>
>>> 10.12.2019 13:37, Jon Hunter пишет:
>>>> The suspend entry and exit code for 32-bit Tegra devices assumes that
>>>> the PLLM (which is used to provide the clock for external memory)
>>>> is always enabled on entry to suspend. Hence, the current code always
>>>> disables the PLLM on entry to suspend and re-enables the PLLM on exit
>>>> from suspend.
>>>>
>>>> Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
>>>> ("memory: tegra: Add EMC (external memory controller) driver"), which is
>>>> used to scale the EMC frequency, PLLM may not be the current clock
>>>> source for the EMC on entry to suspend and hence may not be enabled.
>>>> Always enabling the PLLM on exit from suspend can cause the actual
>>>> status on the PLL to be different from that reported by the common clock
>>>> framework.
>>>>
>>>> On kernels prior to v4.5, the code to set the rate of the PLLM had a
>>>> test to verify if the PLL was enabled and if the PLL was enabled,
>>>> setting the rate would fail. Since commit 267b62a96951
>>>> ("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
>>>> enabled was removed.
>>>>
>>>> With these earlier kernels, if the PLLM is disabled on entering suspend
>>>> and the EMC driver attempts to set the parent of the EMC clock to the
>>>> PLLM on exiting suspend, then the set rate for the PLLM will fail and in
>>>> turn cause the resume to fail.
>>>>
>>>> We should not be re-enabling the PLLM on resume from suspend unless it
>>>> was enabled on entry to suspend. Therefore, fix this by saving the state
>>>> of PLLM on entry to suspend and only re-enable it, if it was already
>>>> enabled.
>>>>
>>>> Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
>>>> Cc: stable@vger.kernel.org
>>>>
>>>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>>>> ---
>>>>  arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
>>>>  1 file changed, 27 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
>>>> index 3341a12bbb9c..c2f0793a424f 100644
>>>> --- a/arch/arm/mach-tegra/sleep-tegra30.S
>>>> +++ b/arch/arm/mach-tegra/sleep-tegra30.S
>>>> @@ -337,26 +337,42 @@ ENTRY(tegra30_lp1_reset)
>>>>  	add	r1, r1, #2
>>>>  	wait_until r1, r7, r3
>>>>  
>>>> -	/* enable PLLM via PMC */
>>>> +	/* restore PLLM state */
>>>>  	mov32	r2, TEGRA_PMC_BASE
>>>> +	adr	r7, tegra_pllm_status
>>>> +	ldr	r1, [r7]
>>>> +	cmp	r2, #(1 << 12)
>>>> +	bne	_skip_pllm
>>>> +
>>>>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>  	orr	r1, r1, #(1 << 12)
>>>>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>  
>>>>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, 0
>>>> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>>> +
>>>> +_skip_pllm:
>>>>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, 0
>>>>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, 0
>>>>  
>>>>  	b	_pll_m_c_x_done
>>>>  
>>>>  _no_pll_iddq_exit:
>>>> -	/* enable PLLM via PMC */
>>>> +	/* restore PLLM state */
>>>>  	mov32	r2, TEGRA_PMC_BASE
>>>> +	adr	r7, tegra_pllm_status
>>>> +	ldr	r1, [r7]
>>>> +	cmp	r2, #(1 << 12)
>>>> +	bne	_skip_pllm_no_iddq
>>>> +
>>>>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>  	orr	r1, r1, #(1 << 12)
>>>>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>>>  
>>>>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, CLK_RESET_PLLM_MISC
>>>> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>>> +
>>>> +_skip_pllm_no_iddq:
>>>>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, CLK_RESET_PLLC_MISC
>>>>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, CLK_RESET_PLLX_MISC
>>>>  
>>>> @@ -364,7 +380,6 @@ _pll_m_c_x_done:
>>>>  	pll_enable r1, r0, CLK_RESET_PLLP_BASE, CLK_RESET_PLLP_MISC
>>>>  	pll_enable r1, r0, CLK_RESET_PLLA_BASE, CLK_RESET_PLLA_MISC
>>>>  
>>>> -	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>>>  	pll_locked r1, r0, CLK_RESET_PLLP_BASE
>>>>  	pll_locked r1, r0, CLK_RESET_PLLA_BASE
>>>>  	pll_locked r1, r0, CLK_RESET_PLLC_BASE
>>>> @@ -526,6 +541,8 @@ __no_dual_emc_chanl:
>>>>  ENDPROC(tegra30_lp1_reset)
>>>>  
>>>>  	.align	L1_CACHE_SHIFT
>>>> +tegra_pllm_status:
>>>> +	.word	0
>>>>  tegra30_sdram_pad_address:
>>>>  	.word	TEGRA_EMC_BASE + EMC_CFG				@0x0
>>>>  	.word	TEGRA_EMC_BASE + EMC_ZCAL_INTERVAL			@0x4
>>>> @@ -624,10 +641,14 @@ tegra30_switch_cpu_to_clk32k:
>>>>  	add	r1, r1, #2
>>>>  	wait_until r1, r7, r9
>>>
>>>
>>>> -	/* disable PLLM via PMC in LP1 */
>>>> +	/* disable PLLM, if enabled, via PMC in LP1 */
>>>> +	adr	r1, tegra_pllm_status
>>>>  	ldr	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>>> -	bic	r0, r0, #(1 << 12)
>>>> -	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>>> +	and	r2, r0, #(1 << 12)
>>>> +	str     r2, [r1]
>>>> +	cmp	r2, #(1 << 12)
>>>> +	biceq	r0, r0, #(1 << 12)
>>>> +	streq	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>>>  
>>>>  	/* disable PLLP, PLLA, PLLC and PLLX */
>>>>  	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
>>>
>>> PLLM's enable-status could be defined either by PMC or CaR. Thus at
>>> first you need to check whether PMC overrides CaR's enable and then
>>> judge the enable state based on PMC or CaR state respectively.
>>>
>>
>> Actually, now I think that it doesn't make sense to check PMC WB0 state
>> at all. IIUC, PLLM's state of the WB0 register defines whether Boot ROM
>> should enable PLLM on resume from suspend. Thus it will be correct to
>> check only the CaR's enable-state of PLLM.
> 
> Thanks for pointing this out and sorry for the delay. However, I am not
> sure I agree that we should not check this at all. If the override bit
> is set, then we do want to check the state from the PMC register and if
> it is not then we should just use the PLLM register itself.

Sorry if I wasn't clear.. my point is that the PMC's override register
bit doesn't reflect the PLLM's enable-state. The PLLM could be disabled
while PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE bit is set.

The CaR's PLLM enable-state reflects the actual hardware state. At least
that's what I see on T30.

>> Looks like it is a bit of nonsense that clk_pll_is_enabled() checks
>> PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE for judging of the enable-state. This
>> is not the first time I'm getting confused by it, perhaps will be
>> worthwhile to clean up that part of the clk driver's code (if I'm not
>> missing something).
> 
> That code looks fine to me. I just think this code entering and exiting
> suspend needs to be fixed. I will re-work this fix.
> 
> Jon
> 

