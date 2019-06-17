Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06358494B2
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfFQWAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:00:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40106 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbfFQWAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 18:00:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so6380362pfp.7
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 15:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FI1rvkkA0sL2gZwWbWTSTjyPa7KBr4Tueutv5uZeWHw=;
        b=GvqEoJO7viMpdICl63XPvsKWboGyf5XmDxbHkgR/cwCoo6BhCDk2VHsxC02kUI3bT5
         VfYXMsNApxwkOd6r1IL8TFWHzq21LM3cLsbBGaASaGNISvtH2oGZHTJlE119BnWghu+l
         O1GbWfqo9aVJ0Ry//sneekXP/+iwOP38JqBdi9y+U1yjDtas47VK2Z84C48x41SLcPZX
         t3xEKNvgl3XKxPBuHK/3qvfB1iAoRbOkz5sbgYNwfXqMUUTU4rjP3id3AuD2ibziEeuJ
         Y05xNUW+mYklXOGApIBwSwDN1OtgByqkQAQ8mtXB3Ugm9pqx6TWYi26WMUsVpEJqeJ3O
         P+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FI1rvkkA0sL2gZwWbWTSTjyPa7KBr4Tueutv5uZeWHw=;
        b=WRZkEajNgcsNrTiyMmdH5EIMGGAK3NqjVoqT8QNFL630qiIUGSn2Dt4M6ocyP6177Z
         fvgKIkRXCOPyJIqaWW9foX2erBYPocHD4s5K3B01JYPobAn5xttLjW6DawYQIR2Y9SaV
         bmGgHqYHhCx1hfT3qns0v6RKIHi+kJ323HCj0qhsB0XYQNVLkA4Ojs4dJ6SJ+mOXXS3F
         ezvmecOGLg5cNFUumfNPn0bddhHwMmmjruQxv3SGalBmZXOTra5awUG7dmh0BlC0aZrP
         gDnBr0WhKpHLUiUDxNPMa5Aksd/2X8UxQewR4UbGdnmc9sH+0aV+wmPROeEwHcTvAB8h
         TmVA==
X-Gm-Message-State: APjAAAVOnryE7/nMpgi5G9efN7zLM+zWfZlBqSdU5BYBc/QS2iwNKCNS
        foOQ80FvlaJ7KzcnLnEI1ZbF/zjK
X-Google-Smtp-Source: APXvYqyi6Fj3v7h1VZCU7zRPGJF2R7j5cK0DagSNIjbT6iDU3yMns6Qiql2yuKNXYHaqUUYY7mdbnw==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr1386185pjq.32.1560808801199;
        Mon, 17 Jun 2019 15:00:01 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id e22sm13054014pgb.9.2019.06.17.14.59.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 15:00:00 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     stable@vger.kernel.org
Cc:     Aaron Armstrong Skomra <skomra@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: [PATCH 1/3] HID: wacom: Don't set tool type until we're in range
Date:   Mon, 17 Jun 2019 14:59:46 -0700
Message-Id: <20190617215946.13423-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <15606126649212@kroah.com>
References: <15606126649212@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

The serial number and tool type information that is reported by the tablet
while a pen is merely "in prox" instead of fully "in range" can be stale
and cause us to report incorrect tool information. Serial number, tool
type, and other information is only valid once the pen comes fully in range
so we should be careful to not use this information until that point.

In particular, this issue may cause the driver to incorectly report
BTN_TOOL_RUBBER after switching from the eraser tool back to the pen.

Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Original commit in Linus' tree: 2cc08800a6b9fcda7c7afbcf2da1a6e8808da725

 drivers/hid/wacom_wac.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 22e80685cd52..53363368da8c 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1225,13 +1225,13 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 		/* Add back in missing bits of ID for non-USI pens */
 		wacom->id[0] |= (wacom->serial[0] >> 32) & 0xFFFFF;
 	}
-	wacom->tool[0]   = wacom_intuos_get_tool_type(wacom_intuos_id_mangle(wacom->id[0]));
 
 	for (i = 0; i < pen_frames; i++) {
 		unsigned char *frame = &data[i*pen_frame_len + 1];
 		bool valid = frame[0] & 0x80;
 		bool prox = frame[0] & 0x40;
 		bool range = frame[0] & 0x20;
+		bool invert = frame[0] & 0x10;
 
 		if (!valid)
 			continue;
@@ -1240,8 +1240,13 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 			wacom->shared->stylus_in_proximity = false;
 			wacom_exit_report(wacom);
 			input_sync(pen_input);
+
+			wacom->tool[0] = 0;
+			wacom->id[0] = 0;
+			wacom->serial[0] = 0;
 			return;
 		}
+
 		if (range) {
 			/* Fix rotation alignment: userspace expects zero at left */
 			int16_t rotation = (int16_t)get_unaligned_le16(&frame[9]);
@@ -1249,6 +1254,16 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 			if (rotation > 899)
 				rotation -= 1800;
 
+			if (!wacom->tool[0]) { /* first in range */
+				/* Going into range select tool */
+				if (invert)
+					wacom->tool[0] = BTN_TOOL_RUBBER;
+				else if (wacom->id[0])
+					wacom->tool[0] = wacom_intuos_get_tool_type(wacom->id[0]);
+				else
+					wacom->tool[0] = BTN_TOOL_PEN;
+			}
+
 			input_report_abs(pen_input, ABS_X, get_unaligned_le16(&frame[1]));
 			input_report_abs(pen_input, ABS_Y, get_unaligned_le16(&frame[3]));
 			input_report_abs(pen_input, ABS_TILT_X, (char)frame[7]);
-- 
2.22.0

