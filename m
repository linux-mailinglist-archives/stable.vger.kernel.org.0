Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC6D1774E8
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 12:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgCCK7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 05:59:39 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38575 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgCCK7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 05:59:38 -0500
X-Originating-IP: 86.202.111.97
Received: from localhost (lfbn-lyo-1-16-97.w86-202.abo.wanadoo.fr [86.202.111.97])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 81CD0E0008;
        Tue,  3 Mar 2020 10:59:33 +0000 (UTC)
Date:   Tue, 3 Mar 2020 11:59:33 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, stable@vger.kernel.org
Subject: Re: [PATCH] rtc/cmos: Protect rtc_lock from interrupts
Message-ID: <20200303105933.GF4803@piout.net>
References: <20200302134455.318328-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302134455.318328-1-chris@chris-wilson.co.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 02/03/2020 13:44:55+0000, Chris Wilson wrote:
> cmos_interrrupt() is called directly on resume paths, and by the
> irqhandler. It currently assumes that it can only be invoked directly
> from a hardirq, and so leads to the lockdep splat:
> 
> <4>[  259.166718] WARNING: inconsistent lock state
> <4>[  259.166725] 5.6.0-rc3-CI-CI_DRM_8038+ #1 Tainted: G     U
> <4>[  259.166727] --------------------------------
> <4>[  259.166731] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> <4>[  259.166741] rtcwake/4221 [HC0[0]:SC0[0]:HE1:SE1] takes:
> <4>[  259.166745] ffffffff82635198 (rtc_lock){?...}, at: cmos_interrupt+0x18/0x100
> <4>[  259.166768] {IN-HARDIRQ-W} state was registered at:
> <4>[  259.166780]   lock_acquire+0xa7/0x1c0
> <4>[  259.166790]   _raw_spin_lock+0x2a/0x40
> <4>[  259.166799]   cmos_interrupt+0x18/0x100
> <4>[  259.166808]   rtc_handler+0x75/0xc0
> <4>[  259.166822]   acpi_ev_fixed_event_detect+0xf9/0x132
> <4>[  259.166829]   acpi_ev_sci_xrupt_handler+0xb/0x28
> <4>[  259.166838]   acpi_irq+0x13/0x30
> <4>[  259.166849]   __handle_irq_event_percpu+0x41/0x2c0
> <4>[  259.166859]   handle_irq_event_percpu+0x2b/0x70
> <4>[  259.166868]   handle_irq_event+0x2f/0x50
> <4>[  259.166875]   handle_fasteoi_irq+0x8e/0x150
> <4>[  259.166883]   do_IRQ+0x7e/0x160
> <4>[  259.166891]   ret_from_intr+0x0/0x35
> <4>[  259.166898]   mwait_idle+0x7e/0x200
> <4>[  259.166905]   do_idle+0x1bb/0x260
> <4>[  259.166912]   cpu_startup_entry+0x14/0x20
> <4>[  259.166921]   start_secondary+0x15f/0x1b0
> <4>[  259.166929]   secondary_startup_64+0xa4/0xb0
> <4>[  259.167264] irq event stamp: 41593
> <4>[  259.167275] hardirqs last  enabled at (41593): [<ffffffff81a394e7>] _raw_spin_unlock_irqrestore+0x47/0x60
> <4>[  259.167285] hardirqs last disabled at (41592): [<ffffffff81a3926d>] _raw_spin_lock_irqsave+0xd/0x50
> <4>[  259.167296] softirqs last  enabled at (41568): [<ffffffff81e00385>] __do_softirq+0x385/0x47f
> <4>[  259.167306] softirqs last disabled at (41561): [<ffffffff810babaa>] irq_exit+0xba/0xc0
> <4>[  259.167309]
>                   other info that might help us debug this:
> <4>[  259.167312]  Possible unsafe locking scenario:
> 
> <4>[  259.167314]        CPU0
> <4>[  259.167316]        ----
> <4>[  259.167319]   lock(rtc_lock);
> <4>[  259.167324]   <Interrupt>
> <4>[  259.167326]     lock(rtc_lock);
> <4>[  259.167332]
>                    *** DEADLOCK ***
> 
> <4>[  259.167337] 6 locks held by rtcwake/4221:
> <4>[  259.167665]  #0: ffff888175e89408 (sb_writers#5){.+.+}, at: vfs_write+0x1a4/0x1d0
> <4>[  259.167687]  #1: ffff88816e112080 (&of->mutex){+.+.}, at: kernfs_fop_write+0xdd/0x1b0
> <4>[  259.167706]  #2: ffff888179be85e0 (kn->count#236){.+.+}, at: kernfs_fop_write+0xe6/0x1b0
> <4>[  259.167728]  #3: ffffffff82641e00 (system_transition_mutex){+.+.}, at: pm_suspend+0xb3/0x3b0
> <4>[  259.167748]  #4: ffffffff826b3ea0 (acpi_scan_lock){+.+.}, at: acpi_suspend_begin+0x47/0x80
> <4>[  259.167763]  #5: ffff888178f6b960 (&dev->mutex){....}, at: device_resume+0x92/0x1c0
> <4>[  259.167778]
>                   stack backtrace:
> <4>[  259.167788] CPU: 1 PID: 4221 Comm: rtcwake Tainted: G     U            5.6.0-rc3-CI-CI_DRM_8038+ #1
> <4>[  259.168106] Hardware name: Google Soraka/Soraka, BIOS MrChromebox-4.10 08/25/2019
> <4>[  259.168110] Call Trace:
> <4>[  259.168123]  dump_stack+0x71/0x9b
> <4>[  259.168133]  mark_lock+0x49a/0x500
> <4>[  259.168457]  ? print_shortest_lock_dependencies+0x200/0x200
> <4>[  259.168469]  __lock_acquire+0x6d4/0x15d0
> <4>[  259.168479]  ? __lock_acquire+0x460/0x15d0
> <4>[  259.168490]  lock_acquire+0xa7/0x1c0
> <4>[  259.168500]  ? cmos_interrupt+0x18/0x100
> <4>[  259.168824]  _raw_spin_lock+0x2a/0x40
> <4>[  259.168834]  ? cmos_interrupt+0x18/0x100
> <4>[  259.168843]  cmos_interrupt+0x18/0x100
> <4>[  259.169159]  cmos_resume+0x1fd/0x290
> <4>[  259.169174]  ? __acpi_pm_set_device_wakeup+0x24/0x100
> <4>[  259.169498]  pnp_bus_resume+0x5e/0x90
> <4>[  259.169509]  ? pnp_bus_suspend+0x10/0x10
> <4>[  259.169518]  dpm_run_callback+0x64/0x280
> <4>[  259.169530]  device_resume+0xd4/0x1c0
> <4>[  259.169540]  ? dpm_watchdog_set+0x60/0x60
> <4>[  259.169860]  dpm_resume+0x106/0x410
> <4>[  259.169870]  ? dpm_resume_early+0x38c/0x3e0
> <4>[  259.169881]  dpm_resume_end+0x8/0x10
> <4>[  259.170195]  suspend_devices_and_enter+0x16f/0xbe0
> <4>[  259.170211]  ? rcu_read_lock_sched_held+0x4d/0x80
> <4>[  259.170528]  pm_suspend+0x344/0x3b0
> <4>[  259.170542]  state_store+0x78/0xe0
> <4>[  259.170559]  kernfs_fop_write+0x112/0x1b0
> <4>[  259.170579]  vfs_write+0xb9/0x1d0
> <4>[  259.170896]  ksys_write+0x9f/0xe0
> <4>[  259.170907]  do_syscall_64+0x4f/0x220
> <4>[  259.170918]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> <4>[  259.171229] RIP: 0033:0x7f9b4f3cb154
> <4>[  259.171240] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 b1 07 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5
> <4>[  259.171245] RSP: 002b:00007ffc057ce438 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> <4>[  259.171253] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f9b4f3cb154
> <4>[  259.171257] RDX: 0000000000000004 RSI: 000055f4b3d185a0 RDI: 000000000000000a
> <4>[  259.171572] RBP: 000055f4b3d185a0 R08: 000055f4b3d165e0 R09: 00007f9b4fab7740
> <4>[  259.171576] R10: 000055f4b3d14010 R11: 0000000000000246 R12: 000055f4b3d16500
> <4>[  259.171580] R13: 0000000000000004 R14: 00007f9b4f6a32a0 R15: 00007f9b4f6a2760
> 
> Fixes: c6d3a278cc12 ("rtc: cmos: acknowledge ACPI driven wake alarms upon resume")
> Fixes: 311ee9c151ad ("rtc: cmos: allow using ACPI for RTC alarm instead of HPET")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: <stable@vger.kernel.org> # v4.18+
> ---
>  drivers/rtc/rtc-cmos.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

I applied the previous fix from Ville but I took your Fixes: tag before
pushing. Thanks!


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
