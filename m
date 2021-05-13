Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56FF37FA4B
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhEMPKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234101AbhEMPKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE33613DF;
        Thu, 13 May 2021 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620918552;
        bh=pMpyBje3X0pIjcF6RmOs1vlQRFxCUirhK6MSR80pCFU=;
        h=Subject:To:From:Date:From;
        b=hE6o5Q0N+UDQ//TxP7S4lQqgUDZsX8R9gcJxaQnUPd0/EnFSjHFgYrj2RSuxYPCoT
         4+6BrORSYr4EU4rjvBeHY377x8AQX8bjuzLsIo9xxKJS6hcHEzCoJhZp1T9TXq1VPH
         Yk8MqLx3U9QC2coAO2yxnZf0/XY0PwDKUl4SAIKo=
Subject: patch "serial: sh-sci: Fix off-by-one error in FIFO threshold register" added to tty-linus
To:     geert+renesas@glider.be, gregkh@linuxfoundation.org,
        linh.phung.jy@renesas.com, stable@vger.kernel.org,
        uli+renesas@fpond.eu, wsa+renesas@sang-engineering.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:09:00 +0200
Message-ID: <1620918540155205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sh-sci: Fix off-by-one error in FIFO threshold register

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2ea2e019c190ee3973ef7bcaf829d8762e56e635 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Mon, 10 May 2021 14:07:55 +0200
Subject: serial: sh-sci: Fix off-by-one error in FIFO threshold register
 setting

The Receive FIFO Data Count Trigger field (RTRG[6:0]) in the Receive
FIFO Data Count Trigger Register (HSRTRGR) of HSCIF can only hold values
ranging from 0-127.  As the FIFO size is equal to 128 on HSCIF, the user
can write an out-of-range value, touching reserved bits.

Fix this by limiting the trigger value to the FIFO size minus one.
Reverse the order of the checks, to avoid rx_trig becoming zero if the
FIFO size is one.

Note that this change has no impact on other SCIF variants, as their
maximum supported trigger value is lower than the FIFO size anyway, and
the code below takes care of enforcing these limits.

Fixes: a380ed461f66d1b8 ("serial: sh-sci: implement FIFO threshold register setting")
Reported-by: Linh Phung <linh.phung.jy@renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5eff320aef92ffb33d00e57979fd3603bbb4a70f.1620648218.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index ef37fdf37612..4baf1316ea72 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1023,10 +1023,10 @@ static int scif_set_rtrg(struct uart_port *port, int rx_trig)
 {
 	unsigned int bits;
 
+	if (rx_trig >= port->fifosize)
+		rx_trig = port->fifosize - 1;
 	if (rx_trig < 1)
 		rx_trig = 1;
-	if (rx_trig >= port->fifosize)
-		rx_trig = port->fifosize;
 
 	/* HSCIF can be set to an arbitrary level. */
 	if (sci_getreg(port, HSRTRGR)->size) {
-- 
2.31.1


