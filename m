Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECBF2D4471
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLIOea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgLIOea (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 09:34:30 -0500
Subject: patch "serial_core: Check for port state when tty is in error state" added to tty-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607524429;
        bh=4eICcyZ5OkY+x1nOVMJyzFgwCohbkPrd9oWFEjXL5tA=;
        h=To:From:Date:From;
        b=kkcwMMNOYZ0/EJgNi3yjXaAdIkKZBSZUFZJyH4FhI6hO8HC1R9EA0WyyEwXyGRTju
         JAM5+mEWYG/36rWQzxAFiK/CYB6iEcJeNbhoIPzs4p9APA41wWXh2zrImmZJqNcNtg
         P6VeMYfcvpWMu0U/m3EE1R7KHP5wsEeMhQUSINTs=
To:     aik@ozlabs.ru, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 15:34:58 +0100
Message-ID: <160752449882239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial_core: Check for port state when tty is in error state

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 2f70e49ed860020f5abae4f7015018ebc10e1f0e Mon Sep 17 00:00:00 2001
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Thu, 3 Dec 2020 16:58:34 +1100
Subject: serial_core: Check for port state when tty is in error state

At the moment opening a serial device node (such as /dev/ttyS3)
succeeds even if there is no actual serial device behind it.
Reading/writing/ioctls fail as expected because the uart port is not
initialized (the type is PORT_UNKNOWN) and the TTY_IO_ERROR error state
bit is set fot the tty.

However setting line discipline does not have these checks
8250_port.c (8250 is the default choice made by univ8250_console_init()).
As the result of PORT_UNKNOWN, uart_port::iobase is NULL which
a platform translates onto some address accessing which produces a crash
like below.

This adds tty_port_initialized() to uart_set_ldisc() to prevent the crash.

Found by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Link: https://lore.kernel.org/r/20201203055834.45838-1-aik@ozlabs.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f41cba10b86b..828f9ad1be49 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1467,6 +1467,10 @@ static void uart_set_ldisc(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport;
+	struct tty_port *port = &state->port;
+
+	if (!tty_port_initialized(port))
+		return;
 
 	mutex_lock(&state->port.mutex);
 	uport = uart_port_check(state);
-- 
2.29.2


