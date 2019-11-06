Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756EEF1F66
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 21:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKFUAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 15:00:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40664 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfKFUAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 15:00:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id r4so19727066pfl.7;
        Wed, 06 Nov 2019 12:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2NBa2LgrpE4L6RGacxchP+uklVKgX1wRCtxgifUbs8=;
        b=c/PhPI5TiUtDMh9DKGZg0Pcn9PeuFpl5OWCpqkNLlMnUBryNNkcWZTiKuxmx0x2hm9
         Q78nCv3CexnDHzj0nWOxntT4bmOVjSI22SjrUUMj2NLzuP87WdEu69tbfSo8y8vLFNrU
         W7E+CFz9FtNM7I2T7PBBy3k9FjSbqwTm4S+fGr3t1XiaV7P3lk0fmrbqvlhVwD81MszV
         BkXU3Vl4K7lw7Hh6JwBstqszFGNYGCa5gKjKsJfNUAMxUWf/MtmTJC/BtwtjnCmALcSn
         buAUbE3TI+frjnWQpAgGeTaD74d8645q44drX7mtZxO8KxePcTv9wlbsUILqlhf3nPuX
         5qvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2NBa2LgrpE4L6RGacxchP+uklVKgX1wRCtxgifUbs8=;
        b=oYuOImBPg1/Q3qJQnTzmPCBe5uKGtWCrFBCdQ2u/dD5NKdelE+8JhW5+7yh3HzUE/l
         tIWKnwANTQ+W86WeQRB7MMEnJYbCXl6nPyr8kNKcCIgpy8z9t36NkjTz7tUyF8H4MlB5
         rjL4gshhWjIjDB04iZ1jGKKKnlkc4RjZjVmqLUPFQG0d40HD4xqu1g1C4IlJ6D7V8VBI
         wEKto0IAZ5bkkUgEeyFZC11RCbR1FT+B+UMN/4SeftMfVNHfTrgUDFiuIYeUd1loPAV3
         uAERed0C5D8BxDSCYUtN/erNbDJMvL5cxW4+P3xOIoiEYNc2N3d/DldtuqGnG39+BIb8
         R42w==
X-Gm-Message-State: APjAAAXFe/FyM6VDt1D40gLzDOoUDqlinbhPaVOrJMbmDE+q+hlpK84s
        Z0s86QEHjGp+/EjfUkJn8Os+LK8fjr4=
X-Google-Smtp-Source: APXvYqwyXfgOgss/tHAjqU7N38N0FVzf0AMwncW+sMuCyh4vPY4CqJWtx7EvNoJ9le3YfXiKQep81g==
X-Received: by 2002:a65:6290:: with SMTP id f16mr5144528pgv.40.1573070410807;
        Wed, 06 Nov 2019 12:00:10 -0800 (PST)
Received: from US-191-ENG0002.corp.onewacom.com (75-148-82-17-Oregon.hfc.comcastbusiness.net. [75.148.82.17])
        by smtp.gmail.com with ESMTPSA id 76sm11795674pfw.75.2019.11.06.12.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 12:00:10 -0800 (PST)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, stable@vger.kernel.org,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: [PATCH] HID: wacom: generic: Treat serial number and related fields as unsigned
Date:   Wed,  6 Nov 2019 11:59:46 -0800
Message-Id: <20191106195946.552879-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

The HID descriptors for most Wacom devices oddly declare the serial
number and other related fields as signed integers. When these numbers
are ingested by the HID subsystem, they are automatically sign-extended
into 32-bit integers. We treat the fields as unsigned elsewhere in the
kernel and userspace, however, so this sign-extension causes problems.
In particular, the sign-extended tool ID sent to userspace as ABS_MISC
does not properly match unsigned IDs used by xf86-input-wacom and libwacom.

We introduce a function 'wacom_s32tou' that can undo the automatic sign
extension performed by 'hid_snto32'. We call this function when processing
the serial number and related fields to ensure that we are dealing with
and reporting the unsigned form. We opt to use this method rather than
adding a descriptor fixup in 'wacom_hid_usage_quirk' since it should be
more robust in the face of future devices.

Ref: https://github.com/linuxwacom/input-wacom/issues/134
Fixes: f85c9dc678 ("HID: wacom: generic: Support tool ID and additional tool types")
CC: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
---
 drivers/hid/wacom.h     | 15 +++++++++++++++
 drivers/hid/wacom_wac.c | 10 ++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index 4a7f8d363220..203d27d198b8 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -202,6 +202,21 @@ static inline void wacom_schedule_work(struct wacom_wac *wacom_wac,
 	}
 }
 
+/*
+ * Convert a signed 32-bit integer to an unsigned n-bit integer. Undoes
+ * the normally-helpful work of 'hid_snto32' for fields that use signed
+ * ranges for questionable reasons.
+ */
+static inline __u32 wacom_s32tou(s32 value, __u8 n)
+{
+	switch (n) {
+	case 8:  return ((__u8)value);
+	case 16: return ((__u16)value);
+	case 32: return ((__u32)value);
+	}
+	return value & (1 << (n - 1)) ? value & (~(~0U << n)) : value;
+}
+
 extern const struct hid_device_id wacom_ids[];
 
 void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len);
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 2b0a5b8ca6e6..ccb74529bc78 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2303,7 +2303,7 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 	case HID_DG_TOOLSERIALNUMBER:
 		if (value) {
 			wacom_wac->serial[0] = (wacom_wac->serial[0] & ~0xFFFFFFFFULL);
-			wacom_wac->serial[0] |= (__u32)value;
+			wacom_wac->serial[0] |= wacom_s32tou(value, field->report_size);
 		}
 		return;
 	case HID_DG_TWIST:
@@ -2319,15 +2319,17 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 		return;
 	case WACOM_HID_WD_SERIALHI:
 		if (value) {
+			__u32 raw_value = wacom_s32tou(value, field->report_size);
+
 			wacom_wac->serial[0] = (wacom_wac->serial[0] & 0xFFFFFFFF);
-			wacom_wac->serial[0] |= ((__u64)value) << 32;
+			wacom_wac->serial[0] |= ((__u64)raw_value) << 32;
 			/*
 			 * Non-USI EMR devices may contain additional tool type
 			 * information here. See WACOM_HID_WD_TOOLTYPE case for
 			 * more details.
 			 */
 			if (value >> 20 == 1) {
-				wacom_wac->id[0] |= value & 0xFFFFF;
+				wacom_wac->id[0] |= raw_value & 0xFFFFF;
 			}
 		}
 		return;
@@ -2339,7 +2341,7 @@ static void wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field
 		 * bitwise OR so the complete value can be built
 		 * up over time :(
 		 */
-		wacom_wac->id[0] |= value;
+		wacom_wac->id[0] |= wacom_s32tou(value, field->report_size);
 		return;
 	case WACOM_HID_WD_OFFSETLEFT:
 		if (features->offset_left && value != features->offset_left)
-- 
2.23.0

