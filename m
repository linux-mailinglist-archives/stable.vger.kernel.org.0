Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0C21B553
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGJMo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 08:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgGJMo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 08:44:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A82220772;
        Fri, 10 Jul 2020 12:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594385096;
        bh=Ns2Fw0ZSMxvngjNfUwdOOEDT6F9X1FBI4kHEDOS32Cs=;
        h=Subject:To:From:Date:From;
        b=LGKHMIhszcoLsrfVFfQsWWVAAD4DkFuAAnL981SK7Xig9gT6QjnceruSi39LYMzd1
         p9cBwN24Q9EmuGgw/qBuBtZoqMy5YP46kLRtJ0GOskli4YrMTZyXLi9UO6cYcu6kuR
         RCSS/YTdg1WoaxnvTkIWq5LbMtNSHyE14SSPJ/6E=
Subject: patch "serial: mxs-auart: add missed iounmap() in probe failure and remove" added to tty-linus
To:     hslester96@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jul 2020 14:45:00 +0200
Message-ID: <1594385100236128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: mxs-auart: add missed iounmap() in probe failure and remove

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d8edf8eb5f6e921fe6389f96d2cd05862730a6ff Mon Sep 17 00:00:00 2001
From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 9 Jul 2020 21:56:08 +0800
Subject: serial: mxs-auart: add missed iounmap() in probe failure and remove

This driver calls ioremap() in probe, but it misses calling iounmap() in
probe's error handler and remove.
Add the missed calls to fix it.

Fixes: 47d37d6f94cc ("serial: Add auart driver for i.MX23/28")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200709135608.68290-1-hslester96@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mxs-auart.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index b4f835e7de23..b784323a6a7b 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1698,21 +1698,21 @@ static int mxs_auart_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = irq;
-		goto out_disable_clks;
+		goto out_iounmap;
 	}
 
 	s->port.irq = irq;
 	ret = devm_request_irq(&pdev->dev, irq, mxs_auart_irq_handle, 0,
 			       dev_name(&pdev->dev), s);
 	if (ret)
-		goto out_disable_clks;
+		goto out_iounmap;
 
 	platform_set_drvdata(pdev, s);
 
 	ret = mxs_auart_init_gpios(s, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize GPIOs.\n");
-		goto out_disable_clks;
+		goto out_iounmap;
 	}
 
 	/*
@@ -1720,7 +1720,7 @@ static int mxs_auart_probe(struct platform_device *pdev)
 	 */
 	ret = mxs_auart_request_gpio_irq(s);
 	if (ret)
-		goto out_disable_clks;
+		goto out_iounmap;
 
 	auart_port[s->port.line] = s;
 
@@ -1746,6 +1746,9 @@ static int mxs_auart_probe(struct platform_device *pdev)
 	mxs_auart_free_gpio_irq(s);
 	auart_port[pdev->id] = NULL;
 
+out_iounmap:
+	iounmap(s->port.membase);
+
 out_disable_clks:
 	if (is_asm9260_auart(s)) {
 		clk_disable_unprepare(s->clk);
@@ -1761,6 +1764,7 @@ static int mxs_auart_remove(struct platform_device *pdev)
 	uart_remove_one_port(&auart_driver, &s->port);
 	auart_port[pdev->id] = NULL;
 	mxs_auart_free_gpio_irq(s);
+	iounmap(s->port.membase);
 	if (is_asm9260_auart(s)) {
 		clk_disable_unprepare(s->clk);
 		clk_disable_unprepare(s->clk_ahb);
-- 
2.27.0


