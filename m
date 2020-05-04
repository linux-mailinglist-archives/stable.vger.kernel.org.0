Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31D1C408E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 18:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgEDQzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 12:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgEDQzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 12:55:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4E4D206A4;
        Mon,  4 May 2020 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588611353;
        bh=CH3GET+MG4Y29cr3xkdCRRrPdSC0SAx2z2zqZ8s3LWw=;
        h=Subject:To:From:Date:From;
        b=0VysZSaG2dZTwIPVSX+IXON0A9f+iEf81A0ijKr0YPvQTHr5njvw5KPcVPAj7HNsp
         /W76Gz2ofG3TiuY6W5bUqivXHxATIHdq0YJmdaZ6VINSZPrfEMbOAS0Tg2cm1D2qaR
         Qaaiv4/c9A6D3Gg1VqJXYusHRSQodVuvCaPFMetc=
Subject: patch "tty: xilinx_uartps: Fix missing id assignment to the console" added to tty-linus
To:     shubhrajyoti.datta@xilinx.com, gregkh@linuxfoundation.org,
        michal.simek@xilinx.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 18:55:51 +0200
Message-ID: <158861135111318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: xilinx_uartps: Fix missing id assignment to the console

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2ae11c46d5fdc46cb396e35911c713d271056d35 Mon Sep 17 00:00:00 2001
From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Date: Mon, 4 May 2020 16:27:28 +0200
Subject: tty: xilinx_uartps: Fix missing id assignment to the console

When serial console has been assigned to ttyPS1 (which is serial1 alias)
console index is not updated property and pointing to index -1 (statically
initialized) which ends up in situation where nothing has been printed on
the port.

The commit 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console
and driver structures"") didn't contain this line which was removed by
accident.

Fixes: 18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index ac137b6a1dc1..35e9e8faf8de 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1459,6 +1459,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 		cdns_uart_uart_driver.cons = &cdns_uart_console;
+		cdns_uart_console.index = id;
 #endif
 
 		rc = uart_register_driver(&cdns_uart_uart_driver);
-- 
2.26.2


