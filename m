Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84E1306357
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 19:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbhA0Sa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 13:30:58 -0500
Received: from foss.arm.com ([217.140.110.172]:59812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236712AbhA0Sa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 13:30:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DB881042;
        Wed, 27 Jan 2021 10:30:08 -0800 (PST)
Received: from [10.57.40.145] (unknown [10.57.40.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 176F53F68F;
        Wed, 27 Jan 2021 10:30:05 -0800 (PST)
Subject: Re: [PATCH v2] coresight: etm4x: Handle accesses to TRCSTALLCTLR
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, coresight@lists.linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Leo Yan <leo.yan@linaro.org>,
        Mike Leach <mike.leach@linaro.org>
References: <20210126145614.3607093-1-suzuki.poulose@arm.com>
 <20210127120032.3611851-1-suzuki.poulose@arm.com>
 <20210127174340.GA1162729@xps15>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <ed5d0810-c226-87c1-3808-ef36b4e9719c@arm.com>
Date:   Wed, 27 Jan 2021 18:29:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127174340.GA1162729@xps15>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/21 5:43 PM, Mathieu Poirier wrote:
> Good day,
> 
> On Wed, Jan 27, 2021 at 12:00:32PM +0000, Suzuki K Poulose wrote:
>> TRCSTALLCTLR register is only implemented if
>>
>>     TRCIDR3.STALLCTL == 0b1
>>
>> Make sure the driver touches the register only it is implemented.
>>
>> Cc: stable@vger.kernel.org
>> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
>> Cc: Leo Yan <leo.yan@linaro.org>
>> Cc: Mike Leach <mike.leach@linaro.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>> Changes since v1:
>>    - No change to the patch, fixed the stable email address and
>>      added usual reviewers.
>> ---
>>   drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
>>   drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 3 +++
>>   2 files changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
>> index b40e3c2bf818..814b49dae0c7 100644
>> --- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
>> +++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
>> @@ -367,7 +367,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
>>   	etm4x_relaxed_write32(csa, 0x0, TRCAUXCTLR);
>>   	etm4x_relaxed_write32(csa, config->eventctrl0, TRCEVENTCTL0R);
>>   	etm4x_relaxed_write32(csa, config->eventctrl1, TRCEVENTCTL1R);
>> -	etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
>> +	if (drvdata->stallctl)
>> +		etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
>>   	etm4x_relaxed_write32(csa, config->ts_ctrl, TRCTSCTLR);
>>   	etm4x_relaxed_write32(csa, config->syncfreq, TRCSYNCPR);
>>   	etm4x_relaxed_write32(csa, config->ccctlr, TRCCCCTLR);
>> @@ -1545,7 +1546,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
>>   	state->trcauxctlr = etm4x_read32(csa, TRCAUXCTLR);
>>   	state->trceventctl0r = etm4x_read32(csa, TRCEVENTCTL0R);
>>   	state->trceventctl1r = etm4x_read32(csa, TRCEVENTCTL1R);
>> -	state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
>> +	if (drvdata->stallctl)
>> +		state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
>>   	state->trctsctlr = etm4x_read32(csa, TRCTSCTLR);
>>   	state->trcsyncpr = etm4x_read32(csa, TRCSYNCPR);
>>   	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
>> @@ -1657,7 +1659,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
>>   	etm4x_relaxed_write32(csa, state->trcauxctlr, TRCAUXCTLR);
>>   	etm4x_relaxed_write32(csa, state->trceventctl0r, TRCEVENTCTL0R);
>>   	etm4x_relaxed_write32(csa, state->trceventctl1r, TRCEVENTCTL1R);
>> -	etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
>> +	if (drvdata->stallctl)
>> +		etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
>>   	etm4x_relaxed_write32(csa, state->trctsctlr, TRCTSCTLR);
>>   	etm4x_relaxed_write32(csa, state->trcsyncpr, TRCSYNCPR);
>>   	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
>> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
>> index 1c490bcef3ad..cd9249fbf913 100644
>> --- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
>> +++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
>> @@ -296,6 +296,9 @@ static ssize_t mode_store(struct device *dev,
>>   	if (kstrtoul(buf, 16, &val))
>>   		return -EINVAL;
>>   
>> +	if ((val & ETM_MODE_ISTALL_EN) && !drvdata->stallctl)
>> +		return -EINVAL;
>> +
> 
> We have two choices here:
> 
> 1) Follow what is already done in this function for implementation define
> options like ETM_MODE_BB, ETMv4_MODE_CTXID, ETM_MODE_RETURNSTACK and others.  In
> that case we would have:
> 
>          /* bit[8], Instruction stall bit */
>          if ((config->mode & ETM_MODE_ISTALL_EN) && drvdata->stallctl == true))
>                  config->stall_ctrl |= BIT(8);
>          else
>                  config->stall_ctrl &= ~BIT(8);
> 
> 2) Return -EINVAL when something is not supported, like you have above.  In that
> case we'd have to enact the same behavior for all the options, which has the > potential of breaking user space.

I did think about this and but now I agree  1 is better for now. I will respin.


Cheers
Suzuki
