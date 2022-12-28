Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B865832F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbiL1Qox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiL1QoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A661C934
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:39:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D347B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880DDC433D2;
        Wed, 28 Dec 2022 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245595;
        bh=8cNekZ4Ly99pLxeUE847IppAKRmEzQ5qOYdrADTmNG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9HMCwxG0RG2qzJg1l4WsT5jzl8sWvNnb6lwyzGtC3IVdoC0iMyVzkgtp227ZN5Aq
         j/BNL6HUecOhaOkvxgAjQWv6xdzum6nakb5esDmz9rb1pCqZ2xjUbXaTr38Zbm4E/T
         qvmPxMz+50OpCQ3a4oi7LYwk1yObZjUm8DQmSfYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kerem Karabay <kekrby@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0920/1073] HID: apple: fix key translations where multiple quirks attempt to translate the same key
Date:   Wed, 28 Dec 2022 15:41:48 +0100
Message-Id: <20221228144353.016620191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 5476fcf7f7b901db1cea92acb1abdd12609e30e1 ]

The hid-apple driver does not support chaining translations or
dependencies on other translations. This creates two problems:

1 - In Non-English keyboards of Macs, KEY_102ND and KEY_GRAVE are
swapped and the APPLE_ISO_TILDE_QUIRK is used to work around this
problem. The quirk is not set for the Macs where these bugs happen yet
(see the 2nd patch for that), but this can be forced by setting the
iso_layout parameter. Unfortunately, this only partially works.
KEY_102ND gets translated to KEY_GRAVE, but KEY_GRAVE does not get
translated to KEY_102ND, so both of them end up functioning as
KEY_GRAVE. This is because the driver translates the keys as if Fn was
pressed and the original is sent if it is not pressed, without any
further translations happening on the key[#463]. KEY_GRAVE is present at
macbookpro_no_esc_fn_keys[#195], so this is what happens:

    - KEY_GRAVE -> KEY_ESC (as if Fn is pressed)
    - KEY_GRAVE is returned (Fn isn't pressed, so translation is discarded)
    - KEY_GRAVE -> KEY_102ND (this part is not reached!)
    ...

2 - In case the touchbar does not work, the driver supports sending
Escape when Fn+KEY_GRAVE is pressed. As mentioned previously, KEY_102ND
is actually KEY_GRAVE and needs to be translated before this happens.

Normally, these are the steps that should happen:

    - KEY_102ND -> KEY_GRAVE
    - KEY_GRAVE -> KEY_ESC (Fn is pressed)
    - KEY_ESC is returned

Though this is what happens instead, as dependencies on other
translations are not supported:

    - KEY_102ND -> KEY_ESC (Fn is pressed)
    - KEY_ESC is returned

This patch fixes both bugs by ordering the translations correctly and by
making the translations continue and not return immediately after
translating a key so that chained translations work and translations can
depend on other ones.

This patch also simplifies the implementation of the swap_fn_leftctrl
option a little bit, as it makes it simply use a normal translation
instead adding extra code to translate a key to KEY_FN[#381]. This change
wasn't put in another patch as the code that translates the Fn key needs
to be changed because of the changes in the patch, and those changes
would be discarded with the next patch anyway (the part that originally
translates KEY_FN to KEY_LEFTCTRL needs to be made an else-if branch of
the part that transltes KEY_LEFTCTRL to KEY_FN).

Note: Line numbers (#XYZ) are for drivers/hid/hid-apple.c at commit
20afcc462579 ("HID: apple: Add "GANSS" to the non-Apple list").

Note: These bugs are only present on Macs with a keyboard with no
dedicated escape key and a non-English layout.

Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 102 +++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 58 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 6970797cdc56..e86bbf85b87e 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -314,6 +314,7 @@ static const struct apple_key_translation swapped_option_cmd_keys[] = {
 
 static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
 	{ KEY_FN, KEY_LEFTCTRL },
+	{ KEY_LEFTCTRL, KEY_FN },
 	{ }
 };
 
@@ -375,24 +376,40 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 	struct apple_sc *asc = hid_get_drvdata(hid);
 	const struct apple_key_translation *trans, *table;
 	bool do_translate;
-	u16 code = 0;
+	u16 code = usage->code;
 	unsigned int real_fnmode;
 
-	u16 fn_keycode = (swap_fn_leftctrl) ? (KEY_LEFTCTRL) : (KEY_FN);
-
-	if (usage->code == fn_keycode) {
-		asc->fn_on = !!value;
-		input_event_with_scancode(input, usage->type, KEY_FN,
-				usage->hid, value);
-		return 1;
-	}
-
 	if (fnmode == 3) {
 		real_fnmode = (asc->quirks & APPLE_IS_NON_APPLE) ? 2 : 1;
 	} else {
 		real_fnmode = fnmode;
 	}
 
+	if (swap_fn_leftctrl) {
+		trans = apple_find_translation(swapped_fn_leftctrl_keys, code);
+
+		if (trans)
+			code = trans->to;
+	}
+
+	if (iso_layout > 0 || (iso_layout < 0 && (asc->quirks & APPLE_ISO_TILDE_QUIRK) &&
+			hid->country == HID_COUNTRY_INTERNATIONAL_ISO)) {
+		trans = apple_find_translation(apple_iso_keyboard, code);
+
+		if (trans)
+			code = trans->to;
+	}
+
+	if (swap_opt_cmd) {
+		trans = apple_find_translation(swapped_option_cmd_keys, code);
+
+		if (trans)
+			code = trans->to;
+	}
+
+	if (code == KEY_FN)
+		asc->fn_on = !!value;
+
 	if (real_fnmode) {
 		if (hid->product == USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI ||
 		    hid->product == USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO ||
@@ -430,15 +447,18 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		else
 			table = apple_fn_keys;
 
-		trans = apple_find_translation (table, usage->code);
+		trans = apple_find_translation(table, code);
 
 		if (trans) {
-			if (test_bit(trans->from, input->key))
+			bool from_is_set = test_bit(trans->from, input->key);
+			bool to_is_set = test_bit(trans->to, input->key);
+
+			if (from_is_set)
 				code = trans->from;
-			else if (test_bit(trans->to, input->key))
+			else if (to_is_set)
 				code = trans->to;
 
-			if (!code) {
+			if (!(from_is_set || to_is_set)) {
 				if (trans->flags & APPLE_FLAG_FKEY) {
 					switch (real_fnmode) {
 					case 1:
@@ -455,62 +475,31 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 					do_translate = asc->fn_on;
 				}
 
-				code = do_translate ? trans->to : trans->from;
+				if (do_translate)
+					code = trans->to;
 			}
-
-			input_event_with_scancode(input, usage->type, code,
-					usage->hid, value);
-			return 1;
 		}
 
 		if (asc->quirks & APPLE_NUMLOCK_EMULATION &&
-				(test_bit(usage->code, asc->pressed_numlock) ||
+				(test_bit(code, asc->pressed_numlock) ||
 				test_bit(LED_NUML, input->led))) {
-			trans = apple_find_translation(powerbook_numlock_keys,
-					usage->code);
+			trans = apple_find_translation(powerbook_numlock_keys, code);
 
 			if (trans) {
 				if (value)
-					set_bit(usage->code,
-							asc->pressed_numlock);
+					set_bit(code, asc->pressed_numlock);
 				else
-					clear_bit(usage->code,
-							asc->pressed_numlock);
+					clear_bit(code, asc->pressed_numlock);
 
-				input_event_with_scancode(input, usage->type,
-						trans->to, usage->hid, value);
+				code = trans->to;
 			}
-
-			return 1;
 		}
 	}
 
-	if (iso_layout > 0 || (iso_layout < 0 && (asc->quirks & APPLE_ISO_TILDE_QUIRK) &&
-			hid->country == HID_COUNTRY_INTERNATIONAL_ISO)) {
-		trans = apple_find_translation(apple_iso_keyboard, usage->code);
-		if (trans) {
-			input_event_with_scancode(input, usage->type,
-					trans->to, usage->hid, value);
-			return 1;
-		}
-	}
+	if (usage->code != code) {
+		input_event_with_scancode(input, usage->type, code, usage->hid, value);
 
-	if (swap_opt_cmd) {
-		trans = apple_find_translation(swapped_option_cmd_keys, usage->code);
-		if (trans) {
-			input_event_with_scancode(input, usage->type,
-					trans->to, usage->hid, value);
-			return 1;
-		}
-	}
-
-	if (swap_fn_leftctrl) {
-		trans = apple_find_translation(swapped_fn_leftctrl_keys, usage->code);
-		if (trans) {
-			input_event_with_scancode(input, usage->type,
-					trans->to, usage->hid, value);
-			return 1;
-		}
+		return 1;
 	}
 
 	return 0;
@@ -640,9 +629,6 @@ static void apple_setup_input(struct input_dev *input)
 	apple_setup_key_translation(input, apple2021_fn_keys);
 	apple_setup_key_translation(input, macbookpro_no_esc_fn_keys);
 	apple_setup_key_translation(input, macbookpro_dedicated_esc_fn_keys);
-
-	if (swap_fn_leftctrl)
-		apple_setup_key_translation(input, swapped_fn_leftctrl_keys);
 }
 
 static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-- 
2.35.1



