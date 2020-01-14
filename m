Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D073913A7CD
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 12:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgANLCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 06:02:12 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36526 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbgANLCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 06:02:12 -0500
Received: by mail-lf1-f65.google.com with SMTP id n12so9483804lfe.3;
        Tue, 14 Jan 2020 03:02:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUjTgp22+/yqEKgWaGHHHjms+UIgzsHHTgm48VbX94s=;
        b=s+VO2WjZO2yU7cZrP9mdc/0Is4epULdijqi7Rx3d2RUBmmjQEsmXrGP7gb3U2UiHqw
         8OMq3rLvOOzfpUKE5uoXUNuD7xgKvyzX6iPL9sSn52IuZD5pwh6Jzf2DvLDAZwFubrLg
         QJlJd3A9qvElkohFk72jL1gtnm3DVe0fJMq63gY4tKN0HANvhAEmsHMWuW/pAW0f0nSl
         so9i/2CjbtXsdHIFEw0FWJahkEfM6BqYmCwYZe7b2OPf3FfGSCIzRzMqINKQEjEVfhw7
         RTi9FQWx+c/YtrqYBEmDZJP/YYlPBDRfa65Ow5dMddVnR8OweYWGVgWrFCseYNdg77jG
         mGxw==
X-Gm-Message-State: APjAAAVdFoM9ZVebE8rTkGRoFuEAvoj/h6gUbyHTDsdBfoTanfVXUwL4
        h/6HAZrnDgeRNDc2KhqbrLssMNcy
X-Google-Smtp-Source: APXvYqz7PUFsG1yu1W/eOAorCpRydpb0AWxQ/NLyMuJuEyFfnBRDpqlXFB3ZZRleU1kYcG3F2oOdnw==
X-Received: by 2002:a19:c697:: with SMTP id w145mr1385784lff.54.1578999730188;
        Tue, 14 Jan 2020 03:02:10 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id d24sm7138358lfb.94.2020.01.14.03.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 03:02:08 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1irJxZ-0001Z0-0E; Tue, 14 Jan 2020 12:02:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] USB: serial: opticon: stop all I/O on close()
Date:   Tue, 14 Jan 2020 12:01:46 +0100
Message-Id: <20200114110146.5929-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114110146.5929-1-johan@kernel.org>
References: <20200114110146.5929-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to stop any submitted write URBs on close(). This specifically
avoids a NULL-pointer dereference or use-after-free in case of a late
completion event after driver unbind.

Fixes: 648d4e16567e ("USB: serial: opticon: add write support")
Cc: stable <stable@vger.kernel.org>	# 2.6.30: xxx: USB: serial: opticon: add chars_in_buffer() implementation
Signed-off-by: Johan Hovold <johan@kernel.org>
---

v2
 - add missing address-of operator that was never commit before
   generating the patch


 drivers/usb/serial/opticon.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index f7bccf14a71f..0af76800bd78 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -42,6 +42,8 @@ struct opticon_private {
 	bool cts;
 	int outstanding_urbs;
 	int outstanding_bytes;
+
+	struct usb_anchor anchor;
 };
 
 
@@ -150,6 +152,15 @@ static int opticon_open(struct tty_struct *tty, struct usb_serial_port *port)
 	return res;
 }
 
+static void opticon_close(struct usb_serial_port *port)
+{
+	struct opticon_private *priv = usb_get_serial_port_data(port);
+
+	usb_kill_anchored_urbs(&priv->anchor);
+
+	usb_serial_generic_close(port);
+}
+
 static void opticon_write_control_callback(struct urb *urb)
 {
 	struct usb_serial_port *port = urb->context;
@@ -226,10 +237,13 @@ static int opticon_write(struct tty_struct *tty, struct usb_serial_port *port,
 		(unsigned char *)dr, buffer, count,
 		opticon_write_control_callback, port);
 
+	usb_anchor_urb(urb, &priv->anchor);
+
 	/* send it down the pipe */
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret) {
 		dev_err(&port->dev, "failed to submit write urb: %d\n", ret);
+		usb_unanchor_urb(urb);
 		goto error;
 	}
 
@@ -364,6 +378,7 @@ static int opticon_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
+	init_usb_anchor(&priv->anchor);
 
 	usb_set_serial_port_data(port, priv);
 
@@ -391,6 +406,7 @@ static struct usb_serial_driver opticon_device = {
 	.port_probe =		opticon_port_probe,
 	.port_remove =		opticon_port_remove,
 	.open =			opticon_open,
+	.close =		opticon_close,
 	.write =		opticon_write,
 	.write_room = 		opticon_write_room,
 	.chars_in_buffer =	opticon_chars_in_buffer,
-- 
2.24.1

