Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC2B316506
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 12:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhBJLUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 06:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229821AbhBJLSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 06:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C67B164E26;
        Wed, 10 Feb 2021 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612955862;
        bh=ep9aqBccEo3Q+DUsVeYKcKl0VwkmbviIE4BxIZxrgAY=;
        h=From:To:Cc:Subject:Date:From;
        b=LEvXVRCucnXRbUatcTF+usJqFQGWNAIKBtEjMqMVHUzOJ5GGu1mjONLaApkDQfBeG
         XaTfggSxnCq8Mf+083AQJw3wHuKzAwGEZgzT7nC1Z99wM2WsWA6jlBBrhcPdGVmjZt
         5CKMDpqAX0H2jFYakJM8vOIab/mZhHLph/H5kisFIc3DeQ2D/OdO+U2n5CmvXWDIyj
         ahSmoPmPG78JFClH4Swp305oZv3EC1ViHKi4UAXRa2rz2z6kw6+2YH/+KYM9YoeOm3
         X1gq4V86H8dmL67Lpxbgbnb5Rxrlvxi2I8naTWiPvkZVNdlDgTgUBRZbXKJT82y7Xk
         KentrUUeIssyg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l9nVM-0003UD-FR; Wed, 10 Feb 2021 12:17:57 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] USB: quirks: sort quirk entries
Date:   Wed, 10 Feb 2021 12:17:46 +0100
Message-Id: <20210210111746.13360-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Move the last entry to its proper place to maintain the VID/PID sort
order.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/core/quirks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 1b4eb7046b07..66a0dc618dfc 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -415,6 +415,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =
 			USB_QUIRK_STRING_FETCH_255 },
 
+	/* novation SoundControl XL */
+	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
@@ -495,9 +498,6 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* novation SoundControl XL */
-	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
-
 	{ }  /* terminating entry must be last */
 };
 
-- 
2.26.2

