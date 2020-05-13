Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286B01D0D87
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733068AbgEMJxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgEMJxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58056205ED;
        Wed, 13 May 2020 09:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363626;
        bh=+feFlMH+aRpu3ZqDbPLETijhIkIBmj5Z97hvv1TLdeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVLP1ueKtIC3HEtMi+Hj3VH61h/VdZ/qpX5PRcWvj8GJQbwlE9A8yGH0egnuDC6An
         AQnZAxxlSyQmo0l5HLCapfXuNPpWDN/kp0kY+EKQS+omlTU+Eu3pE/phJ9J+beTnau
         lJXmvMfOgkwhoE5Vc0uzFjHpkRffC97X5nSExA6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.6 059/118] Revert "HID: wacom: generic: read the number of expected touches on a per collection basis"
Date:   Wed, 13 May 2020 11:44:38 +0200
Message-Id: <20200513094422.171935594@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit b43f977dd281945960c26b3ef67bba0fa07d39d9 upstream.

This reverts commit 15893fa40109f5e7c67eeb8da62267d0fdf0be9d.

The referenced commit broke pen and touch input for a variety of devices
such as the Cintiq Pro 32. Affected devices may appear to work normally
for a short amount of time, but eventually loose track of actual touch
state and can leave touch arbitration enabled which prevents the pen
from working. The commit is not itself required for any currently-available
Bluetooth device, and so we revert it to correct the behavior of broken
devices.

This breakage occurs due to a mismatch between the order of collections
and the order of usages on some devices. This commit tries to read the
contact count before processing events, but will fail if the contact
count does not occur prior to the first logical finger collection. This
is the case for devices like the Cintiq Pro 32 which place the contact
count at the very end of the report.

Without the contact count set, touches will only be partially processed.
The `wacom_wac_finger_slot` function will not open any slots since the
number of contacts seen is greater than the expectation of 0, but we will
still end up calling `input_mt_sync_frame` for each finger anyway. This
can cause problems for userspace separate from the issue currently taking
place in the kernel. Only once all of the individual finger collections
have been processed do we finally get to the enclosing collection which
contains the contact count. The value ends up being used for the *next*
report, however.

This delayed use of the contact count can cause the driver to loose track
of the actual touch state and believe that there are contacts down when
there aren't. This leaves touch arbitration enabled and prevents the pen
from working. It can also cause userspace to incorrectly treat single-
finger input as gestures.

Link: https://github.com/linuxwacom/input-wacom/issues/146
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Fixes: 15893fa40109 ("HID: wacom: generic: read the number of expected touches on a per collection basis")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   79 +++++++++---------------------------------------
 1 file changed, 16 insertions(+), 63 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2637,9 +2637,25 @@ static void wacom_wac_finger_pre_report(
 			case HID_DG_TIPSWITCH:
 				hid_data->last_slot_field = equivalent_usage;
 				break;
+			case HID_DG_CONTACTCOUNT:
+				hid_data->cc_report = report->id;
+				hid_data->cc_index = i;
+				hid_data->cc_value_index = j;
+				break;
 			}
 		}
 	}
+
+	if (hid_data->cc_report != 0 &&
+	    hid_data->cc_index >= 0) {
+		struct hid_field *field = report->field[hid_data->cc_index];
+		int value = field->value[hid_data->cc_value_index];
+		if (value)
+			hid_data->num_expected = value;
+	}
+	else {
+		hid_data->num_expected = wacom_wac->features.touch_max;
+	}
 }
 
 static void wacom_wac_finger_report(struct hid_device *hdev,
@@ -2649,7 +2665,6 @@ static void wacom_wac_finger_report(stru
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
 	struct input_dev *input = wacom_wac->touch_input;
 	unsigned touch_max = wacom_wac->features.touch_max;
-	struct hid_data *hid_data = &wacom_wac->hid_data;
 
 	/* If more packets of data are expected, give us a chance to
 	 * process them rather than immediately syncing a partial
@@ -2663,7 +2678,6 @@ static void wacom_wac_finger_report(stru
 
 	input_sync(input);
 	wacom_wac->hid_data.num_received = 0;
-	hid_data->num_expected = 0;
 
 	/* keep touch state for pen event */
 	wacom_wac->shared->touch_down = wacom_wac_finger_count_touches(wacom_wac);
@@ -2738,73 +2752,12 @@ static void wacom_report_events(struct h
 	}
 }
 
-static void wacom_set_num_expected(struct hid_device *hdev,
-				   struct hid_report *report,
-				   int collection_index,
-				   struct hid_field *field,
-				   int field_index)
-{
-	struct wacom *wacom = hid_get_drvdata(hdev);
-	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
-	struct hid_data *hid_data = &wacom_wac->hid_data;
-	unsigned int original_collection_level =
-		hdev->collection[collection_index].level;
-	bool end_collection = false;
-	int i;
-
-	if (hid_data->num_expected)
-		return;
-
-	// find the contact count value for this segment
-	for (i = field_index; i < report->maxfield && !end_collection; i++) {
-		struct hid_field *field = report->field[i];
-		unsigned int field_level =
-			hdev->collection[field->usage[0].collection_index].level;
-		unsigned int j;
-
-		if (field_level != original_collection_level)
-			continue;
-
-		for (j = 0; j < field->maxusage; j++) {
-			struct hid_usage *usage = &field->usage[j];
-
-			if (usage->collection_index != collection_index) {
-				end_collection = true;
-				break;
-			}
-			if (wacom_equivalent_usage(usage->hid) == HID_DG_CONTACTCOUNT) {
-				hid_data->cc_report = report->id;
-				hid_data->cc_index = i;
-				hid_data->cc_value_index = j;
-
-				if (hid_data->cc_report != 0 &&
-				    hid_data->cc_index >= 0) {
-
-					struct hid_field *field =
-						report->field[hid_data->cc_index];
-					int value =
-						field->value[hid_data->cc_value_index];
-
-					if (value)
-						hid_data->num_expected = value;
-				}
-			}
-		}
-	}
-
-	if (hid_data->cc_report == 0 || hid_data->cc_index < 0)
-		hid_data->num_expected = wacom_wac->features.touch_max;
-}
-
 static int wacom_wac_collection(struct hid_device *hdev, struct hid_report *report,
 			 int collection_index, struct hid_field *field,
 			 int field_index)
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 
-	if (WACOM_FINGER_FIELD(field))
-		wacom_set_num_expected(hdev, report, collection_index, field,
-				       field_index);
 	wacom_report_events(hdev, report, collection_index, field_index);
 
 	/*


