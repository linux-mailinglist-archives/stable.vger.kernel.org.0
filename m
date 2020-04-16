Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7FF1AC4E2
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409685AbgDPOGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406106AbgDPOGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:06:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 701622076D;
        Thu, 16 Apr 2020 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587046000;
        bh=reCH2wLvJ1QUlkBD7kZRGX2fq8Y7c8bBJxRQ2/wZXfE=;
        h=Subject:To:From:Date:From;
        b=AEgQR22n1dnrXXT8MvZj1NX0jRqOVgGzBfGOCyf4PAYitQB0ZuXxU7ZFn/X0tdt0Y
         DSkc7e7TfZsVAte9xUGRHbLmgjivHXwlgldORHnATNTcNIKx57rRQ16XkPbFZ7yyGA
         7DT5o8RoBqz467c+BQfdb+49nd0l74iMxkQD5J0A=
Subject: patch "Revert "serial: uartps: Fix uartps_major handling"" added to tty-linus
To:     michal.simek@xilinx.com, gregkh@linuxfoundation.org,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 16:06:38 +0200
Message-ID: <15870459982441@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: uartps: Fix uartps_major handling"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2e01911b7cf7aa07a304a809eca1b11a4bd35859 Mon Sep 17 00:00:00 2001
From: Michal Simek <michal.simek@xilinx.com>
Date: Fri, 3 Apr 2020 11:24:30 +0200
Subject: Revert "serial: uartps: Fix uartps_major handling"

This reverts commit 5e9bd2d70ae7c00a95a22994abf1eef728649e64.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
    https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/310999ab5342f788a7bc1b0e68294d4f052cad07.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 6b26f767768e..b858fb14833d 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1564,6 +1564,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		goto err_out_id;
 	}
 
+	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
 
 	/*
@@ -1694,7 +1695,6 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		console_port = NULL;
 #endif
 
-	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,
 							     "cts-override");
 	return 0;
@@ -1756,12 +1756,6 @@ static int cdns_uart_remove(struct platform_device *pdev)
 		console_port = NULL;
 #endif
 
-	/* If this is last instance major number should be initialized */
-	mutex_lock(&bitmap_lock);
-	if (bitmap_empty(bitmap, MAX_UART_INSTANCES))
-		uartps_major = 0;
-	mutex_unlock(&bitmap_lock);
-
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
-- 
2.26.1


