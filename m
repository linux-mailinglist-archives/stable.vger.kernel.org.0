Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C8C3642B4
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbhDSNLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239562AbhDSNKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A772F61288;
        Mon, 19 Apr 2021 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837803;
        bh=5x1SmBefa/kSnntTEvpcxavC7fKBCuwyfcpGWdvwOgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpiDDyM73IANmF/eSSV+ghCkitdCAz2z062p6EehZAfrD8pZ1UZaE1OvpQifqqda4
         DFNZ/ylzN/2auZSlZWYSXM13zloEOhelM9Rb9+bOyg0/9pz7sKeOf3WkVFPbqFPa0+
         5fp02cgF44opN8Q7g4tFmKdBSeLPxwlIqwr9NoY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>,
        Jason Gerecke <Jason.Gerecke@wacom.com>,
        Juan Garrido <Juan.Garrido@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.11 058/122] HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices
Date:   Mon, 19 Apr 2021 15:05:38 +0200
Message-Id: <20210419130532.154702469@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping Cheng <pinglinux@gmail.com>

commit 276559d8d02c2709281578976ca2f53bc62063d4 upstream.

Valid HID_GENERIC type of devices set EV_KEY and EV_ABS by wacom_map_usage.
When *_input_capabilities are reached, those devices should already have
their proper EV_* set. EV_KEY and EV_ABS only need to be set for
non-HID_GENERIC type of devices in *_input_capabilities.

Devices that don't support HID descitoprs will pass back to hid-input for
registration without being accidentally rejected by the introduction of
patch: "Input: refuse to register absolute devices without absinfo"

Fixes: 6ecfe51b4082 ("Input: refuse to register absolute devices without absinfo")
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <Jason.Gerecke@wacom.com>
Tested-by: Juan Garrido <Juan.Garrido@wacom.com>
CC: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3574,8 +3574,6 @@ int wacom_setup_pen_input_capabilities(s
 {
 	struct wacom_features *features = &wacom_wac->features;
 
-	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-
 	if (!(features->device_type & WACOM_DEVICETYPE_PEN))
 		return -ENODEV;
 
@@ -3590,6 +3588,7 @@ int wacom_setup_pen_input_capabilities(s
 		return 0;
 	}
 
+	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(ABS_MISC, input_dev->absbit);
 
@@ -3742,8 +3741,6 @@ int wacom_setup_touch_input_capabilities
 {
 	struct wacom_features *features = &wacom_wac->features;
 
-	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3756,6 +3753,7 @@ int wacom_setup_touch_input_capabilities
 		/* setup has already been done */
 		return 0;
 
+	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 
 	if (features->touch_max == 1) {


