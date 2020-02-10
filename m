Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE5157DFC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 15:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgBJO6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 09:58:05 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34544 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgBJO6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 09:58:04 -0500
Received: by mail-lj1-f196.google.com with SMTP id x7so7535898ljc.1;
        Mon, 10 Feb 2020 06:58:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrCHhZ8MNx0wh/bp6TQHAl22F+AoIYKl11PNltzOCI8=;
        b=hPZbeejjaOZddG1jEPneCRMuGZxSJzpP/g6CovsssQLmMv+91Rwc03dwJcf069wJbT
         02q2lGfSX2KVWn9IMcDZhHgN+phPAXuNWkKtoL4NSOpcXV3TSztnhzeqnVWmB1BhRtOJ
         8tePOBizb5ourl+q20XZec5xezWjjp2AN0XAg5+5YCmHcDno0o0v5qZuNQ5ZvGpsJPx5
         E+7rswD59D8IflVkG83J6+1pHL3Sfeeat3/237pvkTGGV4BEfcQXN7VNP5ndemgypoP/
         jE5cvK9n7Pl6LTOUWZTTtv9JiGjT4SpVphqgO2CPiraVMjXMjXTJKvp3CBcBTL7NCZzj
         AF/g==
X-Gm-Message-State: APjAAAXgM5BEsTTqA8UKtdTH9OCBZ/YC/m79vGVgP1eE3bOFbpkY3p6V
        GTp9PjlXG1jEpJAjaTHBnmw=
X-Google-Smtp-Source: APXvYqx1W7ntHSFcf0z4cvNBSXsjgnFe1zGAZILNamB6D3zYwsd0zRbMqB89xZv9nCIYGTtok2r0JA==
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr1103012ljp.22.1581346682318;
        Mon, 10 Feb 2020 06:58:02 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id g15sm445291ljk.8.2020.02.10.06.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 06:58:01 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1j1AVd-0005vt-09; Mon, 10 Feb 2020 15:58:01 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] serdev: ttyport: restore client ops on deregistration
Date:   Mon, 10 Feb 2020 15:57:30 +0100
Message-Id: <20200210145730.22762-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200210145445.GA22240@localhost>
References: <20200210145445.GA22240@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.24.1

