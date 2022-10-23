Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544A3609466
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 17:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJWPcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 11:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJWPcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 11:32:05 -0400
X-Greylist: delayed 33050 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Oct 2022 08:32:03 PDT
Received: from zombie.net4u.de (zombie.net4u.de [IPv6:2a01:4f8:161:9247::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F350760FA
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 08:32:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zombie.net4u.de (Postfix) with ESMTP id A4F2C2A404B0;
        Sun, 23 Oct 2022 15:32:01 +0000 (UTC)
Received: from zombie.net4u.de ([127.0.0.1])
        by localhost (zombie.net4u.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id FZiiMqKen6xC; Sun, 23 Oct 2022 15:32:01 +0000 (UTC)
Received: from [IPV6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3] (unknown [IPv6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3])
        by zombie.net4u.de (Postfix) with ESMTPSA id E1A6A2A40398;
        Sun, 23 Oct 2022 15:32:00 +0000 (UTC)
Message-ID: <8196dd88-4e11-78a7-8f96-20cf3e886e68@net4u.de>
Date:   Sun, 23 Oct 2022 17:32:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [Regression] v6.0.3 rcu_preempt detected expedited stalls
 btrfs-cache btrfs_work_helper
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, josef@toxicpanda.com
References: <10522366-5c17-c18f-523c-b97c1496927b@net4u.de>
 <Y1Uzcc0hqI8yj/Ej@kroah.com>
From:   Ernst Herzberg <earny@net4u.de>
In-Reply-To: <Y1Uzcc0hqI8yj/Ej@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 23.10.22 um 14:28 schrieb Greg KH:
> On Sun, Oct 23, 2022 at 08:21:08AM +0200, Ernst Herzberg wrote:
>>
>> Kernel v5.19.16 works without issues.
>> Booting v6.0.3:
>>
>> [    0.000000] microcode: microcode updated early to revision 0xf0, date = 2021-11-12
>> [    0.000000] Linux version 6.0.3+ (root@dunno) (gcc (Gentoo 11.3.0 p4) 11.3.0, GNU ld (Gentoo 2.38 p4) 2.38) #288 SMP PREEMPT Sat Oct 22 22:07:33 CEST 2022
>> [    0.000000] Command line:
>> [ ... ]
>> [   34.150421] br0: port 2(veth2a8760a2) entered blocking state
>> [   34.150423] br0: port 2(veth2a8760a2) entered forwarding state
>> [   34.890258] new mount options do not match the existing superblock, will be ignored
>> [   88.487151] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 1-.... } 6667 jiffies s: 301 root: 0x2/.
>> [   88.487156] rcu: blocking rcu_node structures (internal RCU debug):
> 
> Can you do 'git bisect' to find the offending change?
>

See below. Had guessed what patch can be the problem, and hit it by the first try.

>> [   88.487157] Task dump for CPU 1:
> 
> And this all is just a warning, is the system working fine otherwise?
> 

No, it does not work, it just hangs. Have to reboot with sysreq.
It does not fully hang: Boots to the login prompt, if i'm fast, i can
login, but every command entered just hangs.

>> [   88.487158] task:kworker/u16:5   state:R  running task     stack:    0 pid:  122 ppid:     2 flags:0x00004008
>> [   88.487161] Workqueue: btrfs-cache btrfs_work_helper
>> [   88.487165] Call Trace:
>> [   88.487166]  <TASK>
>> [   88.487167]  ? __schedule+0x241/0x650
>> [   88.487170]  ? crc32c_pcl_intel_update+0xa1/0xb0
>> [   88.487172]  ? crc32c+0x1e/0x40
>> [   88.487174]  ? folio_wait_bit_common+0x17e/0x350
>> [   88.487176]  ? filemap_invalidate_unlock_two+0x30/0x30
>> [   88.487177]  ? __load_free_space_cache+0x25e/0x4a0
>> [   88.487179]  ? pmdp_collapse_flush+0x30/0x30
>> [   88.487180]  ? folio_clear_dirty_for_io+0x94/0x180
>> [   88.487182]  ? __load_free_space_cache+0x25e/0x4a0
>> [   88.487183]  ? kmem_cache_alloc+0x110/0x360
>> [   88.487185]  ? sysvec_apic_timer_interrupt+0xb/0x90
>> [   88.487186]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>> [   88.487188]  ? queued_spin_lock_slowpath+0x3d/0x190
>> [   88.487190]  ? __btrfs_remove_free_space_cache+0x9/0x30
>> [   88.487191]  ? load_free_space_cache+0x313/0x380
>> [   88.487193]  ? __clear_extent_bit+0x29e/0x490
>> [   88.487194]  ? caching_thread+0x385/0x4f0
>> [   88.487197]  ? dequeue_entity+0xd8/0x250
>> [   88.487198]  ? btrfs_work_helper+0xcd/0x1e0
>> [   88.487200]  ? process_one_work+0x1aa/0x300
>> [   88.487202]  ? worker_thread+0x48/0x3c0
>> [   88.487204]  ? rescuer_thread+0x3c0/0x3c0
>> [   88.487206]  ? kthread+0xd1/0x100
>> [   88.487207]  ? kthread_complete_and_exit+0x20/0x20
>> [   88.487209]  ? ret_from_fork+0x1f/0x30
>> [   88.487210]  </TASK>
>> [   97.557150] rcu: INFO: rcu_preempt self-detected stall on CPU
>> [   97.557152] rcu:     1-....: (17999 ticks this GP) idle=7034/1/0x4000000000000000 softirq=2073/2073 fqs=5999
>> [   97.557154]  (t=18000 jiffies g=2401 q=2899 ncpus=8)
>> [   97.557156] NMI backtrace for cpu 1
>> [   97.557157] CPU: 1 PID: 122 Comm: kworker/u16:5 Not tainted 6.0.3+ #288
>> [   97.557159] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z270M-ITX/ac, BIOS P2.60 03/16/2018
>> [   97.557160] Workqueue: btrfs-cache btrfs_work_helper
>> [   97.557163] Call Trace:
>> [   97.557165]  <IRQ>
>> [   97.557186]  dump_stack_lvl+0x34/0x44
>> [   97.557188]  nmi_cpu_backtrace.cold+0x30/0x70
>> [   97.557189]  ? lapic_can_unplug_cpu+0x80/0x80
>> [   97.557191]  nmi_trigger_cpumask_backtrace+0x95/0xa0
>> [   97.557193]  rcu_dump_cpu_stacks+0xb3/0xea
>> [   97.557196]  rcu_sched_clock_irq.cold+0x1d7/0x699
>> [   97.557197]  ? raw_notifier_call_chain+0x3c/0x50
>> [   97.557198]  ? timekeeping_update+0xaa/0x280
>> [   97.557200]  ? timekeeping_advance+0x35e/0x520
>> [   97.557201]  ? trigger_load_balance+0x5c/0x390
>> [   97.557203]  update_process_times+0x56/0x90
>> [   97.557205]  tick_sched_timer+0x83/0x90
>> [   97.557206]  ? tick_sched_do_timer+0x90/0x90
>> [   97.557206]  ? tick_sched_do_timer+0x90/0x90
>> [   97.557208]  __hrtimer_run_queues+0x10b/0x1b0
>> [   97.557209]  hrtimer_interrupt+0x109/0x230
>> [   97.557210]  __sysvec_apic_timer_interrupt+0x47/0x60
>> [   97.557213]  sysvec_apic_timer_interrupt+0x6d/0x90
>> [   97.557215]  </IRQ>
>> [   97.557215]  <TASK>
>> [   97.557216]  asm_sysvec_apic_timer_interrupt+0x16/0x20
>> [   97.557218] RIP: 0010:queued_spin_lock_slowpath+0x3d/0x190
>> [   97.557220] Code: 0f ba 2a 08 8b 02 0f 92 c1 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ef 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
>> [   97.557221] RSP: 0018:ffff888105977ca0 EFLAGS: 00000202
>> [   97.557222] RAX: 0000000000000101 RBX: ffff888111df7cc0 RCX: 0000000000000000
>> [   97.557223] RDX: ffff888105977ce0 RSI: 0000000000000000 RDI: ffff888105977ce0
>> [   97.557224] RBP: ffff888105977ce0 R08: ffff8881336dff88 R09: ffff888105977cf0
>> [   97.557224] R10: ffff888105977ce8 R11: ffff888100911d00 R12: ffff88810b06cc00
>> [   97.557225] R13: 000000000336e000 R14: 0000000000000001 R15: ffff8881022c5605
>> [   97.557226]  __btrfs_remove_free_space_cache+0x9/0x30
>> [   97.557229]  load_free_space_cache+0x313/0x380
>> [   97.557230]  ? __clear_extent_bit+0x29e/0x490
>> [   97.557232]  caching_thread+0x385/0x4f0
>> [   97.557234]  ? dequeue_entity+0xd8/0x250
>> [   97.557235]  btrfs_work_helper+0xcd/0x1e0
>> [   97.557237]  process_one_work+0x1aa/0x300
>> [   97.557240]  worker_thread+0x48/0x3c0
>> [   97.557241]  ? rescuer_thread+0x3c0/0x3c0
>> [   97.557243]  kthread+0xd1/0x100
>> [   97.557245]  ? kthread_complete_and_exit+0x20/0x20
>> [   97.557246]  ret_from_fork+0x1f/0x30
>> [   97.557248]  </TASK>
>> [  151.633996] rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 1-.... } 25611 jiffies s: 301 root: 0x2/.
>> [  151.634000] rcu: blocking rcu_node structures (internal RCU debug):
>> [  151.634000] Task dump for CPU 1:
>> [  151.634001] task:kworker/u16:5   state:R  running task     stack:    0 pid:  122 ppid:     2 flags:0x00004008
>> [  151.634004] Workqueue: btrfs-cache btrfs_work_helper
>> [  151.634008] Call Trace:
>> [  151.634008]  <TASK>
>> [  151.634009]  ? __schedule+0x241/0x650
>> [  151.634013]  ? crc32c_pcl_intel_update+0xa1/0xb0
>> [  151.634014]  ? crc32c+0x1e/0x40
>> [ ... ]
>>
>> -------------------------
>>
>> Reverting
>>
>> commit 3ea7c50339859394dd667184b5b16eee1ebb53bc
>> Author: Josef Bacik <josef@toxicpanda.com>
>> Date:   Mon Aug 8 16:10:26 2022 -0400
>>
>>      btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure
>>      [ Upstream commit 8a1ae2781dee9fc21ca82db682d37bea4bd074ad ]
>>      Now that lockdep is staying enabled through our entire CI runs I started
>>      seeing the following stack in generic/475
>> ------------------------
>>
>> fixes the problem with dmesg
>>
>> [   31.250172] br0: port 2(veth2a020081) entered blocking state
>> [   31.250175] br0: port 2(veth2a020081) entered forwarding state
>> [   31.924193] new mount options do not match the existing superblock, will be ignored
>> [   34.334304] BTRFS warning (device sdb3): block group 35530997760 has wrong amount of free space
>> [   34.334314] BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now
> 
> That's still a problem, right?
> 

No. If i'm reverting the patch above, the machine works just fine. Seems the free space warning does not do
what i'm expected ;-)


> thanks,
> 
> greg k-h

