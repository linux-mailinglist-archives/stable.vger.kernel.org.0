Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7536261AD5
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgIHSko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731211AbgIHQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:08:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DE523ECF;
        Tue,  8 Sep 2020 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580050;
        bh=HIels2xaM95JxAYzkcpSe0vmR3lhNMI/XaUw8mYvcQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR2kI9up5OadJTQMnCiqhjV5p9ZTCVtwB8FKzCQnRjqPCCPSrX7gklsIrUHmccjfL
         BII3jzVC9gbj4BEXLYUVWBFHDZt2+59WivJ/dRdcR1F+YiVoeyHWhvP9PN3m5NTGyw
         XXVdTPGMWM/FvXU4smmKdP1BZae6n9RLZISC1E48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 4.19 02/88] HID: core: Sanitize event code and type when mapping input
Date:   Tue,  8 Sep 2020 17:25:03 +0200
Message-Id: <20200908152221.209662874@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 35556bed836f8dc07ac55f69c8d17dce3e7f0e25 upstream.

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
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c      |    4 ++++
 drivers/hid/hid-multitouch.c |    2 ++
 include/linux/hid.h          |   42 +++++++++++++++++++++++++++++-------------
 3 files changed, 35 insertions(+), 13 deletions(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1125,6 +1125,10 @@ static void hidinput_configure_usage(str
 	}
 
 mapped:
+	/* Mapping failed, bail out */
+	if (!bit)
+		return;
+
 	if (device->driver->input_mapped &&
 	    device->driver->input_mapped(device, hidinput, field, usage,
 					 &bit, &max) < 0) {
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -841,6 +841,8 @@ static int mt_touch_input_mapping(struct
 			code = BTN_0  + ((usage->hid - 1) & HID_USAGE);
 
 		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
+		if (!*bit)
+			return -1;
 		input_set_capability(hi->input, EV_KEY, code);
 		return 1;
 
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -956,34 +956,49 @@ static inline void hid_device_io_stop(st
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
-		__u8 type, __u16 c)
+		__u8 type, unsigned int c)
 {
 	struct input_dev *input = hidinput->input;
-
-	usage->type = type;
-	usage->code = c;
+	unsigned long *bmap = NULL;
+	unsigned int limit = 0;
 
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
@@ -997,7 +1012,8 @@ static inline void hid_map_usage_clear(s
 		__u8 type, __u16 c)
 {
 	hid_map_usage(hidinput, usage, bit, max, type, c);
-	clear_bit(c, *bit);
+	if (*bit)
+		clear_bit(usage->code, *bit);
 }
 
 /**


