Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B6A8EDB8
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 16:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732425AbfHOOHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 10:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732334AbfHOOHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 10:07:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2E8206C2;
        Thu, 15 Aug 2019 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565878051;
        bh=7LhAkaFUG/4ZQJKJxjnQg8nbws3FteTc/KPlDmPKhQk=;
        h=Subject:To:From:Date:From;
        b=Bu2cHuKvmOUvGqSvDNNgyVD4B6CxzH3dc2ZvDcMcTky71BlMj2zc2IW3CY7X238dO
         bvnt7uAaNj8YIprcUzTjyX7QbOyJOLAiom4ttDseiZmR+Gyi/NyzIh+SdV83dOrR5e
         /Ftqa/fxA/WRJWYzRF/s0lafYxUaC8tbPzHbGoUo=
Subject: patch "tty/serial: atmel: reschedule TX after RX was started" added to tty-testing
To:     razvan.stefanescu@microchip.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Aug 2019 16:07:29 +0200
Message-ID: <156587804914712@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty/serial: atmel: reschedule TX after RX was started

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a8441389f0daef2d74ecd79ab27067953f0b2483 Mon Sep 17 00:00:00 2001
From: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Date: Tue, 13 Aug 2019 10:40:25 +0300
Subject: tty/serial: atmel: reschedule TX after RX was started

When half-duplex RS485 communication is used, after RX is started, TX
tasklet still needs to be  scheduled tasklet. This avoids console freezing
when more data is to be transmitted, if the serial communication is not
closed.

Fixes: 69646d7a3689 ("tty/serial: atmel: RS485 HD w/DMA: enable RX after TX is stopped")
Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190813074025.16218-1-razvan.stefanescu@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 19a85d6fe3d2..9a54c9e6d36e 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1400,7 +1400,6 @@ atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 
 			atmel_port->hd_start_rx = false;
 			atmel_start_rx(port);
-			return;
 		}
 
 		atmel_tasklet_schedule(atmel_port, &atmel_port->tasklet_tx);
-- 
2.22.1


