Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCB158447
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 21:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgBJUce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 15:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJUce (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 15:32:34 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3EEA214DB;
        Mon, 10 Feb 2020 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581366753;
        bh=tuLjUogoYrpQGBqq9LVItpthc7QY2FsR7ieGPLA7tME=;
        h=Subject:To:From:Date:From;
        b=DfaG7prfgyRalWlWxUl34A0F51vvI7WvtKuNOQ/QUWnj0SF7RUyKDfwshrXzYfBWv
         aFEYOvL1GT538nPIzmH0g1pPTqwJF9Tm8mZ9Y/4pJWv48F8W8Z8LHDNge+sQWLgN1p
         GEfF0zz5s/r1XaYIoeLwvrUPkNZNy3g0j8ev8Fyc=
Subject: patch "serdev: ttyport: restore client ops on deregistration" added to tty-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        loic.poulain@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 12:32:32 -0800
Message-ID: <158136675210919@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serdev: ttyport: restore client ops on deregistration

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0c5aae59270fb1f827acce182786094c9ccf598e Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 10 Feb 2020 15:57:30 +0100
Subject: serdev: ttyport: restore client ops on deregistration

The serdev tty-port controller driver should reset the tty-port client
operations also on deregistration to avoid a NULL-pointer dereference in
case the port is later re-registered as a normal tty device.

Note that this can only happen with tty drivers such as 8250 which have
statically allocated port structures that can end up being reused and
where a later registration would not register a serdev controller (e.g.
due to registration errors or if the devicetree has been changed in
between).

Specifically, this can be an issue for any statically defined ports that
would be registered by 8250 core when an 8250 driver is being unbound.

Fixes: bed35c6dfa6a ("serdev: add a tty port controller driver")
Cc: stable <stable@vger.kernel.org>     # 4.11
Reported-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200210145730.22762-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serdev/serdev-ttyport.c | 6 ++----
 drivers/tty/tty_port.c              | 5 +++--
 include/linux/tty.h                 | 2 ++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
index d1cdd2ab8b4c..d367803e2044 100644
--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -265,7 +265,6 @@ struct device *serdev_tty_port_register(struct tty_port *port,
 					struct device *parent,
 					struct tty_driver *drv, int idx)
 {
-	const struct tty_port_client_operations *old_ops;
 	struct serdev_controller *ctrl;
 	struct serport *serport;
 	int ret;
@@ -284,7 +283,6 @@ struct device *serdev_tty_port_register(struct tty_port *port,
 
 	ctrl->ops = &ctrl_ops;
 
-	old_ops = port->client_ops;
 	port->client_ops = &client_ops;
 	port->client_data = ctrl;
 
@@ -297,7 +295,7 @@ struct device *serdev_tty_port_register(struct tty_port *port,
 
 err_reset_data:
 	port->client_data = NULL;
-	port->client_ops = old_ops;
+	port->client_ops = &tty_port_default_client_ops;
 	serdev_controller_put(ctrl);
 
 	return ERR_PTR(ret);
@@ -312,8 +310,8 @@ int serdev_tty_port_unregister(struct tty_port *port)
 		return -ENODEV;
 
 	serdev_controller_remove(ctrl);
-	port->client_ops = NULL;
 	port->client_data = NULL;
+	port->client_ops = &tty_port_default_client_ops;
 	serdev_controller_put(ctrl);
 
 	return 0;
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 044c3cbdcfa4..ea80bf872f54 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -52,10 +52,11 @@ static void tty_port_default_wakeup(struct tty_port *port)
 	}
 }
 
-static const struct tty_port_client_operations default_client_ops = {
+const struct tty_port_client_operations tty_port_default_client_ops = {
 	.receive_buf = tty_port_default_receive_buf,
 	.write_wakeup = tty_port_default_wakeup,
 };
+EXPORT_SYMBOL_GPL(tty_port_default_client_ops);
 
 void tty_port_init(struct tty_port *port)
 {
@@ -68,7 +69,7 @@ void tty_port_init(struct tty_port *port)
 	spin_lock_init(&port->lock);
 	port->close_delay = (50 * HZ) / 100;
 	port->closing_wait = (3000 * HZ) / 100;
-	port->client_ops = &default_client_ops;
+	port->client_ops = &tty_port_default_client_ops;
 	kref_init(&port->kref);
 }
 EXPORT_SYMBOL(tty_port_init);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index bfa4e2ee94a9..bd5fe0e907e8 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -225,6 +225,8 @@ struct tty_port_client_operations {
 	void (*write_wakeup)(struct tty_port *port);
 };
 
+extern const struct tty_port_client_operations tty_port_default_client_ops;
+
 struct tty_port {
 	struct tty_bufhead	buf;		/* Locked internally */
 	struct tty_struct	*tty;		/* Back pointer */
-- 
2.25.0


