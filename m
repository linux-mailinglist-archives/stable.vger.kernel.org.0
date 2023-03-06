Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139076AB9D8
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 10:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCFJ2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 04:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjCFJ2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 04:28:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0C31BC3;
        Mon,  6 Mar 2023 01:28:43 -0800 (PST)
Received: from dggpeml500018.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PVY8z3GYrznWnL;
        Mon,  6 Mar 2023 17:25:55 +0800 (CST)
Received: from [10.67.111.186] (10.67.111.186) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 17:28:41 +0800
Message-ID: <1f8388a8-39cf-080c-4a6d-36b3059544a5@huawei.com>
Date:   Mon, 6 Mar 2023 17:28:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: Patch "sched/fair: sanitize vruntime of entity being placed" has
 been added to the 4.14-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Sasha Levin <sashal@kernel.org>, <stable-commits@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
References: <20230305040248.1787312-1-sashal@kernel.org>
 <cf0108ec-d949-a5ab-7367-f358b6685873@huawei.com>
 <ZAWwIrMQ2EUikr6t@kroah.com>
From:   Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <ZAWwIrMQ2EUikr6t@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.186]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500018.china.huawei.com (7.185.36.186)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2023/3/6 17:19, Greg KH 写道:
> On Mon, Mar 06, 2023 at 04:31:57PM +0800, Zhang Qiao wrote:
>>
>>
>> 在 2023/3/5 12:02, Sasha Levin 写道:
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     sched/fair: sanitize vruntime of entity being placed
>>>
>>> to the 4.14-stable tree which can be found at:
>>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>
>>> The filename of the patch is:
>>>      sched-fair-sanitize-vruntime-of-entity-being-placed.patch
>>> and it can be found in the queue-4.14 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>>
>>>
>>>
>>> commit 38247e1de3305a6ef644404ac818bc6129440eae
>>
>> Hi,
>> This patch has significant impact on the hackbench.throughput [1].
>> Please don't backport this patch.
>>
>> [1] https://lore.kernel.org/lkml/202302211553.9738f304-yujie.liu@intel.com/T/#u
> 
> This link says it made hackbench.throughput faster, not slower, so why
> would we NOT want it?

Please see this section. In some cases, this patch reset task's vruntime by mistake and
will lead to wrong results.


On Tue, Feb 21, 2023 at 03:34:16PM +0800, kernel test robot wrote:
>
>FYI, In addition to that, the commit also has significant impact on the following tests:
>
> +------------------+--------------------------------------------------+
> | testcase: change | hackbench: hackbench.throughput -8.1% regression |
> | test machine     | 104 threads 2 sockets (Skylake) with 192G memory |
> | test parameters  | cpufreq_governor=performance                     |
> |                  | ipc=socket                                       |
> |                  | iterations=4                                     |
> |                  | mode=process                                     |
> |                  | nr_threads=100%                                  |
> +------------------+--------------------------------------------------+
>
> Details are as below:


Thanks.
Zhang Qiao.

> 
> confused,
> 
> greg k-h
> .
> 
