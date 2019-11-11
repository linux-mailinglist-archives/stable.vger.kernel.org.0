Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12F3F7ED7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfKKSfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727949AbfKKSfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:35:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BB5D2173B;
        Mon, 11 Nov 2019 18:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497345;
        bh=K/5WlSPT6KZWbLQV0WS2eO1lDitzgOBGxhZtemDZUZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBlVq+mnJ5yr4qivJO4rHgId6hdKfJ8lo3jGslq1nR4lkn/PAq++jKwQkrn2O5GPy
         BPmdkzmImc4KfN17Ry+OKfR15zmUCFgOeg5bKTr7AHlz8JLEg7Ed6gMn/Q74ayJDpu
         rul9JLGrlDkngVvU6K9c3V0q9L6QTYM8/cBL28Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 022/105] HID: wacom: generic: Treat serial number and related fields as unsigned
Date:   Mon, 11 Nov 2019 19:27:52 +0100
Message-Id: <20191111181435.793586813@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit ff479731c3859609530416a18ddb3db5db019b66 upstream.

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
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom.h     |   15 +++++++++++++++
 drivers/hid/wacom_wac.c |   10 ++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -205,6 +205,21 @@ static inline void wacom_schedule_work(s
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
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2182,7 +2182,7 @@ static void wacom_wac_pen_event(struct h
 	case HID_DG_TOOLSERIALNUMBER:
 		if (value) {
 			wacom_wac->serial[0] = (wacom_wac->serial[0] & ~0xFFFFFFFFULL);
-			wacom_wac->serial[0] |= (__u32)value;
+			wacom_wac->serial[0] |= wacom_s32tou(value, field->report_size);
 		}
 		return;
 	case HID_DG_TWIST:
@@ -2198,15 +2198,17 @@ static void wacom_wac_pen_event(struct h
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
@@ -2218,7 +2220,7 @@ static void wacom_wac_pen_event(struct h
 		 * bitwise OR so the complete value can be built
 		 * up over time :(
 		 */
-		wacom_wac->id[0] |= value;
+		wacom_wac->id[0] |= wacom_s32tou(value, field->report_size);
 		return;
 	case WACOM_HID_WD_OFFSETLEFT:
 		if (features->offset_left && value != features->offset_left)


