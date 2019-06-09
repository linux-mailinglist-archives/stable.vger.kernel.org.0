Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A883AA80
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732320AbfFIRTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbfFIQtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 459EB207E0;
        Sun,  9 Jun 2019 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098959;
        bh=bz6CjJyh4ku0BOYUzUShPSa6C47/lV2rd13xo8166ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kI/rjFd/7OOh4kFBHc91hKQ/MzQwChSqWcv7lvEWhtJ0b9q+QwBFTa9IErEDRXd6y
         c04YYV4L9AnhN5mlqcdDPPw9MQqvbJn+VYjDdU+f21ugc6hWl/C820ignzlsRsrlQu
         8O8CDy2DfAzTVy4bY32iRSsibHs6V8cU1IjzCSCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Li RongQing <lirongqing@baidu.com>,
        Wang Li <wangli39@baidu.com>, Zhang Yu <zhangyu31@baidu.com>
Subject: [PATCH 4.19 51/51] TTY: serial_core, add ->install
Date:   Sun,  9 Jun 2019 18:42:32 +0200
Message-Id: <20190609164131.059889890@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -130,9 +130,6 @@ static void uart_start(struct tty_struct
 	struct uart_port *port;
 	unsigned long flags;
 
-	if (!state)
-		return;
-
 	port = uart_port_lock(state, flags);
 	__uart_start(tty);
 	uart_port_unlock(port, flags);
@@ -730,9 +727,6 @@ static void uart_unthrottle(struct tty_s
 	upstat_t mask = UPSTAT_SYNC_FIFO;
 	struct uart_port *port;
 
-	if (!state)
-		return;
-
 	port = uart_port_ref(state);
 	if (!port)
 		return;
@@ -1708,6 +1702,16 @@ static void uart_dtr_rts(struct tty_port
 	uart_port_deref(uport);
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
@@ -1720,11 +1724,8 @@ static void uart_dtr_rts(struct tty_port
  */
 static int uart_open(struct tty_struct *tty, struct file *filp)
 {
-	struct uart_driver *drv = tty->driver->driver_state;
-	int retval, line = tty->index;
-	struct uart_state *state = drv->state + line;
-
-	tty->driver_data = state;
+	struct uart_state *state = tty->driver_data;
+	int retval;
 
 	retval = tty_port_open(&state->port, tty, filp);
 	if (retval > 0)
@@ -2409,6 +2410,7 @@ static void uart_poll_put_char(struct tt
 #endif
 
 static const struct tty_operations uart_ops = {
+	.install	= uart_install,
 	.open		= uart_open,
 	.close		= uart_close,
 	.write		= uart_write,


