Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CCA61650C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 15:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiKBOYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 10:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiKBOYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 10:24:38 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5016C2A709;
        Wed,  2 Nov 2022 07:24:34 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oqEfI-0005c0-M5; Wed, 02 Nov 2022 15:24:24 +0100
Message-ID: <84f79a09-7cdb-d6cc-ef28-df5ac6b048e7@leemhuis.info>
Date:   Wed, 2 Nov 2022 15:24:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: qemu-i386: perf: BUG: kernel NULL pointer dereference, address:
 00000148
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-perf-users@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        regressions@lists.linux.dev, lkft-triage@lists.linaro.org,
        Marco Elver <elver@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
References: <CA+G9fYsGFoC5TciCuijZXLx48TZnoTSkq=iUgb+vFdi9EYTucw@mail.gmail.com>
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CA+G9fYsGFoC5TciCuijZXLx48TZnoTSkq=iUgb+vFdi9EYTucw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1667399074;aa1f6198;
X-HE-SMSGID: 1oqEfI-0005c0-M5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[just writing this to CC the stable list and Greg, to make sure they are
in the loop before 6.0.7 is released]

[/me wonders why that wasn't done and hopes there isn't a good reason
why it wasn't done]

On 02.11.22 14:12, Naresh Kamboju wrote:
> Following kernel BUG: noticed on qemu-i386 while running perf test suite
> on stable-rc 6.0.7-rc1 the image was built with gcc-11.
> 
> The System did not recover after the crash.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> syscalls:sys_enter_openat event fields: Ok
>  17: Setup struct perf_event_attr                                    :
> --- start ---
> test child forked, pid 433
> Using CPUID AuthenticAMD-23-1-2
> /usr/libexec/perf-core/tests/attr.py:142: DeprecationWarning: The
> SafeConfigParser class has been renamed to ConfigParser in Python 3.2.
> This alias will be removed in Python 3.12. Use ConfigParser directly
> instead.
>   parser = configparser.SafeConfigParser()
> running '/usr/libexec/perf-core/tests/attr/test-record-no-samples'
> /usr/libexec/perf-core/tests/attr.py:201: DeprecationWarning: The
> SafeConfigParser class has been renamed to ConfigParser in Python 3.2.
> This alias will be removed in Python 3.12. Use ConfigParser directly
> instead.
>   parser_event = configparser.SafeConfigParser()
> /usr/libexec/perf-core/tests/attr.py:215: DeprecationWarning: The
> SafeConfigParser class has been renamed to ConfigParser in Python 3.2.
> This alias will be removed in Python 3.12. Use ConfigParser directly
> instead.
>   parser_base = configparser.SafeConfigParser()
> running '/usr/libexec/perf-core/tests/attr/test-record-graph-fp-aarch64'
> test limitation 'aarch64'
> skipped [i686] '/usr/libexec/perf-core/tests/attr/test-record-graph-fp-aarch64'
> running '/usr/libexec/perf-core/tests/attr/test-record-branch-filter-any_ret'
> unsupp  '/usr/libexec/perf-core/tests/attr/test-record-branch-filter-any_ret'
> running '/usr/libexec/perf-core/tests/attr/test-record-branch-filter-ind_call'
> unsupp  '/usr/libexec/perf-core/tests/attr/test-record-branch-filter-ind_call'
> running '/usr/libexec/perf-core/tests/attr/test-record-spe-physical-address'
> test limitation 'aarch64'
> skipped [i686] '/usr/libexec/perf-core/tests/attr/test-record-spe-physical-address'
> running '/usr/libexec/perf-core/tests/attr/test-record-C0'
> [  115.046512] perf: interrupt took too long (11109 > 11096), lowering
> kernel.perf_event_max_sample_rate to 18000
> running '/usr/libexec/perf-core/tests/attr/test-record-group'
> [  116.006600] BUG: kernel NULL pointer dereference, address: 00000148
> [  116.008309] #PF: supervisor read access in kernel mode
> [  116.009527] #PF: error_code(0x0000) - not-present page
> [  116.010809] *pde = 00000000
> [  116.011454] Oops: 0000 [#1] PREEMPT SMP
> [  116.012144] CPU: 2 PID: 449 Comm: perf-exec Not tainted 6.0.7-rc1 #1
> [  116.013256] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [  116.014710] EIP: x86_pmu_enable_event+0x4a/0x190
> [  116.015617] Code: 64 a1 10 2c 8d c6 85 c0 75 16 8b 5d f4 8b 75 f8
> 8b 7d fc 89 ec 5d c3 8d b4 26 00 00 00 00 66 90 b8 43 bb 49 c6 e8 56
> 13 fb 00 <8b> b3 48 01 00 00 b8 dc 39 8d c6 64 03 05 b0 28 8d c6 8b 38
> 85 f6
> [  116.018642] EAX: 00000002 EBX: 00000000 ECX: c0010200 EDX: c649bb43
> [  116.019709] ESI: f51c6b00 EDI: f51c6c00 EBP: c34e1da4 ESP: c34e1d88
> [  116.020744] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210002
> [  116.021847] CR0: 80050033 CR2: 00000148 CR3: 03e07000 CR4: 003506d0
> [  116.022930] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  116.023674] DR6: ffff4ff0 DR7: 00000400
> [  116.024078] Call Trace:
> [  116.024348]  amd_pmu_enable_all+0x3d/0x50
> [  116.024776]  x86_pmu_enable+0x17c/0x370
> [  116.025179]  ctx_resched+0xad/0xf0
> [  116.025542]  perf_event_exec+0x338/0x400
> [  116.025956]  begin_new_exec+0x548/0xac0
> [  116.026358]  load_elf_binary+0x2ad/0x1360
> [  116.027063]  ? __kernel_read+0x12c/0x220
> [  116.027520]  ? _raw_read_unlock+0x1d/0x40
> [  116.027957]  ? load_misc_binary+0x1eb/0x290
> [  116.028404]  ? trace_preempt_on+0x29/0xe0
> [  116.028827]  ? load_misc_binary+0x1eb/0x290
> [  116.029287]  ? preempt_count_sub+0xc1/0x110
> [  116.029722]  ? bprm_execve+0x256/0x650
> [  116.030122]  ? preempt_count_sub+0xc1/0x110
> [  116.030600]  bprm_execve+0x260/0x650
> [  116.031006]  do_execveat_common+0x13f/0x1b0
> [  116.031482]  __ia32_sys_execve+0x35/0x40
> [  116.031897]  __do_fast_syscall_32+0x4c/0xc0
> [  116.032358]  do_fast_syscall_32+0x32/0x70
> [  116.032777]  do_SYSENTER_32+0x15/0x20
> [  116.033190]  entry_SYSENTER_32+0x98/0xf1
> [  116.033601] EIP: 0xb7eda549
> [  116.033903] Code: Unable to access opcode bytes at RIP 0xb7eda51f.
> [  116.034576] EAX: ffffffda EBX: bfa6d940 ECX: bfa730f8 EDX: 08ea9dc0
> [  116.035278] ESI: bfa73d61 EDI: bfa6d949 EBP: bfa6da38 ESP: bfa6d918
> [  116.035927] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 007b EFLAGS: 00200296
> [  116.036624] Modules linked in:
> [  116.036961] CR2: 0000000000000148
> [  116.037315] ---[ end trace 0000000000000000 ]---
> [  116.037753] EIP: x86_pmu_enable_event+0x4a/0x190
> [  116.038190] Code: 64 a1 10 2c 8d c6 85 c0 75 16 8b 5d f4 8b 75 f8
> 8b 7d fc 89 ec 5d c3 8d b4 26 00 00 00 00 66 90 b8 43 bb 49 c6 e8 56
> 13 fb 00 <8b> b3 48 01 00 00 b8 dc 39 8d c6 64 03 05 b0 28 8d c6 8b 38
> 85 f6
> [  116.039918] EAX: 00000002 EBX: 00000000 ECX: c0010200 EDX: c649bb43
> [  116.040509] ESI: f51c6b00 EDI: f51c6c00 EBP: c34e1da4 ESP: c34e1d88
> [  116.041092] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00210002
> [  116.041720] CR0: 80050033 CR2: b7eda51f CR3: 03e07000 CR4: 003506d0
> [  116.042301] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  116.042895] DR6: ffff4ff0 DR7: 00000400
> [  116.043254] note: perf-exec[449] exited with preempt_count 2
> [  136.996781] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  136.998413] rcu: 2-...0: (1 ticks this GP) idle=ed7c/1/0x40000000
> softirq=4094/4094 fqs=4847
> [  137.000598] (detected by 1, t=21002 jiffies, g=7361, q=198 ncpus=4)
> [  137.002418] Sending NMI from CPU 1 to CPUs 2:
> [  137.003676] NMI backtrace for cpu 2
> [  137.003689] CPU: 2 PID: 449 Comm: perf-exec Tainted: G      D
>      6.0.7-rc1 #1
> [  137.003694] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [  137.003697] EIP: queued_spin_lock_slowpath+0x3a/0x2d0
> [  137.003710] Code: 3e 8d 74 26 00 ba 01 00 00 00 8d b6 00 00 00 00
> 8b 03 85 c0 75 12 f0 0f b1 13 85 c0 75 f2 58 5b 5e 5f 5d c3 8d 74 26
> 00 f3 90 <eb> e4 8d 74 26 00 81 fa 00 01 00 00 74 50 81 e2 00 ff ff ff
> 85 d2
> [  137.003712] EAX: 00000001 EBX: c331e0c4 ECX: 00000000 EDX: 00000001
> [  137.003714] ESI: 00000002 EDI: c331e0c0 EBP: c34e1d94 ESP: c34e1d84
> [  137.003716] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00200002
> [  137.003720] CR0: 80050033 CR2: b7eda51f CR3: 03e07000 CR4: 003506d0
> [  137.003723] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  137.003724] DR6: ffff4ff0 DR7: 00000400
> [  137.003725] Call Trace:
> [  137.003731]  _raw_spin_lock+0x31/0x40
> [  137.003737]  perf_event_task_tick+0x97/0x370
> [  137.003743]  ? task_tick_fair+0x77/0x2f0
> [  137.003747]  ? __wake_up+0x21/0x30
> [  137.003751]  ? update_rq_clock+0x39/0x200
> [  137.003754]  ? task_fork_fair+0x180/0x180
> [  137.003756]  scheduler_tick+0xbe/0x2b0
> [  137.003760]  ? task_fork_fair+0x180/0x180
> [  137.003761]  update_process_times+0x85/0x90
> [  137.003766]  tick_sched_handle+0x3d/0x60
> [  137.003769]  tick_sched_timer+0x92/0xb0
> [  137.003771]  __hrtimer_run_queues+0xb2/0x300
> [  137.003774]  ? tick_sched_do_timer+0xa0/0xa0
> [  137.003776]  hrtimer_interrupt+0x129/0x270
> [  137.003778]  ? _prb_read_valid+0x84/0x3c0
> [  137.003783]  ? sysvec_call_function_single+0x50/0x50
> [  137.003785]  __sysvec_apic_timer_interrupt+0x76/0x160
> [  137.003791]  ? debug_smp_processor_id+0x12/0x20
> [  137.003793]  sysvec_apic_timer_interrupt+0x31/0x50
> [  137.003794]  handle_exception+0x133/0x133
> [  137.003796] EIP: _raw_spin_unlock_irq+0x16/0x40
> [  137.003799] Code: c0 74 09 5d c3 8d b4 26 00 00 00 00 e8 73 25 00
> 00 5d c3 90 3e 8d 74 26 00 55 89 e5 c6 00 00 e8 c0 cb 25 ff fb b8 01
> 00 00 00 <e8> 45 b1 17 ff 64 a1 0c 77 8d c6 85 c0 74 0b 5d c3 8d b4 26
> 00 00
> [  137.003801] EAX: 00000001 EBX: c26f24c0 ECX: c5111bf4 EDX: 00000001
> [  137.003802] ESI: c26f24c0 EDI: 00000000 EBP: c34e1f4c ESP: c34e1f4c
> [  137.003803] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00200246
> [  137.003805]  ? do_exit+0x54/0x9c0
> [  137.003809]  ? sysvec_call_function_single+0x50/0x50
> [  137.003811]  ? sysvec_call_function_single+0x50/0x50
> [  137.003812]  ? _raw_spin_unlock_irq+0x16/0x40
> [  137.003814]  do_exit+0x54/0x9c0
> [  137.003816]  ? vprintk+0x55/0x60
> [  137.003818]  make_task_dead+0x56/0x60
> [  137.003820]  rewind_stack_and_make_dead+0x11/0x20
> [  137.003824] EIP: 0xb7eda549
> [  137.003837] Code: Unable to access opcode bytes at RIP 0xb7eda51f.
> [  137.003838] EAX: ffffffda EBX: bfa6d940 ECX: bfa730f8 EDX: 08ea9dc0
> [  137.003839] ESI: bfa73d61 EDI: bfa6d949 EBP: bfa6da38 ESP: bfa6d918
> [  137.003840] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 007b EFLAGS: 00200296
> [  200.005419] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  200.010134] rcu: 2-...0: (1 ticks this GP) idle=ed7c/1/0x40000000
> softirq=4094/4094 fqs=19175
> [  200.011177] (detected by 1, t=84017 jiffies, g=7361, q=436 ncpus=4)
> [  200.011949] Sending NMI from CPU 1 to CPUs 2:
> [  200.012561] NMI backtrace for cpu 2
> [  200.012569] CPU: 2 PID: 449 Comm: perf-exec Tainted: G      D
>      6.0.7-rc1 #1
> [  200.012572] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [  200.012574] EIP: queued_spin_lock_slowpath+0x3a/0x2d0
> [  200.012583] Code: 3e 8d 74 26 00 ba 01 00 00 00 8d b6 00 00 00 00
> 8b 03 85 c0 75 12 f0 0f b1 13 85 c0 75 f2 58 5b 5e 5f 5d c3 8d 74 26
> 00 f3 90 <eb> e4 8d 74 26 00 81 fa 00 01 00 00 74 50 81 e2 00 ff ff ff
> 85 d2
> [  200.012585] EAX: 00000001 EBX: c331e0c4 ECX: 00000000 EDX: 00000001
> [  200.012587] ESI: 00000002 EDI: c331e0c0 EBP: c34e1d94 ESP: c34e1d84
> [  200.012588] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00200002
> [  200.012592] CR0: 80050033 CR2: b7eda51f CR3: 03e07000 CR4: 003506d0
> [  200.012595] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  200.012596] DR6: ffff4ff0 DR7: 00000400
> [  200.012597] Call Trace:
> [  200.012601]  _raw_spin_lock+0x31/0x40
> [  200.012606]  perf_event_task_tick+0x97/0x370
> [  200.012610]  ? task_tick_fair+0x77/0x2f0
> [  200.012613]  ? __wake_up+0x21/0x30
> [  200.012616]  ? update_rq_clock+0x39/0x200
> [  200.012618]  ? task_fork_fair+0x180/0x180
> [  200.012620]  scheduler_tick+0xbe/0x2b0
> [  200.012622]  ? task_fork_fair+0x180/0x180
> [  200.012624]  update_process_times+0x85/0x90
> [  200.012627]  tick_sched_handle+0x3d/0x60
> [  200.012629]  tick_sched_timer+0x92/0xb0
> [  200.012631]  __hrtimer_run_queues+0xb2/0x300
> [  200.012633]  ? tick_sched_do_timer+0xa0/0xa0
> [  200.012635]  hrtimer_interrupt+0x129/0x270
> [  200.012638]  ? _prb_read_valid+0x84/0x3c0
> [  200.012641]  ? sysvec_call_function_single+0x50/0x50
> [  200.012643]  __sysvec_apic_timer_interrupt+0x76/0x160
> [  200.012647]  ? debug_smp_processor_id+0x12/0x20
> [  200.012648]  sysvec_apic_timer_interrupt+0x31/0x50
> [  200.012650]  handle_exception+0x133/0x133
> 
> 
> metadata:
>   git_ref: linux-6.0.y
>   git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git_sha: 436175d0f780af8302164b3102ecf0ff99f7a376
>   git_describe: v6.0.6-241-g436175d0f780
>   kernel_version: 6.0.7-rc1
>   kernel-config: https://builds.tuxbuild.com/2GyMhllOBAqVhs03YoIHIAE7E8c/config
>   build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/683032123
>   artifact-location: https://builds.tuxbuild.com/2GyMhllOBAqVhs03YoIHIAE7E8c
>   toolchain: gcc-11
> 
> Test full log link,
> https://lkft.validation.linaro.org/scheduler/job/5799947#L16491
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 
> 
