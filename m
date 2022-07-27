Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68C2582B76
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiG0Qdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237848AbiG0QdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:33:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0418E54ACE;
        Wed, 27 Jul 2022 09:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA2F9619F6;
        Wed, 27 Jul 2022 16:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E302BC433C1;
        Wed, 27 Jul 2022 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939173;
        bh=J7u/vvB8Zs3W1i9AnlFem8HQrWzcHF81LZifj3tjOak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsNYCgOk7O0DLSisfp5DZlFUboRQtTFXBClEDtL+tikR+Y0QgwAQrWvN01jTA88ns
         B04520Q2/JbD97EtgdAPYkuRZR7c66a9DEwO8LxTHoZBA57TBMX68kWXMWQZSwU0PM
         h+8hv9ym/NtzQEZGm9a1l/UYbMl9wHqJrUu1WqoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/62] HID: multitouch: simplify the application retrieval
Date:   Wed, 27 Jul 2022 18:10:47 +0200
Message-Id: <20220727161005.678048255@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

[ Upstream commit 7ffa13be4945b2f60dfe6c71acbc1fdcfc4629a0 ]

Now that the application is simply stored in struct hid_input, we can
overwrite it in mt_input_mapping() for the faulty egalax and have a
simpler suffix processing in mt_input_configured()

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 72 ++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e99286258f62..5509b09f8656 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1332,6 +1332,13 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		return mt_touch_input_mapping(hdev, hi, field, usage, bit, max,
 					      application);
 
+	/*
+	 * some egalax touchscreens have "application == DG_TOUCHSCREEN"
+	 * for the stylus. Overwrite the hid_input application
+	 */
+	if (field->physical == HID_DG_STYLUS)
+		hi->application = HID_DG_STYLUS;
+
 	/* let hid-core decide for the others */
 	return 0;
 }
@@ -1520,14 +1527,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	struct mt_device *td = hid_get_drvdata(hdev);
 	char *name;
 	const char *suffix = NULL;
-	unsigned int application = 0;
 	struct mt_report_data *rdata;
 	struct mt_application *mt_application = NULL;
 	struct hid_report *report;
 	int ret;
 
 	list_for_each_entry(report, &hi->reports, hidinput_list) {
-		application = report->application;
 		rdata = mt_find_report_data(td, report);
 		if (!rdata) {
 			hid_err(hdev, "failed to allocate data for report\n");
@@ -1542,46 +1547,33 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 			if (ret)
 				return ret;
 		}
-
-		/*
-		 * some egalax touchscreens have "application == DG_TOUCHSCREEN"
-		 * for the stylus. Check this first, and then rely on
-		 * the application field.
-		 */
-		if (report->field[0]->physical == HID_DG_STYLUS) {
-			suffix = "Pen";
-			/* force BTN_STYLUS to allow tablet matching in udev */
-			__set_bit(BTN_STYLUS, hi->input->keybit);
-		}
 	}
 
-	if (!suffix) {
-		switch (application) {
-		case HID_GD_KEYBOARD:
-		case HID_GD_KEYPAD:
-		case HID_GD_MOUSE:
-		case HID_DG_TOUCHPAD:
-		case HID_GD_SYSTEM_CONTROL:
-		case HID_CP_CONSUMER_CONTROL:
-		case HID_GD_WIRELESS_RADIO_CTLS:
-		case HID_GD_SYSTEM_MULTIAXIS:
-			/* already handled by hid core */
-			break;
-		case HID_DG_TOUCHSCREEN:
-			/* we do not set suffix = "Touchscreen" */
-			hi->input->name = hdev->name;
-			break;
-		case HID_DG_STYLUS:
-			/* force BTN_STYLUS to allow tablet matching in udev */
-			__set_bit(BTN_STYLUS, hi->input->keybit);
-			break;
-		case HID_VD_ASUS_CUSTOM_MEDIA_KEYS:
-			suffix = "Custom Media Keys";
-			break;
-		default:
-			suffix = "UNKNOWN";
-			break;
-		}
+	switch (hi->application) {
+	case HID_GD_KEYBOARD:
+	case HID_GD_KEYPAD:
+	case HID_GD_MOUSE:
+	case HID_DG_TOUCHPAD:
+	case HID_GD_SYSTEM_CONTROL:
+	case HID_CP_CONSUMER_CONTROL:
+	case HID_GD_WIRELESS_RADIO_CTLS:
+	case HID_GD_SYSTEM_MULTIAXIS:
+		/* already handled by hid core */
+		break;
+	case HID_DG_TOUCHSCREEN:
+		/* we do not set suffix = "Touchscreen" */
+		hi->input->name = hdev->name;
+		break;
+	case HID_DG_STYLUS:
+		/* force BTN_STYLUS to allow tablet matching in udev */
+		__set_bit(BTN_STYLUS, hi->input->keybit);
+		break;
+	case HID_VD_ASUS_CUSTOM_MEDIA_KEYS:
+		suffix = "Custom Media Keys";
+		break;
+	default:
+		suffix = "UNKNOWN";
+		break;
 	}
 
 	if (suffix) {
-- 
2.35.1



