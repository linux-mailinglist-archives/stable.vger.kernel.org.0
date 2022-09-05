Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72405AC935
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 05:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiIEDru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 23:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIEDrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 23:47:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494442BB00;
        Sun,  4 Sep 2022 20:47:48 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MLZBS53lqzkWvg;
        Mon,  5 Sep 2022 11:44:00 +0800 (CST)
Received: from [10.67.109.61] (10.67.109.61) by canpemm500006.china.huawei.com
 (7.192.105.130) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 5 Sep
 2022 11:47:46 +0800
Message-ID: <0b2f6919-7ed4-b30d-e92b-355c09bbfd25@huawei.com>
Date:   Mon, 5 Sep 2022 11:47:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH -next] sched/cputime: Fix the bug of reading time backward
 from /proc/stat
To:     Peter Zijlstra <peterz@infradead.org>,
        Li Hua <hucool.lihua@huawei.com>
CC:     <mingo@redhat.com>, <juri.lelli@redhat.com>,
        <vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
        <rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
        <bristot@redhat.com>, <vschneid@redhat.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20220813000102.42051-1-hucool.lihua@huawei.com>
 <YvoAk1pnU4gZcFJ1@worktop.programming.kicks-ass.net>
From:   zhengzucheng <zhengzucheng@huawei.com>
In-Reply-To: <YvoAk1pnU4gZcFJ1@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.61]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Assume that a CPU time“ A” is read from /proc/stat， and after a while,  
a CPU time “B” is read. If T = B – A < 0, T is identified as a large 
number as an unsigned integer. As a result, the CPU usage calculated by 
this way will be abnormally high. It seems to be a problem to be fixed.

original link:
https://lore.kernel.org/lkml/20220813000102.42051-1-hucool.lihua@huawei.com/

在 2022/8/15 16:15, Peter Zijlstra 写道:
> On Sat, Aug 13, 2022 at 08:01:02AM +0800, Li Hua wrote:
>> The problem that the statistical time goes backward, the value read first is 319, and the value read again is 318. As follows：
>> first：
>> cat /proc/stat |  grep cpu1
>> cpu1    319    0    496    41665    0    0    0    0    0    0
>> then：
>> cat /proc/stat |  grep cpu1
>> cpu1    318    0    497    41674    0    0    0    0    0    0
>>
>> Time goes back, which is counterintuitive.
>>
>> After debug this, The problem is caused by the implementation of kcpustat_cpu_fetch_vtime. As follows：
>>
>>                                CPU0                                                                          CPU1
>> First:
>> show_stat():
>>      ->kcpustat_cpu_fetch()
>>          ->kcpustat_cpu_fetch_vtime()
>>              ->cpustat[CPUTIME_USER] = kcpustat_cpu(cpu) + vtime->utime + delta;              rq->curr is in user mod
>>               ---> When CPU1 rq->curr running on userspace, need add utime and delta
>>                                                                                               --->  rq->curr->vtime->utime is less than 1 tick
>> Then:
>> show_stat():
>>      ->kcpustat_cpu_fetch()
>>          ->kcpustat_cpu_fetch_vtime()
>>              ->cpustat[CPUTIME_USER] = kcpustat_cpu(cpu);                                     rq->curr is in kernel mod
>>              ---> When CPU1 rq->curr running on kernel space, just got kcpustat
> This is unreadable, what?!?
> .
