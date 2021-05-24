Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D138E320
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 11:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhEXJSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232313AbhEXJSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 05:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE68E60FE7;
        Mon, 24 May 2021 09:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621847843;
        bh=AEdXl0yOkNxGu8Z2KHUxXg9KFkc7Dxr7RFwj4gYtUlo=;
        h=From:To:Cc:Subject:Date:From;
        b=Sp1WXFOR6b2e8ozm+ZjRWCt+tT0Tyn/Xndq0hIidaLdXs2thwnvN2wHomhmagrGaE
         Z4rUv5wYr22iom2/sz7Rbc+YCu6R+ThjXFNNgS725N/0GXvN3LLe2mBCq+vSiCgjjA
         PbKbTRNOorC1iZo1rStTOJaFP/IyIztp/xKja0hlW7M/AwOkNFF2pOn7C3F2oHilUe
         blO0P8gLOY+eF4fKxF/rVByCoUafYV/fUGvbSHgtA3bJei6H5r3bfWZhsW9x0289ry
         H/P9M/zkcqdv8VRbeWJp01REK+TfNykS60xQMW+lTQFhwk4+xocu7dxa+lefv4aUVL
         1DtVV+B0KXfVg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll6i8-000182-4i; Mon, 24 May 2021 11:17:20 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] USB: serial: quatech2: fix control-request directions
Date:   Mon, 24 May 2021 11:17:05 +0200
Message-Id: <20210524091705.4282-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the three requests which erroneously used usb_rcvctrlpipe().

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable@vger.kernel.org      # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Changes in v2
 - fix also the request in attach

 drivers/usb/serial/quatech2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 3b5f2032ecdb..b0bb889f002c 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -416,7 +416,7 @@ static void qt2_close(struct usb_serial_port *port)
 
 	/* flush the port transmit buffer */
 	i = usb_control_msg(serial->dev,
-			    usb_rcvctrlpipe(serial->dev, 0),
+			    usb_sndctrlpipe(serial->dev, 0),
 			    QT2_FLUSH_DEVICE, 0x40, 1,
 			    port_priv->device_port, NULL, 0, QT2_USB_TIMEOUT);
 
@@ -426,7 +426,7 @@ static void qt2_close(struct usb_serial_port *port)
 
 	/* flush the port receive buffer */
 	i = usb_control_msg(serial->dev,
-			    usb_rcvctrlpipe(serial->dev, 0),
+			    usb_sndctrlpipe(serial->dev, 0),
 			    QT2_FLUSH_DEVICE, 0x40, 0,
 			    port_priv->device_port, NULL, 0, QT2_USB_TIMEOUT);
 
@@ -639,7 +639,7 @@ static int qt2_attach(struct usb_serial *serial)
 	int status;
 
 	/* power on unit */
-	status = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	status = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 				 0xc2, 0x40, 0x8000, 0, NULL, 0,
 				 QT2_USB_TIMEOUT);
 	if (status < 0) {
-- 
2.26.3

