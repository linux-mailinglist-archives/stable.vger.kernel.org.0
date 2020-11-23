Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3AC2C076A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732512AbgKWMkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732517AbgKWMkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF0CE20732;
        Mon, 23 Nov 2020 12:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135236;
        bh=AmD7T3beoWo/DzHnBurLwTXjZxHiMjYyblxw0C8IgR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vvyyP28FpgIEZvrYCoeijTj/cKR6wJa9cFqblAW4M9oxcX3dhH7z3qfmCBMjtSgpj
         lqY+QkqhW7cpL+uLf4PK/1h7aUXECkjh/Z7XZmn/NG/QCDyUV/F15QSIAVHlWF2PR2
         L5tHHLd889Cn/UzE6S/E4b/M2p+9VNmGoyX9Kf8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Fugang Duan <fugang.duan@nxp.com>
Subject: [PATCH 5.4 124/158] tty: serial: imx: keep console clocks always on
Date:   Mon, 23 Nov 2020 13:22:32 +0100
Message-Id: <20201123121825.914709199@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
@@ -1942,16 +1942,6 @@ imx_uart_console_write(struct console *c
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
@@ -1987,9 +1977,6 @@ imx_uart_console_write(struct console *c
 
 	if (locked)
 		spin_unlock_irqrestore(&sport->port.lock, flags);
-
-	clk_disable(sport->clk_ipg);
-	clk_disable(sport->clk_per);
 }
 
 /*
@@ -2090,15 +2077,14 @@ imx_uart_console_setup(struct console *c
 
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


