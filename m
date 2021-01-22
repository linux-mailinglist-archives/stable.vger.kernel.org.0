Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9A3001C4
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 12:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbhAVLjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 06:39:47 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:23715 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbhAVL0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 06:26:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611314771; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Wb7HhulwY9fAL/m3pmVgVR2RQUXwnxKpifYKsmCSYVw=; b=R62nZC+sfENRzJNVsXXYjIOH9HVVW0ISCZwNYDWYSD09oLTyaVyMONAq9k5HrxTPYOITaVYf
 FX1xZKxEbY/JMJQIB34InBOTeCTQrPCUxrO/FqJ7Hsj54HgJquA4yrMmkQNZE3OXHkNDbzLh
 tFMGXhn/COlDsyEvp8Wm2OP2RoU=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 600ab6302c36b2106d15033a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 Jan 2021 11:25:36
 GMT
Sender: gkohli=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DB61EC433C6; Fri, 22 Jan 2021 11:25:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [192.168.1.4] (unknown [106.212.224.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gkohli)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E27C7C433CA;
        Fri, 22 Jan 2021 11:25:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E27C7C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=gkohli@codeaurora.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
To:     Greg KH <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Julia Lawall <julia.lawall@inria.fr>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
 <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
 <20210121140951.2a554a5e@gandalf.local.home>
 <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
 <20210121153732.43d7b96b@gandalf.local.home> <YAqwD/ivTgVJ7aap@kroah.com>
From:   Gaurav Kohli <gkohli@codeaurora.org>
Message-ID: <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
Date:   Fri, 22 Jan 2021 16:55:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <YAqwD/ivTgVJ7aap@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/22/2021 4:29 PM, Greg KH wrote:
> On Thu, Jan 21, 2021 at 03:37:32PM -0500, Steven Rostedt wrote:
>> On Thu, 21 Jan 2021 23:15:22 +0300
>> Denis Efremov <efremov@linux.com> wrote:
>>
>>> On 1/21/21 10:09 PM, Steven Rostedt wrote:
>>>> On Thu, 21 Jan 2021 17:30:40 +0300
>>>> Denis Efremov <efremov@linux.com> wrote:
>>>>    
>>>>> Hi,
>>>>>
>>>>> This patch (CVE-2020-27825) was tagged with
>>>>> Fixes: b23d7a5f4a07a ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
>>>>>
>>>>> I'm not an expert here but it seems like b23d7a5f4a07a only refactored
>>>>> ring_buffer_reset_cpu() by introducing reset_disabled_cpu_buffer() without
>>>>> significant changes. Hence, mutex_lock(&buffer->mutex)/mutex_unlock(&buffer->mutex)
>>>>> can be backported further than b23d7a5f4a07a~ and to all LTS kernels. Is
>>>>> b23d7a5f4a07a the actual cause of the bug?
>>>>>   
>>>>
>>>> Ug, that looks to be a mistake. Looking back at the thread about this:
>>>>
>>>>    https://lore.kernel.org/linux-arm-msm/20200915141304.41fa7c30@gandalf.local.home/
>>>
>>> I see from the link that it was planned to backport the patch to LTS kernels:
>>>
>>>> Actually we are seeing issue in older kernel like 4.19/4.14/5.4 and there below patch was not
>>>> present in stable branches:
>>>> Commit b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
>>>
>>> The point is that it's not backported yet. Maybe because of Fixes tag. I've discovered
>>> this while trying to formalize CVE-2020-27825 bug in cvehound
>>> https://github.com/evdenis/cvehound/blob/master/cvehound/cve/CVE-2020-27825.cocci
>>>
>>> I think that the backport to the 4.4+ should be something like:
>>>
>>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>>> index 547a3a5ac57b..2171b377bbc1 100644
>>> --- a/kernel/trace/ring_buffer.c
>>> +++ b/kernel/trace/ring_buffer.c
>>> @@ -4295,6 +4295,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
>>>   	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>>>   		return;
>>>   
>>> +	mutex_lock(&buffer->mutex);
>>> +
>>>   	atomic_inc(&buffer->resize_disabled);
>>>   	atomic_inc(&cpu_buffer->record_disabled);
>>>   
>>> @@ -4317,6 +4319,8 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
>>>   
>>>   	atomic_dec(&cpu_buffer->record_disabled);
>>>   	atomic_dec(&buffer->resize_disabled);
>>> +
>>> +	mutex_unlock(&buffer->mutex);
>>>   }
>>>   EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
>>>   
>>
>> That could possibly work.

Yes, this will work, As i have tested similar patch for internal testing 
for kernel branches like 5.4/4.19.

> 
> Ok, so what can I do here?  Can someone resend this as a backport to the
> other stable kernels in this way so that I can queue it up?
> 
> thanks,
> 
> greg k-h
> 

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center,
Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
