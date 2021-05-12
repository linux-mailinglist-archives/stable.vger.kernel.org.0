Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B80237CB6C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbhELQf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241187AbhELQ0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C247861DB6;
        Wed, 12 May 2021 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834617;
        bh=SddqrF4pqme/pw1h5xa7nekd1GROY2vSDnG5flgcsSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcGJ7KDAJ8zGqm5Ep0XB4IXkubqERnafc/Oh3RdtGkkZKP+TXcXdOZhS810BHKv3v
         3D0ps6aVHbxmgLYtVT5cEcR3I3yGGtcOjhw24FdjmjvPnPxrqg35VKc3uOzEl+2sKR
         q8Oo5g2SPnZeDaBP8NChwdumfv14nqTnCswg+Twk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 016/677] tty: mxser: fix TIOCSSERIAL jiffies conversions
Date:   Wed, 12 May 2021 16:41:02 +0200
Message-Id: <20210512144837.767599327@linuxfoundation.org>
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

commit be6cf583d24dfe87324dd2830d90fc056e0a6648 upstream.

The port close_delay and closing wait parameters set by TIOCSSERIAL are
specified in jiffies, while the values returned by TIOCGSERIAL are
specified in centiseconds.

Add the missing conversions so that TIOCSSERIAL works as expected also
when HZ is not 100.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-14-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/mxser.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1208,19 +1208,26 @@ static int mxser_get_serial_info(struct
 {
 	struct mxser_port *info = tty->driver_data;
 	struct tty_port *port = &info->port;
+	unsigned int closing_wait, close_delay;
 
 	if (tty->index == MXSER_PORTS)
 		return -ENOTTY;
 
 	mutex_lock(&port->mutex);
+
+	close_delay = jiffies_to_msecs(info->port.close_delay) / 10;
+	closing_wait = info->port.closing_wait;
+	if (closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		closing_wait = jiffies_to_msecs(closing_wait) / 10;
+
 	ss->type = info->type,
 	ss->line = tty->index,
 	ss->port = info->ioaddr,
 	ss->irq = info->board->irq,
 	ss->flags = info->port.flags,
 	ss->baud_base = info->baud_base,
-	ss->close_delay = info->port.close_delay,
-	ss->closing_wait = info->port.closing_wait,
+	ss->close_delay = close_delay;
+	ss->closing_wait = closing_wait;
 	ss->custom_divisor = info->custom_divisor,
 	mutex_unlock(&port->mutex);
 	return 0;
@@ -1233,7 +1240,7 @@ static int mxser_set_serial_info(struct
 	struct tty_port *port = &info->port;
 	speed_t baud;
 	unsigned long sl_flags;
-	unsigned int flags;
+	unsigned int flags, close_delay, closing_wait;
 	int retval = 0;
 
 	if (tty->index == MXSER_PORTS)
@@ -1255,9 +1262,14 @@ static int mxser_set_serial_info(struct
 
 	flags = port->flags & ASYNC_SPD_MASK;
 
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
+	closing_wait = ss->closing_wait;
+	if (closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		closing_wait = msecs_to_jiffies(closing_wait * 10);
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((ss->baud_base != info->baud_base) ||
-				(ss->close_delay != info->port.close_delay) ||
+				(close_delay != info->port.close_delay) ||
 				((ss->flags & ~ASYNC_USR_MASK) != (info->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&port->mutex);
 			return -EPERM;
@@ -1271,8 +1283,8 @@ static int mxser_set_serial_info(struct
 		 */
 		port->flags = ((port->flags & ~ASYNC_FLAGS) |
 				(ss->flags & ASYNC_FLAGS));
-		port->close_delay = ss->close_delay * HZ / 100;
-		port->closing_wait = ss->closing_wait * HZ / 100;
+		port->close_delay = close_delay;
+		port->closing_wait = closing_wait;
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
 				(ss->baud_base != info->baud_base ||
 				ss->custom_divisor !=


