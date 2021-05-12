Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0968037CACE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbhELQcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241174AbhELQ0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7924561DC2;
        Wed, 12 May 2021 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834610;
        bh=5tYHIfdHnlifvBDc+mt6bef7AcAUNLaqZMqTWjy9W+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/9cUISL58a0Fjuj96wixIEafnGBOCNHu2MYbyUKXYz0FYsiEsG/p0PX4/OEHz9to
         BKfDDynrIKcg5YHFWRj81Cv7WJ6OZDdXfbKUrkxtWAsHx9BahA5r3h8+tue33mtZvC
         1eW7TjMNHQGoSBNH+CAyYWUuCmgE2be6zHL9HzDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 013/677] USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check
Date:   Wed, 12 May 2021 16:40:59 +0200
Message-Id: <20210512144837.668873281@linuxfoundation.org>
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

commit d370c90dcd64e427a79a093a070117a1571d4cd8 upstream.

Changing the port closing-wait parameter is a privileged operation so
make sure to return -EPERM if a regular user tries to change it.

Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1418,14 +1418,19 @@ static int ti_set_serial_info(struct tty
 	struct serial_struct *ss)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct ti_port *tport = usb_get_serial_port_data(port);
+	struct tty_port *tport = &port->port;
 	unsigned cwait;
 
 	cwait = ss->closing_wait;
 	if (cwait != ASYNC_CLOSING_WAIT_NONE)
 		cwait = msecs_to_jiffies(10 * ss->closing_wait);
 
-	tport->tp_port->port.closing_wait = cwait;
+	if (!capable(CAP_SYS_ADMIN)) {
+		if (cwait != tport->closing_wait)
+			return -EPERM;
+	}
+
+	tport->closing_wait = cwait;
 
 	return 0;
 }


