Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508D92267CE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbgGTQOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387888AbgGTQOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C8B4207DD;
        Mon, 20 Jul 2020 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261688;
        bh=aJQ/DIQ+rul2GS/VuIwymqZJGkffWutP1LK6HMOdbYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz/cbvuOJ0vsLAqqdGmUGi2bqNiZWy9MuWiUHdh+CIJZjFGnxW67utTIqPHkO8m/0
         PKklTFtTMH1uSuRoyX5hx/EDsz7N7tv2Kl7/eAqbO7MXRWBelolIWYtzYVQT5Vjlo4
         J5rlSd4jCxn312j60MpdTMqX8/2s9SjTviyRCxFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 176/244] Revert "serial: core: Refactor uart_unlock_and_check_sysrq()"
Date:   Mon, 20 Jul 2020 17:37:27 +0200
Message-Id: <20200720152834.210555871@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 10652a9e9fe3fbcaca090f99cd3060ac3fee2913 upstream.

This reverts commit da9a5aa3402db0ff3b57216d8dbf2478e1046cae.

In order to ease backporting a fix for a sysrq regression, revert this
rewrite which was since added on top.

The other sysrq helpers now bail out early when sysrq is not enabled;
it's better to keep that pattern here as well.

Note that the __releases() attribute won't be needed after the follow-on
fix either.

Fixes: da9a5aa3402d ("serial: core: Refactor uart_unlock_and_check_sysrq()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200610152232.16925-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |   23 +++++++++++++----------
 include/linux/serial_core.h      |    3 ++-
 2 files changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3251,19 +3251,22 @@ int uart_prepare_sysrq_char(struct uart_
 }
 EXPORT_SYMBOL_GPL(uart_prepare_sysrq_char);
 
-void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long flags)
-__releases(&port->lock)
+void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long irqflags)
 {
-	if (port->has_sysrq) {
-		int sysrq_ch = port->sysrq_ch;
+	int sysrq_ch;
 
-		port->sysrq_ch = 0;
-		spin_unlock_irqrestore(&port->lock, flags);
-		if (sysrq_ch)
-			handle_sysrq(sysrq_ch);
-	} else {
-		spin_unlock_irqrestore(&port->lock, flags);
+	if (!port->has_sysrq) {
+		spin_unlock_irqrestore(&port->lock, irqflags);
+		return;
 	}
+
+	sysrq_ch = port->sysrq_ch;
+	port->sysrq_ch = 0;
+
+	spin_unlock_irqrestore(&port->lock, irqflags);
+
+	if (sysrq_ch)
+		handle_sysrq(sysrq_ch);
 }
 EXPORT_SYMBOL_GPL(uart_unlock_and_check_sysrq);
 
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -462,7 +462,8 @@ extern void uart_insert_char(struct uart
 
 extern int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch);
 extern int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch);
-extern void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long flags);
+extern void uart_unlock_and_check_sysrq(struct uart_port *port,
+					unsigned long irqflags);
 extern int uart_handle_break(struct uart_port *port);
 
 /*


