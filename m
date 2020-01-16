Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A613F53D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbgAPRHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389209AbgAPRHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D849205F4;
        Thu, 16 Jan 2020 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194467;
        bh=6xiaWiqLBwxpR1apSPx73HdLXm/uolr0vKCvNKnnGE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h0HmP5WYDbsHDmavUfPhMDti8HPpQmMhWPyzJWxvYQHzMVx/teQgbWN+E6GrkIhxE
         nQPAXZ/vdPIwZG5RVOvrM6NHxnmFjT1IlPDcVcBsyzd2ZQYuvCWZYUsb3GZ/P+c+tA
         uPiAacRmR1EOBSONCi+MY8tMpD4Nby7gDhBho/Ek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erwan Le Ray <erwan.leray@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 373/671] serial: stm32: fix word length configuration
Date:   Thu, 16 Jan 2020 12:00:11 -0500
Message-Id: <20200116170509.12787-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erwan Le Ray <erwan.leray@st.com>

[ Upstream commit c8a9d043947b4acb19a65f7fac2bd0893e581cd5 ]

STM32 supports either:
- 8 and 9 bits word length (including parity bit) for stm32f4 compatible
  devices
- 7, 8 and 9 bits word length (including parity bit) for stm32f7 and
  stm32h7 compatible devices.

As a consequence STM32 supports the following termios configurations:
- CS7 with parity bit, and CS8 (with or without parity bit) for stm32f4
  compatible devices.
- CS6 with parity bit, CS7 and CS8 (with or without parity bit) for
  stm32f7 and stm32h7 compatible devices.

This patch is fixing word length by configuring correctly the SoC with
supported configurations.

Fixes: ada8618ff3bf ("serial: stm32: adding support for stm32f7")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 56 ++++++++++++++++++++++++++++----
 drivers/tty/serial/stm32-usart.h |  3 +-
 2 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index e8d7a7bb4339..e8321850938a 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -599,6 +599,36 @@ static void stm32_shutdown(struct uart_port *port)
 	free_irq(port->irq, port);
 }
 
+unsigned int stm32_get_databits(struct ktermios *termios)
+{
+	unsigned int bits;
+
+	tcflag_t cflag = termios->c_cflag;
+
+	switch (cflag & CSIZE) {
+	/*
+	 * CSIZE settings are not necessarily supported in hardware.
+	 * CSIZE unsupported configurations are handled here to set word length
+	 * to 8 bits word as default configuration and to print debug message.
+	 */
+	case CS5:
+		bits = 5;
+		break;
+	case CS6:
+		bits = 6;
+		break;
+	case CS7:
+		bits = 7;
+		break;
+	/* default including CS8 */
+	default:
+		bits = 8;
+		break;
+	}
+
+	return bits;
+}
+
 static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 			    struct ktermios *old)
 {
@@ -606,7 +636,7 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct stm32_usart_config *cfg = &stm32_port->info->cfg;
 	struct serial_rs485 *rs485conf = &port->rs485;
-	unsigned int baud;
+	unsigned int baud, bits;
 	u32 usartdiv, mantissa, fraction, oversampling;
 	tcflag_t cflag = termios->c_cflag;
 	u32 cr1, cr2, cr3;
@@ -632,16 +662,28 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (cflag & CSTOPB)
 		cr2 |= USART_CR2_STOP_2B;
 
+	bits = stm32_get_databits(termios);
+
 	if (cflag & PARENB) {
+		bits++;
 		cr1 |= USART_CR1_PCE;
-		if ((cflag & CSIZE) == CS8) {
-			if (cfg->has_7bits_data)
-				cr1 |= USART_CR1_M0;
-			else
-				cr1 |= USART_CR1_M;
-		}
 	}
 
+	/*
+	 * Word length configuration:
+	 * CS8 + parity, 9 bits word aka [M1:M0] = 0b01
+	 * CS7 or (CS6 + parity), 7 bits word aka [M1:M0] = 0b10
+	 * CS8 or (CS7 + parity), 8 bits word aka [M1:M0] = 0b00
+	 * M0 and M1 already cleared by cr1 initialization.
+	 */
+	if (bits == 9)
+		cr1 |= USART_CR1_M0;
+	else if ((bits == 7) && cfg->has_7bits_data)
+		cr1 |= USART_CR1_M1;
+	else if (bits != 8)
+		dev_dbg(port->dev, "Unsupported data bits config: %u bits\n"
+			, bits);
+
 	if (cflag & PARODD)
 		cr1 |= USART_CR1_PS;
 
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index 6f294e280ea3..a70aa5006ab9 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -151,8 +151,7 @@ struct stm32_usart_info stm32h7_info = {
 #define USART_CR1_PS		BIT(9)
 #define USART_CR1_PCE		BIT(10)
 #define USART_CR1_WAKE		BIT(11)
-#define USART_CR1_M		BIT(12)
-#define USART_CR1_M0		BIT(12)		/* F7 */
+#define USART_CR1_M0		BIT(12)		/* F7 (CR1_M for F4) */
 #define USART_CR1_MME		BIT(13)		/* F7 */
 #define USART_CR1_CMIE		BIT(14)		/* F7 */
 #define USART_CR1_OVER8		BIT(15)
-- 
2.20.1

