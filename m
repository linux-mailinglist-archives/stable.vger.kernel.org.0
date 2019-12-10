Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F891191EF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 21:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLJU3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 15:29:47 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33513 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJU3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 15:29:47 -0500
Received: by mail-lj1-f194.google.com with SMTP id 21so21437485ljr.0;
        Tue, 10 Dec 2019 12:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KEQbedRJyV3kaY0bY3SYW8Od0asqs0FkLyw8Zhvxzd4=;
        b=Ipv4T2X6vXrrVNPz9bzhMBYtngakhwsBD1FWA8f7Jw3TPHpi1gDgH4wNd4wvF0YSiL
         yStMDzgkUy3hx1f20jKf/hBS/Ul6qvLQqQM0YXJQuTjOlCUhdbIG9yJD/11XG0YZC+y9
         +l3RelZoKm846drRb0NpOR+ljyFMbiMl3Z/ITigEppOkjuGqFGSSTGDEwTcBHX1TGiRx
         KgYru410NofD0rViBTduX84tB68NNC70pYiV1HZUcVMMKxi6hryX6m5/Uf9Jumu6Ev1Z
         JxlZx6fl61E7l1AEqE7Sm5ygzHoj/sITvhLe1Jnj1csirdrGP7bc2aN0yBpAsvbp2AAR
         Ta3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KEQbedRJyV3kaY0bY3SYW8Od0asqs0FkLyw8Zhvxzd4=;
        b=FxTPQjzpbZ5uKdIgyDfPQmbup2hHLHqldcGoddiG2A3fa9NGIOsoBlZpMW0yXKN4eP
         0oAiCMxnZLZGY/UaHV4er63S9TCcflkhXq9v4H7WuzSNJLVzXgYzpDHP559GVzg4DPyG
         sOOJO3dbwxyMLnARvaDJIbCA5CL5MmPTD9ZAVUOogZ5q/5sg6J+dYoOXlQemO2Q5ZHYc
         1o9p9zPtlRiTr0I8nl0hC63pxo6TxBnucLsNT/LRcNA1lmjWfba85X0OafkxwhG21mi6
         UkqzR1QjXBWEnp9ukZW/p+3DJlGmwcP7ULB1DAE5awHhykrxvfNrNKxbK858TKFtMsr2
         f4bg==
X-Gm-Message-State: APjAAAUgJ2of7HBlogv3SWDhOuURvq+CXUwUrPvSdVAcD4jBdEV5dAGi
        1G6DTsgyveSX0U1PxtSbPxg=
X-Google-Smtp-Source: APXvYqyGr7S/zIkZiW33zhiNeA1BPBdImDRPF4LUUjnKOpKC3TsdQaj51vj30d8WrNyZxaY5E/uPBg==
X-Received: by 2002:a2e:6e10:: with SMTP id j16mr21926270ljc.202.1576009784312;
        Tue, 10 Dec 2019 12:29:44 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id p18sm2503709ljp.39.2019.12.10.12.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:29:43 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Fix restoration of PLLM when exiting suspend
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>
References: <20191210103708.7023-1-jonathanh@nvidia.com>
 <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
Message-ID: <1fe9cd2d-50a2-aae5-95fa-0329acce4c4c@gmail.com>
Date:   Tue, 10 Dec 2019 23:29:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1f2a4f23-5be5-aa7e-6eb4-2aeb4058481d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

10.12.2019 22:28, Dmitry Osipenko пишет:
> Hello Jon,
> 
> 10.12.2019 13:37, Jon Hunter пишет:
>> The suspend entry and exit code for 32-bit Tegra devices assumes that
>> the PLLM (which is used to provide the clock for external memory)
>> is always enabled on entry to suspend. Hence, the current code always
>> disables the PLLM on entry to suspend and re-enables the PLLM on exit
>> from suspend.
>>
>> Since the introduction of the Tegra124 EMC driver by commit 73a7f0a90641
>> ("memory: tegra: Add EMC (external memory controller) driver"), which is
>> used to scale the EMC frequency, PLLM may not be the current clock
>> source for the EMC on entry to suspend and hence may not be enabled.
>> Always enabling the PLLM on exit from suspend can cause the actual
>> status on the PLL to be different from that reported by the common clock
>> framework.
>>
>> On kernels prior to v4.5, the code to set the rate of the PLLM had a
>> test to verify if the PLL was enabled and if the PLL was enabled,
>> setting the rate would fail. Since commit 267b62a96951
>> ("clk: tegra: pll: Update PLLM handling") the test to see if PLLM is
>> enabled was removed.
>>
>> With these earlier kernels, if the PLLM is disabled on entering suspend
>> and the EMC driver attempts to set the parent of the EMC clock to the
>> PLLM on exiting suspend, then the set rate for the PLLM will fail and in
>> turn cause the resume to fail.
>>
>> We should not be re-enabling the PLLM on resume from suspend unless it
>> was enabled on entry to suspend. Therefore, fix this by saving the state
>> of PLLM on entry to suspend and only re-enable it, if it was already
>> enabled.
>>
>> Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
>> Cc: stable@vger.kernel.org
>>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>>  arch/arm/mach-tegra/sleep-tegra30.S | 33 +++++++++++++++++++++++------
>>  1 file changed, 27 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
>> index 3341a12bbb9c..c2f0793a424f 100644
>> --- a/arch/arm/mach-tegra/sleep-tegra30.S
>> +++ b/arch/arm/mach-tegra/sleep-tegra30.S
>> @@ -337,26 +337,42 @@ ENTRY(tegra30_lp1_reset)
>>  	add	r1, r1, #2
>>  	wait_until r1, r7, r3
>>  
>> -	/* enable PLLM via PMC */
>> +	/* restore PLLM state */
>>  	mov32	r2, TEGRA_PMC_BASE
>> +	adr	r7, tegra_pllm_status
>> +	ldr	r1, [r7]
>> +	cmp	r2, #(1 << 12)
>> +	bne	_skip_pllm
>> +
>>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>  	orr	r1, r1, #(1 << 12)
>>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>  
>>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, 0
>> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>> +
>> +_skip_pllm:
>>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, 0
>>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, 0
>>  
>>  	b	_pll_m_c_x_done
>>  
>>  _no_pll_iddq_exit:
>> -	/* enable PLLM via PMC */
>> +	/* restore PLLM state */
>>  	mov32	r2, TEGRA_PMC_BASE
>> +	adr	r7, tegra_pllm_status
>> +	ldr	r1, [r7]
>> +	cmp	r2, #(1 << 12)
>> +	bne	_skip_pllm_no_iddq
>> +
>>  	ldr	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>  	orr	r1, r1, #(1 << 12)
>>  	str	r1, [r2, #PMC_PLLP_WB0_OVERRIDE]
>>  
>>  	pll_enable r1, r0, CLK_RESET_PLLM_BASE, CLK_RESET_PLLM_MISC
>> +	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>> +
>> +_skip_pllm_no_iddq:
>>  	pll_enable r1, r0, CLK_RESET_PLLC_BASE, CLK_RESET_PLLC_MISC
>>  	pll_enable r1, r0, CLK_RESET_PLLX_BASE, CLK_RESET_PLLX_MISC
>>  
>> @@ -364,7 +380,6 @@ _pll_m_c_x_done:
>>  	pll_enable r1, r0, CLK_RESET_PLLP_BASE, CLK_RESET_PLLP_MISC
>>  	pll_enable r1, r0, CLK_RESET_PLLA_BASE, CLK_RESET_PLLA_MISC
>>  
>> -	pll_locked r1, r0, CLK_RESET_PLLM_BASE
>>  	pll_locked r1, r0, CLK_RESET_PLLP_BASE
>>  	pll_locked r1, r0, CLK_RESET_PLLA_BASE
>>  	pll_locked r1, r0, CLK_RESET_PLLC_BASE
>> @@ -526,6 +541,8 @@ __no_dual_emc_chanl:
>>  ENDPROC(tegra30_lp1_reset)
>>  
>>  	.align	L1_CACHE_SHIFT
>> +tegra_pllm_status:
>> +	.word	0
>>  tegra30_sdram_pad_address:
>>  	.word	TEGRA_EMC_BASE + EMC_CFG				@0x0
>>  	.word	TEGRA_EMC_BASE + EMC_ZCAL_INTERVAL			@0x4
>> @@ -624,10 +641,14 @@ tegra30_switch_cpu_to_clk32k:
>>  	add	r1, r1, #2
>>  	wait_until r1, r7, r9
> 
> 
>> -	/* disable PLLM via PMC in LP1 */
>> +	/* disable PLLM, if enabled, via PMC in LP1 */
>> +	adr	r1, tegra_pllm_status
>>  	ldr	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>> -	bic	r0, r0, #(1 << 12)
>> -	str	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>> +	and	r2, r0, #(1 << 12)
>> +	str     r2, [r1]
>> +	cmp	r2, #(1 << 12)
>> +	biceq	r0, r0, #(1 << 12)
>> +	streq	r0, [r4, #PMC_PLLP_WB0_OVERRIDE]
>>  
>>  	/* disable PLLP, PLLA, PLLC and PLLX */
>>  	ldr	r0, [r5, #CLK_RESET_PLLP_BASE]
> 
> PLLM's enable-status could be defined either by PMC or CaR. Thus at
> first you need to check whether PMC overrides CaR's enable and then
> judge the enable state based on PMC or CaR state respectively.
> 

Actually, now I think that it doesn't make sense to check PMC WB0 state
at all. IIUC, PLLM's state of the WB0 register defines whether Boot ROM
should enable PLLM on resume from suspend. Thus it will be correct to
check only the CaR's enable-state of PLLM.

I'm not sure what's the idea of WB0 overriding, maybe to resume faster.
Peter, could you please clarify that?

Looks like it is a bit of nonsense that clk_pll_is_enabled() checks
PMC_PLLP_WB0_OVERRIDE_PLLM_ENABLE for judging of the enable-state. This
is not the first time I'm getting confused by it, perhaps will be
worthwhile to clean up that part of the clk driver's code (if I'm not
missing something).
