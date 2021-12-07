Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0A846AFE5
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 02:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242987AbhLGBm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 20:42:26 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28278 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbhLGBm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 20:42:26 -0500
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J7NHR0MhYzbjMf;
        Tue,  7 Dec 2021 09:38:43 +0800 (CST)
Received: from [10.67.102.99] (10.67.102.99) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 7 Dec
 2021 09:38:54 +0800
Message-ID: <6770e115-61b7-2721-ee71-c986ebd6c2de@huawei.com>
Date:   Tue, 7 Dec 2021 09:38:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2, RESEND] sched/rt: Try to restart rt period timer when
 rt runtime exceeded
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20211203033618.11895-1-hucool.lihua@huawei.com>
 <YanElPGuGJ8J6UK9@kroah.com>
From:   "Lihua (lihua, ran)" <hucool.lihua@huawei.com>
In-Reply-To: <YanElPGuGJ8J6UK9@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.99]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2021/12/3 15:17, Greg KH 写道:
> On Fri, Dec 03, 2021 at 03:36:18AM +0000, Li Hua wrote:
>> When rt_runtime is modified from -1 to a valid control value, it may
>> cause the task to be throttled all the time. Operations like the following
>> will trigger the bug. E.g:
>> 1. echo -1 > /proc/sys/kernel/sched_rt_runtime_us
>> 2. Run a FIFO task named A that executes while(1)
>> 3. echo 950000 > /proc/sys/kernel/sched_rt_runtime_us
>>
>> When rt_runtime is -1, The rt period timer will not be activated when task
>> A enqueued. And then the task will be throttled after setting rt_runtime to
>> 950,000. The task will always be throttled because the rt period timer is
>> not activated.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Li Hua <hucool.lihua@huawei.com>
>> ---
>> v1->v2:
>>    - call do_start_rt_bandwidth to reduce repetitive code.
>>    - use raw_spin_lock_irqsave to avoid deadlock on a timer context.
>> ---
>>   kernel/sched/rt.c | 23 ++++++++++++++++++-----
>>   1 file changed, 18 insertions(+), 5 deletions(-)
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
I did not CC: stable in the signed-off region，Is that so？
> </formletter>
> .
