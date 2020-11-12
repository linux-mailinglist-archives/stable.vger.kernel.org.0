Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AEC2B014B
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 09:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgKLIjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 03:39:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKLIji (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 03:39:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26ECD221FF;
        Thu, 12 Nov 2020 08:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605170377;
        bh=8taqSHxWFbByQnJia3D5L0Jw6PY/pFgoThAEcX64R7g=;
        h=Subject:To:From:Date:From;
        b=c6Izn5B2WeprUvRimR/SXGZu0tZdebvQ4AL7UI+7ukt+WBLRDwpItcWb/4yOj3vbn
         8sPUZ/qFsmDn4Otj6jVPwY31wSDkuKzKyiUi1OhIpvrzcO+pMOAPbXxHpe+PzaZKi7
         ql2BwMbs4M+6mdlA5i4aoF8EA7K1FuK4eOkOwK54=
Subject: patch "tty: serial: imx: keep console clocks always on" added to tty-linus
To:     fugang.duan@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, u.kleine-koenig@pengutronix.de
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Nov 2020 09:40:29 +0100
Message-ID: <160517042921119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: imx: keep console clocks always on

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e67c139c488e84e7eae6c333231e791f0e89b3fb Mon Sep 17 00:00:00 2001
From: Fugang Duan <fugang.duan@nxp.com>
Date: Wed, 11 Nov 2020 10:51:36 +0800
Subject: tty: serial: imx: keep console clocks always on
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For below code, there has chance to cause deadlock in SMP system:
Thread 1:
clk_enable_lock();
pr_info("debug message");
clk_enable_unlock();

Thread 2:
imx_uart_console_write()
	clk_enable()
		clk_enable_lock();

Thread 1:
Acuired clk enable_lock -> printk -> console_trylock_spinning
Thread 2:
console_unlock() -> imx_uart_console_write -> clk_disable -> Acquite clk enable_lock

So the patch is to keep console port clocks always on like
other console drivers.

Fixes: 1cf93e0d5488 ("serial: imx: remove the uart_console() check")
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Link: https://lore.kernel.org/r/20201111025136.29818-1-fugang.duan@nxp.com
Cc: stable <stable@vger.kernel.org>
[fix up build warning - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 3c53a3c89959..cacf7266a262 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2008,16 +2008,6 @@ imx_uart_console_write(struct console *co, const char *s, unsigned int count)
 	unsigned int ucr1;
 	unsigned long flags = 0;
 	int locked = 1;
-	int retval;
-
-	retval = clk_enable(sport->clk_per);
-	if (retval)
-		return;
-	retval = clk_enable(sport->clk_ipg);
-	if (retval) {
-		clk_disable(sport->clk_per);
-		return;
-	}
 
 	if (sport->port.sysrq)
 		locked = 0;
@@ -2053,9 +2043,6 @@ imx_uart_console_write(struct console *co, const char *s, unsigned int count)
 
 	if (locked)
 		spin_unlock_irqrestore(&sport->port.lock, flags);
-
-	clk_disable(sport->clk_ipg);
-	clk_disable(sport->clk_per);
 }
 
 /*
@@ -2156,15 +2143,14 @@ imx_uart_console_setup(struct console *co, char *options)
 
 	retval = uart_set_options(&sport->port, co, baud, parity, bits, flow);
 
-	clk_disable(sport->clk_ipg);
 	if (retval) {
-		clk_unprepare(sport->clk_ipg);
+		clk_disable_unprepare(sport->clk_ipg);
 		goto error_console;
 	}
 
-	retval = clk_prepare(sport->clk_per);
+	retval = clk_prepare_enable(sport->clk_per);
 	if (retval)
-		clk_unprepare(sport->clk_ipg);
+		clk_disable_unprepare(sport->clk_ipg);
 
 error_console:
 	return retval;
-- 
2.29.2


