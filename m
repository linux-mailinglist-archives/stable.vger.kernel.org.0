Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC0EC1788
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbfI2Rih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbfI2RgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:36:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E2621D6C;
        Sun, 29 Sep 2019 17:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778559;
        bh=loZr7MLJpU4XU6TOPh2BVQXDVFm5QAyJaqArvekhQzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jx8InXds9YDSisXpCh5ducyiVGQR6LV8v9n/4YJatME7aRpIpmrhnZlECpRoswSRL
         1R7NnnVyOpdahZDKH+9f6hY9EEXr9VVWAP2CfxoIbl1UkZ4xpc6UgywZU0UGv3hYMN
         4j9/tk3QDVBXiC++J4wto/XV9RPXLOqvjLg8p0jI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joao Moreno <mail@joaomoreno.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/23] HID: apple: Fix stuck function keys when using FN
Date:   Sun, 29 Sep 2019 13:35:22 -0400
Message-Id: <20190929173535.9744-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173535.9744-1-sashal@kernel.org>
References: <20190929173535.9744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joao Moreno <mail@joaomoreno.com>

[ Upstream commit aec256d0ecd561036f188dbc8fa7924c47a9edfd ]

This fixes an issue in which key down events for function keys would be
repeatedly emitted even after the user has raised the physical key. For
example, the driver fails to emit the F5 key up event when going through
the following steps:
- fnmode=1: hold FN, hold F5, release FN, release F5
- fnmode=2: hold F5, hold FN, release F5, release FN

The repeated F5 key down events can be easily verified using xev.

Signed-off-by: Joao Moreno <mail@joaomoreno.com>
Co-developed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 49 +++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 1cb41992aaa1f..d0a81a03ddbdd 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -57,7 +57,6 @@ MODULE_PARM_DESC(swap_opt_cmd, "Swap the Option (\"Alt\") and Command (\"Flag\")
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
-	DECLARE_BITMAP(pressed_fn, KEY_CNT);
 	DECLARE_BITMAP(pressed_numlock, KEY_CNT);
 };
 
@@ -184,6 +183,8 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 {
 	struct apple_sc *asc = hid_get_drvdata(hid);
 	const struct apple_key_translation *trans, *table;
+	bool do_translate;
+	u16 code = 0;
 
 	if (usage->code == KEY_FN) {
 		asc->fn_on = !!value;
@@ -192,8 +193,6 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 	}
 
 	if (fnmode) {
-		int do_translate;
-
 		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
 			table = macbookair_fn_keys;
@@ -205,25 +204,33 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		trans = apple_find_translation (table, usage->code);
 
 		if (trans) {
-			if (test_bit(usage->code, asc->pressed_fn))
-				do_translate = 1;
-			else if (trans->flags & APPLE_FLAG_FKEY)
-				do_translate = (fnmode == 2 && asc->fn_on) ||
-					(fnmode == 1 && !asc->fn_on);
-			else
-				do_translate = asc->fn_on;
-
-			if (do_translate) {
-				if (value)
-					set_bit(usage->code, asc->pressed_fn);
-				else
-					clear_bit(usage->code, asc->pressed_fn);
-
-				input_event(input, usage->type, trans->to,
-						value);
-
-				return 1;
+			if (test_bit(trans->from, input->key))
+				code = trans->from;
+			else if (test_bit(trans->to, input->key))
+				code = trans->to;
+
+			if (!code) {
+				if (trans->flags & APPLE_FLAG_FKEY) {
+					switch (fnmode) {
+					case 1:
+						do_translate = !asc->fn_on;
+						break;
+					case 2:
+						do_translate = asc->fn_on;
+						break;
+					default:
+						/* should never happen */
+						do_translate = false;
+					}
+				} else {
+					do_translate = asc->fn_on;
+				}
+
+				code = do_translate ? trans->to : trans->from;
 			}
+
+			input_event(input, usage->type, code, value);
+			return 1;
 		}
 
 		if (asc->quirks & APPLE_NUMLOCK_EMULATION &&
-- 
2.20.1

