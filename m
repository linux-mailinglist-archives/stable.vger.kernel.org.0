Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46F20C1FD
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgF0OQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 10:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgF0OQ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 27 Jun 2020 10:16:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F0421655;
        Sat, 27 Jun 2020 14:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593267418;
        bh=jAc5GYpcGKf5DuXdEdODwITAMFxWteJ4jTIMUJ/Dok0=;
        h=Subject:To:From:Date:From;
        b=o7eORC++rHIqlZN8djNp7Wh7A+H9teXLg0KfnECr4ePQHyU4wxOMSVhjo28LYNqkS
         xS9mhE7JmlsDbMaaEEjh51mDnqDyKBsfQB+CHmAbfe3cmCRJAGggiLWo75SGonS61+
         SUMSM8tm8oXYpSzhS9g5RjEfdnIuxr+TukY2ovvs=
Subject: patch "Revert "serial: core: Refactor uart_unlock_and_check_sysrq()"" added to tty-linus
To:     johan@kernel.org, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Jun 2020 16:16:51 +0200
Message-ID: <1593267411143191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "serial: core: Refactor uart_unlock_and_check_sysrq()"

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 10652a9e9fe3fbcaca090f99cd3060ac3fee2913 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 10 Jun 2020 17:22:30 +0200
Subject: Revert "serial: core: Refactor uart_unlock_and_check_sysrq()"

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
 drivers/tty/serial/serial_core.c | 23 +++++++++++++----------
 include/linux/serial_core.h      |  3 ++-
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 13fb92ae3710..fcdb6bfbe2cf 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3239,19 +3239,22 @@ int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch)
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
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 9fd550e7946a..ef4921ddbe97 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -464,7 +464,8 @@ extern void uart_insert_char(struct uart_port *port, unsigned int status,
 
 extern int uart_handle_sysrq_char(struct uart_port *port, unsigned int ch);
 extern int uart_prepare_sysrq_char(struct uart_port *port, unsigned int ch);
-extern void uart_unlock_and_check_sysrq(struct uart_port *port, unsigned long flags);
+extern void uart_unlock_and_check_sysrq(struct uart_port *port,
+					unsigned long irqflags);
 extern int uart_handle_break(struct uart_port *port);
 
 /*
-- 
2.27.0


