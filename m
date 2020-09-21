Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8A9272E25
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgIUQqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729168AbgIUQqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 608D22388E;
        Mon, 21 Sep 2020 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706799;
        bh=/MoVMQ+YV+oqcRcLnR9UqxOJQhWQ6bhb789n8we9Mbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iO5vzpKEpujWlawDfnzdJKQ1rctFEK7MHo7irprk4TOvQhX94KydVSM588HMi9K60
         P7ewKTwcsMfiy322vegXhNQiiHJ65SsqqiR2WqIOvF7e+d3DC+MVjuc/8FquVqhbKB
         7vArYpk4Pj3fv+LmT/8qh4p0UWS4XCXaBgjqsW78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.8 100/118] serial: core: fix port-lock initialisation
Date:   Mon, 21 Sep 2020 18:28:32 +0200
Message-Id: <20200921162041.022221044@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit fe88c6489264eaea23570dfdf03e1d3f5f47f423 upstream.

Commit f743061a85f5 ("serial: core: Initialise spin lock before use in
uart_configure_port()") tried to work around a breakage introduced by
commit a3cb39d258ef ("serial: core: Allow detach and attach serial
device for console") by adding a second initialisation of the port lock
when registering the port.

As reported by the build robots [1], this doesn't really solve the
regression introduced by the console-detach changes and also adds a
second redundant initialisation of the lock for normal ports.

Start cleaning up this mess by removing the redundant initialisation and
making sure that the port lock is again initialised once-only for ports
that aren't already in use as a console.

[1] https://lore.kernel.org/r/20200802054852.GR23458@shao2-debian

Fixes: f743061a85f5 ("serial: core: Initialise spin lock before use in uart_configure_port()")
Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device for console")
Cc: stable <stable@vger.kernel.org>     # 5.7
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200909143101.15389-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2376,13 +2376,6 @@ uart_configure_port(struct uart_driver *
 		uart_change_pm(state, UART_PM_STATE_ON);
 
 		/*
-		 * If this driver supports console, and it hasn't been
-		 * successfully registered yet, initialise spin lock for it.
-		 */
-		if (port->cons && !(port->cons->flags & CON_ENABLED))
-			__uart_port_spin_lock_init(port);
-
-		/*
 		 * Ensure that the modem control lines are de-activated.
 		 * keep the DTR setting that is set in uart_set_options()
 		 * We probably don't need a spinlock around this, but
@@ -2897,7 +2890,12 @@ int uart_add_one_port(struct uart_driver
 		goto out;
 	}
 
-	uart_port_spin_lock_init(uport);
+	/*
+	 * If this port is in use as a console then the spinlock is already
+	 * initialised.
+	 */
+	if (!uart_console_enabled(uport))
+		__uart_port_spin_lock_init(uport);
 
 	if (uport->cons && uport->dev)
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);


