Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F92D2C0B6F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbgKWNYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730411AbgKWMdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:33:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A0420857;
        Mon, 23 Nov 2020 12:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134822;
        bh=ZvWrrcQNEE5eUf/tjnCMpPYPD4YLRNF3vF6Auw5LeLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKGnnxQU5kuaYrdznHLHPasl35i2Tn8Mdab320YvXdhly4kSDplQBHAq9Vj61pefs
         3Taya9hd8FxE3LYZ3ycQnXkNUenF/eg8D7Gf2beyTSCK9ylg+PcQSBwE/ZkR0ZxLQt
         48hyl5wLu4MSJIW4ItCPdO1j6cvCaLPSUjqx5y74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH 4.19 72/91] tty: serial: imx: keep console clocks always on
Date:   Mon, 23 Nov 2020 13:22:32 +0100
Message-Id: <20201123121812.821192416@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

commit e67c139c488e84e7eae6c333231e791f0e89b3fb upstream.

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
 drivers/tty/serial/imx.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1915,16 +1915,6 @@ imx_uart_console_write(struct console *c
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
@@ -1960,9 +1950,6 @@ imx_uart_console_write(struct console *c
 
 	if (locked)
 		spin_unlock_irqrestore(&sport->port.lock, flags);
-
-	clk_disable(sport->clk_ipg);
-	clk_disable(sport->clk_per);
 }
 
 /*
@@ -2063,15 +2050,14 @@ imx_uart_console_setup(struct console *c
 
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


