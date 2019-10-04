Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEBACBB67
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 15:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbfJDNOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 09:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388052AbfJDNOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 09:14:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 593B0215EA;
        Fri,  4 Oct 2019 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570194886;
        bh=6/9WVoqQDzax2opwmByoj24XWv4XpbMfI1dPsKeo5JE=;
        h=Subject:To:From:Date:From;
        b=bH70WptTf8v+/Er0CKdD8Aj0J1iVLLvRDMOuZ6YFGmdnLjnZDZOBG3+v3/2Jd+BFj
         1XmqQBZc8nwKoGdjKSR8777IRqnmRqqo9U9/g55pMfuRi+W/ZmTeIz9MybZ5WrisBr
         gndOjrXaa+TvR7YnPy21zBlOjL57xxMhI1BYwqGE=
Subject: patch "serial: uartps: Fix uartps_major handling" added to tty-linus
To:     michal.simek@xilinx.com, gregkh@linuxfoundation.org,
        pthomas8589@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 15:14:44 +0200
Message-ID: <157019488416070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: uartps: Fix uartps_major handling

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e9bd2d70ae7c00a95a22994abf1eef728649e64 Mon Sep 17 00:00:00 2001
From: Michal Simek <michal.simek@xilinx.com>
Date: Fri, 4 Oct 2019 15:04:11 +0200
Subject: serial: uartps: Fix uartps_major handling

There are two parts which should be fixed. The first one is to assigned
uartps_major at the end of probe() to avoid complicated logic when
something fails.
The second part is initialized uartps_major number to 0 when last device is
removed. This will ensure that on next probe driver will ask for new
dynamic major number.

Fixes: ab262666018d ("serial: uartps: Use the same dynamic major number for all ports")
Reported-by: Paul Thomas <pthomas8589@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/d2652cda992833315c4f96f06953eb547f928918.1570194248.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index da4563aaaf5c..4e55bc327a54 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1550,7 +1550,6 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		goto err_out_id;
 	}
 
-	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cdns_uart_driver = cdns_uart_uart_driver;
 
 	/*
@@ -1680,6 +1679,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 		console_port = NULL;
 #endif
 
+	uartps_major = cdns_uart_uart_driver->tty_driver->major;
 	cdns_uart_data->cts_override = of_property_read_bool(pdev->dev.of_node,
 							     "cts-override");
 	return 0;
@@ -1741,6 +1741,12 @@ static int cdns_uart_remove(struct platform_device *pdev)
 		console_port = NULL;
 #endif
 
+	/* If this is last instance major number should be initialized */
+	mutex_lock(&bitmap_lock);
+	if (bitmap_empty(bitmap, MAX_UART_INSTANCES))
+		uartps_major = 0;
+	mutex_unlock(&bitmap_lock);
+
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 	return rc;
 }
-- 
2.23.0


