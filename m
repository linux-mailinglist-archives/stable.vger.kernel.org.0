Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B0C3DA70D
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 17:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbhG2PGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 11:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhG2PGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 11:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6428060E9B;
        Thu, 29 Jul 2021 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627571178;
        bh=VNf8bQ3JMPrIIBO+cy9cMqprWFNk7kool2OWGxPzdbM=;
        h=Subject:To:From:Date:From;
        b=SBOW+wYRHax0iBnj1wB9ZI4wvvY3haHCxjmQINlZmOjrLkmVjbKWGA6jQDwUULvSN
         FWGq24P84k6bWXIXPeMmi7ijvqsByHdBGUt6N5JxBDJNrXlrGcJJMfCh6qIge+lD/n
         CeyHE83CJ5KQH3eoo6ql6wpCw8pVYayMSk1OQi8g=
Subject: patch "tty: serial: fsl_lpuart: fix the wrong return value in" added to tty-linus
To:     sherry.sun@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 17:06:16 +0200
Message-ID: <162757117617939@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: fsl_lpuart: fix the wrong return value in

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 06e91df16f3e1ca1a1886968fb22d4258f3b6b6f Mon Sep 17 00:00:00 2001
From: Sherry Sun <sherry.sun@nxp.com>
Date: Thu, 29 Jul 2021 16:31:09 +0800
Subject: tty: serial: fsl_lpuart: fix the wrong return value in
 lpuart32_get_mctrl

Patch e60c2991f18b make the lpuart32_get_mctrl always return 0, actually
this will break the functions of device which use flow control such as
Bluetooth.
For lpuart32 plaform, the hardware can handle the CTS automatically.
So we should set TIOCM_CTS active. Also need to set CAR and DSR active.

Patch has been tested on lpuart32 platforms such as imx8qm and imx8ulp.

Fixes: e60c2991f18b ("serial: fsl_lpuart: remove RTSCTS handling from get_mctrl()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20210729083109.31541-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 508128ddfa01..f0e5da77ed6d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1415,7 +1415,7 @@ static unsigned int lpuart_get_mctrl(struct uart_port *port)
 
 static unsigned int lpuart32_get_mctrl(struct uart_port *port)
 {
-	unsigned int mctrl = 0;
+	unsigned int mctrl = TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
 	u32 reg;
 
 	reg = lpuart32_read(port, UARTCTRL);
-- 
2.32.0


