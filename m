Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6820C200
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 16:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgF0ORM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 10:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgF0ORM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jun 2020 10:17:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E4892184D;
        Sat, 27 Jun 2020 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593267431;
        bh=UGHP12IvD3d+6Fqmp45w7F6h7izqqhQcpwkNfqARe+s=;
        h=Subject:To:From:Date:From;
        b=J8ut/+36BQZ9Li9fH5oHDcguSAyW1gsUh/TiWdwQcMBBE/TNFcqZ3ZOdBnOUbURHA
         UWkanDpplDE1bE2FSkGmLg5pvYbpeRMo+wtiqJvH3ZOcgfomzR8VezJ64UvoA7khpS
         BhtsJ/S7A5QL8Wg1Nh7cbnRP9YuOrhM9ohopIm2A=
Subject: patch "Revert "tty: xilinx_uartps: Fix missing id assignment to the console"" added to tty-linus
To:     jan.kiszka@siemens.com, gregkh@linuxfoundation.org,
        michal.simek@xilinx.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Jun 2020 16:16:53 +0200
Message-ID: <159326741399112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "tty: xilinx_uartps: Fix missing id assignment to the console"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 76ed2e105796710cf5b8a4ba43c81eceed948b70 Mon Sep 17 00:00:00 2001
From: Jan Kiszka <jan.kiszka@siemens.com>
Date: Thu, 18 Jun 2020 10:11:40 +0200
Subject: Revert "tty: xilinx_uartps: Fix missing id assignment to the console"

This reverts commit 2ae11c46d5fdc46cb396e35911c713d271056d35.

It turned out to break the ultra96-rev1, e.g., which uses uart1 as
serial0 (and stdout-path = "serial0:115200n8").

Fixes: 2ae11c46d5fd ("tty: xilinx_uartps: Fix missing id assignment to the console")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Tested-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/f4092727-d8f5-5f91-2c9f-76643aace993@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index b9d672af8b65..672cfa075e28 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1465,7 +1465,6 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		cdns_uart_uart_driver.nr = CDNS_UART_NR_PORTS;
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 		cdns_uart_uart_driver.cons = &cdns_uart_console;
-		cdns_uart_console.index = id;
 #endif
 
 		rc = uart_register_driver(&cdns_uart_uart_driver);
-- 
2.27.0


