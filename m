Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B7158446
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 21:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgBJUce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 15:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgBJUce (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 15:32:34 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2765420863;
        Mon, 10 Feb 2020 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581366753;
        bh=rf6mbhCVFnB/15EQpaykag2VQfFGfaHnAgcmtqToc88=;
        h=Subject:To:From:Date:From;
        b=Fdt+h0vV86a2Df1EmBWsgXZMq+0hW5ut0n2bzqYxMR296C589z7Pf9SDgyay27Ofl
         JEvQMoaTP5D2+AMF2JCJqtdscTG5YX2jskfcpDAwEj5Bx9GMeo5X1qXCfiJDU9ckgX
         7jQfFNDBiozEYRySdgSwUEvto30J4ODhj/zTVxTo=
Subject: patch "tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode" added to tty-linus
To:     nicolas.ferre@microchip.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 12:32:32 -0800
Message-ID: <158136675262152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 04b5bfe3dc94e64d0590c54045815cb5183fb095 Mon Sep 17 00:00:00 2001
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Date: Mon, 10 Feb 2020 16:20:53 +0100
Subject: tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode

In atmel_shutdown() we call atmel_stop_rx() and atmel_stop_tx() functions.
Prevent the rx restart that is implemented in RS485 or ISO7816 modes when
calling atmel_stop_tx() by using the atomic information tasklet_shutdown
that is already in place for this purpose.

Fixes: 98f2082c3ac4 ("tty/serial: atmel: enforce tasklet init and termination sequences")
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210152053.8289-1-nicolas.ferre@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index c15c398c88a9..a39c87a7c2e1 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -570,7 +570,8 @@ static void atmel_stop_tx(struct uart_port *port)
 	atmel_uart_writel(port, ATMEL_US_IDR, atmel_port->tx_done_mask);
 
 	if (atmel_uart_is_half_duplex(port))
-		atmel_start_rx(port);
+		if (!atomic_read(&atmel_port->tasklet_shutdown))
+			atmel_start_rx(port);
 
 }
 
-- 
2.25.0


