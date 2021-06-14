Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7440D3A645D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhFNLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235362AbhFNLWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A13161438;
        Mon, 14 Jun 2021 10:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667944;
        bh=32Cie78WcU2RXZccCpobeXEb38nYkx9bFQdJIO/nR5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXbPMURO94iWPbfFwQUG/Nj3/eEvtN6dngiFmeSPvPItcY6I/NZv6CoEyF2d/QXvq
         eFDU3aNtA1M9r1w+gsBb8UNJBjcnsLcTXyqF9XWQLvrAB28Nz3K9EjnTfFHP13cckr
         L/hQ5Z6Ik+cca9gjhKXf98ZgESPcUlzHj0jUQXmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 102/173] USB: serial: quatech2: fix control-request directions
Date:   Mon, 14 Jun 2021 12:27:14 +0200
Message-Id: <20210614102701.558124995@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
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
 
@@ -654,7 +654,7 @@ static int qt2_attach(struct usb_serial
 	int status;
 
 	/* power on unit */
-	status = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	status = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				 0xc2, 0x40, 0x8000, 0, NULL, 0,
 				 QT2_USB_TIMEOUT);
 	if (status < 0) {


