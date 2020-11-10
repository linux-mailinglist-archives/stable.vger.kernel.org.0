Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0D82ACE52
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731890AbgKJEJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731692AbgKJDxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FACD207BC;
        Tue, 10 Nov 2020 03:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980410;
        bh=wxReGi6HVGFdUbh0Mok77vUSY+a2MBXG85WHU4GVGms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrw9qPnEMCsnIH8R8uWd9FSjFkrmNln4FeBoEXCbVoWu5YD19rEw60NiwUW29FhMl
         RWib5vCzqESCfawPb/ysO+DMvOJrbeus0tSPqk1TrnD+Kbl72x9ItrtABO8l0H8103
         yfOyuOBMRZTqnf5+WSH9iJ1/dM/tkIKK/+lVJaCs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang.zhang@windriver.com>,
        syzbot+bd38200f53df6259e6bf@syzkaller.appspotmail.com,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 08/55] usb: raw-gadget: fix memory leak in gadget_setup
Date:   Mon,  9 Nov 2020 22:52:31 -0500
Message-Id: <20201110035318.423757-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit 129aa9734559a17990ee933351c7b6956f1dba62 ]

When fetch 'event' from event queue, after copy its address
space content to user space, the 'event' the memory space
pointed to by the 'event' pointer need be freed.

BUG: memory leak
unreferenced object 0xffff888110622660 (size 32):
  comm "softirq", pid 0, jiffies 4294941981 (age 12.480s)
  hex dump (first 32 bytes):
    02 00 00 00 08 00 00 00 80 06 00 01 00 00 40 00  ..............@.
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000efd29abd>] kmalloc include/linux/slab.h:554 [inline]
    [<00000000efd29abd>] raw_event_queue_add drivers/usb/gadget/legacy/raw_gadget.c:66 [inline]
    [<00000000efd29abd>] raw_queue_event drivers/usb/gadget/legacy/raw_gadget.c:225 [inline]
    [<00000000efd29abd>] gadget_setup+0xf6/0x220 drivers/usb/gadget/legacy/raw_gadget.c:343
    [<00000000952c4a46>] dummy_timer+0xb9f/0x14c0 drivers/usb/gadget/udc/dummy_hcd.c:1899
    [<0000000074ac2c54>] call_timer_fn+0x38/0x200 kernel/time/timer.c:1415
    [<00000000560a3a79>] expire_timers kernel/time/timer.c:1460 [inline]
    [<00000000560a3a79>] __run_timers.part.0+0x319/0x400 kernel/time/timer.c:1757
    [<000000009d9503d0>] __run_timers kernel/time/timer.c:1738 [inline]
    [<000000009d9503d0>] run_timer_softirq+0x3d/0x80 kernel/time/timer.c:1770
    [<000000009df27c89>] __do_softirq+0xcc/0x2c2 kernel/softirq.c:298
    [<000000007a3f1a47>] asm_call_irq_on_stack+0xf/0x20
    [<000000004a62cc2e>] __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
    [<000000004a62cc2e>] run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
    [<000000004a62cc2e>] do_softirq_own_stack+0x32/0x40 arch/x86/kernel/irq_64.c:77
    [<00000000b0086800>] invoke_softirq kernel/softirq.c:393 [inline]
    [<00000000b0086800>] __irq_exit_rcu kernel/softirq.c:423 [inline]
    [<00000000b0086800>] irq_exit_rcu+0x91/0xc0 kernel/softirq.c:435
    [<00000000175f9523>] sysvec_apic_timer_interrupt+0x36/0x80 arch/x86/kernel/apic/apic.c:1091
    [<00000000a348e847>] asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
    [<0000000060661100>] native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
    [<0000000060661100>] arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
    [<0000000060661100>] acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
    [<0000000060661100>] acpi_idle_do_entry+0xc3/0xd0 drivers/acpi/processor_idle.c:517
    [<000000003f413b99>] acpi_idle_enter+0x128/0x1f0 drivers/acpi/processor_idle.c:648
    [<00000000f5e5afb8>] cpuidle_enter_state+0xc9/0x650 drivers/cpuidle/cpuidle.c:237
    [<00000000d50d51fc>] cpuidle_enter+0x29/0x40 drivers/cpuidle/cpuidle.c:351
    [<00000000d674baed>] call_cpuidle kernel/sched/idle.c:132 [inline]
    [<00000000d674baed>] cpuidle_idle_call kernel/sched/idle.c:213 [inline]
    [<00000000d674baed>] do_idle+0x1c8/0x250 kernel/sched/idle.c:273

Reported-by: syzbot+bd38200f53df6259e6bf@syzkaller.appspotmail.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index e01e366d89cd5..062dfac303996 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -564,9 +564,12 @@ static int raw_ioctl_event_fetch(struct raw_dev *dev, unsigned long value)
 		return -ENODEV;
 	}
 	length = min(arg.length, event->length);
-	if (copy_to_user((void __user *)value, event, sizeof(*event) + length))
+	if (copy_to_user((void __user *)value, event, sizeof(*event) + length)) {
+		kfree(event);
 		return -EFAULT;
+	}
 
+	kfree(event);
 	return 0;
 }
 
-- 
2.27.0

