Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5EE4932E
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfFQV20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728930AbfFQV20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:28:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 030642063F;
        Mon, 17 Jun 2019 21:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806905;
        bh=B+A0jrXQLUwkgQ3OicSor+/qD60JiGZS8SZX+l/RJbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHLoWuqfU4am+FXvA+Dg3jDYWpoHMWQZi7wGLhSHiguoSEEyTaAHIoNqoovFpKqH1
         LneNq+uXxftgXORSfNw16sLNyckKMF572NinvIZy1LdnM8dyyign20YcA5lb3vxDSE
         5RwEttkxA/WArBaWq44+0s7Qhx0lEmykoSRnK9E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Skomra <aaron.skomra@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.14 03/53] HID: wacom: Correct button numbering 2nd-gen Intuos Pro over Bluetooth
Date:   Mon, 17 Jun 2019 23:09:46 +0200
Message-Id: <20190617210745.732538492@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 6441fc781c344df61402be1fde582c4491fa35fa upstream.

The button numbering of the 2nd-gen Intuos Pro is not consistent between
the USB and Bluetooth interfaces. Over USB, the HID_GENERIC codepath
enumerates the eight ExpressKeys first (BTN_0 - BTN_7) followed by the
center modeswitch button (BTN_8). The Bluetooth codepath, however, has
the center modeswitch button as BTN_0 and the the eight ExpressKeys as
BTN_1 - BTN_8. To ensure userspace button mappings do not change
depending on how the tablet is connected, modify the Bluetooth codepath
to report buttons in the same order as USB.

To ensure the mode switch LED continues to toggle in response to the
mode switch button, the `wacom_is_led_toggled` function also requires
a small update.

Link: https://github.com/linuxwacom/input-wacom/pull/79
Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1340,7 +1340,7 @@ static void wacom_intuos_pro2_bt_pad(str
 	struct input_dev *pad_input = wacom->pad_input;
 	unsigned char *data = wacom->data;
 
-	int buttons = (data[282] << 1) | ((data[281] >> 6) & 0x01);
+	int buttons = data[282] | ((data[281] & 0x40) << 2);
 	int ring = data[285] & 0x7F;
 	bool ringstatus = data[285] & 0x80;
 	bool prox = buttons || ringstatus;
@@ -3650,7 +3650,7 @@ static void wacom_24hd_update_leds(struc
 static bool wacom_is_led_toggled(struct wacom *wacom, int button_count,
 				 int mask, int group)
 {
-	int button_per_group;
+	int group_button;
 
 	/*
 	 * 21UX2 has LED group 1 to the left and LED group 0
@@ -3660,9 +3660,12 @@ static bool wacom_is_led_toggled(struct
 	if (wacom->wacom_wac.features.type == WACOM_21UX2)
 		group = 1 - group;
 
-	button_per_group = button_count/wacom->led.count;
+	group_button = group * (button_count/wacom->led.count);
 
-	return mask & (1 << (group * button_per_group));
+	if (wacom->wacom_wac.features.type == INTUOSP2_BT)
+		group_button = 8;
+
+	return mask & (1 << group_button);
 }
 
 static void wacom_update_led(struct wacom *wacom, int button_count, int mask,


