Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEF93DB882
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 14:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238742AbhG3MXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 08:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhG3MXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 08:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D9660F0F;
        Fri, 30 Jul 2021 12:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627647814;
        bh=bPik6kInDNnV6gh3+hQKpM2WNZeBL0CbzIVEhgD+rMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4oBdkGd+2sCLaXRtb1oRBWbXKQLfmaav2fHnpuTaXExwWmG0rK4pDzoYR9jfnaJ7
         vun0Z/fd//kPxFSDdbDSf20wkbyRtK9wjcOEs+vl6YMyFuiwCvWZh8JFb0gGPBowOK
         h/GZhLcStDKhKx9AUfg6mAzeU5GFx9C0FbYfz2HVguK/N5+ge4+4xmn3SAqtFWjr/X
         lt1Tw/5MB2uI9H05IgQy5bP1vvA1UACplZ6KRFx2Jsnwi7t+mXqt7sjog0ieqnpddb
         I9Q9PLIUqNrDNzbCiAEbJmwgPLXLkClaXcXuLIep2vrGIznn/IGoOq7wrnGrOkfUTN
         KsujCt1ZocPmQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m9RXU-0000Cc-N2; Fri, 30 Jul 2021 14:22:57 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Charles Yeh <charlesyeh522@gmail.com>,
        =?UTF-8?q?Yeh=2ECharles=20=5B=E8=91=89=E6=A6=AE=E9=91=AB=5D?= 
        <charles-yeh@prolific.com.tw>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris <chris@cyber-anlage.de>,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: pl2303: fix HX type detection
Date:   Fri, 30 Jul 2021 14:21:56 +0200
Message-Id: <20210730122156.718-1-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YQPsgPey1V+7ccGq@hovoldconsulting.com>
References: <YQPsgPey1V+7ccGq@hovoldconsulting.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The device release number for HX-type devices is configurable in
EEPROM/OTPROM and cannot be used reliably for type detection.

Assume all (non-H) devices with bcdUSB 1.1 and unknown bcdDevice to be
of HX type while adding a bcdDevice check for HXD and TB (1.1 and 2.0,
respectively).

Reported-by: Chris <chris@cyber-anlage.de>
Fixes: 8a7bf7510d1f ("USB: serial: pl2303: amend and tighten type detection")
Cc: stable@vger.kernel.org	# 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/pl2303.c | 41 ++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 2f2f5047452b..17601e32083e 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -418,24 +418,33 @@ static int pl2303_detect_type(struct usb_serial *serial)
 	bcdDevice = le16_to_cpu(desc->bcdDevice);
 	bcdUSB = le16_to_cpu(desc->bcdUSB);
 
-	switch (bcdDevice) {
-	case 0x100:
-		/*
-		 * Assume it's an HXN-type if the device doesn't support the old read
-		 * request value.
-		 */
-		if (bcdUSB == 0x200 && !pl2303_supports_hx_status(serial))
-			return TYPE_HXN;
+	switch (bcdUSB) {
+	case 0x110:
+		switch (bcdDevice) {
+		case 0x300:
+			return TYPE_HX;
+		case 0x400:
+			return TYPE_HXD;
+		default:
+			return TYPE_HX;
+		}
 		break;
-	case 0x300:
-		if (bcdUSB == 0x200)
+	case 0x200:
+		switch (bcdDevice) {
+		case 0x100:
+			/*
+			 * Assume it's an HXN-type if the device doesn't
+			 * support the old read request value.
+			 */
+			if (!pl2303_supports_hx_status(serial))
+				return TYPE_HXN;
+			break;
+		case 0x300:
 			return TYPE_TA;
-
-		return TYPE_HX;
-	case 0x400:
-		return TYPE_HXD;
-	case 0x500:
-		return TYPE_TB;
+		case 0x500:
+			return TYPE_TB;
+		}
+		break;
 	}
 
 	dev_err(&serial->interface->dev,
-- 
2.31.1

