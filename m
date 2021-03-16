Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E641633D4FE
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 14:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbhCPNhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 09:37:41 -0400
Received: from foss.arm.com ([217.140.110.172]:40958 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235168AbhCPNhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 09:37:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 366FA31B;
        Tue, 16 Mar 2021 06:37:21 -0700 (PDT)
Received: from [10.57.17.216] (unknown [10.57.17.216])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CB423F792;
        Tue, 16 Mar 2021 06:37:19 -0700 (PDT)
Subject: Re: [PATCH][for-stable-v5.11]] arm64: Unconditionally set virtual cpu
 id registers
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, dbrazdil@google.com
References: <20210316112500.85268-1-vladimir.murzin@arm.com>
 <878s6nfd28.wl-maz@kernel.org>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <14ea367a-cdac-145d-ae23-357346ef0b45@arm.com>
Date:   Tue, 16 Mar 2021 13:37:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <878s6nfd28.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 3/16/21 1:22 PM, Marc Zyngier wrote:
> Hi Vladimir,
> 
> On Tue, 16 Mar 2021 11:25:00 +0000,
> Vladimir Murzin <vladimir.murzin@arm.com> wrote:
>>
>> Commit 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> reorganized el2 setup in such way that virtual cpu id registers set
>> only in nVHE, yet they used (and need) to be set irrespective VHE
>> support. Lack of setup causes 32-bit guest stop booting due to MIDR
>> stay undefined.
> 
> Surely this affects 64bit guests as well, doesn't it? I guess the
> 32bit code tries to infer stuff such as the architecture revision from
> MIDR and falls over, and that the 64bit Linux code has less baggage?

Correct, that affects all guests, yet 32-bit tries to lookup processor type
so it is how it became visible to me

> 
>>
>> Fixes: 78869f0f0552 ("arm64: Extract parts of el2_setup into a macro")
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>
>> There is no upstream fix since issue went away due to code there has
>> been reworked in 5.12: nVHE comes first, so virtual cpu id register
>> are always set.
>>
>> Maintainers, please, Ack.
>>
>>  arch/arm64/include/asm/el2_setup.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
>> index f988e94cdf9e..db87daca6b8c 100644
>> --- a/arch/arm64/include/asm/el2_setup.h
>> +++ b/arch/arm64/include/asm/el2_setup.h
>> @@ -113,7 +113,7 @@
>>  .endm
>>  
>>  /* Virtual CPU ID registers */
>> -.macro __init_el2_nvhe_idregs
>> +.macro __init_el2_idregs
>>  	mrs	x0, midr_el1
>>  	mrs	x1, mpidr_el1
>>  	msr	vpidr_el2, x0
>> @@ -165,6 +165,7 @@
>>  	__init_el2_stage2
>>  	__init_el2_gicv3
>>  	__init_el2_hstr
>> +	__init_el2_idregs
>>  
>>  	/*
>>  	 * When VHE is not in use, early init of EL2 needs to be done here.
>> @@ -173,7 +174,6 @@
>>  	 * will be done via the _EL1 system register aliases in __cpu_setup.
>>  	 */
>>  .ifeqs "\mode", "nvhe"
>> -	__init_el2_nvhe_idregs
>>  	__init_el2_nvhe_cptr
>>  	__init_el2_nvhe_sve
>>  	__init_el2_nvhe_prepare_eret
> 
> The couple of VHE systems I have around don't suffer from this issue,
> but it looks like I can trigger it on the FVP model (probably because
> the model is nasty enough to not have VPIDR_EL2 default to anything
> sensible!).

Well firmware could easily hide the issue if it set registers for us ;)

> 
> Anyway, good catch. If you can respin it to drop the reference to
> 32bit guests, I'll happily ack it!

Thanks for prompt review! I'll re-spin it shortly.

Vladimir

> 
> Thanks,
> 
> 	M.
> 

