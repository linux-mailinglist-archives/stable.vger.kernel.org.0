Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1059B29B840
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799942AbgJ0PeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799933AbgJ0PeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:34:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FF442225E;
        Tue, 27 Oct 2020 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812851;
        bh=fl1FrL+pt6wssIHRNNSRSUCfnhfDnK+6aTxbHWKnjr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuBe9sEkugs/Q7kFp6UOnXDTb12Y2ECO9xN2jkXBv9j9ttt/6eRZKjQqupVUs7gFx
         vQkbkevtSf2rAdl1scSYiJzjiD9eOKnB7dYFvK0afrSB6tEP1ihnfCC9pa2bJ7XzCr
         a1b68zsrfirSsS3diaGQmQeK8u075q1jgPPaza+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 353/757] serial: 8250: Skip uninitialized TTY port baud rate update
Date:   Tue, 27 Oct 2020 14:50:03 +0100
Message-Id: <20201027135507.132974595@linuxfoundation.org>
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

[ Upstream commit c8dff3aa824177013d90967687f09f713a55d13f ]

It is erroneous to update the TTY port baud rate if it hasn't been
initialized yet, because in that case the TTY struct isn't set. So there
is no termios structure to get and re-calculate the baud if the current
baud can't be reached. Let's skip the baud rate update then until the port
is fully initialized.

Note the update UART clock method still sets the uartclk member with a new
ref clock value even if the port is turned off. The new UART ref clock
rate will be used later on the port starting up procedure.

Fixes: 868f3ee6e452 ("serial: 8250: Add 8250 port clock update method")
Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20200923161950.6237-3-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 1259fb6b66b38..b0af13074cd36 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2653,6 +2653,10 @@ void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
 		goto out_lock;
 
 	port->uartclk = uartclk;
+
+	if (!tty_port_initialized(&port->state->port))
+		goto out_lock;
+
 	termios = &port->state->port.tty->termios;
 
 	baud = serial8250_get_baud_rate(port, termios, NULL);
-- 
2.25.1



