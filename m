Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52F13F533
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbgAPSyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389222AbgAPRHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5351D2081E;
        Thu, 16 Jan 2020 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194470;
        bh=mtdpDahWP1aF7hD96FX6wKWfhTco2TsYwragG4D/HX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2APAaZPamFyTVrEgLnf6c5IjnIjWYPN3JSyLhvldywN6baEjfIJ+TvxuSVQhnATCd
         IeJF8lCxpaU8tvjRn2dfIsnuZLr4pBm8oehyWTo3AYkBYJ4t8xWBmGNCi4YxqkpYOJ
         qQs8RvY2fZZlpofd2BkzfY+4RkA0w6vRJjaEDjyU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erwan Le Ray <erwan.leray@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 375/671] serial: stm32: fix rx data length when parity enabled
Date:   Thu, 16 Jan 2020 12:00:13 -0500
Message-Id: <20200116170509.12787-112-sashal@kernel.org>
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

[ Upstream commit 6c5962f30bce147b1c83869085f3ddde3b34c9e3 ]

- Fixes a rx data error when data length < 8 bits and parity is enabled.
RDR register MSB is used for parity bit reception.
- Adds a mask to ignore MSB when data is get from RDR.

Fixes: 3489187204eb ("serial: stm32: adding dma support")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 12 ++++++++----
 drivers/tty/serial/stm32-usart.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index f6b739351dde..0a7953e5ce47 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -194,8 +194,8 @@ static int stm32_pending_rx(struct uart_port *port, u32 *sr, int *last_res,
 	return 0;
 }
 
-static unsigned long
-stm32_get_char(struct uart_port *port, u32 *sr, int *last_res)
+static unsigned long stm32_get_char(struct uart_port *port, u32 *sr,
+				    int *last_res)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
@@ -205,10 +205,13 @@ stm32_get_char(struct uart_port *port, u32 *sr, int *last_res)
 		c = stm32_port->rx_buf[RX_BUF_L - (*last_res)--];
 		if ((*last_res) == 0)
 			*last_res = RX_BUF_L;
-		return c;
 	} else {
-		return readl_relaxed(port->membase + ofs->rdr);
+		c = readl_relaxed(port->membase + ofs->rdr);
+		/* apply RDR data mask */
+		c &= stm32_port->rdr_mask;
 	}
+
+	return c;
 }
 
 static void stm32_receive_chars(struct uart_port *port, bool threaded)
@@ -679,6 +682,7 @@ static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
 		cr2 |= USART_CR2_STOP_2B;
 
 	bits = stm32_get_databits(termios);
+	stm32_port->rdr_mask = (BIT(bits) - 1);
 
 	if (cflag & PARENB) {
 		bits++;
diff --git a/drivers/tty/serial/stm32-usart.h b/drivers/tty/serial/stm32-usart.h
index 8d34802e572e..30d2433e27c3 100644
--- a/drivers/tty/serial/stm32-usart.h
+++ b/drivers/tty/serial/stm32-usart.h
@@ -254,6 +254,7 @@ struct stm32_port {
 	bool hw_flow_control;
 	bool fifoen;
 	int wakeirq;
+	int rdr_mask;		/* receive data register mask */
 };
 
 static struct stm32_port stm32_ports[STM32_MAX_PORTS];
-- 
2.20.1

