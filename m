Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D0F147E4A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389042AbgAXKHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:07:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389036AbgAXKHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:07:43 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2201214DB;
        Fri, 24 Jan 2020 10:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860462;
        bh=bsH3ijRqniYLrLbQj0Njg+l5UNwU8vHEuRPVfW5okbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaVMy/qBhVUudS5xHitTMZzrdIRu6jJIuTqXrPjENE9PncMgEy94EysYoe5fi/s+0
         TyTyuIypiWS3SJW7TcXA+xLwKVOQM3s1KoJcU39OKkZnIfTrXY7H2vPnkj2FeAGVC6
         qx4yW79LcPLJl0iRTZieyDr4k/gjsW2h2C2VZWbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 342/343] serial: stm32: fix clearing interrupt error flags
Date:   Fri, 24 Jan 2020 10:32:40 +0100
Message-Id: <20200124093004.818892172@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 1250ed7114a977cdc2a67a0c09d6cdda63970eb9 ]

The interrupt clear flag register is a "write 1 to clear" register.
So, only writing ones allows to clear flags:
- Replace buggy stm32_clr_bits() by a simple write to clear error flags
- Replace useless read/modify/write stm32_set_bits() routine by a
  simple write to clear TC (transfer complete) flag.

Fixes: 4f01d833fdcd ("serial: stm32: fix rx error handling")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1574323849-1909-1-git-send-email-fabrice.gasnier@st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index f8f3f8fafd9f0..1e854e1851fbb 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -132,8 +132,8 @@ static void stm32_receive_chars(struct uart_port *port, bool threaded)
 		 * cleared by the sequence [read SR - read DR].
 		 */
 		if ((sr & USART_SR_ERR_MASK) && ofs->icr != UNDEF_REG)
-			stm32_clr_bits(port, ofs->icr, USART_ICR_ORECF |
-				       USART_ICR_PECF | USART_ICR_FECF);
+			writel_relaxed(sr & USART_SR_ERR_MASK,
+				       port->membase + ofs->icr);
 
 		c = stm32_get_char(port, &sr, &stm32_port->last_res);
 		port->icount.rx++;
@@ -302,7 +302,7 @@ static void stm32_transmit_chars(struct uart_port *port)
 	if (ofs->icr == UNDEF_REG)
 		stm32_clr_bits(port, ofs->isr, USART_SR_TC);
 	else
-		stm32_set_bits(port, ofs->icr, USART_ICR_TCCF);
+		writel_relaxed(USART_ICR_TCCF, port->membase + ofs->icr);
 
 	if (stm32_port->tx_ch)
 		stm32_transmit_chars_dma(port);
-- 
2.20.1



