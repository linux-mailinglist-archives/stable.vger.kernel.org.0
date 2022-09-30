Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04825F0302
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 04:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiI3Cw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 22:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiI3Cwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 22:52:54 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EBCE905E;
        Thu, 29 Sep 2022 19:52:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0VR.txtd_1664506365;
Received: from 30.240.121.51(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VR.txtd_1664506365)
          by smtp.aliyun-inc.com;
          Fri, 30 Sep 2022 10:52:47 +0800
Message-ID: <0f23cee8-9139-742c-a9d1-01674b16d05c@linux.alibaba.com>
Date:   Fri, 30 Sep 2022 10:52:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Content-Language: en-US
To:     "Luck, Tony" <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        James Morse <james.morse@arm.com>,
        baicar@os.amperecomputing.com
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
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
 <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f09e6aee-5d7f-62c2-8a6e-d721d8b22699@linux.alibaba.com>
 <SJ1PR11MB60837ABF899B5CF1F01D68D1FC579@SJ1PR11MB6083.namprd11.prod.outlook.com>
From:   Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB60837ABF899B5CF1F01D68D1FC579@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-14.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/9/30 AM4:52, Luck, Tony 写道:
> Thanks for your patient explanations.

You are welcome :)

> 
>> STEP2: In IRQ context, ghes_proc/_in_irq() queues memory failure work on current CPU
>> in workqueue and add task work to sync with the workqueue.
> 
> Why is there a difference if the interrupted task was a user task vs. a kernel thread?
> 
> It seems arbitrary. If the error can be handled in the kernel thread case without
> a task_work_add() to the current process, can't all errors be handled this way?

I'm afraid not. The kworker in workqueue is asynchronous with ret_to_user() of the
interrupted task. If we return to user-space before the queued memory_failure() work
is processed, we will take the fault again when the error is signal by synchronous
external abort. This loop may cause platform firmware to exceed some threshold and
reboot.

When a user task consuming poison data, a synchronous external abort will be signaled,
for example "einj_mem_uc single" in ras-tools. In such case, the handling flow will
be like bellow:

----------------------------------STEP 0-------------------------------------------
[ghes_sdei_critical_callback: current einj_mem_uc, local cpu]
ghes_sdei_critical_callback
    => __ghes_sdei_callback
        => ghes_in_nmi_queue_one_entry: peak and read estatus
        => irq_work_queue(&ghes_proc_irq_work) // ghes_proc_in_irq - irq_work
[ghes_sdei_critical_callback: return]
-----------------------------------STEP 1------------------------------------------
[ghes_proc_in_irq: current einj_mem_uc, local cpu]
            => ghes_do_proc
                => ghes_handle_memory_failure
                    => ghes_do_memory_failure
                        => memory_failure_queue	- put work task on a specific cpu
                            => if (kfifo_put(&mf_cpu->fifo, entry))
                                  schedule_work_on(smp_processor_id(), &mf_cpu->work);
            => task_work_add(current, &estatus_node->task_work, TWA_RESUME);
[ghes_proc_in_irq: return]
-----------------------------------STEP 3------------------------------------------
// kworker preempts einj_mem_uc on local cpu due to RESCHED flag
[memory_failure_work_func: current kworker, local cpu]	
     => memory_failure_work_func(&mf_cpu->work)
        => while kfifo_get(&mf_cpu->fifo, &entry);	// until get no work
            => soft/hard offline
------------------------------------STEP 4-----------------------------------------
[ghes_kick_task_work: current einj_mem_uc, other cpu]
                => memory_failure_queue_kick
                    => cancel_work_sync //wait memory_failure_work_func finish
                    => memory_failure_work_func(&mf_cpu->work)
                        => kfifo_get(&mf_cpu->fifo, &entry); // no work here
------------------------------------STEP 5-----------------------------------------
[current einj_mem_uc returned to userspace]
                => Killed by SIGBUS

STEP 4 add a task work to ensure the queued memory_failure() work is processed before
returning to user-space. And the interrupted user will be killed by SIGBUS signal.

If we delete STEP 4, the interrupted user task will return to user space synchronously
and consume the poison data again.


> 
> The current thread likely has nothing to do with the error. Just a matter of chance
> on what is running when the NMI is delivered, right?

Yes, the error is actually handled in workqueue. I think the point is that the
synchronous exception signaled by synchronous external abort must be handled
synchronously, otherwise, it will be signaled again.

Best Regards,
Shuai
