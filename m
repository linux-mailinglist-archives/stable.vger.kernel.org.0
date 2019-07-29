Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A1A79615
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389841AbfG2Tsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390094AbfG2Tsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9923E205F4;
        Mon, 29 Jul 2019 19:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429711;
        bh=dY4+MCoX2L9K8Jk3aHUD3La1eiee6KJrz9EY35TJmxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJxluEHPg3whow8CBaLV4zMZSuE/GQuQP/UnmCAuB8pj7xrqQQragvQt8CfxFvC3N
         7SLh9hxLNeyZpyaa/u9fbira06CsZS5uoFqQqqXuHqJ+GZF0mVYyIHWgj8lGxUu7j9
         B7+A8IcDMMrUrIB6c/XKZkQmmmR4q8/Psx8w8wIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 069/215] tty: serial_core: Set port active bit in uart_port_activate
Date:   Mon, 29 Jul 2019 21:21:05 +0200
Message-Id: <20190729190752.259653310@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



