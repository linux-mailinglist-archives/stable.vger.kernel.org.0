Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A48EF071
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbfKDW2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730356AbfKDVtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:49:24 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48717214D8;
        Mon,  4 Nov 2019 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904163;
        bh=dgZCPG1lrwSghZ0yJM0w82f2BJqLxmWENgU1OADh6a0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=crBtIUnpcBp/4K9O6Ob9RXBs0j+gT9+UxcOF8c8pjv95h5luALvKil8Gso2cLe8EA
         XQQTeQcxk3B1uA6syvtQ0oNKN/AYWIh8D8Ob/4t5yfFlQeuAvllHNJCbZ2H3FwQNwr
         P7+GEW9yGIbAqxBX43zmbDNKNmajIso3u8Xn/JmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        syzbot+403741a091bf41d4ae79@syzkaller.appspotmail.com
Subject: [PATCH 4.4 34/46] HID: Fix assumption that devices have inputs
Date:   Mon,  4 Nov 2019 22:45:05 +0100
Message-Id: <20191104211908.637393807@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit d9d4b1e46d9543a82c23f6df03f4ad697dab361b upstream.

The syzbot fuzzer found a slab-out-of-bounds write bug in the hid-gaff
driver.  The problem is caused by the driver's assumption that the
device must have an input report.  While this will be true for all
normal HID input devices, a suitably malicious device can violate the
assumption.

The same assumption is present in over a dozen other HID drivers.
This patch fixes them by checking that the list of hid_inputs for the
hid_device is nonempty before allowing it to be used.

Reported-and-tested-by: syzbot+403741a091bf41d4ae79@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-axff.c     |   11 +++++++++--
 drivers/hid/hid-dr.c       |   12 +++++++++---
 drivers/hid/hid-emsff.c    |   12 +++++++++---
 drivers/hid/hid-gaff.c     |   12 +++++++++---
 drivers/hid/hid-holtekff.c |   12 +++++++++---
 drivers/hid/hid-lg2ff.c    |   12 +++++++++---
 drivers/hid/hid-lg3ff.c    |   11 +++++++++--
 drivers/hid/hid-lg4ff.c    |   11 +++++++++--
 drivers/hid/hid-lgff.c     |   11 +++++++++--
 drivers/hid/hid-sony.c     |   12 +++++++++---
 drivers/hid/hid-tmff.c     |   12 +++++++++---
 drivers/hid/hid-zpff.c     |   12 +++++++++---
 12 files changed, 108 insertions(+), 32 deletions(-)

--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -75,13 +75,20 @@ static int axff_init(struct hid_device *
 {
 	struct axff_device *axff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int field_count = 0;
 	int i, j;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
--- a/drivers/hid/hid-dr.c
+++ b/drivers/hid/hid-dr.c
@@ -87,13 +87,19 @@ static int drff_init(struct hid_device *
 {
 	struct drff_device *drff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_first_entry(&hid->inputs,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -59,13 +59,19 @@ static int emsff_init(struct hid_device
 {
 	struct emsff_device *emsff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_first_entry(&hid->inputs,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -77,14 +77,20 @@ static int gaff_init(struct hid_device *
 {
 	struct gaff_device *gaff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct list_head *report_ptr = report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
--- a/drivers/hid/hid-holtekff.c
+++ b/drivers/hid/hid-holtekff.c
@@ -140,13 +140,19 @@ static int holtekff_init(struct hid_devi
 {
 	struct holtekff_device *holtekff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output report found\n");
 		return -ENODEV;
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -62,11 +62,17 @@ int lg2ff_init(struct hid_device *hid)
 {
 	struct lg2ff_device *lg2ff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	int error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7);
 	if (!report)
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -129,12 +129,19 @@ static const signed short ff3_joystick_a
 
 int lg3ff_init(struct hid_device *hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	const signed short *ff_bits = ff3_joystick_ac;
 	int error;
 	int i;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 35))
 		return -ENODEV;
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -1158,8 +1158,8 @@ static int lg4ff_handle_multimode_wheel(
 
 int lg4ff_init(struct hid_device *hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
 	const struct usb_device_descriptor *udesc = &(hid_to_usb_dev(hid)->descriptor);
@@ -1171,6 +1171,13 @@ int lg4ff_init(struct hid_device *hid)
 	int mmode_ret, mmode_idx = -1;
 	u16 real_product_id;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -1;
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -127,12 +127,19 @@ static void hid_lgff_set_autocenter(stru
 
 int lgff_init(struct hid_device* hid)
 {
-	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	const signed short *ff_bits = ff_joystick;
 	int error;
 	int i;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	/* Check that the report looks ok */
 	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -ENODEV;
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -1960,9 +1960,15 @@ static int sony_play_effect(struct input
 
 static int sony_init_ff(struct sony_sc *sc)
 {
-	struct hid_input *hidinput = list_entry(sc->hdev->inputs.next,
-						struct hid_input, list);
-	struct input_dev *input_dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *input_dev;
+
+	if (list_empty(&sc->hdev->inputs)) {
+		hid_err(sc->hdev, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(sc->hdev->inputs.next, struct hid_input, list);
+	input_dev = hidinput->input;
 
 	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
 	return input_ff_create_memless(input_dev, NULL, sony_play_effect);
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -136,12 +136,18 @@ static int tmff_init(struct hid_device *
 	struct tmff_device *tmff;
 	struct hid_report *report;
 	struct list_head *report_list;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-							struct hid_input, list);
-	struct input_dev *input_dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *input_dev;
 	int error;
 	int i;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	input_dev = hidinput->input;
+
 	tmff = kzalloc(sizeof(struct tmff_device), GFP_KERNEL);
 	if (!tmff)
 		return -ENOMEM;
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -66,11 +66,17 @@ static int zpff_init(struct hid_device *
 {
 	struct zpff_device *zpff;
 	struct hid_report *report;
-	struct hid_input *hidinput = list_entry(hid->inputs.next,
-						struct hid_input, list);
-	struct input_dev *dev = hidinput->input;
+	struct hid_input *hidinput;
+	struct input_dev *dev;
 	int i, error;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+	hidinput = list_entry(hid->inputs.next, struct hid_input, list);
+	dev = hidinput->input;
+
 	for (i = 0; i < 4; i++) {
 		report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, i, 1);
 		if (!report)


