Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9372B013B
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 09:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgKLIc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 03:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgKLIc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 03:32:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D51E52100A;
        Thu, 12 Nov 2020 08:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605169947;
        bh=PGcwZi5pJfL3iqKH7au9+Ilu3JqjdxaLjxs8Rk63fxg=;
        h=Subject:To:From:Date:From;
        b=NBQZsI3DZMpz/gFZTamtyfDlfovWgvbTB7m08ZJtUku8llmg5su8ETVPfqrSbM2DR
         lFxWbaTVioPOt6NLjIRq4pMwQMa/yiRpYnVzKmUKP0iZOCvt0ffmVx7ZMNNWWbVVnc
         GJ5w9dDqBpyplS1Av+LXFWPDf8LbqVOdC7mlS0DM=
Subject: patch "tty: serial: imx: fix potential deadlock" added to tty-linus
To:     samuel.nobs@taitradio.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, u.kleine-koenig@pengutronix.de
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 12 Nov 2020 09:33:26 +0100
Message-ID: <16051700065460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: imx: fix potential deadlock

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 33f16855dcb973f745c51882d0e286601ff3be2b Mon Sep 17 00:00:00 2001
From: Sam Nobs <samuel.nobs@taitradio.com>
Date: Tue, 10 Nov 2020 09:50:06 +1300
Subject: tty: serial: imx: fix potential deadlock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Enabling the lock dependency validator has revealed
that the way spinlocks are used in the IMX serial
port could result in a deadlock.

Specifically, imx_uart_int() acquires a spinlock
without disabling the interrupts, meaning that another
interrupt could come along and try to acquire the same
spinlock, potentially causing the two to wait for each
other indefinitely.

Use spin_lock_irqsave() instead to disable interrupts
upon acquisition of the spinlock.

Fixes: c974991d2620 ("tty:serial:imx: use spin_lock instead of spin_lock_irqsave in isr")
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sam Nobs <samuel.nobs@taitradio.com>
Link: https://lore.kernel.org/r/1604955006-9363-1-git-send-email-samuel.nobs@taitradio.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/imx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 1731d9728865..3c53a3c89959 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -942,8 +942,14 @@ static irqreturn_t imx_uart_int(int irq, void *dev_id)
 	struct imx_port *sport = dev_id;
 	unsigned int usr1, usr2, ucr1, ucr2, ucr3, ucr4;
 	irqreturn_t ret = IRQ_NONE;
+	unsigned long flags = 0;
 
-	spin_lock(&sport->port.lock);
+	/*
+	 * IRQs might not be disabled upon entering this interrupt handler,
+	 * e.g. when interrupt handlers are forced to be threaded. To support
+	 * this scenario as well, disable IRQs when acquiring the spinlock.
+	 */
+	spin_lock_irqsave(&sport->port.lock, flags);
 
 	usr1 = imx_uart_readl(sport, USR1);
 	usr2 = imx_uart_readl(sport, USR2);
@@ -1013,7 +1019,7 @@ static irqreturn_t imx_uart_int(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 	}
 
-	spin_unlock(&sport->port.lock);
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return ret;
 }
-- 
2.29.2


