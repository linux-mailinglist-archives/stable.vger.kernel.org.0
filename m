Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05859B922F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390035AbfITOaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:30:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37128 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388501AbfITOZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:23 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-00051F-P2; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007sk-Ci; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Slaby" <jslaby@suse.cz>, "Wang Li" <wangli39@baidu.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Zhang Yu" <zhangyu31@baidu.com>,
        "Li RongQing" <lirongqing@baidu.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.3301383@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 052/132] TTY: serial_core, add ->install
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 4cdd17ba1dff20ffc99fdbd2e6f0201fc7fe67df upstream.

We need to compute the uart state only on the first open. This is
usually what is done in the ->install hook. serial_core used to do this
in ->open on every open. So move it to ->install.

As a side effect, it ensures the state is set properly in the window
after tty_init_dev is called, but before uart_open. This fixes a bunch
of races between tty_open and flush_to_ldisc we were dealing with
recently.

One of such bugs was attempted to fix in commit fedb5760648a (serial:
fix race between flush_to_ldisc and tty_open), but it only took care of
a couple of functions (uart_start and uart_unthrottle).  I was able to
reproduce the crash on a SLE system, but in uart_write_room which is
also called from flush_to_ldisc via process_echoes. I was *unable* to
reproduce the bug locally. It is due to having this patch in my queue
since 2012!

 general protection fault: 0000 [#1] SMP KASAN PTI
 CPU: 1 PID: 5 Comm: kworker/u4:0 Tainted: G             L 4.12.14-396-default #1 SLE15-SP1 (unreleased)
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c89-prebuilt.qemu.org 04/01/2014
 Workqueue: events_unbound flush_to_ldisc
 task: ffff8800427d8040 task.stack: ffff8800427f0000
 RIP: 0010:uart_write_room+0xc4/0x590
 RSP: 0018:ffff8800427f7088 EFLAGS: 00010202
 RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 000000000000002f RSI: 00000000000000ee RDI: ffff88003888bd90
 RBP: ffffffffb9545850 R08: 0000000000000001 R09: 0000000000000400
 R10: ffff8800427d825c R11: 000000000000006e R12: 1ffff100084fee12
 R13: ffffc900004c5000 R14: ffff88003888bb28 R15: 0000000000000178
 FS:  0000000000000000(0000) GS:ffff880043300000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000561da0794148 CR3: 000000000ebf4000 CR4: 00000000000006e0
 Call Trace:
  tty_write_room+0x6d/0xc0
  __process_echoes+0x55/0x870
  n_tty_receive_buf_common+0x105e/0x26d0
  tty_ldisc_receive_buf+0xb7/0x1c0
  tty_port_default_receive_buf+0x107/0x180
  flush_to_ldisc+0x35d/0x5c0
...

0 in rbx means tty->driver_data is NULL in uart_write_room. 0x178 is
tried to be dereferenced (0x178 >> 3 is 0x2f in rdx) at
uart_write_room+0xc4. 0x178 is exactly (struct uart_state *)NULL->refcount
used in uart_port_lock from uart_write_room.

So revert the upstream commit here as my local patch should fix the
whole family.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Wang Li <wangli39@baidu.com>
Cc: Zhang Yu <zhangyu31@baidu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: The previous fix didn't apply, so we don't need
 to revert it here.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1541,6 +1541,16 @@ static void uart_dtr_rts(struct tty_port
 		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
+static int uart_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + tty->index;
+
+	tty->driver_data = state;
+
+	return tty_standard_install(driver, tty);
+}
+
 /*
  * Calls to uart_open are serialised by the tty_lock in
  *   drivers/tty/tty_io.c:tty_open()
@@ -1553,9 +1563,8 @@ static void uart_dtr_rts(struct tty_port
  */
 static int uart_open(struct tty_struct *tty, struct file *filp)
 {
-	struct uart_driver *drv = (struct uart_driver *)tty->driver->driver_state;
 	int retval, line = tty->index;
-	struct uart_state *state = drv->state + line;
+	struct uart_state *state = tty->driver_data;
 	struct tty_port *port = &state->port;
 
 	pr_debug("uart_open(%d) called\n", line);
@@ -1583,7 +1592,6 @@ static int uart_open(struct tty_struct *
 	 * uart_close() will decrement the driver module use count.
 	 * Any failures from here onwards should not touch the count.
 	 */
-	tty->driver_data = state;
 	state->uart_port->state = state;
 	state->port.low_latency =
 		(state->uart_port->flags & UPF_LOW_LATENCY) ? 1 : 0;
@@ -2265,6 +2273,7 @@ static void uart_poll_put_char(struct tt
 #endif
 
 static const struct tty_operations uart_ops = {
+	.install	= uart_install,
 	.open		= uart_open,
 	.close		= uart_close,
 	.write		= uart_write,

