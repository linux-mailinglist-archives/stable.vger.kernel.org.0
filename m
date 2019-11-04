Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B3BEE502
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 17:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfKDQpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 11:45:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbfKDQpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 11:45:53 -0500
Received: from localhost (host6-102.lan-isdn.imaginet.fr [195.68.6.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 103522084D;
        Mon,  4 Nov 2019 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572885952;
        bh=f7V9jEuhd8DjF/aMvwV1LJcsHoMT+fMXt0FdY3jXSvs=;
        h=Subject:To:From:Date:From;
        b=NVs+aJoWNbuglHBGGlewnmIkHCfEgO4vPnJSkxz3gldbkd5F7Wz77eNIQkYDxUgCh
         18YhVeH6UeNuiGJidwgeoqqvGJ4awejzhOLxQnzNCAD/I4fkg7+mF2smnfdrp61oF3
         pDiujYu1YD0v6uYxe/GZlgJcqz45yT92mM3vRM0A=
Subject: patch "serial: 8250-mtk: Use platform_get_irq_optional() for optional irq" added to tty-testing
To:     frank-w@public-files.de, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Nov 2019 17:45:39 +0100
Message-ID: <1572885939230133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250-mtk: Use platform_get_irq_optional() for optional irq

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the tty-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From eb9c1a41ea1234907615fe47d6e47db8352d744b Mon Sep 17 00:00:00 2001
From: Frank Wunderlich <frank-w@public-files.de>
Date: Sun, 27 Oct 2019 07:21:17 +0100
Subject: serial: 8250-mtk: Use platform_get_irq_optional() for optional irq

As platform_get_irq() now prints an error when the interrupt does not
exist, this warnings are printed on bananapi-r2:

[    4.935780] mt6577-uart 11004000.serial: IRQ index 1 not found
[    4.962589] 11002000.serial: ttyS1 at MMIO 0x11002000 (irq = 202, base_baud = 1625000) is a ST16650V2
[    4.972127] mt6577-uart 11002000.serial: IRQ index 1 not found
[    4.998927] 11003000.serial: ttyS2 at MMIO 0x11003000 (irq = 203, base_baud = 1625000) is a ST16650V2
[    5.008474] mt6577-uart 11003000.serial: IRQ index 1 not found

Fix this by calling platform_get_irq_optional() instead.

now it looks like this:

[    4.872751] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191027062117.20389-1-frank-w@public-files.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index b411ba4eb5e9..4d067f515f74 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -544,7 +544,7 @@ static int mtk8250_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	data->rx_wakeup_irq = platform_get_irq(pdev, 1);
+	data->rx_wakeup_irq = platform_get_irq_optional(pdev, 1);
 
 	return 0;
 }
-- 
2.23.0


