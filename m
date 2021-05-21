Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0991638C82D
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhEUNeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhEUNeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34A2610CB;
        Fri, 21 May 2021 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621603976;
        bh=Rn+wTokD0xjQeGvVUvsRGt44Ve3Prl0d2vf0pLTXhpI=;
        h=From:To:Cc:Subject:Date:From;
        b=pv0hfh50Zemq6yDRyDu41l+dhIBT0hDlgN++nm0I5dMaaFalcv+Mdn8GoUs1KAdOZ
         iAO/j3Or9akONb819HYlVr2K+jm7O/iEwSS8LBxaiUyJEr389ibJuwLkLMCb9JDf2h
         InPWPrjZ8ewNhIYHAtAjRVg0dlgp3s4y/WD/q5+vY6/+DwZaNQe9HLbiA7LLwadE1w
         dT+6U1t6I8FxWuUOUz7FQYWc7M1oDyESvJ3MHaHwOk+gW5BoCyA22nzGvp1N/F9tzU
         ZdcZETPR3JIC+qaFd0bhwx4tj8aa61wUPuOtH51HxoitJiL99E3TZ9QmZYWAu+jYLJ
         yVlV4rQ9FHt5A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk5Gr-0004Z8-4O; Fri, 21 May 2021 15:32:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: quatech2: fix control-request directions
Date:   Fri, 21 May 2021 15:32:31 +0200
Message-Id: <20210521133231.17488-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the two QT2_FLUSH_DEVICE requests which erroneously used
usb_rcvctrlpipe().

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable@vger.kernel.org      # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/quatech2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 3b5f2032ecdb..a9ff3904375f 100644
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
 
-- 
2.26.3

