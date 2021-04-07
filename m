Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE38356972
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350960AbhDGKYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350945AbhDGKYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:24:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED45D613EA;
        Wed,  7 Apr 2021 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617791031;
        bh=YvIR0wKojxogYm4mzV63se8JnVW9YMFH3XKPAsG7738=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIYUKWNeo2Msucz9qhPpvQuQJ5+m8Br118lI46SA3MCNm9N743C/4Ipm+ay1jKDx7
         qku/mXJPNiCW5uu0LGWecO3wJzUgkhO+zUJQKjQolf0QPbHOOoYpO4SH7rYsltdxmW
         OVBlvediJuUSDKcrhUY2ZfhXZafUzgndq+k8V5ik2idP8G/xrWUrMK+2QbK8bBwxUb
         qhCmJajnKvs4ntzYwnPoC5yrVCt1dxjJvsFn7xaejrB2sVsPk8VEFwBKBL09dHXWXy
         WKemapHQkTNfjlcL5vDfqVcNYhYMq6zI3UpKowIQy69/cHP72jbUAUI2Lk6/KpyLot
         BhZdwdEFpiMpQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5Lb-0008Rc-Ma; Wed, 07 Apr 2021 12:23:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-staging@lists.linux.dev,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 13/16] tty: mxser: fix TIOCSSERIAL jiffies conversions
Date:   Wed,  7 Apr 2021 12:23:31 +0200
Message-Id: <20210407102334.32361-14-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210407102334.32361-1-johan@kernel.org>
References: <20210407102334.32361-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The port close_delay and closing wait parameters set by TIOCSSERIAL are
specified in jiffies, while the values returned by TIOCGSERIAL are
specified in centiseconds.

Add the missing conversions so that TIOCSSERIAL works as expected also
when HZ is not 100.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/mxser.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 4203b64bccdb..914b23071961 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1208,19 +1208,26 @@ static int mxser_get_serial_info(struct tty_struct *tty,
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
@@ -1233,7 +1240,7 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 	struct tty_port *port = &info->port;
 	speed_t baud;
 	unsigned long sl_flags;
-	unsigned int flags;
+	unsigned int flags, close_delay, closing_wait;
 	int retval = 0;
 
 	if (tty->index == MXSER_PORTS)
@@ -1255,9 +1262,14 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 
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
@@ -1271,8 +1283,8 @@ static int mxser_set_serial_info(struct tty_struct *tty,
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
-- 
2.26.3

