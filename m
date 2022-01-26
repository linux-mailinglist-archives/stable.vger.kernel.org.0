Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A906049CB62
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 14:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbiAZNxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 08:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiAZNxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 08:53:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD976C06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 05:53:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B469B81E1C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 13:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AC0C340E3;
        Wed, 26 Jan 2022 13:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643205190;
        bh=nHISZH64zKYND//NEAL8vb6kkpyGNFsFipv5D0154to=;
        h=Subject:To:From:Date:From;
        b=XSqEoLVfnGQGnNubWRyubSc68OpuX9CQTuVFSAjD4eQPTjHHSFXH2XCDadgyAWPEN
         WsIlHfTIPjgadjLKanXEUE82MQmY+wfGA5Zf+3EY3FfcIzwkMYQh8GYLnE1mUcYP00
         lfRi1+iLUzIuPeunvsTbK0MSzjL6pfLNhE3PVHOA=
Subject: patch "serial: stm32: fix software flow control transfer" added to tty-linus
To:     valentin.caron@foss.st.com, erwan.leray@foss.st.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 14:52:59 +0100
Message-ID: <164320517971239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: stm32: fix software flow control transfer

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 037b91ec7729524107982e36ec4b40f9b174f7a2 Mon Sep 17 00:00:00 2001
From: Valentin Caron <valentin.caron@foss.st.com>
Date: Tue, 11 Jan 2022 17:44:41 +0100
Subject: serial: stm32: fix software flow control transfer

x_char is ignored by stm32_usart_start_tx() when xmit buffer is empty.

Fix start_tx condition to allow x_char to be sent.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Erwan Le Ray <erwan.leray@foss.st.com>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20220111164441.6178-3-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index c1b8828451c8..9570002d07e7 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -742,7 +742,7 @@ static void stm32_usart_start_tx(struct uart_port *port)
 	struct serial_rs485 *rs485conf = &port->rs485;
 	struct circ_buf *xmit = &port->state->xmit;
 
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {
-- 
2.35.0


