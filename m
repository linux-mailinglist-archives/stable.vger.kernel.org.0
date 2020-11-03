Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2D2A5855
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbgKCUrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731381AbgKCUro (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 270AC20719;
        Tue,  3 Nov 2020 20:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436463;
        bh=4iIu57LZw99xO5TmaDLQ9Qk6BI5wQNdxRHxlLCn9hHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVdajZ/TxltMi+ZnRegGJomz/a4gDEbOfxIzoDxs9rzYa79wOsk3sX8O2oiLdXN5k
         gK0s2A8vJ+EEogSeaDPLuwOyqyA5eIMaRA7Fp/+qODEdOegwqpcAK0lB3ZHMFvwniC
         9BqqszM8h59jDBXny3wnwzVCTvL3VKuW1NIj1kbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.9 259/391] tty: serial: 21285: fix lockup on open
Date:   Tue,  3 Nov 2020 21:35:10 +0100
Message-Id: <20201103203404.500668101@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

commit 82776f6c75a90e1d2103e689b84a689de8f1aa02 upstream.

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
 drivers/tty/serial/21285.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -50,25 +50,25 @@ static const char serial21285_name[] = "
 
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


