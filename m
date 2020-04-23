Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCBD1B5CEE
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 15:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgDWNun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 09:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgDWNun (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 09:50:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E1C2076C;
        Thu, 23 Apr 2020 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587649842;
        bh=gWV9h4/89SiltEXNq2LsJUeDhLBLUKrRfCsELWeJaVc=;
        h=Subject:To:From:Date:From;
        b=maqGfvtpZPgTXxu/UldTGCL4bc6wNgz7RnXwlEHPbBenYyOJIGJWJD0sIeBZ2opFZ
         z0FJfYMKhkQ3z2WIAZomg6Qm+wdtwEx7Zq18xIRtQxsaTQzenvN09WWzYsrUcbuT3B
         vv+05naYrN/bqoSheZ91SfLIOePTIwJsQriMwyLA=
Subject: patch "tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart" added to tty-linus
To:     zou_wei@huawei.com, gregkh@linuxfoundation.org, hulkci@huawei.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Apr 2020 15:50:40 +0200
Message-ID: <1587649840131116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 580d952e44de5509c69c8f9346180ecaa78ebeec Mon Sep 17 00:00:00 2001
From: Zou Wei <zou_wei@huawei.com>
Date: Tue, 21 Apr 2020 20:31:46 +0800
Subject: tty: serial: bcm63xx: fix missing clk_put() in bcm63xx_uart

This patch fixes below error reported by coccicheck

drivers/tty/serial/bcm63xx_uart.c:848:2-8: ERROR: missing clk_put;
clk_get on line 842 and execution via conditional on line 846

Fixes: ab4382d27412 ("tty: move drivers/serial/ to drivers/tty/serial/")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1587472306-105155-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/bcm63xx_uart.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index 5674da2b76f0..ed0aa5c0d9b7 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -843,8 +843,10 @@ static int bcm_uart_probe(struct platform_device *pdev)
 	if (IS_ERR(clk) && pdev->dev.of_node)
 		clk = of_clk_get(pdev->dev.of_node, 0);
 
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
+		clk_put(clk);
 		return -ENODEV;
+	}
 
 	port->iotype = UPIO_MEM;
 	port->irq = res_irq->start;
-- 
2.26.2


