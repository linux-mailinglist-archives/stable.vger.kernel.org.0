Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862AD2D6661
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390402AbgLJTXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:23:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390143AbgLJOam (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:42 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 23/45] USB: serial: kl5kusb105: fix memleak on open
Date:   Thu, 10 Dec 2020 15:26:37 +0100
Message-Id: <20201210142603.504327215@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.361598591@linuxfoundation.org>
References: <20201210142602.361598591@linuxfoundation.org>
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
@@ -293,12 +293,12 @@ static int  klsi_105_open(struct tty_str
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
@@ -341,8 +341,6 @@ err_disable_read:
 			     KLSI_TIMEOUT);
 err_generic_close:
 	usb_serial_generic_close(port);
-err_free_cfg:
-	kfree(cfg);
 
 	return retval;
 }


