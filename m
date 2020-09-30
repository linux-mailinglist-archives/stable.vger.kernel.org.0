Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2712227E82A
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 14:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgI3MEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 08:04:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgI3MEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 08:04:39 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4218C2076B;
        Wed, 30 Sep 2020 12:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601467478;
        bh=GykIBSaiDmEJ3XNEf9HGHAkoXZDo5xF4J1k3EoMvwoQ=;
        h=From:To:Cc:Subject:Date:From;
        b=f99KUqvqfomYjYMNPm/3zHNXcASLOTXscOvNPPIepLguIQ9EHBo0TzXHorvKVdW8b
         QnkTrmvJoFqz2kBpm/RZr9+GXmKYNQ6aytmUsTT88cUsNDZlkW6Et5y9Q/+6ghXzHM
         YrAcx89aIlNjuUc4MshU5oVeSU+CL2El+eM9NEk8=
From:   Will Deacon <will@kernel.org>
To:     linux-serial@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH] serial: pl011: Fix lockdep splat when handling magic-sysrq interrupt
Date:   Wed, 30 Sep 2020 13:04:32 +0100
Message-Id: <20200930120432.16551-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

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
2.28.0.709.gb0816b6eb0-goog

