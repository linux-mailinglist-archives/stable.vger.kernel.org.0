Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D119171BA4
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgB0OEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387552AbgB0OEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EB4E24656;
        Thu, 27 Feb 2020 14:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812253;
        bh=kUKSzHdRRHXlQaZVmuHIoD/S65nhOWHRv5mf2gtz24U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXl8w7bzD12JcxXX6eODjeebRkZg268I4VLhqTgpH6Nk3nTC+BRudyPZycjtRmdnN
         aqT2WSGBsOnMKCVymMplk0Umq4gB+9YBoIUUWZvtFljLwDsNt1NyzSm3tW1wSA3lHl
         1rCy4vBK7tYEvMJ4XQa6vGRO3UucTcP1z7FVMbSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 43/97] serdev: ttyport: restore client ops on deregistration
Date:   Thu, 27 Feb 2020 14:36:51 +0100
Message-Id: <20200227132221.585786585@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 0c5aae59270fb1f827acce182786094c9ccf598e upstream.

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
 drivers/tty/serdev/serdev-ttyport.c |    6 ++----
 drivers/tty/tty_port.c              |    5 +++--
 include/linux/tty.h                 |    2 ++
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/tty/serdev/serdev-ttyport.c
+++ b/drivers/tty/serdev/serdev-ttyport.c
@@ -265,7 +265,6 @@ struct device *serdev_tty_port_register(
 					struct device *parent,
 					struct tty_driver *drv, int idx)
 {
-	const struct tty_port_client_operations *old_ops;
 	struct serdev_controller *ctrl;
 	struct serport *serport;
 	int ret;
@@ -284,7 +283,6 @@ struct device *serdev_tty_port_register(
 
 	ctrl->ops = &ctrl_ops;
 
-	old_ops = port->client_ops;
 	port->client_ops = &client_ops;
 	port->client_data = ctrl;
 
@@ -297,7 +295,7 @@ struct device *serdev_tty_port_register(
 
 err_reset_data:
 	port->client_data = NULL;
-	port->client_ops = old_ops;
+	port->client_ops = &tty_port_default_client_ops;
 	serdev_controller_put(ctrl);
 
 	return ERR_PTR(ret);
@@ -312,8 +310,8 @@ int serdev_tty_port_unregister(struct tt
 		return -ENODEV;
 
 	serdev_controller_remove(ctrl);
-	port->client_ops = NULL;
 	port->client_data = NULL;
+	port->client_ops = &tty_port_default_client_ops;
 	serdev_controller_put(ctrl);
 
 	return 0;
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -52,10 +52,11 @@ static void tty_port_default_wakeup(stru
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
@@ -68,7 +69,7 @@ void tty_port_init(struct tty_port *port
 	spin_lock_init(&port->lock);
 	port->close_delay = (50 * HZ) / 100;
 	port->closing_wait = (3000 * HZ) / 100;
-	port->client_ops = &default_client_ops;
+	port->client_ops = &tty_port_default_client_ops;
 	kref_init(&port->kref);
 }
 EXPORT_SYMBOL(tty_port_init);
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


