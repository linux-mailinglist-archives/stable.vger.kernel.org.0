Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0FB3569D5
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351185AbhDGKkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351153AbhDGKkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A57D613E2;
        Wed,  7 Apr 2021 10:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617791990;
        bh=aSQemZUT4zjOWvpySanyr/JtoPh/9pFqMpRYNW1g5ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrOgWjQyeCtVl7RHFlhbV+iUBd+DaORmBnFQQbyOuxLqcj41aZ0pMz2a66+P3BYNM
         HATpjH8Gz0B3koUr6QN6Hl1c8co67YQg3IrRw2hX9EvdNILy40U8Xb6etYaiQqQQLG
         VY8aLFkCCB0v681wV0Z4IRDTC0FvNnJwrHGLZv/9U8LX5Cs4AS749iBtJy7A4KE2BW
         MpsQ1itSXQruJGnk+i612zRXb8hq+N8bFcGMml98soJ6J7yTYjkEqptT93ZK/JaIed
         EiAj4pQwD5r8bynaL5qc4zwY+evrr8Hxp6nai07IY8kQc+OkYfyZTKypKl9XxcDuNQ
         PI07T2VRzy0/g==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lU5b5-0000FC-Fk; Wed, 07 Apr 2021 12:39:43 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 14/24] USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check
Date:   Wed,  7 Apr 2021 12:39:15 +0200
Message-Id: <20210407103925.829-15-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210407103925.829-1-johan@kernel.org>
References: <20210407103925.829-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Changing the port closing-wait parameter is a privileged operation so
make sure to return -EPERM if a regular user tries to change it.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 4b497c1e850b..bb50098a0ce6 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1418,14 +1418,19 @@ static int ti_set_serial_info(struct tty_struct *tty,
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
-- 
2.26.3

