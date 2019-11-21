Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFCA105887
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 18:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKURXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 12:23:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKURXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 12:23:34 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF812067D;
        Thu, 21 Nov 2019 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574357014;
        bh=/+vDRF+mdlQrYJLUoZNvQwglz6Hp8AVx6ALrf8Fa9VQ=;
        h=Subject:To:From:Date:From;
        b=CYaescfhloaXLil56oWLgk9QY1XdPD9bL25N2TPwPS1Q+6tcwWPiDWvdNegiMEcc3
         ka085FQhsvmCf7qVhMo4JWLC1MfW97c1Q0Fo7URNXG3Ek5bQqViqBXlR7mLI22H0Nu
         FEp4FVp6Z6U8x7v8Zk63Jo7rppI9K0IGjCV+sWFU=
Subject: patch "serial: stm32: fix clearing interrupt error flags" added to tty-testing
To:     fabrice.gasnier@st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Nov 2019 18:23:30 +0100
Message-ID: <1574357010225218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: stm32: fix clearing interrupt error flags

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 1250ed7114a977cdc2a67a0c09d6cdda63970eb9 Mon Sep 17 00:00:00 2001
From: Fabrice Gasnier <fabrice.gasnier@st.com>
Date: Thu, 21 Nov 2019 09:10:49 +0100
Subject: serial: stm32: fix clearing interrupt error flags

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
 drivers/tty/serial/stm32-usart.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index df90747ee3a8..2f72514d63ed 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -240,8 +240,8 @@ static void stm32_receive_chars(struct uart_port *port, bool threaded)
 		 * cleared by the sequence [read SR - read DR].
 		 */
 		if ((sr & USART_SR_ERR_MASK) && ofs->icr != UNDEF_REG)
-			stm32_clr_bits(port, ofs->icr, USART_ICR_ORECF |
-				       USART_ICR_PECF | USART_ICR_FECF);
+			writel_relaxed(sr & USART_SR_ERR_MASK,
+				       port->membase + ofs->icr);
 
 		c = stm32_get_char(port, &sr, &stm32_port->last_res);
 		port->icount.rx++;
@@ -435,7 +435,7 @@ static void stm32_transmit_chars(struct uart_port *port)
 	if (ofs->icr == UNDEF_REG)
 		stm32_clr_bits(port, ofs->isr, USART_SR_TC);
 	else
-		stm32_set_bits(port, ofs->icr, USART_ICR_TCCF);
+		writel_relaxed(USART_ICR_TCCF, port->membase + ofs->icr);
 
 	if (stm32_port->tx_ch)
 		stm32_transmit_chars_dma(port);
-- 
2.24.0


