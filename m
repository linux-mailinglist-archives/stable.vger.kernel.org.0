Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BA3133E4F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 10:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgAHJ2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 04:28:33 -0500
Received: from foss.arm.com ([217.140.110.172]:41212 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbgAHJ2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 04:28:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1168B1FB;
        Wed,  8 Jan 2020 01:28:33 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44DF53F6C4;
        Wed,  8 Jan 2020 01:28:32 -0800 (PST)
Subject: Re: [PATCH 4.14 65/74] coresight: tmc-etf: Do not call
 smp_processor_id from preemptible
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
References: <20200107205135.369001641@linuxfoundation.org>
 <20200107205228.054429793@linuxfoundation.org>
 <20200107230825.GA26430@ubuntu-m2-xlarge-x86>
From:   Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <6deba573-6adb-ea29-329f-9a7bfb1e4e8f@arm.com>
Date:   Wed, 8 Jan 2020 09:28:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107230825.GA26430@ubuntu-m2-xlarge-x86>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nathan,

On 07/01/2020 23:08, Nathan Chancellor wrote:
> On Tue, Jan 07, 2020 at 09:55:30PM +0100, Greg Kroah-Hartman wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> [ Upstream commit 024c1fd9dbcc1d8a847f1311f999d35783921b7f ]
>>

...

>> diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
>> index 336194d059fe..329a201c0c19 100644
>> --- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
>> +++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
>> @@ -308,9 +308,7 @@ static void *tmc_alloc_etf_buffer(struct coresight_device *csdev, int cpu,
>>   	int node;
>>   	struct cs_buffers *buf;
>>   
>> -	if (cpu == -1)
>> -		cpu = smp_processor_id();
>> -	node = cpu_to_node(cpu);
>> +	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);
> 
> This breaks the build on 4.14 (and I believe 4.19 from the looks of it)
> because the event variable is not available without
> commit a0f08a6a9fee ("coresight: Communicate perf event to sink buffer
> allocation functions") from upstream. I am not sure how this should be
> fixed (either backporting the above commit or changing this one somehow)
> but it should be dropped in the meantime.

Thanks for the report. I will send a separate fix for the version where
it breaks. We should be able to use the "cpu" argument directly in these
cases, where event was not introduced.

Cheers
Suzuki
