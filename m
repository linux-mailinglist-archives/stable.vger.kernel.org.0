Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 831A6745B3
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405154AbfGYFpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405147AbfGYFpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4BDA22BEB;
        Thu, 25 Jul 2019 05:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033519;
        bh=zPsCyeore4QByTeWfah3hRE9uGuH/wF0goEemZD+vX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3xU0EYBfnGQFsIjxXboHE0pkkWhom62KOrkWIgd9o0EcA/cGrXbrMEJV8FZ1Rtii
         qcEFKGQU2LgbhLv6Ns5WAIxuwp3Yqd1UZJdP4eXb5QP7JMWUev1RPQzcwUAU+21REF
         zwVC5Lk53x91MjTtNgSJPOGatvgJ1fB3kKq26FIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 236/271] HID: wacom: generic: only switch the mode on devices with LEDs
Date:   Wed, 24 Jul 2019 21:21:45 +0200
Message-Id: <20190724191715.384398661@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Armstrong Skomra <skomra@gmail.com>

commit d8e9806005f28bbb49899dab2068e3359e22ba35 upstream.

Currently, the driver will attempt to set the mode on all
devices with a center button, but some devices with a center
button lack LEDs, and attempting to set the LEDs on devices
without LEDs results in the kernel error message of the form:

"leds input8::wacom-0.1: Setting an LED's brightness failed (-32)"

This is because the generic codepath erroneously assumes that the
BUTTON_CENTER usage indicates that the device has LEDs, the
previously ignored TOUCH_RING_SETTING usage is a more accurate
indication of the existence of LEDs on the device.

Fixes: 10c55cacb8b2 ("HID: wacom: generic: support LEDs")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_sys.c |    3 +++
 drivers/hid/wacom_wac.c |    2 --
 drivers/hid/wacom_wac.h |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -275,6 +275,9 @@ static void wacom_feature_mapping(struct
 	wacom_hid_usage_quirk(hdev, field, usage);
 
 	switch (equivalent_usage) {
+	case WACOM_HID_WD_TOUCH_RING_SETTING:
+		wacom->generic_has_leds = true;
+		break;
 	case HID_DG_CONTACTMAX:
 		/* leave touch_max as is if predefined */
 		if (!features->touch_max) {
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1928,8 +1928,6 @@ static void wacom_wac_pad_usage_mapping(
 		features->device_type |= WACOM_DEVICETYPE_PAD;
 		break;
 	case WACOM_HID_WD_BUTTONCENTER:
-		wacom->generic_has_leds = true;
-		/* fall through */
 	case WACOM_HID_WD_BUTTONHOME:
 	case WACOM_HID_WD_BUTTONUP:
 	case WACOM_HID_WD_BUTTONDOWN:
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -145,6 +145,7 @@
 #define WACOM_HID_WD_OFFSETBOTTOM       (WACOM_HID_UP_WACOMDIGITIZER | 0x0d33)
 #define WACOM_HID_WD_DATAMODE           (WACOM_HID_UP_WACOMDIGITIZER | 0x1002)
 #define WACOM_HID_WD_DIGITIZERINFO      (WACOM_HID_UP_WACOMDIGITIZER | 0x1013)
+#define WACOM_HID_WD_TOUCH_RING_SETTING (WACOM_HID_UP_WACOMDIGITIZER | 0x1032)
 #define WACOM_HID_UP_G9                 0xff090000
 #define WACOM_HID_G9_PEN                (WACOM_HID_UP_G9 | 0x02)
 #define WACOM_HID_G9_TOUCHSCREEN        (WACOM_HID_UP_G9 | 0x11)


