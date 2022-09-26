Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388C55EA6D3
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiIZNGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbiIZNFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:05:45 -0400
Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F1785588;
        Mon, 26 Sep 2022 04:37:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VQm8Lu9_1664192107;
Received: from 30.240.121.51(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VQm8Lu9_1664192107)
          by smtp.aliyun-inc.com;
          Mon, 26 Sep 2022 19:35:09 +0800
Message-ID: <f0735218-7730-c275-8cee-38df9bec427d@linux.alibaba.com>
Date:   Mon, 26 Sep 2022 19:35:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Len Brown <lenb@kernel.org>, James Morse <james.morse@arm.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        =?UTF-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPoyDnm7TkuZ8p?= 
        <naoya.horiguchi@nec.com>, linmiaohe@huawei.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable <stable@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cuibixuan@linux.alibaba.com, baolin.wang@linux.alibaba.com,
        zhuo.song@linux.alibaba.com
References: <20220916050535.26625-1-xueshuai@linux.alibaba.com>
 <20220924074953.83064-1-xueshuai@linux.alibaba.com>
 <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <CAJZ5v0jAZC81Peowy0iKuq+cy68tyn0OK3a--nW=wWMbRojcxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/9/25 AM1:17, Rafael J. Wysocki 写道:
> On Sat, Sep 24, 2022 at 9:50 AM Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>>
>> If an error is detected as a result of user-space process accessing a
>> corrupt memory location, the CPU may take an abort. Then the platform
>> firmware reports kernel via NMI like notifications, e.g. NOTIFY_SEA,
>> NOTIFY_SOFTWARE_DELEGATED, etc.
>>
>> For NMI like notifications, commit 7f17b4a121d0 ("ACPI: APEI: Kick the
>> memory_failure() queue for synchronous errors") keep track of whether
>> memory_failure() work was queued, and make task_work pending to flush out
>> the queue so that the work is processed before return to user-space.
>>
>> The code use init_mm to check whether the error occurs in user space:
>>
>>     if (current->mm != &init_mm)
>>
>> The condition is always true, becase _nobody_ ever has "init_mm" as a real
>> VM any more.
>>
>> In addition to abort, errors can also be signaled as asynchronous
>> exceptions, such as interrupt and SError. In such case, the interrupted
>> current process could be any kind of thread. When a kernel thread is
>> interrupted, the work ghes_kick_task_work deferred to task_work will never
>> be processed because entry_handler returns to call ret_to_kernel() instead
>> of ret_to_user(). Consequently, the estatus_node alloced from
>> ghes_estatus_pool in ghes_in_nmi_queue_one_entry() will not be freed.
>> After around 200 allocations in our platform, the ghes_estatus_pool will
>> run of memory and ghes_in_nmi_queue_one_entry() returns ENOMEM. As a
>> result, the event failed to be processed.
>>
>>     sdei: event 805 on CPU 113 failed with error: -2
>>
>> Finally, a lot of unhandled events may cause platform firmware to exceed
>> some threshold and reboot.
>>
>> The condition should generally just do
>>
>>     if (current->mm)
>>
>> as described in active_mm.rst documentation.
>>
>> Then if an asynchronous error is detected when a kernel thread is running,
>> (e.g. when detected by a background scrubber), do not add task_work to it
>> as the original patch intends to do.
>>
>> Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
>> Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
> 
> I need the APEI code reviewers to tell me that this is all OK.

Thank you for your reply. OK, let's wait the reviewers comments.

Best Regards,
Shuai


> 
>> ---
>> changes since v1:
>> - add description the side effect and give more details
>>
>>  drivers/acpi/apei/ghes.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index d91ad378c00d..80ad530583c9 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -985,7 +985,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
>>                                 ghes_estatus_cache_add(generic, estatus);
>>                 }
>>
>> -               if (task_work_pending && current->mm != &init_mm) {
>> +               if (task_work_pending && current->mm) {
>>                         estatus_node->task_work.func = ghes_kick_task_work;
>>                         estatus_node->task_work_cpu = smp_processor_id();
>>                         ret = task_work_add(current, &estatus_node->task_work,
>> --
>> 2.20.1.12.g72788fdb
>>
