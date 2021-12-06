Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E93468EA0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 02:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhLFBpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 20:45:50 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27342 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhLFBpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 20:45:49 -0500
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J6mPs3sRkzbjBK;
        Mon,  6 Dec 2021 09:42:09 +0800 (CST)
Received: from [10.67.102.99] (10.67.102.99) by canpemm500009.china.huawei.com
 (7.192.105.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Mon, 6 Dec
 2021 09:42:20 +0800
Message-ID: <cbd33c29-2ca8-f8bf-d9b5-fe5527b189e4@huawei.com>
Date:   Mon, 6 Dec 2021 09:42:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2, RESEND] sched/rt: Try to restart rt period timer when
 rt runtime exceeded
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20211203033618.11895-1-hucool.lihua@huawei.com>
 <20211204113415.GV16608@worktop.programming.kicks-ass.net>
From:   "Lihua (lihua, ran)" <hucool.lihua@huawei.com>
In-Reply-To: <20211204113415.GV16608@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.99]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes: d0b27fa77854 ("sched: rt-group: synchonised bandwidth period")

---

Thanks for your review~~

在 2021/12/4 19:34, Peter Zijlstra 写道:
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
> Thanks, do you think you can reply here with a Fixes: tag so I can add
> it?
> .
