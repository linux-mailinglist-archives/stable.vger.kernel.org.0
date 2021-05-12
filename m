Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC3737C4A2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhELPcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235538AbhELP21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9D1161C1F;
        Wed, 12 May 2021 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832420;
        bh=Z7UpVIIgP+lykhV2bZrezUVTgmrS023NBScq3t5tHfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrRKwmF6mmB0oYJ8uJWe63s2xsDi+juMoirESf+r1Ag0BydN3YKRhZT5lH+f6KX8l
         OywzrrL+t646ebsstj/8RkFm0tiiADDkgLisIqdkg3ugJyp60u58GZiWMgIgo1Z1Xk
         Vp+Q3eDhealaVu9nKFvAtthD07h+i/EEM5WqPoNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dario Binacchi <dariobin@libero.it>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/530] serial: omap: dont disable rs485 if rts gpio is missing
Date:   Wed, 12 May 2021 16:46:23 +0200
Message-Id: <20210512144828.780568131@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

[ Upstream commit 45f6b6db53c80787b79044629b062dfcf2da71ec ]

There are rs485 transceivers (e.g. MAX13487E/MAX13488E) which
automatically disable or enable the driver and receiver to keep the bus
in the correct state.
In these cases we don't need a GPIO for flow control.

Fixes: 4a0ac0f55b18 ("OMAP: add RS485 support")
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Link: https://lore.kernel.org/r/20210415210945.25863-1-dariobin@libero.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/omap-serial.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 76b94d0ff586..1583e93b2202 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -302,7 +302,8 @@ static void serial_omap_stop_tx(struct uart_port *port)
 			serial_out(up, UART_OMAP_SCR, up->scr);
 			res = (port->rs485.flags & SER_RS485_RTS_AFTER_SEND) ?
 				1 : 0;
-			if (gpiod_get_value(up->rts_gpiod) != res) {
+			if (up->rts_gpiod &&
+			    gpiod_get_value(up->rts_gpiod) != res) {
 				if (port->rs485.delay_rts_after_send > 0)
 					mdelay(
 					port->rs485.delay_rts_after_send);
@@ -411,7 +412,7 @@ static void serial_omap_start_tx(struct uart_port *port)
 
 		/* if rts not already enabled */
 		res = (port->rs485.flags & SER_RS485_RTS_ON_SEND) ? 1 : 0;
-		if (gpiod_get_value(up->rts_gpiod) != res) {
+		if (up->rts_gpiod && gpiod_get_value(up->rts_gpiod) != res) {
 			gpiod_set_value(up->rts_gpiod, res);
 			if (port->rs485.delay_rts_before_send > 0)
 				mdelay(port->rs485.delay_rts_before_send);
@@ -1407,18 +1408,13 @@ serial_omap_config_rs485(struct uart_port *port, struct serial_rs485 *rs485)
 	/* store new config */
 	port->rs485 = *rs485;
 
-	/*
-	 * Just as a precaution, only allow rs485
-	 * to be enabled if the gpio pin is valid
-	 */
 	if (up->rts_gpiod) {
 		/* enable / disable rts */
 		val = (port->rs485.flags & SER_RS485_ENABLED) ?
 			SER_RS485_RTS_AFTER_SEND : SER_RS485_RTS_ON_SEND;
 		val = (port->rs485.flags & val) ? 1 : 0;
 		gpiod_set_value(up->rts_gpiod, val);
-	} else
-		port->rs485.flags &= ~SER_RS485_ENABLED;
+	}
 
 	/* Enable interrupts */
 	up->ier = mode;
-- 
2.30.2



