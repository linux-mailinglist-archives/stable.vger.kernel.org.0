Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B9936659F
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 08:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbhDUGtL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 21 Apr 2021 02:49:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:61778 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235123AbhDUGtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 02:49:11 -0400
IronPort-SDR: XCDEKuGRiwIkIo7MEcCTeN/iomFOjHZ3GZ0a/U+5MYJ/+MamOUSlLc0ZiPryT0ralvRT122Aqf
 yACrEStnBYIw==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="195204976"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="195204976"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 23:48:38 -0700
IronPort-SDR: cimVGhVKwnnFzH4EtXWPJCGS+ATShQiSdqByld0g2tV/J9UsXzOlPqrCAupKTWtIZY8oWqLPm4
 TspNjMcswhxg==
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="524200083"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 23:48:34 -0700
Date:   Wed, 21 Apr 2021 15:05:58 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Borislav Petkov <bp@suse.de>
Cc:     stable <stable@vger.kernel.org>,
        aliyunlinux2-dev@linux.alibaba.com, jane.lv@intel.com,
        lkp@lists.01.org, lkp@intel.com
Subject: Re: [x86/microcode, cpuhotplug]  ecec31ce4f:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c
Message-ID: <20210421070558.GB13430@xsang-OptiPlex-9020>
References: <20210322023050.GA32426@xsang-OptiPlex-9020>
 <20210322084452.GA10031@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210322084452.GA10031@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hi, Borislav Petkov,

On Mon, Mar 22, 2021 at 09:44:52AM +0100, Borislav Petkov wrote:
> On Mon, Mar 22, 2021 at 10:31:02AM +0800, kernel test robot wrote:
> > 
> > 
> > Greeting,
> > 
> > FYI, we noticed the following commit (built with gcc-9):
> > 
> > commit: ecec31ce4f33c927997f179f5d8f1bc4efdd68b5 ("x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback")
> > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> 
> Is this again one of those internal reports which wrongfully escaped to
> the outside?
> 
> Below it says "4.19.52-00069-gecec31ce4f33c" which is some random
> stable testing tree and 4.19 stable has in the meantime already reached
> v4.19.182.

sorry for late. and sorry for a false positive, we checked the auto-bisect
log again, confirmed this issue actually doesn't exist on linux-4.19.y tip.

as you mentioned the 4.19 already reaches 4.19.182. our auto-bisect does
check on branch tip to confirm the issue still exist before it determines
it's a valid report, but regarding this case, auto-bisect was confused by
some other dmesg stats which made it thought the issue still exist.

BTW, the "4.19.52-00069-gecec31ce4f33c" does not mean it's a random tree,
it's just because ecec31ce4f is between 4.19.52 and 4.19.53

9f31eb60d7a2 (tag: v4.19.53) Linux 4.19.53
90fc261d509e rtc: pcf8523: don't return invalid date when battery is low
04757d0e3789 drm: add fallback override/firmware EDID modes workaround
29a6026624cd drm/edid: abstract override/firmware EDID retrieval
e93ce57f60ca x86/resctrl: Prevent NULL pointer dereference when local MBM is disabled
0257fc9aa53f x86/mm/KASLR: Compute the size of the vmemmap section properly
5e3d10d9375d x86/kasan: Fix boot with 5-level paging and KASAN
ecec31ce4f33 x86/microcode, cpuhotplug: Add a microcode loader CPU hotplug callback
...


> 
> So what's up?
> 
> Leaving in the rest for the stable@ folks newly added to Cc.
> 
> > in testcase: kernel-selftests
> > version: kernel-selftests-x86_64-b553cffa-1_20210122
> > with following parameters:
> > 
> > 	group: net
> > 	ucode: 0x28
> > 
> > test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
> > test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
> > 
> > 
> > on test machine: 8 threads Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz with 16G memory
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > 
> > +-----------------------------------------------------------------------------+------------+------------+
> > |                                                                             | fa982c692b | ecec31ce4f |
> > +-----------------------------------------------------------------------------+------------+------------+
> > | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c | 0          | 6          |
> > | BUG:sleeping_function_called_from_invalid_context_at_mm/slab.h              | 0          | 6          |
> > +-----------------------------------------------------------------------------+------------+------------+
> > 
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > 
> > 
> > [  155.883993] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:908
> > [  155.892413] in_atomic(): 1, irqs_disabled(): 1, pid: 17, name: migration/1
> > [  155.899272] no locks held by migration/1/17.
> > [  155.903533] irq event stamp: 4492
> > [  155.906842] hardirqs last enabled at (4491): _raw_spin_unlock_irq (kbuild/src/consumer/arch/x86/include/asm/paravirt.h:798 kbuild/src/consumer/include/linux/spinlock_api_smp.h:168 kbuild/src/consumer/kernel/locking/spinlock.c:192) 
> > [  155.915695] hardirqs last disabled at (4492): multi_cpu_stop (kbuild/src/consumer/kernel/stop_machine.c:211) 
> > [  155.924116] softirqs last enabled at (3416): __do_softirq (kbuild/src/consumer/arch/x86/include/asm/preempt.h:23 kbuild/src/consumer/kernel/softirq.c:319) 
> > [  155.932449] softirqs last disabled at (3395): irq_exit (kbuild/src/consumer/kernel/softirq.c:372 kbuild/src/consumer/kernel/softirq.c:412) 
> > [  155.940346] Preemption disabled at:
> > [  155.940348] cpu_stopper_thread (kbuild/src/consumer/kernel/stop_machine.c:508) 
> > [  155.949646] CPU: 1 PID: 17 Comm: migration/1 Not tainted 4.19.52-00069-gecec31ce4f33c #1
> > [  155.957716] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
> > [  155.964918] Call Trace:
> > [  155.967362] dump_stack (kbuild/src/consumer/lib/dump_stack.c:115) 
> > [  155.970672] ___might_sleep.cold (kbuild/src/consumer/kernel/sched/core.c:6151) 
> > [  155.974845] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  155.979365] ? __mutex_lock (kbuild/src/consumer/kernel/locking/mutex.c:924 kbuild/src/consumer/kernel/locking/mutex.c:1072) 
> > [  155.983106] ? mark_lock (kbuild/src/consumer/kernel/locking/lockdep.c:3116) 
> > [  155.986583] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  155.991104] ? __rdmsr_on_cpu (kbuild/src/consumer/arch/x86/lib/msr-smp.c:23) 
> > [  155.994931] ? __rdmsr_on_cpu (kbuild/src/consumer/arch/x86/lib/msr-smp.c:23) 
> > [  155.998758] ? generic_exec_single (kbuild/src/consumer/kernel/smp.c:155 (discriminator 1)) 
> > [  156.003104] ? smp_call_function_single (kbuild/src/consumer/arch/x86/include/asm/preempt.h:99 kbuild/src/consumer/kernel/smp.c:304) 
> > [  156.007885] ? microcode_write (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:807) 
> > [  156.011797] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  156.016314] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  156.020834] ? sysfs_remove_group (kbuild/src/consumer/include/linux/kernfs.h:493 kbuild/src/consumer/fs/sysfs/group.c:251) 
> > [  156.025007] ? mc_cpu_down_prep (kbuild/src/consumer/arch/x86/include/asm/jump_label.h:23 kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:813) 
> > [  156.029004] ? cpuhp_invoke_callback (kbuild/src/consumer/kernel/cpu.c:168) 
> > [  156.033526] ? take_cpu_down (kbuild/src/consumer/kernel/cpu.c:829) 
> > [  156.037267] ? multi_cpu_stop (kbuild/src/consumer/kernel/stop_machine.c:214) 
> > [  156.041183] ? cpu_stop_park (kbuild/src/consumer/kernel/stop_machine.c:183) 
> > [  156.044923] ? cpu_stopper_thread (kbuild/src/consumer/kernel/stop_machine.c:509) 
> > [  156.049183] ? smpboot_thread_fn (kbuild/src/consumer/kernel/smpboot.c:112) 
> > [  156.053356] ? smpboot_thread_fn (kbuild/src/consumer/kernel/smpboot.c:164 (discriminator 3)) 
> > [  156.057616] ? sort_range (kbuild/src/consumer/kernel/smpboot.c:107) 
> > [  156.061098] ? kthread (kbuild/src/consumer/kernel/kthread.c:246) 
> > [  156.064492] ? kthread_create_worker_on_cpu (kbuild/src/consumer/kernel/kthread.c:206) 
> > [  156.069533] ? ret_from_fork (kbuild/src/consumer/arch/x86/entry/entry_64.S:421) 
> > [  156.073881] smpboot: CPU 1 is now offline
> > [  156.098653] smpboot: CPU 2 is now offline
> > [  156.125932] smpboot: CPU 3 is now offline
> > [  156.143575] smpboot: CPU 4 is now offline
> > [  156.159286] smpboot: CPU 5 is now offline
> > [  156.172359] smpboot: CPU 6 is now offline
> > [  156.184615] smpboot: CPU 7 is now offline
> > [  156.196783] x86: Booting SMP configuration:
> > [  156.201072] smpboot: Booting Node 0 Processor 1 APIC 0x2
> > [  156.206902] masked ExtINT on CPU#1
> > [  156.211120] microcode: sig=0x306c3, pf=0x2, revision=0x28
> > [  156.230475] smpboot: Booting Node 0 Processor 2 APIC 0x4
> > [  156.236111] masked ExtINT on CPU#2
> > [  156.251474] smpboot: Booting Node 0 Processor 3 APIC 0x6
> > [  156.257110] masked ExtINT on CPU#3
> > [  156.273477] smpboot: Booting Node 0 Processor 4 APIC 0x1
> > [  156.279108] masked ExtINT on CPU#4
> > [  156.296476] smpboot: Booting Node 0 Processor 5 APIC 0x3
> > [  156.302101] masked ExtINT on CPU#5
> > [  156.329483] smpboot: Booting Node 0 Processor 6 APIC 0x5
> > [  156.335109] masked ExtINT on CPU#6
> > [  156.362471] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [  156.368105] masked ExtINT on CPU#7
> > [  156.404909] smpboot: CPU 1 is now offline
> > [  156.428932] smpboot: CPU 2 is now offline
> > [  156.451939] smpboot: CPU 3 is now offline
> > [  156.464575] smpboot: CPU 4 is now offline
> > [  156.479038] smpboot: CPU 5 is now offline
> > [  156.492182] smpboot: CPU 6 is now offline
> > [  156.502630] smpboot: CPU 7 is now offline
> > [  156.513965] x86: Booting SMP configuration:
> > [  156.518206] smpboot: Booting Node 0 Processor 1 APIC 0x2
> > [  156.524043] masked ExtINT on CPU#1
> > [  156.539484] smpboot: Booting Node 0 Processor 2 APIC 0x4
> > [  156.545111] masked ExtINT on CPU#2
> > [  156.560475] smpboot: Booting Node 0 Processor 3 APIC 0x6
> > [  156.566109] masked ExtINT on CPU#3
> > [  156.582477] smpboot: Booting Node 0 Processor 4 APIC 0x1
> > [  156.588109] masked ExtINT on CPU#4
> > [  156.605476] smpboot: Booting Node 0 Processor 5 APIC 0x3
> > [  156.611106] masked ExtINT on CPU#5
> > [  156.635474] smpboot: Booting Node 0 Processor 6 APIC 0x5
> > [  156.641107] masked ExtINT on CPU#6
> > [  156.660478] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [  156.666154] masked ExtINT on CPU#7
> > [  156.706926] smpboot: CPU 1 is now offline
> > [  156.731933] smpboot: CPU 2 is now offline
> > [  156.757925] smpboot: CPU 3 is now offline
> > [  156.774786] smpboot: CPU 4 is now offline
> > [  156.791142] smpboot: CPU 5 is now offline
> > [  156.802112] smpboot: CPU 6 is now offline
> > [  156.813336] smpboot: CPU 7 is now offline
> > [  156.824551] x86: Booting SMP configuration:
> > [  156.828792] smpboot: Booting Node 0 Processor 1 APIC 0x2
> > [  156.834634] masked ExtINT on CPU#1
> > [  156.850483] smpboot: Booting Node 0 Processor 2 APIC 0x4
> > [  156.856104] masked ExtINT on CPU#2
> > [  156.872470] smpboot: Booting Node 0 Processor 3 APIC 0x6
> > [  156.878097] masked ExtINT on CPU#3
> > [  156.882357] BUG: sleeping function called from invalid context at mm/slab.h:422
> > [  156.889651] in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/3
> > [  156.896247] no locks held by swapper/3/0.
> > [  156.900244] irq event stamp: 2135958
> > [  156.903812] hardirqs last enabled at (2135957): switch_mm (kbuild/src/consumer/arch/x86/include/asm/paravirt.h:788 (discriminator 2) kbuild/src/consumer/arch/x86/mm/tlb.c:158 (discriminator 2)) 
> > [  156.911969] hardirqs last disabled at (2135958): native_play_dead (kbuild/src/consumer/arch/x86/kernel/smpboot.c:1675) 
> > [  156.920731] softirqs last enabled at (2135914): __do_softirq (kbuild/src/consumer/arch/x86/include/asm/preempt.h:23 kbuild/src/consumer/kernel/softirq.c:319) 
> > [  156.929321] softirqs last disabled at (2135895): irq_exit (kbuild/src/consumer/kernel/softirq.c:372 kbuild/src/consumer/kernel/softirq.c:412) 
> > [  156.937477] Preemption disabled at:
> > [  156.937479] start_secondary (kbuild/src/consumer/arch/x86/kernel/smpboot.c:160 kbuild/src/consumer/arch/x86/kernel/smpboot.c:236) 
> > [  156.946512] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W         4.19.52-00069-gecec31ce4f33c #1
> > [  156.955707] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
> > [  156.962906] Call Trace:
> > [  156.965348] dump_stack (kbuild/src/consumer/lib/dump_stack.c:115) 
> > [  156.968655] ___might_sleep.cold (kbuild/src/consumer/kernel/sched/core.c:6151) 
> > [  156.972828] ? __kernfs_new_node (kbuild/src/consumer/include/linux/slab.h:699 kbuild/src/consumer/fs/kernfs/dir.c:634) 
> > [  156.976998] ? microcode_init_cpu (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:794) 
> > [  156.981170] ? kmem_cache_alloc (kbuild/src/consumer/mm/slab.h:424 kbuild/src/consumer/mm/slub.c:2632 kbuild/src/consumer/mm/slub.c:2714 kbuild/src/consumer/mm/slub.c:2719) 
> > [  156.985339] ? microcode_init_cpu (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:794) 
> > [  156.989510] ? __kernfs_new_node (kbuild/src/consumer/include/linux/slab.h:699 kbuild/src/consumer/fs/kernfs/dir.c:634) 
> > [  156.993681] ? apply_microcode_intel (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/intel.c:807) 
> > [  156.998196] ? __load_ucode_intel (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/intel.c:794) 
> > [  157.002365] ? microcode_init_cpu (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:794) 
> > [  157.006536] ? collect_cpu_info_local (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:385) 
> > [  157.011054] ? microcode_init_cpu (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:794) 
> > [  157.015222] ? kernfs_new_node (kbuild/src/consumer/fs/kernfs/dir.c:694) 
> > [  157.019132] ? kernfs_create_dir_ns (kbuild/src/consumer/fs/kernfs/dir.c:1022) 
> > [  157.023476] ? internal_create_group (kbuild/src/consumer/fs/sysfs/group.c:138) 
> > [  157.027995] ? microcode_init_cpu (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:794) 
> > [  157.032166] ? mc_cpu_online (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:801) 
> > [  157.035901] ? cpuhp_invoke_callback (kbuild/src/consumer/kernel/cpu.c:168) 
> > [  157.040419] ? cpumask_next (kbuild/src/consumer/lib/cpumask.c:22) 
> > [  157.044072] ? notify_cpu_starting (kbuild/src/consumer/kernel/cpu.c:1044) 
> > [  157.048328] ? start_secondary (kbuild/src/consumer/arch/x86/include/asm/bitops.h:76 kbuild/src/consumer/include/linux/cpumask.h:311 kbuild/src/consumer/arch/x86/kernel/smpboot.c:204 kbuild/src/consumer/arch/x86/kernel/smpboot.c:236) 
> > [  157.052326] ? secondary_startup_64 (kbuild/src/consumer/arch/x86/kernel/head_64.S:243) 
> > [  157.068476] smpboot: Booting Node 0 Processor 4 APIC 0x1
> > [  157.074109] masked ExtINT on CPU#4
> > [  157.093484] smpboot: Booting Node 0 Processor 5 APIC 0x3
> > [  157.099104] masked ExtINT on CPU#5
> > [  157.118481] smpboot: Booting Node 0 Processor 6 APIC 0x5
> > [  157.124110] masked ExtINT on CPU#6
> > [  157.151475] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [  157.157102] masked ExtINT on CPU#7
> > [  157.188931] smpboot: CPU 1 is now offline
> > [  157.212717] smpboot: CPU 2 is now offline
> > [  157.237640] smpboot: CPU 3 is now offline
> > [  157.261636] smpboot: CPU 4 is now offline
> > [  157.285137] smpboot: CPU 5 is now offline
> > [  157.297146] smpboot: CPU 6 is now offline
> > [  157.309600] smpboot: CPU 7 is now offline
> > [  157.320800] x86: Booting SMP configuration:
> > [  157.325049] smpboot: Booting Node 0 Processor 1 APIC 0x2
> > [  157.330872] masked ExtINT on CPU#1
> > [  157.346483] smpboot: Booting Node 0 Processor 2 APIC 0x4
> > [  157.352118] masked ExtINT on CPU#2
> > [  157.367475] smpboot: Booting Node 0 Processor 3 APIC 0x6
> > [  157.373107] masked ExtINT on CPU#3
> > [  157.389471] smpboot: Booting Node 0 Processor 4 APIC 0x1
> > [  157.395103] masked ExtINT on CPU#4
> > [  157.412475] smpboot: Booting Node 0 Processor 5 APIC 0x3
> > [  157.418098] masked ExtINT on CPU#5
> > [  157.442470] smpboot: Booting Node 0 Processor 6 APIC 0x5
> > [  157.448096] masked ExtINT on CPU#6
> > [  157.469485] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [  157.475094] masked ExtINT on CPU#7
> > [  157.506708] smpboot: CPU 1 is now offline
> > [  157.530927] smpboot: CPU 2 is now offline
> > [  157.554937] smpboot: CPU 3 is now offline
> > [  157.571754] smpboot: CPU 4 is now offline
> > [  157.584381] smpboot: CPU 5 is now offline
> > [  157.596203] smpboot: CPU 6 is now offline
> > [  157.608341] smpboot: CPU 7 is now offline
> > [  157.619551] x86: Booting SMP configuration:
> > [  157.623846] smpboot: Booting Node 0 Processor 1 APIC 0x2
> > [  157.629682] masked ExtINT on CPU#1
> > [  157.645483] smpboot: Booting Node 0 Processor 2 APIC 0x4
> > [  157.651113] masked ExtINT on CPU#2
> > [  157.670475] smpboot: Booting Node 0 Processor 3 APIC 0x6
> > [  157.676104] masked ExtINT on CPU#3
> > [  157.692476] smpboot: Booting Node 0 Processor 4 APIC 0x1
> > [  157.698148] masked ExtINT on CPU#4
> > [  157.717484] smpboot: Booting Node 0 Processor 5 APIC 0x3
> > [  157.723095] masked ExtINT on CPU#5
> > [  157.747476] smpboot: Booting Node 0 Processor 6 APIC 0x5
> > [  157.753100] masked ExtINT on CPU#6
> > [  157.773469] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [  157.779105] masked ExtINT on CPU#7
> > [  158.049110] kselftest: Running tests in cpu-hotplug
> > [  158.094080] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:908
> > [  158.102501] in_atomic(): 1, irqs_disabled(): 1, pid: 47, name: migration/7
> > [  158.109359] no locks held by migration/7/47.
> > [  158.113615] irq event stamp: 5238
> > [  158.116924] hardirqs last enabled at (5237): _raw_spin_unlock_irq (kbuild/src/consumer/arch/x86/include/asm/paravirt.h:798 kbuild/src/consumer/include/linux/spinlock_api_smp.h:168 kbuild/src/consumer/kernel/locking/spinlock.c:192) 
> > [  158.125774] hardirqs last disabled at (5238): multi_cpu_stop (kbuild/src/consumer/kernel/stop_machine.c:211) 
> > [  158.134192] softirqs last enabled at (5206): __do_softirq (kbuild/src/consumer/arch/x86/include/asm/preempt.h:23 kbuild/src/consumer/kernel/softirq.c:319) 
> > [  158.142527] softirqs last disabled at (5183): irq_exit (kbuild/src/consumer/kernel/softirq.c:372 kbuild/src/consumer/kernel/softirq.c:412) 
> > [  158.150423] Preemption disabled at:
> > [  158.150425] cpu_stopper_thread (kbuild/src/consumer/kernel/stop_machine.c:508) 
> > [  158.159721] CPU: 7 PID: 47 Comm: migration/7 Tainted: G        W         4.19.52-00069-gecec31ce4f33c #1
> > [  158.169181] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
> > [  158.176386] Call Trace:
> > [  158.178831] dump_stack (kbuild/src/consumer/lib/dump_stack.c:115) 
> > [  158.182139] ___might_sleep.cold (kbuild/src/consumer/kernel/sched/core.c:6151) 
> > [  158.186315] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  158.190836] ? __mutex_lock (kbuild/src/consumer/kernel/locking/mutex.c:924 kbuild/src/consumer/kernel/locking/mutex.c:1072) 
> > [  158.194578] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  158.199101] ? __rdmsr_on_cpu (kbuild/src/consumer/arch/x86/lib/msr-smp.c:23) 
> > [  158.202928] ? __rdmsr_on_cpu (kbuild/src/consumer/arch/x86/lib/msr-smp.c:23) 
> > [  158.206755] ? generic_exec_single (kbuild/src/consumer/kernel/smp.c:155 (discriminator 1)) 
> > [  158.211101] ? smp_call_function_single (kbuild/src/consumer/arch/x86/include/asm/preempt.h:99 kbuild/src/consumer/kernel/smp.c:304) 
> > [  158.215882] ? microcode_write (kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:807) 
> > [  158.219794] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  158.224311] ? kernfs_find_and_get_ns (kbuild/src/consumer/fs/kernfs/dir.c:910) 
> > [  158.228831] ? sysfs_remove_group (kbuild/src/consumer/include/linux/kernfs.h:493 kbuild/src/consumer/fs/sysfs/group.c:251) 
> > [  158.233003] ? mc_cpu_down_prep (kbuild/src/consumer/arch/x86/include/asm/jump_label.h:23 kbuild/src/consumer/arch/x86/kernel/cpu/microcode/core.c:813) 
> > [  158.237002] ? cpuhp_invoke_callback (kbuild/src/consumer/kernel/cpu.c:168) 
> > [  158.241527] ? take_cpu_down (kbuild/src/consumer/kernel/cpu.c:829) 
> > [  158.245267] ? multi_cpu_stop (kbuild/src/consumer/kernel/stop_machine.c:214) 
> > [  158.249180] ? cpu_stop_park (kbuild/src/consumer/kernel/stop_machine.c:183) 
> > [  158.252919] ? cpu_stopper_thread (kbuild/src/consumer/kernel/stop_machine.c:509) 
> > [  158.257178] ? smpboot_thread_fn (kbuild/src/consumer/kernel/smpboot.c:112) 
> > [  158.261350] ? smpboot_thread_fn (kbuild/src/consumer/kernel/smpboot.c:164 (discriminator 3)) 
> > [  158.265609] ? sort_range (kbuild/src/consumer/kernel/smpboot.c:107) 
> > [  158.269092] ? kthread (kbuild/src/consumer/kernel/kthread.c:246) 
> > [  158.272483] ? kthread_create_worker_on_cpu (kbuild/src/consumer/kernel/kthread.c:206) 
> > [  158.277524] ? ret_from_fork (kbuild/src/consumer/arch/x86/entry/entry_64.S:421) 
> > [  158.281315] smpboot: CPU 7 is now offline
> > [  158.307477] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [  158.313121] masked ExtINT on CPU#7
> > [  158.321257] kselftest: Running tests in efivarfs
> > [  158.327163] kselftest: Running tests in exec
> > [  158.331527] kselftest: Running tests in filesystems
> > [  158.336525] kselftest: Running tests in firmware
> > [  158.352073] test_firmware: interface ready
> > [  158.441138] test_firmware: loading ''
> > [  158.444904] test_firmware: load of '' failed: -22
> > [  158.449909] test_firmware: loading ''
> > [  158.453870] test_firmware: failed to async load firmware
> > [  158.459360] test_firmware: loading 'nope-test-firmware.bin'
> > [  158.465088] misc test_firmware: Direct firmware load for nope-test-firmware.bin failed with error -2
> > [  158.474240] Ignoring firmware sysfs fallback due to sysctl knob
> > [  158.480187] test_firmware: load of 'nope-test-firmware.bin' failed: -2
> > [  158.488588] test_firmware: loading 'test-firmware.bin'
> > [  158.493773] test_firmware: loaded: 9
> > [  158.499107] test_firmware: loading 'test-firmware.bin'
> > [  158.504302] test_firmware: loaded: 9
> > [  158.512082] test_firmware: reset
> > [  158.515488] test_firmware: batched sync firmware loading 'test-firmware.bin' 4 times
> > [  158.523556] test_firmware: #0: batched sync loaded 9
> > [  158.523702] test_firmware: #1: batched sync loaded 9
> > [  158.523751] test_firmware: #2: batched sync loaded 9
> > [  158.523842] test_firmware: #3: batched sync loaded 9
> > [  158.546929] test_firmware: #0: loaded 9
> > [  158.552573] test_firmware: #1: loaded 9
> > [  158.558143] test_firmware: #2: loaded 9
> > [  158.563821] test_firmware: #3: loaded 9
> > [  158.568042] test_firmware: reset
> > [  158.571381] test_firmware: batched sync firmware loading 'test-firmware.bin' 4 times
> > [  158.579220] test_firmware: #0: batched sync loaded 9
> > [  158.579277] test_firmware: #1: batched sync loaded 9
> > [  158.579383] test_firmware: #2: batched sync loaded 9
> > [  158.579399] test_firmware: #3: batched sync loaded 9
> > [  158.602421] test_firmware: #0: loaded 9
> > [  158.608063] test_firmware: #1: loaded 9
> > [  158.613685] test_firmware: #2: loaded 9
> > [  158.619295] test_firmware: #3: loaded 9
> > [  158.623546] test_firmware: reset
> > [  158.626837] test_firmware: batched sync firmware loading 'test-firmware.bin' 4 times
> > [  158.634701] test_firmware: #0: batched sync loaded 9
> > [  158.634789] test_firmware: #1: batched sync loaded 9
> > [  158.634847] test_firmware: #2: batched sync loaded 9
> > [  158.634904] test_firmware: #3: batched sync loaded 9
> > [  158.657969] test_firmware: #0: loaded 9
> > [  158.663582] test_firmware: #1: loaded 9
> > [  158.669203] test_firmware: #2: loaded 9
> > [  158.674877] test_firmware: #3: loaded 9
> > [  158.679038] test_firmware: reset
> > [  158.682370] test_firmware: batched sync firmware loading 'test-firmware.bin' 4 times
> > [  158.690238] test_firmware: #0: batched sync loaded 9
> > [  158.690312] test_firmware: #1: batched sync loaded 9
> > [  158.690387] test_firmware: #2: batched sync loaded 9
> > [  158.690477] test_firmware: #3: batched sync loaded 9
> > [  158.713541] test_firmware: #0: loaded 9
> > [  158.719154] test_firmware: #1: loaded 9
> > [  158.724716] test_firmware: #2: loaded 9
> > [  158.730329] test_firmware: #3: loaded 9
> > [  158.734559] test_firmware: reset
> > [  158.737851] test_firmware: batched sync firmware loading 'test-firmware.bin' 4 times
> > [  158.745669] test_firmware: #0: batched sync loaded 9
> > 
> > 
> > To reproduce:
> > 
> >         git clone https://github.com/intel/lkp-tests.git
> >         cd lkp-tests
> >         bin/lkp install                job.yaml  # job file is attached in this email
> >         bin/lkp split-job --compatible job.yaml
> >         bin/lkp run                    compatible-job.yaml
> > 
> > 
> > 
> > ---
> > 0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
> > https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation
> > 
> > Thanks,
> > Oliver Sang
> > 
> 
> > #
> > # Automatically generated file; DO NOT EDIT.
> > # Linux/x86_64 4.19.52 Kernel Configuration
> > #
> > 
> > #
> > # Compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> > #
> > CONFIG_CC_IS_GCC=y
> > CONFIG_GCC_VERSION=90300
> > CONFIG_CLANG_VERSION=0
> > CONFIG_CC_HAS_ASM_GOTO=y
> > CONFIG_IRQ_WORK=y
> > CONFIG_BUILDTIME_EXTABLE_SORT=y
> > CONFIG_THREAD_INFO_IN_TASK=y
> > 
> > #
> > # General setup
> > #
> > CONFIG_INIT_ENV_ARG_LIMIT=32
> > # CONFIG_COMPILE_TEST is not set
> > CONFIG_LOCALVERSION=""
> > CONFIG_LOCALVERSION_AUTO=y
> > CONFIG_BUILD_SALT=""
> > CONFIG_HAVE_KERNEL_GZIP=y
> > CONFIG_HAVE_KERNEL_BZIP2=y
> > CONFIG_HAVE_KERNEL_LZMA=y
> > CONFIG_HAVE_KERNEL_XZ=y
> > CONFIG_HAVE_KERNEL_LZO=y
> > CONFIG_HAVE_KERNEL_LZ4=y
> > CONFIG_KERNEL_GZIP=y
> > # CONFIG_KERNEL_BZIP2 is not set
> > # CONFIG_KERNEL_LZMA is not set
> > # CONFIG_KERNEL_XZ is not set
> > # CONFIG_KERNEL_LZO is not set
> > # CONFIG_KERNEL_LZ4 is not set
> > CONFIG_DEFAULT_HOSTNAME="(none)"
> > CONFIG_SWAP=y
> > CONFIG_SYSVIPC=y
> > CONFIG_SYSVIPC_SYSCTL=y
> > CONFIG_POSIX_MQUEUE=y
> > CONFIG_POSIX_MQUEUE_SYSCTL=y
> > CONFIG_CROSS_MEMORY_ATTACH=y
> > # CONFIG_USELIB is not set
> > CONFIG_AUDIT=y
> > CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> > CONFIG_AUDITSYSCALL=y
> > CONFIG_AUDIT_WATCH=y
> > CONFIG_AUDIT_TREE=y
> > 
> > #
> > # IRQ subsystem
> > #
> > CONFIG_GENERIC_IRQ_PROBE=y
> > CONFIG_GENERIC_IRQ_SHOW=y
> > CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
> > CONFIG_GENERIC_PENDING_IRQ=y
> > CONFIG_GENERIC_IRQ_MIGRATION=y
> > CONFIG_IRQ_DOMAIN=y
> > CONFIG_IRQ_SIM=y
> > CONFIG_IRQ_DOMAIN_HIERARCHY=y
> > CONFIG_GENERIC_MSI_IRQ=y
> > CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
> > CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
> > CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
> > CONFIG_IRQ_FORCED_THREADING=y
> > CONFIG_SPARSE_IRQ=y
> > # CONFIG_GENERIC_IRQ_DEBUGFS is not set
> > CONFIG_CLOCKSOURCE_WATCHDOG=y
> > CONFIG_ARCH_CLOCKSOURCE_DATA=y
> > CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
> > CONFIG_GENERIC_TIME_VSYSCALL=y
> > CONFIG_GENERIC_CLOCKEVENTS=y
> > CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> > CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> > CONFIG_GENERIC_CMOS_UPDATE=y
> > 
> > #
> > # Timers subsystem
> > #
> > CONFIG_TICK_ONESHOT=y
> > CONFIG_NO_HZ_COMMON=y
> > # CONFIG_HZ_PERIODIC is not set
> > # CONFIG_NO_HZ_IDLE is not set
> > CONFIG_NO_HZ_FULL=y
> > CONFIG_NO_HZ=y
> > CONFIG_HIGH_RES_TIMERS=y
> > # CONFIG_PREEMPT_NONE is not set
> > # CONFIG_PREEMPT_VOLUNTARY is not set
> > CONFIG_PREEMPT=y
> > CONFIG_PREEMPT_COUNT=y
> > 
> > #
> > # CPU/Task time and stats accounting
> > #
> > CONFIG_VIRT_CPU_ACCOUNTING=y
> > CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
> > CONFIG_IRQ_TIME_ACCOUNTING=y
> > CONFIG_HAVE_SCHED_AVG_IRQ=y
> > CONFIG_BSD_PROCESS_ACCT=y
> > CONFIG_BSD_PROCESS_ACCT_V3=y
> > CONFIG_TASKSTATS=y
> > CONFIG_TASK_DELAY_ACCT=y
> > CONFIG_TASK_XACCT=y
> > CONFIG_TASK_IO_ACCOUNTING=y
> > CONFIG_CPU_ISOLATION=y
> > 
> > #
> > # RCU Subsystem
> > #
> > CONFIG_PREEMPT_RCU=y
> > # CONFIG_RCU_EXPERT is not set
> > CONFIG_SRCU=y
> > CONFIG_TREE_SRCU=y
> > CONFIG_TASKS_RCU=y
> > CONFIG_RCU_STALL_COMMON=y
> > CONFIG_RCU_NEED_SEGCBLIST=y
> > CONFIG_CONTEXT_TRACKING=y
> > # CONFIG_CONTEXT_TRACKING_FORCE is not set
> > CONFIG_RCU_NOCB_CPU=y
> > CONFIG_BUILD_BIN2C=y
> > CONFIG_IKCONFIG=y
> > CONFIG_IKCONFIG_PROC=y
> > CONFIG_LOG_BUF_SHIFT=20
> > CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
> > CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
> > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> > CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> > CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
> > CONFIG_ARCH_SUPPORTS_INT128=y
> > CONFIG_NUMA_BALANCING=y
> > CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
> > CONFIG_CGROUPS=y
> > CONFIG_PAGE_COUNTER=y
> > CONFIG_MEMCG=y
> > CONFIG_MEMCG_SWAP=y
> > CONFIG_MEMCG_SWAP_ENABLED=y
> > CONFIG_MEMCG_KMEM=y
> > CONFIG_BLK_CGROUP=y
> > # CONFIG_DEBUG_BLK_CGROUP is not set
> > CONFIG_CGROUP_WRITEBACK=y
> > CONFIG_CGROUP_SCHED=y
> > CONFIG_FAIR_GROUP_SCHED=y
> > CONFIG_CFS_BANDWIDTH=y
> > CONFIG_RT_GROUP_SCHED=y
> > CONFIG_CGROUP_PIDS=y
> > CONFIG_CGROUP_RDMA=y
> > CONFIG_CGROUP_FREEZER=y
> > CONFIG_CGROUP_HUGETLB=y
> > CONFIG_CPUSETS=y
> > CONFIG_PROC_PID_CPUSET=y
> > CONFIG_CGROUP_DEVICE=y
> > CONFIG_CGROUP_CPUACCT=y
> > CONFIG_CGROUP_PERF=y
> > CONFIG_CGROUP_BPF=y
> > # CONFIG_CGROUP_DEBUG is not set
> > CONFIG_SOCK_CGROUP_DATA=y
> > CONFIG_NAMESPACES=y
> > CONFIG_UTS_NS=y
> > CONFIG_IPC_NS=y
> > CONFIG_USER_NS=y
> > CONFIG_PID_NS=y
> > CONFIG_NET_NS=y
> > CONFIG_CHECKPOINT_RESTORE=y
> > CONFIG_SCHED_AUTOGROUP=y
> > # CONFIG_SYSFS_DEPRECATED is not set
> > CONFIG_RELAY=y
> > CONFIG_BLK_DEV_INITRD=y
> > CONFIG_INITRAMFS_SOURCE=""
> > CONFIG_RD_GZIP=y
> > CONFIG_RD_BZIP2=y
> > CONFIG_RD_LZMA=y
> > CONFIG_RD_XZ=y
> > CONFIG_RD_LZO=y
> > CONFIG_RD_LZ4=y
> > CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
> > # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> > CONFIG_SYSCTL=y
> > CONFIG_ANON_INODES=y
> > CONFIG_HAVE_UID16=y
> > CONFIG_SYSCTL_EXCEPTION_TRACE=y
> > CONFIG_HAVE_PCSPKR_PLATFORM=y
> > CONFIG_BPF=y
> > CONFIG_EXPERT=y
> > CONFIG_UID16=y
> > CONFIG_MULTIUSER=y
> > CONFIG_SGETMASK_SYSCALL=y
> > CONFIG_SYSFS_SYSCALL=y
> > # CONFIG_SYSCTL_SYSCALL is not set
> > CONFIG_FHANDLE=y
> > CONFIG_POSIX_TIMERS=y
> > CONFIG_PRINTK=y
> > CONFIG_PRINTK_NMI=y
> > CONFIG_BUG=y
> > CONFIG_ELF_CORE=y
> > CONFIG_PCSPKR_PLATFORM=y
> > CONFIG_BASE_FULL=y
> > CONFIG_FUTEX=y
> > CONFIG_FUTEX_PI=y
> > CONFIG_EPOLL=y
> > CONFIG_SIGNALFD=y
> > CONFIG_TIMERFD=y
> > CONFIG_EVENTFD=y
> > CONFIG_SHMEM=y
> > CONFIG_AIO=y
> > CONFIG_ADVISE_SYSCALLS=y
> > CONFIG_MEMBARRIER=y
> > CONFIG_KALLSYMS=y
> > CONFIG_KALLSYMS_ALL=y
> > CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
> > CONFIG_KALLSYMS_BASE_RELATIVE=y
> > CONFIG_BPF_SYSCALL=y
> > CONFIG_BPF_JIT_ALWAYS_ON=y
> > CONFIG_USERFAULTFD=y
> > CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
> > CONFIG_RSEQ=y
> > # CONFIG_DEBUG_RSEQ is not set
> > CONFIG_EMBEDDED=y
> > CONFIG_HAVE_PERF_EVENTS=y
> > # CONFIG_PC104 is not set
> > 
> > #
> > # Kernel Performance Events And Counters
> > #
> > CONFIG_PERF_EVENTS=y
> > # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> > CONFIG_VM_EVENT_COUNTERS=y
> > CONFIG_SLUB_DEBUG=y
> > # CONFIG_SLUB_MEMCG_SYSFS_ON is not set
> > # CONFIG_COMPAT_BRK is not set
> > # CONFIG_SLAB is not set
> > CONFIG_SLUB=y
> > # CONFIG_SLOB is not set
> > CONFIG_SLAB_MERGE_DEFAULT=y
> > CONFIG_SLAB_FREELIST_RANDOM=y
> > # CONFIG_SLAB_FREELIST_HARDENED is not set
> > CONFIG_SLUB_CPU_PARTIAL=y
> > CONFIG_SYSTEM_DATA_VERIFICATION=y
> > CONFIG_PROFILING=y
> > CONFIG_TRACEPOINTS=y
> > CONFIG_64BIT=y
> > CONFIG_X86_64=y
> > CONFIG_X86=y
> > CONFIG_INSTRUCTION_DECODER=y
> > CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> > CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> > CONFIG_LOCKDEP_SUPPORT=y
> > CONFIG_STACKTRACE_SUPPORT=y
> > CONFIG_MMU=y
> > CONFIG_ARCH_MMAP_RND_BITS_MIN=28
> > CONFIG_ARCH_MMAP_RND_BITS_MAX=32
> > CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
> > CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
> > CONFIG_GENERIC_ISA_DMA=y
> > CONFIG_GENERIC_BUG=y
> > CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> > CONFIG_GENERIC_HWEIGHT=y
> > CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> > CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> > CONFIG_GENERIC_CALIBRATE_DELAY=y
> > CONFIG_ARCH_HAS_CPU_RELAX=y
> > CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> > CONFIG_ARCH_HAS_FILTER_PGPROT=y
> > CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> > CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> > CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> > CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> > CONFIG_ARCH_SUSPEND_POSSIBLE=y
> > CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> > CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> > CONFIG_ZONE_DMA32=y
> > CONFIG_AUDIT_ARCH=y
> > CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> > CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> > CONFIG_HAVE_INTEL_TXT=y
> > CONFIG_X86_64_SMP=y
> > CONFIG_ARCH_SUPPORTS_UPROBES=y
> > CONFIG_FIX_EARLYCON_MEM=y
> > CONFIG_DYNAMIC_PHYSICAL_MASK=y
> > CONFIG_PGTABLE_LEVELS=5
> > CONFIG_CC_HAS_SANE_STACKPROTECTOR=y
> > 
> > #
> > # Processor type and features
> > #
> > CONFIG_ZONE_DMA=y
> > CONFIG_SMP=y
> > CONFIG_X86_FEATURE_NAMES=y
> > CONFIG_X86_X2APIC=y
> > CONFIG_X86_MPPARSE=y
> > # CONFIG_GOLDFISH is not set
> > CONFIG_RETPOLINE=y
> > # CONFIG_INTEL_RDT is not set
> > CONFIG_X86_EXTENDED_PLATFORM=y
> > # CONFIG_X86_NUMACHIP is not set
> > # CONFIG_X86_VSMP is not set
> > CONFIG_X86_UV=y
> > # CONFIG_X86_GOLDFISH is not set
> > # CONFIG_X86_INTEL_MID is not set
> > CONFIG_X86_INTEL_LPSS=y
> > CONFIG_X86_AMD_PLATFORM_DEVICE=y
> > CONFIG_IOSF_MBI=y
> > # CONFIG_IOSF_MBI_DEBUG is not set
> > CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> > # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> > CONFIG_HYPERVISOR_GUEST=y
> > CONFIG_PARAVIRT=y
> > # CONFIG_PARAVIRT_DEBUG is not set
> > CONFIG_PARAVIRT_SPINLOCKS=y
> > # CONFIG_QUEUED_LOCK_STAT is not set
> > CONFIG_XEN=y
> > # CONFIG_XEN_PV is not set
> > CONFIG_XEN_PVHVM=y
> > CONFIG_XEN_PVHVM_SMP=y
> > CONFIG_XEN_SAVE_RESTORE=y
> > # CONFIG_XEN_DEBUG_FS is not set
> > # CONFIG_XEN_PVH is not set
> > CONFIG_KVM_GUEST=y
> > # CONFIG_KVM_DEBUG_FS is not set
> > CONFIG_PARAVIRT_TIME_ACCOUNTING=y
> > CONFIG_PARAVIRT_CLOCK=y
> > # CONFIG_JAILHOUSE_GUEST is not set
> > CONFIG_NO_BOOTMEM=y
> > # CONFIG_MK8 is not set
> > # CONFIG_MPSC is not set
> > # CONFIG_MCORE2 is not set
> > # CONFIG_MATOM is not set
> > CONFIG_GENERIC_CPU=y
> > CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> > CONFIG_X86_L1_CACHE_SHIFT=6
> > CONFIG_X86_TSC=y
> > CONFIG_X86_CMPXCHG64=y
> > CONFIG_X86_CMOV=y
> > CONFIG_X86_MINIMUM_CPU_FAMILY=64
> > CONFIG_X86_DEBUGCTLMSR=y
> > # CONFIG_PROCESSOR_SELECT is not set
> > CONFIG_CPU_SUP_INTEL=y
> > CONFIG_CPU_SUP_AMD=y
> > CONFIG_CPU_SUP_CENTAUR=y
> > CONFIG_HPET_TIMER=y
> > CONFIG_HPET_EMULATE_RTC=y
> > CONFIG_DMI=y
> > # CONFIG_GART_IOMMU is not set
> > # CONFIG_CALGARY_IOMMU is not set
> > CONFIG_MAXSMP=y
> > CONFIG_NR_CPUS_RANGE_BEGIN=8192
> > CONFIG_NR_CPUS_RANGE_END=8192
> > CONFIG_NR_CPUS_DEFAULT=8192
> > CONFIG_NR_CPUS=8192
> > CONFIG_SCHED_SMT=y
> > CONFIG_SCHED_MC=y
> > CONFIG_SCHED_MC_PRIO=y
> > CONFIG_X86_LOCAL_APIC=y
> > CONFIG_X86_IO_APIC=y
> > CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> > CONFIG_X86_MCE=y
> > CONFIG_X86_MCELOG_LEGACY=y
> > CONFIG_X86_MCE_INTEL=y
> > CONFIG_X86_MCE_AMD=y
> > CONFIG_X86_MCE_THRESHOLD=y
> > CONFIG_X86_MCE_INJECT=m
> > CONFIG_X86_THERMAL_VECTOR=y
> > 
> > #
> > # Performance monitoring
> > #
> > CONFIG_PERF_EVENTS_INTEL_UNCORE=m
> > CONFIG_PERF_EVENTS_INTEL_RAPL=m
> > CONFIG_PERF_EVENTS_INTEL_CSTATE=m
> > CONFIG_PERF_EVENTS_AMD_POWER=m
> > CONFIG_X86_16BIT=y
> > CONFIG_X86_ESPFIX64=y
> > CONFIG_X86_VSYSCALL_EMULATION=y
> > CONFIG_I8K=m
> > CONFIG_MICROCODE=y
> > CONFIG_MICROCODE_INTEL=y
> > CONFIG_MICROCODE_AMD=y
> > CONFIG_MICROCODE_OLD_INTERFACE=y
> > CONFIG_X86_MSR=y
> > CONFIG_X86_CPUID=y
> > CONFIG_X86_5LEVEL=y
> > CONFIG_X86_DIRECT_GBPAGES=y
> > CONFIG_ARCH_HAS_MEM_ENCRYPT=y
> > CONFIG_AMD_MEM_ENCRYPT=y
> > # CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
> > CONFIG_ARCH_USE_MEMREMAP_PROT=y
> > CONFIG_NUMA=y
> > CONFIG_AMD_NUMA=y
> > CONFIG_X86_64_ACPI_NUMA=y
> > CONFIG_NODES_SPAN_OTHER_NODES=y
> > CONFIG_NUMA_EMU=y
> > CONFIG_NODES_SHIFT=10
> > CONFIG_ARCH_SPARSEMEM_ENABLE=y
> > CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> > CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> > # CONFIG_ARCH_MEMORY_PROBE is not set
> > CONFIG_ARCH_PROC_KCORE_TEXT=y
> > CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> > CONFIG_X86_PMEM_LEGACY_DEVICE=y
> > CONFIG_X86_PMEM_LEGACY=m
> > CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> > # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> > CONFIG_X86_RESERVE_LOW=64
> > CONFIG_MTRR=y
> > CONFIG_MTRR_SANITIZER=y
> > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> > CONFIG_X86_PAT=y
> > CONFIG_ARCH_USES_PG_UNCACHED=y
> > CONFIG_ARCH_RANDOM=y
> > CONFIG_X86_SMAP=y
> > CONFIG_X86_INTEL_UMIP=y
> > # CONFIG_X86_INTEL_MPX is not set
> > CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
> > CONFIG_EFI=y
> > CONFIG_EFI_STUB=y
> > CONFIG_EFI_MIXED=y
> > CONFIG_SECCOMP=y
> > # CONFIG_HZ_100 is not set
> > # CONFIG_HZ_250 is not set
> > # CONFIG_HZ_300 is not set
> > CONFIG_HZ_1000=y
> > CONFIG_HZ=1000
> > CONFIG_SCHED_HRTICK=y
> > CONFIG_KEXEC=y
> > CONFIG_KEXEC_FILE=y
> > CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
> > CONFIG_KEXEC_VERIFY_SIG=y
> > CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
> > CONFIG_CRASH_DUMP=y
> > CONFIG_KEXEC_JUMP=y
> > CONFIG_PHYSICAL_START=0x1000000
> > CONFIG_RELOCATABLE=y
> > CONFIG_RANDOMIZE_BASE=y
> > CONFIG_X86_NEED_RELOCS=y
> > CONFIG_PHYSICAL_ALIGN=0x200000
> > CONFIG_DYNAMIC_MEMORY_LAYOUT=y
> > CONFIG_RANDOMIZE_MEMORY=y
> > CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
> > CONFIG_HOTPLUG_CPU=y
> > CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
> > # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> > # CONFIG_COMPAT_VDSO is not set
> > CONFIG_LEGACY_VSYSCALL_EMULATE=y
> > # CONFIG_LEGACY_VSYSCALL_NONE is not set
> > # CONFIG_CMDLINE_BOOL is not set
> > CONFIG_MODIFY_LDT_SYSCALL=y
> > CONFIG_HAVE_LIVEPATCH=y
> > CONFIG_LIVEPATCH=y
> > CONFIG_ARCH_HAS_ADD_PAGES=y
> > CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> > CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> > CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> > CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> > CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
> > CONFIG_ARCH_ENABLE_THP_MIGRATION=y
> > 
> > #
> > # Power management and ACPI options
> > #
> > CONFIG_ARCH_HIBERNATION_HEADER=y
> > CONFIG_SUSPEND=y
> > CONFIG_SUSPEND_FREEZER=y
> > # CONFIG_SUSPEND_SKIP_SYNC is not set
> > CONFIG_HIBERNATE_CALLBACKS=y
> > CONFIG_HIBERNATION=y
> > CONFIG_PM_STD_PARTITION=""
> > CONFIG_PM_SLEEP=y
> > CONFIG_PM_SLEEP_SMP=y
> > # CONFIG_PM_AUTOSLEEP is not set
> > # CONFIG_PM_WAKELOCKS is not set
> > CONFIG_PM=y
> > CONFIG_PM_DEBUG=y
> > # CONFIG_PM_ADVANCED_DEBUG is not set
> > # CONFIG_PM_TEST_SUSPEND is not set
> > CONFIG_PM_SLEEP_DEBUG=y
> > # CONFIG_DPM_WATCHDOG is not set
> > # CONFIG_PM_TRACE_RTC is not set
> > CONFIG_PM_CLK=y
> > # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> > CONFIG_ARCH_SUPPORTS_ACPI=y
> > CONFIG_ACPI=y
> > CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
> > CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
> > CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
> > # CONFIG_ACPI_DEBUGGER is not set
> > CONFIG_ACPI_SPCR_TABLE=y
> > CONFIG_ACPI_LPIT=y
> > CONFIG_ACPI_SLEEP=y
> > # CONFIG_ACPI_PROCFS_POWER is not set
> > CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
> > CONFIG_ACPI_EC_DEBUGFS=m
> > CONFIG_ACPI_AC=y
> > CONFIG_ACPI_BATTERY=y
> > CONFIG_ACPI_BUTTON=y
> > CONFIG_ACPI_VIDEO=m
> > CONFIG_ACPI_FAN=y
> > CONFIG_ACPI_TAD=m
> > CONFIG_ACPI_DOCK=y
> > CONFIG_ACPI_CPU_FREQ_PSS=y
> > CONFIG_ACPI_PROCESSOR_CSTATE=y
> > CONFIG_ACPI_PROCESSOR_IDLE=y
> > CONFIG_ACPI_CPPC_LIB=y
> > CONFIG_ACPI_PROCESSOR=y
> > CONFIG_ACPI_IPMI=m
> > CONFIG_ACPI_HOTPLUG_CPU=y
> > CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> > CONFIG_ACPI_THERMAL=y
> > CONFIG_ACPI_NUMA=y
> > CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
> > CONFIG_ACPI_TABLE_UPGRADE=y
> > # CONFIG_ACPI_DEBUG is not set
> > CONFIG_ACPI_PCI_SLOT=y
> > CONFIG_ACPI_CONTAINER=y
> > CONFIG_ACPI_HOTPLUG_MEMORY=y
> > CONFIG_ACPI_HOTPLUG_IOAPIC=y
> > CONFIG_ACPI_SBS=m
> > CONFIG_ACPI_HED=y
> > # CONFIG_ACPI_CUSTOM_METHOD is not set
> > CONFIG_ACPI_BGRT=y
> > # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> > CONFIG_ACPI_NFIT=m
> > CONFIG_HAVE_ACPI_APEI=y
> > CONFIG_HAVE_ACPI_APEI_NMI=y
> > CONFIG_ACPI_APEI=y
> > CONFIG_ACPI_APEI_GHES=y
> > CONFIG_ACPI_APEI_PCIEAER=y
> > CONFIG_ACPI_APEI_MEMORY_FAILURE=y
> > CONFIG_ACPI_APEI_EINJ=m
> > # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> > CONFIG_DPTF_POWER=m
> > CONFIG_ACPI_WATCHDOG=y
> > CONFIG_ACPI_EXTLOG=m
> > CONFIG_PMIC_OPREGION=y
> > # CONFIG_ACPI_CONFIGFS is not set
> > CONFIG_X86_PM_TIMER=y
> > CONFIG_SFI=y
> > 
> > #
> > # CPU Frequency scaling
> > #
> > CONFIG_CPU_FREQ=y
> > CONFIG_CPU_FREQ_GOV_ATTR_SET=y
> > CONFIG_CPU_FREQ_GOV_COMMON=y
> > CONFIG_CPU_FREQ_STAT=y
> > CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> > # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> > # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> > # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> > # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> > # CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
> > CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> > CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> > CONFIG_CPU_FREQ_GOV_USERSPACE=y
> > CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> > CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> > CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y
> > 
> > #
> > # CPU frequency scaling drivers
> > #
> > CONFIG_X86_INTEL_PSTATE=y
> > # CONFIG_X86_PCC_CPUFREQ is not set
> > CONFIG_X86_ACPI_CPUFREQ=m
> > CONFIG_X86_ACPI_CPUFREQ_CPB=y
> > CONFIG_X86_POWERNOW_K8=m
> > CONFIG_X86_AMD_FREQ_SENSITIVITY=m
> > # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> > CONFIG_X86_P4_CLOCKMOD=m
> > 
> > #
> > # shared options
> > #
> > CONFIG_X86_SPEEDSTEP_LIB=m
> > 
> > #
> > # CPU Idle
> > #
> > CONFIG_CPU_IDLE=y
> > # CONFIG_CPU_IDLE_GOV_LADDER is not set
> > CONFIG_CPU_IDLE_GOV_MENU=y
> > CONFIG_INTEL_IDLE=y
> > 
> > #
> > # Bus options (PCI etc.)
> > #
> > CONFIG_PCI=y
> > CONFIG_PCI_DIRECT=y
> > CONFIG_PCI_MMCONFIG=y
> > CONFIG_PCI_XEN=y
> > CONFIG_PCI_DOMAINS=y
> > CONFIG_MMCONF_FAM10H=y
> > # CONFIG_PCI_CNB20LE_QUIRK is not set
> > CONFIG_PCIEPORTBUS=y
> > CONFIG_HOTPLUG_PCI_PCIE=y
> > CONFIG_PCIEAER=y
> > CONFIG_PCIEAER_INJECT=m
> > CONFIG_PCIE_ECRC=y
> > CONFIG_PCIEASPM=y
> > # CONFIG_PCIEASPM_DEBUG is not set
> > CONFIG_PCIEASPM_DEFAULT=y
> > # CONFIG_PCIEASPM_POWERSAVE is not set
> > # CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
> > # CONFIG_PCIEASPM_PERFORMANCE is not set
> > CONFIG_PCIE_PME=y
> > CONFIG_PCIE_DPC=y
> > # CONFIG_PCIE_PTM is not set
> > CONFIG_PCI_MSI=y
> > CONFIG_PCI_MSI_IRQ_DOMAIN=y
> > CONFIG_PCI_QUIRKS=y
> > # CONFIG_PCI_DEBUG is not set
> > # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> > CONFIG_PCI_STUB=y
> > CONFIG_PCI_PF_STUB=m
> > # CONFIG_XEN_PCIDEV_FRONTEND is not set
> > CONFIG_PCI_ATS=y
> > CONFIG_PCI_LOCKLESS_CONFIG=y
> > CONFIG_PCI_IOV=y
> > CONFIG_PCI_PRI=y
> > CONFIG_PCI_PASID=y
> > CONFIG_PCI_LABEL=y
> > CONFIG_PCI_HYPERV=m
> > CONFIG_HOTPLUG_PCI=y
> > CONFIG_HOTPLUG_PCI_ACPI=y
> > CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> > # CONFIG_HOTPLUG_PCI_CPCI is not set
> > CONFIG_HOTPLUG_PCI_SHPC=y
> > 
> > #
> > # PCI controller drivers
> > #
> > 
> > #
> > # Cadence PCIe controllers support
> > #
> > CONFIG_VMD=y
> > 
> > #
> > # DesignWare PCI Core Support
> > #
> > # CONFIG_PCIE_DW_PLAT_HOST is not set
> > 
> > #
> > # PCI Endpoint
> > #
> > # CONFIG_PCI_ENDPOINT is not set
> > 
> > #
> > # PCI switch controller drivers
> > #
> > # CONFIG_PCI_SW_SWITCHTEC is not set
> > # CONFIG_ISA_BUS is not set
> > CONFIG_ISA_DMA_API=y
> > CONFIG_AMD_NB=y
> > # CONFIG_PCCARD is not set
> > # CONFIG_RAPIDIO is not set
> > # CONFIG_X86_SYSFB is not set
> > 
> > #
> > # Binary Emulations
> > #
> > CONFIG_IA32_EMULATION=y
> > # CONFIG_IA32_AOUT is not set
> > # CONFIG_X86_X32 is not set
> > CONFIG_COMPAT_32=y
> > CONFIG_COMPAT=y
> > CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> > CONFIG_SYSVIPC_COMPAT=y
> > CONFIG_X86_DEV_DMA_OPS=y
> > CONFIG_HAVE_GENERIC_GUP=y
> > 
> > #
> > # Firmware Drivers
> > #
> > CONFIG_EDD=m
> > # CONFIG_EDD_OFF is not set
> > CONFIG_FIRMWARE_MEMMAP=y
> > CONFIG_DELL_RBU=m
> > CONFIG_DCDBAS=m
> > CONFIG_DMIID=y
> > CONFIG_DMI_SYSFS=y
> > CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> > CONFIG_ISCSI_IBFT_FIND=y
> > # CONFIG_ISCSI_IBFT is not set
> > CONFIG_FW_CFG_SYSFS=y
> > # CONFIG_FW_CFG_SYSFS_CMDLINE is not set
> > # CONFIG_GOOGLE_FIRMWARE is not set
> > 
> > #
> > # EFI (Extensible Firmware Interface) Support
> > #
> > CONFIG_EFI_VARS=y
> > CONFIG_EFI_ESRT=y
> > CONFIG_EFI_VARS_PSTORE=y
> > CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
> > CONFIG_EFI_RUNTIME_MAP=y
> > # CONFIG_EFI_FAKE_MEMMAP is not set
> > CONFIG_EFI_RUNTIME_WRAPPERS=y
> > # CONFIG_EFI_BOOTLOADER_CONTROL is not set
> > # CONFIG_EFI_CAPSULE_LOADER is not set
> > # CONFIG_EFI_TEST is not set
> > CONFIG_APPLE_PROPERTIES=y
> > # CONFIG_RESET_ATTACK_MITIGATION is not set
> > CONFIG_UEFI_CPER=y
> > CONFIG_UEFI_CPER_X86=y
> > CONFIG_EFI_DEV_PATH_PARSER=y
> > 
> > #
> > # Tegra firmware driver
> > #
> > CONFIG_HAVE_KVM=y
> > CONFIG_HAVE_KVM_IRQCHIP=y
> > CONFIG_HAVE_KVM_IRQFD=y
> > CONFIG_HAVE_KVM_IRQ_ROUTING=y
> > CONFIG_HAVE_KVM_EVENTFD=y
> > CONFIG_KVM_MMIO=y
> > CONFIG_KVM_ASYNC_PF=y
> > CONFIG_HAVE_KVM_MSI=y
> > CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> > CONFIG_KVM_VFIO=y
> > CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
> > CONFIG_KVM_COMPAT=y
> > CONFIG_HAVE_KVM_IRQ_BYPASS=y
> > CONFIG_VIRTUALIZATION=y
> > CONFIG_KVM=y
> > CONFIG_KVM_INTEL=y
> > # CONFIG_KVM_AMD is not set
> > CONFIG_KVM_MMU_AUDIT=y
> > CONFIG_VHOST_NET=m
> > # CONFIG_VHOST_SCSI is not set
> > CONFIG_VHOST_VSOCK=m
> > CONFIG_VHOST=m
> > # CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set
> > 
> > #
> > # General architecture-dependent options
> > #
> > CONFIG_CRASH_CORE=y
> > CONFIG_KEXEC_CORE=y
> > CONFIG_HOTPLUG_SMT=y
> > CONFIG_OPROFILE=m
> > CONFIG_OPROFILE_EVENT_MULTIPLEX=y
> > CONFIG_HAVE_OPROFILE=y
> > CONFIG_OPROFILE_NMI_TIMER=y
> > CONFIG_KPROBES=y
> > CONFIG_JUMP_LABEL=y
> > # CONFIG_STATIC_KEYS_SELFTEST is not set
> > CONFIG_OPTPROBES=y
> > CONFIG_KPROBES_ON_FTRACE=y
> > CONFIG_UPROBES=y
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> > CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> > CONFIG_KRETPROBES=y
> > CONFIG_USER_RETURN_NOTIFIER=y
> > CONFIG_HAVE_IOREMAP_PROT=y
> > CONFIG_HAVE_KPROBES=y
> > CONFIG_HAVE_KRETPROBES=y
> > CONFIG_HAVE_OPTPROBES=y
> > CONFIG_HAVE_KPROBES_ON_FTRACE=y
> > CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
> > CONFIG_HAVE_NMI=y
> > CONFIG_HAVE_ARCH_TRACEHOOK=y
> > CONFIG_HAVE_DMA_CONTIGUOUS=y
> > CONFIG_GENERIC_SMP_IDLE_THREAD=y
> > CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
> > CONFIG_ARCH_HAS_SET_MEMORY=y
> > CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
> > CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
> > CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> > CONFIG_HAVE_RSEQ=y
> > CONFIG_HAVE_CLK=y
> > CONFIG_HAVE_HW_BREAKPOINT=y
> > CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> > CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> > CONFIG_HAVE_PERF_EVENTS_NMI=y
> > CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
> > CONFIG_HAVE_PERF_REGS=y
> > CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> > CONFIG_HAVE_ARCH_JUMP_LABEL=y
> > CONFIG_HAVE_RCU_TABLE_FREE=y
> > CONFIG_HAVE_RCU_TABLE_INVALIDATE=y
> > CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> > CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> > CONFIG_HAVE_CMPXCHG_LOCAL=y
> > CONFIG_HAVE_CMPXCHG_DOUBLE=y
> > CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> > CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> > CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> > CONFIG_SECCOMP_FILTER=y
> > CONFIG_HAVE_STACKPROTECTOR=y
> > CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
> > CONFIG_STACKPROTECTOR=y
> > CONFIG_STACKPROTECTOR_STRONG=y
> > CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
> > CONFIG_HAVE_CONTEXT_TRACKING=y
> > CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> > CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> > CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> > CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
> > CONFIG_HAVE_ARCH_HUGE_VMAP=y
> > CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> > CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
> > CONFIG_MODULES_USE_ELF_RELA=y
> > CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> > CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
> > CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
> > CONFIG_HAVE_EXIT_THREAD=y
> > CONFIG_ARCH_MMAP_RND_BITS=28
> > CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
> > CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
> > CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
> > CONFIG_HAVE_COPY_THREAD_TLS=y
> > CONFIG_HAVE_STACK_VALIDATION=y
> > CONFIG_HAVE_RELIABLE_STACKTRACE=y
> > CONFIG_OLD_SIGSUSPEND3=y
> > CONFIG_COMPAT_OLD_SIGACTION=y
> > CONFIG_COMPAT_32BIT_TIME=y
> > CONFIG_HAVE_ARCH_VMAP_STACK=y
> > CONFIG_VMAP_STACK=y
> > CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
> > CONFIG_STRICT_KERNEL_RWX=y
> > CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
> > CONFIG_STRICT_MODULE_RWX=y
> > CONFIG_ARCH_HAS_REFCOUNT=y
> > # CONFIG_REFCOUNT_FULL is not set
> > CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
> > 
> > #
> > # GCOV-based kernel profiling
> > #
> > # CONFIG_GCOV_KERNEL is not set
> > CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
> > CONFIG_PLUGIN_HOSTCC=""
> > CONFIG_HAVE_GCC_PLUGINS=y
> > CONFIG_RT_MUTEXES=y
> > CONFIG_BASE_SMALL=0
> > CONFIG_MODULES=y
> > CONFIG_MODULE_FORCE_LOAD=y
> > CONFIG_MODULE_UNLOAD=y
> > # CONFIG_MODULE_FORCE_UNLOAD is not set
> > # CONFIG_MODVERSIONS is not set
> > # CONFIG_MODULE_SRCVERSION_ALL is not set
> > CONFIG_MODULE_SIG=y
> > # CONFIG_MODULE_SIG_FORCE is not set
> > CONFIG_MODULE_SIG_ALL=y
> > # CONFIG_MODULE_SIG_SHA1 is not set
> > # CONFIG_MODULE_SIG_SHA224 is not set
> > CONFIG_MODULE_SIG_SHA256=y
> > # CONFIG_MODULE_SIG_SHA384 is not set
> > # CONFIG_MODULE_SIG_SHA512 is not set
> > CONFIG_MODULE_SIG_HASH="sha256"
> > # CONFIG_MODULE_COMPRESS is not set
> > # CONFIG_TRIM_UNUSED_KSYMS is not set
> > CONFIG_MODULES_TREE_LOOKUP=y
> > CONFIG_BLOCK=y
> > CONFIG_BLK_SCSI_REQUEST=y
> > CONFIG_BLK_DEV_BSG=y
> > CONFIG_BLK_DEV_BSGLIB=y
> > CONFIG_BLK_DEV_INTEGRITY=y
> > # CONFIG_BLK_DEV_ZONED is not set
> > CONFIG_BLK_DEV_THROTTLING=y
> > # CONFIG_BLK_DEV_THROTTLING_LOW is not set
> > # CONFIG_BLK_CMDLINE_PARSER is not set
> > CONFIG_BLK_WBT=y
> > # CONFIG_BLK_CGROUP_IOLATENCY is not set
> > # CONFIG_BLK_WBT_SQ is not set
> > CONFIG_BLK_WBT_MQ=y
> > CONFIG_BLK_DEBUG_FS=y
> > # CONFIG_BLK_SED_OPAL is not set
> > 
> > #
> > # Partition Types
> > #
> > CONFIG_PARTITION_ADVANCED=y
> > # CONFIG_ACORN_PARTITION is not set
> > # CONFIG_AIX_PARTITION is not set
> > CONFIG_OSF_PARTITION=y
> > CONFIG_AMIGA_PARTITION=y
> > # CONFIG_ATARI_PARTITION is not set
> > CONFIG_MAC_PARTITION=y
> > CONFIG_MSDOS_PARTITION=y
> > CONFIG_BSD_DISKLABEL=y
> > CONFIG_MINIX_SUBPARTITION=y
> > CONFIG_SOLARIS_X86_PARTITION=y
> > CONFIG_UNIXWARE_DISKLABEL=y
> > # CONFIG_LDM_PARTITION is not set
> > CONFIG_SGI_PARTITION=y
> > # CONFIG_ULTRIX_PARTITION is not set
> > CONFIG_SUN_PARTITION=y
> > CONFIG_KARMA_PARTITION=y
> > CONFIG_EFI_PARTITION=y
> > # CONFIG_SYSV68_PARTITION is not set
> > # CONFIG_CMDLINE_PARTITION is not set
> > CONFIG_BLOCK_COMPAT=y
> > CONFIG_BLK_MQ_PCI=y
> > CONFIG_BLK_MQ_VIRTIO=y
> > 
> > #
> > # IO Schedulers
> > #
> > CONFIG_IOSCHED_NOOP=y
> > CONFIG_IOSCHED_DEADLINE=y
> > CONFIG_IOSCHED_CFQ=y
> > # CONFIG_CFQ_GROUP_IOSCHED is not set
> > # CONFIG_DEFAULT_DEADLINE is not set
> > CONFIG_DEFAULT_CFQ=y
> > # CONFIG_DEFAULT_NOOP is not set
> > CONFIG_DEFAULT_IOSCHED="cfq"
> > CONFIG_MQ_IOSCHED_DEADLINE=y
> > CONFIG_MQ_IOSCHED_KYBER=y
> > CONFIG_IOSCHED_BFQ=y
> > CONFIG_BFQ_GROUP_IOSCHED=y
> > CONFIG_PREEMPT_NOTIFIERS=y
> > CONFIG_PADATA=y
> > CONFIG_ASN1=y
> > CONFIG_UNINLINE_SPIN_UNLOCK=y
> > CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
> > CONFIG_MUTEX_SPIN_ON_OWNER=y
> > CONFIG_RWSEM_SPIN_ON_OWNER=y
> > CONFIG_LOCK_SPIN_ON_OWNER=y
> > CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
> > CONFIG_QUEUED_SPINLOCKS=y
> > CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
> > CONFIG_QUEUED_RWLOCKS=y
> > CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
> > CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
> > CONFIG_FREEZER=y
> > 
> > #
> > # Executable file formats
> > #
> > CONFIG_BINFMT_ELF=y
> > CONFIG_COMPAT_BINFMT_ELF=y
> > CONFIG_ELFCORE=y
> > CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> > CONFIG_BINFMT_SCRIPT=y
> > CONFIG_BINFMT_MISC=m
> > CONFIG_COREDUMP=y
> > 
> > #
> > # Memory Management options
> > #
> > CONFIG_SELECT_MEMORY_MODEL=y
> > CONFIG_SPARSEMEM_MANUAL=y
> > CONFIG_SPARSEMEM=y
> > CONFIG_NEED_MULTIPLE_NODES=y
> > CONFIG_HAVE_MEMORY_PRESENT=y
> > CONFIG_SPARSEMEM_EXTREME=y
> > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> > CONFIG_SPARSEMEM_VMEMMAP=y
> > CONFIG_HAVE_MEMBLOCK=y
> > CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> > CONFIG_ARCH_DISCARD_MEMBLOCK=y
> > CONFIG_MEMORY_ISOLATION=y
> > CONFIG_HAVE_BOOTMEM_INFO_NODE=y
> > CONFIG_MEMORY_HOTPLUG=y
> > CONFIG_MEMORY_HOTPLUG_SPARSE=y
> > # CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
> > CONFIG_MEMORY_HOTREMOVE=y
> > CONFIG_SPLIT_PTLOCK_CPUS=4
> > CONFIG_MEMORY_BALLOON=y
> > CONFIG_BALLOON_COMPACTION=y
> > CONFIG_COMPACTION=y
> > CONFIG_MIGRATION=y
> > CONFIG_PHYS_ADDR_T_64BIT=y
> > CONFIG_BOUNCE=y
> > CONFIG_VIRT_TO_BUS=y
> > CONFIG_MMU_NOTIFIER=y
> > CONFIG_KSM=y
> > CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> > CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> > CONFIG_MEMORY_FAILURE=y
> > CONFIG_HWPOISON_INJECT=m
> > CONFIG_TRANSPARENT_HUGEPAGE=y
> > CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> > # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> > CONFIG_ARCH_WANTS_THP_SWAP=y
> > CONFIG_THP_SWAP=y
> > CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
> > CONFIG_CLEANCACHE=y
> > CONFIG_FRONTSWAP=y
> > # CONFIG_CMA is not set
> > # CONFIG_MEM_SOFT_DIRTY is not set
> > CONFIG_ZSWAP=y
> > CONFIG_ZPOOL=y
> > CONFIG_ZBUD=y
> > # CONFIG_Z3FOLD is not set
> > CONFIG_ZSMALLOC=y
> > # CONFIG_PGTABLE_MAPPING is not set
> > CONFIG_ZSMALLOC_STAT=y
> > CONFIG_GENERIC_EARLY_IOREMAP=y
> > CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
> > CONFIG_IDLE_PAGE_TRACKING=y
> > CONFIG_ARCH_HAS_ZONE_DEVICE=y
> > CONFIG_ZONE_DEVICE=y
> > CONFIG_ARCH_HAS_HMM=y
> > CONFIG_MIGRATE_VMA_HELPER=y
> > CONFIG_DEV_PAGEMAP_OPS=y
> > CONFIG_HMM=y
> > CONFIG_HMM_MIRROR=y
> > CONFIG_DEVICE_PRIVATE=y
> > # CONFIG_DEVICE_PUBLIC is not set
> > CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
> > CONFIG_ARCH_HAS_PKEYS=y
> > # CONFIG_PERCPU_STATS is not set
> > CONFIG_GUP_BENCHMARK=y
> > CONFIG_ARCH_HAS_PTE_SPECIAL=y
> > CONFIG_NET=y
> > CONFIG_NET_INGRESS=y
> > CONFIG_NET_EGRESS=y
> > 
> > #
> > # Networking options
> > #
> > CONFIG_PACKET=y
> > CONFIG_PACKET_DIAG=m
> > CONFIG_UNIX=y
> > CONFIG_UNIX_DIAG=m
> > CONFIG_TLS=m
> > CONFIG_TLS_DEVICE=y
> > CONFIG_XFRM=y
> > CONFIG_XFRM_OFFLOAD=y
> > CONFIG_XFRM_ALGO=y
> > CONFIG_XFRM_USER=y
> > # CONFIG_XFRM_INTERFACE is not set
> > CONFIG_XFRM_SUB_POLICY=y
> > CONFIG_XFRM_MIGRATE=y
> > CONFIG_XFRM_STATISTICS=y
> > CONFIG_XFRM_IPCOMP=m
> > CONFIG_NET_KEY=m
> > CONFIG_NET_KEY_MIGRATE=y
> > CONFIG_XDP_SOCKETS=y
> > CONFIG_INET=y
> > CONFIG_IP_MULTICAST=y
> > CONFIG_IP_ADVANCED_ROUTER=y
> > CONFIG_IP_FIB_TRIE_STATS=y
> > CONFIG_IP_MULTIPLE_TABLES=y
> > CONFIG_IP_ROUTE_MULTIPATH=y
> > CONFIG_IP_ROUTE_VERBOSE=y
> > CONFIG_IP_ROUTE_CLASSID=y
> > CONFIG_IP_PNP=y
> > CONFIG_IP_PNP_DHCP=y
> > # CONFIG_IP_PNP_BOOTP is not set
> > # CONFIG_IP_PNP_RARP is not set
> > CONFIG_NET_IPIP=y
> > CONFIG_NET_IPGRE_DEMUX=y
> > CONFIG_NET_IP_TUNNEL=y
> > CONFIG_NET_IPGRE=y
> > CONFIG_NET_IPGRE_BROADCAST=y
> > CONFIG_IP_MROUTE_COMMON=y
> > CONFIG_IP_MROUTE=y
> > CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
> > CONFIG_IP_PIMSM_V1=y
> > CONFIG_IP_PIMSM_V2=y
> > CONFIG_SYN_COOKIES=y
> > CONFIG_NET_IPVTI=m
> > CONFIG_NET_UDP_TUNNEL=y
> > CONFIG_NET_FOU=y
> > CONFIG_NET_FOU_IP_TUNNELS=y
> > CONFIG_INET_AH=m
> > CONFIG_INET_ESP=m
> > CONFIG_INET_ESP_OFFLOAD=m
> > CONFIG_INET_IPCOMP=m
> > CONFIG_INET_XFRM_TUNNEL=m
> > CONFIG_INET_TUNNEL=y
> > CONFIG_INET_XFRM_MODE_TRANSPORT=m
> > CONFIG_INET_XFRM_MODE_TUNNEL=m
> > CONFIG_INET_XFRM_MODE_BEET=m
> > CONFIG_INET_DIAG=m
> > CONFIG_INET_TCP_DIAG=m
> > CONFIG_INET_UDP_DIAG=m
> > CONFIG_INET_RAW_DIAG=m
> > # CONFIG_INET_DIAG_DESTROY is not set
> > CONFIG_TCP_CONG_ADVANCED=y
> > CONFIG_TCP_CONG_BIC=m
> > CONFIG_TCP_CONG_CUBIC=y
> > CONFIG_TCP_CONG_WESTWOOD=m
> > CONFIG_TCP_CONG_HTCP=m
> > CONFIG_TCP_CONG_HSTCP=m
> > CONFIG_TCP_CONG_HYBLA=m
> > CONFIG_TCP_CONG_VEGAS=m
> > CONFIG_TCP_CONG_NV=m
> > CONFIG_TCP_CONG_SCALABLE=m
> > CONFIG_TCP_CONG_LP=m
> > CONFIG_TCP_CONG_VENO=m
> > CONFIG_TCP_CONG_YEAH=m
> > CONFIG_TCP_CONG_ILLINOIS=m
> > CONFIG_TCP_CONG_DCTCP=m
> > # CONFIG_TCP_CONG_CDG is not set
> > CONFIG_TCP_CONG_BBR=m
> > CONFIG_DEFAULT_CUBIC=y
> > # CONFIG_DEFAULT_RENO is not set
> > CONFIG_DEFAULT_TCP_CONG="cubic"
> > CONFIG_TCP_MD5SIG=y
> > CONFIG_IPV6=y
> > CONFIG_IPV6_ROUTER_PREF=y
> > CONFIG_IPV6_ROUTE_INFO=y
> > CONFIG_IPV6_OPTIMISTIC_DAD=y
> > CONFIG_INET6_AH=m
> > CONFIG_INET6_ESP=m
> > CONFIG_INET6_ESP_OFFLOAD=m
> > CONFIG_INET6_IPCOMP=m
> > CONFIG_IPV6_MIP6=m
> > # CONFIG_IPV6_ILA is not set
> > CONFIG_INET6_XFRM_TUNNEL=m
> > CONFIG_INET6_TUNNEL=y
> > CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> > CONFIG_INET6_XFRM_MODE_TUNNEL=m
> > CONFIG_INET6_XFRM_MODE_BEET=m
> > CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> > CONFIG_IPV6_VTI=m
> > CONFIG_IPV6_SIT=m
> > CONFIG_IPV6_SIT_6RD=y
> > CONFIG_IPV6_NDISC_NODETYPE=y
> > CONFIG_IPV6_TUNNEL=y
> > CONFIG_IPV6_GRE=y
> > CONFIG_IPV6_FOU=y
> > CONFIG_IPV6_FOU_TUNNEL=y
> > CONFIG_IPV6_MULTIPLE_TABLES=y
> > # CONFIG_IPV6_SUBTREES is not set
> > CONFIG_IPV6_MROUTE=y
> > CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
> > CONFIG_IPV6_PIMSM_V2=y
> > CONFIG_IPV6_SEG6_LWTUNNEL=y
> > # CONFIG_IPV6_SEG6_HMAC is not set
> > CONFIG_IPV6_SEG6_BPF=y
> > CONFIG_NETLABEL=y
> > CONFIG_NETWORK_SECMARK=y
> > CONFIG_NET_PTP_CLASSIFY=y
> > CONFIG_NETWORK_PHY_TIMESTAMPING=y
> > CONFIG_NETFILTER=y
> > CONFIG_NETFILTER_ADVANCED=y
> > CONFIG_BRIDGE_NETFILTER=m
> > 
> > #
> > # Core Netfilter Configuration
> > #
> > CONFIG_NETFILTER_INGRESS=y
> > CONFIG_NETFILTER_NETLINK=m
> > CONFIG_NETFILTER_FAMILY_BRIDGE=y
> > CONFIG_NETFILTER_FAMILY_ARP=y
> > # CONFIG_NETFILTER_NETLINK_ACCT is not set
> > CONFIG_NETFILTER_NETLINK_QUEUE=m
> > CONFIG_NETFILTER_NETLINK_LOG=m
> > CONFIG_NETFILTER_NETLINK_OSF=m
> > CONFIG_NF_CONNTRACK=m
> > CONFIG_NF_LOG_COMMON=m
> > CONFIG_NF_LOG_NETDEV=m
> > CONFIG_NETFILTER_CONNCOUNT=m
> > CONFIG_NF_CONNTRACK_MARK=y
> > CONFIG_NF_CONNTRACK_SECMARK=y
> > CONFIG_NF_CONNTRACK_ZONES=y
> > CONFIG_NF_CONNTRACK_PROCFS=y
> > CONFIG_NF_CONNTRACK_EVENTS=y
> > CONFIG_NF_CONNTRACK_TIMEOUT=y
> > CONFIG_NF_CONNTRACK_TIMESTAMP=y
> > CONFIG_NF_CONNTRACK_LABELS=y
> > CONFIG_NF_CT_PROTO_DCCP=y
> > CONFIG_NF_CT_PROTO_GRE=m
> > CONFIG_NF_CT_PROTO_SCTP=y
> > CONFIG_NF_CT_PROTO_UDPLITE=y
> > CONFIG_NF_CONNTRACK_AMANDA=m
> > CONFIG_NF_CONNTRACK_FTP=m
> > CONFIG_NF_CONNTRACK_H323=m
> > CONFIG_NF_CONNTRACK_IRC=m
> > CONFIG_NF_CONNTRACK_BROADCAST=m
> > CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> > CONFIG_NF_CONNTRACK_SNMP=m
> > CONFIG_NF_CONNTRACK_PPTP=m
> > CONFIG_NF_CONNTRACK_SANE=m
> > CONFIG_NF_CONNTRACK_SIP=m
> > CONFIG_NF_CONNTRACK_TFTP=m
> > CONFIG_NF_CT_NETLINK=m
> > CONFIG_NF_CT_NETLINK_TIMEOUT=m
> > CONFIG_NF_CT_NETLINK_HELPER=m
> > CONFIG_NETFILTER_NETLINK_GLUE_CT=y
> > CONFIG_NF_NAT=m
> > CONFIG_NF_NAT_NEEDED=y
> > CONFIG_NF_NAT_PROTO_DCCP=y
> > CONFIG_NF_NAT_PROTO_UDPLITE=y
> > CONFIG_NF_NAT_PROTO_SCTP=y
> > CONFIG_NF_NAT_AMANDA=m
> > CONFIG_NF_NAT_FTP=m
> > CONFIG_NF_NAT_IRC=m
> > CONFIG_NF_NAT_SIP=m
> > CONFIG_NF_NAT_TFTP=m
> > CONFIG_NF_NAT_REDIRECT=y
> > CONFIG_NETFILTER_SYNPROXY=m
> > CONFIG_NF_TABLES=m
> > CONFIG_NF_TABLES_SET=m
> > CONFIG_NF_TABLES_INET=y
> > CONFIG_NF_TABLES_NETDEV=y
> > CONFIG_NFT_NUMGEN=m
> > CONFIG_NFT_CT=m
> > CONFIG_NFT_FLOW_OFFLOAD=m
> > CONFIG_NFT_COUNTER=m
> > CONFIG_NFT_CONNLIMIT=m
> > CONFIG_NFT_LOG=m
> > CONFIG_NFT_LIMIT=m
> > CONFIG_NFT_MASQ=m
> > CONFIG_NFT_REDIR=m
> > CONFIG_NFT_NAT=m
> > # CONFIG_NFT_TUNNEL is not set
> > CONFIG_NFT_OBJREF=m
> > CONFIG_NFT_QUEUE=m
> > CONFIG_NFT_QUOTA=m
> > CONFIG_NFT_REJECT=m
> > CONFIG_NFT_REJECT_INET=m
> > CONFIG_NFT_COMPAT=m
> > CONFIG_NFT_HASH=m
> > CONFIG_NFT_FIB=m
> > CONFIG_NFT_FIB_INET=m
> > CONFIG_NFT_SOCKET=m
> > # CONFIG_NFT_OSF is not set
> > # CONFIG_NFT_TPROXY is not set
> > CONFIG_NF_DUP_NETDEV=m
> > CONFIG_NFT_DUP_NETDEV=m
> > CONFIG_NFT_FWD_NETDEV=m
> > CONFIG_NFT_FIB_NETDEV=m
> > CONFIG_NF_FLOW_TABLE_INET=m
> > CONFIG_NF_FLOW_TABLE=m
> > CONFIG_NETFILTER_XTABLES=y
> > 
> > #
> > # Xtables combined modules
> > #
> > CONFIG_NETFILTER_XT_MARK=m
> > CONFIG_NETFILTER_XT_CONNMARK=m
> > CONFIG_NETFILTER_XT_SET=m
> > 
> > #
> > # Xtables targets
> > #
> > CONFIG_NETFILTER_XT_TARGET_AUDIT=m
> > CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
> > CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> > CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> > CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> > CONFIG_NETFILTER_XT_TARGET_CT=m
> > CONFIG_NETFILTER_XT_TARGET_DSCP=m
> > CONFIG_NETFILTER_XT_TARGET_HL=m
> > CONFIG_NETFILTER_XT_TARGET_HMARK=m
> > CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
> > # CONFIG_NETFILTER_XT_TARGET_LED is not set
> > CONFIG_NETFILTER_XT_TARGET_LOG=m
> > CONFIG_NETFILTER_XT_TARGET_MARK=m
> > CONFIG_NETFILTER_XT_NAT=m
> > CONFIG_NETFILTER_XT_TARGET_NETMAP=m
> > CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> > CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> > CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> > CONFIG_NETFILTER_XT_TARGET_RATEEST=m
> > CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
> > CONFIG_NETFILTER_XT_TARGET_TEE=m
> > CONFIG_NETFILTER_XT_TARGET_TPROXY=m
> > CONFIG_NETFILTER_XT_TARGET_TRACE=m
> > CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> > CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> > CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
> > 
> > #
> > # Xtables matches
> > #
> > CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
> > CONFIG_NETFILTER_XT_MATCH_BPF=m
> > CONFIG_NETFILTER_XT_MATCH_CGROUP=m
> > CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
> > CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> > CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> > CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
> > CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> > CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> > CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> > CONFIG_NETFILTER_XT_MATCH_CPU=m
> > CONFIG_NETFILTER_XT_MATCH_DCCP=m
> > CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
> > CONFIG_NETFILTER_XT_MATCH_DSCP=m
> > CONFIG_NETFILTER_XT_MATCH_ECN=m
> > CONFIG_NETFILTER_XT_MATCH_ESP=m
> > CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> > CONFIG_NETFILTER_XT_MATCH_HELPER=m
> > CONFIG_NETFILTER_XT_MATCH_HL=m
> > # CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
> > CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
> > CONFIG_NETFILTER_XT_MATCH_IPVS=m
> > # CONFIG_NETFILTER_XT_MATCH_L2TP is not set
> > CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> > CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> > CONFIG_NETFILTER_XT_MATCH_MAC=m
> > CONFIG_NETFILTER_XT_MATCH_MARK=m
> > CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> > # CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
> > CONFIG_NETFILTER_XT_MATCH_OSF=m
> > CONFIG_NETFILTER_XT_MATCH_OWNER=m
> > CONFIG_NETFILTER_XT_MATCH_POLICY=m
> > CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
> > CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> > CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> > CONFIG_NETFILTER_XT_MATCH_RATEEST=m
> > CONFIG_NETFILTER_XT_MATCH_REALM=m
> > CONFIG_NETFILTER_XT_MATCH_RECENT=m
> > CONFIG_NETFILTER_XT_MATCH_SCTP=m
> > CONFIG_NETFILTER_XT_MATCH_SOCKET=m
> > CONFIG_NETFILTER_XT_MATCH_STATE=m
> > CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> > CONFIG_NETFILTER_XT_MATCH_STRING=m
> > CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> > # CONFIG_NETFILTER_XT_MATCH_TIME is not set
> > # CONFIG_NETFILTER_XT_MATCH_U32 is not set
> > CONFIG_IP_SET=m
> > CONFIG_IP_SET_MAX=256
> > CONFIG_IP_SET_BITMAP_IP=m
> > CONFIG_IP_SET_BITMAP_IPMAC=m
> > CONFIG_IP_SET_BITMAP_PORT=m
> > CONFIG_IP_SET_HASH_IP=m
> > CONFIG_IP_SET_HASH_IPMARK=m
> > CONFIG_IP_SET_HASH_IPPORT=m
> > CONFIG_IP_SET_HASH_IPPORTIP=m
> > CONFIG_IP_SET_HASH_IPPORTNET=m
> > CONFIG_IP_SET_HASH_IPMAC=m
> > CONFIG_IP_SET_HASH_MAC=m
> > CONFIG_IP_SET_HASH_NETPORTNET=m
> > CONFIG_IP_SET_HASH_NET=m
> > CONFIG_IP_SET_HASH_NETNET=m
> > CONFIG_IP_SET_HASH_NETPORT=m
> > CONFIG_IP_SET_HASH_NETIFACE=m
> > CONFIG_IP_SET_LIST_SET=m
> > CONFIG_IP_VS=m
> > CONFIG_IP_VS_IPV6=y
> > # CONFIG_IP_VS_DEBUG is not set
> > CONFIG_IP_VS_TAB_BITS=12
> > 
> > #
> > # IPVS transport protocol load balancing support
> > #
> > CONFIG_IP_VS_PROTO_TCP=y
> > CONFIG_IP_VS_PROTO_UDP=y
> > CONFIG_IP_VS_PROTO_AH_ESP=y
> > CONFIG_IP_VS_PROTO_ESP=y
> > CONFIG_IP_VS_PROTO_AH=y
> > CONFIG_IP_VS_PROTO_SCTP=y
> > 
> > #
> > # IPVS scheduler
> > #
> > CONFIG_IP_VS_RR=m
> > CONFIG_IP_VS_WRR=m
> > CONFIG_IP_VS_LC=m
> > CONFIG_IP_VS_WLC=m
> > CONFIG_IP_VS_FO=m
> > CONFIG_IP_VS_OVF=m
> > CONFIG_IP_VS_LBLC=m
> > CONFIG_IP_VS_LBLCR=m
> > CONFIG_IP_VS_DH=m
> > CONFIG_IP_VS_SH=m
> > # CONFIG_IP_VS_MH is not set
> > CONFIG_IP_VS_SED=m
> > CONFIG_IP_VS_NQ=m
> > 
> > #
> > # IPVS SH scheduler
> > #
> > CONFIG_IP_VS_SH_TAB_BITS=8
> > 
> > #
> > # IPVS MH scheduler
> > #
> > CONFIG_IP_VS_MH_TAB_INDEX=12
> > 
> > #
> > # IPVS application helper
> > #
> > CONFIG_IP_VS_FTP=m
> > CONFIG_IP_VS_NFCT=y
> > CONFIG_IP_VS_PE_SIP=m
> > 
> > #
> > # IP: Netfilter Configuration
> > #
> > CONFIG_NF_DEFRAG_IPV4=m
> > CONFIG_NF_SOCKET_IPV4=m
> > CONFIG_NF_TPROXY_IPV4=m
> > CONFIG_NF_TABLES_IPV4=y
> > CONFIG_NFT_CHAIN_ROUTE_IPV4=m
> > CONFIG_NFT_REJECT_IPV4=m
> > CONFIG_NFT_DUP_IPV4=m
> > CONFIG_NFT_FIB_IPV4=m
> > CONFIG_NF_TABLES_ARP=y
> > CONFIG_NF_FLOW_TABLE_IPV4=m
> > CONFIG_NF_DUP_IPV4=m
> > CONFIG_NF_LOG_ARP=m
> > CONFIG_NF_LOG_IPV4=m
> > CONFIG_NF_REJECT_IPV4=m
> > CONFIG_NF_NAT_IPV4=m
> > CONFIG_NF_NAT_MASQUERADE_IPV4=y
> > CONFIG_NFT_CHAIN_NAT_IPV4=m
> > CONFIG_NFT_MASQ_IPV4=m
> > CONFIG_NFT_REDIR_IPV4=m
> > CONFIG_NF_NAT_SNMP_BASIC=m
> > CONFIG_NF_NAT_PROTO_GRE=m
> > CONFIG_NF_NAT_PPTP=m
> > CONFIG_NF_NAT_H323=m
> > CONFIG_IP_NF_IPTABLES=m
> > CONFIG_IP_NF_MATCH_AH=m
> > CONFIG_IP_NF_MATCH_ECN=m
> > CONFIG_IP_NF_MATCH_RPFILTER=m
> > CONFIG_IP_NF_MATCH_TTL=m
> > CONFIG_IP_NF_FILTER=m
> > CONFIG_IP_NF_TARGET_REJECT=m
> > CONFIG_IP_NF_TARGET_SYNPROXY=m
> > CONFIG_IP_NF_NAT=m
> > CONFIG_IP_NF_TARGET_MASQUERADE=m
> > CONFIG_IP_NF_TARGET_NETMAP=m
> > CONFIG_IP_NF_TARGET_REDIRECT=m
> > CONFIG_IP_NF_MANGLE=m
> > # CONFIG_IP_NF_TARGET_CLUSTERIP is not set
> > CONFIG_IP_NF_TARGET_ECN=m
> > CONFIG_IP_NF_TARGET_TTL=m
> > CONFIG_IP_NF_RAW=m
> > CONFIG_IP_NF_SECURITY=m
> > CONFIG_IP_NF_ARPTABLES=m
> > CONFIG_IP_NF_ARPFILTER=m
> > CONFIG_IP_NF_ARP_MANGLE=m
> > 
> > #
> > # IPv6: Netfilter Configuration
> > #
> > CONFIG_NF_SOCKET_IPV6=m
> > CONFIG_NF_TPROXY_IPV6=m
> > CONFIG_NF_TABLES_IPV6=y
> > CONFIG_NFT_CHAIN_ROUTE_IPV6=m
> > CONFIG_NFT_CHAIN_NAT_IPV6=m
> > CONFIG_NFT_MASQ_IPV6=m
> > CONFIG_NFT_REDIR_IPV6=m
> > CONFIG_NFT_REJECT_IPV6=m
> > CONFIG_NFT_DUP_IPV6=m
> > CONFIG_NFT_FIB_IPV6=m
> > CONFIG_NF_FLOW_TABLE_IPV6=m
> > CONFIG_NF_DUP_IPV6=m
> > CONFIG_NF_REJECT_IPV6=m
> > CONFIG_NF_LOG_IPV6=m
> > CONFIG_NF_NAT_IPV6=m
> > CONFIG_NF_NAT_MASQUERADE_IPV6=y
> > CONFIG_IP6_NF_IPTABLES=m
> > CONFIG_IP6_NF_MATCH_AH=m
> > CONFIG_IP6_NF_MATCH_EUI64=m
> > CONFIG_IP6_NF_MATCH_FRAG=m
> > CONFIG_IP6_NF_MATCH_OPTS=m
> > CONFIG_IP6_NF_MATCH_HL=m
> > CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> > CONFIG_IP6_NF_MATCH_MH=m
> > CONFIG_IP6_NF_MATCH_RPFILTER=m
> > CONFIG_IP6_NF_MATCH_RT=m
> > # CONFIG_IP6_NF_MATCH_SRH is not set
> > # CONFIG_IP6_NF_TARGET_HL is not set
> > CONFIG_IP6_NF_FILTER=m
> > CONFIG_IP6_NF_TARGET_REJECT=m
> > CONFIG_IP6_NF_TARGET_SYNPROXY=m
> > CONFIG_IP6_NF_MANGLE=m
> > CONFIG_IP6_NF_RAW=m
> > CONFIG_IP6_NF_SECURITY=m
> > CONFIG_IP6_NF_NAT=m
> > CONFIG_IP6_NF_TARGET_MASQUERADE=m
> > CONFIG_IP6_NF_TARGET_NPT=m
> > CONFIG_NF_DEFRAG_IPV6=m
> > CONFIG_NF_TABLES_BRIDGE=y
> > CONFIG_NFT_BRIDGE_REJECT=m
> > CONFIG_NF_LOG_BRIDGE=m
> > CONFIG_BRIDGE_NF_EBTABLES=m
> > CONFIG_BRIDGE_EBT_BROUTE=m
> > CONFIG_BRIDGE_EBT_T_FILTER=m
> > CONFIG_BRIDGE_EBT_T_NAT=m
> > CONFIG_BRIDGE_EBT_802_3=m
> > CONFIG_BRIDGE_EBT_AMONG=m
> > CONFIG_BRIDGE_EBT_ARP=m
> > CONFIG_BRIDGE_EBT_IP=m
> > CONFIG_BRIDGE_EBT_IP6=m
> > CONFIG_BRIDGE_EBT_LIMIT=m
> > CONFIG_BRIDGE_EBT_MARK=m
> > CONFIG_BRIDGE_EBT_PKTTYPE=m
> > CONFIG_BRIDGE_EBT_STP=m
> > CONFIG_BRIDGE_EBT_VLAN=m
> > CONFIG_BRIDGE_EBT_ARPREPLY=m
> > CONFIG_BRIDGE_EBT_DNAT=m
> > CONFIG_BRIDGE_EBT_MARK_T=m
> > CONFIG_BRIDGE_EBT_REDIRECT=m
> > CONFIG_BRIDGE_EBT_SNAT=m
> > CONFIG_BRIDGE_EBT_LOG=m
> > CONFIG_BRIDGE_EBT_NFLOG=m
> > # CONFIG_BPFILTER is not set
> > # CONFIG_IP_DCCP is not set
> > CONFIG_IP_SCTP=m
> > # CONFIG_SCTP_DBG_OBJCNT is not set
> > # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
> > CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
> > # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
> > CONFIG_SCTP_COOKIE_HMAC_MD5=y
> > CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> > CONFIG_INET_SCTP_DIAG=m
> > # CONFIG_RDS is not set
> > CONFIG_TIPC=m
> > CONFIG_TIPC_MEDIA_UDP=y
> > CONFIG_TIPC_DIAG=m
> > CONFIG_ATM=m
> > CONFIG_ATM_CLIP=m
> > # CONFIG_ATM_CLIP_NO_ICMP is not set
> > CONFIG_ATM_LANE=m
> > # CONFIG_ATM_MPOA is not set
> > CONFIG_ATM_BR2684=m
> > # CONFIG_ATM_BR2684_IPFILTER is not set
> > CONFIG_L2TP=m
> > CONFIG_L2TP_DEBUGFS=m
> > CONFIG_L2TP_V3=y
> > CONFIG_L2TP_IP=m
> > CONFIG_L2TP_ETH=m
> > CONFIG_STP=y
> > CONFIG_GARP=y
> > CONFIG_MRP=y
> > CONFIG_BRIDGE=y
> > CONFIG_BRIDGE_IGMP_SNOOPING=y
> > CONFIG_BRIDGE_VLAN_FILTERING=y
> > CONFIG_HAVE_NET_DSA=y
> > # CONFIG_NET_DSA is not set
> > CONFIG_VLAN_8021Q=y
> > CONFIG_VLAN_8021Q_GVRP=y
> > CONFIG_VLAN_8021Q_MVRP=y
> > # CONFIG_DECNET is not set
> > CONFIG_LLC=y
> > # CONFIG_LLC2 is not set
> > # CONFIG_ATALK is not set
> > # CONFIG_X25 is not set
> > # CONFIG_LAPB is not set
> > # CONFIG_PHONET is not set
> > CONFIG_6LOWPAN=m
> > # CONFIG_6LOWPAN_DEBUGFS is not set
> > # CONFIG_6LOWPAN_NHC is not set
> > CONFIG_IEEE802154=m
> > # CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
> > CONFIG_IEEE802154_SOCKET=m
> > CONFIG_IEEE802154_6LOWPAN=m
> > CONFIG_MAC802154=m
> > CONFIG_NET_SCHED=y
> > 
> > #
> > # Queueing/Scheduling
> > #
> > CONFIG_NET_SCH_CBQ=m
> > CONFIG_NET_SCH_HTB=m
> > CONFIG_NET_SCH_HFSC=m
> > CONFIG_NET_SCH_ATM=m
> > CONFIG_NET_SCH_PRIO=m
> > CONFIG_NET_SCH_MULTIQ=m
> > CONFIG_NET_SCH_RED=m
> > CONFIG_NET_SCH_SFB=m
> > CONFIG_NET_SCH_SFQ=m
> > CONFIG_NET_SCH_TEQL=m
> > CONFIG_NET_SCH_TBF=m
> > # CONFIG_NET_SCH_CBS is not set
> > CONFIG_NET_SCH_ETF=m
> > CONFIG_NET_SCH_GRED=m
> > CONFIG_NET_SCH_DSMARK=m
> > CONFIG_NET_SCH_NETEM=y
> > CONFIG_NET_SCH_DRR=m
> > CONFIG_NET_SCH_MQPRIO=m
> > # CONFIG_NET_SCH_SKBPRIO is not set
> > CONFIG_NET_SCH_CHOKE=m
> > CONFIG_NET_SCH_QFQ=m
> > CONFIG_NET_SCH_CODEL=m
> > CONFIG_NET_SCH_FQ_CODEL=y
> > # CONFIG_NET_SCH_CAKE is not set
> > CONFIG_NET_SCH_FQ=m
> > CONFIG_NET_SCH_HHF=m
> > CONFIG_NET_SCH_PIE=m
> > CONFIG_NET_SCH_INGRESS=y
> > CONFIG_NET_SCH_PLUG=m
> > CONFIG_NET_SCH_DEFAULT=y
> > # CONFIG_DEFAULT_FQ is not set
> > # CONFIG_DEFAULT_CODEL is not set
> > CONFIG_DEFAULT_FQ_CODEL=y
> > # CONFIG_DEFAULT_SFQ is not set
> > # CONFIG_DEFAULT_PFIFO_FAST is not set
> > CONFIG_DEFAULT_NET_SCH="fq_codel"
> > 
> > #
> > # Classification
> > #
> > CONFIG_NET_CLS=y
> > CONFIG_NET_CLS_BASIC=m
> > CONFIG_NET_CLS_TCINDEX=m
> > CONFIG_NET_CLS_ROUTE4=m
> > CONFIG_NET_CLS_FW=m
> > CONFIG_NET_CLS_U32=m
> > CONFIG_CLS_U32_PERF=y
> > CONFIG_CLS_U32_MARK=y
> > CONFIG_NET_CLS_RSVP=m
> > CONFIG_NET_CLS_RSVP6=m
> > CONFIG_NET_CLS_FLOW=m
> > CONFIG_NET_CLS_CGROUP=y
> > CONFIG_NET_CLS_BPF=m
> > CONFIG_NET_CLS_FLOWER=m
> > CONFIG_NET_CLS_MATCHALL=m
> > CONFIG_NET_EMATCH=y
> > CONFIG_NET_EMATCH_STACK=32
> > CONFIG_NET_EMATCH_CMP=m
> > CONFIG_NET_EMATCH_NBYTE=m
> > CONFIG_NET_EMATCH_U32=m
> > CONFIG_NET_EMATCH_META=m
> > CONFIG_NET_EMATCH_TEXT=m
> > CONFIG_NET_EMATCH_CANID=m
> > CONFIG_NET_EMATCH_IPSET=m
> > CONFIG_NET_EMATCH_IPT=m
> > CONFIG_NET_CLS_ACT=y
> > CONFIG_NET_ACT_POLICE=m
> > CONFIG_NET_ACT_GACT=m
> > CONFIG_GACT_PROB=y
> > CONFIG_NET_ACT_MIRRED=m
> > CONFIG_NET_ACT_SAMPLE=m
> > CONFIG_NET_ACT_IPT=m
> > CONFIG_NET_ACT_NAT=m
> > CONFIG_NET_ACT_PEDIT=m
> > CONFIG_NET_ACT_SIMP=m
> > CONFIG_NET_ACT_SKBEDIT=m
> > CONFIG_NET_ACT_CSUM=m
> > CONFIG_NET_ACT_VLAN=m
> > CONFIG_NET_ACT_BPF=m
> > CONFIG_NET_ACT_CONNMARK=m
> > CONFIG_NET_ACT_SKBMOD=m
> > CONFIG_NET_ACT_IFE=m
> > CONFIG_NET_ACT_TUNNEL_KEY=m
> > CONFIG_NET_IFE_SKBMARK=m
> > CONFIG_NET_IFE_SKBPRIO=m
> > CONFIG_NET_IFE_SKBTCINDEX=m
> > # CONFIG_NET_CLS_IND is not set
> > CONFIG_NET_SCH_FIFO=y
> > CONFIG_DCB=y
> > CONFIG_DNS_RESOLVER=m
> > # CONFIG_BATMAN_ADV is not set
> > CONFIG_OPENVSWITCH=m
> > CONFIG_OPENVSWITCH_GRE=m
> > CONFIG_OPENVSWITCH_VXLAN=m
> > CONFIG_OPENVSWITCH_GENEVE=m
> > CONFIG_VSOCKETS=m
> > CONFIG_VSOCKETS_DIAG=m
> > CONFIG_VMWARE_VMCI_VSOCKETS=m
> > CONFIG_VIRTIO_VSOCKETS=m
> > CONFIG_VIRTIO_VSOCKETS_COMMON=m
> > CONFIG_HYPERV_VSOCKETS=m
> > CONFIG_NETLINK_DIAG=m
> > CONFIG_MPLS=y
> > CONFIG_NET_MPLS_GSO=m
> > CONFIG_MPLS_ROUTING=m
> > CONFIG_MPLS_IPTUNNEL=m
> > CONFIG_NET_NSH=y
> > # CONFIG_HSR is not set
> > CONFIG_NET_SWITCHDEV=y
> > CONFIG_NET_L3_MASTER_DEV=y
> > # CONFIG_NET_NCSI is not set
> > CONFIG_RPS=y
> > CONFIG_RFS_ACCEL=y
> > CONFIG_XPS=y
> > CONFIG_CGROUP_NET_PRIO=y
> > CONFIG_CGROUP_NET_CLASSID=y
> > CONFIG_NET_RX_BUSY_POLL=y
> > CONFIG_BQL=y
> > CONFIG_BPF_JIT=y
> > CONFIG_BPF_STREAM_PARSER=y
> > CONFIG_NET_FLOW_LIMIT=y
> > 
> > #
> > # Network testing
> > #
> > CONFIG_NET_PKTGEN=m
> > CONFIG_NET_DROP_MONITOR=y
> > # CONFIG_HAMRADIO is not set
> > CONFIG_CAN=m
> > CONFIG_CAN_RAW=m
> > CONFIG_CAN_BCM=m
> > CONFIG_CAN_GW=m
> > 
> > #
> > # CAN Device Drivers
> > #
> > CONFIG_CAN_VCAN=m
> > # CONFIG_CAN_VXCAN is not set
> > CONFIG_CAN_SLCAN=m
> > CONFIG_CAN_DEV=m
> > CONFIG_CAN_CALC_BITTIMING=y
> > CONFIG_CAN_C_CAN=m
> > CONFIG_CAN_C_CAN_PLATFORM=m
> > CONFIG_CAN_C_CAN_PCI=m
> > CONFIG_CAN_CC770=m
> > # CONFIG_CAN_CC770_ISA is not set
> > CONFIG_CAN_CC770_PLATFORM=m
> > # CONFIG_CAN_IFI_CANFD is not set
> > # CONFIG_CAN_M_CAN is not set
> > # CONFIG_CAN_PEAK_PCIEFD is not set
> > CONFIG_CAN_SJA1000=m
> > # CONFIG_CAN_SJA1000_ISA is not set
> > CONFIG_CAN_SJA1000_PLATFORM=m
> > CONFIG_CAN_EMS_PCI=m
> > CONFIG_CAN_PEAK_PCI=m
> > CONFIG_CAN_PEAK_PCIEC=y
> > CONFIG_CAN_KVASER_PCI=m
> > CONFIG_CAN_PLX_PCI=m
> > CONFIG_CAN_SOFTING=m
> > 
> > #
> > # CAN SPI interfaces
> > #
> > # CONFIG_CAN_HI311X is not set
> > # CONFIG_CAN_MCP251X is not set
> > 
> > #
> > # CAN USB interfaces
> > #
> > # CONFIG_CAN_8DEV_USB is not set
> > # CONFIG_CAN_EMS_USB is not set
> > # CONFIG_CAN_ESD_USB2 is not set
> > # CONFIG_CAN_GS_USB is not set
> > # CONFIG_CAN_KVASER_USB is not set
> > # CONFIG_CAN_MCBA_USB is not set
> > # CONFIG_CAN_PEAK_USB is not set
> > # CONFIG_CAN_UCAN is not set
> > # CONFIG_CAN_DEBUG_DEVICES is not set
> > CONFIG_BT=m
> > CONFIG_BT_BREDR=y
> > CONFIG_BT_RFCOMM=m
> > CONFIG_BT_RFCOMM_TTY=y
> > CONFIG_BT_BNEP=m
> > CONFIG_BT_BNEP_MC_FILTER=y
> > CONFIG_BT_BNEP_PROTO_FILTER=y
> > CONFIG_BT_HIDP=m
> > CONFIG_BT_HS=y
> > CONFIG_BT_LE=y
> > # CONFIG_BT_6LOWPAN is not set
> > # CONFIG_BT_LEDS is not set
> > # CONFIG_BT_SELFTEST is not set
> > CONFIG_BT_DEBUGFS=y
> > 
> > #
> > # Bluetooth device drivers
> > #
> > # CONFIG_BT_HCIBTUSB is not set
> > # CONFIG_BT_HCIBTSDIO is not set
> > CONFIG_BT_HCIUART=m
> > CONFIG_BT_HCIUART_H4=y
> > CONFIG_BT_HCIUART_BCSP=y
> > CONFIG_BT_HCIUART_ATH3K=y
> > # CONFIG_BT_HCIUART_INTEL is not set
> > # CONFIG_BT_HCIUART_AG6XX is not set
> > # CONFIG_BT_HCIUART_MRVL is not set
> > # CONFIG_BT_HCIBCM203X is not set
> > # CONFIG_BT_HCIBPA10X is not set
> > # CONFIG_BT_HCIBFUSB is not set
> > CONFIG_BT_HCIVHCI=m
> > CONFIG_BT_MRVL=m
> > # CONFIG_BT_MRVL_SDIO is not set
> > # CONFIG_AF_RXRPC is not set
> > # CONFIG_AF_KCM is not set
> > CONFIG_STREAM_PARSER=y
> > CONFIG_FIB_RULES=y
> > CONFIG_WIRELESS=y
> > CONFIG_CFG80211=m
> > # CONFIG_NL80211_TESTMODE is not set
> > # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> > # CONFIG_CFG80211_CERTIFICATION_ONUS is not set
> > CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
> > CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
> > CONFIG_CFG80211_DEFAULT_PS=y
> > # CONFIG_CFG80211_DEBUGFS is not set
> > CONFIG_CFG80211_CRDA_SUPPORT=y
> > # CONFIG_CFG80211_WEXT is not set
> > CONFIG_MAC80211=m
> > CONFIG_MAC80211_HAS_RC=y
> > CONFIG_MAC80211_RC_MINSTREL=y
> > CONFIG_MAC80211_RC_MINSTREL_HT=y
> > # CONFIG_MAC80211_RC_MINSTREL_VHT is not set
> > CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> > CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> > # CONFIG_MAC80211_MESH is not set
> > CONFIG_MAC80211_LEDS=y
> > CONFIG_MAC80211_DEBUGFS=y
> > # CONFIG_MAC80211_MESSAGE_TRACING is not set
> > # CONFIG_MAC80211_DEBUG_MENU is not set
> > CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
> > # CONFIG_WIMAX is not set
> > CONFIG_RFKILL=m
> > CONFIG_RFKILL_LEDS=y
> > CONFIG_RFKILL_INPUT=y
> > # CONFIG_RFKILL_GPIO is not set
> > CONFIG_NET_9P=y
> > CONFIG_NET_9P_VIRTIO=y
> > # CONFIG_NET_9P_XEN is not set
> > # CONFIG_NET_9P_DEBUG is not set
> > # CONFIG_CAIF is not set
> > CONFIG_CEPH_LIB=m
> > # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
> > CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
> > # CONFIG_NFC is not set
> > CONFIG_PSAMPLE=m
> > CONFIG_NET_IFE=m
> > CONFIG_LWTUNNEL=y
> > CONFIG_LWTUNNEL_BPF=y
> > CONFIG_DST_CACHE=y
> > CONFIG_GRO_CELLS=y
> > CONFIG_SOCK_VALIDATE_XMIT=y
> > CONFIG_NET_DEVLINK=y
> > CONFIG_MAY_USE_DEVLINK=y
> > CONFIG_FAILOVER=m
> > CONFIG_HAVE_EBPF_JIT=y
> > 
> > #
> > # Device Drivers
> > #
> > 
> > #
> > # Generic Driver Options
> > #
> > # CONFIG_UEVENT_HELPER is not set
> > CONFIG_DEVTMPFS=y
> > CONFIG_DEVTMPFS_MOUNT=y
> > CONFIG_STANDALONE=y
> > CONFIG_PREVENT_FIRMWARE_BUILD=y
> > 
> > #
> > # Firmware loader
> > #
> > CONFIG_FW_LOADER=y
> > CONFIG_EXTRA_FIRMWARE=""
> > CONFIG_FW_LOADER_USER_HELPER=y
> > # CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
> > CONFIG_ALLOW_DEV_COREDUMP=y
> > # CONFIG_DEBUG_DRIVER is not set
> > # CONFIG_DEBUG_DEVRES is not set
> > # CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
> > # CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
> > CONFIG_SYS_HYPERVISOR=y
> > CONFIG_GENERIC_CPU_AUTOPROBE=y
> > CONFIG_GENERIC_CPU_VULNERABILITIES=y
> > CONFIG_REGMAP=y
> > CONFIG_REGMAP_I2C=y
> > CONFIG_REGMAP_SPI=y
> > CONFIG_DMA_SHARED_BUFFER=y
> > # CONFIG_DMA_FENCE_TRACE is not set
> > 
> > #
> > # Bus devices
> > #
> > CONFIG_CONNECTOR=y
> > CONFIG_PROC_EVENTS=y
> > # CONFIG_GNSS is not set
> > # CONFIG_MTD is not set
> > # CONFIG_OF is not set
> > CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> > CONFIG_PARPORT=m
> > CONFIG_PARPORT_PC=m
> > CONFIG_PARPORT_SERIAL=m
> > # CONFIG_PARPORT_PC_FIFO is not set
> > # CONFIG_PARPORT_PC_SUPERIO is not set
> > # CONFIG_PARPORT_AX88796 is not set
> > CONFIG_PARPORT_1284=y
> > CONFIG_PNP=y
> > # CONFIG_PNP_DEBUG_MESSAGES is not set
> > 
> > #
> > # Protocols
> > #
> > CONFIG_PNPACPI=y
> > CONFIG_BLK_DEV=y
> > CONFIG_BLK_DEV_NULL_BLK=m
> > # CONFIG_BLK_DEV_FD is not set
> > CONFIG_CDROM=m
> > # CONFIG_PARIDE is not set
> > # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> > CONFIG_ZRAM=m
> > CONFIG_ZRAM_WRITEBACK=y
> > # CONFIG_ZRAM_MEMORY_TRACKING is not set
> > # CONFIG_BLK_DEV_DAC960 is not set
> > # CONFIG_BLK_DEV_UMEM is not set
> > CONFIG_BLK_DEV_LOOP=m
> > CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
> > # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> > # CONFIG_BLK_DEV_DRBD is not set
> > CONFIG_BLK_DEV_NBD=m
> > # CONFIG_BLK_DEV_SKD is not set
> > # CONFIG_BLK_DEV_SX8 is not set
> > CONFIG_BLK_DEV_RAM=m
> > CONFIG_BLK_DEV_RAM_COUNT=16
> > CONFIG_BLK_DEV_RAM_SIZE=16384
> > CONFIG_CDROM_PKTCDVD=m
> > CONFIG_CDROM_PKTCDVD_BUFFERS=8
> > # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> > # CONFIG_ATA_OVER_ETH is not set
> > CONFIG_XEN_BLKDEV_FRONTEND=m
> > CONFIG_VIRTIO_BLK=m
> > # CONFIG_VIRTIO_BLK_SCSI is not set
> > CONFIG_BLK_DEV_RBD=m
> > # CONFIG_BLK_DEV_RSXX is not set
> > 
> > #
> > # NVME Support
> > #
> > CONFIG_NVME_CORE=m
> > CONFIG_BLK_DEV_NVME=m
> > CONFIG_NVME_MULTIPATH=y
> > CONFIG_NVME_FABRICS=m
> > CONFIG_NVME_FC=m
> > CONFIG_NVME_TARGET=m
> > CONFIG_NVME_TARGET_LOOP=m
> > CONFIG_NVME_TARGET_FC=m
> > CONFIG_NVME_TARGET_FCLOOP=m
> > 
> > #
> > # Misc devices
> > #
> > CONFIG_SENSORS_LIS3LV02D=m
> > # CONFIG_AD525X_DPOT is not set
> > # CONFIG_DUMMY_IRQ is not set
> > # CONFIG_IBM_ASM is not set
> > # CONFIG_PHANTOM is not set
> > CONFIG_SGI_IOC4=m
> > CONFIG_TIFM_CORE=m
> > CONFIG_TIFM_7XX1=m
> > # CONFIG_ICS932S401 is not set
> > CONFIG_ENCLOSURE_SERVICES=m
> > CONFIG_SGI_XP=m
> > CONFIG_HP_ILO=m
> > CONFIG_SGI_GRU=m
> > # CONFIG_SGI_GRU_DEBUG is not set
> > CONFIG_APDS9802ALS=m
> > CONFIG_ISL29003=m
> > CONFIG_ISL29020=m
> > CONFIG_SENSORS_TSL2550=m
> > CONFIG_SENSORS_BH1770=m
> > CONFIG_SENSORS_APDS990X=m
> > # CONFIG_HMC6352 is not set
> > # CONFIG_DS1682 is not set
> > CONFIG_VMWARE_BALLOON=m
> > # CONFIG_USB_SWITCH_FSA9480 is not set
> > # CONFIG_LATTICE_ECP3_CONFIG is not set
> > # CONFIG_SRAM is not set
> > # CONFIG_PCI_ENDPOINT_TEST is not set
> > CONFIG_MISC_RTSX=m
> > # CONFIG_C2PORT is not set
> > 
> > #
> > # EEPROM support
> > #
> > # CONFIG_EEPROM_AT24 is not set
> > # CONFIG_EEPROM_AT25 is not set
> > CONFIG_EEPROM_LEGACY=m
> > CONFIG_EEPROM_MAX6875=m
> > CONFIG_EEPROM_93CX6=m
> > # CONFIG_EEPROM_93XX46 is not set
> > # CONFIG_EEPROM_IDT_89HPESX is not set
> > CONFIG_CB710_CORE=m
> > # CONFIG_CB710_DEBUG is not set
> > CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> > 
> > #
> > # Texas Instruments shared transport line discipline
> > #
> > # CONFIG_TI_ST is not set
> > CONFIG_SENSORS_LIS3_I2C=m
> > CONFIG_ALTERA_STAPL=m
> > CONFIG_INTEL_MEI=m
> > CONFIG_INTEL_MEI_ME=m
> > # CONFIG_INTEL_MEI_TXE is not set
> > CONFIG_VMWARE_VMCI=m
> > 
> > #
> > # Intel MIC & related support
> > #
> > 
> > #
> > # Intel MIC Bus Driver
> > #
> > # CONFIG_INTEL_MIC_BUS is not set
> > 
> > #
> > # SCIF Bus Driver
> > #
> > # CONFIG_SCIF_BUS is not set
> > 
> > #
> > # VOP Bus Driver
> > #
> > # CONFIG_VOP_BUS is not set
> > 
> > #
> > # Intel MIC Host Driver
> > #
> > 
> > #
> > # Intel MIC Card Driver
> > #
> > 
> > #
> > # SCIF Driver
> > #
> > 
> > #
> > # Intel MIC Coprocessor State Management (COSM) Drivers
> > #
> > 
> > #
> > # VOP Driver
> > #
> > # CONFIG_GENWQE is not set
> > # CONFIG_ECHO is not set
> > CONFIG_MISC_RTSX_PCI=m
> > # CONFIG_MISC_RTSX_USB is not set
> > CONFIG_HAVE_IDE=y
> > # CONFIG_IDE is not set
> > 
> > #
> > # SCSI device support
> > #
> > CONFIG_SCSI_MOD=y
> > CONFIG_RAID_ATTRS=m
> > CONFIG_SCSI=y
> > CONFIG_SCSI_DMA=y
> > CONFIG_SCSI_NETLINK=y
> > # CONFIG_SCSI_MQ_DEFAULT is not set
> > CONFIG_SCSI_PROC_FS=y
> > 
> > #
> > # SCSI support type (disk, tape, CD-ROM)
> > #
> > CONFIG_BLK_DEV_SD=m
> > CONFIG_CHR_DEV_ST=m
> > # CONFIG_CHR_DEV_OSST is not set
> > CONFIG_BLK_DEV_SR=m
> > CONFIG_BLK_DEV_SR_VENDOR=y
> > CONFIG_CHR_DEV_SG=m
> > CONFIG_CHR_DEV_SCH=m
> > CONFIG_SCSI_ENCLOSURE=m
> > CONFIG_SCSI_CONSTANTS=y
> > CONFIG_SCSI_LOGGING=y
> > CONFIG_SCSI_SCAN_ASYNC=y
> > 
> > #
> > # SCSI Transports
> > #
> > CONFIG_SCSI_SPI_ATTRS=m
> > CONFIG_SCSI_FC_ATTRS=m
> > CONFIG_SCSI_ISCSI_ATTRS=m
> > CONFIG_SCSI_SAS_ATTRS=m
> > CONFIG_SCSI_SAS_LIBSAS=m
> > CONFIG_SCSI_SAS_ATA=y
> > CONFIG_SCSI_SAS_HOST_SMP=y
> > CONFIG_SCSI_SRP_ATTRS=m
> > CONFIG_SCSI_LOWLEVEL=y
> > # CONFIG_ISCSI_TCP is not set
> > # CONFIG_ISCSI_BOOT_SYSFS is not set
> > # CONFIG_SCSI_CXGB3_ISCSI is not set
> > # CONFIG_SCSI_CXGB4_ISCSI is not set
> > # CONFIG_SCSI_BNX2_ISCSI is not set
> > # CONFIG_BE2ISCSI is not set
> > # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> > # CONFIG_SCSI_HPSA is not set
> > # CONFIG_SCSI_3W_9XXX is not set
> > # CONFIG_SCSI_3W_SAS is not set
> > # CONFIG_SCSI_ACARD is not set
> > # CONFIG_SCSI_AACRAID is not set
> > # CONFIG_SCSI_AIC7XXX is not set
> > # CONFIG_SCSI_AIC79XX is not set
> > # CONFIG_SCSI_AIC94XX is not set
> > # CONFIG_SCSI_MVSAS is not set
> > # CONFIG_SCSI_MVUMI is not set
> > # CONFIG_SCSI_DPT_I2O is not set
> > # CONFIG_SCSI_ADVANSYS is not set
> > # CONFIG_SCSI_ARCMSR is not set
> > # CONFIG_SCSI_ESAS2R is not set
> > # CONFIG_MEGARAID_NEWGEN is not set
> > # CONFIG_MEGARAID_LEGACY is not set
> > # CONFIG_MEGARAID_SAS is not set
> > CONFIG_SCSI_MPT3SAS=m
> > CONFIG_SCSI_MPT2SAS_MAX_SGE=128
> > CONFIG_SCSI_MPT3SAS_MAX_SGE=128
> > # CONFIG_SCSI_MPT2SAS is not set
> > # CONFIG_SCSI_SMARTPQI is not set
> > # CONFIG_SCSI_UFSHCD is not set
> > # CONFIG_SCSI_HPTIOP is not set
> > # CONFIG_SCSI_BUSLOGIC is not set
> > # CONFIG_VMWARE_PVSCSI is not set
> > # CONFIG_XEN_SCSI_FRONTEND is not set
> > CONFIG_HYPERV_STORAGE=m
> > # CONFIG_LIBFC is not set
> > # CONFIG_SCSI_SNIC is not set
> > # CONFIG_SCSI_DMX3191D is not set
> > # CONFIG_SCSI_GDTH is not set
> > CONFIG_SCSI_ISCI=m
> > # CONFIG_SCSI_IPS is not set
> > # CONFIG_SCSI_INITIO is not set
> > # CONFIG_SCSI_INIA100 is not set
> > # CONFIG_SCSI_PPA is not set
> > # CONFIG_SCSI_IMM is not set
> > # CONFIG_SCSI_STEX is not set
> > # CONFIG_SCSI_SYM53C8XX_2 is not set
> > # CONFIG_SCSI_IPR is not set
> > # CONFIG_SCSI_QLOGIC_1280 is not set
> > # CONFIG_SCSI_QLA_FC is not set
> > # CONFIG_SCSI_QLA_ISCSI is not set
> > # CONFIG_SCSI_LPFC is not set
> > # CONFIG_SCSI_DC395x is not set
> > # CONFIG_SCSI_AM53C974 is not set
> > # CONFIG_SCSI_WD719X is not set
> > # CONFIG_SCSI_DEBUG is not set
> > # CONFIG_SCSI_PMCRAID is not set
> > # CONFIG_SCSI_PM8001 is not set
> > # CONFIG_SCSI_BFA_FC is not set
> > # CONFIG_SCSI_VIRTIO is not set
> > # CONFIG_SCSI_CHELSIO_FCOE is not set
> > CONFIG_SCSI_DH=y
> > CONFIG_SCSI_DH_RDAC=y
> > CONFIG_SCSI_DH_HP_SW=y
> > CONFIG_SCSI_DH_EMC=y
> > CONFIG_SCSI_DH_ALUA=y
> > # CONFIG_SCSI_OSD_INITIATOR is not set
> > CONFIG_ATA=m
> > CONFIG_ATA_VERBOSE_ERROR=y
> > CONFIG_ATA_ACPI=y
> > # CONFIG_SATA_ZPODD is not set
> > CONFIG_SATA_PMP=y
> > 
> > #
> > # Controllers with non-SFF native interface
> > #
> > CONFIG_SATA_AHCI=m
> > CONFIG_SATA_MOBILE_LPM_POLICY=0
> > CONFIG_SATA_AHCI_PLATFORM=m
> > # CONFIG_SATA_INIC162X is not set
> > # CONFIG_SATA_ACARD_AHCI is not set
> > # CONFIG_SATA_SIL24 is not set
> > CONFIG_ATA_SFF=y
> > 
> > #
> > # SFF controllers with custom DMA interface
> > #
> > # CONFIG_PDC_ADMA is not set
> > # CONFIG_SATA_QSTOR is not set
> > # CONFIG_SATA_SX4 is not set
> > CONFIG_ATA_BMDMA=y
> > 
> > #
> > # SATA SFF controllers with BMDMA
> > #
> > CONFIG_ATA_PIIX=m
> > # CONFIG_SATA_DWC is not set
> > # CONFIG_SATA_MV is not set
> > # CONFIG_SATA_NV is not set
> > # CONFIG_SATA_PROMISE is not set
> > # CONFIG_SATA_SIL is not set
> > # CONFIG_SATA_SIS is not set
> > # CONFIG_SATA_SVW is not set
> > # CONFIG_SATA_ULI is not set
> > # CONFIG_SATA_VIA is not set
> > # CONFIG_SATA_VITESSE is not set
> > 
> > #
> > # PATA SFF controllers with BMDMA
> > #
> > # CONFIG_PATA_ALI is not set
> > # CONFIG_PATA_AMD is not set
> > # CONFIG_PATA_ARTOP is not set
> > # CONFIG_PATA_ATIIXP is not set
> > # CONFIG_PATA_ATP867X is not set
> > # CONFIG_PATA_CMD64X is not set
> > # CONFIG_PATA_CYPRESS is not set
> > # CONFIG_PATA_EFAR is not set
> > # CONFIG_PATA_HPT366 is not set
> > # CONFIG_PATA_HPT37X is not set
> > # CONFIG_PATA_HPT3X2N is not set
> > # CONFIG_PATA_HPT3X3 is not set
> > # CONFIG_PATA_IT8213 is not set
> > # CONFIG_PATA_IT821X is not set
> > # CONFIG_PATA_JMICRON is not set
> > # CONFIG_PATA_MARVELL is not set
> > # CONFIG_PATA_NETCELL is not set
> > # CONFIG_PATA_NINJA32 is not set
> > # CONFIG_PATA_NS87415 is not set
> > # CONFIG_PATA_OLDPIIX is not set
> > # CONFIG_PATA_OPTIDMA is not set
> > # CONFIG_PATA_PDC2027X is not set
> > # CONFIG_PATA_PDC_OLD is not set
> > # CONFIG_PATA_RADISYS is not set
> > # CONFIG_PATA_RDC is not set
> > # CONFIG_PATA_SCH is not set
> > # CONFIG_PATA_SERVERWORKS is not set
> > # CONFIG_PATA_SIL680 is not set
> > # CONFIG_PATA_SIS is not set
> > # CONFIG_PATA_TOSHIBA is not set
> > # CONFIG_PATA_TRIFLEX is not set
> > # CONFIG_PATA_VIA is not set
> > # CONFIG_PATA_WINBOND is not set
> > 
> > #
> > # PIO-only SFF controllers
> > #
> > # CONFIG_PATA_CMD640_PCI is not set
> > # CONFIG_PATA_MPIIX is not set
> > # CONFIG_PATA_NS87410 is not set
> > # CONFIG_PATA_OPTI is not set
> > # CONFIG_PATA_PLATFORM is not set
> > # CONFIG_PATA_RZ1000 is not set
> > 
> > #
> > # Generic fallback / legacy drivers
> > #
> > # CONFIG_PATA_ACPI is not set
> > CONFIG_ATA_GENERIC=m
> > # CONFIG_PATA_LEGACY is not set
> > CONFIG_MD=y
> > CONFIG_BLK_DEV_MD=y
> > CONFIG_MD_AUTODETECT=y
> > CONFIG_MD_LINEAR=m
> > CONFIG_MD_RAID0=m
> > CONFIG_MD_RAID1=m
> > CONFIG_MD_RAID10=m
> > CONFIG_MD_RAID456=m
> > # CONFIG_MD_MULTIPATH is not set
> > CONFIG_MD_FAULTY=m
> > CONFIG_MD_CLUSTER=m
> > # CONFIG_BCACHE is not set
> > CONFIG_BLK_DEV_DM_BUILTIN=y
> > CONFIG_BLK_DEV_DM=m
> > # CONFIG_DM_MQ_DEFAULT is not set
> > CONFIG_DM_DEBUG=y
> > CONFIG_DM_BUFIO=m
> > # CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
> > CONFIG_DM_BIO_PRISON=m
> > CONFIG_DM_PERSISTENT_DATA=m
> > # CONFIG_DM_UNSTRIPED is not set
> > CONFIG_DM_CRYPT=m
> > CONFIG_DM_SNAPSHOT=m
> > CONFIG_DM_THIN_PROVISIONING=m
> > CONFIG_DM_CACHE=m
> > CONFIG_DM_CACHE_SMQ=m
> > CONFIG_DM_WRITECACHE=m
> > CONFIG_DM_ERA=m
> > CONFIG_DM_MIRROR=m
> > CONFIG_DM_LOG_USERSPACE=m
> > CONFIG_DM_RAID=m
> > CONFIG_DM_ZERO=m
> > CONFIG_DM_MULTIPATH=m
> > CONFIG_DM_MULTIPATH_QL=m
> > CONFIG_DM_MULTIPATH_ST=m
> > CONFIG_DM_DELAY=m
> > CONFIG_DM_UEVENT=y
> > CONFIG_DM_FLAKEY=m
> > CONFIG_DM_VERITY=m
> > # CONFIG_DM_VERITY_FEC is not set
> > CONFIG_DM_SWITCH=m
> > CONFIG_DM_LOG_WRITES=m
> > CONFIG_DM_INTEGRITY=m
> > CONFIG_TARGET_CORE=m
> > CONFIG_TCM_IBLOCK=m
> > CONFIG_TCM_FILEIO=m
> > CONFIG_TCM_PSCSI=m
> > CONFIG_TCM_USER2=m
> > CONFIG_LOOPBACK_TARGET=m
> > CONFIG_ISCSI_TARGET=m
> > # CONFIG_SBP_TARGET is not set
> > # CONFIG_FUSION is not set
> > 
> > #
> > # IEEE 1394 (FireWire) support
> > #
> > CONFIG_FIREWIRE=m
> > CONFIG_FIREWIRE_OHCI=m
> > CONFIG_FIREWIRE_SBP2=m
> > CONFIG_FIREWIRE_NET=m
> > # CONFIG_FIREWIRE_NOSY is not set
> > CONFIG_MACINTOSH_DRIVERS=y
> > CONFIG_MAC_EMUMOUSEBTN=y
> > CONFIG_NETDEVICES=y
> > CONFIG_MII=y
> > CONFIG_NET_CORE=y
> > # CONFIG_BONDING is not set
> > CONFIG_DUMMY=y
> > # CONFIG_EQUALIZER is not set
> > # CONFIG_NET_FC is not set
> > CONFIG_IFB=y
> > # CONFIG_NET_TEAM is not set
> > # CONFIG_MACVLAN is not set
> > # CONFIG_IPVLAN is not set
> > CONFIG_VXLAN=y
> > CONFIG_GENEVE=y
> > # CONFIG_GTP is not set
> > CONFIG_MACSEC=y
> > CONFIG_NETCONSOLE=m
> > CONFIG_NETCONSOLE_DYNAMIC=y
> > CONFIG_NETPOLL=y
> > CONFIG_NET_POLL_CONTROLLER=y
> > CONFIG_TUN=m
> > # CONFIG_TUN_VNET_CROSS_LE is not set
> > CONFIG_VETH=y
> > CONFIG_VIRTIO_NET=m
> > # CONFIG_NLMON is not set
> > CONFIG_NET_VRF=y
> > # CONFIG_VSOCKMON is not set
> > # CONFIG_ARCNET is not set
> > CONFIG_ATM_DRIVERS=y
> > # CONFIG_ATM_DUMMY is not set
> > # CONFIG_ATM_TCP is not set
> > # CONFIG_ATM_LANAI is not set
> > # CONFIG_ATM_ENI is not set
> > # CONFIG_ATM_FIRESTREAM is not set
> > # CONFIG_ATM_ZATM is not set
> > # CONFIG_ATM_NICSTAR is not set
> > # CONFIG_ATM_IDT77252 is not set
> > # CONFIG_ATM_AMBASSADOR is not set
> > # CONFIG_ATM_HORIZON is not set
> > # CONFIG_ATM_IA is not set
> > # CONFIG_ATM_FORE200E is not set
> > # CONFIG_ATM_HE is not set
> > # CONFIG_ATM_SOLOS is not set
> > 
> > #
> > # CAIF transport drivers
> > #
> > 
> > #
> > # Distributed Switch Architecture drivers
> > #
> > CONFIG_ETHERNET=y
> > CONFIG_MDIO=y
> > CONFIG_NET_VENDOR_3COM=y
> > # CONFIG_VORTEX is not set
> > # CONFIG_TYPHOON is not set
> > CONFIG_NET_VENDOR_ADAPTEC=y
> > # CONFIG_ADAPTEC_STARFIRE is not set
> > CONFIG_NET_VENDOR_AGERE=y
> > # CONFIG_ET131X is not set
> > CONFIG_NET_VENDOR_ALACRITECH=y
> > # CONFIG_SLICOSS is not set
> > CONFIG_NET_VENDOR_ALTEON=y
> > # CONFIG_ACENIC is not set
> > # CONFIG_ALTERA_TSE is not set
> > CONFIG_NET_VENDOR_AMAZON=y
> > # CONFIG_ENA_ETHERNET is not set
> > CONFIG_NET_VENDOR_AMD=y
> > # CONFIG_AMD8111_ETH is not set
> > # CONFIG_PCNET32 is not set
> > # CONFIG_AMD_XGBE is not set
> > CONFIG_NET_VENDOR_AQUANTIA=y
> > # CONFIG_AQTION is not set
> > CONFIG_NET_VENDOR_ARC=y
> > CONFIG_NET_VENDOR_ATHEROS=y
> > # CONFIG_ATL2 is not set
> > # CONFIG_ATL1 is not set
> > # CONFIG_ATL1E is not set
> > # CONFIG_ATL1C is not set
> > # CONFIG_ALX is not set
> > # CONFIG_NET_VENDOR_AURORA is not set
> > CONFIG_NET_VENDOR_BROADCOM=y
> > # CONFIG_B44 is not set
> > # CONFIG_BCMGENET is not set
> > # CONFIG_BNX2 is not set
> > # CONFIG_CNIC is not set
> > # CONFIG_TIGON3 is not set
> > # CONFIG_BNX2X is not set
> > # CONFIG_SYSTEMPORT is not set
> > # CONFIG_BNXT is not set
> > CONFIG_NET_VENDOR_BROCADE=y
> > # CONFIG_BNA is not set
> > CONFIG_NET_VENDOR_CADENCE=y
> > # CONFIG_MACB is not set
> > CONFIG_NET_VENDOR_CAVIUM=y
> > # CONFIG_THUNDER_NIC_PF is not set
> > # CONFIG_THUNDER_NIC_VF is not set
> > # CONFIG_THUNDER_NIC_BGX is not set
> > # CONFIG_THUNDER_NIC_RGX is not set
> > CONFIG_CAVIUM_PTP=y
> > # CONFIG_LIQUIDIO is not set
> > # CONFIG_LIQUIDIO_VF is not set
> > CONFIG_NET_VENDOR_CHELSIO=y
> > # CONFIG_CHELSIO_T1 is not set
> > # CONFIG_CHELSIO_T3 is not set
> > # CONFIG_CHELSIO_T4 is not set
> > # CONFIG_CHELSIO_T4VF is not set
> > CONFIG_NET_VENDOR_CISCO=y
> > # CONFIG_ENIC is not set
> > CONFIG_NET_VENDOR_CORTINA=y
> > # CONFIG_CX_ECAT is not set
> > # CONFIG_DNET is not set
> > CONFIG_NET_VENDOR_DEC=y
> > # CONFIG_NET_TULIP is not set
> > CONFIG_NET_VENDOR_DLINK=y
> > # CONFIG_DL2K is not set
> > # CONFIG_SUNDANCE is not set
> > CONFIG_NET_VENDOR_EMULEX=y
> > # CONFIG_BE2NET is not set
> > CONFIG_NET_VENDOR_EZCHIP=y
> > CONFIG_NET_VENDOR_HP=y
> > # CONFIG_HP100 is not set
> > CONFIG_NET_VENDOR_HUAWEI=y
> > # CONFIG_HINIC is not set
> > CONFIG_NET_VENDOR_I825XX=y
> > CONFIG_NET_VENDOR_INTEL=y
> > # CONFIG_E100 is not set
> > CONFIG_E1000=y
> > CONFIG_E1000E=y
> > CONFIG_E1000E_HWTS=y
> > CONFIG_IGB=y
> > CONFIG_IGB_HWMON=y
> > # CONFIG_IGBVF is not set
> > # CONFIG_IXGB is not set
> > CONFIG_IXGBE=y
> > CONFIG_IXGBE_HWMON=y
> > # CONFIG_IXGBE_DCB is not set
> > # CONFIG_IXGBEVF is not set
> > CONFIG_I40E=y
> > # CONFIG_I40E_DCB is not set
> > # CONFIG_I40EVF is not set
> > # CONFIG_ICE is not set
> > # CONFIG_FM10K is not set
> > # CONFIG_JME is not set
> > CONFIG_NET_VENDOR_MARVELL=y
> > # CONFIG_MVMDIO is not set
> > # CONFIG_SKGE is not set
> > # CONFIG_SKY2 is not set
> > CONFIG_NET_VENDOR_MELLANOX=y
> > # CONFIG_MLX4_EN is not set
> > # CONFIG_MLX5_CORE is not set
> > # CONFIG_MLXSW_CORE is not set
> > # CONFIG_MLXFW is not set
> > CONFIG_NET_VENDOR_MICREL=y
> > # CONFIG_KS8842 is not set
> > # CONFIG_KS8851 is not set
> > # CONFIG_KS8851_MLL is not set
> > # CONFIG_KSZ884X_PCI is not set
> > CONFIG_NET_VENDOR_MICROCHIP=y
> > # CONFIG_ENC28J60 is not set
> > # CONFIG_ENCX24J600 is not set
> > # CONFIG_LAN743X is not set
> > CONFIG_NET_VENDOR_MICROSEMI=y
> > # CONFIG_MSCC_OCELOT_SWITCH is not set
> > CONFIG_NET_VENDOR_MYRI=y
> > # CONFIG_MYRI10GE is not set
> > # CONFIG_FEALNX is not set
> > CONFIG_NET_VENDOR_NATSEMI=y
> > # CONFIG_NATSEMI is not set
> > # CONFIG_NS83820 is not set
> > CONFIG_NET_VENDOR_NETERION=y
> > # CONFIG_S2IO is not set
> > # CONFIG_VXGE is not set
> > CONFIG_NET_VENDOR_NETRONOME=y
> > # CONFIG_NFP is not set
> > CONFIG_NET_VENDOR_NI=y
> > CONFIG_NET_VENDOR_8390=y
> > # CONFIG_NE2K_PCI is not set
> > CONFIG_NET_VENDOR_NVIDIA=y
> > # CONFIG_FORCEDETH is not set
> > CONFIG_NET_VENDOR_OKI=y
> > # CONFIG_ETHOC is not set
> > CONFIG_NET_VENDOR_PACKET_ENGINES=y
> > # CONFIG_HAMACHI is not set
> > # CONFIG_YELLOWFIN is not set
> > CONFIG_NET_VENDOR_QLOGIC=y
> > # CONFIG_QLA3XXX is not set
> > # CONFIG_QLCNIC is not set
> > # CONFIG_QLGE is not set
> > # CONFIG_NETXEN_NIC is not set
> > # CONFIG_QED is not set
> > CONFIG_NET_VENDOR_QUALCOMM=y
> > # CONFIG_QCOM_EMAC is not set
> > # CONFIG_RMNET is not set
> > CONFIG_NET_VENDOR_RDC=y
> > # CONFIG_R6040 is not set
> > CONFIG_NET_VENDOR_REALTEK=y
> > # CONFIG_ATP is not set
> > # CONFIG_8139CP is not set
> > # CONFIG_8139TOO is not set
> > CONFIG_R8169=y
> > CONFIG_NET_VENDOR_RENESAS=y
> > CONFIG_NET_VENDOR_ROCKER=y
> > # CONFIG_ROCKER is not set
> > CONFIG_NET_VENDOR_SAMSUNG=y
> > # CONFIG_SXGBE_ETH is not set
> > CONFIG_NET_VENDOR_SEEQ=y
> > CONFIG_NET_VENDOR_SOLARFLARE=y
> > # CONFIG_SFC is not set
> > # CONFIG_SFC_FALCON is not set
> > CONFIG_NET_VENDOR_SILAN=y
> > # CONFIG_SC92031 is not set
> > CONFIG_NET_VENDOR_SIS=y
> > # CONFIG_SIS900 is not set
> > # CONFIG_SIS190 is not set
> > CONFIG_NET_VENDOR_SMSC=y
> > # CONFIG_EPIC100 is not set
> > # CONFIG_SMSC911X is not set
> > # CONFIG_SMSC9420 is not set
> > CONFIG_NET_VENDOR_SOCIONEXT=y
> > CONFIG_NET_VENDOR_STMICRO=y
> > # CONFIG_STMMAC_ETH is not set
> > CONFIG_NET_VENDOR_SUN=y
> > # CONFIG_HAPPYMEAL is not set
> > # CONFIG_SUNGEM is not set
> > # CONFIG_CASSINI is not set
> > # CONFIG_NIU is not set
> > CONFIG_NET_VENDOR_SYNOPSYS=y
> > # CONFIG_DWC_XLGMAC is not set
> > CONFIG_NET_VENDOR_TEHUTI=y
> > # CONFIG_TEHUTI is not set
> > CONFIG_NET_VENDOR_TI=y
> > # CONFIG_TI_CPSW_ALE is not set
> > # CONFIG_TLAN is not set
> > CONFIG_NET_VENDOR_VIA=y
> > # CONFIG_VIA_RHINE is not set
> > # CONFIG_VIA_VELOCITY is not set
> > CONFIG_NET_VENDOR_WIZNET=y
> > # CONFIG_WIZNET_W5100 is not set
> > # CONFIG_WIZNET_W5300 is not set
> > # CONFIG_FDDI is not set
> > # CONFIG_HIPPI is not set
> > # CONFIG_NET_SB1000 is not set
> > CONFIG_MDIO_DEVICE=y
> > CONFIG_MDIO_BUS=y
> > # CONFIG_MDIO_BCM_UNIMAC is not set
> > # CONFIG_MDIO_BITBANG is not set
> > # CONFIG_MDIO_MSCC_MIIM is not set
> > # CONFIG_MDIO_THUNDER is not set
> > CONFIG_PHYLIB=y
> > # CONFIG_LED_TRIGGER_PHY is not set
> > 
> > #
> > # MII PHY device drivers
> > #
> > # CONFIG_AMD_PHY is not set
> > # CONFIG_AQUANTIA_PHY is not set
> > # CONFIG_ASIX_PHY is not set
> > # CONFIG_AT803X_PHY is not set
> > # CONFIG_BCM7XXX_PHY is not set
> > # CONFIG_BCM87XX_PHY is not set
> > # CONFIG_BROADCOM_PHY is not set
> > # CONFIG_CICADA_PHY is not set
> > # CONFIG_CORTINA_PHY is not set
> > # CONFIG_DAVICOM_PHY is not set
> > # CONFIG_DP83822_PHY is not set
> > # CONFIG_DP83TC811_PHY is not set
> > # CONFIG_DP83848_PHY is not set
> > # CONFIG_DP83867_PHY is not set
> > # CONFIG_FIXED_PHY is not set
> > # CONFIG_ICPLUS_PHY is not set
> > # CONFIG_INTEL_XWAY_PHY is not set
> > # CONFIG_LSI_ET1011C_PHY is not set
> > # CONFIG_LXT_PHY is not set
> > # CONFIG_MARVELL_PHY is not set
> > # CONFIG_MARVELL_10G_PHY is not set
> > # CONFIG_MICREL_PHY is not set
> > # CONFIG_MICROCHIP_PHY is not set
> > # CONFIG_MICROCHIP_T1_PHY is not set
> > # CONFIG_MICROSEMI_PHY is not set
> > # CONFIG_NATIONAL_PHY is not set
> > # CONFIG_QSEMI_PHY is not set
> > CONFIG_REALTEK_PHY=y
> > # CONFIG_RENESAS_PHY is not set
> > # CONFIG_ROCKCHIP_PHY is not set
> > # CONFIG_SMSC_PHY is not set
> > # CONFIG_STE10XP is not set
> > # CONFIG_TERANETICS_PHY is not set
> > # CONFIG_VITESSE_PHY is not set
> > # CONFIG_XILINX_GMII2RGMII is not set
> > # CONFIG_MICREL_KS8995MA is not set
> > # CONFIG_PLIP is not set
> > # CONFIG_PPP is not set
> > # CONFIG_SLIP is not set
> > CONFIG_USB_NET_DRIVERS=y
> > # CONFIG_USB_CATC is not set
> > # CONFIG_USB_KAWETH is not set
> > # CONFIG_USB_PEGASUS is not set
> > # CONFIG_USB_RTL8150 is not set
> > CONFIG_USB_RTL8152=y
> > # CONFIG_USB_LAN78XX is not set
> > CONFIG_USB_USBNET=y
> > CONFIG_USB_NET_AX8817X=y
> > CONFIG_USB_NET_AX88179_178A=y
> > # CONFIG_USB_NET_CDCETHER is not set
> > # CONFIG_USB_NET_CDC_EEM is not set
> > # CONFIG_USB_NET_CDC_NCM is not set
> > # CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
> > # CONFIG_USB_NET_CDC_MBIM is not set
> > # CONFIG_USB_NET_DM9601 is not set
> > # CONFIG_USB_NET_SR9700 is not set
> > # CONFIG_USB_NET_SR9800 is not set
> > # CONFIG_USB_NET_SMSC75XX is not set
> > # CONFIG_USB_NET_SMSC95XX is not set
> > # CONFIG_USB_NET_GL620A is not set
> > # CONFIG_USB_NET_NET1080 is not set
> > # CONFIG_USB_NET_PLUSB is not set
> > # CONFIG_USB_NET_MCS7830 is not set
> > # CONFIG_USB_NET_RNDIS_HOST is not set
> > # CONFIG_USB_NET_CDC_SUBSET is not set
> > # CONFIG_USB_NET_ZAURUS is not set
> > # CONFIG_USB_NET_CX82310_ETH is not set
> > # CONFIG_USB_NET_KALMIA is not set
> > # CONFIG_USB_NET_QMI_WWAN is not set
> > # CONFIG_USB_HSO is not set
> > # CONFIG_USB_NET_INT51X1 is not set
> > # CONFIG_USB_IPHETH is not set
> > # CONFIG_USB_SIERRA_NET is not set
> > # CONFIG_USB_NET_CH9200 is not set
> > CONFIG_WLAN=y
> > # CONFIG_WIRELESS_WDS is not set
> > CONFIG_WLAN_VENDOR_ADMTEK=y
> > # CONFIG_ADM8211 is not set
> > CONFIG_WLAN_VENDOR_ATH=y
> > # CONFIG_ATH_DEBUG is not set
> > # CONFIG_ATH5K is not set
> > # CONFIG_ATH5K_PCI is not set
> > # CONFIG_ATH9K is not set
> > # CONFIG_ATH9K_HTC is not set
> > # CONFIG_CARL9170 is not set
> > # CONFIG_ATH6KL is not set
> > # CONFIG_AR5523 is not set
> > # CONFIG_WIL6210 is not set
> > # CONFIG_ATH10K is not set
> > # CONFIG_WCN36XX is not set
> > CONFIG_WLAN_VENDOR_ATMEL=y
> > # CONFIG_ATMEL is not set
> > # CONFIG_AT76C50X_USB is not set
> > CONFIG_WLAN_VENDOR_BROADCOM=y
> > # CONFIG_B43 is not set
> > # CONFIG_B43LEGACY is not set
> > # CONFIG_BRCMSMAC is not set
> > # CONFIG_BRCMFMAC is not set
> > CONFIG_WLAN_VENDOR_CISCO=y
> > # CONFIG_AIRO is not set
> > CONFIG_WLAN_VENDOR_INTEL=y
> > # CONFIG_IPW2100 is not set
> > # CONFIG_IPW2200 is not set
> > # CONFIG_IWL4965 is not set
> > # CONFIG_IWL3945 is not set
> > # CONFIG_IWLWIFI is not set
> > CONFIG_WLAN_VENDOR_INTERSIL=y
> > # CONFIG_HOSTAP is not set
> > # CONFIG_HERMES is not set
> > # CONFIG_P54_COMMON is not set
> > # CONFIG_PRISM54 is not set
> > CONFIG_WLAN_VENDOR_MARVELL=y
> > # CONFIG_LIBERTAS is not set
> > # CONFIG_LIBERTAS_THINFIRM is not set
> > # CONFIG_MWIFIEX is not set
> > # CONFIG_MWL8K is not set
> > CONFIG_WLAN_VENDOR_MEDIATEK=y
> > # CONFIG_MT7601U is not set
> > # CONFIG_MT76x0U is not set
> > # CONFIG_MT76x2E is not set
> > # CONFIG_MT76x2U is not set
> > CONFIG_WLAN_VENDOR_RALINK=y
> > # CONFIG_RT2X00 is not set
> > CONFIG_WLAN_VENDOR_REALTEK=y
> > # CONFIG_RTL8180 is not set
> > # CONFIG_RTL8187 is not set
> > CONFIG_RTL_CARDS=m
> > # CONFIG_RTL8192CE is not set
> > # CONFIG_RTL8192SE is not set
> > # CONFIG_RTL8192DE is not set
> > # CONFIG_RTL8723AE is not set
> > # CONFIG_RTL8723BE is not set
> > # CONFIG_RTL8188EE is not set
> > # CONFIG_RTL8192EE is not set
> > # CONFIG_RTL8821AE is not set
> > # CONFIG_RTL8192CU is not set
> > # CONFIG_RTL8XXXU is not set
> > CONFIG_WLAN_VENDOR_RSI=y
> > # CONFIG_RSI_91X is not set
> > CONFIG_WLAN_VENDOR_ST=y
> > # CONFIG_CW1200 is not set
> > CONFIG_WLAN_VENDOR_TI=y
> > # CONFIG_WL1251 is not set
> > # CONFIG_WL12XX is not set
> > # CONFIG_WL18XX is not set
> > # CONFIG_WLCORE is not set
> > CONFIG_WLAN_VENDOR_ZYDAS=y
> > # CONFIG_USB_ZD1201 is not set
> > # CONFIG_ZD1211RW is not set
> > CONFIG_WLAN_VENDOR_QUANTENNA=y
> > # CONFIG_QTNFMAC_PEARL_PCIE is not set
> > # CONFIG_MAC80211_HWSIM is not set
> > # CONFIG_USB_NET_RNDIS_WLAN is not set
> > 
> > #
> > # Enable WiMAX (Networking options) to see the WiMAX drivers
> > #
> > # CONFIG_WAN is not set
> > CONFIG_IEEE802154_DRIVERS=m
> > # CONFIG_IEEE802154_FAKELB is not set
> > # CONFIG_IEEE802154_AT86RF230 is not set
> > # CONFIG_IEEE802154_MRF24J40 is not set
> > # CONFIG_IEEE802154_CC2520 is not set
> > # CONFIG_IEEE802154_ATUSB is not set
> > # CONFIG_IEEE802154_ADF7242 is not set
> > # CONFIG_IEEE802154_CA8210 is not set
> > # CONFIG_IEEE802154_MCR20A is not set
> > # CONFIG_IEEE802154_HWSIM is not set
> > CONFIG_XEN_NETDEV_FRONTEND=y
> > # CONFIG_VMXNET3 is not set
> > # CONFIG_FUJITSU_ES is not set
> > # CONFIG_THUNDERBOLT_NET is not set
> > # CONFIG_HYPERV_NET is not set
> > CONFIG_NETDEVSIM=m
> > CONFIG_NET_FAILOVER=m
> > # CONFIG_ISDN is not set
> > # CONFIG_NVM is not set
> > 
> > #
> > # Input device support
> > #
> > CONFIG_INPUT=y
> > CONFIG_INPUT_LEDS=y
> > CONFIG_INPUT_FF_MEMLESS=m
> > CONFIG_INPUT_POLLDEV=m
> > CONFIG_INPUT_SPARSEKMAP=m
> > # CONFIG_INPUT_MATRIXKMAP is not set
> > 
> > #
> > # Userland interfaces
> > #
> > CONFIG_INPUT_MOUSEDEV=y
> > # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> > CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> > CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> > CONFIG_INPUT_JOYDEV=m
> > CONFIG_INPUT_EVDEV=y
> > # CONFIG_INPUT_EVBUG is not set
> > 
> > #
> > # Input Device Drivers
> > #
> > CONFIG_INPUT_KEYBOARD=y
> > # CONFIG_KEYBOARD_ADP5588 is not set
> > # CONFIG_KEYBOARD_ADP5589 is not set
> > CONFIG_KEYBOARD_ATKBD=y
> > # CONFIG_KEYBOARD_QT1070 is not set
> > # CONFIG_KEYBOARD_QT2160 is not set
> > # CONFIG_KEYBOARD_DLINK_DIR685 is not set
> > # CONFIG_KEYBOARD_LKKBD is not set
> > # CONFIG_KEYBOARD_GPIO is not set
> > # CONFIG_KEYBOARD_GPIO_POLLED is not set
> > # CONFIG_KEYBOARD_TCA6416 is not set
> > # CONFIG_KEYBOARD_TCA8418 is not set
> > # CONFIG_KEYBOARD_MATRIX is not set
> > # CONFIG_KEYBOARD_LM8323 is not set
> > # CONFIG_KEYBOARD_LM8333 is not set
> > # CONFIG_KEYBOARD_MAX7359 is not set
> > # CONFIG_KEYBOARD_MCS is not set
> > # CONFIG_KEYBOARD_MPR121 is not set
> > # CONFIG_KEYBOARD_NEWTON is not set
> > # CONFIG_KEYBOARD_OPENCORES is not set
> > # CONFIG_KEYBOARD_SAMSUNG is not set
> > # CONFIG_KEYBOARD_STOWAWAY is not set
> > # CONFIG_KEYBOARD_SUNKBD is not set
> > # CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
> > # CONFIG_KEYBOARD_XTKBD is not set
> > CONFIG_INPUT_MOUSE=y
> > CONFIG_MOUSE_PS2=y
> > CONFIG_MOUSE_PS2_ALPS=y
> > CONFIG_MOUSE_PS2_BYD=y
> > CONFIG_MOUSE_PS2_LOGIPS2PP=y
> > CONFIG_MOUSE_PS2_SYNAPTICS=y
> > CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
> > CONFIG_MOUSE_PS2_CYPRESS=y
> > CONFIG_MOUSE_PS2_LIFEBOOK=y
> > CONFIG_MOUSE_PS2_TRACKPOINT=y
> > CONFIG_MOUSE_PS2_ELANTECH=y
> > CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
> > CONFIG_MOUSE_PS2_SENTELIC=y
> > # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> > CONFIG_MOUSE_PS2_FOCALTECH=y
> > CONFIG_MOUSE_PS2_VMMOUSE=y
> > CONFIG_MOUSE_PS2_SMBUS=y
> > CONFIG_MOUSE_SERIAL=m
> > # CONFIG_MOUSE_APPLETOUCH is not set
> > # CONFIG_MOUSE_BCM5974 is not set
> > CONFIG_MOUSE_CYAPA=m
> > CONFIG_MOUSE_ELAN_I2C=m
> > CONFIG_MOUSE_ELAN_I2C_I2C=y
> > CONFIG_MOUSE_ELAN_I2C_SMBUS=y
> > CONFIG_MOUSE_VSXXXAA=m
> > # CONFIG_MOUSE_GPIO is not set
> > CONFIG_MOUSE_SYNAPTICS_I2C=m
> > # CONFIG_MOUSE_SYNAPTICS_USB is not set
> > # CONFIG_INPUT_JOYSTICK is not set
> > # CONFIG_INPUT_TABLET is not set
> > # CONFIG_INPUT_TOUCHSCREEN is not set
> > # CONFIG_INPUT_MISC is not set
> > CONFIG_RMI4_CORE=m
> > CONFIG_RMI4_I2C=m
> > CONFIG_RMI4_SPI=m
> > CONFIG_RMI4_SMB=m
> > CONFIG_RMI4_F03=y
> > CONFIG_RMI4_F03_SERIO=m
> > CONFIG_RMI4_2D_SENSOR=y
> > CONFIG_RMI4_F11=y
> > CONFIG_RMI4_F12=y
> > CONFIG_RMI4_F30=y
> > CONFIG_RMI4_F34=y
> > CONFIG_RMI4_F55=y
> > 
> > #
> > # Hardware I/O ports
> > #
> > CONFIG_SERIO=y
> > CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> > CONFIG_SERIO_I8042=y
> > CONFIG_SERIO_SERPORT=y
> > # CONFIG_SERIO_CT82C710 is not set
> > # CONFIG_SERIO_PARKBD is not set
> > # CONFIG_SERIO_PCIPS2 is not set
> > CONFIG_SERIO_LIBPS2=y
> > CONFIG_SERIO_RAW=m
> > CONFIG_SERIO_ALTERA_PS2=m
> > # CONFIG_SERIO_PS2MULT is not set
> > CONFIG_SERIO_ARC_PS2=m
> > CONFIG_HYPERV_KEYBOARD=m
> > # CONFIG_SERIO_GPIO_PS2 is not set
> > # CONFIG_USERIO is not set
> > # CONFIG_GAMEPORT is not set
> > 
> > #
> > # Character devices
> > #
> > CONFIG_TTY=y
> > CONFIG_VT=y
> > CONFIG_CONSOLE_TRANSLATIONS=y
> > CONFIG_VT_CONSOLE=y
> > CONFIG_VT_CONSOLE_SLEEP=y
> > CONFIG_HW_CONSOLE=y
> > CONFIG_VT_HW_CONSOLE_BINDING=y
> > CONFIG_UNIX98_PTYS=y
> > # CONFIG_LEGACY_PTYS is not set
> > CONFIG_SERIAL_NONSTANDARD=y
> > # CONFIG_ROCKETPORT is not set
> > CONFIG_CYCLADES=m
> > # CONFIG_CYZ_INTR is not set
> > # CONFIG_MOXA_INTELLIO is not set
> > # CONFIG_MOXA_SMARTIO is not set
> > CONFIG_SYNCLINK=m
> > CONFIG_SYNCLINKMP=m
> > CONFIG_SYNCLINK_GT=m
> > CONFIG_NOZOMI=m
> > # CONFIG_ISI is not set
> > CONFIG_N_HDLC=m
> > CONFIG_N_GSM=m
> > # CONFIG_TRACE_SINK is not set
> > CONFIG_LDISC_AUTOLOAD=y
> > CONFIG_DEVMEM=y
> > # CONFIG_DEVKMEM is not set
> > 
> > #
> > # Serial drivers
> > #
> > CONFIG_SERIAL_EARLYCON=y
> > CONFIG_SERIAL_8250=y
> > # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> > CONFIG_SERIAL_8250_PNP=y
> > # CONFIG_SERIAL_8250_FINTEK is not set
> > CONFIG_SERIAL_8250_CONSOLE=y
> > CONFIG_SERIAL_8250_DMA=y
> > CONFIG_SERIAL_8250_PCI=y
> > CONFIG_SERIAL_8250_EXAR=y
> > CONFIG_SERIAL_8250_NR_UARTS=64
> > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> > CONFIG_SERIAL_8250_EXTENDED=y
> > CONFIG_SERIAL_8250_MANY_PORTS=y
> > CONFIG_SERIAL_8250_SHARE_IRQ=y
> > # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> > CONFIG_SERIAL_8250_RSA=y
> > CONFIG_SERIAL_8250_DW=y
> > # CONFIG_SERIAL_8250_RT288X is not set
> > CONFIG_SERIAL_8250_LPSS=y
> > CONFIG_SERIAL_8250_MID=y
> > # CONFIG_SERIAL_8250_MOXA is not set
> > 
> > #
> > # Non-8250 serial port support
> > #
> > # CONFIG_SERIAL_MAX3100 is not set
> > # CONFIG_SERIAL_MAX310X is not set
> > # CONFIG_SERIAL_UARTLITE is not set
> > CONFIG_SERIAL_CORE=y
> > CONFIG_SERIAL_CORE_CONSOLE=y
> > CONFIG_SERIAL_JSM=m
> > # CONFIG_SERIAL_SCCNXP is not set
> > # CONFIG_SERIAL_SC16IS7XX is not set
> > # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> > # CONFIG_SERIAL_ALTERA_UART is not set
> > # CONFIG_SERIAL_IFX6X60 is not set
> > CONFIG_SERIAL_ARC=m
> > CONFIG_SERIAL_ARC_NR_PORTS=1
> > # CONFIG_SERIAL_RP2 is not set
> > # CONFIG_SERIAL_FSL_LPUART is not set
> > # CONFIG_SERIAL_DEV_BUS is not set
> > # CONFIG_TTY_PRINTK is not set
> > CONFIG_PRINTER=m
> > # CONFIG_LP_CONSOLE is not set
> > CONFIG_PPDEV=m
> > CONFIG_HVC_DRIVER=y
> > CONFIG_HVC_IRQ=y
> > CONFIG_HVC_XEN=y
> > CONFIG_HVC_XEN_FRONTEND=y
> > CONFIG_VIRTIO_CONSOLE=m
> > CONFIG_IPMI_HANDLER=m
> > CONFIG_IPMI_DMI_DECODE=y
> > CONFIG_IPMI_PANIC_EVENT=y
> > CONFIG_IPMI_PANIC_STRING=y
> > CONFIG_IPMI_DEVICE_INTERFACE=m
> > CONFIG_IPMI_SI=m
> > CONFIG_IPMI_SSIF=m
> > CONFIG_IPMI_WATCHDOG=m
> > CONFIG_IPMI_POWEROFF=m
> > CONFIG_HW_RANDOM=y
> > CONFIG_HW_RANDOM_TIMERIOMEM=m
> > CONFIG_HW_RANDOM_INTEL=m
> > CONFIG_HW_RANDOM_AMD=m
> > CONFIG_HW_RANDOM_VIA=m
> > CONFIG_HW_RANDOM_VIRTIO=y
> > CONFIG_NVRAM=y
> > # CONFIG_APPLICOM is not set
> > # CONFIG_MWAVE is not set
> > CONFIG_RAW_DRIVER=y
> > CONFIG_MAX_RAW_DEVS=8192
> > CONFIG_HPET=y
> > CONFIG_HPET_MMAP=y
> > # CONFIG_HPET_MMAP_DEFAULT is not set
> > CONFIG_HANGCHECK_TIMER=m
> > CONFIG_UV_MMTIMER=m
> > CONFIG_TCG_TPM=y
> > CONFIG_HW_RANDOM_TPM=y
> > CONFIG_TCG_TIS_CORE=y
> > CONFIG_TCG_TIS=y
> > # CONFIG_TCG_TIS_SPI is not set
> > CONFIG_TCG_TIS_I2C_ATMEL=m
> > CONFIG_TCG_TIS_I2C_INFINEON=m
> > CONFIG_TCG_TIS_I2C_NUVOTON=m
> > CONFIG_TCG_NSC=m
> > CONFIG_TCG_ATMEL=m
> > CONFIG_TCG_INFINEON=m
> > # CONFIG_TCG_XEN is not set
> > CONFIG_TCG_CRB=y
> > # CONFIG_TCG_VTPM_PROXY is not set
> > CONFIG_TCG_TIS_ST33ZP24=m
> > CONFIG_TCG_TIS_ST33ZP24_I2C=m
> > # CONFIG_TCG_TIS_ST33ZP24_SPI is not set
> > CONFIG_TELCLOCK=m
> > CONFIG_DEVPORT=y
> > # CONFIG_XILLYBUS is not set
> > # CONFIG_RANDOM_TRUST_CPU is not set
> > 
> > #
> > # I2C support
> > #
> > CONFIG_I2C=y
> > CONFIG_ACPI_I2C_OPREGION=y
> > CONFIG_I2C_BOARDINFO=y
> > CONFIG_I2C_COMPAT=y
> > CONFIG_I2C_CHARDEV=m
> > CONFIG_I2C_MUX=m
> > 
> > #
> > # Multiplexer I2C Chip support
> > #
> > # CONFIG_I2C_MUX_GPIO is not set
> > # CONFIG_I2C_MUX_LTC4306 is not set
> > # CONFIG_I2C_MUX_PCA9541 is not set
> > # CONFIG_I2C_MUX_PCA954x is not set
> > # CONFIG_I2C_MUX_REG is not set
> > CONFIG_I2C_MUX_MLXCPLD=m
> > CONFIG_I2C_HELPER_AUTO=y
> > CONFIG_I2C_SMBUS=m
> > CONFIG_I2C_ALGOBIT=y
> > CONFIG_I2C_ALGOPCA=m
> > 
> > #
> > # I2C Hardware Bus support
> > #
> > 
> > #
> > # PC SMBus host controller drivers
> > #
> > # CONFIG_I2C_ALI1535 is not set
> > # CONFIG_I2C_ALI1563 is not set
> > # CONFIG_I2C_ALI15X3 is not set
> > CONFIG_I2C_AMD756=m
> > CONFIG_I2C_AMD756_S4882=m
> > CONFIG_I2C_AMD8111=m
> > CONFIG_I2C_I801=m
> > CONFIG_I2C_ISCH=m
> > CONFIG_I2C_ISMT=m
> > CONFIG_I2C_PIIX4=m
> > CONFIG_I2C_NFORCE2=m
> > CONFIG_I2C_NFORCE2_S4985=m
> > # CONFIG_I2C_SIS5595 is not set
> > # CONFIG_I2C_SIS630 is not set
> > CONFIG_I2C_SIS96X=m
> > CONFIG_I2C_VIA=m
> > CONFIG_I2C_VIAPRO=m
> > 
> > #
> > # ACPI drivers
> > #
> > CONFIG_I2C_SCMI=m
> > 
> > #
> > # I2C system bus drivers (mostly embedded / system-on-chip)
> > #
> > # CONFIG_I2C_CBUS_GPIO is not set
> > CONFIG_I2C_DESIGNWARE_CORE=m
> > CONFIG_I2C_DESIGNWARE_PLATFORM=m
> > # CONFIG_I2C_DESIGNWARE_SLAVE is not set
> > # CONFIG_I2C_DESIGNWARE_PCI is not set
> > CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
> > # CONFIG_I2C_EMEV2 is not set
> > # CONFIG_I2C_GPIO is not set
> > # CONFIG_I2C_OCORES is not set
> > CONFIG_I2C_PCA_PLATFORM=m
> > CONFIG_I2C_SIMTEC=m
> > # CONFIG_I2C_XILINX is not set
> > 
> > #
> > # External I2C/SMBus adapter drivers
> > #
> > # CONFIG_I2C_DIOLAN_U2C is not set
> > CONFIG_I2C_PARPORT=m
> > CONFIG_I2C_PARPORT_LIGHT=m
> > # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> > # CONFIG_I2C_TAOS_EVM is not set
> > # CONFIG_I2C_TINY_USB is not set
> > 
> > #
> > # Other I2C/SMBus bus drivers
> > #
> > CONFIG_I2C_MLXCPLD=m
> > CONFIG_I2C_STUB=m
> > # CONFIG_I2C_SLAVE is not set
> > # CONFIG_I2C_DEBUG_CORE is not set
> > # CONFIG_I2C_DEBUG_ALGO is not set
> > # CONFIG_I2C_DEBUG_BUS is not set
> > CONFIG_SPI=y
> > # CONFIG_SPI_DEBUG is not set
> > CONFIG_SPI_MASTER=y
> > # CONFIG_SPI_MEM is not set
> > 
> > #
> > # SPI Master Controller Drivers
> > #
> > # CONFIG_SPI_ALTERA is not set
> > # CONFIG_SPI_AXI_SPI_ENGINE is not set
> > # CONFIG_SPI_BITBANG is not set
> > # CONFIG_SPI_BUTTERFLY is not set
> > # CONFIG_SPI_CADENCE is not set
> > # CONFIG_SPI_DESIGNWARE is not set
> > # CONFIG_SPI_GPIO is not set
> > # CONFIG_SPI_LM70_LLP is not set
> > # CONFIG_SPI_OC_TINY is not set
> > # CONFIG_SPI_PXA2XX is not set
> > # CONFIG_SPI_ROCKCHIP is not set
> > # CONFIG_SPI_SC18IS602 is not set
> > # CONFIG_SPI_XCOMM is not set
> > # CONFIG_SPI_XILINX is not set
> > # CONFIG_SPI_ZYNQMP_GQSPI is not set
> > 
> > #
> > # SPI Protocol Masters
> > #
> > # CONFIG_SPI_SPIDEV is not set
> > # CONFIG_SPI_LOOPBACK_TEST is not set
> > # CONFIG_SPI_TLE62X0 is not set
> > # CONFIG_SPI_SLAVE is not set
> > # CONFIG_SPMI is not set
> > # CONFIG_HSI is not set
> > CONFIG_PPS=y
> > # CONFIG_PPS_DEBUG is not set
> > 
> > #
> > # PPS clients support
> > #
> > # CONFIG_PPS_CLIENT_KTIMER is not set
> > CONFIG_PPS_CLIENT_LDISC=m
> > CONFIG_PPS_CLIENT_PARPORT=m
> > CONFIG_PPS_CLIENT_GPIO=m
> > 
> > #
> > # PPS generators support
> > #
> > 
> > #
> > # PTP clock support
> > #
> > CONFIG_PTP_1588_CLOCK=y
> > # CONFIG_DP83640_PHY is not set
> > CONFIG_PTP_1588_CLOCK_KVM=m
> > CONFIG_PINCTRL=y
> > CONFIG_PINMUX=y
> > CONFIG_PINCONF=y
> > CONFIG_GENERIC_PINCONF=y
> > # CONFIG_DEBUG_PINCTRL is not set
> > CONFIG_PINCTRL_AMD=m
> > # CONFIG_PINCTRL_MCP23S08 is not set
> > # CONFIG_PINCTRL_SX150X is not set
> > CONFIG_PINCTRL_BAYTRAIL=y
> > # CONFIG_PINCTRL_CHERRYVIEW is not set
> > CONFIG_PINCTRL_INTEL=m
> > CONFIG_PINCTRL_BROXTON=m
> > CONFIG_PINCTRL_CANNONLAKE=m
> > CONFIG_PINCTRL_CEDARFORK=m
> > CONFIG_PINCTRL_DENVERTON=m
> > CONFIG_PINCTRL_GEMINILAKE=m
> > # CONFIG_PINCTRL_ICELAKE is not set
> > CONFIG_PINCTRL_LEWISBURG=m
> > CONFIG_PINCTRL_SUNRISEPOINT=m
> > CONFIG_GPIOLIB=y
> > CONFIG_GPIOLIB_FASTPATH_LIMIT=512
> > CONFIG_GPIO_ACPI=y
> > CONFIG_GPIOLIB_IRQCHIP=y
> > # CONFIG_DEBUG_GPIO is not set
> > CONFIG_GPIO_SYSFS=y
> > CONFIG_GPIO_GENERIC=m
> > 
> > #
> > # Memory mapped GPIO drivers
> > #
> > CONFIG_GPIO_AMDPT=m
> > # CONFIG_GPIO_DWAPB is not set
> > # CONFIG_GPIO_EXAR is not set
> > # CONFIG_GPIO_GENERIC_PLATFORM is not set
> > CONFIG_GPIO_ICH=m
> > # CONFIG_GPIO_LYNXPOINT is not set
> > # CONFIG_GPIO_MB86S7X is not set
> > CONFIG_GPIO_MOCKUP=m
> > # CONFIG_GPIO_VX855 is not set
> > 
> > #
> > # Port-mapped I/O GPIO drivers
> > #
> > # CONFIG_GPIO_F7188X is not set
> > # CONFIG_GPIO_IT87 is not set
> > # CONFIG_GPIO_SCH is not set
> > # CONFIG_GPIO_SCH311X is not set
> > # CONFIG_GPIO_WINBOND is not set
> > # CONFIG_GPIO_WS16C48 is not set
> > 
> > #
> > # I2C GPIO expanders
> > #
> > # CONFIG_GPIO_ADP5588 is not set
> > # CONFIG_GPIO_MAX7300 is not set
> > # CONFIG_GPIO_MAX732X is not set
> > # CONFIG_GPIO_PCA953X is not set
> > # CONFIG_GPIO_PCF857X is not set
> > # CONFIG_GPIO_TPIC2810 is not set
> > 
> > #
> > # MFD GPIO expanders
> > #
> > 
> > #
> > # PCI GPIO expanders
> > #
> > # CONFIG_GPIO_AMD8111 is not set
> > # CONFIG_GPIO_BT8XX is not set
> > # CONFIG_GPIO_ML_IOH is not set
> > # CONFIG_GPIO_PCI_IDIO_16 is not set
> > # CONFIG_GPIO_PCIE_IDIO_24 is not set
> > # CONFIG_GPIO_RDC321X is not set
> > 
> > #
> > # SPI GPIO expanders
> > #
> > # CONFIG_GPIO_MAX3191X is not set
> > # CONFIG_GPIO_MAX7301 is not set
> > # CONFIG_GPIO_MC33880 is not set
> > # CONFIG_GPIO_PISOSR is not set
> > # CONFIG_GPIO_XRA1403 is not set
> > 
> > #
> > # USB GPIO expanders
> > #
> > # CONFIG_W1 is not set
> > # CONFIG_POWER_AVS is not set
> > CONFIG_POWER_RESET=y
> > # CONFIG_POWER_RESET_RESTART is not set
> > CONFIG_POWER_SUPPLY=y
> > # CONFIG_POWER_SUPPLY_DEBUG is not set
> > # CONFIG_PDA_POWER is not set
> > # CONFIG_TEST_POWER is not set
> > # CONFIG_CHARGER_ADP5061 is not set
> > # CONFIG_BATTERY_DS2780 is not set
> > # CONFIG_BATTERY_DS2781 is not set
> > # CONFIG_BATTERY_DS2782 is not set
> > # CONFIG_BATTERY_SBS is not set
> > # CONFIG_CHARGER_SBS is not set
> > # CONFIG_MANAGER_SBS is not set
> > # CONFIG_BATTERY_BQ27XXX is not set
> > # CONFIG_BATTERY_MAX17040 is not set
> > # CONFIG_BATTERY_MAX17042 is not set
> > # CONFIG_CHARGER_MAX8903 is not set
> > # CONFIG_CHARGER_LP8727 is not set
> > # CONFIG_CHARGER_GPIO is not set
> > # CONFIG_CHARGER_LTC3651 is not set
> > # CONFIG_CHARGER_BQ2415X is not set
> > # CONFIG_CHARGER_BQ24257 is not set
> > # CONFIG_CHARGER_BQ24735 is not set
> > # CONFIG_CHARGER_BQ25890 is not set
> > CONFIG_CHARGER_SMB347=m
> > # CONFIG_BATTERY_GAUGE_LTC2941 is not set
> > # CONFIG_CHARGER_RT9455 is not set
> > CONFIG_HWMON=y
> > CONFIG_HWMON_VID=m
> > # CONFIG_HWMON_DEBUG_CHIP is not set
> > 
> > #
> > # Native drivers
> > #
> > CONFIG_SENSORS_ABITUGURU=m
> > CONFIG_SENSORS_ABITUGURU3=m
> > # CONFIG_SENSORS_AD7314 is not set
> > CONFIG_SENSORS_AD7414=m
> > CONFIG_SENSORS_AD7418=m
> > CONFIG_SENSORS_ADM1021=m
> > CONFIG_SENSORS_ADM1025=m
> > CONFIG_SENSORS_ADM1026=m
> > CONFIG_SENSORS_ADM1029=m
> > CONFIG_SENSORS_ADM1031=m
> > CONFIG_SENSORS_ADM9240=m
> > CONFIG_SENSORS_ADT7X10=m
> > # CONFIG_SENSORS_ADT7310 is not set
> > CONFIG_SENSORS_ADT7410=m
> > CONFIG_SENSORS_ADT7411=m
> > CONFIG_SENSORS_ADT7462=m
> > CONFIG_SENSORS_ADT7470=m
> > CONFIG_SENSORS_ADT7475=m
> > CONFIG_SENSORS_ASC7621=m
> > CONFIG_SENSORS_K8TEMP=m
> > CONFIG_SENSORS_K10TEMP=m
> > CONFIG_SENSORS_FAM15H_POWER=m
> > CONFIG_SENSORS_APPLESMC=m
> > CONFIG_SENSORS_ASB100=m
> > # CONFIG_SENSORS_ASPEED is not set
> > CONFIG_SENSORS_ATXP1=m
> > CONFIG_SENSORS_DS620=m
> > CONFIG_SENSORS_DS1621=m
> > CONFIG_SENSORS_DELL_SMM=m
> > CONFIG_SENSORS_I5K_AMB=m
> > CONFIG_SENSORS_F71805F=m
> > CONFIG_SENSORS_F71882FG=m
> > CONFIG_SENSORS_F75375S=m
> > CONFIG_SENSORS_FSCHMD=m
> > # CONFIG_SENSORS_FTSTEUTATES is not set
> > CONFIG_SENSORS_GL518SM=m
> > CONFIG_SENSORS_GL520SM=m
> > CONFIG_SENSORS_G760A=m
> > # CONFIG_SENSORS_G762 is not set
> > # CONFIG_SENSORS_HIH6130 is not set
> > CONFIG_SENSORS_IBMAEM=m
> > CONFIG_SENSORS_IBMPEX=m
> > CONFIG_SENSORS_I5500=m
> > CONFIG_SENSORS_CORETEMP=m
> > CONFIG_SENSORS_IT87=m
> > CONFIG_SENSORS_JC42=m
> > # CONFIG_SENSORS_POWR1220 is not set
> > CONFIG_SENSORS_LINEAGE=m
> > # CONFIG_SENSORS_LTC2945 is not set
> > # CONFIG_SENSORS_LTC2990 is not set
> > CONFIG_SENSORS_LTC4151=m
> > CONFIG_SENSORS_LTC4215=m
> > # CONFIG_SENSORS_LTC4222 is not set
> > CONFIG_SENSORS_LTC4245=m
> > # CONFIG_SENSORS_LTC4260 is not set
> > CONFIG_SENSORS_LTC4261=m
> > # CONFIG_SENSORS_MAX1111 is not set
> > CONFIG_SENSORS_MAX16065=m
> > CONFIG_SENSORS_MAX1619=m
> > CONFIG_SENSORS_MAX1668=m
> > CONFIG_SENSORS_MAX197=m
> > # CONFIG_SENSORS_MAX31722 is not set
> > # CONFIG_SENSORS_MAX6621 is not set
> > CONFIG_SENSORS_MAX6639=m
> > CONFIG_SENSORS_MAX6642=m
> > CONFIG_SENSORS_MAX6650=m
> > CONFIG_SENSORS_MAX6697=m
> > # CONFIG_SENSORS_MAX31790 is not set
> > CONFIG_SENSORS_MCP3021=m
> > # CONFIG_SENSORS_MLXREG_FAN is not set
> > # CONFIG_SENSORS_TC654 is not set
> > # CONFIG_SENSORS_ADCXX is not set
> > CONFIG_SENSORS_LM63=m
> > # CONFIG_SENSORS_LM70 is not set
> > CONFIG_SENSORS_LM73=m
> > CONFIG_SENSORS_LM75=m
> > CONFIG_SENSORS_LM77=m
> > CONFIG_SENSORS_LM78=m
> > CONFIG_SENSORS_LM80=m
> > CONFIG_SENSORS_LM83=m
> > CONFIG_SENSORS_LM85=m
> > CONFIG_SENSORS_LM87=m
> > CONFIG_SENSORS_LM90=m
> > CONFIG_SENSORS_LM92=m
> > CONFIG_SENSORS_LM93=m
> > CONFIG_SENSORS_LM95234=m
> > CONFIG_SENSORS_LM95241=m
> > CONFIG_SENSORS_LM95245=m
> > CONFIG_SENSORS_PC87360=m
> > CONFIG_SENSORS_PC87427=m
> > CONFIG_SENSORS_NTC_THERMISTOR=m
> > # CONFIG_SENSORS_NCT6683 is not set
> > CONFIG_SENSORS_NCT6775=m
> > # CONFIG_SENSORS_NCT7802 is not set
> > # CONFIG_SENSORS_NCT7904 is not set
> > # CONFIG_SENSORS_NPCM7XX is not set
> > CONFIG_SENSORS_PCF8591=m
> > CONFIG_PMBUS=m
> > CONFIG_SENSORS_PMBUS=m
> > CONFIG_SENSORS_ADM1275=m
> > # CONFIG_SENSORS_IBM_CFFPS is not set
> > # CONFIG_SENSORS_IR35221 is not set
> > CONFIG_SENSORS_LM25066=m
> > CONFIG_SENSORS_LTC2978=m
> > # CONFIG_SENSORS_LTC3815 is not set
> > CONFIG_SENSORS_MAX16064=m
> > # CONFIG_SENSORS_MAX20751 is not set
> > # CONFIG_SENSORS_MAX31785 is not set
> > CONFIG_SENSORS_MAX34440=m
> > CONFIG_SENSORS_MAX8688=m
> > # CONFIG_SENSORS_TPS40422 is not set
> > # CONFIG_SENSORS_TPS53679 is not set
> > CONFIG_SENSORS_UCD9000=m
> > CONFIG_SENSORS_UCD9200=m
> > CONFIG_SENSORS_ZL6100=m
> > CONFIG_SENSORS_SHT15=m
> > CONFIG_SENSORS_SHT21=m
> > # CONFIG_SENSORS_SHT3x is not set
> > # CONFIG_SENSORS_SHTC1 is not set
> > CONFIG_SENSORS_SIS5595=m
> > CONFIG_SENSORS_DME1737=m
> > CONFIG_SENSORS_EMC1403=m
> > # CONFIG_SENSORS_EMC2103 is not set
> > CONFIG_SENSORS_EMC6W201=m
> > CONFIG_SENSORS_SMSC47M1=m
> > CONFIG_SENSORS_SMSC47M192=m
> > CONFIG_SENSORS_SMSC47B397=m
> > CONFIG_SENSORS_SCH56XX_COMMON=m
> > CONFIG_SENSORS_SCH5627=m
> > CONFIG_SENSORS_SCH5636=m
> > # CONFIG_SENSORS_STTS751 is not set
> > # CONFIG_SENSORS_SMM665 is not set
> > # CONFIG_SENSORS_ADC128D818 is not set
> > CONFIG_SENSORS_ADS1015=m
> > CONFIG_SENSORS_ADS7828=m
> > # CONFIG_SENSORS_ADS7871 is not set
> > CONFIG_SENSORS_AMC6821=m
> > CONFIG_SENSORS_INA209=m
> > CONFIG_SENSORS_INA2XX=m
> > # CONFIG_SENSORS_INA3221 is not set
> > # CONFIG_SENSORS_TC74 is not set
> > CONFIG_SENSORS_THMC50=m
> > CONFIG_SENSORS_TMP102=m
> > # CONFIG_SENSORS_TMP103 is not set
> > # CONFIG_SENSORS_TMP108 is not set
> > CONFIG_SENSORS_TMP401=m
> > CONFIG_SENSORS_TMP421=m
> > CONFIG_SENSORS_VIA_CPUTEMP=m
> > CONFIG_SENSORS_VIA686A=m
> > CONFIG_SENSORS_VT1211=m
> > CONFIG_SENSORS_VT8231=m
> > # CONFIG_SENSORS_W83773G is not set
> > CONFIG_SENSORS_W83781D=m
> > CONFIG_SENSORS_W83791D=m
> > CONFIG_SENSORS_W83792D=m
> > CONFIG_SENSORS_W83793=m
> > CONFIG_SENSORS_W83795=m
> > # CONFIG_SENSORS_W83795_FANCTRL is not set
> > CONFIG_SENSORS_W83L785TS=m
> > CONFIG_SENSORS_W83L786NG=m
> > CONFIG_SENSORS_W83627HF=m
> > CONFIG_SENSORS_W83627EHF=m
> > # CONFIG_SENSORS_XGENE is not set
> > 
> > #
> > # ACPI drivers
> > #
> > CONFIG_SENSORS_ACPI_POWER=m
> > CONFIG_SENSORS_ATK0110=m
> > CONFIG_THERMAL=y
> > # CONFIG_THERMAL_STATISTICS is not set
> > CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
> > CONFIG_THERMAL_HWMON=y
> > CONFIG_THERMAL_WRITABLE_TRIPS=y
> > CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> > # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> > # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> > # CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
> > CONFIG_THERMAL_GOV_FAIR_SHARE=y
> > CONFIG_THERMAL_GOV_STEP_WISE=y
> > CONFIG_THERMAL_GOV_BANG_BANG=y
> > CONFIG_THERMAL_GOV_USER_SPACE=y
> > # CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
> > # CONFIG_THERMAL_EMULATION is not set
> > CONFIG_INTEL_POWERCLAMP=m
> > CONFIG_X86_PKG_TEMP_THERMAL=m
> > CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
> > # CONFIG_INTEL_SOC_DTS_THERMAL is not set
> > 
> > #
> > # ACPI INT340X thermal drivers
> > #
> > CONFIG_INT340X_THERMAL=m
> > CONFIG_ACPI_THERMAL_REL=m
> > # CONFIG_INT3406_THERMAL is not set
> > CONFIG_INTEL_PCH_THERMAL=m
> > CONFIG_WATCHDOG=y
> > CONFIG_WATCHDOG_CORE=y
> > # CONFIG_WATCHDOG_NOWAYOUT is not set
> > CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
> > CONFIG_WATCHDOG_SYSFS=y
> > 
> > #
> > # Watchdog Device Drivers
> > #
> > CONFIG_SOFT_WATCHDOG=m
> > CONFIG_WDAT_WDT=m
> > # CONFIG_XILINX_WATCHDOG is not set
> > # CONFIG_ZIIRAVE_WATCHDOG is not set
> > # CONFIG_CADENCE_WATCHDOG is not set
> > # CONFIG_DW_WATCHDOG is not set
> > # CONFIG_MAX63XX_WATCHDOG is not set
> > # CONFIG_ACQUIRE_WDT is not set
> > # CONFIG_ADVANTECH_WDT is not set
> > CONFIG_ALIM1535_WDT=m
> > CONFIG_ALIM7101_WDT=m
> > # CONFIG_EBC_C384_WDT is not set
> > CONFIG_F71808E_WDT=m
> > CONFIG_SP5100_TCO=m
> > CONFIG_SBC_FITPC2_WATCHDOG=m
> > # CONFIG_EUROTECH_WDT is not set
> > CONFIG_IB700_WDT=m
> > CONFIG_IBMASR=m
> > # CONFIG_WAFER_WDT is not set
> > CONFIG_I6300ESB_WDT=y
> > CONFIG_IE6XX_WDT=m
> > CONFIG_ITCO_WDT=y
> > CONFIG_ITCO_VENDOR_SUPPORT=y
> > CONFIG_IT8712F_WDT=m
> > CONFIG_IT87_WDT=m
> > CONFIG_HP_WATCHDOG=m
> > CONFIG_HPWDT_NMI_DECODING=y
> > # CONFIG_SC1200_WDT is not set
> > # CONFIG_PC87413_WDT is not set
> > CONFIG_NV_TCO=m
> > # CONFIG_60XX_WDT is not set
> > # CONFIG_CPU5_WDT is not set
> > CONFIG_SMSC_SCH311X_WDT=m
> > # CONFIG_SMSC37B787_WDT is not set
> > CONFIG_VIA_WDT=m
> > CONFIG_W83627HF_WDT=m
> > CONFIG_W83877F_WDT=m
> > CONFIG_W83977F_WDT=m
> > CONFIG_MACHZ_WDT=m
> > # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> > CONFIG_INTEL_MEI_WDT=m
> > # CONFIG_NI903X_WDT is not set
> > # CONFIG_NIC7018_WDT is not set
> > # CONFIG_MEN_A21_WDT is not set
> > CONFIG_XEN_WDT=m
> > 
> > #
> > # PCI-based Watchdog Cards
> > #
> > CONFIG_PCIPCWATCHDOG=m
> > CONFIG_WDTPCI=m
> > 
> > #
> > # USB-based Watchdog Cards
> > #
> > # CONFIG_USBPCWATCHDOG is not set
> > 
> > #
> > # Watchdog Pretimeout Governors
> > #
> > # CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set
> > CONFIG_SSB_POSSIBLE=y
> > # CONFIG_SSB is not set
> > CONFIG_BCMA_POSSIBLE=y
> > CONFIG_BCMA=m
> > CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> > CONFIG_BCMA_HOST_PCI=y
> > # CONFIG_BCMA_HOST_SOC is not set
> > CONFIG_BCMA_DRIVER_PCI=y
> > CONFIG_BCMA_DRIVER_GMAC_CMN=y
> > CONFIG_BCMA_DRIVER_GPIO=y
> > # CONFIG_BCMA_DEBUG is not set
> > 
> > #
> > # Multifunction device drivers
> > #
> > CONFIG_MFD_CORE=y
> > # CONFIG_MFD_AS3711 is not set
> > # CONFIG_PMIC_ADP5520 is not set
> > # CONFIG_MFD_AAT2870_CORE is not set
> > # CONFIG_MFD_BCM590XX is not set
> > # CONFIG_MFD_BD9571MWV is not set
> > # CONFIG_MFD_AXP20X_I2C is not set
> > # CONFIG_MFD_CROS_EC is not set
> > # CONFIG_MFD_MADERA is not set
> > # CONFIG_PMIC_DA903X is not set
> > # CONFIG_MFD_DA9052_SPI is not set
> > # CONFIG_MFD_DA9052_I2C is not set
> > # CONFIG_MFD_DA9055 is not set
> > # CONFIG_MFD_DA9062 is not set
> > # CONFIG_MFD_DA9063 is not set
> > # CONFIG_MFD_DA9150 is not set
> > # CONFIG_MFD_DLN2 is not set
> > # CONFIG_MFD_MC13XXX_SPI is not set
> > # CONFIG_MFD_MC13XXX_I2C is not set
> > # CONFIG_HTC_PASIC3 is not set
> > # CONFIG_HTC_I2CPLD is not set
> > # CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
> > CONFIG_LPC_ICH=m
> > CONFIG_LPC_SCH=m
> > # CONFIG_INTEL_SOC_PMIC is not set
> > # CONFIG_INTEL_SOC_PMIC_CHTWC is not set
> > # CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
> > CONFIG_MFD_INTEL_LPSS=y
> > CONFIG_MFD_INTEL_LPSS_ACPI=y
> > CONFIG_MFD_INTEL_LPSS_PCI=y
> > # CONFIG_MFD_JANZ_CMODIO is not set
> > # CONFIG_MFD_KEMPLD is not set
> > # CONFIG_MFD_88PM800 is not set
> > # CONFIG_MFD_88PM805 is not set
> > # CONFIG_MFD_88PM860X is not set
> > # CONFIG_MFD_MAX14577 is not set
> > # CONFIG_MFD_MAX77693 is not set
> > # CONFIG_MFD_MAX77843 is not set
> > # CONFIG_MFD_MAX8907 is not set
> > # CONFIG_MFD_MAX8925 is not set
> > # CONFIG_MFD_MAX8997 is not set
> > # CONFIG_MFD_MAX8998 is not set
> > # CONFIG_MFD_MT6397 is not set
> > # CONFIG_MFD_MENF21BMC is not set
> > # CONFIG_EZX_PCAP is not set
> > # CONFIG_MFD_VIPERBOARD is not set
> > # CONFIG_MFD_RETU is not set
> > # CONFIG_MFD_PCF50633 is not set
> > # CONFIG_MFD_RDC321X is not set
> > # CONFIG_MFD_RT5033 is not set
> > # CONFIG_MFD_RC5T583 is not set
> > # CONFIG_MFD_SEC_CORE is not set
> > # CONFIG_MFD_SI476X_CORE is not set
> > CONFIG_MFD_SM501=m
> > CONFIG_MFD_SM501_GPIO=y
> > # CONFIG_MFD_SKY81452 is not set
> > # CONFIG_MFD_SMSC is not set
> > # CONFIG_ABX500_CORE is not set
> > # CONFIG_MFD_SYSCON is not set
> > # CONFIG_MFD_TI_AM335X_TSCADC is not set
> > # CONFIG_MFD_LP3943 is not set
> > # CONFIG_MFD_LP8788 is not set
> > # CONFIG_MFD_TI_LMU is not set
> > # CONFIG_MFD_PALMAS is not set
> > # CONFIG_TPS6105X is not set
> > # CONFIG_TPS65010 is not set
> > # CONFIG_TPS6507X is not set
> > # CONFIG_MFD_TPS65086 is not set
> > # CONFIG_MFD_TPS65090 is not set
> > # CONFIG_MFD_TPS68470 is not set
> > # CONFIG_MFD_TI_LP873X is not set
> > # CONFIG_MFD_TPS6586X is not set
> > # CONFIG_MFD_TPS65910 is not set
> > # CONFIG_MFD_TPS65912_I2C is not set
> > # CONFIG_MFD_TPS65912_SPI is not set
> > # CONFIG_MFD_TPS80031 is not set
> > # CONFIG_TWL4030_CORE is not set
> > # CONFIG_TWL6040_CORE is not set
> > # CONFIG_MFD_WL1273_CORE is not set
> > # CONFIG_MFD_LM3533 is not set
> > CONFIG_MFD_VX855=m
> > # CONFIG_MFD_ARIZONA_I2C is not set
> > # CONFIG_MFD_ARIZONA_SPI is not set
> > # CONFIG_MFD_WM8400 is not set
> > # CONFIG_MFD_WM831X_I2C is not set
> > # CONFIG_MFD_WM831X_SPI is not set
> > # CONFIG_MFD_WM8350_I2C is not set
> > # CONFIG_MFD_WM8994 is not set
> > # CONFIG_REGULATOR is not set
> > CONFIG_RC_CORE=m
> > CONFIG_RC_MAP=m
> > CONFIG_LIRC=y
> > CONFIG_RC_DECODERS=y
> > CONFIG_IR_NEC_DECODER=m
> > CONFIG_IR_RC5_DECODER=m
> > CONFIG_IR_RC6_DECODER=m
> > CONFIG_IR_JVC_DECODER=m
> > CONFIG_IR_SONY_DECODER=m
> > CONFIG_IR_SANYO_DECODER=m
> > CONFIG_IR_SHARP_DECODER=m
> > CONFIG_IR_MCE_KBD_DECODER=m
> > # CONFIG_IR_XMP_DECODER is not set
> > CONFIG_IR_IMON_DECODER=m
> > CONFIG_RC_DEVICES=y
> > # CONFIG_RC_ATI_REMOTE is not set
> > CONFIG_IR_ENE=m
> > # CONFIG_IR_IMON is not set
> > # CONFIG_IR_IMON_RAW is not set
> > # CONFIG_IR_MCEUSB is not set
> > CONFIG_IR_ITE_CIR=m
> > CONFIG_IR_FINTEK=m
> > CONFIG_IR_NUVOTON=m
> > # CONFIG_IR_REDRAT3 is not set
> > # CONFIG_IR_STREAMZAP is not set
> > CONFIG_IR_WINBOND_CIR=m
> > # CONFIG_IR_IGORPLUGUSB is not set
> > # CONFIG_IR_IGUANA is not set
> > # CONFIG_IR_TTUSBIR is not set
> > CONFIG_RC_LOOPBACK=m
> > CONFIG_IR_SERIAL=m
> > CONFIG_IR_SERIAL_TRANSMITTER=y
> > CONFIG_IR_SIR=m
> > CONFIG_MEDIA_SUPPORT=m
> > 
> > #
> > # Multimedia core support
> > #
> > # CONFIG_MEDIA_CAMERA_SUPPORT is not set
> > # CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
> > # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> > # CONFIG_MEDIA_RADIO_SUPPORT is not set
> > # CONFIG_MEDIA_SDR_SUPPORT is not set
> > # CONFIG_MEDIA_CEC_SUPPORT is not set
> > # CONFIG_VIDEO_ADV_DEBUG is not set
> > # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> > 
> > #
> > # Media drivers
> > #
> > # CONFIG_MEDIA_USB_SUPPORT is not set
> > # CONFIG_MEDIA_PCI_SUPPORT is not set
> > 
> > #
> > # Supported MMC/SDIO adapters
> > #
> > # CONFIG_CYPRESS_FIRMWARE is not set
> > 
> > #
> > # Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
> > #
> > 
> > #
> > # Media SPI Adapters
> > #
> > 
> > #
> > # Customise DVB Frontends
> > #
> > 
> > #
> > # Tools to develop new frontends
> > #
> > 
> > #
> > # Graphics support
> > #
> > # CONFIG_AGP is not set
> > CONFIG_INTEL_GTT=m
> > CONFIG_VGA_ARB=y
> > CONFIG_VGA_ARB_MAX_GPUS=64
> > CONFIG_VGA_SWITCHEROO=y
> > CONFIG_DRM=y
> > CONFIG_DRM_MIPI_DSI=y
> > CONFIG_DRM_DP_AUX_CHARDEV=y
> > # CONFIG_DRM_DEBUG_MM is not set
> > CONFIG_DRM_DEBUG_SELFTEST=m
> > CONFIG_DRM_KMS_HELPER=y
> > CONFIG_DRM_KMS_FB_HELPER=y
> > CONFIG_DRM_FBDEV_EMULATION=y
> > CONFIG_DRM_FBDEV_OVERALLOC=100
> > # CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
> > CONFIG_DRM_LOAD_EDID_FIRMWARE=y
> > # CONFIG_DRM_DP_CEC is not set
> > CONFIG_DRM_TTM=m
> > 
> > #
> > # I2C encoder or helper chips
> > #
> > CONFIG_DRM_I2C_CH7006=m
> > CONFIG_DRM_I2C_SIL164=m
> > # CONFIG_DRM_I2C_NXP_TDA998X is not set
> > # CONFIG_DRM_I2C_NXP_TDA9950 is not set
> > # CONFIG_DRM_RADEON is not set
> > # CONFIG_DRM_AMDGPU is not set
> > 
> > #
> > # ACP (Audio CoProcessor) Configuration
> > #
> > 
> > #
> > # AMD Library routines
> > #
> > # CONFIG_DRM_NOUVEAU is not set
> > CONFIG_DRM_I915=m
> > # CONFIG_DRM_I915_ALPHA_SUPPORT is not set
> > CONFIG_DRM_I915_CAPTURE_ERROR=y
> > CONFIG_DRM_I915_COMPRESS_ERROR=y
> > CONFIG_DRM_I915_USERPTR=y
> > CONFIG_DRM_I915_GVT=y
> > CONFIG_DRM_I915_GVT_KVMGT=m
> > 
> > #
> > # drm/i915 Debugging
> > #
> > # CONFIG_DRM_I915_WERROR is not set
> > # CONFIG_DRM_I915_DEBUG is not set
> > # CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
> > # CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
> > # CONFIG_DRM_I915_DEBUG_GUC is not set
> > # CONFIG_DRM_I915_SELFTEST is not set
> > # CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
> > # CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
> > CONFIG_DRM_VGEM=y
> > # CONFIG_DRM_VKMS is not set
> > CONFIG_DRM_VMWGFX=m
> > CONFIG_DRM_VMWGFX_FBCON=y
> > CONFIG_DRM_GMA500=m
> > CONFIG_DRM_GMA600=y
> > CONFIG_DRM_GMA3600=y
> > # CONFIG_DRM_UDL is not set
> > CONFIG_DRM_AST=m
> > CONFIG_DRM_MGAG200=m
> > CONFIG_DRM_CIRRUS_QEMU=m
> > CONFIG_DRM_QXL=m
> > CONFIG_DRM_BOCHS=m
> > CONFIG_DRM_VIRTIO_GPU=m
> > CONFIG_DRM_PANEL=y
> > 
> > #
> > # Display Panels
> > #
> > # CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
> > CONFIG_DRM_BRIDGE=y
> > CONFIG_DRM_PANEL_BRIDGE=y
> > 
> > #
> > # Display Interface Bridges
> > #
> > # CONFIG_DRM_ANALOGIX_ANX78XX is not set
> > # CONFIG_DRM_HISI_HIBMC is not set
> > # CONFIG_DRM_TINYDRM is not set
> > # CONFIG_DRM_XEN is not set
> > # CONFIG_DRM_LEGACY is not set
> > CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
> > CONFIG_DRM_LIB_RANDOM=y
> > 
> > #
> > # Frame buffer Devices
> > #
> > CONFIG_FB=y
> > # CONFIG_FIRMWARE_EDID is not set
> > CONFIG_FB_CMDLINE=y
> > CONFIG_FB_NOTIFY=y
> > CONFIG_FB_BOOT_VESA_SUPPORT=y
> > CONFIG_FB_CFB_FILLRECT=y
> > CONFIG_FB_CFB_COPYAREA=y
> > CONFIG_FB_CFB_IMAGEBLIT=y
> > CONFIG_FB_SYS_FILLRECT=y
> > CONFIG_FB_SYS_COPYAREA=y
> > CONFIG_FB_SYS_IMAGEBLIT=y
> > # CONFIG_FB_FOREIGN_ENDIAN is not set
> > CONFIG_FB_SYS_FOPS=y
> > CONFIG_FB_DEFERRED_IO=y
> > # CONFIG_FB_MODE_HELPERS is not set
> > CONFIG_FB_TILEBLITTING=y
> > 
> > #
> > # Frame buffer hardware drivers
> > #
> > # CONFIG_FB_CIRRUS is not set
> > # CONFIG_FB_PM2 is not set
> > # CONFIG_FB_CYBER2000 is not set
> > # CONFIG_FB_ARC is not set
> > # CONFIG_FB_ASILIANT is not set
> > # CONFIG_FB_IMSTT is not set
> > # CONFIG_FB_VGA16 is not set
> > # CONFIG_FB_UVESA is not set
> > CONFIG_FB_VESA=y
> > CONFIG_FB_EFI=y
> > # CONFIG_FB_N411 is not set
> > # CONFIG_FB_HGA is not set
> > # CONFIG_FB_OPENCORES is not set
> > # CONFIG_FB_S1D13XXX is not set
> > # CONFIG_FB_NVIDIA is not set
> > # CONFIG_FB_RIVA is not set
> > # CONFIG_FB_I740 is not set
> > # CONFIG_FB_LE80578 is not set
> > # CONFIG_FB_MATROX is not set
> > # CONFIG_FB_RADEON is not set
> > # CONFIG_FB_ATY128 is not set
> > # CONFIG_FB_ATY is not set
> > # CONFIG_FB_S3 is not set
> > # CONFIG_FB_SAVAGE is not set
> > # CONFIG_FB_SIS is not set
> > # CONFIG_FB_VIA is not set
> > # CONFIG_FB_NEOMAGIC is not set
> > # CONFIG_FB_KYRO is not set
> > # CONFIG_FB_3DFX is not set
> > # CONFIG_FB_VOODOO1 is not set
> > # CONFIG_FB_VT8623 is not set
> > # CONFIG_FB_TRIDENT is not set
> > # CONFIG_FB_ARK is not set
> > # CONFIG_FB_PM3 is not set
> > # CONFIG_FB_CARMINE is not set
> > # CONFIG_FB_SM501 is not set
> > # CONFIG_FB_SMSCUFX is not set
> > # CONFIG_FB_UDL is not set
> > # CONFIG_FB_IBM_GXT4500 is not set
> > # CONFIG_FB_VIRTUAL is not set
> > # CONFIG_XEN_FBDEV_FRONTEND is not set
> > # CONFIG_FB_METRONOME is not set
> > # CONFIG_FB_MB862XX is not set
> > # CONFIG_FB_BROADSHEET is not set
> > CONFIG_FB_HYPERV=m
> > # CONFIG_FB_SIMPLE is not set
> > # CONFIG_FB_SM712 is not set
> > CONFIG_BACKLIGHT_LCD_SUPPORT=y
> > CONFIG_LCD_CLASS_DEVICE=m
> > # CONFIG_LCD_L4F00242T03 is not set
> > # CONFIG_LCD_LMS283GF05 is not set
> > # CONFIG_LCD_LTV350QV is not set
> > # CONFIG_LCD_ILI922X is not set
> > # CONFIG_LCD_ILI9320 is not set
> > # CONFIG_LCD_TDO24M is not set
> > # CONFIG_LCD_VGG2432A4 is not set
> > CONFIG_LCD_PLATFORM=m
> > # CONFIG_LCD_S6E63M0 is not set
> > # CONFIG_LCD_LD9040 is not set
> > # CONFIG_LCD_AMS369FG06 is not set
> > # CONFIG_LCD_LMS501KF03 is not set
> > # CONFIG_LCD_HX8357 is not set
> > # CONFIG_LCD_OTM3225A is not set
> > CONFIG_BACKLIGHT_CLASS_DEVICE=y
> > # CONFIG_BACKLIGHT_GENERIC is not set
> > # CONFIG_BACKLIGHT_PWM is not set
> > CONFIG_BACKLIGHT_APPLE=m
> > # CONFIG_BACKLIGHT_PM8941_WLED is not set
> > # CONFIG_BACKLIGHT_SAHARA is not set
> > # CONFIG_BACKLIGHT_ADP8860 is not set
> > # CONFIG_BACKLIGHT_ADP8870 is not set
> > # CONFIG_BACKLIGHT_LM3630A is not set
> > # CONFIG_BACKLIGHT_LM3639 is not set
> > CONFIG_BACKLIGHT_LP855X=m
> > # CONFIG_BACKLIGHT_GPIO is not set
> > # CONFIG_BACKLIGHT_LV5207LP is not set
> > # CONFIG_BACKLIGHT_BD6107 is not set
> > # CONFIG_BACKLIGHT_ARCXCNN is not set
> > CONFIG_HDMI=y
> > 
> > #
> > # Console display driver support
> > #
> > CONFIG_VGA_CONSOLE=y
> > CONFIG_VGACON_SOFT_SCROLLBACK=y
> > CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> > # CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
> > CONFIG_DUMMY_CONSOLE=y
> > CONFIG_DUMMY_CONSOLE_COLUMNS=80
> > CONFIG_DUMMY_CONSOLE_ROWS=25
> > CONFIG_FRAMEBUFFER_CONSOLE=y
> > CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> > CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> > # CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
> > CONFIG_LOGO=y
> > # CONFIG_LOGO_LINUX_MONO is not set
> > # CONFIG_LOGO_LINUX_VGA16 is not set
> > CONFIG_LOGO_LINUX_CLUT224=y
> > # CONFIG_SOUND is not set
> > 
> > #
> > # HID support
> > #
> > CONFIG_HID=y
> > CONFIG_HID_BATTERY_STRENGTH=y
> > CONFIG_HIDRAW=y
> > CONFIG_UHID=m
> > CONFIG_HID_GENERIC=y
> > 
> > #
> > # Special HID drivers
> > #
> > CONFIG_HID_A4TECH=m
> > # CONFIG_HID_ACCUTOUCH is not set
> > CONFIG_HID_ACRUX=m
> > # CONFIG_HID_ACRUX_FF is not set
> > CONFIG_HID_APPLE=m
> > # CONFIG_HID_APPLEIR is not set
> > CONFIG_HID_ASUS=m
> > CONFIG_HID_AUREAL=m
> > CONFIG_HID_BELKIN=m
> > # CONFIG_HID_BETOP_FF is not set
> > CONFIG_HID_CHERRY=m
> > CONFIG_HID_CHICONY=m
> > # CONFIG_HID_CORSAIR is not set
> > # CONFIG_HID_COUGAR is not set
> > CONFIG_HID_CMEDIA=m
> > # CONFIG_HID_CP2112 is not set
> > CONFIG_HID_CYPRESS=m
> > CONFIG_HID_DRAGONRISE=m
> > # CONFIG_DRAGONRISE_FF is not set
> > # CONFIG_HID_EMS_FF is not set
> > # CONFIG_HID_ELAN is not set
> > CONFIG_HID_ELECOM=m
> > # CONFIG_HID_ELO is not set
> > CONFIG_HID_EZKEY=m
> > CONFIG_HID_GEMBIRD=m
> > CONFIG_HID_GFRM=m
> > # CONFIG_HID_HOLTEK is not set
> > # CONFIG_HID_GOOGLE_HAMMER is not set
> > # CONFIG_HID_GT683R is not set
> > CONFIG_HID_KEYTOUCH=m
> > CONFIG_HID_KYE=m
> > # CONFIG_HID_UCLOGIC is not set
> > CONFIG_HID_WALTOP=m
> > CONFIG_HID_GYRATION=m
> > CONFIG_HID_ICADE=m
> > CONFIG_HID_ITE=m
> > CONFIG_HID_JABRA=m
> > CONFIG_HID_TWINHAN=m
> > CONFIG_HID_KENSINGTON=m
> > CONFIG_HID_LCPOWER=m
> > CONFIG_HID_LED=m
> > CONFIG_HID_LENOVO=m
> > CONFIG_HID_LOGITECH=m
> > CONFIG_HID_LOGITECH_DJ=m
> > CONFIG_HID_LOGITECH_HIDPP=m
> > # CONFIG_LOGITECH_FF is not set
> > # CONFIG_LOGIRUMBLEPAD2_FF is not set
> > # CONFIG_LOGIG940_FF is not set
> > # CONFIG_LOGIWHEELS_FF is not set
> > CONFIG_HID_MAGICMOUSE=y
> > # CONFIG_HID_MAYFLASH is not set
> > # CONFIG_HID_REDRAGON is not set
> > CONFIG_HID_MICROSOFT=m
> > CONFIG_HID_MONTEREY=m
> > CONFIG_HID_MULTITOUCH=m
> > CONFIG_HID_NTI=m
> > # CONFIG_HID_NTRIG is not set
> > CONFIG_HID_ORTEK=m
> > CONFIG_HID_PANTHERLORD=m
> > # CONFIG_PANTHERLORD_FF is not set
> > # CONFIG_HID_PENMOUNT is not set
> > CONFIG_HID_PETALYNX=m
> > CONFIG_HID_PICOLCD=m
> > CONFIG_HID_PICOLCD_FB=y
> > CONFIG_HID_PICOLCD_BACKLIGHT=y
> > CONFIG_HID_PICOLCD_LCD=y
> > CONFIG_HID_PICOLCD_LEDS=y
> > CONFIG_HID_PICOLCD_CIR=y
> > CONFIG_HID_PLANTRONICS=m
> > CONFIG_HID_PRIMAX=m
> > # CONFIG_HID_RETRODE is not set
> > # CONFIG_HID_ROCCAT is not set
> > CONFIG_HID_SAITEK=m
> > CONFIG_HID_SAMSUNG=m
> > # CONFIG_HID_SONY is not set
> > CONFIG_HID_SPEEDLINK=m
> > # CONFIG_HID_STEAM is not set
> > CONFIG_HID_STEELSERIES=m
> > CONFIG_HID_SUNPLUS=m
> > CONFIG_HID_RMI=m
> > CONFIG_HID_GREENASIA=m
> > # CONFIG_GREENASIA_FF is not set
> > CONFIG_HID_HYPERV_MOUSE=m
> > CONFIG_HID_SMARTJOYPLUS=m
> > # CONFIG_SMARTJOYPLUS_FF is not set
> > CONFIG_HID_TIVO=m
> > CONFIG_HID_TOPSEED=m
> > CONFIG_HID_THINGM=m
> > CONFIG_HID_THRUSTMASTER=m
> > # CONFIG_THRUSTMASTER_FF is not set
> > # CONFIG_HID_UDRAW_PS3 is not set
> > # CONFIG_HID_WACOM is not set
> > CONFIG_HID_WIIMOTE=m
> > CONFIG_HID_XINMO=m
> > CONFIG_HID_ZEROPLUS=m
> > # CONFIG_ZEROPLUS_FF is not set
> > CONFIG_HID_ZYDACRON=m
> > CONFIG_HID_SENSOR_HUB=y
> > CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
> > CONFIG_HID_ALPS=m
> > 
> > #
> > # USB HID support
> > #
> > CONFIG_USB_HID=y
> > # CONFIG_HID_PID is not set
> > # CONFIG_USB_HIDDEV is not set
> > 
> > #
> > # I2C HID support
> > #
> > CONFIG_I2C_HID=m
> > 
> > #
> > # Intel ISH HID support
> > #
> > CONFIG_INTEL_ISH_HID=m
> > CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> > CONFIG_USB_SUPPORT=y
> > CONFIG_USB_COMMON=y
> > CONFIG_USB_ARCH_HAS_HCD=y
> > CONFIG_USB=y
> > CONFIG_USB_PCI=y
> > CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> > 
> > #
> > # Miscellaneous USB options
> > #
> > CONFIG_USB_DEFAULT_PERSIST=y
> > # CONFIG_USB_DYNAMIC_MINORS is not set
> > # CONFIG_USB_OTG is not set
> > # CONFIG_USB_OTG_WHITELIST is not set
> > # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> > CONFIG_USB_LEDS_TRIGGER_USBPORT=y
> > CONFIG_USB_MON=y
> > CONFIG_USB_WUSB_CBAF=m
> > # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> > 
> > #
> > # USB Host Controller Drivers
> > #
> > # CONFIG_USB_C67X00_HCD is not set
> > CONFIG_USB_XHCI_HCD=y
> > # CONFIG_USB_XHCI_DBGCAP is not set
> > CONFIG_USB_XHCI_PCI=y
> > # CONFIG_USB_XHCI_PLATFORM is not set
> > CONFIG_USB_EHCI_HCD=y
> > CONFIG_USB_EHCI_ROOT_HUB_TT=y
> > CONFIG_USB_EHCI_TT_NEWSCHED=y
> > CONFIG_USB_EHCI_PCI=y
> > # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> > # CONFIG_USB_OXU210HP_HCD is not set
> > # CONFIG_USB_ISP116X_HCD is not set
> > # CONFIG_USB_FOTG210_HCD is not set
> > # CONFIG_USB_MAX3421_HCD is not set
> > CONFIG_USB_OHCI_HCD=y
> > CONFIG_USB_OHCI_HCD_PCI=y
> > # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> > CONFIG_USB_UHCI_HCD=y
> > # CONFIG_USB_SL811_HCD is not set
> > # CONFIG_USB_R8A66597_HCD is not set
> > # CONFIG_USB_HCD_BCMA is not set
> > # CONFIG_USB_HCD_TEST_MODE is not set
> > 
> > #
> > # USB Device Class drivers
> > #
> > # CONFIG_USB_ACM is not set
> > # CONFIG_USB_PRINTER is not set
> > # CONFIG_USB_WDM is not set
> > # CONFIG_USB_TMC is not set
> > 
> > #
> > # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> > #
> > 
> > #
> > # also be needed; see USB_STORAGE Help for more info
> > #
> > CONFIG_USB_STORAGE=m
> > # CONFIG_USB_STORAGE_DEBUG is not set
> > # CONFIG_USB_STORAGE_REALTEK is not set
> > # CONFIG_USB_STORAGE_DATAFAB is not set
> > # CONFIG_USB_STORAGE_FREECOM is not set
> > # CONFIG_USB_STORAGE_ISD200 is not set
> > # CONFIG_USB_STORAGE_USBAT is not set
> > # CONFIG_USB_STORAGE_SDDR09 is not set
> > # CONFIG_USB_STORAGE_SDDR55 is not set
> > # CONFIG_USB_STORAGE_JUMPSHOT is not set
> > # CONFIG_USB_STORAGE_ALAUDA is not set
> > # CONFIG_USB_STORAGE_ONETOUCH is not set
> > # CONFIG_USB_STORAGE_KARMA is not set
> > # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> > # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> > # CONFIG_USB_UAS is not set
> > 
> > #
> > # USB Imaging devices
> > #
> > # CONFIG_USB_MDC800 is not set
> > # CONFIG_USB_MICROTEK is not set
> > # CONFIG_USBIP_CORE is not set
> > # CONFIG_USB_MUSB_HDRC is not set
> > # CONFIG_USB_DWC3 is not set
> > # CONFIG_USB_DWC2 is not set
> > # CONFIG_USB_CHIPIDEA is not set
> > # CONFIG_USB_ISP1760 is not set
> > 
> > #
> > # USB port drivers
> > #
> > # CONFIG_USB_USS720 is not set
> > CONFIG_USB_SERIAL=m
> > CONFIG_USB_SERIAL_GENERIC=y
> > # CONFIG_USB_SERIAL_SIMPLE is not set
> > # CONFIG_USB_SERIAL_AIRCABLE is not set
> > # CONFIG_USB_SERIAL_ARK3116 is not set
> > # CONFIG_USB_SERIAL_BELKIN is not set
> > # CONFIG_USB_SERIAL_CH341 is not set
> > # CONFIG_USB_SERIAL_WHITEHEAT is not set
> > # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> > # CONFIG_USB_SERIAL_CP210X is not set
> > # CONFIG_USB_SERIAL_CYPRESS_M8 is not set
> > # CONFIG_USB_SERIAL_EMPEG is not set
> > # CONFIG_USB_SERIAL_FTDI_SIO is not set
> > # CONFIG_USB_SERIAL_VISOR is not set
> > # CONFIG_USB_SERIAL_IPAQ is not set
> > # CONFIG_USB_SERIAL_IR is not set
> > # CONFIG_USB_SERIAL_EDGEPORT is not set
> > # CONFIG_USB_SERIAL_EDGEPORT_TI is not set
> > # CONFIG_USB_SERIAL_F81232 is not set
> > # CONFIG_USB_SERIAL_F8153X is not set
> > # CONFIG_USB_SERIAL_GARMIN is not set
> > # CONFIG_USB_SERIAL_IPW is not set
> > # CONFIG_USB_SERIAL_IUU is not set
> > # CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
> > # CONFIG_USB_SERIAL_KEYSPAN is not set
> > # CONFIG_USB_SERIAL_KLSI is not set
> > # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> > # CONFIG_USB_SERIAL_MCT_U232 is not set
> > # CONFIG_USB_SERIAL_METRO is not set
> > # CONFIG_USB_SERIAL_MOS7720 is not set
> > # CONFIG_USB_SERIAL_MOS7840 is not set
> > # CONFIG_USB_SERIAL_MXUPORT is not set
> > # CONFIG_USB_SERIAL_NAVMAN is not set
> > # CONFIG_USB_SERIAL_PL2303 is not set
> > # CONFIG_USB_SERIAL_OTI6858 is not set
> > # CONFIG_USB_SERIAL_QCAUX is not set
> > # CONFIG_USB_SERIAL_QUALCOMM is not set
> > # CONFIG_USB_SERIAL_SPCP8X5 is not set
> > # CONFIG_USB_SERIAL_SAFE is not set
> > # CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
> > # CONFIG_USB_SERIAL_SYMBOL is not set
> > # CONFIG_USB_SERIAL_TI is not set
> > # CONFIG_USB_SERIAL_CYBERJACK is not set
> > # CONFIG_USB_SERIAL_XIRCOM is not set
> > # CONFIG_USB_SERIAL_OPTION is not set
> > # CONFIG_USB_SERIAL_OMNINET is not set
> > # CONFIG_USB_SERIAL_OPTICON is not set
> > # CONFIG_USB_SERIAL_XSENS_MT is not set
> > # CONFIG_USB_SERIAL_WISHBONE is not set
> > # CONFIG_USB_SERIAL_SSU100 is not set
> > # CONFIG_USB_SERIAL_QT2 is not set
> > # CONFIG_USB_SERIAL_UPD78F0730 is not set
> > CONFIG_USB_SERIAL_DEBUG=m
> > 
> > #
> > # USB Miscellaneous drivers
> > #
> > # CONFIG_USB_EMI62 is not set
> > # CONFIG_USB_EMI26 is not set
> > # CONFIG_USB_ADUTUX is not set
> > # CONFIG_USB_SEVSEG is not set
> > # CONFIG_USB_RIO500 is not set
> > # CONFIG_USB_LEGOTOWER is not set
> > # CONFIG_USB_LCD is not set
> > # CONFIG_USB_CYPRESS_CY7C63 is not set
> > # CONFIG_USB_CYTHERM is not set
> > # CONFIG_USB_IDMOUSE is not set
> > # CONFIG_USB_FTDI_ELAN is not set
> > # CONFIG_USB_APPLEDISPLAY is not set
> > # CONFIG_USB_SISUSBVGA is not set
> > # CONFIG_USB_LD is not set
> > # CONFIG_USB_TRANCEVIBRATOR is not set
> > # CONFIG_USB_IOWARRIOR is not set
> > # CONFIG_USB_TEST is not set
> > # CONFIG_USB_EHSET_TEST_FIXTURE is not set
> > # CONFIG_USB_ISIGHTFW is not set
> > # CONFIG_USB_YUREX is not set
> > # CONFIG_USB_EZUSB_FX2 is not set
> > # CONFIG_USB_HUB_USB251XB is not set
> > # CONFIG_USB_HSIC_USB3503 is not set
> > # CONFIG_USB_HSIC_USB4604 is not set
> > # CONFIG_USB_LINK_LAYER_TEST is not set
> > # CONFIG_USB_CHAOSKEY is not set
> > # CONFIG_USB_ATM is not set
> > 
> > #
> > # USB Physical Layer drivers
> > #
> > # CONFIG_NOP_USB_XCEIV is not set
> > # CONFIG_USB_GPIO_VBUS is not set
> > # CONFIG_USB_ISP1301 is not set
> > # CONFIG_USB_GADGET is not set
> > CONFIG_TYPEC=y
> > # CONFIG_TYPEC_TCPM is not set
> > CONFIG_TYPEC_UCSI=y
> > CONFIG_UCSI_ACPI=y
> > # CONFIG_TYPEC_TPS6598X is not set
> > 
> > #
> > # USB Type-C Multiplexer/DeMultiplexer Switch support
> > #
> > # CONFIG_TYPEC_MUX_PI3USB30532 is not set
> > 
> > #
> > # USB Type-C Alternate Mode drivers
> > #
> > # CONFIG_TYPEC_DP_ALTMODE is not set
> > # CONFIG_USB_ROLE_SWITCH is not set
> > # CONFIG_USB_LED_TRIG is not set
> > # CONFIG_USB_ULPI_BUS is not set
> > # CONFIG_UWB is not set
> > CONFIG_MMC=m
> > CONFIG_MMC_BLOCK=m
> > CONFIG_MMC_BLOCK_MINORS=8
> > CONFIG_SDIO_UART=m
> > # CONFIG_MMC_TEST is not set
> > 
> > #
> > # MMC/SD/SDIO Host Controller Drivers
> > #
> > # CONFIG_MMC_DEBUG is not set
> > CONFIG_MMC_SDHCI=m
> > CONFIG_MMC_SDHCI_PCI=m
> > CONFIG_MMC_RICOH_MMC=y
> > CONFIG_MMC_SDHCI_ACPI=m
> > CONFIG_MMC_SDHCI_PLTFM=m
> > # CONFIG_MMC_SDHCI_F_SDH30 is not set
> > # CONFIG_MMC_WBSD is not set
> > # CONFIG_MMC_TIFM_SD is not set
> > # CONFIG_MMC_SPI is not set
> > # CONFIG_MMC_CB710 is not set
> > # CONFIG_MMC_VIA_SDMMC is not set
> > # CONFIG_MMC_VUB300 is not set
> > # CONFIG_MMC_USHC is not set
> > # CONFIG_MMC_USDHI6ROL0 is not set
> > # CONFIG_MMC_REALTEK_PCI is not set
> > CONFIG_MMC_CQHCI=m
> > # CONFIG_MMC_TOSHIBA_PCI is not set
> > # CONFIG_MMC_MTK is not set
> > # CONFIG_MMC_SDHCI_XENON is not set
> > # CONFIG_MEMSTICK is not set
> > CONFIG_NEW_LEDS=y
> > CONFIG_LEDS_CLASS=y
> > # CONFIG_LEDS_CLASS_FLASH is not set
> > # CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set
> > 
> > #
> > # LED drivers
> > #
> > # CONFIG_LEDS_APU is not set
> > CONFIG_LEDS_LM3530=m
> > # CONFIG_LEDS_LM3642 is not set
> > # CONFIG_LEDS_PCA9532 is not set
> > # CONFIG_LEDS_GPIO is not set
> > CONFIG_LEDS_LP3944=m
> > # CONFIG_LEDS_LP3952 is not set
> > CONFIG_LEDS_LP55XX_COMMON=m
> > CONFIG_LEDS_LP5521=m
> > CONFIG_LEDS_LP5523=m
> > CONFIG_LEDS_LP5562=m
> > # CONFIG_LEDS_LP8501 is not set
> > CONFIG_LEDS_CLEVO_MAIL=m
> > # CONFIG_LEDS_PCA955X is not set
> > # CONFIG_LEDS_PCA963X is not set
> > # CONFIG_LEDS_DAC124S085 is not set
> > # CONFIG_LEDS_PWM is not set
> > # CONFIG_LEDS_BD2802 is not set
> > CONFIG_LEDS_INTEL_SS4200=m
> > CONFIG_LEDS_LT3593=m
> > # CONFIG_LEDS_TCA6507 is not set
> > # CONFIG_LEDS_TLC591XX is not set
> > # CONFIG_LEDS_LM355x is not set
> > 
> > #
> > # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> > #
> > CONFIG_LEDS_BLINKM=m
> > CONFIG_LEDS_MLXCPLD=m
> > # CONFIG_LEDS_MLXREG is not set
> > # CONFIG_LEDS_USER is not set
> > # CONFIG_LEDS_NIC78BX is not set
> > 
> > #
> > # LED Triggers
> > #
> > CONFIG_LEDS_TRIGGERS=y
> > CONFIG_LEDS_TRIGGER_TIMER=m
> > CONFIG_LEDS_TRIGGER_ONESHOT=m
> > # CONFIG_LEDS_TRIGGER_DISK is not set
> > CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> > CONFIG_LEDS_TRIGGER_BACKLIGHT=m
> > # CONFIG_LEDS_TRIGGER_CPU is not set
> > # CONFIG_LEDS_TRIGGER_ACTIVITY is not set
> > CONFIG_LEDS_TRIGGER_GPIO=m
> > CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
> > 
> > #
> > # iptables trigger is under Netfilter config (LED target)
> > #
> > CONFIG_LEDS_TRIGGER_TRANSIENT=m
> > CONFIG_LEDS_TRIGGER_CAMERA=m
> > # CONFIG_LEDS_TRIGGER_PANIC is not set
> > # CONFIG_LEDS_TRIGGER_NETDEV is not set
> > # CONFIG_ACCESSIBILITY is not set
> > # CONFIG_INFINIBAND is not set
> > CONFIG_EDAC_ATOMIC_SCRUB=y
> > CONFIG_EDAC_SUPPORT=y
> > CONFIG_EDAC=y
> > CONFIG_EDAC_LEGACY_SYSFS=y
> > # CONFIG_EDAC_DEBUG is not set
> > CONFIG_EDAC_DECODE_MCE=m
> > CONFIG_EDAC_GHES=y
> > CONFIG_EDAC_AMD64=m
> > # CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
> > CONFIG_EDAC_E752X=m
> > CONFIG_EDAC_I82975X=m
> > CONFIG_EDAC_I3000=m
> > CONFIG_EDAC_I3200=m
> > CONFIG_EDAC_IE31200=m
> > CONFIG_EDAC_X38=m
> > CONFIG_EDAC_I5400=m
> > CONFIG_EDAC_I7CORE=m
> > CONFIG_EDAC_I5000=m
> > CONFIG_EDAC_I5100=m
> > CONFIG_EDAC_I7300=m
> > CONFIG_EDAC_SBRIDGE=m
> > CONFIG_EDAC_SKX=m
> > CONFIG_EDAC_PND2=m
> > CONFIG_RTC_LIB=y
> > CONFIG_RTC_MC146818_LIB=y
> > CONFIG_RTC_CLASS=y
> > CONFIG_RTC_HCTOSYS=y
> > CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> > # CONFIG_RTC_SYSTOHC is not set
> > # CONFIG_RTC_DEBUG is not set
> > CONFIG_RTC_NVMEM=y
> > 
> > #
> > # RTC interfaces
> > #
> > CONFIG_RTC_INTF_SYSFS=y
> > CONFIG_RTC_INTF_PROC=y
> > CONFIG_RTC_INTF_DEV=y
> > # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> > # CONFIG_RTC_DRV_TEST is not set
> > 
> > #
> > # I2C RTC drivers
> > #
> > # CONFIG_RTC_DRV_ABB5ZES3 is not set
> > # CONFIG_RTC_DRV_ABX80X is not set
> > CONFIG_RTC_DRV_DS1307=m
> > # CONFIG_RTC_DRV_DS1307_CENTURY is not set
> > CONFIG_RTC_DRV_DS1374=m
> > # CONFIG_RTC_DRV_DS1374_WDT is not set
> > CONFIG_RTC_DRV_DS1672=m
> > CONFIG_RTC_DRV_MAX6900=m
> > CONFIG_RTC_DRV_RS5C372=m
> > CONFIG_RTC_DRV_ISL1208=m
> > CONFIG_RTC_DRV_ISL12022=m
> > CONFIG_RTC_DRV_X1205=m
> > CONFIG_RTC_DRV_PCF8523=m
> > # CONFIG_RTC_DRV_PCF85063 is not set
> > # CONFIG_RTC_DRV_PCF85363 is not set
> > CONFIG_RTC_DRV_PCF8563=m
> > CONFIG_RTC_DRV_PCF8583=m
> > CONFIG_RTC_DRV_M41T80=m
> > CONFIG_RTC_DRV_M41T80_WDT=y
> > CONFIG_RTC_DRV_BQ32K=m
> > # CONFIG_RTC_DRV_S35390A is not set
> > CONFIG_RTC_DRV_FM3130=m
> > # CONFIG_RTC_DRV_RX8010 is not set
> > CONFIG_RTC_DRV_RX8581=m
> > CONFIG_RTC_DRV_RX8025=m
> > CONFIG_RTC_DRV_EM3027=m
> > # CONFIG_RTC_DRV_RV8803 is not set
> > 
> > #
> > # SPI RTC drivers
> > #
> > # CONFIG_RTC_DRV_M41T93 is not set
> > # CONFIG_RTC_DRV_M41T94 is not set
> > # CONFIG_RTC_DRV_DS1302 is not set
> > # CONFIG_RTC_DRV_DS1305 is not set
> > # CONFIG_RTC_DRV_DS1343 is not set
> > # CONFIG_RTC_DRV_DS1347 is not set
> > # CONFIG_RTC_DRV_DS1390 is not set
> > # CONFIG_RTC_DRV_MAX6916 is not set
> > # CONFIG_RTC_DRV_R9701 is not set
> > CONFIG_RTC_DRV_RX4581=m
> > # CONFIG_RTC_DRV_RX6110 is not set
> > # CONFIG_RTC_DRV_RS5C348 is not set
> > # CONFIG_RTC_DRV_MAX6902 is not set
> > # CONFIG_RTC_DRV_PCF2123 is not set
> > # CONFIG_RTC_DRV_MCP795 is not set
> > CONFIG_RTC_I2C_AND_SPI=y
> > 
> > #
> > # SPI and I2C RTC drivers
> > #
> > CONFIG_RTC_DRV_DS3232=m
> > CONFIG_RTC_DRV_DS3232_HWMON=y
> > # CONFIG_RTC_DRV_PCF2127 is not set
> > CONFIG_RTC_DRV_RV3029C2=m
> > # CONFIG_RTC_DRV_RV3029_HWMON is not set
> > 
> > #
> > # Platform RTC drivers
> > #
> > CONFIG_RTC_DRV_CMOS=y
> > CONFIG_RTC_DRV_DS1286=m
> > CONFIG_RTC_DRV_DS1511=m
> > CONFIG_RTC_DRV_DS1553=m
> > # CONFIG_RTC_DRV_DS1685_FAMILY is not set
> > CONFIG_RTC_DRV_DS1742=m
> > CONFIG_RTC_DRV_DS2404=m
> > CONFIG_RTC_DRV_STK17TA8=m
> > # CONFIG_RTC_DRV_M48T86 is not set
> > CONFIG_RTC_DRV_M48T35=m
> > CONFIG_RTC_DRV_M48T59=m
> > CONFIG_RTC_DRV_MSM6242=m
> > CONFIG_RTC_DRV_BQ4802=m
> > CONFIG_RTC_DRV_RP5C01=m
> > CONFIG_RTC_DRV_V3020=m
> > 
> > #
> > # on-CPU RTC drivers
> > #
> > # CONFIG_RTC_DRV_FTRTC010 is not set
> > 
> > #
> > # HID Sensor RTC drivers
> > #
> > # CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
> > CONFIG_DMADEVICES=y
> > # CONFIG_DMADEVICES_DEBUG is not set
> > 
> > #
> > # DMA Devices
> > #
> > CONFIG_DMA_ENGINE=y
> > CONFIG_DMA_VIRTUAL_CHANNELS=y
> > CONFIG_DMA_ACPI=y
> > # CONFIG_ALTERA_MSGDMA is not set
> > CONFIG_INTEL_IDMA64=m
> > CONFIG_INTEL_IOATDMA=m
> > # CONFIG_QCOM_HIDMA_MGMT is not set
> > # CONFIG_QCOM_HIDMA is not set
> > CONFIG_DW_DMAC_CORE=y
> > CONFIG_DW_DMAC=m
> > CONFIG_DW_DMAC_PCI=y
> > CONFIG_HSU_DMA=y
> > 
> > #
> > # DMA Clients
> > #
> > CONFIG_ASYNC_TX_DMA=y
> > CONFIG_DMATEST=m
> > CONFIG_DMA_ENGINE_RAID=y
> > 
> > #
> > # DMABUF options
> > #
> > CONFIG_SYNC_FILE=y
> > CONFIG_SW_SYNC=y
> > CONFIG_DCA=m
> > # CONFIG_AUXDISPLAY is not set
> > # CONFIG_PANEL is not set
> > CONFIG_UIO=m
> > CONFIG_UIO_CIF=m
> > CONFIG_UIO_PDRV_GENIRQ=m
> > # CONFIG_UIO_DMEM_GENIRQ is not set
> > CONFIG_UIO_AEC=m
> > CONFIG_UIO_SERCOS3=m
> > CONFIG_UIO_PCI_GENERIC=m
> > # CONFIG_UIO_NETX is not set
> > # CONFIG_UIO_PRUSS is not set
> > # CONFIG_UIO_MF624 is not set
> > CONFIG_UIO_HV_GENERIC=m
> > CONFIG_VFIO_IOMMU_TYPE1=m
> > CONFIG_VFIO_VIRQFD=m
> > CONFIG_VFIO=m
> > CONFIG_VFIO_NOIOMMU=y
> > CONFIG_VFIO_PCI=m
> > # CONFIG_VFIO_PCI_VGA is not set
> > CONFIG_VFIO_PCI_MMAP=y
> > CONFIG_VFIO_PCI_INTX=y
> > # CONFIG_VFIO_PCI_IGD is not set
> > CONFIG_VFIO_MDEV=m
> > CONFIG_VFIO_MDEV_DEVICE=m
> > CONFIG_IRQ_BYPASS_MANAGER=y
> > # CONFIG_VIRT_DRIVERS is not set
> > CONFIG_VIRTIO=y
> > CONFIG_VIRTIO_MENU=y
> > CONFIG_VIRTIO_PCI=y
> > CONFIG_VIRTIO_PCI_LEGACY=y
> > CONFIG_VIRTIO_BALLOON=m
> > CONFIG_VIRTIO_INPUT=m
> > # CONFIG_VIRTIO_MMIO is not set
> > 
> > #
> > # Microsoft Hyper-V guest support
> > #
> > CONFIG_HYPERV=m
> > CONFIG_HYPERV_TSCPAGE=y
> > CONFIG_HYPERV_UTILS=m
> > CONFIG_HYPERV_BALLOON=m
> > 
> > #
> > # Xen driver support
> > #
> > # CONFIG_XEN_BALLOON is not set
> > CONFIG_XEN_DEV_EVTCHN=m
> > CONFIG_XENFS=m
> > CONFIG_XEN_COMPAT_XENFS=y
> > CONFIG_XEN_SYS_HYPERVISOR=y
> > CONFIG_XEN_XENBUS_FRONTEND=y
> > # CONFIG_XEN_GNTDEV is not set
> > # CONFIG_XEN_GRANT_DEV_ALLOC is not set
> > # CONFIG_XEN_GRANT_DMA_ALLOC is not set
> > CONFIG_SWIOTLB_XEN=y
> > CONFIG_XEN_TMEM=m
> > # CONFIG_XEN_PVCALLS_FRONTEND is not set
> > CONFIG_XEN_PRIVCMD=m
> > CONFIG_XEN_EFI=y
> > CONFIG_XEN_AUTO_XLATE=y
> > CONFIG_XEN_ACPI=y
> > CONFIG_STAGING=y
> > # CONFIG_PRISM2_USB is not set
> > # CONFIG_COMEDI is not set
> > # CONFIG_RTL8192U is not set
> > # CONFIG_RTLLIB is not set
> > # CONFIG_RTL8723BS is not set
> > # CONFIG_R8712U is not set
> > # CONFIG_R8188EU is not set
> > # CONFIG_R8822BE is not set
> > # CONFIG_RTS5208 is not set
> > # CONFIG_VT6655 is not set
> > # CONFIG_VT6656 is not set
> > # CONFIG_FB_SM750 is not set
> > # CONFIG_FB_XGI is not set
> > 
> > #
> > # Speakup console speech
> > #
> > # CONFIG_SPEAKUP is not set
> > # CONFIG_STAGING_MEDIA is not set
> > 
> > #
> > # Android
> > #
> > # CONFIG_ASHMEM is not set
> > # CONFIG_ANDROID_VSOC is not set
> > CONFIG_ION=y
> > CONFIG_ION_SYSTEM_HEAP=y
> > # CONFIG_ION_CARVEOUT_HEAP is not set
> > # CONFIG_ION_CHUNK_HEAP is not set
> > # CONFIG_LTE_GDM724X is not set
> > # CONFIG_FIREWIRE_SERIAL is not set
> > # CONFIG_DGNC is not set
> > # CONFIG_GS_FPGABOOT is not set
> > # CONFIG_UNISYSSPAR is not set
> > # CONFIG_FB_TFT is not set
> > # CONFIG_WILC1000_SDIO is not set
> > # CONFIG_WILC1000_SPI is not set
> > # CONFIG_MOST is not set
> > # CONFIG_KS7010 is not set
> > # CONFIG_GREYBUS is not set
> > # CONFIG_DRM_VBOXVIDEO is not set
> > # CONFIG_PI433 is not set
> > # CONFIG_MTK_MMC is not set
> > 
> > #
> > # Gasket devices
> > #
> > # CONFIG_STAGING_GASKET_FRAMEWORK is not set
> > # CONFIG_EROFS_FS is not set
> > CONFIG_X86_PLATFORM_DEVICES=y
> > CONFIG_ACER_WMI=m
> > # CONFIG_ACER_WIRELESS is not set
> > CONFIG_ACERHDF=m
> > # CONFIG_ALIENWARE_WMI is not set
> > CONFIG_ASUS_LAPTOP=m
> > CONFIG_DELL_SMBIOS=m
> > CONFIG_DELL_SMBIOS_WMI=y
> > # CONFIG_DELL_SMBIOS_SMM is not set
> > CONFIG_DELL_LAPTOP=m
> > CONFIG_DELL_WMI=m
> > CONFIG_DELL_WMI_DESCRIPTOR=m
> > CONFIG_DELL_WMI_AIO=m
> > CONFIG_DELL_WMI_LED=m
> > CONFIG_DELL_SMO8800=m
> > CONFIG_DELL_RBTN=m
> > CONFIG_FUJITSU_LAPTOP=m
> > CONFIG_FUJITSU_TABLET=m
> > CONFIG_AMILO_RFKILL=m
> > # CONFIG_GPD_POCKET_FAN is not set
> > CONFIG_HP_ACCEL=m
> > CONFIG_HP_WIRELESS=m
> > CONFIG_HP_WMI=m
> > CONFIG_MSI_LAPTOP=m
> > CONFIG_PANASONIC_LAPTOP=m
> > CONFIG_COMPAL_LAPTOP=m
> > CONFIG_SONY_LAPTOP=m
> > CONFIG_SONYPI_COMPAT=y
> > CONFIG_IDEAPAD_LAPTOP=m
> > # CONFIG_SURFACE3_WMI is not set
> > CONFIG_THINKPAD_ACPI=m
> > # CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
> > # CONFIG_THINKPAD_ACPI_DEBUG is not set
> > # CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
> > CONFIG_THINKPAD_ACPI_VIDEO=y
> > CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
> > CONFIG_SENSORS_HDAPS=m
> > # CONFIG_INTEL_MENLOW is not set
> > CONFIG_EEEPC_LAPTOP=m
> > CONFIG_ASUS_WMI=m
> > CONFIG_ASUS_NB_WMI=m
> > CONFIG_EEEPC_WMI=m
> > # CONFIG_ASUS_WIRELESS is not set
> > CONFIG_ACPI_WMI=m
> > CONFIG_WMI_BMOF=m
> > CONFIG_INTEL_WMI_THUNDERBOLT=m
> > CONFIG_MSI_WMI=m
> > # CONFIG_PEAQ_WMI is not set
> > CONFIG_TOPSTAR_LAPTOP=m
> > CONFIG_TOSHIBA_BT_RFKILL=m
> > # CONFIG_TOSHIBA_HAPS is not set
> > # CONFIG_TOSHIBA_WMI is not set
> > CONFIG_ACPI_CMPC=m
> > # CONFIG_INTEL_INT0002_VGPIO is not set
> > CONFIG_INTEL_HID_EVENT=m
> > CONFIG_INTEL_VBTN=m
> > CONFIG_INTEL_IPS=m
> > CONFIG_INTEL_PMC_CORE=m
> > # CONFIG_IBM_RTL is not set
> > CONFIG_SAMSUNG_LAPTOP=m
> > CONFIG_MXM_WMI=m
> > CONFIG_INTEL_OAKTRAIL=m
> > CONFIG_SAMSUNG_Q10=m
> > CONFIG_APPLE_GMUX=m
> > CONFIG_INTEL_RST=m
> > # CONFIG_INTEL_SMARTCONNECT is not set
> > CONFIG_PVPANIC=y
> > # CONFIG_INTEL_PMC_IPC is not set
> > # CONFIG_SURFACE_PRO3_BUTTON is not set
> > # CONFIG_INTEL_PUNIT_IPC is not set
> > CONFIG_MLX_PLATFORM=m
> > CONFIG_INTEL_TURBO_MAX_3=y
> > # CONFIG_I2C_MULTI_INSTANTIATE is not set
> > # CONFIG_INTEL_ATOMISP2_PM is not set
> > CONFIG_PMC_ATOM=y
> > # CONFIG_CHROME_PLATFORMS is not set
> > CONFIG_MELLANOX_PLATFORM=y
> > CONFIG_MLXREG_HOTPLUG=m
> > # CONFIG_MLXREG_IO is not set
> > CONFIG_CLKDEV_LOOKUP=y
> > CONFIG_HAVE_CLK_PREPARE=y
> > CONFIG_COMMON_CLK=y
> > 
> > #
> > # Common Clock Framework
> > #
> > # CONFIG_COMMON_CLK_MAX9485 is not set
> > # CONFIG_COMMON_CLK_SI5351 is not set
> > # CONFIG_COMMON_CLK_SI544 is not set
> > # CONFIG_COMMON_CLK_CDCE706 is not set
> > # CONFIG_COMMON_CLK_CS2000_CP is not set
> > # CONFIG_COMMON_CLK_PWM is not set
> > CONFIG_HWSPINLOCK=y
> > 
> > #
> > # Clock Source drivers
> > #
> > CONFIG_CLKEVT_I8253=y
> > CONFIG_I8253_LOCK=y
> > CONFIG_CLKBLD_I8253=y
> > CONFIG_MAILBOX=y
> > CONFIG_PCC=y
> > # CONFIG_ALTERA_MBOX is not set
> > CONFIG_IOMMU_API=y
> > CONFIG_IOMMU_SUPPORT=y
> > 
> > #
> > # Generic IOMMU Pagetable Support
> > #
> > # CONFIG_IOMMU_DEBUGFS is not set
> > # CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
> > CONFIG_IOMMU_IOVA=y
> > CONFIG_AMD_IOMMU=y
> > CONFIG_AMD_IOMMU_V2=m
> > CONFIG_DMAR_TABLE=y
> > CONFIG_INTEL_IOMMU=y
> > # CONFIG_INTEL_IOMMU_SVM is not set
> > # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
> > CONFIG_INTEL_IOMMU_FLOPPY_WA=y
> > CONFIG_IRQ_REMAP=y
> > 
> > #
> > # Remoteproc drivers
> > #
> > # CONFIG_REMOTEPROC is not set
> > 
> > #
> > # Rpmsg drivers
> > #
> > # CONFIG_RPMSG_QCOM_GLINK_RPM is not set
> > # CONFIG_RPMSG_VIRTIO is not set
> > # CONFIG_SOUNDWIRE is not set
> > 
> > #
> > # SOC (System On Chip) specific Drivers
> > #
> > 
> > #
> > # Amlogic SoC drivers
> > #
> > 
> > #
> > # Broadcom SoC drivers
> > #
> > 
> > #
> > # NXP/Freescale QorIQ SoC drivers
> > #
> > 
> > #
> > # i.MX SoC drivers
> > #
> > 
> > #
> > # Qualcomm SoC drivers
> > #
> > # CONFIG_SOC_TI is not set
> > 
> > #
> > # Xilinx SoC drivers
> > #
> > # CONFIG_XILINX_VCU is not set
> > # CONFIG_PM_DEVFREQ is not set
> > # CONFIG_EXTCON is not set
> > # CONFIG_MEMORY is not set
> > # CONFIG_IIO is not set
> > CONFIG_NTB=m
> > # CONFIG_NTB_AMD is not set
> > # CONFIG_NTB_IDT is not set
> > # CONFIG_NTB_INTEL is not set
> > # CONFIG_NTB_SWITCHTEC is not set
> > # CONFIG_NTB_PINGPONG is not set
> > # CONFIG_NTB_TOOL is not set
> > # CONFIG_NTB_PERF is not set
> > # CONFIG_NTB_TRANSPORT is not set
> > # CONFIG_VME_BUS is not set
> > CONFIG_PWM=y
> > CONFIG_PWM_SYSFS=y
> > CONFIG_PWM_LPSS=m
> > CONFIG_PWM_LPSS_PCI=m
> > CONFIG_PWM_LPSS_PLATFORM=m
> > # CONFIG_PWM_PCA9685 is not set
> > 
> > #
> > # IRQ chip support
> > #
> > CONFIG_ARM_GIC_MAX_NR=1
> > # CONFIG_IPACK_BUS is not set
> > # CONFIG_RESET_CONTROLLER is not set
> > # CONFIG_FMC is not set
> > 
> > #
> > # PHY Subsystem
> > #
> > # CONFIG_GENERIC_PHY is not set
> > # CONFIG_BCM_KONA_USB2_PHY is not set
> > # CONFIG_PHY_PXA_28NM_HSIC is not set
> > # CONFIG_PHY_PXA_28NM_USB2 is not set
> > CONFIG_POWERCAP=y
> > CONFIG_INTEL_RAPL=m
> > # CONFIG_IDLE_INJECT is not set
> > # CONFIG_MCB is not set
> > 
> > #
> > # Performance monitor support
> > #
> > CONFIG_RAS=y
> > # CONFIG_RAS_CEC is not set
> > CONFIG_THUNDERBOLT=y
> > 
> > #
> > # Android
> > #
> > CONFIG_ANDROID=y
> > # CONFIG_ANDROID_BINDER_IPC is not set
> > CONFIG_LIBNVDIMM=m
> > CONFIG_BLK_DEV_PMEM=m
> > CONFIG_ND_BLK=m
> > CONFIG_ND_CLAIM=y
> > CONFIG_ND_BTT=m
> > CONFIG_BTT=y
> > CONFIG_ND_PFN=m
> > CONFIG_NVDIMM_PFN=y
> > CONFIG_NVDIMM_DAX=y
> > CONFIG_DAX_DRIVER=y
> > CONFIG_DAX=y
> > CONFIG_DEV_DAX=m
> > CONFIG_DEV_DAX_PMEM=m
> > CONFIG_NVMEM=y
> > 
> > #
> > # HW tracing support
> > #
> > CONFIG_STM=m
> > CONFIG_STM_DUMMY=m
> > CONFIG_STM_SOURCE_CONSOLE=m
> > CONFIG_STM_SOURCE_HEARTBEAT=m
> > CONFIG_STM_SOURCE_FTRACE=m
> > CONFIG_INTEL_TH=m
> > CONFIG_INTEL_TH_PCI=m
> > CONFIG_INTEL_TH_ACPI=m
> > CONFIG_INTEL_TH_GTH=m
> > CONFIG_INTEL_TH_STH=m
> > CONFIG_INTEL_TH_MSU=m
> > CONFIG_INTEL_TH_PTI=m
> > # CONFIG_INTEL_TH_DEBUG is not set
> > # CONFIG_FPGA is not set
> > # CONFIG_UNISYS_VISORBUS is not set
> > # CONFIG_SIOX is not set
> > # CONFIG_SLIMBUS is not set
> > 
> > #
> > # File systems
> > #
> > CONFIG_DCACHE_WORD_ACCESS=y
> > CONFIG_FS_IOMAP=y
> > # CONFIG_EXT2_FS is not set
> > # CONFIG_EXT3_FS is not set
> > CONFIG_EXT4_FS=y
> > CONFIG_EXT4_USE_FOR_EXT2=y
> > CONFIG_EXT4_FS_POSIX_ACL=y
> > CONFIG_EXT4_FS_SECURITY=y
> > # CONFIG_EXT4_ENCRYPTION is not set
> > # CONFIG_EXT4_DEBUG is not set
> > CONFIG_JBD2=y
> > # CONFIG_JBD2_DEBUG is not set
> > CONFIG_FS_MBCACHE=y
> > # CONFIG_REISERFS_FS is not set
> > # CONFIG_JFS_FS is not set
> > CONFIG_XFS_FS=m
> > CONFIG_XFS_QUOTA=y
> > CONFIG_XFS_POSIX_ACL=y
> > CONFIG_XFS_RT=y
> > CONFIG_XFS_ONLINE_SCRUB=y
> > # CONFIG_XFS_ONLINE_REPAIR is not set
> > CONFIG_XFS_DEBUG=y
> > CONFIG_XFS_ASSERT_FATAL=y
> > CONFIG_GFS2_FS=m
> > CONFIG_GFS2_FS_LOCKING_DLM=y
> > CONFIG_OCFS2_FS=m
> > CONFIG_OCFS2_FS_O2CB=m
> > CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
> > CONFIG_OCFS2_FS_STATS=y
> > CONFIG_OCFS2_DEBUG_MASKLOG=y
> > # CONFIG_OCFS2_DEBUG_FS is not set
> > CONFIG_BTRFS_FS=m
> > CONFIG_BTRFS_FS_POSIX_ACL=y
> > # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> > # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> > # CONFIG_BTRFS_DEBUG is not set
> > # CONFIG_BTRFS_ASSERT is not set
> > # CONFIG_BTRFS_FS_REF_VERIFY is not set
> > # CONFIG_NILFS2_FS is not set
> > CONFIG_F2FS_FS=m
> > CONFIG_F2FS_STAT_FS=y
> > CONFIG_F2FS_FS_XATTR=y
> > CONFIG_F2FS_FS_POSIX_ACL=y
> > # CONFIG_F2FS_FS_SECURITY is not set
> > # CONFIG_F2FS_CHECK_FS is not set
> > CONFIG_F2FS_FS_ENCRYPTION=y
> > # CONFIG_F2FS_IO_TRACE is not set
> > # CONFIG_F2FS_FAULT_INJECTION is not set
> > CONFIG_FS_DAX=y
> > CONFIG_FS_DAX_PMD=y
> > CONFIG_FS_POSIX_ACL=y
> > CONFIG_EXPORTFS=y
> > CONFIG_EXPORTFS_BLOCK_OPS=y
> > CONFIG_FILE_LOCKING=y
> > CONFIG_MANDATORY_FILE_LOCKING=y
> > CONFIG_FS_ENCRYPTION=y
> > CONFIG_FSNOTIFY=y
> > CONFIG_DNOTIFY=y
> > CONFIG_INOTIFY_USER=y
> > CONFIG_FANOTIFY=y
> > CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
> > CONFIG_QUOTA=y
> > CONFIG_QUOTA_NETLINK_INTERFACE=y
> > CONFIG_PRINT_QUOTA_WARNING=y
> > # CONFIG_QUOTA_DEBUG is not set
> > CONFIG_QUOTA_TREE=y
> > # CONFIG_QFMT_V1 is not set
> > CONFIG_QFMT_V2=y
> > CONFIG_QUOTACTL=y
> > CONFIG_QUOTACTL_COMPAT=y
> > CONFIG_AUTOFS4_FS=y
> > CONFIG_AUTOFS_FS=y
> > CONFIG_FUSE_FS=m
> > CONFIG_CUSE=m
> > CONFIG_OVERLAY_FS=m
> > # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
> > # CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
> > # CONFIG_OVERLAY_FS_INDEX is not set
> > # CONFIG_OVERLAY_FS_XINO_AUTO is not set
> > # CONFIG_OVERLAY_FS_METACOPY is not set
> > 
> > #
> > # Caches
> > #
> > CONFIG_FSCACHE=m
> > CONFIG_FSCACHE_STATS=y
> > # CONFIG_FSCACHE_HISTOGRAM is not set
> > # CONFIG_FSCACHE_DEBUG is not set
> > # CONFIG_FSCACHE_OBJECT_LIST is not set
> > CONFIG_CACHEFILES=m
> > # CONFIG_CACHEFILES_DEBUG is not set
> > # CONFIG_CACHEFILES_HISTOGRAM is not set
> > 
> > #
> > # CD-ROM/DVD Filesystems
> > #
> > CONFIG_ISO9660_FS=m
> > CONFIG_JOLIET=y
> > CONFIG_ZISOFS=y
> > CONFIG_UDF_FS=m
> > 
> > #
> > # DOS/FAT/NT Filesystems
> > #
> > CONFIG_FAT_FS=m
> > CONFIG_MSDOS_FS=m
> > CONFIG_VFAT_FS=m
> > CONFIG_FAT_DEFAULT_CODEPAGE=437
> > CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
> > # CONFIG_FAT_DEFAULT_UTF8 is not set
> > # CONFIG_NTFS_FS is not set
> > 
> > #
> > # Pseudo filesystems
> > #
> > CONFIG_PROC_FS=y
> > CONFIG_PROC_KCORE=y
> > CONFIG_PROC_VMCORE=y
> > CONFIG_PROC_VMCORE_DEVICE_DUMP=y
> > CONFIG_PROC_SYSCTL=y
> > CONFIG_PROC_PAGE_MONITOR=y
> > CONFIG_PROC_CHILDREN=y
> > CONFIG_KERNFS=y
> > CONFIG_SYSFS=y
> > CONFIG_TMPFS=y
> > CONFIG_TMPFS_POSIX_ACL=y
> > CONFIG_TMPFS_XATTR=y
> > CONFIG_HUGETLBFS=y
> > CONFIG_HUGETLB_PAGE=y
> > CONFIG_MEMFD_CREATE=y
> > CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
> > CONFIG_CONFIGFS_FS=y
> > CONFIG_EFIVAR_FS=y
> > CONFIG_MISC_FILESYSTEMS=y
> > # CONFIG_ORANGEFS_FS is not set
> > # CONFIG_ADFS_FS is not set
> > # CONFIG_AFFS_FS is not set
> > # CONFIG_ECRYPT_FS is not set
> > # CONFIG_HFS_FS is not set
> > # CONFIG_HFSPLUS_FS is not set
> > # CONFIG_BEFS_FS is not set
> > # CONFIG_BFS_FS is not set
> > # CONFIG_EFS_FS is not set
> > CONFIG_CRAMFS=m
> > CONFIG_CRAMFS_BLOCKDEV=y
> > CONFIG_SQUASHFS=m
> > # CONFIG_SQUASHFS_FILE_CACHE is not set
> > CONFIG_SQUASHFS_FILE_DIRECT=y
> > # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> > # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> > CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> > CONFIG_SQUASHFS_XATTR=y
> > CONFIG_SQUASHFS_ZLIB=y
> > # CONFIG_SQUASHFS_LZ4 is not set
> > CONFIG_SQUASHFS_LZO=y
> > CONFIG_SQUASHFS_XZ=y
> > # CONFIG_SQUASHFS_ZSTD is not set
> > # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> > # CONFIG_SQUASHFS_EMBEDDED is not set
> > CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> > # CONFIG_VXFS_FS is not set
> > # CONFIG_MINIX_FS is not set
> > # CONFIG_OMFS_FS is not set
> > # CONFIG_HPFS_FS is not set
> > # CONFIG_QNX4FS_FS is not set
> > # CONFIG_QNX6FS_FS is not set
> > # CONFIG_ROMFS_FS is not set
> > CONFIG_PSTORE=y
> > CONFIG_PSTORE_DEFLATE_COMPRESS=y
> > # CONFIG_PSTORE_LZO_COMPRESS is not set
> > # CONFIG_PSTORE_LZ4_COMPRESS is not set
> > # CONFIG_PSTORE_LZ4HC_COMPRESS is not set
> > # CONFIG_PSTORE_842_COMPRESS is not set
> > # CONFIG_PSTORE_ZSTD_COMPRESS is not set
> > CONFIG_PSTORE_COMPRESS=y
> > CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
> > CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
> > CONFIG_PSTORE_CONSOLE=y
> > CONFIG_PSTORE_PMSG=y
> > # CONFIG_PSTORE_FTRACE is not set
> > CONFIG_PSTORE_RAM=m
> > # CONFIG_SYSV_FS is not set
> > # CONFIG_UFS_FS is not set
> > CONFIG_NETWORK_FILESYSTEMS=y
> > CONFIG_NFS_FS=y
> > # CONFIG_NFS_V2 is not set
> > CONFIG_NFS_V3=y
> > CONFIG_NFS_V3_ACL=y
> > CONFIG_NFS_V4=m
> > # CONFIG_NFS_SWAP is not set
> > CONFIG_NFS_V4_1=y
> > CONFIG_NFS_V4_2=y
> > CONFIG_PNFS_FILE_LAYOUT=m
> > CONFIG_PNFS_BLOCK=m
> > CONFIG_PNFS_FLEXFILE_LAYOUT=m
> > CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> > # CONFIG_NFS_V4_1_MIGRATION is not set
> > CONFIG_NFS_V4_SECURITY_LABEL=y
> > CONFIG_ROOT_NFS=y
> > # CONFIG_NFS_USE_LEGACY_DNS is not set
> > CONFIG_NFS_USE_KERNEL_DNS=y
> > CONFIG_NFS_DEBUG=y
> > CONFIG_NFSD=m
> > CONFIG_NFSD_V2_ACL=y
> > CONFIG_NFSD_V3=y
> > CONFIG_NFSD_V3_ACL=y
> > CONFIG_NFSD_V4=y
> > CONFIG_NFSD_PNFS=y
> > # CONFIG_NFSD_BLOCKLAYOUT is not set
> > CONFIG_NFSD_SCSILAYOUT=y
> > # CONFIG_NFSD_FLEXFILELAYOUT is not set
> > CONFIG_NFSD_V4_SECURITY_LABEL=y
> > # CONFIG_NFSD_FAULT_INJECTION is not set
> > CONFIG_GRACE_PERIOD=y
> > CONFIG_LOCKD=y
> > CONFIG_LOCKD_V4=y
> > CONFIG_NFS_ACL_SUPPORT=y
> > CONFIG_NFS_COMMON=y
> > CONFIG_SUNRPC=y
> > CONFIG_SUNRPC_GSS=m
> > CONFIG_SUNRPC_BACKCHANNEL=y
> > CONFIG_RPCSEC_GSS_KRB5=m
> > CONFIG_SUNRPC_DEBUG=y
> > CONFIG_CEPH_FS=m
> > # CONFIG_CEPH_FSCACHE is not set
> > CONFIG_CEPH_FS_POSIX_ACL=y
> > CONFIG_CIFS=m
> > # CONFIG_CIFS_STATS2 is not set
> > CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
> > CONFIG_CIFS_WEAK_PW_HASH=y
> > CONFIG_CIFS_UPCALL=y
> > CONFIG_CIFS_XATTR=y
> > CONFIG_CIFS_POSIX=y
> > # CONFIG_CIFS_ACL is not set
> > CONFIG_CIFS_DEBUG=y
> > # CONFIG_CIFS_DEBUG2 is not set
> > # CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
> > CONFIG_CIFS_DFS_UPCALL=y
> > # CONFIG_CIFS_FSCACHE is not set
> > # CONFIG_CODA_FS is not set
> > # CONFIG_AFS_FS is not set
> > # CONFIG_9P_FS is not set
> > CONFIG_NLS=y
> > CONFIG_NLS_DEFAULT="utf8"
> > CONFIG_NLS_CODEPAGE_437=y
> > CONFIG_NLS_CODEPAGE_737=m
> > CONFIG_NLS_CODEPAGE_775=m
> > CONFIG_NLS_CODEPAGE_850=m
> > CONFIG_NLS_CODEPAGE_852=m
> > CONFIG_NLS_CODEPAGE_855=m
> > CONFIG_NLS_CODEPAGE_857=m
> > CONFIG_NLS_CODEPAGE_860=m
> > CONFIG_NLS_CODEPAGE_861=m
> > CONFIG_NLS_CODEPAGE_862=m
> > CONFIG_NLS_CODEPAGE_863=m
> > CONFIG_NLS_CODEPAGE_864=m
> > CONFIG_NLS_CODEPAGE_865=m
> > CONFIG_NLS_CODEPAGE_866=m
> > CONFIG_NLS_CODEPAGE_869=m
> > CONFIG_NLS_CODEPAGE_936=m
> > CONFIG_NLS_CODEPAGE_950=m
> > CONFIG_NLS_CODEPAGE_932=m
> > CONFIG_NLS_CODEPAGE_949=m
> > CONFIG_NLS_CODEPAGE_874=m
> > CONFIG_NLS_ISO8859_8=m
> > CONFIG_NLS_CODEPAGE_1250=m
> > CONFIG_NLS_CODEPAGE_1251=m
> > CONFIG_NLS_ASCII=y
> > CONFIG_NLS_ISO8859_1=m
> > CONFIG_NLS_ISO8859_2=m
> > CONFIG_NLS_ISO8859_3=m
> > CONFIG_NLS_ISO8859_4=m
> > CONFIG_NLS_ISO8859_5=m
> > CONFIG_NLS_ISO8859_6=m
> > CONFIG_NLS_ISO8859_7=m
> > CONFIG_NLS_ISO8859_9=m
> > CONFIG_NLS_ISO8859_13=m
> > CONFIG_NLS_ISO8859_14=m
> > CONFIG_NLS_ISO8859_15=m
> > CONFIG_NLS_KOI8_R=m
> > CONFIG_NLS_KOI8_U=m
> > CONFIG_NLS_MAC_ROMAN=m
> > CONFIG_NLS_MAC_CELTIC=m
> > CONFIG_NLS_MAC_CENTEURO=m
> > CONFIG_NLS_MAC_CROATIAN=m
> > CONFIG_NLS_MAC_CYRILLIC=m
> > CONFIG_NLS_MAC_GAELIC=m
> > CONFIG_NLS_MAC_GREEK=m
> > CONFIG_NLS_MAC_ICELAND=m
> > CONFIG_NLS_MAC_INUIT=m
> > CONFIG_NLS_MAC_ROMANIAN=m
> > CONFIG_NLS_MAC_TURKISH=m
> > CONFIG_NLS_UTF8=m
> > CONFIG_DLM=m
> > CONFIG_DLM_DEBUG=y
> > 
> > #
> > # Security options
> > #
> > CONFIG_KEYS=y
> > CONFIG_KEYS_COMPAT=y
> > CONFIG_PERSISTENT_KEYRINGS=y
> > CONFIG_BIG_KEYS=y
> > CONFIG_TRUSTED_KEYS=y
> > CONFIG_ENCRYPTED_KEYS=y
> > # CONFIG_KEY_DH_OPERATIONS is not set
> > # CONFIG_SECURITY_DMESG_RESTRICT is not set
> > CONFIG_SECURITY=y
> > CONFIG_SECURITY_WRITABLE_HOOKS=y
> > CONFIG_SECURITYFS=y
> > CONFIG_SECURITY_NETWORK=y
> > CONFIG_PAGE_TABLE_ISOLATION=y
> > CONFIG_SECURITY_NETWORK_XFRM=y
> > # CONFIG_SECURITY_PATH is not set
> > CONFIG_INTEL_TXT=y
> > CONFIG_LSM_MMAP_MIN_ADDR=65535
> > CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
> > CONFIG_HARDENED_USERCOPY=y
> > CONFIG_HARDENED_USERCOPY_FALLBACK=y
> > # CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
> > CONFIG_FORTIFY_SOURCE=y
> > # CONFIG_STATIC_USERMODEHELPER is not set
> > CONFIG_SECURITY_SELINUX=y
> > CONFIG_SECURITY_SELINUX_BOOTPARAM=y
> > CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
> > CONFIG_SECURITY_SELINUX_DISABLE=y
> > CONFIG_SECURITY_SELINUX_DEVELOP=y
> > CONFIG_SECURITY_SELINUX_AVC_STATS=y
> > CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> > # CONFIG_SECURITY_SMACK is not set
> > # CONFIG_SECURITY_TOMOYO is not set
> > # CONFIG_SECURITY_APPARMOR is not set
> > # CONFIG_SECURITY_LOADPIN is not set
> > CONFIG_SECURITY_YAMA=y
> > CONFIG_INTEGRITY=y
> > CONFIG_INTEGRITY_SIGNATURE=y
> > CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
> > CONFIG_INTEGRITY_TRUSTED_KEYRING=y
> > CONFIG_INTEGRITY_AUDIT=y
> > CONFIG_IMA=y
> > CONFIG_IMA_MEASURE_PCR_IDX=10
> > CONFIG_IMA_LSM_RULES=y
> > # CONFIG_IMA_TEMPLATE is not set
> > CONFIG_IMA_NG_TEMPLATE=y
> > # CONFIG_IMA_SIG_TEMPLATE is not set
> > CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
> > CONFIG_IMA_DEFAULT_HASH_SHA1=y
> > # CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
> > CONFIG_IMA_DEFAULT_HASH="sha1"
> > CONFIG_IMA_WRITE_POLICY=y
> > CONFIG_IMA_READ_POLICY=y
> > CONFIG_IMA_APPRAISE=y
> > # CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
> > CONFIG_IMA_APPRAISE_BOOTPARAM=y
> > CONFIG_IMA_TRUSTED_KEYRING=y
> > # CONFIG_IMA_BLACKLIST_KEYRING is not set
> > # CONFIG_IMA_LOAD_X509 is not set
> > CONFIG_EVM=y
> > CONFIG_EVM_ATTR_FSUUID=y
> > # CONFIG_EVM_ADD_XATTRS is not set
> > # CONFIG_EVM_LOAD_X509 is not set
> > CONFIG_DEFAULT_SECURITY_SELINUX=y
> > # CONFIG_DEFAULT_SECURITY_DAC is not set
> > CONFIG_DEFAULT_SECURITY="selinux"
> > CONFIG_XOR_BLOCKS=m
> > CONFIG_ASYNC_CORE=m
> > CONFIG_ASYNC_MEMCPY=m
> > CONFIG_ASYNC_XOR=m
> > CONFIG_ASYNC_PQ=m
> > CONFIG_ASYNC_RAID6_RECOV=m
> > CONFIG_CRYPTO=y
> > 
> > #
> > # Crypto core or helper
> > #
> > CONFIG_CRYPTO_ALGAPI=y
> > CONFIG_CRYPTO_ALGAPI2=y
> > CONFIG_CRYPTO_AEAD=y
> > CONFIG_CRYPTO_AEAD2=y
> > CONFIG_CRYPTO_BLKCIPHER=y
> > CONFIG_CRYPTO_BLKCIPHER2=y
> > CONFIG_CRYPTO_HASH=y
> > CONFIG_CRYPTO_HASH2=y
> > CONFIG_CRYPTO_RNG=y
> > CONFIG_CRYPTO_RNG2=y
> > CONFIG_CRYPTO_RNG_DEFAULT=y
> > CONFIG_CRYPTO_AKCIPHER2=y
> > CONFIG_CRYPTO_AKCIPHER=y
> > CONFIG_CRYPTO_KPP2=y
> > CONFIG_CRYPTO_KPP=m
> > CONFIG_CRYPTO_ACOMP2=y
> > CONFIG_CRYPTO_RSA=y
> > CONFIG_CRYPTO_DH=m
> > CONFIG_CRYPTO_ECDH=m
> > CONFIG_CRYPTO_MANAGER=y
> > CONFIG_CRYPTO_MANAGER2=y
> > CONFIG_CRYPTO_USER=m
> > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> > CONFIG_CRYPTO_GF128MUL=y
> > CONFIG_CRYPTO_NULL=y
> > CONFIG_CRYPTO_NULL2=y
> > CONFIG_CRYPTO_PCRYPT=m
> > CONFIG_CRYPTO_WORKQUEUE=y
> > CONFIG_CRYPTO_CRYPTD=y
> > CONFIG_CRYPTO_MCRYPTD=m
> > CONFIG_CRYPTO_AUTHENC=m
> > CONFIG_CRYPTO_TEST=m
> > CONFIG_CRYPTO_SIMD=y
> > CONFIG_CRYPTO_GLUE_HELPER_X86=y
> > 
> > #
> > # Authenticated Encryption with Associated Data
> > #
> > CONFIG_CRYPTO_CCM=m
> > CONFIG_CRYPTO_GCM=y
> > CONFIG_CRYPTO_CHACHA20POLY1305=m
> > # CONFIG_CRYPTO_AEGIS128 is not set
> > # CONFIG_CRYPTO_AEGIS128L is not set
> > # CONFIG_CRYPTO_AEGIS256 is not set
> > # CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
> > # CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
> > # CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
> > # CONFIG_CRYPTO_MORUS640 is not set
> > # CONFIG_CRYPTO_MORUS640_SSE2 is not set
> > # CONFIG_CRYPTO_MORUS1280 is not set
> > # CONFIG_CRYPTO_MORUS1280_SSE2 is not set
> > # CONFIG_CRYPTO_MORUS1280_AVX2 is not set
> > CONFIG_CRYPTO_SEQIV=y
> > CONFIG_CRYPTO_ECHAINIV=m
> > 
> > #
> > # Block modes
> > #
> > CONFIG_CRYPTO_CBC=y
> > CONFIG_CRYPTO_CFB=y
> > CONFIG_CRYPTO_CTR=y
> > CONFIG_CRYPTO_CTS=y
> > CONFIG_CRYPTO_ECB=y
> > CONFIG_CRYPTO_LRW=m
> > CONFIG_CRYPTO_PCBC=m
> > CONFIG_CRYPTO_XTS=y
> > # CONFIG_CRYPTO_KEYWRAP is not set
> > 
> > #
> > # Hash modes
> > #
> > CONFIG_CRYPTO_CMAC=m
> > CONFIG_CRYPTO_HMAC=y
> > CONFIG_CRYPTO_XCBC=m
> > CONFIG_CRYPTO_VMAC=m
> > 
> > #
> > # Digest
> > #
> > CONFIG_CRYPTO_CRC32C=y
> > CONFIG_CRYPTO_CRC32C_INTEL=m
> > CONFIG_CRYPTO_CRC32=m
> > CONFIG_CRYPTO_CRC32_PCLMUL=m
> > CONFIG_CRYPTO_CRCT10DIF=y
> > CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> > CONFIG_CRYPTO_GHASH=y
> > CONFIG_CRYPTO_POLY1305=m
> > CONFIG_CRYPTO_POLY1305_X86_64=m
> > CONFIG_CRYPTO_MD4=m
> > CONFIG_CRYPTO_MD5=y
> > CONFIG_CRYPTO_MICHAEL_MIC=m
> > CONFIG_CRYPTO_RMD128=m
> > CONFIG_CRYPTO_RMD160=m
> > CONFIG_CRYPTO_RMD256=m
> > CONFIG_CRYPTO_RMD320=m
> > CONFIG_CRYPTO_SHA1=y
> > CONFIG_CRYPTO_SHA1_SSSE3=y
> > CONFIG_CRYPTO_SHA256_SSSE3=y
> > CONFIG_CRYPTO_SHA512_SSSE3=m
> > CONFIG_CRYPTO_SHA1_MB=m
> > CONFIG_CRYPTO_SHA256_MB=m
> > CONFIG_CRYPTO_SHA512_MB=m
> > CONFIG_CRYPTO_SHA256=y
> > CONFIG_CRYPTO_SHA512=m
> > CONFIG_CRYPTO_SHA3=m
> > # CONFIG_CRYPTO_SM3 is not set
> > CONFIG_CRYPTO_TGR192=m
> > CONFIG_CRYPTO_WP512=m
> > CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
> > 
> > #
> > # Ciphers
> > #
> > CONFIG_CRYPTO_AES=y
> > # CONFIG_CRYPTO_AES_TI is not set
> > CONFIG_CRYPTO_AES_X86_64=y
> > CONFIG_CRYPTO_AES_NI_INTEL=y
> > CONFIG_CRYPTO_ANUBIS=m
> > CONFIG_CRYPTO_ARC4=m
> > CONFIG_CRYPTO_BLOWFISH=m
> > CONFIG_CRYPTO_BLOWFISH_COMMON=m
> > CONFIG_CRYPTO_BLOWFISH_X86_64=m
> > CONFIG_CRYPTO_CAMELLIA=m
> > CONFIG_CRYPTO_CAMELLIA_X86_64=m
> > CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
> > CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
> > CONFIG_CRYPTO_CAST_COMMON=m
> > CONFIG_CRYPTO_CAST5=m
> > CONFIG_CRYPTO_CAST5_AVX_X86_64=m
> > CONFIG_CRYPTO_CAST6=m
> > CONFIG_CRYPTO_CAST6_AVX_X86_64=m
> > CONFIG_CRYPTO_DES=m
> > CONFIG_CRYPTO_DES3_EDE_X86_64=m
> > CONFIG_CRYPTO_FCRYPT=m
> > CONFIG_CRYPTO_KHAZAD=m
> > CONFIG_CRYPTO_SALSA20=m
> > CONFIG_CRYPTO_CHACHA20=m
> > CONFIG_CRYPTO_CHACHA20_X86_64=m
> > CONFIG_CRYPTO_SEED=m
> > CONFIG_CRYPTO_SERPENT=m
> > CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
> > CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
> > CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
> > # CONFIG_CRYPTO_SM4 is not set
> > CONFIG_CRYPTO_TEA=m
> > CONFIG_CRYPTO_TWOFISH=m
> > CONFIG_CRYPTO_TWOFISH_COMMON=m
> > CONFIG_CRYPTO_TWOFISH_X86_64=m
> > CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
> > CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
> > 
> > #
> > # Compression
> > #
> > CONFIG_CRYPTO_DEFLATE=y
> > CONFIG_CRYPTO_LZO=y
> > # CONFIG_CRYPTO_842 is not set
> > # CONFIG_CRYPTO_LZ4 is not set
> > # CONFIG_CRYPTO_LZ4HC is not set
> > # CONFIG_CRYPTO_ZSTD is not set
> > 
> > #
> > # Random Number Generation
> > #
> > CONFIG_CRYPTO_ANSI_CPRNG=m
> > CONFIG_CRYPTO_DRBG_MENU=y
> > CONFIG_CRYPTO_DRBG_HMAC=y
> > CONFIG_CRYPTO_DRBG_HASH=y
> > CONFIG_CRYPTO_DRBG_CTR=y
> > CONFIG_CRYPTO_DRBG=y
> > CONFIG_CRYPTO_JITTERENTROPY=y
> > CONFIG_CRYPTO_USER_API=y
> > CONFIG_CRYPTO_USER_API_HASH=y
> > CONFIG_CRYPTO_USER_API_SKCIPHER=y
> > CONFIG_CRYPTO_USER_API_RNG=y
> > CONFIG_CRYPTO_USER_API_AEAD=y
> > CONFIG_CRYPTO_HASH_INFO=y
> > CONFIG_CRYPTO_HW=y
> > CONFIG_CRYPTO_DEV_PADLOCK=m
> > CONFIG_CRYPTO_DEV_PADLOCK_AES=m
> > CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
> > CONFIG_CRYPTO_DEV_CCP=y
> > CONFIG_CRYPTO_DEV_CCP_DD=m
> > CONFIG_CRYPTO_DEV_SP_CCP=y
> > CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
> > CONFIG_CRYPTO_DEV_SP_PSP=y
> > CONFIG_CRYPTO_DEV_QAT=m
> > CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
> > CONFIG_CRYPTO_DEV_QAT_C3XXX=m
> > CONFIG_CRYPTO_DEV_QAT_C62X=m
> > CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
> > CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
> > CONFIG_CRYPTO_DEV_QAT_C62XVF=m
> > CONFIG_CRYPTO_DEV_NITROX=m
> > CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
> > # CONFIG_CRYPTO_DEV_VIRTIO is not set
> > CONFIG_ASYMMETRIC_KEY_TYPE=y
> > CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> > CONFIG_X509_CERTIFICATE_PARSER=y
> > CONFIG_PKCS7_MESSAGE_PARSER=y
> > # CONFIG_PKCS7_TEST_KEY is not set
> > CONFIG_SIGNED_PE_FILE_VERIFICATION=y
> > 
> > #
> > # Certificates for signature checking
> > #
> > CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
> > CONFIG_SYSTEM_TRUSTED_KEYRING=y
> > CONFIG_SYSTEM_TRUSTED_KEYS=""
> > # CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
> > # CONFIG_SECONDARY_TRUSTED_KEYRING is not set
> > CONFIG_SYSTEM_BLACKLIST_KEYRING=y
> > CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
> > CONFIG_BINARY_PRINTF=y
> > 
> > #
> > # Library routines
> > #
> > CONFIG_RAID6_PQ=m
> > CONFIG_BITREVERSE=y
> > CONFIG_RATIONAL=y
> > CONFIG_GENERIC_STRNCPY_FROM_USER=y
> > CONFIG_GENERIC_STRNLEN_USER=y
> > CONFIG_GENERIC_NET_UTILS=y
> > CONFIG_GENERIC_FIND_FIRST_BIT=y
> > CONFIG_GENERIC_PCI_IOMAP=y
> > CONFIG_GENERIC_IOMAP=y
> > CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> > CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
> > CONFIG_CRC_CCITT=y
> > CONFIG_CRC16=y
> > CONFIG_CRC_T10DIF=y
> > CONFIG_CRC_ITU_T=m
> > CONFIG_CRC32=y
> > # CONFIG_CRC32_SELFTEST is not set
> > CONFIG_CRC32_SLICEBY8=y
> > # CONFIG_CRC32_SLICEBY4 is not set
> > # CONFIG_CRC32_SARWATE is not set
> > # CONFIG_CRC32_BIT is not set
> > # CONFIG_CRC64 is not set
> > # CONFIG_CRC4 is not set
> > CONFIG_CRC7=m
> > CONFIG_LIBCRC32C=m
> > CONFIG_CRC8=m
> > CONFIG_XXHASH=m
> > # CONFIG_RANDOM32_SELFTEST is not set
> > CONFIG_ZLIB_INFLATE=y
> > CONFIG_ZLIB_DEFLATE=y
> > CONFIG_LZO_COMPRESS=y
> > CONFIG_LZO_DECOMPRESS=y
> > CONFIG_LZ4_DECOMPRESS=y
> > CONFIG_ZSTD_COMPRESS=m
> > CONFIG_ZSTD_DECOMPRESS=m
> > CONFIG_XZ_DEC=y
> > CONFIG_XZ_DEC_X86=y
> > CONFIG_XZ_DEC_POWERPC=y
> > CONFIG_XZ_DEC_IA64=y
> > CONFIG_XZ_DEC_ARM=y
> > CONFIG_XZ_DEC_ARMTHUMB=y
> > CONFIG_XZ_DEC_SPARC=y
> > CONFIG_XZ_DEC_BCJ=y
> > # CONFIG_XZ_DEC_TEST is not set
> > CONFIG_DECOMPRESS_GZIP=y
> > CONFIG_DECOMPRESS_BZIP2=y
> > CONFIG_DECOMPRESS_LZMA=y
> > CONFIG_DECOMPRESS_XZ=y
> > CONFIG_DECOMPRESS_LZO=y
> > CONFIG_DECOMPRESS_LZ4=y
> > CONFIG_GENERIC_ALLOCATOR=y
> > CONFIG_REED_SOLOMON=m
> > CONFIG_REED_SOLOMON_ENC8=y
> > CONFIG_REED_SOLOMON_DEC8=y
> > CONFIG_TEXTSEARCH=y
> > CONFIG_TEXTSEARCH_KMP=m
> > CONFIG_TEXTSEARCH_BM=m
> > CONFIG_TEXTSEARCH_FSM=m
> > CONFIG_INTERVAL_TREE=y
> > CONFIG_RADIX_TREE_MULTIORDER=y
> > CONFIG_ASSOCIATIVE_ARRAY=y
> > CONFIG_HAS_IOMEM=y
> > CONFIG_HAS_IOPORT_MAP=y
> > CONFIG_HAS_DMA=y
> > CONFIG_NEED_SG_DMA_LENGTH=y
> > CONFIG_NEED_DMA_MAP_STATE=y
> > CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> > CONFIG_DMA_DIRECT_OPS=y
> > CONFIG_SWIOTLB=y
> > CONFIG_SGL_ALLOC=y
> > CONFIG_CHECK_SIGNATURE=y
> > CONFIG_CPUMASK_OFFSTACK=y
> > CONFIG_CPU_RMAP=y
> > CONFIG_DQL=y
> > CONFIG_GLOB=y
> > # CONFIG_GLOB_SELFTEST is not set
> > CONFIG_NLATTR=y
> > CONFIG_CLZ_TAB=y
> > CONFIG_CORDIC=m
> > # CONFIG_DDR is not set
> > CONFIG_IRQ_POLL=y
> > CONFIG_MPILIB=y
> > CONFIG_SIGNATURE=y
> > CONFIG_OID_REGISTRY=y
> > CONFIG_UCS2_STRING=y
> > CONFIG_FONT_SUPPORT=y
> > # CONFIG_FONTS is not set
> > CONFIG_FONT_8x8=y
> > CONFIG_FONT_8x16=y
> > CONFIG_SG_POOL=y
> > CONFIG_ARCH_HAS_SG_CHAIN=y
> > CONFIG_ARCH_HAS_PMEM_API=y
> > CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
> > CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
> > CONFIG_SBITMAP=y
> > CONFIG_PRIME_NUMBERS=m
> > # CONFIG_STRING_SELFTEST is not set
> > 
> > #
> > # Kernel hacking
> > #
> > 
> > #
> > # printk and dmesg options
> > #
> > CONFIG_PRINTK_TIME=y
> > CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
> > CONFIG_CONSOLE_LOGLEVEL_QUIET=4
> > CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
> > CONFIG_BOOT_PRINTK_DELAY=y
> > CONFIG_DYNAMIC_DEBUG=y
> > 
> > #
> > # Compile-time checks and compiler options
> > #
> > CONFIG_DEBUG_INFO=y
> > # CONFIG_DEBUG_INFO_REDUCED is not set
> > # CONFIG_DEBUG_INFO_SPLIT is not set
> > CONFIG_DEBUG_INFO_DWARF4=y
> > # CONFIG_GDB_SCRIPTS is not set
> > CONFIG_ENABLE_MUST_CHECK=y
> > CONFIG_FRAME_WARN=2048
> > CONFIG_STRIP_ASM_SYMS=y
> > # CONFIG_READABLE_ASM is not set
> > # CONFIG_UNUSED_SYMBOLS is not set
> > # CONFIG_PAGE_OWNER is not set
> > CONFIG_DEBUG_FS=y
> > CONFIG_HEADERS_CHECK=y
> > CONFIG_DEBUG_SECTION_MISMATCH=y
> > CONFIG_SECTION_MISMATCH_WARN_ONLY=y
> > CONFIG_STACK_VALIDATION=y
> > # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> > CONFIG_MAGIC_SYSRQ=y
> > CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> > CONFIG_MAGIC_SYSRQ_SERIAL=y
> > CONFIG_DEBUG_KERNEL=y
> > 
> > #
> > # Memory Debugging
> > #
> > # CONFIG_PAGE_EXTENSION is not set
> > # CONFIG_DEBUG_PAGEALLOC is not set
> > # CONFIG_PAGE_POISONING is not set
> > # CONFIG_DEBUG_PAGE_REF is not set
> > # CONFIG_DEBUG_RODATA_TEST is not set
> > # CONFIG_DEBUG_OBJECTS is not set
> > # CONFIG_SLUB_DEBUG_ON is not set
> > # CONFIG_SLUB_STATS is not set
> > CONFIG_HAVE_DEBUG_KMEMLEAK=y
> > # CONFIG_DEBUG_KMEMLEAK is not set
> > # CONFIG_DEBUG_STACK_USAGE is not set
> > # CONFIG_DEBUG_VM is not set
> > CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
> > # CONFIG_DEBUG_VIRTUAL is not set
> > CONFIG_DEBUG_MEMORY_INIT=y
> > CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
> > # CONFIG_DEBUG_PER_CPU_MAPS is not set
> > CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> > CONFIG_DEBUG_STACKOVERFLOW=y
> > CONFIG_HAVE_ARCH_KASAN=y
> > # CONFIG_KASAN is not set
> > CONFIG_ARCH_HAS_KCOV=y
> > CONFIG_CC_HAS_SANCOV_TRACE_PC=y
> > # CONFIG_KCOV is not set
> > CONFIG_DEBUG_SHIRQ=y
> > 
> > #
> > # Debug Lockups and Hangs
> > #
> > CONFIG_LOCKUP_DETECTOR=y
> > CONFIG_SOFTLOCKUP_DETECTOR=y
> > # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> > CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> > CONFIG_HARDLOCKUP_DETECTOR_PERF=y
> > CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
> > CONFIG_HARDLOCKUP_DETECTOR=y
> > CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> > CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
> > # CONFIG_DETECT_HUNG_TASK is not set
> > # CONFIG_WQ_WATCHDOG is not set
> > CONFIG_PANIC_ON_OOPS=y
> > CONFIG_PANIC_ON_OOPS_VALUE=1
> > CONFIG_PANIC_TIMEOUT=0
> > CONFIG_SCHED_DEBUG=y
> > CONFIG_SCHED_INFO=y
> > CONFIG_SCHEDSTATS=y
> > # CONFIG_SCHED_STACK_END_CHECK is not set
> > # CONFIG_DEBUG_TIMEKEEPING is not set
> > CONFIG_DEBUG_PREEMPT=y
> > 
> > #
> > # Lock Debugging (spinlocks, mutexes, etc...)
> > #
> > CONFIG_LOCK_DEBUGGING_SUPPORT=y
> > CONFIG_PROVE_LOCKING=y
> > # CONFIG_LOCK_STAT is not set
> > CONFIG_DEBUG_RT_MUTEXES=y
> > CONFIG_DEBUG_SPINLOCK=y
> > CONFIG_DEBUG_MUTEXES=y
> > CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> > CONFIG_DEBUG_RWSEMS=y
> > CONFIG_DEBUG_LOCK_ALLOC=y
> > CONFIG_LOCKDEP=y
> > # CONFIG_DEBUG_LOCKDEP is not set
> > CONFIG_DEBUG_ATOMIC_SLEEP=y
> > # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> > # CONFIG_LOCK_TORTURE_TEST is not set
> > CONFIG_WW_MUTEX_SELFTEST=m
> > CONFIG_TRACE_IRQFLAGS=y
> > CONFIG_STACKTRACE=y
> > # CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
> > # CONFIG_DEBUG_KOBJECT is not set
> > CONFIG_DEBUG_BUGVERBOSE=y
> > CONFIG_DEBUG_LIST=y
> > CONFIG_DEBUG_PI_LIST=y
> > # CONFIG_DEBUG_SG is not set
> > # CONFIG_DEBUG_NOTIFIERS is not set
> > # CONFIG_DEBUG_CREDENTIALS is not set
> > 
> > #
> > # RCU Debugging
> > #
> > CONFIG_PROVE_RCU=y
> > # CONFIG_RCU_PERF_TEST is not set
> > # CONFIG_RCU_TORTURE_TEST is not set
> > CONFIG_RCU_CPU_STALL_TIMEOUT=60
> > # CONFIG_RCU_TRACE is not set
> > # CONFIG_RCU_EQS_DEBUG is not set
> > # CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
> > # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> > # CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
> > CONFIG_NOTIFIER_ERROR_INJECTION=y
> > CONFIG_PM_NOTIFIER_ERROR_INJECT=m
> > # CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
> > CONFIG_FUNCTION_ERROR_INJECTION=y
> > # CONFIG_FAULT_INJECTION is not set
> > CONFIG_LATENCYTOP=y
> > CONFIG_USER_STACKTRACE_SUPPORT=y
> > CONFIG_NOP_TRACER=y
> > CONFIG_HAVE_FUNCTION_TRACER=y
> > CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> > CONFIG_HAVE_DYNAMIC_FTRACE=y
> > CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> > CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> > CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> > CONFIG_HAVE_FENTRY=y
> > CONFIG_HAVE_C_RECORDMCOUNT=y
> > CONFIG_TRACER_MAX_TRACE=y
> > CONFIG_TRACE_CLOCK=y
> > CONFIG_RING_BUFFER=y
> > CONFIG_EVENT_TRACING=y
> > CONFIG_CONTEXT_SWITCH_TRACER=y
> > CONFIG_RING_BUFFER_ALLOW_SWAP=y
> > CONFIG_PREEMPTIRQ_TRACEPOINTS=y
> > CONFIG_TRACING=y
> > CONFIG_GENERIC_TRACER=y
> > CONFIG_TRACING_SUPPORT=y
> > CONFIG_FTRACE=y
> > CONFIG_FUNCTION_TRACER=y
> > CONFIG_FUNCTION_GRAPH_TRACER=y
> > CONFIG_TRACE_PREEMPT_TOGGLE=y
> > # CONFIG_PREEMPTIRQ_EVENTS is not set
> > CONFIG_IRQSOFF_TRACER=y
> > CONFIG_PREEMPT_TRACER=y
> > CONFIG_SCHED_TRACER=y
> > CONFIG_HWLAT_TRACER=y
> > CONFIG_FTRACE_SYSCALLS=y
> > CONFIG_TRACER_SNAPSHOT=y
> > CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> > CONFIG_BRANCH_PROFILE_NONE=y
> > # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> > CONFIG_STACK_TRACER=y
> > CONFIG_BLK_DEV_IO_TRACE=y
> > CONFIG_KPROBE_EVENTS=y
> > # CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
> > CONFIG_UPROBE_EVENTS=y
> > CONFIG_BPF_EVENTS=y
> > CONFIG_PROBE_EVENTS=y
> > CONFIG_DYNAMIC_FTRACE=y
> > CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> > CONFIG_FUNCTION_PROFILER=y
> > # CONFIG_BPF_KPROBE_OVERRIDE is not set
> > CONFIG_FTRACE_MCOUNT_RECORD=y
> > # CONFIG_FTRACE_STARTUP_TEST is not set
> > # CONFIG_MMIOTRACE is not set
> > CONFIG_TRACING_MAP=y
> > CONFIG_HIST_TRIGGERS=y
> > # CONFIG_TRACEPOINT_BENCHMARK is not set
> > CONFIG_RING_BUFFER_BENCHMARK=m
> > # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> > CONFIG_PREEMPTIRQ_DELAY_TEST=m
> > # CONFIG_TRACE_EVAL_MAP_FILE is not set
> > # CONFIG_TRACING_EVENTS_GPIO is not set
> > CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> > # CONFIG_DMA_API_DEBUG is not set
> > CONFIG_RUNTIME_TESTING_MENU=y
> > CONFIG_LKDTM=y
> > # CONFIG_TEST_LIST_SORT is not set
> > # CONFIG_TEST_SORT is not set
> > # CONFIG_KPROBES_SANITY_TEST is not set
> > # CONFIG_BACKTRACE_SELF_TEST is not set
> > # CONFIG_RBTREE_TEST is not set
> > # CONFIG_INTERVAL_TREE_TEST is not set
> > # CONFIG_PERCPU_TEST is not set
> > CONFIG_ATOMIC64_SELFTEST=y
> > # CONFIG_ASYNC_RAID6_TEST is not set
> > # CONFIG_TEST_HEXDUMP is not set
> > # CONFIG_TEST_STRING_HELPERS is not set
> > # CONFIG_TEST_KSTRTOX is not set
> > CONFIG_TEST_PRINTF=m
> > CONFIG_TEST_BITMAP=m
> > # CONFIG_TEST_BITFIELD is not set
> > # CONFIG_TEST_UUID is not set
> > # CONFIG_TEST_OVERFLOW is not set
> > # CONFIG_TEST_RHASHTABLE is not set
> > # CONFIG_TEST_HASH is not set
> > # CONFIG_TEST_IDA is not set
> > CONFIG_TEST_LKM=m
> > CONFIG_TEST_USER_COPY=m
> > CONFIG_TEST_BPF=m
> > # CONFIG_FIND_BIT_BENCHMARK is not set
> > CONFIG_TEST_FIRMWARE=m
> > CONFIG_TEST_SYSCTL=y
> > # CONFIG_TEST_UDELAY is not set
> > CONFIG_TEST_STATIC_KEYS=m
> > CONFIG_TEST_KMOD=m
> > # CONFIG_MEMTEST is not set
> > CONFIG_BUG_ON_DATA_CORRUPTION=y
> > CONFIG_SAMPLES=y
> > # CONFIG_SAMPLE_TRACE_EVENTS is not set
> > CONFIG_SAMPLE_TRACE_PRINTK=m
> > # CONFIG_SAMPLE_KOBJECT is not set
> > # CONFIG_SAMPLE_KPROBES is not set
> > # CONFIG_SAMPLE_HW_BREAKPOINT is not set
> > # CONFIG_SAMPLE_KFIFO is not set
> > # CONFIG_SAMPLE_LIVEPATCH is not set
> > # CONFIG_SAMPLE_CONFIGFS is not set
> > # CONFIG_SAMPLE_CONNECTOR is not set
> > # CONFIG_SAMPLE_SECCOMP is not set
> > # CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
> > # CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
> > # CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
> > # CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
> > CONFIG_HAVE_ARCH_KGDB=y
> > # CONFIG_KGDB is not set
> > CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> > # CONFIG_UBSAN is not set
> > CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
> > CONFIG_STRICT_DEVMEM=y
> > # CONFIG_IO_STRICT_DEVMEM is not set
> > CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> > CONFIG_EARLY_PRINTK_USB=y
> > CONFIG_X86_VERBOSE_BOOTUP=y
> > CONFIG_EARLY_PRINTK=y
> > CONFIG_EARLY_PRINTK_DBGP=y
> > CONFIG_EARLY_PRINTK_EFI=y
> > CONFIG_EARLY_PRINTK_USB_XDBC=y
> > # CONFIG_X86_PTDUMP is not set
> > # CONFIG_EFI_PGT_DUMP is not set
> > # CONFIG_DEBUG_WX is not set
> > CONFIG_DOUBLEFAULT=y
> > # CONFIG_DEBUG_TLBFLUSH is not set
> > CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> > CONFIG_X86_DECODER_SELFTEST=y
> > CONFIG_IO_DELAY_TYPE_0X80=0
> > CONFIG_IO_DELAY_TYPE_0XED=1
> > CONFIG_IO_DELAY_TYPE_UDELAY=2
> > CONFIG_IO_DELAY_TYPE_NONE=3
> > CONFIG_IO_DELAY_0X80=y
> > # CONFIG_IO_DELAY_0XED is not set
> > # CONFIG_IO_DELAY_UDELAY is not set
> > # CONFIG_IO_DELAY_NONE is not set
> > CONFIG_DEFAULT_IO_DELAY_TYPE=0
> > CONFIG_DEBUG_BOOT_PARAMS=y
> > # CONFIG_CPA_DEBUG is not set
> > CONFIG_OPTIMIZE_INLINING=y
> > # CONFIG_DEBUG_ENTRY is not set
> > # CONFIG_DEBUG_NMI_SELFTEST is not set
> > # CONFIG_X86_DEBUG_FPU is not set
> > # CONFIG_PUNIT_ATOM_DEBUG is not set
> > CONFIG_UNWINDER_ORC=y
> > # CONFIG_UNWINDER_FRAME_POINTER is not set
> > # CONFIG_UNWINDER_GUESS is not set
> 
> > #!/bin/sh
> > 
> > export_top_env()
> > {
> > 	export suite='kernel-selftests'
> > 	export testcase='kernel-selftests'
> > 	export category='functional'
> > 	export kconfig='x86_64-rhel-8.3-kselftests'
> > 	export job_origin='kernel-selftests-bm.yaml'
> > 	export queue='validate'
> > 	export testbox='lkp-hsw-d03'
> > 	export commit='ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > 	export branch='linux-stable-rc/linux-4.19.y'
> > 	export name='/cephfs/jenkins/jobs/lkp-stable/workspace@5/lkp-customers/linux/stable/function/lkp-hsw-d03/kernel-selftests-bm.yaml'
> > 	export kernel_cmdline=
> > 	export tbox_group='lkp-hsw-d03'
> > 	export submit_id='6054c82dd92e662c78ae2adf'
> > 	export job_file='/lkp/jobs/scheduled/lkp-hsw-d03/kernel-selftests-net-ucode=0x28-debian-10.4-x86_64-20200603.cgz-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5-20210319-11384-5xsj69-5.yaml'
> > 	export id='0460e04a1917cb144600ae77b4874ae829182230'
> > 	export queuer_version='/lkp-src'
> > 	export model='Haswell'
> > 	export nr_node=1
> > 	export nr_cpu=8
> > 	export memory='16G'
> > 	export nr_ssd_partitions=1
> > 	export nr_hdd_partitions=4
> > 	export hdd_partitions='/dev/disk/by-id/ata-ST31000524AS_6VPHDMY6-part*'
> > 	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2KW480H6_CVLT625008W6480EGN-part1'
> > 	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2KW480H6_CVLT625008W6480EGN-part2'
> > 	export brand='Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz'
> > 	export ucode='0x28'
> > 	export need_kconfig_hw='CONFIG_E1000E=y
> > CONFIG_SATA_AHCI'
> > 	export need_linux_headers=true
> > 	export need_linux_selftests=true
> > 	export need_kselftests=true
> > 	export need_kconfig='CONFIG_USER_NS=y
> > CONFIG_BPF_SYSCALL=y
> > CONFIG_TEST_BPF=m
> > CONFIG_NUMA=y ~ ">= v5.6-rc1"
> > CONFIG_NET_VRF=y ~ ">= v4.3-rc1"
> > CONFIG_NET_L3_MASTER_DEV=y ~ ">= v4.4-rc1"
> > CONFIG_IPV6=y
> > CONFIG_IPV6_MULTIPLE_TABLES=y
> > CONFIG_VETH=y
> > CONFIG_NET_IPVTI=m
> > CONFIG_IPV6_VTI=m
> > CONFIG_DUMMY=y
> > CONFIG_BRIDGE=y
> > CONFIG_VLAN_8021Q=y
> > CONFIG_IFB=y
> > CONFIG_NETFILTER=y
> > CONFIG_NETFILTER_ADVANCED=y
> > CONFIG_NF_CONNTRACK=m
> > CONFIG_NF_NAT=m ~ ">= v5.1-rc1"
> > CONFIG_IP6_NF_IPTABLES=m
> > CONFIG_IP_NF_IPTABLES=m
> > CONFIG_IP6_NF_NAT=m
> > CONFIG_IP_NF_NAT=m
> > CONFIG_NF_TABLES=m
> > CONFIG_NF_TABLES_IPV6=y ~ ">= v4.17-rc1"
> > CONFIG_NF_TABLES_IPV4=y ~ ">= v4.17-rc1"
> > CONFIG_NFT_CHAIN_NAT_IPV6=m ~ "<= v5.0"
> > CONFIG_NFT_CHAIN_NAT_IPV4=m ~ "<= v5.0"
> > CONFIG_NET_SCH_FQ=m
> > CONFIG_NET_SCH_ETF=m ~ ">= v4.19-rc1"
> > CONFIG_NET_SCH_NETEM=y
> > CONFIG_TEST_BLACKHOLE_DEV=m ~ ">= v5.3-rc1"
> > CONFIG_KALLSYMS=y
> > CONFIG_BAREUDP=m ~ ">= v5.7-rc1"
> > CONFIG_MPLS_ROUTING=m ~ ">= v4.1-rc1"
> > CONFIG_MPLS_IPTUNNEL=m ~ ">= v4.3-rc1"
> > CONFIG_NET_SCH_INGRESS=y ~ ">= v4.19-rc1"
> > CONFIG_NET_CLS_FLOWER=m ~ ">= v4.2-rc1"
> > CONFIG_NET_ACT_TUNNEL_KEY=m ~ ">= v4.9-rc1"
> > CONFIG_NET_ACT_MIRRED=m ~ ">= v5.11-rc1"'
> > 	export rootfs='debian-10.4-x86_64-20200603.cgz'
> > 	export enqueue_time='2021-03-19 23:50:05 +0800'
> > 	export compiler='gcc-9'
> > 	export _id='6054c832d92e662c78ae2ae3'
> > 	export _rt='/result/kernel-selftests/net-ucode=0x28/lkp-hsw-d03/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > 	export user='lkp'
> > 	export LKP_SERVER='internal-lkp-server'
> > 	export result_root='/result/kernel-selftests/net-ucode=0x28/lkp-hsw-d03/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/3'
> > 	export scheduler_version='/lkp/lkp/.src-20210319-191423'
> > 	export arch='x86_64'
> > 	export max_uptime=2100
> > 	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
> > 	export bootloader_append='root=/dev/ram0
> > user=lkp
> > job=/lkp/jobs/scheduled/lkp-hsw-d03/kernel-selftests-net-ucode=0x28-debian-10.4-x86_64-20200603.cgz-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5-20210319-11384-5xsj69-5.yaml
> > ARCH=x86_64
> > kconfig=x86_64-rhel-8.3-kselftests
> > branch=linux-stable-rc/linux-4.19.y
> > commit=ecec31ce4f33c927997f179f5d8f1bc4efdd68b5
> > BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/vmlinuz-4.19.52-00069-gecec31ce4f33c
> > max_uptime=2100
> > RESULT_ROOT=/result/kernel-selftests/net-ucode=0x28/lkp-hsw-d03/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/3
> > LKP_SERVER=internal-lkp-server
> > nokaslr
> > selinux=0
> > debug
> > apic=debug
> > sysrq_always_enabled
> > rcupdate.rcu_cpu_stall_timeout=100
> > net.ifnames=0
> > printk.devkmsg=on
> > panic=-1
> > softlockup_panic=1
> > nmi_watchdog=panic
> > oops=panic
> > load_ramdisk=2
> > prompt_ramdisk=0
> > drbd.minor_count=8
> > systemd.log_level=err
> > ignore_loglevel
> > console=tty0
> > earlyprintk=ttyS0,115200
> > console=ttyS0,115200
> > vga=normal
> > rw'
> > 	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/modules.cgz'
> > 	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/linux-headers.cgz'
> > 	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/linux-selftests.cgz'
> > 	export kselftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/kselftests.cgz'
> > 	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20201231.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-b553cffa-1_20210122.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
> > 	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
> > 	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
> > 	export site='inn'
> > 	export LKP_CGI_PORT=80
> > 	export LKP_CIFS_PORT=139
> > 	export last_kernel='4.19.181'
> > 	export repeat_to=6
> > 	export queue_cmdline_keys='branch
> > commit
> > queue_at_least_once'
> > 	export queue_at_least_once=1
> > 	export kernel='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/vmlinuz-4.19.52-00069-gecec31ce4f33c'
> > 	export dequeue_time='2021-03-20 00:05:36 +0800'
> > 	export job_initrd='/lkp/jobs/scheduled/lkp-hsw-d03/kernel-selftests-net-ucode=0x28-debian-10.4-x86_64-20200603.cgz-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5-20210319-11384-5xsj69-5.cgz'
> > 
> > 	[ -n "$LKP_SRC" ] ||
> > 	export LKP_SRC=/lkp/${user:-lkp}/src
> > }
> > 
> > run_job()
> > {
> > 	echo $$ > $TMP/run-job.pid
> > 
> > 	. $LKP_SRC/lib/http.sh
> > 	. $LKP_SRC/lib/job.sh
> > 	. $LKP_SRC/lib/env.sh
> > 
> > 	export_top_env
> > 
> > 	run_monitor $LKP_SRC/monitors/wrapper kmsg
> > 	run_monitor $LKP_SRC/monitors/wrapper heartbeat
> > 	run_monitor $LKP_SRC/monitors/wrapper meminfo
> > 	run_monitor $LKP_SRC/monitors/wrapper oom-killer
> > 	run_monitor $LKP_SRC/monitors/plain/watchdog
> > 
> > 	run_test group='net' $LKP_SRC/tests/wrapper kernel-selftests
> > }
> > 
> > extract_stats()
> > {
> > 	export stats_part_begin=
> > 	export stats_part_end=
> > 
> > 	env group='net' $LKP_SRC/stats/wrapper kernel-selftests
> > 	$LKP_SRC/stats/wrapper kmsg
> > 	$LKP_SRC/stats/wrapper meminfo
> > 
> > 	$LKP_SRC/stats/wrapper time kernel-selftests.time
> > 	$LKP_SRC/stats/wrapper dmesg
> > 	$LKP_SRC/stats/wrapper kmsg
> > 	$LKP_SRC/stats/wrapper last_state
> > 	$LKP_SRC/stats/wrapper stderr
> > 	$LKP_SRC/stats/wrapper time
> > }
> > 
> > "$@"
> 
> 
> > KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5
> > 2021-03-19 16:06:56 mount --bind /lib/modules/4.19.52-00069-gecec31ce4f33c/kernel/lib /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/lib
> > 2021-03-19 16:17:11 make -C bpf
> > make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf'
> > gcc -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/urandom_read -static urandom_read.c -Wl,--build-id
> > make -C ../../../lib/bpf OUTPUT=/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/
> > make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/lib/bpf'
> >   HOSTCC   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/fixdep.o
> >   HOSTLD   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/fixdep-in.o
> >   LINK     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/fixdep
> >   CC       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.o
> >   CC       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/bpf.o
> >   CC       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/nlattr.o
> >   CC       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/btf.o
> >   CC       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf_errno.o
> >   CC       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/str_error.o
> >   LD       /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf-in.o
> >   LINK     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a
> >   LINK     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.so
> > make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/lib/bpf'
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_verifier.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_verifier
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_tag.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_tag
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_maps.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_maps
> > In file included from test_maps.c:16:
> > test_maps.c: In function ‘run_all_tests’:
> > test_maps.c:917:10: warning: array subscript -1 is below array bounds of ‘pid_t[<U5120> + 1]’ [-Warray-bounds]
> >    assert(waitpid(pid[i], &status, 0) == pid[i]);
> >           ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > test_maps.c:897:6: warning: array subscript -1 is below array bounds of ‘pid_t[<U5120> + 1]’ [-Warray-bounds]
> >    pid[i] = fork();
> >    ~~~^~~
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_lru_map.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_lru_map
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_lpm_map.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_lpm_map
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_progs.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a trace_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_progs
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_align.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_align
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_verifier_log.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_verifier_log
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_dev_cgroup.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_dev_cgroup
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_tcpbpf_user.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_tcpbpf_user
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_sock.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_sock
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_btf.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_btf
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_sockmap.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_sockmap
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_lirc_mode2_user.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_lirc_mode2_user
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    get_cgroup_id_user.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/get_cgroup_id_user
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_socket_cookie.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_socket_cookie
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_cgroup_storage.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_cgroup_storage
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_select_reuseport.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_select_reuseport
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_libbpf_open.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_libbpf_open
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_sock_addr.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_sock_addr
> > gcc -Wall -O2 -I../../../include/uapi -I../../../lib -I../../../lib/bpf -I../../../../include/generated -DHAVE_GENHDR -I../../../include    test_skb_cgroup_id_user.c /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/libbpf.a cgroup_helpers.c -lcap -lelf -lrt -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf/test_skb_cgroup_id_user
> > make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/bpf'
> > LKP SKIP net.l2tp.sh
> > 2021-03-19 16:17:16 make -C ../../../tools/testing/selftests/net
> > make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net'
> > make ARCH=x86 -C ../../../.. headers_install
> > make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> >   HOSTCC  scripts/basic/fixdep
> >   HOSTCC  arch/x86/tools/relocs_32.o
> >   HOSTCC  arch/x86/tools/relocs_64.o
> >   HOSTCC  arch/x86/tools/relocs_common.o
> >   HOSTLD  arch/x86/tools/relocs
> >   HOSTCC  scripts/unifdef
> >   INSTALL usr/include/asm-generic/ (37 files)
> >   INSTALL usr/include/drm/ (26 files)
> >   INSTALL usr/include/linux/ (499 files)
> >   INSTALL usr/include/linux/android/ (1 file)
> >   INSTALL usr/include/linux/byteorder/ (2 files)
> >   INSTALL usr/include/linux/caif/ (2 files)
> >   INSTALL usr/include/linux/can/ (6 files)
> >   INSTALL usr/include/linux/cifs/ (1 file)
> >   INSTALL usr/include/linux/dvb/ (8 files)
> >   INSTALL usr/include/linux/genwqe/ (1 file)
> >   INSTALL usr/include/linux/hdlc/ (1 file)
> >   INSTALL usr/include/linux/hsi/ (2 files)
> >   INSTALL usr/include/linux/iio/ (2 files)
> >   INSTALL usr/include/linux/isdn/ (1 file)
> >   INSTALL usr/include/linux/mmc/ (1 file)
> >   INSTALL usr/include/linux/netfilter/ (88 files)
> >   INSTALL usr/include/linux/netfilter/ipset/ (4 files)
> >   INSTALL usr/include/linux/netfilter_arp/ (2 files)
> >   INSTALL usr/include/linux/netfilter_bridge/ (17 files)
> >   INSTALL usr/include/linux/netfilter_ipv4/ (9 files)
> >   INSTALL usr/include/linux/netfilter_ipv6/ (13 files)
> >   INSTALL usr/include/linux/nfsd/ (5 files)
> >   INSTALL usr/include/linux/raid/ (2 files)
> >   INSTALL usr/include/linux/sched/ (1 file)
> >   INSTALL usr/include/linux/spi/ (1 file)
> >   INSTALL usr/include/linux/sunrpc/ (1 file)
> >   INSTALL usr/include/linux/tc_act/ (15 files)
> >   INSTALL usr/include/linux/tc_ematch/ (5 files)
> >   INSTALL usr/include/linux/usb/ (13 files)
> >   INSTALL usr/include/linux/wimax/ (1 file)
> >   INSTALL usr/include/misc/ (2 files)
> >   INSTALL usr/include/mtd/ (5 files)
> >   INSTALL usr/include/rdma/ (25 files)
> >   INSTALL usr/include/rdma/hfi/ (2 files)
> >   INSTALL usr/include/scsi/ (4 files)
> >   INSTALL usr/include/scsi/fc/ (4 files)
> >   INSTALL usr/include/sound/ (16 files)
> >   INSTALL usr/include/video/ (3 files)
> >   INSTALL usr/include/xen/ (4 files)
> >   INSTALL usr/include/asm/ (62 files)
> > make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net'
> > 2021-03-19 16:17:26 make install INSTALL_PATH=/usr/bin/ -C ../../../tools/testing/selftests/net
> > make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net'
> > make ARCH=x86 -C ../../../.. headers_install
> > make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport_bpf.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_bpf
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport_bpf_cpu.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_bpf_cpu
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport_bpf_numa.c -lnuma -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_bpf_numa
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport_dualstack.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_dualstack
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseaddr_conflict.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseaddr_conflict
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tls.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/tls
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    socket.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/socket
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_fanout.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/psock_fanout
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_tpacket.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/psock_tpacket
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    msg_zerocopy.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/msg_zerocopy
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/  -lpthread  tcp_mmap.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/tcp_mmap
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/  -lpthread  tcp_inq.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/tcp_inq
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_snd.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/psock_snd
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/udpgso
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso_bench_tx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/udpgso_bench_tx
> > gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso_bench_rx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/udpgso_bench_rx
> > rsync -a run_netsocktests run_afpackettests test_bpf.sh netdevice.sh rtnetlink.sh fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh in_netns.sh  /usr/bin//
> > rsync -a /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_bpf /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_bpf_cpu /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_bpf_numa /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseport_dualstack /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/reuseaddr_conflict /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/tls   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/socket /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/psock_fanout /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/psock_tpacket /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/msg_zerocopy /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/tcp_mmap /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/tcp_inq /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/psock_snd /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/udpgso /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/udpgso_bench_tx /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net/udpgso_bench_rx /usr/bin//
> > make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net'
> > LKP WARN miss target net
> > 2021-03-19 16:17:29 make run_tests -C net
> > make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net'
> > make ARCH=x86 -C ../../../.. headers_install
> > make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5'
> > TAP version 13
> > selftests: net: reuseport_bpf
> > ========================================
> > ---- IPv4 UDP ----
> > Testing EBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing EBPF mod 20...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 10: 10
> > Socket 11: 11
> > Socket 12: 12
> > Socket 13: 13
> > Socket 14: 14
> > Socket 15: 15
> > Socket 16: 16
> > Socket 17: 17
> > Socket 18: 18
> > Socket 19: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 10: 30
> > Socket 11: 31
> > Socket 12: 32
> > Socket 13: 33
> > Socket 14: 34
> > Socket 15: 35
> > Socket 16: 36
> > Socket 17: 37
> > Socket 18: 38
> > Socket 19: 39
> > Reprograming, testing mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 0: 30
> > Socket 1: 31
> > Socket 2: 32
> > Socket 3: 33
> > Socket 4: 34
> > Socket 5: 35
> > Socket 6: 36
> > Socket 7: 37
> > Socket 8: 38
> > Socket 9: 39
> > Testing CBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 20...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 10: 10
> > Socket 11: 11
> > Socket 12: 12
> > Socket 13: 13
> > Socket 14: 14
> > Socket 15: 15
> > Socket 16: 16
> > Socket 17: 17
> > Socket 18: 18
> > Socket 19: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 10: 30
> > Socket 11: 31
> > Socket 12: 32
> > Socket 13: 33
> > Socket 14: 34
> > Socket 15: 35
> > Socket 16: 36
> > Socket 17: 37
> > Socket 18: 38
> > Socket 19: 39
> > Reprograming, testing mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 0: 30
> > Socket 1: 31
> > Socket 2: 32
> > Socket 3: 33
> > Socket 4: 34
> > Socket 5: 35
> > Socket 6: 36
> > Socket 7: 37
> > Socket 8: 38
> > Socket 9: 39
> > Testing too many filters...
> > Testing filters on non-SO_REUSEPORT socket...
> > ---- IPv6 UDP ----
> > Testing EBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing EBPF mod 20...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 10: 10
> > Socket 11: 11
> > Socket 12: 12
> > Socket 13: 13
> > Socket 14: 14
> > Socket 15: 15
> > Socket 16: 16
> > Socket 17: 17
> > Socket 18: 18
> > Socket 19: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 10: 30
> > Socket 11: 31
> > Socket 12: 32
> > Socket 13: 33
> > Socket 14: 34
> > Socket 15: 35
> > Socket 16: 36
> > Socket 17: 37
> > Socket 18: 38
> > Socket 19: 39
> > Reprograming, testing mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 0: 30
> > Socket 1: 31
> > Socket 2: 32
> > Socket 3: 33
> > Socket 4: 34
> > Socket 5: 35
> > Socket 6: 36
> > Socket 7: 37
> > Socket 8: 38
> > Socket 9: 39
> > Testing CBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 20...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 10: 10
> > Socket 11: 11
> > Socket 12: 12
> > Socket 13: 13
> > Socket 14: 14
> > Socket 15: 15
> > Socket 16: 16
> > Socket 17: 17
> > Socket 18: 18
> > Socket 19: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 10: 30
> > Socket 11: 31
> > Socket 12: 32
> > Socket 13: 33
> > Socket 14: 34
> > Socket 15: 35
> > Socket 16: 36
> > Socket 17: 37
> > Socket 18: 38
> > Socket 19: 39
> > Reprograming, testing mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 0: 30
> > Socket 1: 31
> > Socket 2: 32
> > Socket 3: 33
> > Socket 4: 34
> > Socket 5: 35
> > Socket 6: 36
> > Socket 7: 37
> > Socket 8: 38
> > Socket 9: 39
> > Testing too many filters...
> > Testing filters on non-SO_REUSEPORT socket...
> > ---- IPv6 UDP w/ mapped IPv4 ----
> > Testing EBPF mod 20...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 10: 10
> > Socket 11: 11
> > Socket 12: 12
> > Socket 13: 13
> > Socket 14: 14
> > Socket 15: 15
> > Socket 16: 16
> > Socket 17: 17
> > Socket 18: 18
> > Socket 19: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 10: 30
> > Socket 11: 31
> > Socket 12: 32
> > Socket 13: 33
> > Socket 14: 34
> > Socket 15: 35
> > Socket 16: 36
> > Socket 17: 37
> > Socket 18: 38
> > Socket 19: 39
> > Reprograming, testing mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 0: 30
> > Socket 1: 31
> > Socket 2: 32
> > Socket 3: 33
> > Socket 4: 34
> > Socket 5: 35
> > Socket 6: 36
> > Socket 7: 37
> > Socket 8: 38
> > Socket 9: 39
> > Testing EBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 20...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 10: 10
> > Socket 11: 11
> > Socket 12: 12
> > Socket 13: 13
> > Socket 14: 14
> > Socket 15: 15
> > Socket 16: 16
> > Socket 17: 17
> > Socket 18: 18
> > Socket 19: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 10: 30
> > Socket 11: 31
> > Socket 12: 32
> > Socket 13: 33
> > Socket 14: 34
> > Socket 15: 35
> > Socket 16: 36
> > Socket 17: 37
> > Socket 18: 38
> > Socket 19: 39
> > Reprograming, testing mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Socket 0: 20
> > Socket 1: 21
> > Socket 2: 22
> > Socket 3: 23
> > Socket 4: 24
> > Socket 5: 25
> > Socket 6: 26
> > Socket 7: 27
> > Socket 8: 28
> > Socket 9: 29
> > Socket 0: 30
> > Socket 1: 31
> > Socket 2: 32
> > Socket 3: 33
> > Socket 4: 34
> > Socket 5: 35
> > Socket 6: 36
> > Socket 7: 37
> > Socket 8: 38
> > Socket 9: 39
> > ---- IPv4 TCP ----
> > Testing EBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing too many filters...
> > Testing filters on non-SO_REUSEPORT socket...
> > ---- IPv6 TCP ----
> > Testing EBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing too many filters...
> > Testing filters on non-SO_REUSEPORT socket...
> > ---- IPv6 TCP w/ mapped IPv4 ----
> > Testing EBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing CBPF mod 10...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 5: 5
> > Socket 6: 6
> > Socket 7: 7
> > Socket 8: 8
> > Socket 9: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 5: 15
> > Socket 6: 16
> > Socket 7: 17
> > Socket 8: 18
> > Socket 9: 19
> > Reprograming, testing mod 5...
> > Socket 0: 0
> > Socket 1: 1
> > Socket 2: 2
> > Socket 3: 3
> > Socket 4: 4
> > Socket 0: 5
> > Socket 1: 6
> > Socket 2: 7
> > Socket 3: 8
> > Socket 4: 9
> > Socket 0: 10
> > Socket 1: 11
> > Socket 2: 12
> > Socket 3: 13
> > Socket 4: 14
> > Socket 0: 15
> > Socket 1: 16
> > Socket 2: 17
> > Socket 3: 18
> > Socket 4: 19
> > Testing filter add without bind...
> > SUCCESS
> > ok 1..1 selftests: net: reuseport_bpf [PASS]
> > selftests: net: reuseport_bpf_cpu
> > ========================================
> > ---- IPv4 UDP ----
> > send cpu 0, receive socket 0
> > send cpu 1, receive socket 1
> > send cpu 2, receive socket 2
> > send cpu 3, receive socket 3
> > send cpu 4, receive socket 4
> > send cpu 5, receive socket 5
> > send cpu 6, receive socket 6
> > send cpu 7, receive socket 7
> > send cpu 7, receive socket 7
> > send cpu 6, receive socket 6
> > send cpu 5, receive socket 5
> > send cpu 4, receive socket 4
> > send cpu 3, receive socket 3
> > send cpu 2, receive socket 2
> > send cpu 1, receive socket 1
> > send cpu 0, receive socket 0
> > send cpu 0, receive socket 0
> > send cpu 2, receive socket 2
> > send cpu 4, receive socket 4
> > send cpu 6, receive socket 6
> > send cpu 1, receive socket 1
> > send cpu 3, receive socket 3
> > send cpu 5, receive socket 5
> > send cpu 7, receive socket 7
> > ---- IPv6 UDP ----
> > send cpu 0, receive socket 0
> > send cpu 1, receive socket 1
> > send cpu 2, receive socket 2
> > send cpu 3, receive socket 3
> > send cpu 4, receive socket 4
> > send cpu 5, receive socket 5
> > send cpu 6, receive socket 6
> > send cpu 7, receive socket 7
> > send cpu 7, receive socket 7
> > send cpu 6, receive socket 6
> > send cpu 5, receive socket 5
> > send cpu 4, receive socket 4
> > send cpu 3, receive socket 3
> > send cpu 2, receive socket 2
> > send cpu 1, receive socket 1
> > send cpu 0, receive socket 0
> > send cpu 0, receive socket 0
> > send cpu 2, receive socket 2
> > send cpu 4, receive socket 4
> > send cpu 6, receive socket 6
> > send cpu 1, receive socket 1
> > send cpu 3, receive socket 3
> > send cpu 5, receive socket 5
> > send cpu 7, receive socket 7
> > ---- IPv4 TCP ----
> > send cpu 0, receive socket 0
> > send cpu 1, receive socket 1
> > send cpu 2, receive socket 2
> > send cpu 3, receive socket 3
> > send cpu 4, receive socket 4
> > send cpu 5, receive socket 5
> > send cpu 6, receive socket 6
> > send cpu 7, receive socket 7
> > send cpu 7, receive socket 7
> > send cpu 6, receive socket 6
> > send cpu 5, receive socket 5
> > send cpu 4, receive socket 4
> > send cpu 3, receive socket 3
> > send cpu 2, receive socket 2
> > send cpu 1, receive socket 1
> > send cpu 0, receive socket 0
> > send cpu 0, receive socket 0
> > send cpu 2, receive socket 2
> > send cpu 4, receive socket 4
> > send cpu 6, receive socket 6
> > send cpu 1, receive socket 1
> > send cpu 3, receive socket 3
> > send cpu 5, receive socket 5
> > send cpu 7, receive socket 7
> > ---- IPv6 TCP ----
> > send cpu 0, receive socket 0
> > send cpu 1, receive socket 1
> > send cpu 2, receive socket 2
> > send cpu 3, receive socket 3
> > send cpu 4, receive socket 4
> > send cpu 5, receive socket 5
> > send cpu 6, receive socket 6
> > send cpu 7, receive socket 7
> > send cpu 7, receive socket 7
> > send cpu 6, receive socket 6
> > send cpu 5, receive socket 5
> > send cpu 4, receive socket 4
> > send cpu 3, receive socket 3
> > send cpu 2, receive socket 2
> > send cpu 1, receive socket 1
> > send cpu 0, receive socket 0
> > send cpu 0, receive socket 0
> > send cpu 2, receive socket 2
> > send cpu 4, receive socket 4
> > send cpu 6, receive socket 6
> > send cpu 1, receive socket 1
> > send cpu 3, receive socket 3
> > send cpu 5, receive socket 5
> > send cpu 7, receive socket 7
> > SUCCESS
> > ok 1..2 selftests: net: reuseport_bpf_cpu [PASS]
> > selftests: net: reuseport_bpf_numa
> > ========================================
> > ---- IPv4 UDP ----
> > send node 0, receive socket 0
> > send node 0, receive socket 0
> > ---- IPv6 UDP ----
> > send node 0, receive socket 0
> > send node 0, receive socket 0
> > ---- IPv4 TCP ----
> > send node 0, receive socket 0
> > send node 0, receive socket 0
> > ---- IPv6 TCP ----
> > send node 0, receive socket 0
> > send node 0, receive socket 0
> > SUCCESS
> > ok 1..3 selftests: net: reuseport_bpf_numa [PASS]
> > selftests: net: reuseport_dualstack
> > ========================================
> > ---- UDP IPv4 created before IPv6 ----
> > ---- UDP IPv6 created before IPv4 ----
> > ---- UDP IPv4 created before IPv6 (large) ----
> > ---- UDP IPv6 created before IPv4 (large) ----
> > ---- TCP IPv4 created before IPv6 ----
> > ---- TCP IPv6 created before IPv4 ----
> > SUCCESS
> > ok 1..4 selftests: net: reuseport_dualstack [PASS]
> > selftests: net: reuseaddr_conflict
> > ========================================
> > Opening 127.0.0.1:9999
> > Opening INADDR_ANY:9999
> > bind: Address already in use
> > Opening in6addr_any:9999
> > Opening INADDR_ANY:9999
> > bind: Address already in use
> > Opening INADDR_ANY:9999 after closing ipv6 socket
> > bind: Address already in use
> > Successok 1..5 selftests: net: reuseaddr_conflict [PASS]
> > selftests: net: tls
> > ========================================
> > [==========] Running 28 tests from 2 test cases.
> > [ RUN      ] tls.sendfile
> > [       OK ] tls.sendfile
> > [ RUN      ] tls.send_then_sendfile
> > [       OK ] tls.send_then_sendfile
> > [ RUN      ] tls.recv_max
> > [       OK ] tls.recv_max
> > [ RUN      ] tls.recv_small
> > [       OK ] tls.recv_small
> > [ RUN      ] tls.msg_more
> > [       OK ] tls.msg_more
> > [ RUN      ] tls.sendmsg_single
> > [       OK ] tls.sendmsg_single
> > [ RUN      ] tls.sendmsg_large
> > [       OK ] tls.sendmsg_large
> > [ RUN      ] tls.sendmsg_multiple
> > [       OK ] tls.sendmsg_multiple
> > [ RUN      ] tls.sendmsg_multiple_stress
> > [       OK ] tls.sendmsg_multiple_stress
> > [ RUN      ] tls.splice_from_pipe
> > [       OK ] tls.splice_from_pipe
> > [ RUN      ] tls.splice_from_pipe2
> > [       OK ] tls.splice_from_pipe2
> > [ RUN      ] tls.send_and_splice
> > [       OK ] tls.send_and_splice
> > [ RUN      ] tls.splice_to_pipe
> > [       OK ] tls.splice_to_pipe
> > [ RUN      ] tls.recvmsg_single
> > [       OK ] tls.recvmsg_single
> > [ RUN      ] tls.recvmsg_single_max
> > [       OK ] tls.recvmsg_single_max
> > [ RUN      ] tls.recvmsg_multiple
> > [       OK ] tls.recvmsg_multiple
> > [ RUN      ] tls.single_send_multiple_recv
> > [       OK ] tls.single_send_multiple_recv
> > [ RUN      ] tls.multiple_send_single_recv
> > [       OK ] tls.multiple_send_single_recv
> > [ RUN      ] tls.recv_partial
> > [       OK ] tls.recv_partial
> > [ RUN      ] tls.recv_nonblock
> > [       OK ] tls.recv_nonblock
> > [ RUN      ] tls.recv_peek
> > [       OK ] tls.recv_peek
> > [ RUN      ] tls.recv_peek_multiple
> > [       OK ] tls.recv_peek_multiple
> > [ RUN      ] tls.recv_peek_multiple_records
> > [       OK ] tls.recv_peek_multiple_records
> > [ RUN      ] tls.pollin
> > [       OK ] tls.pollin
> > [ RUN      ] tls.poll_wait
> > [       OK ] tls.poll_wait
> > [ RUN      ] tls.blocking
> > [       OK ] tls.blocking
> > [ RUN      ] tls.nonblocking
> > [       OK ] tls.nonblocking
> > [ RUN      ] tls.control_msg
> > [       OK ] tls.control_msg
> > [==========] 28 / 28 tests passed.
> > [  PASSED  ]
> > ok 1..6 selftests: net: tls [PASS]
> > selftests: net: run_netsocktests
> > ========================================
> > --------------------
> > running socket test
> > --------------------
> > socket(44, 0, 0) expected err (Address family not supported by protocol) got (Socket type not supported)
> > [FAIL]
> > not ok 1..7 selftests: net: run_netsocktests [FAIL]
> > selftests: net: run_afpackettests
> > ========================================
> > --------------------
> > running psock_fanout test
> > --------------------
> > test: control single socket
> > test: control multiple sockets
> > test: unique ids
> > 
> > test: datapath 0x0 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=15,5, expect=15,5
> > info: count=20,5, expect=20,5
> > 
> > test: datapath 0x1000 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=15,5, expect=15,5
> > info: count=20,15, expect=20,15
> > 
> > test: datapath 0x1 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=10,10, expect=10,10
> > info: count=17,18, expect=18,17
> > 
> > test: datapath 0x3 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=15,5, expect=15,5
> > info: count=20,15, expect=20,15
> > 
> > test: datapath 0x6 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=5,15, expect=15,5
> > info: count=20,15, expect=15,20
> > 
> > test: datapath 0x7 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=5,15, expect=15,5
> > info: count=20,15, expect=15,20
> > 
> > test: datapath 0x2 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=20,0, expect=20,0
> > info: count=20,0, expect=20,0
> > 
> > test: datapath 0x2 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=0,20, expect=0,20
> > info: count=0,20, expect=0,20
> > 
> > test: datapath 0x2000 ports 8000,8002
> > info: count=0,0, expect=0,0
> > info: count=20,20, expect=20,20
> > info: count=20,20, expect=20,20
> > OK. All tests passed
> > [PASS]
> > --------------------
> > running psock_tpacket test
> > --------------------
> > test: TPACKET_V1 with PACKET_RX_RING .................... 100 pkts (14200 bytes)
> > test: TPACKET_V1 with PACKET_TX_RING .................... 100 pkts (14200 bytes)
> > test: TPACKET_V2 with PACKET_RX_RING .................... 100 pkts (14200 bytes)
> > test: TPACKET_V2 with PACKET_TX_RING .................... 100 pkts (14200 bytes)
> > test: TPACKET_V3 with PACKET_RX_RING .................... 100 pkts (14200 bytes)
> > test: TPACKET_V3 with PACKET_TX_RING .................... 100 pkts (14200 bytes)
> > OK. All tests passed
> > [PASS]
> > ok 1..8 selftests: net: run_afpackettests [PASS]
> > selftests: net: test_bpf.sh
> > ========================================
> > test_bpf: ok
> > ok 1..9 selftests: net: test_bpf.sh [PASS]
> > selftests: net: netdevice.sh
> > ========================================
> > SKIP: eth0: interface already up
> > PASS: eth0: ethtool list features
> > PASS: eth0: ethtool dump
> > PASS: eth0: ethtool stats
> > SKIP: eth0: interface kept up
> > PASS: eth1: set interface up
> > PASS: eth1: set MAC address
> > SKIP: eth1: set IP address
> > PASS: eth1: ethtool list features
> > PASS: eth1: ethtool dump
> > PASS: eth1: ethtool stats
> > PASS: eth1: stop interface
> > ok 1..10 selftests: net: netdevice.sh [PASS]
> > selftests: net: rtnetlink.sh
> > ========================================
> > PASS: policy routing
> > PASS: route get
> > PASS: tc htb hierarchy
> > PASS: gre tunnel endpoint
> > PASS: gretap
> > PASS: ip6gretap
> > PASS: erspan
> > PASS: ip6erspan
> > PASS: bridge setup
> > PASS: ipv6 addrlabel
> > PASS: set ifalias 634292e4-dc27-408f-b41d-170f9b240f7b for test-dummy0
> > PASS: vrf
> > PASS: vxlan
> > PASS: fou
> > PASS: macsec
> > PASS: ipsec
> > PASS: ipsec_offload
> > ok 1..11 selftests: net: rtnetlink.sh [PASS]
> > selftests: net: fib_tests.sh
> > ========================================
> > 
> > Single path route test
> >     Start point
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     Nexthop device deleted
> >     TEST: IPv4 fibmatch - no route                                      [ OK ]
> >     TEST: IPv6 fibmatch - no route                                      [ OK ]
> > 
> > Multipath route test
> >     Start point
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     One nexthop device deleted
> >     TEST: IPv4 - multipath route removed on delete                      [ OK ]
> >     TEST: IPv6 - multipath down to single path                          [ OK ]
> >     Second nexthop device deleted
> >     TEST: IPv6 - no route                                               [ OK ]
> > 
> > Single path, admin down
> >     Start point
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     Route deleted on down
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> > 
> > Admin down multipath
> >     Verify start point
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     One device down, one up
> >     TEST: IPv4 fibmatch on down device                                  [ OK ]
> >     TEST: IPv6 fibmatch on down device                                  [ OK ]
> >     TEST: IPv4 fibmatch on up device                                    [ OK ]
> >     TEST: IPv6 fibmatch on up device                                    [ OK ]
> >     TEST: IPv4 flags on down device                                     [ OK ]
> >     TEST: IPv6 flags on down device                                     [ OK ]
> >     TEST: IPv4 flags on up device                                       [ OK ]
> >     TEST: IPv6 flags on up device                                       [ OK ]
> >     Other device down and up
> >     TEST: IPv4 fibmatch on down device                                  [ OK ]
> >     TEST: IPv6 fibmatch on down device                                  [ OK ]
> >     TEST: IPv4 fibmatch on up device                                    [ OK ]
> >     TEST: IPv6 fibmatch on up device                                    [ OK ]
> >     TEST: IPv4 flags on down device                                     [ OK ]
> >     TEST: IPv6 flags on down device                                     [ OK ]
> >     TEST: IPv4 flags on up device                                       [ OK ]
> >     TEST: IPv6 flags on up device                                       [ OK ]
> >     Both devices down
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> > 
> > Local carrier tests - single path
> >     Start point
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     TEST: IPv4 - no linkdown flag                                       [ OK ]
> >     TEST: IPv6 - no linkdown flag                                       [ OK ]
> >     Carrier off on nexthop
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     TEST: IPv4 - linkdown flag set                                      [ OK ]
> >     TEST: IPv6 - linkdown flag set                                      [ OK ]
> >     Route to local address with carrier down
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     TEST: IPv4 linkdown flag set                                        [ OK ]
> >     TEST: IPv6 linkdown flag set                                        [ OK ]
> > 
> > Single path route carrier test
> >     Start point
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     TEST: IPv4 no linkdown flag                                         [ OK ]
> >     TEST: IPv6 no linkdown flag                                         [ OK ]
> >     Carrier down
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     TEST: IPv4 linkdown flag set                                        [ OK ]
> >     TEST: IPv6 linkdown flag set                                        [ OK ]
> >     Second address added with carrier down
> >     TEST: IPv4 fibmatch                                                 [ OK ]
> >     TEST: IPv6 fibmatch                                                 [ OK ]
> >     TEST: IPv4 linkdown flag set                                        [ OK ]
> >     TEST: IPv6 linkdown flag set                                        [ OK ]
> > 
> > IPv4 nexthop tests
> > <<< write me >>>
> > 
> > IPv6 nexthop tests
> >     TEST: Directly connected nexthop, unicast address                   [ OK ]
> >     TEST: Directly connected nexthop, unicast address with device       [ OK ]
> >     TEST: Gateway is linklocal address                                  [ OK ]
> >     TEST: Gateway is linklocal address, no device                       [ OK ]
> >     TEST: Gateway can not be local unicast address                      [ OK ]
> >     TEST: Gateway can not be local unicast address, with device         [ OK ]
> >     TEST: Gateway can not be a local linklocal address                  [ OK ]
> >     TEST: Gateway can be local address in a VRF                         [ OK ]
> >     TEST: Gateway can be local address in a VRF, with device            [ OK ]
> >     TEST: Gateway can be local linklocal address in a VRF               [ OK ]
> >     TEST: Redirect to VRF lookup                                        [ OK ]
> >     TEST: VRF route, gateway can be local address in default VRF        [ OK ]
> >     TEST: VRF route, gateway can not be a local address                 [ OK ]
> >     TEST: VRF route, gateway can not be a local addr with device        [ OK ]
> > 
> > IPv6 route add / append tests
> >     TEST: Attempt to add duplicate route - gw                           [ OK ]
> >     TEST: Attempt to add duplicate route - dev only                     [ OK ]
> >     TEST: Attempt to add duplicate route - reject route                 [ OK ]
> >     TEST: Append nexthop to existing route - gw                         [ OK ]
> >     TEST: Add multipath route                                           [ OK ]
> >     TEST: Attempt to add duplicate multipath route                      [ OK ]
> >     TEST: Route add with different metrics                              [ OK ]
> >     TEST: Route delete with metric                                      [ OK ]
> > 
> > IPv6 route replace tests
> >     TEST: Single path with single path                                  [ OK ]
> >     TEST: Single path with multipath                                    [ OK ]
> >     TEST: Single path with single path via multipath attribute          [ OK ]
> >     TEST: Invalid nexthop                                               [ OK ]
> >     TEST: Single path - replace of non-existent route                   [ OK ]
> >     TEST: Multipath with multipath                                      [ OK ]
> >     TEST: Multipath with single path                                    [ OK ]
> >     TEST: Multipath with single path via multipath attribute            [ OK ]
> >     TEST: Multipath - invalid first nexthop                             [ OK ]
> >     TEST: Multipath - invalid second nexthop                            [ OK ]
> >     TEST: Multipath - replace of non-existent route                     [ OK ]
> > 
> > IPv4 route add / append tests
> >     TEST: Attempt to add duplicate route - gw                           [ OK ]
> >     TEST: Attempt to add duplicate route - dev only                     [ OK ]
> >     TEST: Attempt to add duplicate route - reject route                 [ OK ]
> >     TEST: Add new nexthop for existing prefix                           [ OK ]
> >     TEST: Append nexthop to existing route - gw                         [ OK ]
> >     TEST: Append nexthop to existing route - dev only                   [ OK ]
> >     TEST: Append nexthop to existing route - reject route               [ OK ]
> >     TEST: Append nexthop to existing reject route - gw                  [ OK ]
> >     TEST: Append nexthop to existing reject route - dev only            [ OK ]
> >     TEST: add multipath route                                           [ OK ]
> >     TEST: Attempt to add duplicate multipath route                      [ OK ]
> >     TEST: Route add with different metrics                              [ OK ]
> >     TEST: Route delete with metric                                      [ OK ]
> > 
> > IPv4 route replace tests
> >     TEST: Single path with single path                                  [ OK ]
> >     TEST: Single path with multipath                                    [ OK ]
> >     TEST: Single path with reject route                                 [ OK ]
> >     TEST: Single path with single path via multipath attribute          [ OK ]
> >     TEST: Invalid nexthop                                               [ OK ]
> >     TEST: Single path - replace of non-existent route                   [ OK ]
> >     TEST: Multipath with multipath                                      [ OK ]
> >     TEST: Multipath with single path                                    [ OK ]
> >     TEST: Multipath with single path via multipath attribute            [ OK ]
> >     TEST: Multipath with reject route                                   [ OK ]
> >     TEST: Multipath - invalid first nexthop                             [ OK ]
> >     TEST: Multipath - invalid second nexthop                            [ OK ]
> >     TEST: Multipath - replace of non-existent route                     [ OK ]
> > 
> > IPv6 prefix route tests
> >     TEST: Default metric                                                [ OK ]
> >     TEST: User specified metric on first device                         [ OK ]
> >     TEST: User specified metric on second device                        [ OK ]
> >     TEST: Delete of address on first device                             [ OK ]
> >     TEST: Modify metric of address                                      [ OK ]
> >     TEST: Prefix route removed on link down                             [ OK ]
> >     TEST: Prefix route with metric on link up                           [ OK ]
> > 
> > IPv4 prefix route tests
> >     TEST: Default metric                                                [ OK ]
> >     TEST: User specified metric on first device                         [ OK ]
> >     TEST: User specified metric on second device                        [ OK ]
> >     TEST: Delete of address on first device                             [ OK ]
> >     TEST: Modify metric of address                                      [ OK ]
> >     TEST: Prefix route removed on link down                             [ OK ]
> >     TEST: Prefix route with metric on link up                           [ OK ]
> > 
> > Tests passed: 130
> > Tests failed:   0
> > ok 1..12 selftests: net: fib_tests.sh [PASS]
> > selftests: net: fib-onlink-tests.sh
> > ========================================
> > 
> > ########################################
> > Configuring interfaces
> > 
> > ######################################################################
> > TEST SECTION: IPv4 onlink
> > ######################################################################
> > 
> > #########################################
> > TEST SUBSECTION: Valid onlink commands
> > 
> > #########################################
> > TEST SUBSECTION: default VRF - main table
> > 
> > COMMAND: ip ro add table 254 169.254.101.1/32 via 169.254.1.254 dev veth1 onlink
> > 
> >     TEST: unicast connected                                   [ OK ]
> > 
> > COMMAND: ip ro add table 254 169.254.101.2/32 via 169.254.11.254 dev veth1 onlink
> > 
> >     TEST: unicast recursive                                   [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: VRF lisa
> > 
> > COMMAND: ip ro add table 1101 169.254.102.1/32 via 169.254.5.254 dev veth5 onlink
> > 
> >     TEST: unicast connected                                   [ OK ]
> > 
> > COMMAND: ip ro add table 1101 169.254.102.2/32 via 169.254.12.254 dev veth5 onlink
> > 
> >     TEST: unicast recursive                                   [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: VRF device, PBR table
> > 
> > COMMAND: ip ro add table 101 169.254.102.3/32 via 169.254.5.254 dev veth5 onlink
> > 
> >     TEST: unicast connected                                   [ OK ]
> > 
> > COMMAND: ip ro add table 101 169.254.102.4/32 via 169.254.12.254 dev veth5 onlink
> > 
> >     TEST: unicast recursive                                   [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: default VRF - main table - multipath
> > 
> > COMMAND: ip ro add table 254 169.254.101.5/32 nexthop via 169.254.1.254 dev veth1 onlink nexthop via 169.254.3.254 dev veth3 onlink
> > 
> >     TEST: unicast connected - multipath                       [ OK ]
> > 
> > COMMAND: ip ro add table 254 169.254.101.6/32 nexthop via 169.254.11.254 dev veth1 onlink nexthop via 169.254.12.254 dev veth3 onlink
> > 
> >     TEST: unicast recursive - multipath                       [ OK ]
> > 
> > COMMAND: ip ro add table 254 169.254.101.7/32 nexthop via 169.254.1.254 dev veth1 nexthop via 169.254.3.254 dev veth3 onlink
> > 
> >     TEST: unicast connected - multipath onlink first only     [ OK ]
> > 
> > COMMAND: ip ro add table 254 169.254.101.8/32 nexthop via 169.254.1.254 dev veth1 onlink nexthop via 169.254.3.254 dev veth3
> > 
> >     TEST: unicast connected - multipath onlink second only    [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: Invalid onlink commands
> > 
> > COMMAND: ip ro add table 254 169.254.101.11/32 via 169.254.1.1 dev veth1 onlink
> > Error: Nexthop has invalid gateway.
> > 
> >     TEST: Invalid gw - local unicast address                  [ OK ]
> > 
> > COMMAND: ip ro add table 1101 169.254.102.11/32 via 169.254.5.1 dev veth5 onlink
> > Error: Nexthop has invalid gateway.
> > 
> >     TEST: Invalid gw - local unicast address, VRF             [ OK ]
> > 
> > COMMAND: ip ro add table 254 169.254.101.101/32 via 169.254.1.1  onlink
> > RTNETLINK answers: No such device
> > 
> >     TEST: No nexthop device given                             [ OK ]
> > 
> > COMMAND: ip ro add table 254 169.254.101.102/32 via 169.254.3.1 dev veth1 onlink
> > Error: Nexthop has invalid gateway.
> > 
> >     TEST: Gateway resolves to wrong nexthop device            [ OK ]
> > 
> > COMMAND: ip ro add table 1101 169.254.102.103/32 via 169.254.7.1 dev veth5 onlink
> > Error: Nexthop has invalid gateway.
> > 
> >     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]
> > 
> > ######################################################################
> > TEST SECTION: IPv6 onlink
> > ######################################################################
> > 
> > #########################################
> > TEST SUBSECTION: Valid onlink commands
> > 
> > #########################################
> > TEST SUBSECTION: default VRF - main table
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::1/128 via 2001:db8:101::64 dev veth1 onlink
> > 
> >     TEST: unicast connected                                   [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::2/128 via 2001:db8:11::64 dev veth1 onlink
> > 
> >     TEST: unicast recursive                                   [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::3/128 via ::ffff:10.1.1.254 dev veth1 onlink
> > 
> >     TEST: v4-mapped                                           [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: VRF lisa
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::1/128 via 2001:db8:501::64 dev veth5 onlink
> > 
> >     TEST: unicast connected                                   [ OK ]
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::2/128 via 2001:db8:12::64 dev veth5 onlink
> > 
> >     TEST: unicast recursive                                   [ OK ]
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::3/128 via ::ffff:10.2.1.254 dev veth5 onlink
> > 
> >     TEST: v4-mapped                                           [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: VRF device, PBR table
> > 
> > COMMAND: ip -6 ro add table 101 2001:db8:102::4/128 via 2001:db8:501::64 dev veth5 onlink
> > 
> >     TEST: unicast connected                                   [ OK ]
> > 
> > COMMAND: ip -6 ro add table 101 2001:db8:102::5/128 via 2001:db8:12::64 dev veth5 onlink
> > 
> >     TEST: unicast recursive                                   [ OK ]
> > 
> > COMMAND: ip -6 ro add table 101 2001:db8:102::6/128 via ::ffff:10.2.1.254 dev veth5 onlink
> > 
> >     TEST: v4-mapped                                           [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: default VRF - main table - multipath
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::4/128 onlink nexthop via 2001:db8:101::64 dev veth1 nexthop via 2001:db8:301::64 dev veth3
> > 
> >     TEST: unicast connected - multipath onlink                [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::5/128 onlink nexthop via 2001:db8:11::64 dev veth1 nexthop via 2001:db8:12::64 dev veth3
> > 
> >     TEST: unicast recursive - multipath onlink                [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::6/128 onlink nexthop via ::ffff:10.1.1.254 dev veth1 nexthop via ::ffff:10.2.1.254 dev veth3
> > 
> >     TEST: v4-mapped - multipath onlink                        [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::7/128  nexthop via 2001:db8:101::64 dev veth1 onlink nexthop via 2001:db8:301::64 dev veth3 onlink
> > 
> >     TEST: unicast connected - multipath onlink both nexthops  [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::8/128  nexthop via 2001:db8:101::64 dev veth1 onlink nexthop via 2001:db8:301::64 dev veth3
> > 
> >     TEST: unicast connected - multipath onlink first only     [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::9/128  nexthop via 2001:db8:101::64 dev veth1 nexthop via 2001:db8:301::64 dev veth3 onlink
> > 
> >     TEST: unicast connected - multipath onlink second only    [ OK ]
> > 
> > #########################################
> > TEST SUBSECTION: Invalid onlink commands
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::11/128 via 2001:db8:101::1 dev veth1 onlink
> > Error: Gateway can not be a local address.
> > 
> >     TEST: Invalid gw - local unicast address                  [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::12/128 via fe80::882d:18ff:fe88:6d1a dev veth1 onlink
> > Error: Gateway can not be a local address.
> > 
> >     TEST: Invalid gw - local linklocal address                [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::12/128 via ff02::1 dev veth1 onlink
> > Error: Invalid gateway address.
> > 
> >     TEST: Invalid gw - multicast address                      [ OK ]
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::11/128 via 2001:db8:501::1 dev veth5 onlink
> > Error: Gateway can not be a local address.
> > 
> >     TEST: Invalid gw - local unicast address, VRF             [ OK ]
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::12/128 via fe80::94c8:97ff:fed4:ebfb dev veth5 onlink
> > Error: Gateway can not be a local address.
> > 
> >     TEST: Invalid gw - local linklocal address, VRF           [ OK ]
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::12/128 via ff02::1 dev veth5 onlink
> > Error: Invalid gateway address.
> > 
> >     TEST: Invalid gw - multicast address, VRF                 [ OK ]
> > 
> > COMMAND: ip -6 ro add table 254 2001:db8:101::101/128 via 2001:db8:101::1  onlink
> > Error: Nexthop device required for onlink.
> > 
> >     TEST: No nexthop device given                             [ OK ]
> > 
> > COMMAND: ip -6 ro add table 1101 2001:db8:102::103/128 via 2001:db8:701::64 dev veth5 onlink
> > Error: Nexthop has invalid gateway or device mismatch.
> > 
> >     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]
> > 
> > Tests passed:  38
> > Tests failed:   0
> > ok 1..13 selftests: net: fib-onlink-tests.sh [PASS]
> > selftests: net: pmtu.sh
> > ========================================
> > TEST: vti6: PMTU exceptions                                         [ OK ]
> > TEST: vti4: PMTU exceptions                                         [ OK ]
> > TEST: vti4: default MTU assignment                                  [ OK ]
> > TEST: vti6: default MTU assignment                                  [ OK ]
> > TEST: vti4: MTU setting on link creation                            [ OK ]
> > TEST: vti6: MTU setting on link creation                            [ OK ]
> > TEST: vti6: MTU changes on link changes                             [ OK ]
> > ok 1..14 selftests: net: pmtu.sh [PASS]
> > selftests: net: udpgso.sh
> > ========================================
> > ipv4 cmsg
> > device mtu (orig): 65536
> > device mtu (test): 1500
> > ipv4 tx:1 gso:0 
> > ipv4 tx:1472 gso:0 
> > ipv4 tx:1473 gso:0 (fail)
> > ipv4 tx:1472 gso:1472 (fail)
> > ipv4 tx:1473 gso:1472 
> > ipv4 tx:2944 gso:1472 
> > ipv4 tx:2945 gso:1472 
> > ipv4 tx:64768 gso:1472 
> > ipv4 tx:65507 gso:1472 
> > ipv4 tx:65508 gso:1472 (fail)
> > ipv4 tx:1 gso:1 (fail)
> > ipv4 tx:2 gso:1 
> > ipv4 tx:5 gso:2 
> > ipv4 tx:36 gso:1 
> > ipv4 tx:37 gso:1 (fail)
> > OK
> > ipv4 setsockopt
> > device mtu (orig): 65536
> > device mtu (test): 1500
> > ipv4 tx:1 gso:0 
> > ipv4 tx:1472 gso:0 
> > ipv4 tx:1473 gso:0 (fail)
> > ipv4 tx:1472 gso:1472 (fail)
> > ipv4 tx:1473 gso:1472 
> > ipv4 tx:2944 gso:1472 
> > ipv4 tx:2945 gso:1472 
> > ipv4 tx:64768 gso:1472 
> > ipv4 tx:65507 gso:1472 
> > ipv4 tx:65508 gso:1472 (fail)
> > ipv4 tx:1 gso:1 (fail)
> > ipv4 tx:2 gso:1 
> > ipv4 tx:5 gso:2 
> > ipv4 tx:36 gso:1 
> > ipv4 tx:37 gso:1 (fail)
> > OK
> > ipv6 cmsg
> > device mtu (orig): 65536
> > device mtu (test): 1500
> > ipv6 tx:1 gso:0 
> > ipv6 tx:1452 gso:0 
> > ipv6 tx:1453 gso:0 (fail)
> > ipv6 tx:1452 gso:1452 (fail)
> > ipv6 tx:1453 gso:1452 
> > ipv6 tx:2904 gso:1452 
> > ipv6 tx:2905 gso:1452 
> > ipv6 tx:65340 gso:1452 
> > ipv6 tx:65527 gso:1452 
> > ipv6 tx:65528 gso:1452 (fail)
> > ipv6 tx:1 gso:1 (fail)
> > ipv6 tx:2 gso:1 
> > ipv6 tx:5 gso:2 
> > ipv6 tx:16 gso:1 
> > ipv6 tx:17 gso:1 (fail)
> > OK
> > ipv6 setsockopt
> > device mtu (orig): 65536
> > device mtu (test): 1500
> > ipv6 tx:1 gso:0 
> > ipv6 tx:1452 gso:0 
> > ipv6 tx:1453 gso:0 (fail)
> > ipv6 tx:1452 gso:1452 (fail)
> > ipv6 tx:1453 gso:1452 
> > ipv6 tx:2904 gso:1452 
> > ipv6 tx:2905 gso:1452 
> > ipv6 tx:65340 gso:1452 
> > ipv6 tx:65527 gso:1452 
> > ipv6 tx:65528 gso:1452 (fail)
> > ipv6 tx:1 gso:1 (fail)
> > ipv6 tx:2 gso:1 
> > ipv6 tx:5 gso:2 
> > ipv6 tx:16 gso:1 
> > ipv6 tx:17 gso:1 (fail)
> > OK
> > ipv4 connected
> > device mtu (orig): 65536
> > device mtu (test): 1600
> > route mtu (test): 1500
> > path mtu (read):  1500
> > ipv4 tx:1 gso:0 
> > ipv4 tx:1472 gso:0 
> > ipv4 tx:1473 gso:0 (fail)
> > ipv4 tx:1472 gso:1472 (fail)
> > ipv4 tx:1473 gso:1472 
> > ipv4 tx:2944 gso:1472 
> > ipv4 tx:2945 gso:1472 
> > ipv4 tx:64768 gso:1472 
> > ipv4 tx:65507 gso:1472 
> > ipv4 tx:65508 gso:1472 (fail)
> > ipv4 tx:1 gso:1 (fail)
> > ipv4 tx:2 gso:1 
> > ipv4 tx:5 gso:2 
> > ipv4 tx:36 gso:1 
> > ipv4 tx:37 gso:1 (fail)
> > OK
> > ipv4 msg_more
> > device mtu (orig): 65536
> > device mtu (test): 1500
> > ipv4 tx:1 gso:0 
> > ipv4 tx:1472 gso:0 
> > ipv4 tx:1473 gso:0 (fail)
> > ipv4 tx:1472 gso:1472 (fail)
> > ipv4 tx:1473 gso:1472 
> > ipv4 tx:2944 gso:1472 
> > ipv4 tx:2945 gso:1472 
> > ipv4 tx:64768 gso:1472 
> > ipv4 tx:65507 gso:1472 
> > ipv4 tx:65508 gso:1472 (fail)
> > ipv4 tx:1 gso:1 (fail)
> > ipv4 tx:2 gso:1 
> > ipv4 tx:5 gso:2 
> > ipv4 tx:36 gso:1 
> > ipv4 tx:37 gso:1 (fail)
> > OK
> > ipv6 msg_more
> > device mtu (orig): 65536
> > device mtu (test): 1500
> > ipv6 tx:1 gso:0 
> > ipv6 tx:1452 gso:0 
> > ipv6 tx:1453 gso:0 (fail)
> > ipv6 tx:1452 gso:1452 (fail)
> > ipv6 tx:1453 gso:1452 
> > ipv6 tx:2904 gso:1452 
> > ipv6 tx:2905 gso:1452 
> > ipv6 tx:65340 gso:1452 
> > ipv6 tx:65527 gso:1452 
> > ipv6 tx:65528 gso:1452 (fail)
> > ipv6 tx:1 gso:1 (fail)
> > ipv6 tx:2 gso:1 
> > ipv6 tx:5 gso:2 
> > ipv6 tx:16 gso:1 
> > ipv6 tx:17 gso:1 (fail)
> > OK
> > ok 1..15 selftests: net: udpgso.sh [PASS]
> > selftests: net: udpgso_bench.sh
> > ========================================
> > ipv4
> > tcp
> > tcp tx:   4352 MB/s    73823 calls/s  73823 msg/s
> > tcp rx:   4352 MB/s    73562 calls/s
> > tcp tx:   4315 MB/s    73193 calls/s  73193 msg/s
> > tcp rx:   4315 MB/s    73193 calls/s
> > tcp tx:   4383 MB/s    74344 calls/s  74344 msg/s
> > tcp rx:   4383 MB/s    74332 calls/s
> > tcp zerocopy
> > tcp rx:   3298 MB/s    55844 calls/s
> > tcp tx:   3298 MB/s    55944 calls/s  55944 msg/s
> > tcp rx:   3283 MB/s    55568 calls/s
> > tcp tx:   3283 MB/s    55687 calls/s  55687 msg/s
> > tcp tx:   3328 MB/s    56456 calls/s  56456 msg/s
> > tcp rx:   3328 MB/s    55228 calls/s
> > udp
> > udp rx:    251 MB/s   179319 calls/s
> > udp tx:    251 MB/s   179340 calls/s   4270 msg/s
> > udp rx:    255 MB/s   181668 calls/s
> > udp tx:    255 MB/s   181650 calls/s   4325 msg/s
> > udp rx:    254 MB/s   181351 calls/s
> > udp tx:    254 MB/s   181356 calls/s   4318 msg/s
> > udp gso
> > udp rx:    698 MB/s   497658 calls/s
> > udp tx:    700 MB/s    11873 calls/s  11873 msg/s
> > udp rx:    717 MB/s   511140 calls/s
> > udp tx:    718 MB/s    12179 calls/s  12179 msg/s
> > udp rx:    700 MB/s   498960 calls/s
> > udp tx:    700 MB/s    11880 calls/s  11880 msg/s
> > ipv6
> > tcp
> > tcp rx:   4356 MB/s    73861 calls/s
> > tcp tx:   4356 MB/s    73889 calls/s  73889 msg/s
> > tcp rx:   4490 MB/s    76162 calls/s
> > tcp tx:   4490 MB/s    76166 calls/s  76166 msg/s
> > tcp tx:   4470 MB/s    75823 calls/s  75823 msg/s
> > tcp rx:   4470 MB/s    75820 calls/s
> > tcp zerocopy
> > tcp tx:   3263 MB/s    55350 calls/s  55350 msg/s
> > tcp rx:   3263 MB/s    55340 calls/s
> > tcp rx:   3271 MB/s    55476 calls/s
> > tcp tx:   3271 MB/s    55493 calls/s  55493 msg/s
> > tcp rx:   3189 MB/s    54091 calls/s
> > tcp tx:   3189 MB/s    54093 calls/s  54093 msg/s
> > udp
> > udp rx:    167 MB/s   122285 calls/s
> > udp tx:    168 MB/s   122679 calls/s   2853 msg/s
> > udp rx:    168 MB/s   122658 calls/s
> > udp tx:    168 MB/s   122765 calls/s   2855 msg/s
> > udp rx:    169 MB/s   123533 calls/s
> > udp tx:    169 MB/s   123539 calls/s   2873 msg/s
> > udp gso
> > udp rx:    618 MB/s   450769 calls/s
> > udp tx:    619 MB/s    10503 calls/s  10503 msg/s
> > udp rx:    621 MB/s   453048 calls/s
> > udp tx:    620 MB/s    10531 calls/s  10531 msg/s
> > udp rx:    620 MB/s   452704 calls/s
> > udp tx:    621 MB/s    10533 calls/s  10533 msg/s
> > ok 1..16 selftests: net: udpgso_bench.sh [PASS]
> > selftests: net: fib_rule_tests.sh
> > ========================================
> > 
> > ######################################################################
> > TEST SECTION: IPv4 fib rule
> > ######################################################################
> > 
> >     TEST: rule4 check: oif dummy0                             [ OK ]
> > 
> >     TEST: rule4 del by pref: oif dummy0                       [ OK ]
> > RTNETLINK answers: No route to host
> > 
> >     TEST: rule4 check: from 192.51.100.3 iif dummy0           [FAIL]
> > 
> >     TEST: rule4 del by pref: from 192.51.100.3 iif dummy0     [ OK ]
> > 
> >     TEST: rule4 check: tos 0x10                               [ OK ]
> > 
> >     TEST: rule4 del by pref: tos 0x10                         [ OK ]
> > 
> >     TEST: rule4 check: fwmark 0x64                            [ OK ]
> > 
> >     TEST: rule4 del by pref: fwmark 0x64                      [ OK ]
> > 
> >     TEST: rule4 check: uidrange 100-100                       [ OK ]
> > 
> >     TEST: rule4 del by pref: uidrange 100-100                 [ OK ]
> > 
> >     TEST: rule4 check: sport 666 dport 777                    [ OK ]
> > 
> >     TEST: rule4 del by pref: sport 666 dport 777              [ OK ]
> > 
> >     TEST: rule4 check: ipproto tcp                            [ OK ]
> > 
> >     TEST: rule4 del by pref: ipproto tcp                      [ OK ]
> > 
> >     TEST: rule4 check: ipproto icmp                           [ OK ]
> > 
> >     TEST: rule4 del by pref: ipproto icmp                     [ OK ]
> > 
> > ######################################################################
> > TEST SECTION: IPv6 fib rule
> > ######################################################################
> > 
> >     TEST: rule6 check: oif dummy0                             [ OK ]
> > 
> >     TEST: rule6 del by pref: oif dummy0                       [ OK ]
> > 
> >     TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]
> > 
> >     TEST: rule6 del by pref: from 2001:db8:1::3 iif dummy0    [ OK ]
> > 
> >     TEST: rule6 check: tos 0x10                               [ OK ]
> > 
> >     TEST: rule6 del by pref: tos 0x10                         [ OK ]
> > 
> >     TEST: rule6 check: fwmark 0x64                            [ OK ]
> > 
> >     TEST: rule6 del by pref: fwmark 0x64                      [ OK ]
> > 
> >     TEST: rule6 check: uidrange 100-100                       [ OK ]
> > 
> >     TEST: rule6 del by pref: uidrange 100-100                 [ OK ]
> > 
> >     TEST: rule6 check: sport 666 dport 777                    [ OK ]
> > 
> >     TEST: rule6 del by pref: sport 666 dport 777              [ OK ]
> > 
> >     TEST: rule6 check: ipproto tcp                            [ OK ]
> > 
> >     TEST: rule6 del by pref: ipproto tcp                      [ OK ]
> > Error: Unsupported ip proto.
> > 
> >     TEST: rule6 check: ipproto icmp                           [FAIL]
> > 
> >     TEST: rule6 del by pref: ipproto icmp                     [ OK ]
> > 
> > Tests passed:  30
> > Tests failed:   2
> > not ok 1..17 selftests: net: fib_rule_tests.sh [FAIL]
> > selftests: net: msg_zerocopy.sh
> > ========================================
> > ipv4 tcp -t 1
> > tx=90705 (5660 MB) txc=0 zc=n
> > rx=45352 (5660 MB)
> > ipv4 tcp -z -t 1
> > tx=71174 (4441 MB) txc=71174 zc=n
> > rx=35586 (4441 MB)
> > ok
> > ipv6 tcp -t 1
> > tx=75122 (4687 MB) txc=0 zc=n
> > rx=37560 (4687 MB)
> > ipv6 tcp -z -t 1
> > gap: 63657..63657 does not append to 63649
> > serr: inconsistent
> > rx=31828 (3972 MB)
> > gap: 63649..63656 does not append to 63658
> > serr: inconsistent
> > tx=63658 (3972 MB) txc=63658 zc=n
> > ok
> > OK. All tests passed
> > ok 1..18 selftests: net: msg_zerocopy.sh [PASS]
> > selftests: net: psock_snd.sh
> > ========================================
> > dgram
> > tx: 128
> > rx: 142
> > rx: 100
> > OK
> > 
> > dgram bind
> > tx: 128
> > rx: 142
> > rx: 100
> > OK
> > 
> > raw
> > tx: 142
> > rx: 142
> > rx: 100
> > OK
> > 
> > raw bind
> > tx: 142
> > rx: 142
> > rx: 100
> > OK
> > 
> > raw qdisc bypass
> > tx: 142
> > rx: 142
> > rx: 100
> > OK
> > 
> > raw vlan
> > tx: 146
> > rx: 100
> > OK
> > 
> > raw vnet hdr
> > tx: 152
> > rx: 142
> > rx: 100
> > OK
> > 
> > raw csum_off
> > tx: 152
> > rx: 142
> > rx: 100
> > OK
> > 
> > raw csum_off with bad offset (fails)
> > ./psock_snd: write: Invalid argument
> > raw min size
> > tx: 42
> > rx: 0
> > OK
> > 
> > raw mtu size
> > tx: 1514
> > rx: 1472
> > OK
> > 
> > raw mtu size + 1 (fails)
> > ./psock_snd: write: Message too long
> > raw vlan mtu size + 1 (fails)
> > ./psock_snd: write: Message too long
> > dgram mtu size
> > tx: 1500
> > rx: 1472
> > OK
> > 
> > dgram mtu size + 1 (fails)
> > ./psock_snd: write: Message too long
> > raw truncate hlen (fails: does not arrive)
> > tx: 14
> > ./psock_snd: recv: Resource temporarily unavailable
> > raw truncate hlen - 1 (fails: EINVAL)
> > ./psock_snd: write: Invalid argument
> > raw gso min size
> > tx: 1525
> > rx: 1473
> > OK
> > 
> > raw gso min size - 1 (fails)
> > tx: 1524
> > ./psock_snd: recv: Resource temporarily unavailable
> > raw gso max size
> > tx: 65559
> > rx: 65507
> > OK
> > 
> > raw gso max size + 1 (fails)
> > tx: 65560
> > ./psock_snd: recv: Resource temporarily unavailable
> > OK. All tests passed
> > ok 1..19 selftests: net: psock_snd.sh [PASS]
> > make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/tools/testing/selftests/net'
> 
> > ---
> > 
> > #! /cephfs/jenkins/jobs/lkp-stable/workspace@5/lkp-customers/linux/stable/function/lkp-hsw-d03/kernel-selftests-bm.yaml
> > suite: kernel-selftests
> > testcase: kernel-selftests
> > category: functional
> > kconfig: x86_64-rhel-8.3-kselftests
> > kernel-selftests:
> >   group: net
> > job_origin: kernel-selftests-bm.yaml
> > queue: bisect
> > testbox: lkp-hsw-d03
> > commit: ecec31ce4f33c927997f179f5d8f1bc4efdd68b5
> > branch: stable/linux-4.19.y
> > name: "/cephfs/jenkins/jobs/lkp-stable/workspace@5/lkp-customers/linux/stable/function/lkp-hsw-d03/kernel-selftests-bm.yaml"
> > kernel_cmdline: 
> > tbox_group: lkp-hsw-d03
> > submit_id: 6054bbf7d92e661a861eb937
> > job_file: "/lkp/jobs/scheduled/lkp-hsw-d03/kernel-selftests-net-ucode=0x28-debian-10.4-x86_64-20200603.cgz-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5-20210319-6790-1wspryi-0.yaml"
> > id: 804d9f896d0b980d4f7d2e7a42297a7aa9ec932b
> > queuer_version: "/lkp-src"
> > 
> > #! hosts/lkp-hsw-d03
> > model: Haswell
> > nr_node: 1
> > nr_cpu: 8
> > memory: 16G
> > nr_ssd_partitions: 1
> > nr_hdd_partitions: 4
> > hdd_partitions: "/dev/disk/by-id/ata-ST31000524AS_6VPHDMY6-part*"
> > ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2KW480H6_CVLT625008W6480EGN-part1"
> > rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2KW480H6_CVLT625008W6480EGN-part2"
> > brand: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
> > 
> > #! include/category/functional
> > kmsg: 
> > heartbeat: 
> > meminfo: 
> > 
> > #! include/testbox/lkp-hsw-d03
> > ucode: '0x28'
> > need_kconfig_hw:
> > - CONFIG_E1000E=y
> > - CONFIG_SATA_AHCI
> > 
> > #! include/kernel-selftests
> > need_linux_headers: true
> > need_linux_selftests: true
> > need_kselftests: true
> > need_kconfig:
> > - CONFIG_USER_NS=y
> > - CONFIG_BPF_SYSCALL=y
> > - CONFIG_TEST_BPF=m
> > - CONFIG_NUMA=y ~ ">= v5.6-rc1"
> > - CONFIG_NET_VRF=y ~ ">= v4.3-rc1"
> > - CONFIG_NET_L3_MASTER_DEV=y ~ ">= v4.4-rc1"
> > - CONFIG_IPV6=y
> > - CONFIG_IPV6_MULTIPLE_TABLES=y
> > - CONFIG_VETH=y
> > - CONFIG_NET_IPVTI=m
> > - CONFIG_IPV6_VTI=m
> > - CONFIG_DUMMY=y
> > - CONFIG_BRIDGE=y
> > - CONFIG_VLAN_8021Q=y
> > - CONFIG_IFB=y
> > - CONFIG_NETFILTER=y
> > - CONFIG_NETFILTER_ADVANCED=y
> > - CONFIG_NF_CONNTRACK=m
> > - CONFIG_NF_NAT=m ~ ">= v5.1-rc1"
> > - CONFIG_IP6_NF_IPTABLES=m
> > - CONFIG_IP_NF_IPTABLES=m
> > - CONFIG_IP6_NF_NAT=m
> > - CONFIG_IP_NF_NAT=m
> > - CONFIG_NF_TABLES=m
> > - CONFIG_NF_TABLES_IPV6=y ~ ">= v4.17-rc1"
> > - CONFIG_NF_TABLES_IPV4=y ~ ">= v4.17-rc1"
> > - CONFIG_NFT_CHAIN_NAT_IPV6=m ~ "<= v5.0"
> > - CONFIG_NFT_CHAIN_NAT_IPV4=m ~ "<= v5.0"
> > - CONFIG_NET_SCH_FQ=m
> > - CONFIG_NET_SCH_ETF=m ~ ">= v4.19-rc1"
> > - CONFIG_NET_SCH_NETEM=y
> > - CONFIG_TEST_BLACKHOLE_DEV=m ~ ">= v5.3-rc1"
> > - CONFIG_KALLSYMS=y
> > - CONFIG_BAREUDP=m ~ ">= v5.7-rc1"
> > - CONFIG_MPLS_ROUTING=m ~ ">= v4.1-rc1"
> > - CONFIG_MPLS_IPTUNNEL=m ~ ">= v4.3-rc1"
> > - CONFIG_NET_SCH_INGRESS=y ~ ">= v4.19-rc1"
> > - CONFIG_NET_CLS_FLOWER=m ~ ">= v4.2-rc1"
> > - CONFIG_NET_ACT_TUNNEL_KEY=m ~ ">= v4.9-rc1"
> > - CONFIG_NET_ACT_MIRRED=m ~ ">= v5.11-rc1"
> > rootfs: debian-10.4-x86_64-20200603.cgz
> > enqueue_time: 2021-03-19 22:57:59.199921162 +08:00
> > compiler: gcc-9
> > _id: 6054bbf7d92e661a861eb937
> > _rt: "/result/kernel-selftests/net-ucode=0x28/lkp-hsw-d03/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5"
> > 
> > #! schedule options
> > user: lkp
> > LKP_SERVER: internal-lkp-server
> > result_root: "/result/kernel-selftests/net-ucode=0x28/lkp-hsw-d03/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/0"
> > scheduler_version: "/lkp/lkp/.src-20210319-191423"
> > arch: x86_64
> > max_uptime: 2100
> > initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
> > bootloader_append:
> > - root=/dev/ram0
> > - user=lkp
> > - job=/lkp/jobs/scheduled/lkp-hsw-d03/kernel-selftests-net-ucode=0x28-debian-10.4-x86_64-20200603.cgz-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5-20210319-6790-1wspryi-0.yaml
> > - ARCH=x86_64
> > - kconfig=x86_64-rhel-8.3-kselftests
> > - branch=stable/linux-4.19.y
> > - commit=ecec31ce4f33c927997f179f5d8f1bc4efdd68b5
> > - BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/vmlinuz-4.19.52-00069-gecec31ce4f33c
> > - max_uptime=2100
> > - RESULT_ROOT=/result/kernel-selftests/net-ucode=0x28/lkp-hsw-d03/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/0
> > - LKP_SERVER=internal-lkp-server
> > - nokaslr
> > - selinux=0
> > - debug
> > - apic=debug
> > - sysrq_always_enabled
> > - rcupdate.rcu_cpu_stall_timeout=100
> > - net.ifnames=0
> > - printk.devkmsg=on
> > - panic=-1
> > - softlockup_panic=1
> > - nmi_watchdog=panic
> > - oops=panic
> > - load_ramdisk=2
> > - prompt_ramdisk=0
> > - drbd.minor_count=8
> > - systemd.log_level=err
> > - ignore_loglevel
> > - console=tty0
> > - earlyprintk=ttyS0,115200
> > - console=ttyS0,115200
> > - vga=normal
> > - rw
> > modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/modules.cgz"
> > linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/linux-headers.cgz"
> > linux_selftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/linux-selftests.cgz"
> > kselftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/kselftests.cgz"
> > bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20201211.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20201231.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-b553cffa-1_20210122.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
> > ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
> > lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
> > site: inn
> > 
> > #! /lkp/lkp/.src-20210318-154611/include/site/inn
> > LKP_CGI_PORT: 80
> > LKP_CIFS_PORT: 139
> > oom-killer: 
> > watchdog: 
> > 
> > #! runtime status
> > last_kernel: 5.10.24
> > 
> > #! queue options
> > queue_cmdline_keys:
> > - branch
> > - commit
> > 
> > #! user overrides
> > kernel: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/vmlinuz-4.19.52-00069-gecec31ce4f33c"
> > dequeue_time: 2021-03-19 23:23:09.085022349 +08:00
> > 
> > #! /lkp/lkp/.src-20210319-191423/include/site/inn
> > job_state: finished
> > loadavg: 1.98 2.26 1.27 1/182 4625
> > start_time: '1616167467'
> > end_time: '1616168200'
> > version: "/lkp/lkp/.src-20210319-191455:dccef67d:134599622"
> 
> > mount --bind /lib/modules/4.19.52-00069-gecec31ce4f33c/kernel/lib /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-ecec31ce4f33c927997f179f5d8f1bc4efdd68b5/lib
> > make -C bpf
> > make -C ../../../tools/testing/selftests/net
> > make install INSTALL_PATH=/usr/bin/ -C ../../../tools/testing/selftests/net
> > make run_tests -C net
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
