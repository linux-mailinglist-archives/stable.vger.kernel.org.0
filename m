Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100E8420CB0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbhJDNJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234983AbhJDNGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:06:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22E2A611C2;
        Mon,  4 Oct 2021 13:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352496;
        bh=MylyCFsFcFuRAZurpinNKG7rgGh5Fk9L5R3wmCK5FYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8NA3elpcPZ2WWl9ZNVwLT98yrX5VWB5aeXd4KVS/ntBb32uy02JRTy631xbXUmj9
         47CBmy5JMqCWUbP8Y0wirT2n0WwMNkQQ7wmVPx9YhtbQMUiBVcNqd6aumn+EVmYS3e
         4mw9bRIBKPTI5pUSgyugECGnHlq048APRLzube4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 10/95] staging: greybus: uart: fix tty use after free
Date:   Mon,  4 Oct 2021 14:51:40 +0200
Message-Id: <20211004125033.906683142@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125033.572932188@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 92dc0b1f46e12cfabd28d709bb34f7a39431b44f upstream.

User space can hold a tty open indefinitely and tty drivers must not
release the underlying structures until the last user is gone.

Switch to using the tty-port reference counter to manage the life time
of the greybus tty state to avoid use after free after a disconnect.

Fixes: a18e15175708 ("greybus: more uart work")
Cc: stable@vger.kernel.org      # 4.9
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210906124538.22358-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/uart.c |   62 +++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -799,6 +799,17 @@ out:
 	gbphy_runtime_put_autosuspend(gb_tty->gbphy_dev);
 }
 
+static void gb_tty_port_destruct(struct tty_port *port)
+{
+	struct gb_tty *gb_tty = container_of(port, struct gb_tty, port);
+
+	if (gb_tty->minor != GB_NUM_MINORS)
+		release_minor(gb_tty);
+	kfifo_free(&gb_tty->write_fifo);
+	kfree(gb_tty->buffer);
+	kfree(gb_tty);
+}
+
 static const struct tty_operations gb_ops = {
 	.install =		gb_tty_install,
 	.open =			gb_tty_open,
@@ -822,6 +833,7 @@ static const struct tty_port_operations
 	.dtr_rts =		gb_tty_dtr_rts,
 	.activate =		gb_tty_port_activate,
 	.shutdown =		gb_tty_port_shutdown,
+	.destruct =		gb_tty_port_destruct,
 };
 
 static int gb_uart_probe(struct gbphy_device *gbphy_dev,
@@ -834,17 +846,11 @@ static int gb_uart_probe(struct gbphy_de
 	int retval;
 	int minor;
 
-	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
-	if (!gb_tty)
-		return -ENOMEM;
-
 	connection = gb_connection_create(gbphy_dev->bundle,
 					  le16_to_cpu(gbphy_dev->cport_desc->id),
 					  gb_uart_request_handler);
-	if (IS_ERR(connection)) {
-		retval = PTR_ERR(connection);
-		goto exit_tty_free;
-	}
+	if (IS_ERR(connection))
+		return PTR_ERR(connection);
 
 	max_payload = gb_operation_get_payload_size_max(connection);
 	if (max_payload < sizeof(struct gb_uart_send_data_request)) {
@@ -852,13 +858,23 @@ static int gb_uart_probe(struct gbphy_de
 		goto exit_connection_destroy;
 	}
 
+	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
+	if (!gb_tty) {
+		retval = -ENOMEM;
+		goto exit_connection_destroy;
+	}
+
+	tty_port_init(&gb_tty->port);
+	gb_tty->port.ops = &gb_port_ops;
+	gb_tty->minor = GB_NUM_MINORS;
+
 	gb_tty->buffer_payload_max = max_payload -
 			sizeof(struct gb_uart_send_data_request);
 
 	gb_tty->buffer = kzalloc(gb_tty->buffer_payload_max, GFP_KERNEL);
 	if (!gb_tty->buffer) {
 		retval = -ENOMEM;
-		goto exit_connection_destroy;
+		goto exit_put_port;
 	}
 
 	INIT_WORK(&gb_tty->tx_work, gb_uart_tx_write_work);
@@ -866,7 +882,7 @@ static int gb_uart_probe(struct gbphy_de
 	retval = kfifo_alloc(&gb_tty->write_fifo, GB_UART_WRITE_FIFO_SIZE,
 			     GFP_KERNEL);
 	if (retval)
-		goto exit_buf_free;
+		goto exit_put_port;
 
 	gb_tty->credits = GB_UART_FIRMWARE_CREDITS;
 	init_completion(&gb_tty->credits_complete);
@@ -880,7 +896,7 @@ static int gb_uart_probe(struct gbphy_de
 		} else {
 			retval = minor;
 		}
-		goto exit_kfifo_free;
+		goto exit_put_port;
 	}
 
 	gb_tty->minor = minor;
@@ -889,9 +905,6 @@ static int gb_uart_probe(struct gbphy_de
 	init_waitqueue_head(&gb_tty->wioctl);
 	mutex_init(&gb_tty->mutex);
 
-	tty_port_init(&gb_tty->port);
-	gb_tty->port.ops = &gb_port_ops;
-
 	gb_tty->connection = connection;
 	gb_tty->gbphy_dev = gbphy_dev;
 	gb_connection_set_data(connection, gb_tty);
@@ -899,7 +912,7 @@ static int gb_uart_probe(struct gbphy_de
 
 	retval = gb_connection_enable_tx(connection);
 	if (retval)
-		goto exit_release_minor;
+		goto exit_put_port;
 
 	send_control(gb_tty, gb_tty->ctrlout);
 
@@ -926,16 +939,10 @@ static int gb_uart_probe(struct gbphy_de
 
 exit_connection_disable:
 	gb_connection_disable(connection);
-exit_release_minor:
-	release_minor(gb_tty);
-exit_kfifo_free:
-	kfifo_free(&gb_tty->write_fifo);
-exit_buf_free:
-	kfree(gb_tty->buffer);
+exit_put_port:
+	tty_port_put(&gb_tty->port);
 exit_connection_destroy:
 	gb_connection_destroy(connection);
-exit_tty_free:
-	kfree(gb_tty);
 
 	return retval;
 }
@@ -966,15 +973,10 @@ static void gb_uart_remove(struct gbphy_
 	gb_connection_disable_rx(connection);
 	tty_unregister_device(gb_tty_driver, gb_tty->minor);
 
-	/* FIXME - free transmit / receive buffers */
-
 	gb_connection_disable(connection);
-	tty_port_destroy(&gb_tty->port);
 	gb_connection_destroy(connection);
-	release_minor(gb_tty);
-	kfifo_free(&gb_tty->write_fifo);
-	kfree(gb_tty->buffer);
-	kfree(gb_tty);
+
+	tty_port_put(&gb_tty->port);
 }
 
 static int gb_tty_init(void)


