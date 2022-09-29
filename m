Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B264F5EEBD2
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 04:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiI2Cec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 22:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbiI2CeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 22:34:07 -0400
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09764126B60;
        Wed, 28 Sep 2022 19:33:43 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0VQy2tsA_1664418817;
Received: from 30.240.121.51(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0VQy2tsA_1664418817)
          by smtp.aliyun-inc.com;
          Thu, 29 Sep 2022 10:33:39 +0800
Message-ID: <f09e6aee-5d7f-62c2-8a6e-d721d8b22699@linux.alibaba.com>
Date:   Thu, 29 Sep 2022 10:33:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
From:   Shuai Xue <xueshuai@linux.alibaba.com>
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
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
 <79cb9aee-9ad5-00f4-3f7a-9c409f502685@linux.alibaba.com>
 <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <SJ1PR11MB60830CBCB42CFF552A2B6CF0FC559@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



在 2022/9/28 AM1:47, Luck, Tony 写道:
> I follow and agree with everything up until:
> 
>> In a conclusion, the error will be handled in a kworker with or without this fix.

> 
> It isn't handled during the interrupt (it can't be).

Yes, it is not handled during the interrupt and it does not have to.

>
> Who handles the error if the interrupt happens during the execution of a kthread?

As I mentioned, the GHES driver always queues work into workqueue to handle memory
failure of a page in memory_failure_queue(), so the **worker will be scheduled and
handle memory failure later**.

> 
> Can't use the task_work_add() trick to handle it (because this thread never returns to user mode).

Yes, it can not. And this is the key point to fix.

> 
> So how is the error handled?
> 

The workflow to handle hardware error is summery as bellow:

-----------------------------------------------------------------------------
[ghes_sdei_critical_callback: current swapper/3, CPU 3]
ghes_sdei_critical_callback
    => __ghes_sdei_callback
        => ghes_in_nmi_queue_one_entry 		// peak and read estatus
        => irq_work_queue(&ghes_proc_irq_work) <=> ghes_proc_in_irq // irq_work
[ghes_sdei_critical_callback: return]
-----------------------------------------------------------------------------
[ghes_proc_in_irq: current swapper/3, CPU 3]
            => ghes_do_proc
                => ghes_handle_memory_failure
                    => ghes_do_memory_failure
                        => memory_failure_queue	 // put work task on current CPU
                            => if (kfifo_put(&mf_cpu->fifo, entry))
                                  schedule_work_on(smp_processor_id(), &mf_cpu->work);
            => task_work_add(current, &estatus_node->task_work, TWA_RESUME); // fix here, always added to current
[ghes_proc_in_irq: return]
-----------------------------------------------------------------------------
// kworker preempts swapper/3 on CPU 3 due to RESCHED flag
[memory_failure_work_func: current kworker, CPU 3]	
     => memory_failure_work_func(&mf_cpu->work)
        => while kfifo_get(&mf_cpu->fifo, &entry);	// until get no work
            => soft/hard offline
-----------------------------------------------------------------------------

STEP 0: The firmware notifies hardware error to kernel through is SDEI
(ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED).

STEP 1: In SDEI callback (or any NMI-like handler), memory from ghes_estatus_pool is
used to save estatus, and added to the ghes_estatus_llist. The swapper running on
CPU 3 is interrupted. irq_work_queue() causes ghes_proc_in_irq() to run in IRQ
context where each estatus in ghes_estatus_llist is processed.

STEP2: In IRQ context, ghes_proc_in_irq() queues memory failure work on current CPU
in workqueue and add task work to sync with the workqueue.

STEP3: The kworker preempts the current running thread and get CPU 3. Then memory failure
is processed in kworker.

(STEP4 for user thread: ghes_kick_task_work() is called as task_work to ensure any
queued workqueue has been done before returning to user-space. The estatus_node is freed.)

If the task work is not added, estatus_node->task_work.func will be NULL, and estatus_node
is freed in STEP 2.

Hope it helps to make the problem clearer. You can also check the stack dumped in key
function in above flow.

Best Regards,
Shuai


---------------------------------------------------------------------------------------
dump_stack() is added in:
- __ghes_sdei_callback()
- ghes_proc_in_irq()
- memory_failure_queue_kick()
- memory_failure_work_func()
- memory_failure()

[  485.457761] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G            E      6.0.0-rc5+ #33
[  485.457769] Hardware name: xxxx
[  485.457771] Call trace:
[  485.457772]  dump_backtrace+0xe8/0x12c
[  485.457779]  show_stack+0x20/0x50
[  485.457781]  dump_stack_lvl+0x68/0x84
[  485.457785]  dump_stack+0x18/0x34
[  485.457787]  __ghes_sdei_callback+0x24/0x64
[  485.457789]  ghes_sdei_critical_callback+0x5c/0x94
[  485.457792]  sdei_event_handler+0x28/0x90
[  485.457795]  do_sdei_event+0x74/0x160
[  485.457797]  __sdei_handler+0x60/0xf0
[  485.457799]  __sdei_asm_handler+0xbc/0x18c
[  485.457801]  cpu_do_idle+0x14/0x80
[  485.457802]  default_idle_call+0x50/0x114
[  485.457804]  cpuidle_idle_call+0x16c/0x1c0
[  485.457806]  do_idle+0xb8/0x110
[  485.457808]  cpu_startup_entry+0x2c/0x34
[  485.457809]  secondary_start_kernel+0xf0/0x144
[  485.457812]  __secondary_switched+0xb0/0xb4

[  485.459513] EDAC MC0: 1 UE multi-symbol chipkill ECC on unknown memory (node:0 card:3 module:0 rank:0 bank_group:0 bank_address:0 device:0 row:624 column:384 chip_id:0 page:0x89c033 offset:0x400 grain:1 - APEI location: node:0 card:3 module:0 rank:0 bank_group:0 bank_address:0 device:0 row:624 column:384 chip_id:0 status(0x0000000000000400): Storage error in DRAM memory)
[  485.459523] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
[  485.470607] {2}[Hardware Error]: event severity: recoverable
[  485.476252] {2}[Hardware Error]:  precise tstamp: 2022-09-29 09:31:27
[  485.482678] {2}[Hardware Error]:  Error 0, type: recoverable
[  485.488322] {2}[Hardware Error]:   section_type: memory error
[  485.494052] {2}[Hardware Error]:    error_status: Storage error in DRAM memory (0x0000000000000400)
[  485.503081] {2}[Hardware Error]:   physical_address: 0x000000089c033400
[  485.509680] {2}[Hardware Error]:   node:0 card:3 module:0 rank:0 bank_group:0 bank_address:0 device:0 row:624 column:384 chip_id:0
[  485.521487] {2}[Hardware Error]:   error_type: 5, multi-symbol chipkill ECC

[  485.528439] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G            E      6.0.0-rc5+ #33
[  485.528440] Hardware name: AlibabaCloud AliServer-Xuanwu2.0AM-02-2UC1P-5B/M, BIOS 1.2.M1.AL.E.132.01 08/23/2022
[  485.528441] Call trace:
[  485.528441]  dump_backtrace+0xe8/0x12c
[  485.528443]  show_stack+0x20/0x50
[  485.528444]  dump_stack_lvl+0x68/0x84
[  485.528446]  dump_stack+0x18/0x34
[  485.528448]  ghes_proc_in_irq+0x220/0x250
[  485.528450]  irq_work_single+0x30/0x80
[  485.528453]  irq_work_run_list+0x4c/0x70
[  485.528455]  irq_work_run+0x28/0x44
[  485.528457]  do_handle_IPI+0x2b4/0x2f0
[  485.528459]  ipi_handler+0x24/0x34
[  485.528461]  handle_percpu_devid_irq+0x90/0x1c4
[  485.528463]  generic_handle_domain_irq+0x34/0x50
[  485.528465]  __gic_handle_irq_from_irqson.isra.0+0x130/0x230
[  485.528468]  gic_handle_irq+0x2c/0x60
[  485.528469]  call_on_irq_stack+0x2c/0x38
[  485.528471]  do_interrupt_handler+0x88/0x90
[  485.528472]  el1_interrupt+0x48/0xb0
[  485.528475]  el1h_64_irq_handler+0x18/0x24
[  485.528476]  el1h_64_irq+0x74/0x78
[  485.528477]  __do_softirq+0xa4/0x358
[  485.528478]  __irq_exit_rcu+0x110/0x13c
[  485.528479]  irq_exit_rcu+0x18/0x24
[  485.528480]  el1_interrupt+0x4c/0xb0
[  485.528482]  el1h_64_irq_handler+0x18/0x24
[  485.528483]  el1h_64_irq+0x74/0x78
[  485.528484]  arch_cpu_idle+0x18/0x40
[  485.528485]  default_idle_call+0x50/0x114
[  485.528487]  cpuidle_idle_call+0x16c/0x1c0
[  485.528488]  do_idle+0xb8/0x110
[  485.528489]  cpu_startup_entry+0x2c/0x34
[  485.528491]  secondary_start_kernel+0xf0/0x144
[  485.528493]  __secondary_switched+0xb0/0xb4

[  485.528511] CPU: 3 PID: 12696 Comm: kworker/3:0 Tainted: G            E      6.0.0-rc5+ #33
[  485.528513] Hardware name: AlibabaCloud AliServer-Xuanwu2.0AM-02-2UC1P-5B/M, BIOS 1.2.M1.AL.E.132.01 08/23/2022
[  485.528514] Workqueue: events memory_failure_work_func
[  485.528518] Call trace:
[  485.528519]  dump_backtrace+0xe8/0x12c
[  485.528520]  show_stack+0x20/0x50
[  485.528521]  dump_stack_lvl+0x68/0x84
[  485.528523]  dump_stack+0x18/0x34
[  485.528525]  memory_failure_work_func+0xec/0x180
[  485.528527]  process_one_work+0x1f4/0x460
[  485.528528]  worker_thread+0x188/0x3e4
[  485.528530]  kthread+0xd0/0xd4
[  485.528532]  ret_from_fork+0x10/0x20

[  485.528533] CPU: 3 PID: 12696 Comm: kworker/3:0 Tainted: G            E      6.0.0-rc5+ #33
[  485.528534] Hardware name: AlibabaCloud AliServer-Xuanwu2.0AM-02-2UC1P-5B/M, BIOS 1.2.M1.AL.E.132.01 08/23/2022
[  485.528535] Workqueue: events memory_failure_work_func
[  485.528537] Call trace:
[  485.528538]  dump_backtrace+0xe8/0x12c
[  485.528539]  show_stack+0x20/0x50
[  485.528540]  dump_stack_lvl+0x68/0x84
[  485.528541]  dump_stack+0x18/0x34
[  485.528543]  memory_failure+0x50/0x438
[  485.528544]  memory_failure_work_func+0x174/0x180
[  485.528546]  process_one_work+0x1f4/0x460
[  485.528547]  worker_thread+0x188/0x3e4
[  485.528548]  kthread+0xd0/0xd4
[  485.528550]  ret_from_fork+0x10/0x20
[  485.530622] Memory failure: 0x89c033: recovery action for dirty LRU page: Recovered





