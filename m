Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED1C10BC66
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfK0VHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732576AbfK0VHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0223F21774;
        Wed, 27 Nov 2019 21:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888837;
        bh=T1MXmbsTb5l21gkuQES/GB8e+xI4ESof/KURkbDXcow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTZnUV16QqnLo2+JldCwWGx6xDYq/Is4EF3sedh/lchf0/20uP+6tpo2G7gYGikFJ
         i/ltaoVLS3NWEoGhCc376//B+o0FWgaNwLf914PgZxmFbX4RXCI/V7aurUGIIJR7bS
         zTCmGsLWmiOJhzvwDwPjzedC0aIJaPmw4kS7YYKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f49d12d34f2321cf4df2@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 290/306] media: imon: invalid dereference in imon_touch_event
Date:   Wed, 27 Nov 2019 21:32:20 +0100
Message-Id: <20191127203135.948976481@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit f3f5ba42c58d56d50f539854d8cc188944e96087 upstream.

The touch timer is set up in intf1. If the second interface does not exist,
the timer and touch input device are not setup and we get the following
error, when touch events are reported via intf0.

kernel BUG at kernel/time/timer.c:956!
invalid opcode: 0000 [#1] SMP KASAN
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__mod_timer kernel/time/timer.c:956 [inline]
RIP: 0010:__mod_timer kernel/time/timer.c:949 [inline]
RIP: 0010:mod_timer+0x5a2/0xb50 kernel/time/timer.c:1100
Code: 45 10 c7 44 24 14 ff ff ff ff 48 89 44 24 08 48 8d 45 20 48 c7 44 24 18 00 00 00 00 48 89 04 24 e9 5a fc ff ff e8 ae ce 0e 00 <0f> 0b e8 a7 ce 0e 00 4c 89 74 24 20 e9 37 fe ff ff e8 98 ce 0e 00
RSP: 0018:ffff8881db209930 EFLAGS: 00010006
RAX: ffffffff86c2b200 RBX: 00000000ffffa688 RCX: ffffffff83efc583
RDX: 0000000000000100 RSI: ffffffff812f4d82 RDI: ffff8881d2356200
RBP: ffff8881d23561e8 R08: ffffffff86c2b200 R09: ffffed103a46abeb
R10: ffffed103a46abea R11: ffff8881d2355f53 R12: dffffc0000000000
R13: 1ffff1103b64132d R14: ffff8881d2355f50 R15: 0000000000000006
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f75e2799000 CR3: 00000001d3b07000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 imon_touch_event drivers/media/rc/imon.c:1348 [inline]
 imon_incoming_packet.isra.0+0x2546/0x2f10 drivers/media/rc/imon.c:1603
 usb_rx_callback_intf0+0x151/0x1e0 drivers/media/rc/imon.c:1734
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1654
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1719
 dummy_timer+0x120f/0x2fa2 drivers/usb/gadget/udc/dummy_hcd.c:1965
 call_timer_fn+0x179/0x650 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5e3/0x1490 kernel/time/timer.c:1786
 __do_softirq+0x221/0x912 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x12f/0x500 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
 </IRQ>
RIP: 0010:default_idle+0x28/0x2e0 arch/x86/kernel/process.c:581
Code: 90 90 41 56 41 55 65 44 8b 2d 44 3a 8f 7a 41 54 55 53 0f 1f 44 00 00 e8 36 ee d0 fb e9 07 00 00 00 0f 00 2d fa dd 4f 00 fb f4 <65> 44 8b 2d 20 3a 8f 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffffff86c07da8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffffffff86c2b200 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffffff86c2ba4c
RBP: fffffbfff0d85640 R08: ffffffff86c2b200 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3b6/0x500 kernel/sched/idle.c:263
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:355
 start_kernel+0x82a/0x864 init/main.c:784
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241
Modules linked in:

Reported-by: syzbot+f49d12d34f2321cf4df2@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/imon.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1607,8 +1607,7 @@ static void imon_incoming_packet(struct
 	spin_unlock_irqrestore(&ictx->kc_lock, flags);
 
 	/* send touchscreen events through input subsystem if touchpad data */
-	if (ictx->display_type == IMON_DISPLAY_TYPE_VGA && len == 8 &&
-	    buf[7] == 0x86) {
+	if (ictx->touch && len == 8 && buf[7] == 0x86) {
 		imon_touch_event(ictx, buf);
 		return;
 


