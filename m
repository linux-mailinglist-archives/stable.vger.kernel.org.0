Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00BD226920
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbgGTQYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732182AbgGTQCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:02:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6205420684;
        Mon, 20 Jul 2020 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260965;
        bh=fsnnDiVTPQQbT2KVekUadP5jr9jJ91n2sCUXodLSEyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWr4wUfqCWpUJMHs/vwyPMUlm6B1g0E+xXRE4yW9kZDHT4EOjjP3FmY457Od6mOFc
         PakbFGEmgDMqngFnPNcWjZ9SQBxGEJ2IfHYK6F7dC9gY0T1eKAepqtLFWUYr/ZtvvM
         Xez7MMvyaMU+Pjd8VCO4DaspopyXzJv4/588gtbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 159/215] USB: serial: iuu_phoenix: fix memory corruption
Date:   Mon, 20 Jul 2020 17:37:21 +0200
Message-Id: <20200720152827.745793500@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
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
@@ -697,14 +697,16 @@ static int iuu_uart_write(struct tty_str
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


