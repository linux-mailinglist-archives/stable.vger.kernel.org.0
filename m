Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FAD259409
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgIAPex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbgIAPev (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E16A20866;
        Tue,  1 Sep 2020 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974490;
        bh=jYb4GQxI7atbxo7wKSsAyMnuCDwEneApn0EWTOBjdjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+tEJ1QcGsSd5v67yH97HS1QfMbQ1cLwjl59xtGz0W/CT/HMqD8maugDyJtwfOA7+
         grc7rKuViuZDL330pxEADFay0tJ8NTTC1BVJvt+9CYc4CToNUpmMD9CVl2qsRDntKG
         DGl/0U4sa/kq6tE61ivK6VDHW/1poJK3K7HcaKIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Raul Rangel <rrangel@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 166/214] serial: 8250: change lock order in serial8250_do_startup()
Date:   Tue,  1 Sep 2020 17:10:46 +0200
Message-Id: <20200901151000.930281293@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit 205d300aea75623e1ae4aa43e0d265ab9cf195fd upstream.

We have a number of "uart.port->desc.lock vs desc.lock->uart.port"
lockdep reports coming from 8250 driver; this causes a bit of trouble
to people, so let's fix it.

The problem is reverse lock order in two different call paths:

chain #1:

 serial8250_do_startup()
  spin_lock_irqsave(&port->lock);
   disable_irq_nosync(port->irq);
    raw_spin_lock_irqsave(&desc->lock)

chain #2:

  __report_bad_irq()
   raw_spin_lock_irqsave(&desc->lock)
    for_each_action_of_desc()
     printk()
      spin_lock_irqsave(&port->lock);

Fix this by changing the order of locks in serial8250_do_startup():
 do disable_irq_nosync() first, which grabs desc->lock, and grab
 uart->port after that, so that chain #1 and chain #2 have same lock
 order.

Full lockdep splat:

 ======================================================
 WARNING: possible circular locking dependency detected
 5.4.39 #55 Not tainted
 ======================================================

 swapper/0/0 is trying to acquire lock:
 ffffffffab65b6c0 (console_owner){-...}, at: console_lock_spinning_enable+0x31/0x57

 but task is already holding lock:
 ffff88810a8e34c0 (&irq_desc_lock_class){-.-.}, at: __report_bad_irq+0x5b/0xba

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #2 (&irq_desc_lock_class){-.-.}:
        _raw_spin_lock_irqsave+0x61/0x8d
        __irq_get_desc_lock+0x65/0x89
        __disable_irq_nosync+0x3b/0x93
        serial8250_do_startup+0x451/0x75c
        uart_startup+0x1b4/0x2ff
        uart_port_activate+0x73/0xa0
        tty_port_open+0xae/0x10a
        uart_open+0x1b/0x26
        tty_open+0x24d/0x3a0
        chrdev_open+0xd5/0x1cc
        do_dentry_open+0x299/0x3c8
        path_openat+0x434/0x1100
        do_filp_open+0x9b/0x10a
        do_sys_open+0x15f/0x3d7
        kernel_init_freeable+0x157/0x1dd
        kernel_init+0xe/0x105
        ret_from_fork+0x27/0x50

 -> #1 (&port_lock_key){-.-.}:
        _raw_spin_lock_irqsave+0x61/0x8d
        serial8250_console_write+0xa7/0x2a0
        console_unlock+0x3b7/0x528
        vprintk_emit+0x111/0x17f
        printk+0x59/0x73
        register_console+0x336/0x3a4
        uart_add_one_port+0x51b/0x5be
        serial8250_register_8250_port+0x454/0x55e
        dw8250_probe+0x4dc/0x5b9
        platform_drv_probe+0x67/0x8b
        really_probe+0x14a/0x422
        driver_probe_device+0x66/0x130
        device_driver_attach+0x42/0x5b
        __driver_attach+0xca/0x139
        bus_for_each_dev+0x97/0xc9
        bus_add_driver+0x12b/0x228
        driver_register+0x64/0xed
        do_one_initcall+0x20c/0x4a6
        do_initcall_level+0xb5/0xc5
        do_basic_setup+0x4c/0x58
        kernel_init_freeable+0x13f/0x1dd
        kernel_init+0xe/0x105
        ret_from_fork+0x27/0x50

 -> #0 (console_owner){-...}:
        __lock_acquire+0x118d/0x2714
        lock_acquire+0x203/0x258
        console_lock_spinning_enable+0x51/0x57
        console_unlock+0x25d/0x528
        vprintk_emit+0x111/0x17f
        printk+0x59/0x73
        __report_bad_irq+0xa3/0xba
        note_interrupt+0x19a/0x1d6
        handle_irq_event_percpu+0x57/0x79
        handle_irq_event+0x36/0x55
        handle_fasteoi_irq+0xc2/0x18a
        do_IRQ+0xb3/0x157
        ret_from_intr+0x0/0x1d
        cpuidle_enter_state+0x12f/0x1fd
        cpuidle_enter+0x2e/0x3d
        do_idle+0x1ce/0x2ce
        cpu_startup_entry+0x1d/0x1f
        start_kernel+0x406/0x46a
        secondary_startup_64+0xa4/0xb0

 other info that might help us debug this:

 Chain exists of:
   console_owner --> &port_lock_key --> &irq_desc_lock_class

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&irq_desc_lock_class);
                                lock(&port_lock_key);
                                lock(&irq_desc_lock_class);
   lock(console_owner);

  *** DEADLOCK ***

 2 locks held by swapper/0/0:
  #0: ffff88810a8e34c0 (&irq_desc_lock_class){-.-.}, at: __report_bad_irq+0x5b/0xba
  #1: ffffffffab65b5c0 (console_lock){+.+.}, at: console_trylock_spinning+0x20/0x181

 stack backtrace:
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.39 #55
 Hardware name: XXXXXX
 Call Trace:
  <IRQ>
  dump_stack+0xbf/0x133
  ? print_circular_bug+0xd6/0xe9
  check_noncircular+0x1b9/0x1c3
  __lock_acquire+0x118d/0x2714
  lock_acquire+0x203/0x258
  ? console_lock_spinning_enable+0x31/0x57
  console_lock_spinning_enable+0x51/0x57
  ? console_lock_spinning_enable+0x31/0x57
  console_unlock+0x25d/0x528
  ? console_trylock+0x18/0x4e
  vprintk_emit+0x111/0x17f
  ? lock_acquire+0x203/0x258
  printk+0x59/0x73
  __report_bad_irq+0xa3/0xba
  note_interrupt+0x19a/0x1d6
  handle_irq_event_percpu+0x57/0x79
  handle_irq_event+0x36/0x55
  handle_fasteoi_irq+0xc2/0x18a
  do_IRQ+0xb3/0x157
  common_interrupt+0xf/0xf
  </IRQ>

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Fixes: 768aec0b5bcc ("serial: 8250: fix shared interrupts issues with SMP and RT kernels")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Raul Rangel <rrangel@google.com>
BugLink: https://bugs.chromium.org/p/chromium/issues/detail?id=1114800
Link: https://lore.kernel.org/lkml/CAHQZ30BnfX+gxjPm1DUd5psOTqbyDh4EJE=2=VAMW_VDafctkA@mail.gmail.com/T/#u
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200817022646.1484638-1-sergey.senozhatsky@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_port.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2198,6 +2198,10 @@ int serial8250_do_startup(struct uart_po
 
 	if (port->irq && !(up->port.flags & UPF_NO_THRE_TEST)) {
 		unsigned char iir1;
+
+		if (port->irqflags & IRQF_SHARED)
+			disable_irq_nosync(port->irq);
+
 		/*
 		 * Test for UARTs that do not reassert THRE when the
 		 * transmitter is idle and the interrupt has already
@@ -2207,8 +2211,6 @@ int serial8250_do_startup(struct uart_po
 		 * allow register changes to become visible.
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		if (up->port.irqflags & IRQF_SHARED)
-			disable_irq_nosync(port->irq);
 
 		wait_for_xmitr(up, UART_LSR_THRE);
 		serial_port_out_sync(port, UART_IER, UART_IER_THRI);
@@ -2220,9 +2222,10 @@ int serial8250_do_startup(struct uart_po
 		iir = serial_port_in(port, UART_IIR);
 		serial_port_out(port, UART_IER, 0);
 
+		spin_unlock_irqrestore(&port->lock, flags);
+
 		if (port->irqflags & IRQF_SHARED)
 			enable_irq(port->irq);
-		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
 		 * If the interrupt is not reasserted, or we otherwise


