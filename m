Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C5BE87A7
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 13:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfJ2MAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 08:00:46 -0400
Received: from foss.arm.com ([217.140.110.172]:51218 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJ2MAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 08:00:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C98F41F1;
        Tue, 29 Oct 2019 05:00:44 -0700 (PDT)
Received: from [10.37.13.3] (unknown [10.37.13.3])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 261F03F71E;
        Tue, 29 Oct 2019 05:00:42 -0700 (PDT)
Subject: Re: [PATCH] arm64: cpufeature: Enable Qualcomm erratas
To:     will@kernel.org, bjorn.andersson@linaro.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, broonie@kernel.org
References: <20191029060432.1208859-1-bjorn.andersson@linaro.org>
 <20191029113956.GC12103@willie-the-truck>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <1d1a3dca-16ce-f541-5d78-e61ad24227e0@arm.com>
Date:   Tue, 29 Oct 2019 12:04:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20191029113956.GC12103@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/29/2019 11:39 AM, Will Deacon wrote:
> On Mon, Oct 28, 2019 at 11:04:32PM -0700, Bjorn Andersson wrote:
>> With the introduction of 'cce360b54ce6 ("arm64: capabilities: Filter the
>> entries based on a given mask")' the Qualcomm erratas are no long
>> applied.
>>
>> The result of not applying errata 1003 is that MSM8996 runs into various
>> RCU stalls and fails to boot most of the times.
>>
>> Give both 1003 and 1009 a "type" to ensure they are not filtered out in
>> update_cpu_capabilities().
> 
> Oh nasty. Thanks for debugging and fixing this.
> 
>> Fixes: cce360b54ce6 ("arm64: capabilities: Filter the entries based on a given mask")
>> Cc: stable@vger.kernel.org
>> Reported-by: Mark Brown <broonie@kernel.org>
>> Suggested-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> ---
>>   arch/arm64/kernel/cpu_errata.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
>> index df9465120e2f..cdd8df033536 100644
>> --- a/arch/arm64/kernel/cpu_errata.c
>> +++ b/arch/arm64/kernel/cpu_errata.c
>> @@ -780,6 +780,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>   	{
>>   		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
>>   		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
>> +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
>>   		.matches = cpucap_multi_entry_cap_matches,
> 
> This should probably be ARM64_CPUCAP_LOCAL_CPU_ERRATUM instead, but I'll
> want Suzuki's ack before I take the change.

Yes, it must be ARM64_CPUCAP_LOCAL_CPU_ERRATUM.

It may be a good idea to stick in a check to make sure that the scope is
set for all the capabilities in a separate patch. e.g,

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d260e3bdf07b..51a79b4a44eb 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -546,6 +546,8 @@ static void __init
  init_cpu_hwcaps_indirect_list_from_array(const struct 
arm64_cpu_capabilities *caps)
  {
  	for (; caps->matches; caps++) {
+		WARN(!cpucap_default_scope(caps),
+		     "Invalid scope for capability %d\n", caps->capability);
  		if (WARN(caps->capability >= ARM64_NCAPS,
  			"Invalid capability %d\n", caps->capability))
			continue;

Otherwise looks good to me.

>>   		.match_list = qcom_erratum_1003_list,
>>   	},
>> @@ -788,6 +789,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>>   	{
>>   		.desc = "Qualcomm erratum 1009, ARM erratum 1286807",
>>   		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
>> +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
>>   		ERRATA_MIDR_RANGE_LIST(arm64_repeat_tlbi_cpus),
> 
> ERRATA_MIDR_RANGE_LIST sets the type already, so I think this is redundant.
> 
> Will
> 



Cheers
Suzuki
