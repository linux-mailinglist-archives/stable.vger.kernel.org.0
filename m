Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351DA469E3F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbhLFPhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388621AbhLFPeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:34:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A4BC09B12B;
        Mon,  6 Dec 2021 07:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9046861345;
        Mon,  6 Dec 2021 15:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F686C341C8;
        Mon,  6 Dec 2021 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804013;
        bh=sXgJzHs7JzEf09w3X3JOxNwVMwTEphr/alkghYIIFRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7i9FEGtcOlJuScfDXC7IELHGkk+gsva77qR2Qy+mF4zo7dPW2RA/fe1aKDS5HYmn
         PKmZ1k6e6teUEpvmE8IH6cP/yWy4ND/WR6FS7k/uQ29hi9V5ATA7rMkwCoDH51kiRP
         FZP2mv9Iq/c4EsHZoXd1myOXKmRUE+1A2HYkZdqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Zeng <chao.zeng@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.10 126/130] serial: 8250: Fix RTS modem control while in rs485 mode
Date:   Mon,  6 Dec 2021 15:57:23 +0100
Message-Id: <20211206145604.015861899@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit f85e04503f369b3f2be28c83fc48b74e19936ebc upstream.

Commit f45709df7731 ("serial: 8250: Don't touch RTS modem control while
in rs485 mode") sought to prevent user space from interfering with rs485
communication by ignoring a TIOCMSET ioctl() which changes RTS polarity.

It did so in serial8250_do_set_mctrl(), which turns out to be too deep
in the call stack:  When a uart_port is opened, RTS polarity is set by
the rs485-aware function uart_port_dtr_rts().  It calls down to
serial8250_do_set_mctrl() and that particular RTS polarity change should
*not* be ignored.

The user-visible result is that on 8250_omap ports which use rs485 with
inverse polarity (RTS bit in MCR register is 1 to receive, 0 to send),
a newly opened port initially sets up RTS for sending instead of
receiving.  That's because omap_8250_startup() sets the cached value
up->mcr to 0 and omap_8250_restore_regs() subsequently writes it to the
MCR register.  Due to the commit, serial8250_do_set_mctrl() preserves
that incorrect register value:

do_sys_openat2
  do_filp_open
    path_openat
      vfs_open
        do_dentry_open
	  chrdev_open
	    tty_open
	      uart_open
	        tty_port_open
		  uart_port_activate
		    uart_startup
		      uart_port_startup
		        serial8250_startup
			  omap_8250_startup # up->mcr = 0
			uart_change_speed
			  serial8250_set_termios
			    omap_8250_set_termios
			      omap_8250_restore_regs
			        serial8250_out_MCR # up->mcr written
		  tty_port_block_til_ready
		    uart_dtr_rts
		      uart_port_dtr_rts
		        serial8250_set_mctrl
			  omap8250_set_mctrl
			    serial8250_do_set_mctrl # mcr[1] = 1 ignored

Fix by intercepting RTS changes from user space in uart_tiocmset()
instead.

Link: https://lore.kernel.org/linux-serial/20211027111644.1996921-1-baocheng.su@siemens.com/
Fixes: f45709df7731 ("serial: 8250: Don't touch RTS modem control while in rs485 mode")
Cc: Chao Zeng <chao.zeng@siemens.com>
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Su Bao Cheng <baocheng.su@siemens.com>
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Su Bao Cheng <baocheng.su@siemens.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/21170e622a1aaf842a50b32146008b5374b3dd1d.1637596432.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    7 -------
 drivers/tty/serial/serial_core.c    |    5 +++++
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2029,13 +2029,6 @@ void serial8250_do_set_mctrl(struct uart
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned char mcr;
 
-	if (port->rs485.flags & SER_RS485_ENABLED) {
-		if (serial8250_in_MCR(up) & UART_MCR_RTS)
-			mctrl |= TIOCM_RTS;
-		else
-			mctrl &= ~TIOCM_RTS;
-	}
-
 	mcr = serial8250_TIOCM_to_MCR(mctrl);
 
 	mcr = (mcr & up->mcr_mask) | up->mcr_force | up->mcr;
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1102,6 +1102,11 @@ uart_tiocmset(struct tty_struct *tty, un
 		goto out;
 
 	if (!tty_io_error(tty)) {
+		if (uport->rs485.flags & SER_RS485_ENABLED) {
+			set &= ~TIOCM_RTS;
+			clear &= ~TIOCM_RTS;
+		}
+
 		uart_update_mctrl(uport, set, clear);
 		ret = 0;
 	}


