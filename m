Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD162ABD28
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbgKINnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:43:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730380AbgKIM7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:59:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E5C20684;
        Mon,  9 Nov 2020 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926776;
        bh=iLDrDM2p+upcXyAkPIFZdCqI5bYnc9t7FxVbiDcUE9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaH4uakYX1CEaL2+SEarAbpnYcrK2F9+sd8Hgsxuez6ZDQX31RGHtaIQlk1DWyEhd
         Ou5sIebSgsAJeP7j8dl/+KKT102YbCCze2Ze1lOLxGctOtEoNvsQLTJxtuNALz1Q05
         J6bTwdeqlcl/U+WjEbcbdbxk6r+srGA5VuzxUMJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claire Chang <tientzu@chromium.org>
Subject: [PATCH 4.4 79/86] serial: 8250_mtk: Fix uart_get_baud_rate warning
Date:   Mon,  9 Nov 2020 13:55:26 +0100
Message-Id: <20201109125024.586406070@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claire Chang <tientzu@chromium.org>

commit 912ab37c798770f21b182d656937072b58553378 upstream.

Mediatek 8250 port supports speed higher than uartclk / 16. If the baud
rates in both the new and the old termios setting are higher than
uartclk / 16, the WARN_ON in uart_get_baud_rate() will be triggered.
Passing NULL as the old termios so uart_get_baud_rate() will use
uartclk / 16 - 1 as the new baud rate which will be replaced by the
original baud rate later by tty_termios_encode_baud_rate() in
mtk8250_set_termios().

Fixes: 551e553f0d4a ("serial: 8250_mtk: Fix high-speed baud rates clamping")
Signed-off-by: Claire Chang <tientzu@chromium.org>
Link: https://lore.kernel.org/r/20201102120749.374458-1-tientzu@chromium.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_mtk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -58,7 +58,7 @@ mtk8250_set_termios(struct uart_port *po
 	 */
 	baud = tty_termios_baud_rate(termios);
 
-	serial8250_do_set_termios(port, termios, old);
+	serial8250_do_set_termios(port, termios, NULL);
 
 	tty_termios_encode_baud_rate(termios, baud, baud);
 


