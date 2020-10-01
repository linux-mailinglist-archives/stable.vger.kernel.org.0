Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE4727FB7A
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 10:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgJAI3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 04:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730695AbgJAI3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 04:29:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4014C20739;
        Thu,  1 Oct 2020 08:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601540960;
        bh=N/xkmsm636QmuqqC+v0nPtWaxHvekFAeftVhRQoFymo=;
        h=Subject:To:From:Date:From;
        b=SaVTktxba6WJ+6WBhhqFgs4gQz/CQOMrAYR3EIYU/0XFM5a9FHYoBEBweJq8vNTg6
         06k21ybanYNFWhUyNqMDK2T5iw7XSu/f3yax60kHQRo4wKrc71oU5I6WkH5RVNM7RS
         KuFqlLla3vMPlcTobS0EKbitZ2fxeGFRDmwtxl7c=
Subject: patch "serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt" added to tty-next
To:     peterz@infradead.org, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, linux@armlinux.org.uk,
        stable@vger.kernel.org, will@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 01 Oct 2020 10:29:16 +0200
Message-ID: <160154095643239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 534cf755d9df99e214ddbe26b91cd4d81d2603e2 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 30 Sep 2020 13:04:32 +0100
Subject: serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt

Issuing a magic-sysrq via the PL011 causes the following lockdep splat,
which is easily reproducible under QEMU:

  | sysrq: Changing Loglevel
  | sysrq: Loglevel set to 9
  |
  | ======================================================
  | WARNING: possible circular locking dependency detected
  | 5.9.0-rc7 #1 Not tainted
  | ------------------------------------------------------
  | systemd-journal/138 is trying to acquire lock:
  | ffffab133ad950c0 (console_owner){-.-.}-{0:0}, at: console_lock_spinning_enable+0x34/0x70
  |
  | but task is already holding lock:
  | ffff0001fd47b098 (&port_lock_key){-.-.}-{2:2}, at: pl011_int+0x40/0x488
  |
  | which lock already depends on the new lock.

  [...]

  |  Possible unsafe locking scenario:
  |
  |        CPU0                    CPU1
  |        ----                    ----
  |   lock(&port_lock_key);
  |                                lock(console_owner);
  |                                lock(&port_lock_key);
  |   lock(console_owner);
  |
  |  *** DEADLOCK ***

The issue being that CPU0 takes 'port_lock' on the irq path in pl011_int()
before taking 'console_owner' on the printk() path, whereas CPU1 takes
the two locks in the opposite order on the printk() path due to setting
the "console_owner" prior to calling into into the actual console driver.

Fix this in the same way as the msm-serial driver by dropping 'port_lock'
before handling the sysrq.

Cc: <stable@vger.kernel.org> # 4.19+
Cc: Russell King <linux@armlinux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20200811101313.GA6970@willie-the-truck
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Will Deacon <will@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200930120432.16551-1-will@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 67498594d7d7..87dc3fc15694 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -308,8 +308,9 @@ static void pl011_write(unsigned int val, const struct uart_amba_port *uap,
  */
 static int pl011_fifo_to_tty(struct uart_amba_port *uap)
 {
-	u16 status;
 	unsigned int ch, flag, fifotaken;
+	int sysrq;
+	u16 status;
 
 	for (fifotaken = 0; fifotaken != 256; fifotaken++) {
 		status = pl011_read(uap, REG_FR);
@@ -344,10 +345,12 @@ static int pl011_fifo_to_tty(struct uart_amba_port *uap)
 				flag = TTY_FRAME;
 		}
 
-		if (uart_handle_sysrq_char(&uap->port, ch & 255))
-			continue;
+		spin_unlock(&uap->port.lock);
+		sysrq = uart_handle_sysrq_char(&uap->port, ch & 255);
+		spin_lock(&uap->port.lock);
 
-		uart_insert_char(&uap->port, ch, UART011_DR_OE, ch, flag);
+		if (!sysrq)
+			uart_insert_char(&uap->port, ch, UART011_DR_OE, ch, flag);
 	}
 
 	return fifotaken;
-- 
2.28.0


