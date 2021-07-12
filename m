Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5103C4710
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhGLGbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhGLGaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A8860234;
        Mon, 12 Jul 2021 06:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071249;
        bh=Bhh2DQEhh1uBHyp1UCy1f5cTK7hXioqPzWhR7WtO+QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCUUiVnAdUlZjm1uSwDIpelpaaERyBHOeeTGApe2d5D6kJtivf/jDlrKENNa4Zqa2
         jasvm6CT28Dx9bwawljx/vxtiouJCmdTtlCr0S8Npcfo6xgKDbjeYSynhZYCI5Kyxe
         VkEz3lWaFUKc9r36egyv5wu6Zwik+woGZgp/ZfUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 337/348] serial: mvebu-uart: correctly calculate minimal possible baudrate
Date:   Mon, 12 Jul 2021 08:12:01 +0200
Message-Id: <20210712060748.831903340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit deeaf963569a0d9d1b08babb771f61bb501a5704 ]

For default (x16) scheme which is currently used by mvebu-uart.c driver,
maximal divisor of UART base clock is 1023*16. Therefore there is limit for
minimal supported baudrate. This change calculate it correctly and prevents
setting invalid divisor 0 into hardware registers.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 68a0db1d7da2 ("serial: mvebu-uart: add function to change baudrate")
Link: https://lore.kernel.org/r/20210624224909.6350-4-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/mvebu-uart.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 57929b54e46a..51b4d8d1dcac 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -481,7 +481,7 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 				   struct ktermios *old)
 {
 	unsigned long flags;
-	unsigned int baud;
+	unsigned int baud, min_baud, max_baud;
 
 	spin_lock_irqsave(&port->lock, flags);
 
@@ -500,16 +500,21 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 		port->ignore_status_mask |= STAT_RX_RDY(port) | STAT_BRK_ERR;
 
 	/*
+	 * Maximal divisor is 1023 * 16 when using default (x16) scheme.
 	 * Maximum achievable frequency with simple baudrate divisor is 230400.
 	 * Since the error per bit frame would be of more than 15%, achieving
 	 * higher frequencies would require to implement the fractional divisor
 	 * feature.
 	 */
-	baud = uart_get_baud_rate(port, termios, old, 0, 230400);
+	min_baud = DIV_ROUND_UP(port->uartclk, 1023 * 16);
+	max_baud = 230400;
+
+	baud = uart_get_baud_rate(port, termios, old, min_baud, max_baud);
 	if (mvebu_uart_baud_rate_set(port, baud)) {
 		/* No clock available, baudrate cannot be changed */
 		if (old)
-			baud = uart_get_baud_rate(port, old, NULL, 0, 230400);
+			baud = uart_get_baud_rate(port, old, NULL,
+						  min_baud, max_baud);
 	} else {
 		tty_termios_encode_baud_rate(termios, baud, baud);
 		uart_update_timeout(port, termios->c_cflag, baud);
-- 
2.30.2



