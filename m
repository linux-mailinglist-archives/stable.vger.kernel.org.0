Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2215C6DFED
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfGSD7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbfGSD7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3379121852;
        Fri, 19 Jul 2019 03:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508747;
        bh=cMkGSY6nHF8MaSprRbBJnM+U9bxKfqQFy7K21qB/h2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvRWJGJRaHxZOVv1Yxsb3KyiL7wG5b4WuCvypfanRv+MIJu5my2FKOJjem8FYIg1h
         R06XMZXI5jqjbV3i6vI4q175dZNOYnX1tlfvx34ctqlaAT870ha5xVxgTxcf3srM8Z
         mHVuKwPs8xdG640hZs3eWsiRmKTAJVIUsbO/YKJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 068/171] tty: serial_core: Set port active bit in uart_port_activate
Date:   Thu, 18 Jul 2019 23:54:59 -0400
Message-Id: <20190719035643.14300-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 13b18d35909707571af9539f7731389fbf0feb31 ]

A bug was introduced by commit b3b576461864 ("tty: serial_core: convert
uart_open to use tty_port_open"). It caused a constant warning printed
into the system log regarding the tty and port counter mismatch:

[   21.644197] ttyS ttySx: tty_port_close_start: tty->count = 1 port count = 2

in case if session hangup was detected so the warning is printed starting
from the second open-close iteration.

Particularly the problem was discovered in situation when there is a
serial tty device without hardware back-end being setup. It is considered
by the tty-serial subsystems as a hardware problem with session hang up.
In this case uart_startup() will return a positive value with TTY_IO_ERROR
flag set in corresponding tty_struct instance. The same value will get
passed to be returned from the activate() callback and then being returned
from tty_port_open(). But since in this case tty_port_block_til_ready()
isn't called the TTY_PORT_ACTIVE flag isn't set (while the method had been
called before tty_port_open conversion was introduced and the rest of the
subsystem code expected the bit being set in this case), which prevents the
uart_hangup() method to perform any cleanups including the tty port
counter setting to zero. So the next attempt to open/close the tty device
will discover the counters mismatch.

In order to fix the problem we need to manually set the TTY_PORT_ACTIVE
flag in case if uart_startup() returned a positive value. In this case
the hang up procedure will perform a full set of cleanup actions including
the port ref-counter resetting.

Fixes: b3b576461864 "tty: serial_core: convert uart_open to use tty_port_open"
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 83f4dd0bfd74..4223cb496764 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1777,6 +1777,7 @@ static int uart_port_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport;
+	int ret;
 
 	uport = uart_port_check(state);
 	if (!uport || uport->flags & UPF_DEAD)
@@ -1787,7 +1788,11 @@ static int uart_port_activate(struct tty_port *port, struct tty_struct *tty)
 	/*
 	 * Start up the serial port.
 	 */
-	return uart_startup(tty, state, 0);
+	ret = uart_startup(tty, state, 0);
+	if (ret > 0)
+		tty_port_set_active(port, 1);
+
+	return ret;
 }
 
 static const char *uart_type(struct uart_port *port)
-- 
2.20.1

