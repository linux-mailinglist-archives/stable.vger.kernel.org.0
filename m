Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF965222718
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 17:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgGPPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbgGPPfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 11:35:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9748A2076A;
        Thu, 16 Jul 2020 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594913705;
        bh=go48CUbwgIsdATzZEniBymkeTicWIbgG66WZo3KqmtA=;
        h=Subject:To:From:Date:From;
        b=al+1K2rIQfI7cOzzlLuYWg4alcxe4X+Y8va3nHALWUfI/Q1SwVug1P7f+librKYjw
         z928f2Flyj5aZRFJORmyV9O4wWIl07L783stfI7/m7N+yulyYj004d0ivu94qjRt+q
         E+jT7Zk6/J+ak0YYPKJIDgFWITUXhH1WSmwZsKtk=
Subject: patch "USB: serial: iuu_phoenix: fix memory corruption" added to usb-linus
To:     johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Jul 2020 17:34:58 +0200
Message-ID: <1594913698147170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: iuu_phoenix: fix memory corruption

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e7b931bee739e8a77ae216e613d3b99342b6dec0 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 15 Jul 2020 11:02:45 +0200
Subject: USB: serial: iuu_phoenix: fix memory corruption

The driver would happily overwrite its write buffer with user data in
256 byte increments due to a removed buffer-space sanity check.

Fixes: 5fcf62b0f1f2 ("tty: iuu_phoenix: fix locking.")
Cc: stable <stable@vger.kernel.org>     # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/iuu_phoenix.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index d5bff69b1769..b8dfeb4fb2ed 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -697,14 +697,16 @@ static int iuu_uart_write(struct tty_struct *tty, struct usb_serial_port *port,
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
 
-	if (count > 256)
-		return -ENOMEM;
-
 	spin_lock_irqsave(&priv->lock, flags);
 
+	count = min(count, 256 - priv->writelen);
+	if (count == 0)
+		goto out;
+
 	/* fill the buffer */
 	memcpy(priv->writebuf + priv->writelen, buf, count);
 	priv->writelen += count;
+out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return count;
-- 
2.27.0


