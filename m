Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F27CD3E3
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfJFRTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726895AbfJFRTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:19:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7D1D2077B;
        Sun,  6 Oct 2019 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382387;
        bh=fn1W6DM1VZqlD8bGq5EDAS5JqU3+VCwob7WeUZs8YE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZiPRjsjZpN+J+yn/cHQt6S/ttE6Ig+3hiOzf1LY0BsHkrKg9z6FqsQQWjdnOmLudr
         kGzVTA0gDlbhKCw/CzJJb3NjqN+yHUrciky5mtces1WBWInSRt080sOPF2Oc6I4GIA
         SkMKzAk32RjyylmGXQJMsy2zbE6CG+QBCviDPgb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joao Moreno <mail@joaomoreno.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/36] HID: apple: Fix stuck function keys when using FN
Date:   Sun,  6 Oct 2019 19:18:59 +0200
Message-Id: <20191006171051.570514181@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
References: <20191006171038.266461022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 884d82f9190e2..8af87dc05f2a5 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -55,7 +55,6 @@ MODULE_PARM_DESC(swap_opt_cmd, "Swap the Option (\"Alt\") and Command (\"Flag\")
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
-	DECLARE_BITMAP(pressed_fn, KEY_CNT);
 	DECLARE_BITMAP(pressed_numlock, KEY_CNT);
 };
 
@@ -182,6 +181,8 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 {
 	struct apple_sc *asc = hid_get_drvdata(hid);
 	const struct apple_key_translation *trans, *table;
+	bool do_translate;
+	u16 code = 0;
 
 	if (usage->code == KEY_FN) {
 		asc->fn_on = !!value;
@@ -190,8 +191,6 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 	}
 
 	if (fnmode) {
-		int do_translate;
-
 		if (hid->product >= USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI &&
 				hid->product <= USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS)
 			table = macbookair_fn_keys;
@@ -203,25 +202,33 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
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



