Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2652D11B847
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfLKQNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbfLKPHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860E020663;
        Wed, 11 Dec 2019 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076853;
        bh=VHxlxLOLLZvPuDGUtfTeJj0Tcy+tv50pDkYuhEUowGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1up13xXqwN/yR7M74ufSQacbn+pC+GiA/eulTAstl4v/4Jc2apJVQrF0WYxcZJpqF
         g/JUWGAodJIXDbXKn3DaarDfoX7FdI6U6/FdPZiXbvyBdE8+hQv52+EENRqxx/ZHEI
         dky6baflvA+9V5b3GtZ9bvLHzazAjemKDAWIatFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>
Subject: [PATCH 5.4 16/92] serial: stm32: fix clearing interrupt error flags
Date:   Wed, 11 Dec 2019 16:05:07 +0100
Message-Id: <20191211150226.398223510@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

commit 1250ed7114a977cdc2a67a0c09d6cdda63970eb9 upstream.

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

---
 drivers/tty/serial/stm32-usart.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -240,8 +240,8 @@ static void stm32_receive_chars(struct u
 		 * cleared by the sequence [read SR - read DR].
 		 */
 		if ((sr & USART_SR_ERR_MASK) && ofs->icr != UNDEF_REG)
-			stm32_clr_bits(port, ofs->icr, USART_ICR_ORECF |
-				       USART_ICR_PECF | USART_ICR_FECF);
+			writel_relaxed(sr & USART_SR_ERR_MASK,
+				       port->membase + ofs->icr);
 
 		c = stm32_get_char(port, &sr, &stm32_port->last_res);
 		port->icount.rx++;
@@ -435,7 +435,7 @@ static void stm32_transmit_chars(struct
 	if (ofs->icr == UNDEF_REG)
 		stm32_clr_bits(port, ofs->isr, USART_SR_TC);
 	else
-		stm32_set_bits(port, ofs->icr, USART_ICR_TCCF);
+		writel_relaxed(USART_ICR_TCCF, port->membase + ofs->icr);
 
 	if (stm32_port->tx_ch)
 		stm32_transmit_chars_dma(port);


