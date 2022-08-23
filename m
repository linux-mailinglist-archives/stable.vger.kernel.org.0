Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E305859E266
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353927AbiHWKYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353870AbiHWKTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3659C80F52;
        Tue, 23 Aug 2022 02:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CC256123D;
        Tue, 23 Aug 2022 09:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C71C433C1;
        Tue, 23 Aug 2022 09:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245310;
        bh=ipq2pS/8t4yHP6Fqk/y+1ZASECAh1Sf6kp7qJO6XM+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CChWWDZ6pXpZW3c4/oWJ09apHQJTMdDMa75yOSwf7f9je+uLa/2N1OBDdKghKslCX
         glqiHzmSg9UCTbcb4QJyBrFZDGAVSz+rzfUfCnNozA0uqcPD2ws5GaBTOr+/xPQYE2
         w7pB/6i0ONglrpj/Ltp2yhYe1mHjHktgSctndTzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 008/287] HID: wacom: Dont register pad_input for touch switch
Date:   Tue, 23 Aug 2022 10:22:57 +0200
Message-Id: <20220823080100.545612301@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Ping Cheng <pinglinux@gmail.com>

commit d6b675687a4ab4dba684716d97c8c6f81bf10905 upstream.

Touch switch state is received through WACOM_PAD_FIELD. However, it
is reported by touch_input. Don't register pad_input if no other pad
events require the interface.

Cc: stable@vger.kernel.org
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    2 +-
 drivers/hid/wacom_wac.c |   43 +++++++++++++++++++++++++------------------
 2 files changed, 26 insertions(+), 19 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2095,7 +2095,7 @@ static int wacom_register_inputs(struct
 
 	error = wacom_setup_pad_input_capabilities(pad_input_dev, wacom_wac);
 	if (error) {
-		/* no pad in use on this interface */
+		/* no pad events using this interface */
 		input_free_device(pad_input_dev);
 		wacom_wac->pad_input = NULL;
 		pad_input_dev = NULL;
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1954,7 +1954,6 @@ static void wacom_wac_pad_usage_mapping(
 		wacom_wac->has_mute_touch_switch = true;
 		usage->type = EV_SW;
 		usage->code = SW_MUTE_DEVICE;
-		features->device_type |= WACOM_DEVICETYPE_PAD;
 		break;
 	case WACOM_HID_WD_TOUCHSTRIP:
 		wacom_map_usage(input, usage, field, EV_ABS, ABS_RX, 0);
@@ -2034,6 +2033,30 @@ static void wacom_wac_pad_event(struct h
 			wacom_wac->hid_data.inrange_state |= value;
 	}
 
+	/* Process touch switch state first since it is reported through touch interface,
+	 * which is indepentent of pad interface. In the case when there are no other pad
+	 * events, the pad interface will not even be created.
+	 */
+	if ((equivalent_usage == WACOM_HID_WD_MUTE_DEVICE) ||
+	   (equivalent_usage == WACOM_HID_WD_TOUCHONOFF)) {
+		if (wacom_wac->shared->touch_input) {
+			bool *is_touch_on = &wacom_wac->shared->is_touch_on;
+
+			if (equivalent_usage == WACOM_HID_WD_MUTE_DEVICE && value)
+				*is_touch_on = !(*is_touch_on);
+			else if (equivalent_usage == WACOM_HID_WD_TOUCHONOFF)
+				*is_touch_on = value;
+
+			input_report_switch(wacom_wac->shared->touch_input,
+					    SW_MUTE_DEVICE, !(*is_touch_on));
+			input_sync(wacom_wac->shared->touch_input);
+		}
+		return;
+	}
+
+	if (!input)
+		return;
+
 	switch (equivalent_usage) {
 	case WACOM_HID_WD_TOUCHRING:
 		/*
@@ -2063,22 +2086,6 @@ static void wacom_wac_pad_event(struct h
 			input_event(input, usage->type, usage->code, 0);
 		break;
 
-	case WACOM_HID_WD_MUTE_DEVICE:
-	case WACOM_HID_WD_TOUCHONOFF:
-		if (wacom_wac->shared->touch_input) {
-			bool *is_touch_on = &wacom_wac->shared->is_touch_on;
-
-			if (equivalent_usage == WACOM_HID_WD_MUTE_DEVICE && value)
-				*is_touch_on = !(*is_touch_on);
-			else if (equivalent_usage == WACOM_HID_WD_TOUCHONOFF)
-				*is_touch_on = value;
-
-			input_report_switch(wacom_wac->shared->touch_input,
-					    SW_MUTE_DEVICE, !(*is_touch_on));
-			input_sync(wacom_wac->shared->touch_input);
-		}
-		break;
-
 	case WACOM_HID_WD_MODE_CHANGE:
 		if (wacom_wac->is_direct_mode != value) {
 			wacom_wac->is_direct_mode = value;
@@ -2719,7 +2726,7 @@ void wacom_wac_event(struct hid_device *
 	/* usage tests must precede field tests */
 	if (WACOM_BATTERY_USAGE(usage))
 		wacom_wac_battery_event(hdev, field, usage, value);
-	else if (WACOM_PAD_FIELD(field) && wacom->wacom_wac.pad_input)
+	else if (WACOM_PAD_FIELD(field))
 		wacom_wac_pad_event(hdev, field, usage, value);
 	else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
 		wacom_wac_pen_event(hdev, field, usage, value);


