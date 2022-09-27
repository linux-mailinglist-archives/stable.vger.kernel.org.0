Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D2A5EB902
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 05:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiI0Duf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 23:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiI0Due (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 23:50:34 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA54895EC;
        Mon, 26 Sep 2022 20:50:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VQq.GZ1_1664250625;
Received: from 30.240.121.51(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VQq.GZ1_1664250625)
          by smtp.aliyun-inc.com;
          Tue, 27 Sep 2022 11:50:27 +0800
Message-ID: <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
Date:   Tue, 27 Sep 2022 11:50:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        James Morse <james.morse@arm.com>
Cc:     Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>,
        "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cuibixuan@linux.alibaba.com" <cuibixuan@linux.alibaba.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhuo.song@linux.alibaba.com" <zhuo.song@linux.alibaba.com>
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
 <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
 <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB6083FC6B8D64933C573CAB64FC529@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/9/26 PM11:20, Luck, Tony 写道:
>>>
>>> -               if (task_work_pending && current->mm != &init_mm) {
>>> +               if (task_work_pending && current->mm) {
>>>                         estatus_node->task_work.func = ghes_kick_task_work;
>>>                         estatus_node->task_work_cpu = smp_processor_id();
>>>                         ret = task_work_add(current, &estatus_node->task_work,
> 
> It seems that you are getting errors reported while running kernel threads. This fix avoids
> pointlessly adding "task_work" that will never be processed because kernel threads never
> return to user mode.

Yes, you are right.

> 
> But maybe something else needs to be done? The code was, and with this fix still is,
> taking no action for the error. That doesn't seem right.

Sorry, I don't think so. As far as I know, on Arm platform, hardware error can signal
exceptions including:

- Synchronous External Abort (SEA), e,g. data abort or instruction abort
- Asynchronous External Abort (signalled as SErrors), e,g. L2 can generate SError for
  error responses from the interconnect for a Device or Non-cacheable store
- Fault Handling and Error Recovery interrupts: DDR mainline/demand/scrubber error interrupt

When the error signals asynchronous exceptions (SError or interrupt), any kind of thread can
be interrupted, including kernel thread. Because asynchronous exceptions are signaled in
background, the errors are detected outside of the current execution context.

The GHES driver always queues work to handle memory failure of a page in memory_failure_queue().
If a kernel thread is interrupted:

- Without this fix, the added task_work will never be processed so that the work will not
  be canceled.
- With this fix, the task_work will not be added.

In a conclusion, the error will be handled in a kworker with or without this fix.

The point of fix is that:

- The condition is useless because it is always tree. And I think it is not the original patch
  intends to do.
- The current code leads to memory leaks. The estatus_node will not be freed when task_work is
  added to a kernel thread.


> 
> Are you injecting errors to create this scenario? 

Yes, I am injecting error to create such scenario. After 200 injections, the ghes_estatus_pool
will run of memory and ghes_in_nmi_queue_one_entry() returns ENOMEM. Finally, a lot of unhandled
events may cause platform firmware to exceed some threshold and reboot.

> What does your test do?

My injection includes two steps:

- mmap a device memory for userspace in a driver
- inject uc and trigger write like ras-tools does

I have opened source the code and you can find here[1]. It's forked from your repo and mainly based
on your code :)

By the way, do you have any plans to extend ras-tools to Arm platform. And is there a mail-list
for ras-tools? I send a mail to add test cases to ras-tools several weeks ago, but no response.
May your mailbox regards it as Spam.


[1] https://gitee.com/anolis/ras-tools/tree/arm-devel



