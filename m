Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402483C4B12
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbhGLGza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239946AbhGLGxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 882B9610CA;
        Mon, 12 Jul 2021 06:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072623;
        bh=ZRMDoZWoA2P8hiekASzkXbUfXYZp2iQhJ1y5qwSSpA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVf0KwYEnSlIk0K54lnrJeHnuMSqYvg8gGING/jzZbSIrZFYmGlh4lQ/vlBYEo6ug
         40n8pr+riJzKWMzsu2juVfL+2xF3iU6XcuveVhfITvkjZ9lXW36AOXaZRjyySqaKQj
         q8VahtZXnIdQajrP0dar5EAzIbLjO2PXo0ae7o54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 558/593] serial: mvebu-uart: do not allow changing baudrate when uartclk is not available
Date:   Mon, 12 Jul 2021 08:11:58 +0200
Message-Id: <20210712060955.963196244@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit ecd6b010d81f97b06b2f64d2d4f50ebf5acddaa9 ]

Testing mvuart->clk for non-error is not enough as mvuart->clk may contain
valid clk pointer but when clk_prepare_enable(mvuart->clk) failed then
port->uartclk is zero.

When mvuart->clk is not available then port->uartclk is zero too.

Parent clock rate port->uartclk is needed to calculate UART clock divisor
and without it is not possible to change baudrate.

So fix test condition when it is possible to change baudrate.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 68a0db1d7da2 ("serial: mvebu-uart: add function to change baudrate")
Link: https://lore.kernel.org/r/20210624224909.6350-3-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/mvebu-uart.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 908a4ac6b5a7..9638ae6aae79 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -445,12 +445,11 @@ static void mvebu_uart_shutdown(struct uart_port *port)
 
 static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 {
-	struct mvebu_uart *mvuart = to_mvuart(port);
 	unsigned int d_divisor, m_divisor;
 	u32 brdv, osamp;
 
-	if (IS_ERR(mvuart->clk))
-		return -PTR_ERR(mvuart->clk);
+	if (!port->uartclk)
+		return -EOPNOTSUPP;
 
 	/*
 	 * The baudrate is derived from the UART clock thanks to two divisors:
-- 
2.30.2



