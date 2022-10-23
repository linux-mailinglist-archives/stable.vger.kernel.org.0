Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DFD6094C4
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 18:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJWQlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 12:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJWQlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 12:41:06 -0400
Received: from zombie.net4u.de (zombie.net4u.de [IPv6:2a01:4f8:161:9247::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9813F65667
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 09:41:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zombie.net4u.de (Postfix) with ESMTP id 07E242A404B0;
        Sun, 23 Oct 2022 16:41:00 +0000 (UTC)
Received: from zombie.net4u.de ([127.0.0.1])
        by localhost (zombie.net4u.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 8LfPYEy0_26W; Sun, 23 Oct 2022 16:40:59 +0000 (UTC)
Received: from [IPV6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3] (unknown [IPv6:2001:470:999b:fb01:7285:c2ff:fe2b:43c3])
        by zombie.net4u.de (Postfix) with ESMTPSA id 1FA382A40398;
        Sun, 23 Oct 2022 16:40:59 +0000 (UTC)
Message-ID: <cf29c80a-1c4a-fdc0-533b-fa538cde36f8@net4u.de>
Date:   Sun, 23 Oct 2022 18:40:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [Regression] v6.0.3 rcu_preempt detected expedited stalls
 btrfs-cache btrfs_work_helper
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, josef@toxicpanda.com
References: <10522366-5c17-c18f-523c-b97c1496927b@net4u.de>
 <Y1Uzcc0hqI8yj/Ej@kroah.com> <8196dd88-4e11-78a7-8f96-20cf3e886e68@net4u.de>
 <Y1Vf+/Y9qRpnaTw+@kroah.com>
Content-Language: en-US
From:   Ernst Herzberg <earny@net4u.de>
In-Reply-To: <Y1Vf+/Y9qRpnaTw+@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 23.10.22 um 17:38 schrieb Greg KH:
> On Sun, Oct 23, 2022 at 05:32:00PM +0200, Ernst Herzberg wrote:
>> Am 23.10.22 um 14:28 schrieb Greg KH:
>>> On Sun, Oct 23, 2022 at 08:21:08AM +0200, Ernst Herzberg wrote:
>>>>
[ .... ]
>>>> -------------------------
>>>>
>>>> Reverting
>>>>
>>>> commit 3ea7c50339859394dd667184b5b16eee1ebb53bc
>>>> Author: Josef Bacik <josef@toxicpanda.com>
>>>> Date:   Mon Aug 8 16:10:26 2022 -0400
>>>>
>>>>       btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure
>>>>       [ Upstream commit 8a1ae2781dee9fc21ca82db682d37bea4bd074ad ]
>>>>       Now that lockdep is staying enabled through our entire CI runs I started
>>>>       seeing the following stack in generic/475
>>>> ------------------------
>>>>
>>>> fixes the problem with dmesg
>>>>
>>>> [   31.250172] br0: port 2(veth2a020081) entered blocking state
>>>> [   31.250175] br0: port 2(veth2a020081) entered forwarding state
>>>> [   31.924193] new mount options do not match the existing superblock, will be ignored
>>>> [   34.334304] BTRFS warning (device sdb3): block group 35530997760 has wrong amount of free space
>>>> [   34.334314] BTRFS warning (device sdb3): failed to load free space cache for block group 35530997760, rebuilding it now
>>>
>>> That's still a problem, right?
>>>
>>
>> No. If i'm reverting the patch above, the machine works just fine. Seems the free space warning does not do
>> what i'm expected ;-)
> 
> Ah, ick.  So does 6.0.2 work with the same warning too?  Should other
> btrfs commits be reverted here also?
> 

Very good question. It look like I've have some 'free space problem' on one of my partition that hits
somewhere a bug in 6.0.3. (and 5.19.17-rc, see below)

So i've tried the stable tree 5.19.17-rc1 also. Exact the same problem!

Reverting there
---
commit 1789c776ec788d544d9e1f4e5f6cd937b3527407
Author: Josef Bacik <josef@toxicpanda.com>
Date:   Mon Aug 8 16:10:26 2022 -0400

     btrfs: call __btrfs_remove_free_space_cache_locked on cache load failure
     
     [ Upstream commit 8a1ae2781dee9fc21ca82db682d37bea4bd074ad ]
---

... and 5.19.17-rc1 works as it should without problems.

----------------------------

There i have catched a litte better dmesg what is going on:

[    0.000000] microcode: microcode updated early to revision 0xf0, date = 2021-11-12
[    0.000000] Linux version 5.19.17-rc1+ (root@dunno) (gcc (Gentoo 11.3.0 p4) 11.3.0, GNU ld (Gentoo 2.38 p4) 2.38) #291 SMP PREEMPT Sun Oct 23 18:01:47 CEST 2022
[    0.000000] Command line:
[ ... ]
[   10.867230] BTRFS info (device sda3): allowing degraded mounts
[   10.867234] BTRFS info (device sda3): disk space caching is enabled
[   10.867236] BTRFS info (device sda3): has skinny extents
[   10.936296] BTRFS info (device sdb3): allowing degraded mounts
[   10.936299] BTRFS info (device sdb3): disk space caching is enabled
[   10.936300] BTRFS info (device sdb3): has skinny extents
[   11.532272] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   11.532274] Bluetooth: BNEP filters: protocol multicast
[   11.532276] Bluetooth: BNEP socket layer initialized
[   11.641605] 8021q: adding VLAN 0 to HW filter on device enp2s0
[   14.647774] igb 0000:02:00.0 enp2s0: igb: enp2s0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   14.754012] IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0: link becomes ready
[   14.754447] IPv6: ADDRCONF(NETDEV_CHANGE): vlan55: link becomes ready
[   16.884897] br0: port 1(enp2s0) entered blocking state
[   16.884899] br0: port 1(enp2s0) entered disabled state
[   16.885031] device enp2s0 entered promiscuous mode
[   16.887543] device br0 entered promiscuous mode
[   16.888323] br0: port 1(enp2s0) entered blocking state
[   16.888325] br0: port 1(enp2s0) entered forwarding state
[   16.903011] br0: port 1(enp2s0) entered disabled state
[   16.907526] br0: port 1(enp2s0) entered blocking state
[   16.907528] br0: port 1(enp2s0) entered forwarding state
[   17.900471] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[   29.939400] bpfilter: Loaded bpfilter_umh pid 3943
[   29.939501] Started bpfilter
[   94.681456] rcu: INFO: rcu_preempt self-detected stall on CPU
[   94.681458] rcu:     6-....: (17999 ticks this GP) idle=5e7/1/0x4000000000000000 softirq=1580/1580 fqs=5999
[   94.681460]  (t=18000 jiffies g=1761 q=3795 ncpus=8)
[   94.681462] NMI backtrace for cpu 6
[   94.681462] CPU: 6 PID: 1962 Comm: kworker/u16:9 Not tainted 5.19.17-rc1+ #291
[   94.681464] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z270M-ITX/ac, BIOS P2.60 03/16/2018
[   94.681465] Workqueue: btrfs-cache btrfs_work_helper
[   94.681469] Call Trace:
[   94.681470]  <IRQ>
[   94.681471]  dump_stack_lvl+0x34/0x44
[   94.681494]  nmi_cpu_backtrace.cold+0x30/0x70
[   94.681496]  ? lapic_can_unplug_cpu+0x80/0x80
[   94.681497]  nmi_trigger_cpumask_backtrace+0x95/0xa0
[   94.681500]  trigger_single_cpu_backtrace+0x1a/0x1d
[   94.681502]  rcu_dump_cpu_stacks+0x9b/0xd4
[   94.681504]  rcu_sched_clock_irq.cold+0x1f9/0x73f
[   94.681506]  ? timekeeping_update+0xaa/0x280
[   94.681508]  ? timekeeping_advance+0x35e/0x520
[   94.681509]  ? trigger_load_balance+0x5b/0x340
[   94.681523]  update_process_times+0x56/0x90
[   94.681525]  tick_sched_timer+0x83/0x90
[   94.681527]  ? tick_sched_do_timer+0x90/0x90
[   94.681528]  __hrtimer_run_queues+0x10b/0x1b0
[   94.681529]  hrtimer_interrupt+0x109/0x230
[   94.681530]  __sysvec_apic_timer_interrupt+0x47/0x60
[   94.681532]  sysvec_apic_timer_interrupt+0x6d/0x90
[   94.681534]  </IRQ>
[   94.681534]  <TASK>
[   94.681535]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[   94.681536] RIP: 0010:queued_spin_lock_slowpath+0x3d/0x190
[   94.681538] Code: 0f ba 2a 08 8b 02 0f 92 c1 0f b6 c9 c1 e1 08 30 e4 09 c8 a9 00 01 ff ff 0f 85 ef 00 00 00 85 c0 74 0e 8b 02 84 c0 74 08 f3 90 <8b> 02 84 c0 75 f8 b8 01 00 00 00 66 89 02 c3 8b 37 b8 00 02 00 00
[   94.681539] RSP: 0018:ffff888112657ca0 EFLAGS: 00000202
[   94.681540] RAX: 0000000000000101 RBX: ffff88810f32b000 RCX: 0000000000000000
[   94.681541] RDX: ffff888112657ce0 RSI: 0000000000000000 RDI: ffff888112657ce0
[   94.681542] RBP: ffff888112657ce0 R08: ffff888115d6fcb0 R09: ffff888112657cf0
[   94.681543] R10: ffff888112657ce8 R11: ffff888135006000 R12: ffff88810c085c00
[   94.681543] R13: 000000000336e000 R14: 0000000000000001 R15: ffff88810c347705
[   94.681545]  __btrfs_remove_free_space_cache+0x9/0x30
[   94.681547]  load_free_space_cache+0x313/0x380
[   94.681549]  caching_thread+0x30f/0x4d0
[   94.681551]  ? dequeue_entity+0xd4/0x250
[   94.681552]  btrfs_work_helper+0xcd/0x1e0
[   94.681553]  process_one_work+0x1aa/0x300
[   94.681555]  worker_thread+0x48/0x3c0
[   94.681557]  ? rescuer_thread+0x3c0/0x3c0
[   94.681559]  kthread+0xd1/0x100
[   94.681560]  ? kthread_complete_and_exit+0x20/0x20
[   94.681562]  ret_from_fork+0x1f/0x30
[   94.681563]  </TASK>
[  100.640722] ------------[ cut here ]------------
[  100.640724] NETDEV WATCHDOG: enp2s0 (igb): transmit queue 1 timed out
[  100.640736] WARNING: CPU: 2 PID: 0 at net/sched/sch_generic.c:529 dev_watchdog+0x194/0x1a0
[  100.640759] Modules linked in: ebtable_filter ebtables ip6table_mangle ip6table_filter ip6_tables iptable_mangle iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_filter ip_tables x_tables bpfilter cmac ecb bnep vfat fat hid_logitech_hidpp joydev iwlmvm mac80211 iwlwifi btusb btrtl btbcm cfg80211 uas btintel bluetooth mei_me cp210x mei usbserial ecdh_generic hid_logitech_dj usb_storage ecc rfkill
[  100.640776] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.19.17-rc1+ #291
[  100.640778] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z270M-ITX/ac, BIOS P2.60 03/16/2018
[  100.640779] RIP: 0010:dev_watchdog+0x194/0x1a0
[  100.640780] Code: 28 e9 65 ff ff ff 48 89 ef c6 05 21 45 07 01 01 e8 91 58 fc ff 44 89 e9 48 89 ee 48 c7 c7 b0 e3 87 82 48 89 c2 e8 01 0d 1d 00 <0f> 0b e9 78 ff ff ff 0f 1f 44 00 00 41 55 48 85 f6 41 54 55 53 48
[  100.640781] RSP: 0018:ffff88884f085ed0 EFLAGS: 00010286
[  100.640783] RAX: 0000000000000039 RBX: ffff888102230440 RCX: 0000000000000027
[  100.640784] RDX: ffff88884f09b4a8 RSI: 0000000000000001 RDI: ffff88884f09b4a0
[  100.640784] RBP: ffff888102230000 R08: ffffffff82bfe648 R09: 0000000000000003
[  100.640785] R10: ffffffff82a3e660 R11: ffffffff82b9e660 R12: ffff88810223039c
[  100.640786] R13: 0000000000000001 R14: 0000000000000000 R15: ffffffff81bf8bd0
[  100.640787] FS:  0000000000000000(0000) GS:ffff88884f080000(0000) knlGS:0000000000000000
[  100.640788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.640789] CR2: 000000c0005d7000 CR3: 0000000002a0a001 CR4: 00000000003706e0
[  100.640789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  100.640790] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  100.640791] Call Trace:
[  100.640792]  <IRQ>
[  100.640794]  ? mq_change_real_num_tx+0xd0/0xd0
[  100.640795]  call_timer_fn.constprop.0+0xe/0x70
[  100.640798]  __run_timers.part.0+0x19a/0x1d0
[  100.640800]  ? __hrtimer_run_queues+0x14e/0x1b0
[  100.640801]  ? ktime_get+0x30/0x90
[  100.640803]  run_timer_softirq+0x21/0x50
[  100.640804]  __do_softirq+0xb0/0x1d2
[  100.640807]  irq_exit_rcu+0x75/0xa0
[  100.640810]  sysvec_apic_timer_interrupt+0x72/0x90
[  100.640811]  </IRQ>
[  100.640812]  <TASK>
[  100.640812]  asm_sysvec_apic_timer_interrupt+0x16/0x20
[  100.640814] RIP: 0010:cpuidle_enter_state+0xb3/0x270
[  100.640816] Code: e8 72 4a 64 ff 31 ff 49 89 c6 e8 a8 ca 63 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 a5 01 00 00 31 ff e8 01 e4 67 ff fb 45 85 ed <0f> 88 ad 00 00 00 49 63 cd 4c 2b 34 24 48 89 c8 48 6b d1 68 48 c1
[  100.640817] RSP: 0018:ffff888100aabea0 EFLAGS: 00000206
[  100.640817] RAX: ffff88884f0a2040 RBX: 0000000000000006 RCX: 000000000000001f
[  100.640818] RDX: 0000000000000000 RSI: 000000001e79fb97 RDI: 0000000000000000
[  100.640819] RBP: ffff88884f0abd00 R08: 000000176ea78a44 R09: 0000000000000023
[  100.640820] R10: 0000000000000023 R11: 0000000000000000 R12: ffffffff82c237e0
[  100.640820] R13: 0000000000000006 R14: 000000176ea78a44 R15: 0000000000000000
[  100.640822]  cpuidle_enter+0x24/0x40
[  100.640823]  do_idle+0x184/0x1e0
[  100.640826]  cpu_startup_entry+0x14/0x20
[  100.640828]  start_secondary+0xd6/0xe0
[  100.640830]  secondary_startup_64_no_verify+0xce/0xdb
[  100.640832]  </TASK>
[  100.640832] ---[ end trace 0000000000000000 ]---
[  100.640841] igb 0000:02:00.0 enp2s0: Reset adapter
[  101.494004] igb 0000:02:00.0 enp2s0: igb: enp2s0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[  184.774858] logitech-hidpp-device 0003:046D:400A.0006: HID++ 2.0 device connected.

Here the machine is not responding anymore.


> thanks,
> 
> greg k-h

