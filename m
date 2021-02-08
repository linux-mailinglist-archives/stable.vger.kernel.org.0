Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B831380F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhBHPgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233374AbhBHPa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BFEE64F3B;
        Mon,  8 Feb 2021 15:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797445;
        bh=W8MSarqIdqS69+5JTnBsFHEOaxYh8AoYMdo+mJgAlXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYKfTmKL/BHRCRONe83BsZHIRoZ+54NPoEaxmk3nH0jkLtUM67CaMZLb2FXFONiXw
         J/sp4Ob6Rq3U73dZkoEPBi9HlVOCYwXlyVhNWLdRC0Q52jBimvBvUBfgPVShkOaR22
         2ky51j5jqaKpKY9KtuvHc6PDSEnyzLYZo+S1PRp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 113/120] Input: ili210x - implement pressure reporting for ILI251x
Date:   Mon,  8 Feb 2021 16:01:40 +0100
Message-Id: <20210208145822.876963509@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 60159e9e7bc7e528c103b6b6d47dfd83af29669c upstream.

The ILI251x seems to report pressure information in the 5th byte of
each per-finger touch data element. On the available hardware, this
information has the values ranging from 0x0 to 0xa, which is also
matching the downstream example code. Report pressure information
on the ILI251x.

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20201224071238.160098-1-marex@denx.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ili210x.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -29,11 +29,13 @@ struct ili2xxx_chip {
 			void *buf, size_t len);
 	int (*get_touch_data)(struct i2c_client *client, u8 *data);
 	bool (*parse_touch_data)(const u8 *data, unsigned int finger,
-				 unsigned int *x, unsigned int *y);
+				 unsigned int *x, unsigned int *y,
+				 unsigned int *z);
 	bool (*continue_polling)(const u8 *data, bool touch);
 	unsigned int max_touches;
 	unsigned int resolution;
 	bool has_calibrate_reg;
+	bool has_pressure_reg;
 };
 
 struct ili210x {
@@ -82,7 +84,8 @@ static int ili210x_read_touch_data(struc
 
 static bool ili210x_touchdata_to_coords(const u8 *touchdata,
 					unsigned int finger,
-					unsigned int *x, unsigned int *y)
+					unsigned int *x, unsigned int *y,
+					unsigned int *z)
 {
 	if (touchdata[0] & BIT(finger))
 		return false;
@@ -137,7 +140,8 @@ static int ili211x_read_touch_data(struc
 
 static bool ili211x_touchdata_to_coords(const u8 *touchdata,
 					unsigned int finger,
-					unsigned int *x, unsigned int *y)
+					unsigned int *x, unsigned int *y,
+					unsigned int *z)
 {
 	u32 data;
 
@@ -169,7 +173,8 @@ static const struct ili2xxx_chip ili211x
 
 static bool ili212x_touchdata_to_coords(const u8 *touchdata,
 					unsigned int finger,
-					unsigned int *x, unsigned int *y)
+					unsigned int *x, unsigned int *y,
+					unsigned int *z)
 {
 	u16 val;
 
@@ -235,7 +240,8 @@ static int ili251x_read_touch_data(struc
 
 static bool ili251x_touchdata_to_coords(const u8 *touchdata,
 					unsigned int finger,
-					unsigned int *x, unsigned int *y)
+					unsigned int *x, unsigned int *y,
+					unsigned int *z)
 {
 	u16 val;
 
@@ -245,6 +251,7 @@ static bool ili251x_touchdata_to_coords(
 
 	*x = val & 0x3fff;
 	*y = get_unaligned_be16(touchdata + 1 + (finger * 5) + 2);
+	*z = touchdata[1 + (finger * 5) + 4];
 
 	return true;
 }
@@ -261,6 +268,7 @@ static const struct ili2xxx_chip ili251x
 	.continue_polling	= ili251x_check_continue_polling,
 	.max_touches		= 10,
 	.has_calibrate_reg	= true,
+	.has_pressure_reg	= true,
 };
 
 static bool ili210x_report_events(struct ili210x *priv, u8 *touchdata)
@@ -268,14 +276,16 @@ static bool ili210x_report_events(struct
 	struct input_dev *input = priv->input;
 	int i;
 	bool contact = false, touch;
-	unsigned int x = 0, y = 0;
+	unsigned int x = 0, y = 0, z = 0;
 
 	for (i = 0; i < priv->chip->max_touches; i++) {
-		touch = priv->chip->parse_touch_data(touchdata, i, &x, &y);
+		touch = priv->chip->parse_touch_data(touchdata, i, &x, &y, &z);
 
 		input_mt_slot(input, i);
 		if (input_mt_report_slot_state(input, MT_TOOL_FINGER, touch)) {
 			touchscreen_report_pos(input, &priv->prop, x, y, true);
+			if (priv->chip->has_pressure_reg)
+				input_report_abs(input, ABS_MT_PRESSURE, z);
 			contact = true;
 		}
 	}
@@ -437,6 +447,8 @@ static int ili210x_i2c_probe(struct i2c_
 	max_xy = (chip->resolution ?: SZ_64K) - 1;
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, max_xy, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, max_xy, 0, 0);
+	if (priv->chip->has_pressure_reg)
+		input_set_abs_params(input, ABS_MT_PRESSURE, 0, 0xa, 0, 0);
 	touchscreen_parse_properties(input, true, &priv->prop);
 
 	error = input_mt_init_slots(input, priv->chip->max_touches,


