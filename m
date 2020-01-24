Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70A61481B0
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390923AbgAXLWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:32774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387407AbgAXLWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:01 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25022077C;
        Fri, 24 Jan 2020 11:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864920;
        bh=1CALuaOOM/VwzPqkDA6OmFCVVQCzwi3w2moNt9t3L2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWp2SxA/0d7SNgT/+cmor31lJWF9HjL2v3VP5iqPMSvuUAFkX6xoS3ii5X6bQ/TNl
         QfObpVovaOJ5UmjK1QYah8Z3kvayNpCSWpp5//Inq057Xejb6gaLwdb8ZS94Ch7McS
         n++A6M9Lfjc561KkNHQ3mfh4PdtPNEMYBFO4Vx/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 388/639] serial: stm32: fix word length configuration
Date:   Fri, 24 Jan 2020 10:29:18 +0100
Message-Id: <20200124093135.559514503@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e8d7a7bb4339e..e8321850938af 100644
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
index 6f294e280ea30..a70aa5006ab97 100644
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



