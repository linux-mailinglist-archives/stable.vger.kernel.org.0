Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329C62ABAE3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbgKINUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730884AbgKINUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB2D6206D8;
        Mon,  9 Nov 2020 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928039;
        bh=E5lSHdmMymlin9eyATPYgZBKInfLPQsXgYtM131YSF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xpuqtaSV0NV3VPbpDyXB4ecl+cIHUM8KI2suG0+9NjEgqsnvCmhY1xJROYUZYKiQ9
         tqueCLS+aIJ1dg7wYKbfzXlQHWwuq5hCuRtkiVJ4qjERvEGkcq8YTPsDbNWSdqy4cP
         1+4AsRbDKSz1240h0eXAY6lWPYfs/tc97q+CCodo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH 5.9 107/133] tty: fix crash in release_tty if tty->port is not set
Date:   Mon,  9 Nov 2020 13:56:09 +0100
Message-Id: <20201109125035.837647533@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Reichl <hias@horus.com>

commit 4466d6d2f80c1193e0845d110277c56da77a6418 upstream.

Commit 2ae0b31e0face ("tty: don't crash in tty_init_dev when missing
tty_port") didn't fully prevent the crash as the cleanup path in
tty_init_dev() calls release_tty() which dereferences tty->port
without checking it for non-null.

Add tty->port checks to release_tty to avoid the kernel crash.

Fixes: 2ae0b31e0face ("tty: don't crash in tty_init_dev when missing tty_port")
Signed-off-by: Matthias Reichl <hias@horus.com>
Link: https://lore.kernel.org/r/20201105123432.4448-1-hias@horus.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1514,10 +1514,12 @@ static void release_tty(struct tty_struc
 		tty->ops->shutdown(tty);
 	tty_save_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
-	tty->port->itty = NULL;
+	if (tty->port)
+		tty->port->itty = NULL;
 	if (tty->link)
 		tty->link->port->itty = NULL;
-	tty_buffer_cancel_work(tty->port);
+	if (tty->port)
+		tty_buffer_cancel_work(tty->port);
 	if (tty->link)
 		tty_buffer_cancel_work(tty->link->port);
 


