Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5819B226BFF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgGTPjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729593AbgGTPjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:39:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECA3022D04;
        Mon, 20 Jul 2020 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259586;
        bh=R0FwqxG8ES+ytRK/W3QTjkRyesWmEBLa/Mw0OsP60e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UM2cZ707APNbN9T7ms5x+u8jSrZ0w1I2jnMa4nCqewe2tCkq0IGgWxksXyrq/XBSq
         FG1bmXu+sjJRyOMBEDX44neMY12p/tssRChpoCXXwme9eTjEpH5c11CqjbOgYgHIHi
         QNk++H+WTHYkmpXcBzVExjNb+/dBKQ6rzHyOc0VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 44/58] USB: serial: iuu_phoenix: fix memory corruption
Date:   Mon, 20 Jul 2020 17:37:00 +0200
Message-Id: <20200720152749.444649755@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit e7b931bee739e8a77ae216e613d3b99342b6dec0 upstream.

The driver would happily overwrite its write buffer with user data in
256 byte increments due to a removed buffer-space sanity check.

Fixes: 5fcf62b0f1f2 ("tty: iuu_phoenix: fix locking.")
Cc: stable <stable@vger.kernel.org>     # 2.6.31
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/iuu_phoenix.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -717,14 +717,16 @@ static int iuu_uart_write(struct tty_str
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


