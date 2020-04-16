Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF811AC65D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgDPOiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgDPOGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:06:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB3072076D;
        Thu, 16 Apr 2020 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587046009;
        bh=iCRKiNCbyUIHqs2S+YLw2FwE2r0t1ZxbvtEFt59JMzg=;
        h=Subject:To:From:Date:From;
        b=ecuJ1NU6pmURJA1NBtxhc4tRaZZXHMTMFfrMcfTNZxukuc1DrQhyoidcOlrYP/QuU
         nL8CEZQ7Uw8fSS0375iNAkGe1OYrpdN5r+qJYf0dhiKHYMn1ywzSIRz8kOfH/pFPSY
         hRA+Lx2LBqlTuQNcbnehO/YvQT6/7XG9QT3rHFJ4=
Subject: patch "Revert "serial: uartps: Fix error path when alloc failed"" added to tty-linus
To:     michal.simek@xilinx.com, gregkh@linuxfoundation.org,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 16:06:39 +0200
Message-ID: <1587045999107178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: uartps: Fix error path when alloc failed"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b6fd2dbbd649b89a3998528994665ded1e3fbf7f Mon Sep 17 00:00:00 2001
From: Michal Simek <michal.simek@xilinx.com>
Date: Fri, 3 Apr 2020 11:24:32 +0200
Subject: Revert "serial: uartps: Fix error path when alloc failed"

This reverts commit 32cf21ac4edd6c0d5b9614368a83bcdc68acb031.

As Johan says, this driver needs a lot more work and these changes are
only going in the wrong direction:
  https://lkml.kernel.org/r/20190523091839.GC568@localhost

Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/46cd7f039db847c08baa6508edd7854f7c8ff80f.1585905873.git.michal.simek@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/xilinx_uartps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 4e3fefa70b56..412bfc51f546 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1542,10 +1542,8 @@ static int cdns_uart_probe(struct platform_device *pdev)
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 	cdns_uart_console = devm_kzalloc(&pdev->dev, sizeof(*cdns_uart_console),
 					 GFP_KERNEL);
-	if (!cdns_uart_console) {
-		rc = -ENOMEM;
-		goto err_out_id;
-	}
+	if (!cdns_uart_console)
+		return -ENOMEM;
 
 	strncpy(cdns_uart_console->name, CDNS_UART_TTY_NAME,
 		sizeof(cdns_uart_console->name));
-- 
2.26.1


