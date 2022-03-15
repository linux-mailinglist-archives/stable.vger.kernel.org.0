Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8932B4D9297
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 03:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344442AbiCOCbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 22:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344432AbiCOCbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 22:31:37 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957AB47079;
        Mon, 14 Mar 2022 19:30:26 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KHcjT0DVNz9snV;
        Tue, 15 Mar 2022 10:26:37 +0800 (CST)
Received: from [10.67.109.61] (10.67.109.61) by canpemm500006.china.huawei.com
 (7.192.105.130) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 15 Mar
 2022 10:30:24 +0800
Subject: Re: [PATCH] cpufreq: fix cpufreq_get() can't get correct CPU
 frequency
To:     "Rafael J. Wysocki" <rafael@kernel.org>
References: <20220311081111.159639-1-zhengzucheng@huawei.com>
 <CAJZ5v0jponp=ijVx6W=eNEGrfTKh0KbGmOQG_V0P-Mq366559g@mail.gmail.com>
CC:     Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
From:   zhengzucheng <zhengzucheng@huawei.com>
Message-ID: <100a5228-a941-0ff7-8133-14273472b6f5@huawei.com>
Date:   Tue, 15 Mar 2022 10:30:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0jponp=ijVx6W=eNEGrfTKh0KbGmOQG_V0P-Mq366559g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.61]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/3/11 23:52, Rafael J. Wysocki wrote:
> On Fri, Mar 11, 2022 at 9:11 AM z00314508 <zhengzucheng@huawei.com> wrote:
>> From: Zucheng Zheng <zhengzucheng@huawei.com>
>>
>> On some specific platforms, the cpufreq driver does not define
>> cpufreq_driver.get() routine (eg:x86 intel_pstate driver), as a
> I guess you mean the cpufreq driver ->get callback.
>
> No, intel_pstate doesn't implement it, because it cannot reliably
> return the current CPU frequency.
>
>> result, the cpufreq_get() can't get the correct CPU frequency.
> No, it can't, if intel_pstate is the driver, but what's the problem?
> This function is only called in one place in the kernel and not on x8
> even.
>
>> Modern x86 processors include the hardware needed to accurately
>> calculate frequency over an interval -- APERF, MPERF and the TSC.
> You can compute the average frequency over an interval, but ->get is
> expected to return the actual current frequency at the time call time.
>
>> Here we use arch_freq_get_on_cpu() in preference to any driver
>> driver-specific cpufreq_driver.get() routine to get CPU frequency.
>>
>> Fixes: f8475cef9008 ("x86: use common aperfmperf_khz_on_cpu() to calculate KHz using APERF/MPERF")
> No kidding.
>
>> Signed-off-by: Zucheng Zheng <zhengzucheng@huawei.com>
>> ---
>>   drivers/cpufreq/cpufreq.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 80f535cc8a75..d777257b4454 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1806,10 +1806,14 @@ unsigned int cpufreq_get(unsigned int cpu)
>>   {
>>          struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
>>          unsigned int ret_freq = 0;
>> +       unsigned int freq;
>>
>>          if (policy) {
>>                  down_read(&policy->rwsem);
>> -               if (cpufreq_driver->get)
>> +               freq = arch_freq_get_on_cpu(policy->cpu);
>> +               if (freq)
>> +                       ret_freq = freq;
>> +               else if (cpufreq_driver->get)
> Again, what problem exactly does this address?
Thank you for review.

In some scenarios, cpufreq driver ->get is not defined,
some driver get the CPU frequency by calling cpufreq_get() will return 0.
The modification to this problem is inspired by the implementation of 
the show_scaling_cur_freq().
>
>>                          ret_freq = __cpufreq_get(policy);
>>                  up_read(&policy->rwsem);
>>
>> --
> .
>

