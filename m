Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC820493E9
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfFQVeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:34:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbfFQVY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE2D206B7;
        Mon, 17 Jun 2019 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806698;
        bh=igOdzN89KKVX8A3h5h5NoYHgXU5ZTK3QVBO+0ZZ7Sbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/ksfGSn9PzWWgzY8t2BrwbKDI2QQJWKKxDnpCdI8IA1W/JxpdckBssghpefb74J5
         4uoiiz+IGtIQptc6trzdKwGy50n4xIGt0K7o4VkR5dZQGKcDiUFEtTTDv04UoMNyIm
         Mso8uEZGL3oKKajucvIE8BEqcMjAT82o8hKTDp5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.19 05/75] HID: wacom: Dont report anything prior to the tool entering range
Date:   Mon, 17 Jun 2019 23:09:16 +0200
Message-Id: <20190617210753.036762812@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc upstream.

If the tool spends some time in prox before entering range, a series of
events (e.g. ABS_DISTANCE, MSC_SERIAL) can be sent before we or userspace
have any clue about the pen whose data is being reported. We need to hold
off on reporting anything until the pen has entered range. Since we still
want to report events that occur "in prox" after the pen has *left* range
we use 'wacom-tool[0]' as the indicator that the pen did at one point
enter range and provide us/userspace with tool type and serial number
information.

Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1288,23 +1288,26 @@ static void wacom_intuos_pro2_bt_pen(str
 						 get_unaligned_le16(&frame[11]));
 			}
 		}
-		input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
-		if (wacom->features.type == INTUOSP2_BT) {
-			input_report_abs(pen_input, ABS_DISTANCE,
-					 range ? frame[13] : wacom->features.distance_max);
-		} else {
-			input_report_abs(pen_input, ABS_DISTANCE,
-					 range ? frame[7] : wacom->features.distance_max);
-		}
 
-		input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
-		input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
-		input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
+		if (wacom->tool[0]) {
+			input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
+			if (wacom->features.type == INTUOSP2_BT) {
+				input_report_abs(pen_input, ABS_DISTANCE,
+						 range ? frame[13] : wacom->features.distance_max);
+			} else {
+				input_report_abs(pen_input, ABS_DISTANCE,
+						 range ? frame[7] : wacom->features.distance_max);
+			}
+
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
+			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
 
-		input_report_key(pen_input, wacom->tool[0], prox);
-		input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
-		input_report_abs(pen_input, ABS_MISC,
-				 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+			input_report_key(pen_input, wacom->tool[0], prox);
+			input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
+			input_report_abs(pen_input, ABS_MISC,
+					 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+		}
 
 		wacom->shared->stylus_in_proximity = prox;
 


