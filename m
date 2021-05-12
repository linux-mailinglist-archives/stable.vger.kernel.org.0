Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4EE37CCB1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhELQqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:46:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243369AbhELQkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3779961E36;
        Wed, 12 May 2021 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835422;
        bh=wp7nTbQIuWvKN3naV9vxaY6AWGocGC41NvPAVXhYoac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JftnZ3KKfMD1ikcsBEQZrZeLsYs8sMH+8TWbLbG3ucfoFmFN9krnCz+LFOIZlgOPy
         fT5v+YSMhhvIh73e87j+g1MzVEZm5ArUpOOFQ3QXl6n2Oc4ONNI73LUl09/u0NIfso
         djwWdlzEWcFCNPhDYqo0xikC/Ps/1iKoa0+IgIlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 304/677] serial: core: return early on unsupported ioctls
Date:   Wed, 12 May 2021 16:45:50 +0200
Message-Id: <20210512144847.306180744@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 79c5966cec7b148199386ef9933c31b999379065 ]

Drivers can return -ENOIOCTLCMD when an ioctl is not recognised to tell
the upper layers to continue looking for a handler.

This is not the case for the RS485 and ISO7816 ioctls whose handlers
should return -ENOTTY directly in case a serial driver does not
implement the corresponding methods.

Fixes: a5f276f10ff7 ("serial_core: Handle TIOC[GS]RS485 ioctls.")
Fixes: ad8c0eaa0a41 ("tty/serial_core: add ISO7816 infrastructure")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407095208.31838-9-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ba31e97d3d96..43f02ed055d5 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1305,7 +1305,7 @@ static int uart_set_rs485_config(struct uart_port *port,
 	unsigned long flags;
 
 	if (!port->rs485_config)
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 
 	if (copy_from_user(&rs485, rs485_user, sizeof(*rs485_user)))
 		return -EFAULT;
@@ -1329,7 +1329,7 @@ static int uart_get_iso7816_config(struct uart_port *port,
 	struct serial_iso7816 aux;
 
 	if (!port->iso7816_config)
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 
 	spin_lock_irqsave(&port->lock, flags);
 	aux = port->iso7816;
@@ -1349,7 +1349,7 @@ static int uart_set_iso7816_config(struct uart_port *port,
 	unsigned long flags;
 
 	if (!port->iso7816_config)
-		return -ENOIOCTLCMD;
+		return -ENOTTY;
 
 	if (copy_from_user(&iso7816, iso7816_user, sizeof(*iso7816_user)))
 		return -EFAULT;
-- 
2.30.2



