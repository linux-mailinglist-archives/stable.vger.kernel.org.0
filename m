Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2D13A6253
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhFNK7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234401AbhFNK4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD0E61585;
        Mon, 14 Jun 2021 10:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667272;
        bh=SSRrjdZq/z6ZxWH4qc5dp3zSTpiW11h5uRRJEVT9Cs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0edesK7hpXXX/E9BK83b87k2JJ1szgGvenqFWhDE2O3XNO1m71e/HUOnAnkh7fOt+
         RCf4Wq4L8tctxMk6N8tsAJbje/I+EEwx0BN7gPPeS08v+UO0JfyxDczOH6SeOc7Ygy
         sblJra6qe/jBRbI/rM5O2XqSrTQNZ8vC5BWNCkiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 57/84] USB: serial: quatech2: fix control-request directions
Date:   Mon, 14 Jun 2021 12:27:35 +0200
Message-Id: <20210614102648.311060312@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit eb8dbe80326c3d44c1e38ee4f40e0d8d3e06f2d0 upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the three requests which erroneously used usb_rcvctrlpipe().

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable@vger.kernel.org      # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/quatech2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -416,7 +416,7 @@ static void qt2_close(struct usb_serial_
 
 	/* flush the port transmit buffer */
 	i = usb_control_msg(serial->dev,
-			    usb_rcvctrlpipe(serial->dev, 0),
+			    usb_sndctrlpipe(serial->dev, 0),
 			    QT2_FLUSH_DEVICE, 0x40, 1,
 			    port_priv->device_port, NULL, 0, QT2_USB_TIMEOUT);
 
@@ -426,7 +426,7 @@ static void qt2_close(struct usb_serial_
 
 	/* flush the port receive buffer */
 	i = usb_control_msg(serial->dev,
-			    usb_rcvctrlpipe(serial->dev, 0),
+			    usb_sndctrlpipe(serial->dev, 0),
 			    QT2_FLUSH_DEVICE, 0x40, 0,
 			    port_priv->device_port, NULL, 0, QT2_USB_TIMEOUT);
 
@@ -670,7 +670,7 @@ static int qt2_attach(struct usb_serial
 	int status;
 
 	/* power on unit */
-	status = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	status = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				 0xc2, 0x40, 0x8000, 0, NULL, 0,
 				 QT2_USB_TIMEOUT);
 	if (status < 0) {


