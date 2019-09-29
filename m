Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7244C1599
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfI2OBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbfI2OBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:01:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A8721835;
        Sun, 29 Sep 2019 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765705;
        bh=kIPGBHPBXLNlAwGmoPfJpsWmba/5nJ1VTP4Y2cSafRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l9p2NtcmG1J75LlLbxOpL8Gad5JY1iRCrXzyZysTfJ08dlt2Ll2yLV0Qm0tvCCq8
         9+4BaYJ2eXrM9+4sF4f51ltmjYFUzTAsHyM9TgXJK+NSJ/g+FeWpJ9/2cN4Uww5PDO
         yP9HsBymDt/tZbgFjIySsKbfPYwF6akezzTTClP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 5.2 21/45] Revert "HID: logitech-hidpp: add USB PID for a few more supported mice"
Date:   Sun, 29 Sep 2019 15:55:49 +0200
Message-Id: <20190929135030.591928130@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit addf3382c47c033e579c9c88f18e36c4e75d806a upstream.

This partially reverts commit 27fc32fd9417968a459d43d9a7c50fd423d53eb9.

It turns out that the G502 has some issues with hid-logitech-hidpp:
when plugging it in, the driver tries to contact it but it fails.
So the driver bails out leaving only the mouse event node available.

This timeout is problematic as it introduce a delay in the boot,
and having only the mouse event node means that the hardware
macros keys can not be relayed to the userspace.

Filipe and I just gave a shot at the following devices:

G403 Wireless (0xC082)
G703 (0xC087)
G703 Hero (0xC090)
G903 (0xC086)
G903 Hero (0xC091)
G Pro (0xC088)

Reverting the devices we are not sure that works flawlessly.

Reviewed-by: Filipe Laíns <lains@archlinux.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jeremy Cline <jcline@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-hidpp.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3749,28 +3749,8 @@ static const struct hid_device_id hidpp_
 
 	{ L27MHZ_DEVICE(HID_ANY_ID) },
 
-	{ /* Logitech G203/Prodigy Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC084) },
-	{ /* Logitech G302 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07F) },
-	{ /* Logitech G303 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC080) },
-	{ /* Logitech G400 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07E) },
 	{ /* Logitech G403 Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
-	{ /* Logitech G403 Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC083) },
-	{ /* Logitech G403 Hero Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08F) },
-	{ /* Logitech G502 Proteus Core Gaming Mouse */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07D) },
-	{ /* Logitech G502 Proteus Spectrum Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC332) },
-	{ /* Logitech G502 Hero Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08B) },
-	{ /* Logitech G700s Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC07C) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */


