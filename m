Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DA04925F
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbfFQVTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728849AbfFQVTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636D02089E;
        Mon, 17 Jun 2019 21:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806374;
        bh=9VFLOxWP77UVjbLY1Q/kxJQE2cuRxlJD6RT8jOtOxa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFxMIFBBsHfCdh7kA9SB+RzypE2VapLOB02h2aGEo3ZDT0IWyFfrrVJGAl4ZGQXHx
         we+y9Kaa3mNnz0uyCdydagcnsap+Dv4QFQP507iqiLLJNRLhrg2qWONhrq9cXGon1a
         SfgYIkA6S4YOwxxtqFdBkFcvO46FGt8cmm39mcHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        James Feeney <james@nurealm.net>
Subject: [PATCH 5.1 003/115] HID: input: make sure the wheel high resolution multiplier is set
Date:   Mon, 17 Jun 2019 23:08:23 +0200
Message-Id: <20190617210800.096317488@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit d43c17ead879ba7c076dc2f5fd80cd76047c9ff4 upstream.

Some old mice have a tendency to not accept the high resolution multiplier.
They reply with a -EPIPE which was previously ignored.

Force the call to resolution multiplier to be synchronous and actually
check for the answer. If this fails, consider the mouse like a normal one.

Fixes: 2dc702c991e377 ("HID: input: use the Resolution Multiplier for
       high-resolution scrolling")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1700071
Reported-and-tested-by: James Feeney <james@nurealm.net>
Cc: stable@vger.kernel.org  # v5.0+
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c  |    7 ++--
 drivers/hid/hid-input.c |   81 +++++++++++++++++++++++++++++-------------------
 include/linux/hid.h     |    2 -
 3 files changed, 56 insertions(+), 34 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1636,7 +1636,7 @@ static struct hid_report *hid_get_report
  * Implement a generic .request() callback, using .raw_request()
  * DO NOT USE in hid drivers directly, but through hid_hw_request instead.
  */
-void __hid_request(struct hid_device *hid, struct hid_report *report,
+int __hid_request(struct hid_device *hid, struct hid_report *report,
 		int reqtype)
 {
 	char *buf;
@@ -1645,7 +1645,7 @@ void __hid_request(struct hid_device *hi
 
 	buf = hid_alloc_report_buf(report, GFP_KERNEL);
 	if (!buf)
-		return;
+		return -ENOMEM;
 
 	len = hid_report_len(report);
 
@@ -1662,8 +1662,11 @@ void __hid_request(struct hid_device *hi
 	if (reqtype == HID_REQ_GET_REPORT)
 		hid_input_report(hid, report->type, buf, ret, 0);
 
+	ret = 0;
+
 out:
 	kfree(buf);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__hid_request);
 
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1557,52 +1557,71 @@ static void hidinput_close(struct input_
 	hid_hw_close(hid);
 }
 
-static void hidinput_change_resolution_multipliers(struct hid_device *hid)
+static bool __hidinput_change_resolution_multipliers(struct hid_device *hid,
+		struct hid_report *report, bool use_logical_max)
 {
-	struct hid_report_enum *rep_enum;
-	struct hid_report *rep;
 	struct hid_usage *usage;
+	bool update_needed = false;
 	int i, j;
 
-	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
-	list_for_each_entry(rep, &rep_enum->report_list, list) {
-		bool update_needed = false;
+	if (report->maxfield == 0)
+		return false;
 
-		if (rep->maxfield == 0)
-			continue;
+	/*
+	 * If we have more than one feature within this report we
+	 * need to fill in the bits from the others before we can
+	 * overwrite the ones for the Resolution Multiplier.
+	 */
+	if (report->maxfield > 1) {
+		hid_hw_request(hid, report, HID_REQ_GET_REPORT);
+		hid_hw_wait(hid);
+	}
 
-		/*
-		 * If we have more than one feature within this report we
-		 * need to fill in the bits from the others before we can
-		 * overwrite the ones for the Resolution Multiplier.
+	for (i = 0; i < report->maxfield; i++) {
+		__s32 value = use_logical_max ?
+			      report->field[i]->logical_maximum :
+			      report->field[i]->logical_minimum;
+
+		/* There is no good reason for a Resolution
+		 * Multiplier to have a count other than 1.
+		 * Ignore that case.
 		 */
-		if (rep->maxfield > 1) {
-			hid_hw_request(hid, rep, HID_REQ_GET_REPORT);
-			hid_hw_wait(hid);
-		}
+		if (report->field[i]->report_count != 1)
+			continue;
 
-		for (i = 0; i < rep->maxfield; i++) {
-			__s32 logical_max = rep->field[i]->logical_maximum;
+		for (j = 0; j < report->field[i]->maxusage; j++) {
+			usage = &report->field[i]->usage[j];
 
-			/* There is no good reason for a Resolution
-			 * Multiplier to have a count other than 1.
-			 * Ignore that case.
-			 */
-			if (rep->field[i]->report_count != 1)
+			if (usage->hid != HID_GD_RESOLUTION_MULTIPLIER)
 				continue;
 
-			for (j = 0; j < rep->field[i]->maxusage; j++) {
-				usage = &rep->field[i]->usage[j];
+			*report->field[i]->value = value;
+			update_needed = true;
+		}
+	}
+
+	return update_needed;
+}
+
+static void hidinput_change_resolution_multipliers(struct hid_device *hid)
+{
+	struct hid_report_enum *rep_enum;
+	struct hid_report *rep;
+	int ret;
 
-				if (usage->hid != HID_GD_RESOLUTION_MULTIPLIER)
-					continue;
+	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
+	list_for_each_entry(rep, &rep_enum->report_list, list) {
+		bool update_needed = __hidinput_change_resolution_multipliers(hid,
+								     rep, true);
 
-				*rep->field[i]->value = logical_max;
-				update_needed = true;
+		if (update_needed) {
+			ret = __hid_request(hid, rep, HID_REQ_SET_REPORT);
+			if (ret) {
+				__hidinput_change_resolution_multipliers(hid,
+								    rep, false);
+				return;
 			}
 		}
-		if (update_needed)
-			hid_hw_request(hid, rep, HID_REQ_SET_REPORT);
 	}
 
 	/* refresh our structs */
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -894,7 +894,7 @@ struct hid_field *hidinput_get_led_field
 unsigned int hidinput_count_leds(struct hid_device *hid);
 __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
 void hid_output_report(struct hid_report *report, __u8 *data);
-void __hid_request(struct hid_device *hid, struct hid_report *rep, int reqtype);
+int __hid_request(struct hid_device *hid, struct hid_report *rep, int reqtype);
 u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device,


