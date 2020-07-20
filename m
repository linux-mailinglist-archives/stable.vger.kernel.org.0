Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656362267C8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbgGTQOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387612AbgGTQOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A65E20684;
        Mon, 20 Jul 2020 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261677;
        bh=6uxzCo+IwlUzjA4NV+/IdtXYD5eCNWmAuMiyw7f0kJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lq48uQTuckiYvD9Jj6To1U5jSWFiHPrWXZzfVsl/yluFS7BAGFT5Cv2wa094W3gC3
         ors07MRU+zh7Ul/Za5ypFc2UMaVdr6c0vYkt0x8DPrqCFO3005+a8e2UoPOAz//Mqs
         no1NH90Pqba5vuhHFksPCUh2GipC2hbQRpDOWqwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 5.7 175/244] serial: mxs-auart: add missed iounmap() in probe failure and remove
Date:   Mon, 20 Jul 2020 17:37:26 +0200
Message-Id: <20200720152834.162743422@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit d8edf8eb5f6e921fe6389f96d2cd05862730a6ff upstream.

This driver calls ioremap() in probe, but it misses calling iounmap() in
probe's error handler and remove.
Add the missed calls to fix it.

Fixes: 47d37d6f94cc ("serial: Add auart driver for i.MX23/28")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200709135608.68290-1-hslester96@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/mxs-auart.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1698,21 +1698,21 @@ static int mxs_auart_probe(struct platfo
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
@@ -1720,7 +1720,7 @@ static int mxs_auart_probe(struct platfo
 	 */
 	ret = mxs_auart_request_gpio_irq(s);
 	if (ret)
-		goto out_disable_clks;
+		goto out_iounmap;
 
 	auart_port[s->port.line] = s;
 
@@ -1746,6 +1746,9 @@ out_free_qpio_irq:
 	mxs_auart_free_gpio_irq(s);
 	auart_port[pdev->id] = NULL;
 
+out_iounmap:
+	iounmap(s->port.membase);
+
 out_disable_clks:
 	if (is_asm9260_auart(s)) {
 		clk_disable_unprepare(s->clk);
@@ -1761,6 +1764,7 @@ static int mxs_auart_remove(struct platf
 	uart_remove_one_port(&auart_driver, &s->port);
 	auart_port[pdev->id] = NULL;
 	mxs_auart_free_gpio_irq(s);
+	iounmap(s->port.membase);
 	if (is_asm9260_auart(s)) {
 		clk_disable_unprepare(s->clk);
 		clk_disable_unprepare(s->clk_ahb);


