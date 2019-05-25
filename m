Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E842A39F
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfEYJIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 05:08:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38898 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfEYJIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 05:08:21 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id AA93B8034C; Sat, 25 May 2019 11:08:05 +0200 (CEST)
Date:   Sat, 25 May 2019 11:08:15 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Hugh Dickins <hughd@google.com>, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Revert "leds: avoid races with workqueue"?
Message-ID: <20190525090815.GA16936@amd>
References: <alpine.LSU.2.11.1905241540080.1674@eggly.anvils>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1905241540080.1674@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I'm having to revert 0db37915d912 ("leds: avoid races with workqueue")
> from my 5.2-rc testing tree, because lockdep and other debug options
> don't like it: net/mac80211/led.c arranges for led_blink_setup() to be
> called at softirq time, and flush_work() is not good for calling
> then.

Yep, I noticed something is fishy during code review, and asked Sasha
not to queue it for stable yesterday.

Thanks for confirmation.

Standby.

LED code is "interesting" but I should be able to keep the X60 working
as it is. Unbreaking code will mean more changes.

Best regards,
								Pavel



> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: inconsistent lock state
> 5.2.0-rc1 #1 Tainted: G        W       =20
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> 000000006e30541b ((work_completion)(&led_cdev->set_brightness_work)){+.?.=
}, at: __flush_work+0x3b/0x38a
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x146/0x1a1
>   __flush_work+0x5b/0x38a
>   flush_work+0xb/0xd
>   led_blink_setup+0x1e/0xd3
>   led_blink_set+0x3f/0x44
>   tpt_trig_timer+0xdb/0x106
>   ieee80211_mod_tpt_led_trig+0xed/0x112
>   __ieee80211_recalc_idle+0xd9/0x11f
>   ieee80211_idle_off+0xe/0x10
>   ieee80211_add_chanctx+0x6c/0x2df
>   ieee80211_new_chanctx+0x7d/0xe8
>   ieee80211_vif_use_channel+0x163/0x1fe
>   ieee80211_prep_connection+0x9db/0xbac
>   ieee80211_mgd_auth+0x274/0x328
>   ieee80211_auth+0x13/0x15
>   cfg80211_mlme_auth+0x1e1/0x341
>   nl80211_authenticate+0x25c/0x29e
>   genl_family_rcv_msg+0x2b7/0x31a
>   genl_rcv_msg+0x4a/0x6c
>   netlink_rcv_skb+0x55/0xaa
>   genl_rcv+0x23/0x32
>   netlink_unicast+0xfc/0x1bb
>   netlink_sendmsg+0x2c6/0x335
>   sock_sendmsg+0x12/0x1d
>   ___sys_sendmsg+0x1c5/0x23d
>   __sys_sendmsg+0x4b/0x75
>   __x64_sys_sendmsg+0x1a/0x1c
>   do_syscall_64+0x51/0x182
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> irq event stamp: 44098
> hardirqs last  enabled at (44098): [<ffffffff818a2375>] _raw_spin_unlock_=
irqrestore+0x3a/0x5b
> hardirqs last disabled at (44097): [<ffffffff818a21fd>] _raw_spin_lock_ir=
qsave+0x13/0x4c
> softirqs last  enabled at (44088): [<ffffffff810fbb8e>] _local_bh_enable+=
0x1e/0x20
> softirqs last disabled at (44089): [<ffffffff810fbecf>] irq_exit+0x69/0xb9
>=20
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>=20
>        CPU0
>        ----
>   lock((work_completion)(&led_cdev->set_brightness_work));
>   <Interrupt>
>     lock((work_completion)(&led_cdev->set_brightness_work));
>=20
>  *** DEADLOCK ***
>=20
> 2 locks held by swapper/1/0:
>  #0: 0000000002d634a0 ((&tpt_trig->timer)){+.-.}, at: call_timer_fn+0x0/0=
x2ce
>  #1: 000000007ed2567d (&trig->leddev_list_lock){.+.?}, at: tpt_trig_timer=
+0xbe/0x106
>=20
> stack backtrace:
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  print_usage_bug+0x292/0x2a5
>  ? print_irq_inversion_bug+0x1cb/0x1cb
>  mark_lock+0x307/0x51e
>  __lock_acquire+0x2c0/0x762
>  lock_acquire+0x146/0x1a1
>  ? __flush_work+0x3b/0x38a
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __flush_work+0x5b/0x38a
>  ? __flush_work+0x3b/0x38a
>  ? mark_held_locks+0x47/0x63
>  ? _raw_spin_unlock_irqrestore+0x3a/0x5b
>  ? _raw_spin_unlock_irqrestore+0x3a/0x5b
>  ? lockdep_hardirqs_on+0x196/0x1a5
>  ? try_to_del_timer_sync+0x44/0x4f
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: ffff888234d84300 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff888234d84300
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 0000000000000ed5 R11: 0000000000000086 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
2974
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8108e14f>] start_secondary+0x48/0x11b
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  ? start_secondary+0x48/0x11b
>  ___might_sleep+0x229/0x240
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __might_sleep+0x63/0x77
>  ? __flush_work+0x3b/0x38a
>  __flush_work+0x84/0x38a
>  ? mark_held_locks+0x47/0x63
>  ? _raw_spin_unlock_irqrestore+0x3a/0x5b
>  ? _raw_spin_unlock_irqrestore+0x3a/0x5b
>  ? lockdep_hardirqs_on+0x196/0x1a5
>  ? try_to_del_timer_sync+0x44/0x4f
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: ffff888234d84300 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff888234d84300
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 0000000000000ed5 R11: 0000000000000086 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0
> ing mDNS multicast group on interface wlp3s0.IPv6 with address fe80::2677=
:3ff:fe6f:637c.
> ing mDNS multicast group on interface wlp3s0.IPv6 with address 2600:1700:=
3ec0:f40:2677:3ff:fe6f:637c.
> stering new address record for 2600:1700:3ec0:f40:2677:3ff:fe6f:637c on w=
lp3s0.*.
> drawing address record for fe80::2677:3ff:fe6f:637c on wlp3s0.
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
2974
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8108e14f>] start_secondary+0x48/0x11b
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  ? start_secondary+0x48/0x11b
>  ___might_sleep+0x229/0x240
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __might_sleep+0x63/0x77
>  ? __flush_work+0x3b/0x38a
>  __flush_work+0x84/0x38a
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  ? ktime_get+0x8e/0xe4
>  ? trace_hardirqs_on+0xc7/0xf7
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 0000001c6cff9837 RDI: ffffffff81664055
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 000000000000e848 R11: 0000000000016727 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
2974
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8108e14f>] start_secondary+0x48/0x11b
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  ? start_secondary+0x48/0x11b
>  ___might_sleep+0x229/0x240
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __might_sleep+0x63/0x77
>  ? __flush_work+0x3b/0x38a
>  __flush_work+0x84/0x38a
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  ? ktime_get+0x8e/0xe4
>  ? trace_hardirqs_on+0xc7/0xf7
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 0000001d051767b2 RDI: ffffffff81664055
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 0000000000031f74 R11: 0000000000034923 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
2974
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8108e14f>] start_secondary+0x48/0x11b
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  ? start_secondary+0x48/0x11b
>  ___might_sleep+0x229/0x240
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __might_sleep+0x63/0x77
>  ? __flush_work+0x3b/0x38a
>  __flush_work+0x84/0x38a
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  ? ktime_get+0x8e/0xe4
>  ? trace_hardirqs_on+0xc7/0xf7
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 0000001e2bc5a50d RDI: ffffffff81664055
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 0000000000007d25 R11: 00000000000300c8 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
2974
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8108e14f>] start_secondary+0x48/0x11b
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  ? start_secondary+0x48/0x11b
>  ___might_sleep+0x229/0x240
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __might_sleep+0x63/0x77
>  ? __flush_work+0x3b/0x38a
>  __flush_work+0x84/0x38a
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  ? ktime_get+0x8e/0xe4
>  ? trace_hardirqs_on+0xc7/0xf7
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 0000001f57348651 RDI: ffffffff81664055
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 0000000000006ac4 R11: 0000000000007e37 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
2974
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8108e14f>] start_secondary+0x48/0x11b
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W         5.2.0-rc1 #1
> Hardware name: LENOVO 4174EH1/4174EH1, BIOS 8CET51WW (1.31 ) 11/29/2011
> Call Trace:
>  <IRQ>
>  dump_stack+0x67/0x93
>  ? start_secondary+0x48/0x11b
>  ___might_sleep+0x229/0x240
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  __might_sleep+0x63/0x77
>  ? __flush_work+0x3b/0x38a
>  __flush_work+0x84/0x38a
>  ? trace_hardirqs_on+0xc7/0xf7
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  ? _raw_spin_unlock_irqrestore+0x46/0x5b
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  flush_work+0xb/0xd
>  led_blink_setup+0x1e/0xd3
>  led_blink_set+0x3f/0x44
>  tpt_trig_timer+0xdb/0x106
>  ? add_timer_on+0xce/0xce
>  call_timer_fn+0x11e/0x2ce
>  ? __ieee80211_create_tpt_led_trigger+0xcb/0xcb
>  expire_timers+0x141/0x197
>  run_timer_softirq+0x65/0x10e
>  ? ktime_get+0x8e/0xe4
>  ? trace_hardirqs_on+0xc7/0xf7
>  __do_softirq+0x1bf/0x430
>  irq_exit+0x69/0xb9
>  smp_apic_timer_interrupt+0x1ee/0x269
>  apic_timer_interrupt+0xf/0x20
>  </IRQ>
> RIP: 0010:cpuidle_enter_state+0x1f4/0x34d
> Code: ff e8 36 0c ac ff 45 84 ff 74 16 9c 58 f6 c4 02 74 08 0f 0b fa e8 e=
5 da b4 ff 31 ff e8 23 c9 b1 ff e8 f0 d8 b4 ff fb 45 85 ed <0f> 88 e2 00 00=
 00 49 63 f5 b9 e8 03 00 00 48 6b c6 60 49 8d 7c 04
> RSP: 0018:ffff888234d8be58 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
> RAX: 0000000000000000 RBX: ffffe8ffffc864c0 RCX: 000000000000001f
> RDX: 0000000000000000 RSI: 000000207de2bdf6 RDI: ffffffff81664055
> RBP: ffff888234d8be98 R08: 0000000000000002 R09: fffffffa2dd3f8df
> R10: 000000000000afc8 R11: 00000000000185c2 R12: ffffffff8229e320
> R13: 0000000000000005 R14: ffffffff8229e518 R15: 0000000000000000
>  ? cpuidle_enter_state+0x1f0/0x34d
>  ? cpuidle_enter_state+0x1f0/0x34d
>  cpuidle_enter+0x28/0x36
>  call_cpuidle+0x3b/0x3d
>  do_idle+0x189/0x1eb
>  cpu_startup_entry+0x1a/0x1e
>  start_secondary+0xfe/0x11b
>  secondary_startup_64+0xa4/0xb0

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzpBf4ACgkQMOfwapXb+vJ5JQCeNL20cNgFLMzrcWp++MgXLHJp
jhIAoJCv4/Yv7/1qhUvDrPofa1xyR4Mf
=78GY
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
