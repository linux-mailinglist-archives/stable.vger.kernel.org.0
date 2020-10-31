Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA7E2A162B
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgJaLmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgJaLmh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D34C20739;
        Sat, 31 Oct 2020 11:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144557;
        bh=jIHPrIt3PDmeivFwBtgkZ3njTlUGFDZiU2DvIsHM8QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxsHLNGPdeBF6q9Zj0aTPiJzpRFLAPsu1CpUz9VHhPN6Xt9yN4q2OGr+lhqufBxiB
         7XLnOIpZPZvXoW9K3iVYB9t/y/oJ1MuWW4xgEZtaaCU+IiTSOUbxqWn/EzT8WisLk0
         2e8wZVg9KyUEP5v5de1iLu/AdAe5pXwEQTTAjmNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.8 64/70] serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt
Date:   Sat, 31 Oct 2020 12:36:36 +0100
Message-Id: <20201031113502.549232987@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 534cf755d9df99e214ddbe26b91cd4d81d2603e2 upstream.

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
 drivers/tty/serial/amba-pl011.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -308,8 +308,9 @@ static void pl011_write(unsigned int val
  */
 static int pl011_fifo_to_tty(struct uart_amba_port *uap)
 {
-	u16 status;
 	unsigned int ch, flag, fifotaken;
+	int sysrq;
+	u16 status;
 
 	for (fifotaken = 0; fifotaken != 256; fifotaken++) {
 		status = pl011_read(uap, REG_FR);
@@ -344,10 +345,12 @@ static int pl011_fifo_to_tty(struct uart
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


