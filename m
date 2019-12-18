Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF681245FE
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfLRLlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 06:41:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:59722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfLRLlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 06:41:45 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C51D21582;
        Wed, 18 Dec 2019 11:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576669303;
        bh=aULGyUA/wGPKod6NyWxf+sPn1EYFMleyk53t/k6z6fA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lKbb86CYHq9yNqnYdf/wU/yzfgus3CWcp9Z5PEHJvg0FJ6YkjNxOkUS4N5HzI+8jl
         pt8pLlnFUHPPN2Q/0TR1kdJqjdBz8pp2hn2MKuCAcxwDNusgyKi5Dd8F2Ych5xCY53
         M/f/osMm+EVWDl97J/DkuhMEfeICSsqR434ftU9o=
Date:   Wed, 18 Dec 2019 11:41:38 +0000
From:   Will Deacon <will@kernel.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH RESEND RESEND] media: uvc: Avoid cyclic entity chains due
 to malformed USB descriptors
Message-ID: <20191218114137.GA15505@willie-the-truck>
References: <20191108154838.21487-1-will@kernel.org>
 <20191108155503.GB15731@pendragon.ideasonboard.com>
 <20191216121651.GA12947@willie-the-truck>
 <CAAeHK+xdVmEFtK78bWd2Odn0uBynqnt5UT9jZJFvqGL=_9NU2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+xdVmEFtK78bWd2Odn0uBynqnt5UT9jZJFvqGL=_9NU2w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 02:17:52PM +0100, Andrey Konovalov wrote:
> On Mon, Dec 16, 2019 at 1:16 PM Will Deacon <will@kernel.org> wrote:
> > On Fri, Nov 08, 2019 at 05:55:03PM +0200, Laurent Pinchart wrote:
> > > Thank you for the patch.
> > >
> > > I'm sorry for the delay, and will have to ask you to be a bit more
> > > patient I'm afraid. I will leave tomorrow for a week without computer
> > > access and will only be able to go through my backlog when I will be
> > > back on the 17th.
> >
> > Gentle reminder on this, now you've been back a month ;)
> 
> I think we now have a reproducer for this issue that syzbot just reported:
> 
> https://syzkaller.appspot.com/bug?extid=0a5c96772a9b26f2a876
> 
> You can try you patch on it :)

Oh wow, I *really* like the raw USB gadget thingy you have to reproduce
these! I also really like that this patch fixes the issue. Logs below.

Laurent -- can we please merge this now?

Will

--->8

Before:

bash-5.0# ./repro
[   31.749418][   T92] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   31.989356][   T92] usb 1-1: Using ep0 maxpacket: 8
[   32.109448][   T92] usb 1-1: config index 0 descriptor too short (expected 51150, got 70)
[   32.111898][   T92] usb 1-1: config 0 contains an unexpected descriptor of type 0x2, skipping
[   32.114317][   T92] usb 1-1: config 0 has an invalid descriptor of length 0, skipping remainder of the config
[   32.117145][   T92] usb 1-1: config 0 interface 0 altsetting 0 has 0 endpoint descriptors, different from the interface descriptor's value: 16
[   32.120554][   T92] usb 1-1: New USB device found, idVendor=0bd3, idProduct=0755, bcdDevice=69.f1
[   32.122875][   T92] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   32.126602][   T92] usb 1-1: config 0 descriptor??
[   32.399436][   T92] usb 1-1: string descriptor 0 read error: -71
[   32.401266][   T92] uvcvideo: Found UVC 0.00 device <unnamed> (0bd3:0755)
[   32.403266][   T92] ------------[ cut here ]------------
[   32.404790][   T92] list_add double add: new=ffff888015992010, prev=ffff888015992010, next=ffff8880146c6a18.
[   32.407819][   T92] WARNING: CPU: 2 PID: 92 at lib/list_debug.c:31 __list_add_valid+0xab/0xe0
[   32.410214][   T92] Modules linked in:
[   32.411071][   T92] CPU: 2 PID: 92 Comm: kworker/2:1 Not tainted 5.5.0-rc2+ #1
[   32.412432][   T92] Workqueue: usb_hub_wq hub_event
[   32.413364][   T92] RIP: 0010:__list_add_valid+0xab/0xe0
[   32.414382][   T92] Code: 48 c7 c7 a0 ae fa 85 48 89 de e8 19 eb 2a ff 0f 0b 31 c0 eb cc 48 89 f2 48 89 d9 48 89 ee 48 c7 c7 20 af fa 85 e8 fe ea 2a ff <0f> 0b 31 c0 eb b1 48 89 34 24 e8 36 e8 7e ff 48 8b 34 24 e9 68 ff
[   32.418007][   T92] RSP: 0018:ffff8880158d7008 EFLAGS: 00010286
[   32.419127][   T92] RAX: 0000000000000000 RBX: ffff8880146c6a18 RCX: ffffffff81293978
[   32.420589][   T92] RDX: 0000000000000000 RSI: ffffffff812990fc RDI: 0000000000000006
[   32.421692][   T92] RBP: ffff888015992010 R08: ffff88801551de80 R09: fffffbfff11ea4b5
[   32.422744][   T92] R10: fffffbfff11ea4b4 R11: ffffffff88f525a7 R12: dffffc0000000000
[   32.423784][   T92] R13: ffff888015992000 R14: ffff8880146c6a20 R15: ffff8880146c6a18
[   32.424838][   T92] FS:  0000000000000000(0000) GS:ffff888016800000(0000) knlGS:0000000000000000
[   32.425996][   T92] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.426867][   T92] CR2: 0000000000478f10 CR3: 000000001327e005 CR4: 0000000000760ea0
[   32.427935][   T92] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.428972][   T92] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   32.430012][   T92] PKRU: 55555554
[   32.430473][   T92] Call Trace:
[   32.430944][   T92]  uvc_scan_chain_forward.isra.9+0x4df/0x635
[   32.431600][   T92]  uvc_probe.cold.19+0x1ef2/0x29bc
[   32.432175][   T92]  ? __lock_acquire+0xeda/0x41a0
[   32.432712][   T92]  ? mark_lock+0xbe/0x10f0
[   32.433209][   T92]  ? pm_runtime_enable+0x2a/0x310
[   32.433773][   T92]  ? find_held_lock+0x33/0x1c0
[   32.434307][   T92]  ? usb_probe_interface+0x307/0x7b0
[   32.434869][   T92]  usb_probe_interface+0x307/0x7b0
[   32.435414][   T92]  ? usb_probe_device+0xf0/0xf0
[   32.435938][   T92]  really_probe+0x281/0x700
[   32.436424][   T92]  ? driver_allows_async_probing+0x150/0x150
[   32.437065][   T92]  driver_probe_device+0x105/0x200
[   32.437611][   T92]  __device_attach_driver+0x1b9/0x230
[   32.438190][   T92]  bus_for_each_drv+0x156/0x1d0
[   32.438708][   T92]  ? bus_rescan_devices+0x20/0x20
[   32.439248][   T92]  ? lockdep_hardirqs_on+0x388/0x570
[   32.439812][   T92]  __device_attach+0x20b/0x350
[   32.440323][   T92]  ? device_bind_driver+0xc0/0xc0
[   32.440870][   T92]  bus_probe_device+0x1e5/0x290
[   32.441386][   T92]  device_add+0x1420/0x1b90
[   32.441887][   T92]  ? wait_for_completion+0x3c0/0x3c0
[   32.442466][   T92]  ? device_link_remove+0x150/0x150
[   32.443037][   T92]  usb_set_configuration+0xd6f/0x1750
[   32.443633][   T92]  generic_probe+0x95/0xcd
[   32.444146][   T92]  usb_probe_device+0x97/0xf0
[   32.444650][   T92]  ? usb_suspend+0x630/0x630
[   32.445151][   T92]  really_probe+0x281/0x700
[   32.445642][   T92]  ? driver_allows_async_probing+0x150/0x150
[   32.446299][   T92]  driver_probe_device+0x105/0x200
[   32.446857][   T92]  __device_attach_driver+0x1b9/0x230
[   32.447448][   T92]  bus_for_each_drv+0x156/0x1d0
[   32.447981][   T92]  ? bus_rescan_devices+0x20/0x20
[   32.448523][   T92]  ? lockdep_hardirqs_on+0x388/0x570
[   32.449095][   T92]  __device_attach+0x20b/0x350
[   32.449612][   T92]  ? device_bind_driver+0xc0/0xc0
[   32.450167][   T92]  bus_probe_device+0x1e5/0x290
[   32.450686][   T92]  device_add+0x1420/0x1b90
[   32.451164][   T92]  ? device_link_remove+0x150/0x150
[   32.451715][   T92]  ? _raw_spin_unlock_irq+0x1f/0x30
[   32.452267][   T92]  usb_new_device.cold.65+0x66e/0xe63
[   32.452835][   T92]  hub_event+0x1ebd/0x3810
[   32.453300][   T92]  ? hub_port_debounce+0x270/0x270
[   32.453837][   T92]  ? __lock_acquire+0xeda/0x41a0
[   32.454389][   T92]  ? find_held_lock+0x33/0x1c0
[   32.454904][   T92]  ? process_one_work+0x8fc/0x1720
[   32.455445][   T92]  ? mark_held_locks+0x110/0x110
[   32.455954][   T92]  ? rcu_read_lock_sched_held+0x9c/0xd0
[   32.456536][   T92]  ? rcu_read_lock_bh_held+0xb0/0xb0
[   32.457093][   T92]  process_one_work+0x9f2/0x1720
[   32.457616][   T92]  ? mark_held_locks+0x110/0x110
[   32.458138][   T92]  ? pwq_dec_nr_in_flight+0x310/0x310
[   32.458701][   T92]  ? do_raw_spin_lock+0x11b/0x280
[   32.459237][   T92]  worker_thread+0x8c/0xd10
[   32.459715][   T92]  ? process_one_work+0x1720/0x1720
[   32.460266][   T92]  kthread+0x352/0x420
[   32.460702][   T92]  ? kthread_create_on_node+0xe0/0xe0
[   32.461275][   T92]  ret_from_fork+0x24/0x30
[   32.461738][   T92] irq event stamp: 2238
[   32.462183][   T92] hardirqs last  enabled at (2237): [<ffffffff81293b92>] console_unlock+0x8f2/0xc40
[   32.463174][   T92] hardirqs last disabled at (2238): [<ffffffff8100468d>] trace_hardirqs_off_thunk+0x1a/0x1c
[   32.464244][   T92] softirqs last  enabled at (1196): [<ffffffff85c00643>] __do_softirq+0x643/0x8fc
[   32.465225][   T92] softirqs last disabled at (1187): [<ffffffff8115a035>] irq_exit+0x175/0x1a0
[   32.466155][   T92] ---[ end trace ef28d8c60b68a46d ]---
[   32.466781][   T92] uvcvideo: No valid video chain found.
[   32.468076][   T92] usb 1-1: USB disconnect, device number 2


After:

bash-5.0# ./repro
[   19.067221][   T92] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   19.307154][   T92] usb 1-1: Using ep0 maxpacket: 8
[   19.427261][   T92] usb 1-1: config index 0 descriptor too short (expected 51150, got 70)
[   19.429709][   T92] usb 1-1: config 0 contains an unexpected descriptor of type 0x2, skipping
[   19.432150][   T92] usb 1-1: config 0 has an invalid descriptor of length 0, skipping remainder of the config
[   19.435003][   T92] usb 1-1: config 0 interface 0 altsetting 0 has 0 endpoint descriptors, different from the interface descriptor's value: 16
[   19.438655][   T92] usb 1-1: New USB device found, idVendor=0bd3, idProduct=0755, bcdDevice=69.f1
[   19.441166][   T92] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   19.445163][   T92] usb 1-1: config 0 descriptor??
[   19.717195][   T92] usb 1-1: string descriptor 0 read error: -71
[   19.719038][   T92] uvcvideo: Found UVC 0.00 device <unnamed> (0bd3:0755)
[   19.721087][   T92] uvcvideo: No valid video chain found.
[   19.725262][   T92] usb 1-1: USB disconnect, device number 2
