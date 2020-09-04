Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBC425D9A5
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgIDNbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbgIDNad (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:30:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE5C2073B;
        Fri,  4 Sep 2020 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226196;
        bh=x0jRDvCp22UPsUYFnsR/oV19tzgSwO5cbcHG4SpBbzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5UonjHpz7TVONDKQimvQujTFRwkGMiy6WZd5Jkvl45sjPIu6YvMjtRzDbkrgEquY
         xiIDKmgcv1l5WWdeDSNTOIz3f6SOl7mYrv9gfgk8Z7IT3e6Vu0gMn5LvzAHZm2+Kiu
         Ozy2xPoJeAOUENBimSeVBVDksbjwXkxzt/74+tyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: [PATCH 5.4 02/16] HID: core: Sanitize event code and type when mapping input
Date:   Fri,  4 Sep 2020 15:29:55 +0200
Message-Id: <20200904120257.326980422@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
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
@@ -1132,6 +1132,10 @@ static void hidinput_configure_usage(str
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
@@ -864,6 +864,8 @@ static int mt_touch_input_mapping(struct
 			code = BTN_0  + ((usage->hid - 1) & HID_USAGE);
 
 		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
+		if (!*bit)
+			return -1;
 		input_set_capability(hi->input, EV_KEY, code);
 		return 1;
 
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -959,34 +959,49 @@ static inline void hid_device_io_stop(st
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
@@ -1000,7 +1015,8 @@ static inline void hid_map_usage_clear(s
 		__u8 type, __u16 c)
 {
 	hid_map_usage(hidinput, usage, bit, max, type, c);
-	clear_bit(c, *bit);
+	if (*bit)
+		clear_bit(usage->code, *bit);
 }
 
 /**


