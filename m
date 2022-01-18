Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEDA4930E8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbiARWiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiARWiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:38:15 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ED0C061574;
        Tue, 18 Jan 2022 14:38:14 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z17-20020a17090ab11100b001b4d8817e04so3391853pjq.2;
        Tue, 18 Jan 2022 14:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZbU8JFNz8EJwN7FgVu0cRZAO8izn8Kn18zUzADS8gd4=;
        b=qLB+fZQTeul3PaPNLzabru6EfFjb//O5L/H/oGiKJk6TaaSEMrWTOhEWbZPsWk1pjV
         M/HVD2P/vAS/4eRozOAAnO8w0x4yFENI/51hKy494g2CGbfV9vUIiqymYiTIiVqeWQSW
         WrmsgPiaf0Tf0wIk6Hc6U6qHMXSatSkClsyRzPyZRj4EkWuTOTlGOYE7wKsqTCM2tX2N
         wqOApjbBiBop50XZfY4uyGQLhpy71ajc8x6itLLzdFYGN8sdSC3kFDvaaTppbrRIIFya
         bxzEzyDMOHCsUkzMgWmLXUU4vamt9/hPXpQj0Y1QIauOwskTbI97TBfVi/DV/tdUOE/x
         o7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZbU8JFNz8EJwN7FgVu0cRZAO8izn8Kn18zUzADS8gd4=;
        b=Y3eXMPkdO9Dug68CNxyf3afTXlP0QLvtVs7RCUjWWJX1VxSl/gaO0uCNjeMeM/CwNm
         vEoxlUBX4vPJRBD0U/3LiTeKe3EZpi3RsBmFlWO7T4rT0Wl6xJ9P07DFofjQetLivT0g
         /MUH5X9ALO6bTJK6VjF3SfMNwSMle6C/wx1EpRyA3yZ4wkEHYe6MFRLG4zVH7ppxHarx
         E1pGenyWk8hlMkguQMyZaPdqXNLuSgU3jyd8Io0odlMESZdNl1HzPS9FGG6BoioH1O8t
         PzdpVC27LYoTXAd9kIPHjO0XaU0fjYA21vjXyuUz7cJTjvzHVQKXCkC4M6FAq8y24bT/
         IPqw==
X-Gm-Message-State: AOAM5325y9kv6jKdwK1x1LPNFW9C60nrbZRvCELS4qNf67YQdmCu24DJ
        ZJV5qaZ7y2GUebwG8ERawP9ZMSKX+T4=
X-Google-Smtp-Source: ABdhPJy8NmyV4OoqB4rgP4Cm4SB/wZYyrZBmDQQ3COSOsm2/hnk+FnumY4KbscTnDAiRl/RLxL/q2g==
X-Received: by 2002:a17:902:bf02:b0:149:c653:22af with SMTP id bi2-20020a170902bf0200b00149c65322afmr29852473plb.139.1642545494367;
        Tue, 18 Jan 2022 14:38:14 -0800 (PST)
Received: from horus.lan (75-164-184-207.ptld.qwest.net. [75.164.184.207])
        by smtp.gmail.com with ESMTPSA id pf16sm3433250pjb.35.2022.01.18.14.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 14:38:13 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH 2/2] HID: wacom: Ignore the confidence flag when a touch is removed
Date:   Tue, 18 Jan 2022 14:37:56 -0800
Message-Id: <20220118223756.45624-2-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118223756.45624-1-jason.gerecke@wacom.com>
References: <20220118223756.45624-1-jason.gerecke@wacom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AES hardware may internally re-classify a contact that it thought was
intentional as a palm. Intentional contacts are reported as "down" with
the confidence bit set. When this re-classification occurs, however, the
state transitions to "up" with the confidence bit cleared. This kind of
transition appears to be legal according to Microsoft docs, but we do
not handle it correctly. Because the confidence bit is clear, we don't
call `wacom_wac_finger_slot` and update userspace. This causes hung
touches that confuse userspace and interfere with pen arbitration.

This commit adds a special case to ignore the confidence flag if a contact
is reported as removed. This ensures we do not leave a hung touch if one
of these re-classification events occured. Ideally we'd have some way to
also let userspace know that the touch has been re-classified as a palm
and needs to be canceled, but that's not possible right now :)

Link: https://github.com/linuxwacom/input-wacom/issues/288
Fixes: 7fb0413baa7f (HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts)
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_wac.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 5978399ae7d2..92b52b1de526 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2588,6 +2588,24 @@ static void wacom_wac_finger_slot(struct wacom_wac *wacom_wac,
 	}
 }
 
+static bool wacom_wac_slot_is_active(struct input_dev *dev, int key)
+{
+	struct input_mt *mt = dev->mt;
+	struct input_mt_slot *s;
+
+	if (!mt)
+		return false;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (s->key == key &&
+			input_mt_get_value(s, ABS_MT_TRACKING_ID) >= 0) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static void wacom_wac_finger_event(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage, __s32 value)
 {
@@ -2638,9 +2656,14 @@ static void wacom_wac_finger_event(struct hid_device *hdev,
 	}
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field &&
-		    wacom_wac->hid_data.confidence)
-			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field) {
+			bool touch_removed = wacom_wac_slot_is_active(wacom_wac->touch_input,
+				wacom_wac->hid_data.id) && !wacom_wac->hid_data.tipswitch;
+
+			if (wacom_wac->hid_data.confidence || touch_removed) {
+				wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
+			}
+		}
 	}
 }
 
-- 
2.34.1

