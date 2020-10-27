Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE08029B842
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798444AbgJ0PeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799944AbgJ0PeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBD4622264;
        Tue, 27 Oct 2020 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812854;
        bh=/DJbkGWZe5025wo5u4bMwrhCrwpohauIKQ6UXOkJg/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRLBsHKp6RT1lYEZz61NiMqv2dtV1e0SFCmaYOfqhIZmCcIuDkQ+8Y4x3BiRsk1K4
         5K0uO6hHaiGKwQzoF9OzP65b7sI9YUSxhp/E6cXpfyeBuLX/4YTqNEoAId8WGur38g
         WMP+swHYSUmoxBXHY+4hQK+RnNsgbkUCdyAzhTmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 354/757] serial: 8250_dw: Fix clk-notifier/port suspend deadlock
Date:   Tue, 27 Oct 2020 14:50:04 +0100
Message-Id: <20201027135507.180954087@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 85985a3dcd7415dd849cf62ec14f931cd905099a ]

It has been discovered that there is a potential deadlock between
the clock-change-notifier thread and the UART port suspending one:

   CPU0 (suspend CPU/UART)   CPU1 (update clock)
            ----                    ----
   lock(&port->mutex);
                             lock((work_completion)(&data->clk_work));
                             lock(&port->mutex);
   lock((work_completion)(&data->clk_work));

   *** DEADLOCK ***

The best way to fix this is to eliminate the CPU0
port->mutex/work-completion scenario. So we suggest to register and
unregister the clock-notifier during the DW APB UART port probe/remove
procedures, instead of doing that at the points of the port
startup/shutdown.

Link: https://lore.kernel.org/linux-serial/f1cd5c75-9cda-6896-a4e2-42c5bfc3f5c3@redhat.com

Fixes: cc816969d7b5 ("serial: 8250_dw: Fix common clocks usage race condition")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200923161950.6237-4-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 54 +++++++++++--------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 87f450b7c1779..9e204f9b799a1 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -373,39 +373,6 @@ static void dw8250_set_ldisc(struct uart_port *p, struct ktermios *termios)
 	serial8250_do_set_ldisc(p, termios);
 }
 
-static int dw8250_startup(struct uart_port *p)
-{
-	struct dw8250_data *d = to_dw8250_data(p->private_data);
-	int ret;
-
-	/*
-	 * Some platforms may provide a reference clock shared between several
-	 * devices. In this case before using the serial port first we have to
-	 * make sure that any clock state change is known to the UART port at
-	 * least post factum.
-	 */
-	if (d->clk) {
-		ret = clk_notifier_register(d->clk, &d->clk_notifier);
-		if (ret)
-			dev_warn(p->dev, "Failed to set the clock notifier\n");
-	}
-
-	return serial8250_do_startup(p);
-}
-
-static void dw8250_shutdown(struct uart_port *p)
-{
-	struct dw8250_data *d = to_dw8250_data(p->private_data);
-
-	serial8250_do_shutdown(p);
-
-	if (d->clk) {
-		clk_notifier_unregister(d->clk, &d->clk_notifier);
-
-		flush_work(&d->clk_work);
-	}
-}
-
 /*
  * dw8250_fallback_dma_filter will prevent the UART from getting just any free
  * channel on platforms that have DMA engines, but don't have any channels
@@ -501,8 +468,6 @@ static int dw8250_probe(struct platform_device *pdev)
 	p->serial_out	= dw8250_serial_out;
 	p->set_ldisc	= dw8250_set_ldisc;
 	p->set_termios	= dw8250_set_termios;
-	p->startup	= dw8250_startup;
-	p->shutdown	= dw8250_shutdown;
 
 	p->membase = devm_ioremap(dev, regs->start, resource_size(regs));
 	if (!p->membase)
@@ -622,6 +587,19 @@ static int dw8250_probe(struct platform_device *pdev)
 		goto err_reset;
 	}
 
+	/*
+	 * Some platforms may provide a reference clock shared between several
+	 * devices. In this case any clock state change must be known to the
+	 * UART port at least post factum.
+	 */
+	if (data->clk) {
+		err = clk_notifier_register(data->clk, &data->clk_notifier);
+		if (err)
+			dev_warn(p->dev, "Failed to set the clock notifier\n");
+		else
+			queue_work(system_unbound_wq, &data->clk_work);
+	}
+
 	platform_set_drvdata(pdev, data);
 
 	pm_runtime_set_active(dev);
@@ -648,6 +626,12 @@ static int dw8250_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(dev);
 
+	if (data->clk) {
+		clk_notifier_unregister(data->clk, &data->clk_notifier);
+
+		flush_work(&data->clk_work);
+	}
+
 	serial8250_unregister_port(data->data.line);
 
 	reset_control_assert(data->rst);
-- 
2.25.1



