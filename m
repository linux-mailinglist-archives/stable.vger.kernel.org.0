Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4672B1AC4EB
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409718AbgDPOHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbgDPOGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:06:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 300582078B;
        Thu, 16 Apr 2020 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587046011;
        bh=etw1XQXIw8r3MdB8ASa0ycsQI00NhzU/5ElyykG30UE=;
        h=Subject:To:From:Date:From;
        b=Pjc4n31cqz9yBw7fdUatF5YNSq4jfY92y8J/T3j6drZcxyLBHyL6pJJ/JeCV3YCqp
         AX9x/r5Lu/5Sg/lF3HYptXwDiTXRrU1CEWWH09w30rB62hLnwSkTq8XU5/Z7VWV67H
         XsxHGP/d1WiY1xCx97hK39BO7YzvZes2Jszl0TrA=
Subject: patch "Revert "serial: uartps: Do not allow use aliases >=" added to tty-linus
To:     michal.simek@xilinx.com, gregkh@linuxfoundation.org,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 16:06:39 +0200
Message-ID: <15870459994412@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: uartps: Do not allow use aliases >=

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 91c9dfa25c7f95b543c280e0edf1fd8de6e90985 Mon Sep 17 00:00:00 2001
From: Michal Simek <michal.simek@xilinx.com>
Date: Fri, 3 Apr 2020 11:24:33 +0200
Subject: Revert "serial: uartps: Do not allow use aliases >=
 MAX_UART_INSTANCES"

This reverts commit 2088cfd882d0403609bdf426e9b24372fe1b8337.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/dac3898e3e32d963f357fb436ac9a7ac3cbcf933.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 412bfc51f546..9db3cd120057 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1712,8 +1712,7 @@ static int cdns_uart_probe(struct platform_device *pdev)
 	uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
 err_out_id:
 	mutex_lock(&bitmap_lock);
-	if (cdns_uart_data->id < MAX_UART_INSTANCES)
-		clear_bit(cdns_uart_data->id, bitmap);
+	clear_bit(cdns_uart_data->id, bitmap);
 	mutex_unlock(&bitmap_lock);
 	return rc;
 }
@@ -1738,8 +1737,7 @@ static int cdns_uart_remove(struct platform_device *pdev)
 	rc = uart_remove_one_port(cdns_uart_data->cdns_uart_driver, port);
 	port->mapbase = 0;
 	mutex_lock(&bitmap_lock);
-	if (cdns_uart_data->id < MAX_UART_INSTANCES)
-		clear_bit(cdns_uart_data->id, bitmap);
+	clear_bit(cdns_uart_data->id, bitmap);
 	mutex_unlock(&bitmap_lock);
 	clk_disable_unprepare(cdns_uart_data->uartclk);
 	clk_disable_unprepare(cdns_uart_data->pclk);
-- 
2.26.1


