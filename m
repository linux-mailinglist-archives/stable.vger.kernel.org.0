Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A702F2C0948
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgKWNFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729349AbgKWMtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B7AA204EF;
        Mon, 23 Nov 2020 12:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135794;
        bh=bDcj1YfB5EbpadlKflGobTNF7boG96JYpxkIuHQpzIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OiDrAFBbjXZwlaWaLofsuH7YSC9c0qPTTqUX54/nIBfpDIvpOa6iunGGjX+bMeYls
         1vqW5Y0wK/XzW646mm5WKNKirx5YHW+f4XfZooLFh+uaCOHWvaxPaeWnHdA+G1oyfg
         s+x7vAde9qS/cgQYqlsvFoniI4PXAQLZzUMvfMCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sam Nobs <samuel.nobs@taitradio.com>
Subject: [PATCH 5.9 198/252] tty: serial: imx: fix potential deadlock
Date:   Mon, 23 Nov 2020 13:22:28 +0100
Message-Id: <20201123121845.148588582@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Nobs <samuel.nobs@taitradio.com>

commit 33f16855dcb973f745c51882d0e286601ff3be2b upstream.

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
 drivers/tty/serial/imx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -942,8 +942,14 @@ static irqreturn_t imx_uart_int(int irq,
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
@@ -1013,7 +1019,7 @@ static irqreturn_t imx_uart_int(int irq,
 		ret = IRQ_HANDLED;
 	}
 
-	spin_unlock(&sport->port.lock);
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return ret;
 }


