Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1B4F5665
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391640AbfKHTIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391628AbfKHTIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:08:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D3AD206A3;
        Fri,  8 Nov 2019 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240113;
        bh=TAuMHgqwJJKTmBeWOg5vHut9F581cQ4TYt5g1x0s8Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+Wk7k39kzyKJKzYJUOoQ604rrl6M2x4iSZQ8yZyEnXs9WzVXTwdiKBZHHw9cO9fb
         Q7Df4C62ks1RGgcumqhm93oDqFdZH/LmhbSEYetCq1C+efon4ZmnkOd/1noIzv2R6D
         gjhVkY6tL5a51mgSuuVA0sp4erUiHEEA5NeRWSnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 5.3 093/140] net: usb: lan78xx: Disable interrupts before calling generic_handle_irq()
Date:   Fri,  8 Nov 2019 19:50:21 +0100
Message-Id: <20191108174910.923423603@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 0a29ac5bd3a988dc151c8d26910dec2557421f64 ]

lan78xx_status() will run with interrupts enabled due to the change in
ed194d136769 ("usb: core: remove local_irq_save() around ->complete()
handler"). generic_handle_irq() expects to be run with IRQs disabled.

[    4.886203] 000: irq 79 handler irq_default_primary_handler+0x0/0x8 enabled interrupts
[    4.886243] 000: WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:152 __handle_irq_event_percpu+0x154/0x168
[    4.896294] 000: Modules linked in:
[    4.896301] 000: CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.3.6 #39
[    4.896310] 000: Hardware name: Raspberry Pi 3 Model B+ (DT)
[    4.896315] 000: pstate: 60000005 (nZCv daif -PAN -UAO)
[    4.896321] 000: pc : __handle_irq_event_percpu+0x154/0x168
[    4.896331] 000: lr : __handle_irq_event_percpu+0x154/0x168
[    4.896339] 000: sp : ffff000010003cc0
[    4.896346] 000: x29: ffff000010003cc0 x28: 0000000000000060
[    4.896355] 000: x27: ffff000011021980 x26: ffff00001189c72b
[    4.896364] 000: x25: ffff000011702bc0 x24: ffff800036d6e400
[    4.896373] 000: x23: 000000000000004f x22: ffff000010003d64
[    4.896381] 000: x21: 0000000000000000 x20: 0000000000000002
[    4.896390] 000: x19: ffff8000371c8480 x18: 0000000000000060
[    4.896398] 000: x17: 0000000000000000 x16: 00000000000000eb
[    4.896406] 000: x15: ffff000011712d18 x14: 7265746e69206465
[    4.896414] 000: x13: ffff000010003ba0 x12: ffff000011712df0
[    4.896422] 000: x11: 0000000000000001 x10: ffff000011712e08
[    4.896430] 000: x9 : 0000000000000001 x8 : 000000000003c920
[    4.896437] 000: x7 : ffff0000118cc410 x6 : ffff0000118c7f00
[    4.896445] 000: x5 : 000000000003c920 x4 : 0000000000004510
[    4.896453] 000: x3 : ffff000011712dc8 x2 : 0000000000000000
[    4.896461] 000: x1 : 73a3f67df94c1500 x0 : 0000000000000000
[    4.896466] 000: Call trace:
[    4.896471] 000:  __handle_irq_event_percpu+0x154/0x168
[    4.896481] 000:  handle_irq_event_percpu+0x50/0xb0
[    4.896489] 000:  handle_irq_event+0x40/0x98
[    4.896497] 000:  handle_simple_irq+0xa4/0xf0
[    4.896505] 000:  generic_handle_irq+0x24/0x38
[    4.896513] 000:  intr_complete+0xb0/0xe0
[    4.896525] 000:  __usb_hcd_giveback_urb+0x58/0xd8
[    4.896533] 000:  usb_giveback_urb_bh+0xd0/0x170
[    4.896539] 000:  tasklet_action_common.isra.0+0x9c/0x128
[    4.896549] 000:  tasklet_hi_action+0x24/0x30
[    4.896556] 000:  __do_softirq+0x120/0x23c
[    4.896564] 000:  irq_exit+0xb8/0xd8
[    4.896571] 000:  __handle_domain_irq+0x64/0xb8
[    4.896579] 000:  bcm2836_arm_irqchip_handle_irq+0x60/0xc0
[    4.896586] 000:  el1_irq+0xb8/0x140
[    4.896592] 000:  arch_cpu_idle+0x10/0x18
[    4.896601] 000:  do_idle+0x200/0x280
[    4.896608] 000:  cpu_startup_entry+0x20/0x28
[    4.896615] 000:  rest_init+0xb4/0xc0
[    4.896623] 000:  arch_call_rest_init+0xc/0x14
[    4.896632] 000:  start_kernel+0x454/0x480

Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
Cc: Woojung Huh <woojung.huh@microchip.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stefan Wahren <wahrenst@gmx.net>
Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Tested-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1265,8 +1265,11 @@ static void lan78xx_status(struct lan78x
 		netif_dbg(dev, link, dev->net, "PHY INTR: 0x%08x\n", intdata);
 		lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 
-		if (dev->domain_data.phyirq > 0)
+		if (dev->domain_data.phyirq > 0) {
+			local_irq_disable();
 			generic_handle_irq(dev->domain_data.phyirq);
+			local_irq_enable();
+		}
 	} else
 		netdev_warn(dev->net,
 			    "unexpected interrupt: 0x%08x\n", intdata);


