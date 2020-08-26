Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3809A253051
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgHZNuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730428AbgHZNrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:47:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 592E322BEA;
        Wed, 26 Aug 2020 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598449630;
        bh=2c7kLmBWxeG5b+bZP/Vwev5mREKep9OqRfHbzY3d2IQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ZYWMzWcjXOiK1J4w+5K7nZTegwvyJ6ASu9e/dnz7EEs8bJI7SZvMBA5GO5F6lynkN
         ZK3UHThXzWZhEdJKFpBBhdvZGJ3+TLWLn0Qa4QwXQJ3COlancfyzsx8Ws+mFeB2IRB
         OSv6/FLZ2W09njvsgDsKnrdErU7jx1mRMgQ9puvI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kAvlc-006rUp-Qw; Wed, 26 Aug 2020 14:47:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] HID: core: Sanitize event code and type when mapping input
Date:   Wed, 26 Aug 2020 14:46:58 +0100
Message-Id: <20200826134658.1046338-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dmitry.torokhov@gmail.com, jikos@kernel.org, benjamin.tissoires@redhat.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When calling into hid_map_usage(), the passed event code is
blindly stored as is, even if it doesn't fit in the associated bitmap.

This event code can come from a variety of sources, including devices
masquerading as input devices, only a bit more "programmable".

Instead of taking the event code at face value, check that it actually
fits the corresponding bitmap, and if it doesn't:
- spit out a warning so that we know which device is acting up
- NULLify the bitmap pointer so that we catch unexpected uses

Code paths that can make use of untrusted inputs can now check
that the mapping was indeed correct and bail out if not.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
* From v1:
  - Dropped the input.c changes, and turned hid_map_usage() into
    the validation primitive.
  - Handle mapping failures in hidinput_configure_usage() and
    mt_touch_input_mapping() (on top of hid_map_usage_clear() which
    was already handled)

 drivers/hid/hid-input.c      |  4 ++++
 drivers/hid/hid-multitouch.c |  2 ++
 include/linux/hid.h          | 40 +++++++++++++++++++++++++-----------
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index b8eabf206e74..88e19996427e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1132,6 +1132,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	}
 
 mapped:
+	/* Mapping failed, bail out */
+	if (!bit)
+		return;
+
 	if (device->driver->input_mapped &&
 	    device->driver->input_mapped(device, hidinput, field, usage,
 					 &bit, &max) < 0) {
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3f94b4954225..e3152155c4b8 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -856,6 +856,8 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			code = BTN_0  + ((usage->hid - 1) & HID_USAGE);
 
 		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
+		if (!*bit)
+			return -1;
 		input_set_capability(hi->input, EV_KEY, code);
 		return 1;
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 875f71132b14..ff4ccf7ba694 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -959,34 +959,49 @@ static inline void hid_device_io_stop(struct hid_device *hid) {
  * @max: maximal valid usage->code to consider later (out parameter)
  * @type: input event type (EV_KEY, EV_REL, ...)
  * @c: code which corresponds to this usage and type
+ *
+ * The value pointed to by @bit will be set to NULL if either @type is
+ * an unhandled event type, or if @c is out of range for @type. This
+ * can be used as an error condition.
  */
 static inline void hid_map_usage(struct hid_input *hidinput,
 		struct hid_usage *usage, unsigned long **bit, int *max,
 		__u8 type, __u16 c)
 {
 	struct input_dev *input = hidinput->input;
-
-	usage->type = type;
-	usage->code = c;
+	unsigned long *bmap = NULL;
+	u16 limit = 0;
 
 	switch (type) {
 	case EV_ABS:
-		*bit = input->absbit;
-		*max = ABS_MAX;
+		bmap = input->absbit;
+		limit = ABS_MAX;
 		break;
 	case EV_REL:
-		*bit = input->relbit;
-		*max = REL_MAX;
+		bmap = input->relbit;
+		limit = REL_MAX;
 		break;
 	case EV_KEY:
-		*bit = input->keybit;
-		*max = KEY_MAX;
+		bmap = input->keybit;
+		limit = KEY_MAX;
 		break;
 	case EV_LED:
-		*bit = input->ledbit;
-		*max = LED_MAX;
+		bmap = input->ledbit;
+		limit = LED_MAX;
 		break;
 	}
+
+	if (unlikely(c > limit || !bmap)) {
+		pr_warn_ratelimited("%s: Invalid code %d type %d\n",
+				    input->name, c, type);
+		*bit = NULL;
+		return;
+	}
+
+	usage->type = type;
+	usage->code = c;
+	*max = limit;
+	*bit = bmap;
 }
 
 /**
@@ -1000,7 +1015,8 @@ static inline void hid_map_usage_clear(struct hid_input *hidinput,
 		__u8 type, __u16 c)
 {
 	hid_map_usage(hidinput, usage, bit, max, type, c);
-	clear_bit(c, *bit);
+	if (*bit)
+		clear_bit(usage->code, *bit);
 }
 
 /**
-- 
2.27.0

