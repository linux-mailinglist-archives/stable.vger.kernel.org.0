Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B296611B836
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfLKPHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730010AbfLKPHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F69222C4;
        Wed, 11 Dec 2019 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076855;
        bh=aPdqcuoYB/AxfN1Ijbok5sCn7AQwGNsV+TPJFrNmQa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NU99usv2kkyYI/OCZIcze7zoxJEkK154ShCAJogrNcBeT7bXw2aQfbnhcqDsO7lx1
         kv7N7bzh2u1FN7K8fHl2HphGa74Z++fjVJpJtDTH6oGzvGQ3+cCDqsJEL2ZGiTKiL2
         RSPKcBA7YM6rtTQ50Aa5hCoS41O//e7BTRw3EkH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 17/92] serial: 8250_dw: Avoid double error messaging when IRQ absent
Date:   Wed, 11 Dec 2019 16:05:08 +0100
Message-Id: <20191211150226.742908160@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 05faa64e73924556ba281911db24643e438fe7ba upstream.

Since the commit 7723f4c5ecdb ("driver core: platform: Add an error message
to platform_get_irq*()") platform_get_irq() started issuing an error message.
Thus, there is no need to have the same in the driver

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191023103558.51862-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_dw.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -386,10 +386,10 @@ static int dw8250_probe(struct platform_
 {
 	struct uart_8250_port uart = {}, *up = &uart;
 	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int irq = platform_get_irq(pdev, 0);
 	struct uart_port *p = &up->port;
 	struct device *dev = &pdev->dev;
 	struct dw8250_data *data;
+	int irq;
 	int err;
 	u32 val;
 
@@ -398,11 +398,9 @@ static int dw8250_probe(struct platform_
 		return -EINVAL;
 	}
 
-	if (irq < 0) {
-		if (irq != -EPROBE_DEFER)
-			dev_err(dev, "cannot get irq\n");
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
 		return irq;
-	}
 
 	spin_lock_init(&p->lock);
 	p->mapbase	= regs->start;


