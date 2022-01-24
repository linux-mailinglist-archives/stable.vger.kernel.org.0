Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C5A498BEF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344162AbiAXTRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40546 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343943AbiAXTPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:15:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF3D9B8122A;
        Mon, 24 Jan 2022 19:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F8C340E5;
        Mon, 24 Jan 2022 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051729;
        bh=H+TtTiaS+wXHHNh6mrbg38+/ZuFn+N7M8uOJBPK0OBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGkN14v/pSxcuBofLN5tA3mwCuDjolgI9jA+9qKz94GxSC+jFJdnZDNc8CxsU3r6f
         JR6zAr3asBCTGXRWYRlytS7UvAIMDIylEfkjcSWwWcIdmV1XfKm7478xIl/Hp9kmSu
         4vvxZa9irRILZF8tAeMVJDIOdvyuGX+vOR5Cpnnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/239] serial: amba-pl011: do not request memory region twice
Date:   Mon, 24 Jan 2022 19:41:45 +0100
Message-Id: <20220124183945.267710790@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

[ Upstream commit d1180405c7b5c7a1c6bde79d5fc24fe931430737 ]

With commit 3873e2d7f63a ("drivers: PL011: refactor pl011_probe()") the
function devm_ioremap() called from pl011_setup_port() was replaced with
devm_ioremap_resource(). Since this function not only remaps but also
requests the ports io memory region it now collides with the .config_port()
callback which requests the same region at uart port registration.

Since devm_ioremap_resource() already claims the memory successfully, the
request in .config_port() fails.

Later at uart port deregistration the attempt to release the unclaimed
memory also fails. The failure results in a “Trying to free nonexistent
resource" warning.

Fix these issues by removing the callbacks that implement the redundant
memory allocation/release. Also make sure that changing the drivers io
memory base address via TIOCSSERIAL is not allowed any more.

Fixes: 3873e2d7f63a ("drivers: PL011: refactor pl011_probe()")
Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Link: https://lore.kernel.org/r/20211129174238.8333-1-LinoSanfilippo@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3d63e9a71c376..5edc3813a9b99 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2094,32 +2094,13 @@ static const char *pl011_type(struct uart_port *port)
 	return uap->port.type == PORT_AMBA ? uap->type : NULL;
 }
 
-/*
- * Release the memory region(s) being used by 'port'
- */
-static void pl011_release_port(struct uart_port *port)
-{
-	release_mem_region(port->mapbase, SZ_4K);
-}
-
-/*
- * Request the memory region(s) being used by 'port'
- */
-static int pl011_request_port(struct uart_port *port)
-{
-	return request_mem_region(port->mapbase, SZ_4K, "uart-pl011")
-			!= NULL ? 0 : -EBUSY;
-}
-
 /*
  * Configure/autoconfigure the port.
  */
 static void pl011_config_port(struct uart_port *port, int flags)
 {
-	if (flags & UART_CONFIG_TYPE) {
+	if (flags & UART_CONFIG_TYPE)
 		port->type = PORT_AMBA;
-		pl011_request_port(port);
-	}
 }
 
 /*
@@ -2134,6 +2115,8 @@ static int pl011_verify_port(struct uart_port *port, struct serial_struct *ser)
 		ret = -EINVAL;
 	if (ser->baud_base < 9600)
 		ret = -EINVAL;
+	if (port->mapbase != (unsigned long) ser->iomem_base)
+		ret = -EINVAL;
 	return ret;
 }
 
@@ -2151,8 +2134,6 @@ static const struct uart_ops amba_pl011_pops = {
 	.flush_buffer	= pl011_dma_flush_buffer,
 	.set_termios	= pl011_set_termios,
 	.type		= pl011_type,
-	.release_port	= pl011_release_port,
-	.request_port	= pl011_request_port,
 	.config_port	= pl011_config_port,
 	.verify_port	= pl011_verify_port,
 #ifdef CONFIG_CONSOLE_POLL
@@ -2182,8 +2163,6 @@ static const struct uart_ops sbsa_uart_pops = {
 	.shutdown	= sbsa_uart_shutdown,
 	.set_termios	= sbsa_uart_set_termios,
 	.type		= pl011_type,
-	.release_port	= pl011_release_port,
-	.request_port	= pl011_request_port,
 	.config_port	= pl011_config_port,
 	.verify_port	= pl011_verify_port,
 #ifdef CONFIG_CONSOLE_POLL
-- 
2.34.1



