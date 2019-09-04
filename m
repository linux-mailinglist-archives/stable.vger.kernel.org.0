Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1B9A8DF7
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbfIDRzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731852AbfIDRzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72EA822CED;
        Wed,  4 Sep 2019 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619719;
        bh=uSIP8u8DY++aF/wMqdAfQwS0BjIVacNJen3OVr0tJrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWN3x2sCvHyJc4wkLw/cCb1s7X8JaHzLzYCbmNsLDT0caIMLkauQGHQIuNCF3h+Bb
         hr711Yr8B/Ar2DAKMS4g6cYbJ0ghmLXu4r8q2bxXEqp+X0vnAD4e+RAC9aB/JqQzZ5
         nwZSSBQwvImtv45GC1Q9LSBM4WCUhVame25YSv8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Trukhanov <lahvuun@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/77] HID: Add 044f:b320 ThrustMaster, Inc. 2 in 1 DT
Date:   Wed,  4 Sep 2019 19:52:48 +0200
Message-Id: <20190904175303.454565485@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 65f11c72780fa9d598df88def045ccb6a885cf80 ]

Enable force feedback for the Thrustmaster Dual Trigger 2 in 1 Rumble Force
gamepad. Compared to other Thrustmaster devices, left and right rumble
motors here are swapped.

Signed-off-by: Ilya Trukhanov <lahvuun@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-tmff.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index b83376077d722..cfa0cb22c9b3c 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -34,6 +34,8 @@
 
 #include "hid-ids.h"
 
+#define THRUSTMASTER_DEVICE_ID_2_IN_1_DT	0xb320
+
 static const signed short ff_rumble[] = {
 	FF_RUMBLE,
 	-1
@@ -88,6 +90,7 @@ static int tmff_play(struct input_dev *dev, void *data,
 	struct hid_field *ff_field = tmff->ff_field;
 	int x, y;
 	int left, right;	/* Rumbling */
+	int motor_swap;
 
 	switch (effect->type) {
 	case FF_CONSTANT:
@@ -112,6 +115,13 @@ static int tmff_play(struct input_dev *dev, void *data,
 					ff_field->logical_minimum,
 					ff_field->logical_maximum);
 
+		/* 2-in-1 strong motor is left */
+		if (hid->product == THRUSTMASTER_DEVICE_ID_2_IN_1_DT) {
+			motor_swap = left;
+			left = right;
+			right = motor_swap;
+		}
+
 		dbg_hid("(left,right)=(%08x, %08x)\n", left, right);
 		ff_field->value[0] = left;
 		ff_field->value[1] = right;
@@ -238,6 +248,8 @@ static const struct hid_device_id tm_devices[] = {
 		.driver_data = (unsigned long)ff_rumble },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),   /* FireStorm Dual Power 2 (and 3) */
 		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, THRUSTMASTER_DEVICE_ID_2_IN_1_DT),   /* Dual Trigger 2-in-1 */
+		.driver_data = (unsigned long)ff_rumble },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323),   /* Dual Trigger 3-in-1 (PC Mode) */
 		.driver_data = (unsigned long)ff_rumble },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324),   /* Dual Trigger 3-in-1 (PS3 Mode) */
-- 
2.20.1



