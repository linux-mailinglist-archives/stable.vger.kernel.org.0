Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFBD3110CE
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhBER3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:29:43 -0500
Received: from foss.arm.com ([217.140.110.172]:37826 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhBEP7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:59:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A46731B;
        Fri,  5 Feb 2021 09:41:21 -0800 (PST)
Received: from [10.57.60.124] (unknown [10.57.60.124])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E32173F718;
        Fri,  5 Feb 2021 09:41:18 -0800 (PST)
Subject: Re: [PATCH] arm64: Extend workaround for erratum 1024718 to all
 versions of Cortex-A55
To:     Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
References: <20210203230057.3961239-1-suzuki.poulose@arm.com>
 <20210204095457.GA20361@willie-the-truck>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <5a8ea892-98bb-e02e-cced-9ffa7e0bbda9@arm.com>
Date:   Fri, 5 Feb 2021 17:41:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204095457.GA20361@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Will

On 2/4/21 9:54 AM, Will Deacon wrote:
> Hi Suzuki,
> 
> On Wed, Feb 03, 2021 at 11:00:57PM +0000, Suzuki K Poulose wrote:
>> The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
>> we apply the work around for r0p0 - r1p0. Unfortunately this
>> won't be fixed for the future revisions for the CPU. Thus
>> extend the work around for all versions of A55, to cover
>> for r2p0 and any future revisions.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   arch/arm64/kernel/cpufeature.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index e99eddec0a46..db400ca77427 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1455,7 +1455,7 @@ static bool cpu_has_broken_dbm(void)
>>   	/* List of CPUs which have broken DBM support. */
>>   	static const struct midr_range cpus[] = {
>>   #ifdef CONFIG_ARM64_ERRATUM_1024718
>> -		MIDR_RANGE(MIDR_CORTEX_A55, 0, 0, 1, 0),  // A55 r0p0 -r1p0
>> +		MIDR_ALL_VERSIONS(MIDR_CORTEX_A55),
> 
> I think we have bigger problems with this erratum, since cpu_has_hw_af()
> doesn't taken this erratum into account at all, meaning that
> arch_faults_on_old_pte() will return the wrong value on any system with an
> A55.

Please note that we enable HW_AF on these CPUs even with this erratum as
they are not affected. It is only the DBM that we selectively disable. Thus
the AF flag checks are still valid (See __cpu_setup in arch/arm64/mm/proc.S).
Or am I miss something ?

Kind regards
Suzuki

> 
> Please can you fix that along with this patch? You'll need to pay extra
> attention to the stuff I've queued on for-next/faultaround, where we will
> actually want arch_wants_old_prefaulted_pte() to return 'true' if any of the
> CPUs have DBM, since it's a pure performance thing.
> 
> Cheers,
> 
> Will
> 

