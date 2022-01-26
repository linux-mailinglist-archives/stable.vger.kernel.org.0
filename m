Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535D949CB61
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbiAZNxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiAZNxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:53:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A41C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:53:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28796B81E1A
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2C2C340E3;
        Wed, 26 Jan 2022 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643205182;
        bh=0Lci/EM572fMibrMBAjCKzj8PBIQsy6sTUQYqeJU3bM=;
        h=Subject:To:From:Date:From;
        b=cekUuamZx5BexVKNP0Eq9bQaec4RhpMtuAc8GXTNakjXyh8rZ+VcouKVt8E/R/9E4
         0lYgbwdGzxobc6YNWihT5d5Ah3y1BzphMgmXoRdmd6AFoV8f44oNVO8sFIot80xBHV
         BxlmtogCvK/VJ/N6XQgkaS+eatU6W+0csxJoU3MY=
Subject: patch "serial: stm32: prevent TDR register overwrite when sending x_char" added to tty-linus
To:     valentin.caron@foss.st.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 14:52:59 +0100
Message-ID: <164320517921928@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: stm32: prevent TDR register overwrite when sending x_char

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d3d079bde07e1b7deaeb57506dc0b86010121d17 Mon Sep 17 00:00:00 2001
From: Valentin Caron <valentin.caron@foss.st.com>
Date: Tue, 11 Jan 2022 17:44:40 +0100
Subject: serial: stm32: prevent TDR register overwrite when sending x_char

When sending x_char in stm32_usart_transmit_chars(), driver can overwrite
the value of TDR register by the value of x_char. If this happens, the
previous value that was present in TDR register will not be sent through
uart.

This code checks if the previous value in TDR register is sent before
writing the x_char value into register.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20220111164441.6178-2-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 1f89ab0e49ac..c1b8828451c8 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -550,11 +550,23 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
+	u32 isr;
+	int ret;
 
 	if (port->x_char) {
 		if (stm32_usart_tx_dma_started(stm32_port) &&
 		    stm32_usart_tx_dma_enabled(stm32_port))
 			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+
+		/* Check that TDR is empty before filling FIFO */
+		ret =
+		readl_relaxed_poll_timeout_atomic(port->membase + ofs->isr,
+						  isr,
+						  (isr & USART_SR_TXE),
+						  10, 1000);
+		if (ret)
+			dev_warn(port->dev, "1 character may be erased\n");
+
 		writel_relaxed(port->x_char, port->membase + ofs->tdr);
 		port->x_char = 0;
 		port->icount.tx++;
-- 
2.35.0


