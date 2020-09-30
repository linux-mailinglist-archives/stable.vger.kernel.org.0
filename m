Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9C227E88F
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbgI3M36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 08:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3M36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Sep 2020 08:29:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D041A2071E;
        Wed, 30 Sep 2020 12:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601468996;
        bh=c2MCpeZ/UJtK+5c4lA61wvr8I+CATu4YU3RN6UmjPxg=;
        h=Subject:To:From:Date:From;
        b=2I6vwk3HgLWYuNwfNJQ29GgUgGNTyp2y48ncHFogO4a5r8bICFA5qUr/HmT6DPvAE
         RKQfrS49t2cyRrc6azF7SUP3Io29pU/mNu32p8++85cnlkBmZ2APmXnNATs1v0uJb6
         jWX4PKa47xb4FHHd3CE4t95bXYnrtVB7SpBNLbYg=
Subject: patch "tty: serial: fsl_lpuart: fix lpuart32_poll_get_char" added to tty-testing
To:     peng.fan@nxp.com, fugang.duan@nxp.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Sep 2020 14:29:52 +0200
Message-ID: <1601468992136208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 29788ab1d2bf26c130de8f44f9553ee78a27e8d5 Mon Sep 17 00:00:00 2001
From: Peng Fan <peng.fan@nxp.com>
Date: Tue, 29 Sep 2020 17:55:09 +0800
Subject: tty: serial: fsl_lpuart: fix lpuart32_poll_get_char

The watermark is set to 1, so we need to input two chars to trigger RDRF
using the original logic. With the new logic, we could always get the
char when there is data in FIFO.

Suggested-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20200929095509.21680-1-peng.fan@nxp.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 645bbb24b433..590c901a1fc5 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -680,7 +680,7 @@ static void lpuart32_poll_put_char(struct uart_port *port, unsigned char c)
 
 static int lpuart32_poll_get_char(struct uart_port *port)
 {
-	if (!(lpuart32_read(port, UARTSTAT) & UARTSTAT_RDRF))
+	if (!(lpuart32_read(port, UARTWATER) >> UARTWATER_RXCNT_OFF))
 		return NO_POLL_CHAR;
 
 	return lpuart32_read(port, UARTDATA);
-- 
2.28.0


