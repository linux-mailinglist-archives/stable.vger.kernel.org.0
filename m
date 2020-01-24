Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFA51481B6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390804AbgAXLWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:22:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391172AbgAXLWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABF892075D;
        Fri, 24 Jan 2020 11:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864930;
        bh=UFgbHMhDM2XKV3T2FJem1KMeOh7Pql6hpufPWFWgcDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0GZLHAT3LueQJQRdw0GZXkTyKl3ZC368jGhe7UhdkgyZ/vdCVWrLTwq6tUwUv3zRD
         /phvbRp62ic6ke8nVbMywrK5F97bxop9OnH4cbJpF/ufE42XWpYhGpNJFAc0tnxfXW
         4fbfDy9edV+tiD+w3P7GJBW+gm909+fUd4rn8B4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erwan Le Ray <erwan.leray@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 391/639] serial: stm32: fix transmit_chars when tx is stopped
Date:   Fri, 24 Jan 2020 10:29:21 +0100
Message-Id: <20200124093135.931147394@linuxfoundation.org>
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

[ Upstream commit b83b957c91f68e53f0dc596e129e8305761f2a32 ]

Disables the tx irq  when the transmission is ended and updates stop_tx
conditions for code cleanup.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Signed-off-by: Erwan Le Ray <erwan.leray@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 0a7953e5ce47a..2e7757d5e5d83 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -420,13 +420,8 @@ static void stm32_transmit_chars(struct uart_port *port)
 		return;
 	}
 
-	if (uart_tx_stopped(port)) {
-		stm32_stop_tx(port);
-		return;
-	}
-
-	if (uart_circ_empty(xmit)) {
-		stm32_stop_tx(port);
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
+		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 		return;
 	}
 
@@ -439,7 +434,7 @@ static void stm32_transmit_chars(struct uart_port *port)
 		uart_write_wakeup(port);
 
 	if (uart_circ_empty(xmit))
-		stm32_stop_tx(port);
+		stm32_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
 static irqreturn_t stm32_interrupt(int irq, void *ptr)
-- 
2.20.1



