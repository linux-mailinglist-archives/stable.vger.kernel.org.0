Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1618829DE8A
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgJ1WSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731726AbgJ1WRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A559D2472B;
        Wed, 28 Oct 2020 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603888735;
        bh=iY7sZAOVaH7gDLnkau28CdgqIrvvs27kXiUjTFQL9HI=;
        h=Subject:To:From:Date:From;
        b=zOoAGEnXVvdvMWeJD6q4cH2gXmJzQg0XokNk0oMnND2rcEl2E0xQWYm763JC/fkH0
         4/U2IrKCegflqm906rZpoUxeXlRfrTYVCRlhWLMbBd3eKwndDKrJF7PVpgxrNQU8GA
         /6e4UNghI3Fkv5KmqlDpbuK33/+VTgrJhxOTlEfo=
Subject: patch "tty: serial: 21285: fix lockup on open" added to tty-linus
To:     rmk+kernel@armlinux.org.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:39:47 +0100
Message-ID: <16038887876912@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: 21285: fix lockup on open

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 82776f6c75a90e1d2103e689b84a689de8f1aa02 Mon Sep 17 00:00:00 2001
From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Sun, 18 Oct 2020 09:42:04 +0100
Subject: tty: serial: 21285: fix lockup on open

Commit 293f89959483 ("tty: serial: 21285: stop using the unused[]
variable from struct uart_port") introduced a bug which stops the
transmit interrupt being disabled when there are no characters to
transmit - disabling the transmit interrupt at the interrupt controller
is the only way to stop an interrupt storm. If this interrupt is not
disabled when there are no transmit characters, we end up with an
interrupt storm which prevents the machine making forward progress.

Fixes: 293f89959483 ("tty: serial: 21285: stop using the unused[] variable from struct uart_port")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/E1kU4GS-0006lE-OO@rmk-PC.armlinux.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/21285.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/21285.c b/drivers/tty/serial/21285.c
index 718e010fcb04..09baef4ccc39 100644
--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -50,25 +50,25 @@ static const char serial21285_name[] = "Footbridge UART";
 
 static bool is_enabled(struct uart_port *port, int bit)
 {
-	unsigned long private_data = (unsigned long)port->private_data;
+	unsigned long *private_data = (unsigned long *)&port->private_data;
 
-	if (test_bit(bit, &private_data))
+	if (test_bit(bit, private_data))
 		return true;
 	return false;
 }
 
 static void enable(struct uart_port *port, int bit)
 {
-	unsigned long private_data = (unsigned long)port->private_data;
+	unsigned long *private_data = (unsigned long *)&port->private_data;
 
-	set_bit(bit, &private_data);
+	set_bit(bit, private_data);
 }
 
 static void disable(struct uart_port *port, int bit)
 {
-	unsigned long private_data = (unsigned long)port->private_data;
+	unsigned long *private_data = (unsigned long *)&port->private_data;
 
-	clear_bit(bit, &private_data);
+	clear_bit(bit, private_data);
 }
 
 #define is_tx_enabled(port)	is_enabled(port, tx_enabled_bit)
-- 
2.29.1


