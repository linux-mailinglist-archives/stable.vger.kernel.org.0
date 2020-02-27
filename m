Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC812171B4E
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732889AbgB0OBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732890AbgB0OBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C342073D;
        Thu, 27 Feb 2020 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812074;
        bh=0WEPTYqZ5Y4oG4shErs6HA0zfDpS3Vlm3zVRv8t6hA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHQG1Ac9CL9m4JhcVSMbU9Sl5YZtU3+lpR80p8S3F/wQvML1AFDfsqZwUQv0kiRHZ
         PbxeJNjSm1yzSVZTqChUHNdIfxRl7/fb6tF5xyvo1BkijpS1o12hBEl1dfbM3WkIE3
         Ccnp6//0pOzPhYNSykoSXzLwbqnRSufEUBNbRUEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 195/237] serdev: ttyport: restore client ops on deregistration
Date:   Thu, 27 Feb 2020 14:36:49 +0100
Message-Id: <20200227132310.657779420@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
@@ -238,7 +238,6 @@ struct device *serdev_tty_port_register(
 					struct device *parent,
 					struct tty_driver *drv, int idx)
 {
-	const struct tty_port_client_operations *old_ops;
 	struct serdev_controller *ctrl;
 	struct serport *serport;
 	int ret;
@@ -257,7 +256,6 @@ struct device *serdev_tty_port_register(
 
 	ctrl->ops = &ctrl_ops;
 
-	old_ops = port->client_ops;
 	port->client_ops = &client_ops;
 	port->client_data = ctrl;
 
@@ -270,7 +268,7 @@ struct device *serdev_tty_port_register(
 
 err_reset_data:
 	port->client_data = NULL;
-	port->client_ops = old_ops;
+	port->client_ops = &tty_port_default_client_ops;
 	serdev_controller_put(ctrl);
 
 	return ERR_PTR(ret);
@@ -285,8 +283,8 @@ int serdev_tty_port_unregister(struct tt
 		return -ENODEV;
 
 	serdev_controller_remove(ctrl);
-	port->client_ops = NULL;
 	port->client_data = NULL;
+	port->client_ops = &tty_port_default_client_ops;
 	serdev_controller_put(ctrl);
 
 	return 0;
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -51,10 +51,11 @@ static void tty_port_default_wakeup(stru
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
@@ -67,7 +68,7 @@ void tty_port_init(struct tty_port *port
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
@@ -224,6 +224,8 @@ struct tty_port_client_operations {
 	void (*write_wakeup)(struct tty_port *port);
 };
 
+extern const struct tty_port_client_operations tty_port_default_client_ops;
+
 struct tty_port {
 	struct tty_bufhead	buf;		/* Locked internally */
 	struct tty_struct	*tty;		/* Back pointer */


