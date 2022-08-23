Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2E959E0A8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352489AbiHWKJf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352407AbiHWKHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:07:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A2C48E9E;
        Tue, 23 Aug 2022 01:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 322F7B81C39;
        Tue, 23 Aug 2022 08:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD92C433C1;
        Tue, 23 Aug 2022 08:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244850;
        bh=0pbObdzox6CbrcgRjPxsv/HH0bIFHIjmUHHJFWXZ/p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZkUgonVhrNby4KGEiwrX1qaWkUIkRaV6kWmdyy9m5w7muTCayKhGdVFi0gaYZgb5
         b223s0uoxGJl6xfCiMkUFJirK62WX+heZT2RLRo/EyXhFKqQZF3UM4pHzIJq+YpXRF
         THE3hO+l1+Zkiw+iukebJwRtiTfI6lWVz3H6VcfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Jin <tao-j@outlook.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/244] HID: multitouch: new device class fix Lenovo X12 trackpad sticky
Date:   Tue, 23 Aug 2022 10:25:21 +0200
Message-Id: <20220823080104.611415335@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Jin <tao-j@outlook.com>

[ Upstream commit 54eed5c7b938dc4ef6b14d4ee048bbdafdbce352 ]

The trackpad of the given device sends continuous report of pointers
status as per wxn8 spec. However, the spec did not clarify when the
fingers are lifted so fast that between the interval of two report
frames fingers on pad reduced from >=2 to 0. The second last report
contains >=2 fingers with tip state 1 and the last report contains only
1 finger with tip state 0. Although this can happen unfrequently, a
  quick fix will be improve the consistency to 100%. A quick fix is to
disable MT_QUIRK_ALWAYS_VALID and enable MT_QUIRK_NOT_SEEN_MEANS_UP.

Test for hid-tools is added in [1]

In addition to this, I2C device 04CA:00B1 may also need similar class
but with MT_QUIRK_FORCE_MULTI_INPUT disabled (but it does not harm to
 enable it on non-multi-input device either). The respective owner has
been notified and a patch may coming soon after test.

[1]: https://gitlab.freedesktop.org/libevdev/hid-tools/-/merge_requests/130

Signed-off-by: Tao Jin <tao-j@outlook.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f382444dc2db..a14c48de4446 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -194,6 +194,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
 #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
 #define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
+#define MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU	0x0018
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -286,6 +287,15 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_WIN8_PTP_BUTTONS |
 			MT_QUIRK_FORCE_MULTI_INPUT,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		.quirks = MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_FORCE_MULTI_INPUT |
+			MT_QUIRK_NOT_SEEN_MEANS_UP,
+		.export_all_inputs = true },
 	{ .name = MT_CLS_WIN_8_DISABLE_WAKEUP,
 		.quirks = MT_QUIRK_ALWAYS_VALID |
 			MT_QUIRK_IGNORE_DUPLICATES |
@@ -783,6 +793,7 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONFIDENCE:
 			if ((cls->name == MT_CLS_WIN_8 ||
 			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
+			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU ||
 			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
@@ -2033,7 +2044,7 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
 
 	/* Lenovo X12 TAB Gen 1 */
-	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X12_TAB) },
-- 
2.35.1



