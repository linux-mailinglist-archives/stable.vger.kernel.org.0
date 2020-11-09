Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D3F2AB939
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgKINHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:07:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731250AbgKINHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:07:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B9DA20663;
        Mon,  9 Nov 2020 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927227;
        bh=0LisRcsaOQwUHAi14yXqT89DRf0dyrFbssm8tp7AO6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wogt0c1AI4YmdAxN1h3k1lFcXaI1+6m8GQa3BNVj+NHojSzMxjiTjUs23JCrOY7vo
         KErdpcEMKIN55HWCUSyc58JroH9+fUQlQjVVeIYVfUn99MqgnjYN8kA4nTKAk3TmBY
         Ts6TQS6oJMYT1SpeVbX7UhonnKgyjmZhatBDt3ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claire Chang <tientzu@chromium.org>
Subject: [PATCH 4.14 37/48] serial: 8250_mtk: Fix uart_get_baud_rate warning
Date:   Mon,  9 Nov 2020 13:55:46 +0100
Message-Id: <20201109125018.583456285@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
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
@@ -56,7 +56,7 @@ mtk8250_set_termios(struct uart_port *po
 	 */
 	baud = tty_termios_baud_rate(termios);
 
-	serial8250_do_set_termios(port, termios, old);
+	serial8250_do_set_termios(port, termios, NULL);
 
 	tty_termios_encode_baud_rate(termios, baud, baud);
 


