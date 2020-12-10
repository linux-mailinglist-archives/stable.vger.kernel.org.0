Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56892D6514
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390784AbgLJSc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 13:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390780AbgLJOdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:33:49 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 04/39] USB: serial: kl5kusb105: fix memleak on open
Date:   Thu, 10 Dec 2020 15:26:43 +0100
Message-Id: <20201210142602.507198856@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3f203f057edfcf6bd02c6b942799262bfcf31f73 upstream.

Fix memory leak of control-message transfer buffer on successful open().

Fixes: 6774d5f53271 ("USB: serial: kl5kusb105: fix open error path")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/kl5kusb105.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -276,12 +276,12 @@ static int  klsi_105_open(struct tty_str
 	priv->cfg.unknown2 = cfg->unknown2;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	kfree(cfg);
+
 	/* READ_ON and urb submission */
 	rc = usb_serial_generic_open(tty, port);
-	if (rc) {
-		retval = rc;
-		goto err_free_cfg;
-	}
+	if (rc)
+		return rc;
 
 	rc = usb_control_msg(port->serial->dev,
 			     usb_sndctrlpipe(port->serial->dev, 0),
@@ -324,8 +324,6 @@ err_disable_read:
 			     KLSI_TIMEOUT);
 err_generic_close:
 	usb_serial_generic_close(port);
-err_free_cfg:
-	kfree(cfg);
 
 	return retval;
 }


