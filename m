Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A3F1C361E
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 11:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgEDJup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 05:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgEDJup (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 05:50:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 336872073B;
        Mon,  4 May 2020 09:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588585844;
        bh=4iFMgh/e/RR5jvrP+xm/xxysXxlQwFy4kaX+yjqLG+c=;
        h=Subject:To:From:Date:From;
        b=L6o0wxpAkxzQYiIE6uqGAeThE67KWBRjcUIN5LAScyaI9MCJ7L0qln193/fVxbbCG
         l9QmY17eyYa6O0CW0AHwpTVTdYDLusdSY+F8X1SSi8So9HO501fFYV+ykFYKyXvEg+
         f9mm0HxN7lHWAugfLbgK/zrQWvHBSndpzWAzCpDE=
Subject: patch "Revert "tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart"" added to tty-linus
To:     f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 11:50:42 +0200
Message-ID: <158858584223618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 092a9f59bc05904d4555fa012db12e768734ba1a Mon Sep 17 00:00:00 2001
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 30 Apr 2020 18:39:04 -0700
Subject: Revert "tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart"

This reverts commit 580d952e44de5509c69c8f9346180ecaa78ebeec ("tty:
serial: bcm63xx: fix missing clk_put() in bcm63xx_uart") because we
should not be doing a clk_put() if we were not successful in getting a
valid clock reference via clk_get() in the first place.

Fixes: 580d952e44de ("tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200501013904.1394-1-f.fainelli@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/bcm63xx_uart.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index ed0aa5c0d9b7..5674da2b76f0 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -843,10 +843,8 @@ static int bcm_uart_probe(struct platform_device *pdev)
 	if (IS_ERR(clk) && pdev->dev.of_node)
 		clk = of_clk_get(pdev->dev.of_node, 0);
 
-	if (IS_ERR(clk)) {
-		clk_put(clk);
+	if (IS_ERR(clk))
 		return -ENODEV;
-	}
 
 	port->iotype = UPIO_MEM;
 	port->irq = res_irq->start;
-- 
2.26.2


