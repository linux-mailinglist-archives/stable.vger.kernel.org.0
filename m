Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AEE469AEE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346265AbhLFPLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42024 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345451AbhLFPJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:09:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C2C6B81017;
        Mon,  6 Dec 2021 15:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF8CC341C1;
        Mon,  6 Dec 2021 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803135;
        bh=0Ik3TpwB80NHWsmohbDiYpLzIbvgCl/kGtoZ2ZU64RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lsja437oBAtwJcc5XYNIiSoE90vnj7onKqksEAJmAOrgRZ4ziAfcXL0gvBufFXbZx
         eWNy7fHcF71xSN/0moaI3RtiElYzOEvuq2yBTKa8Mv+01jT7rDA5WfVV7KObt5M/7r
         0dmcSUh2Ks7oH80EaiYccrYR0czatuCVlkOp8ZhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 008/106] HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts
Date:   Mon,  6 Dec 2021 15:55:16 +0100
Message-Id: <20211206145555.683830766@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit 7fb0413baa7f8a04caef0c504df9af7e0623d296 upstream.

The HID descriptor of many of Wacom's touch input devices include a
"Confidence" usage that signals if a particular touch collection contains
useful data. The driver does not look at this flag, however, which causes
even invalid contacts to be reported to userspace. A lucky combination of
kernel event filtering and device behavior (specifically: contact ID 0 ==
invalid, contact ID >0 == valid; and order all data so that all valid
contacts are reported before any invalid contacts) spare most devices from
any visibly-bad behavior.

The DTH-2452 is one example of an unlucky device that misbehaves. It uses
ID 0 for both the first valid contact and all invalid contacts. Because
we report both the valid and invalid contacts, the kernel reports that
contact 0 first goes down (valid) and then goes up (invalid) in every
report. This causes ~100 clicks per second simply by touching the screen.

This patch inroduces new `confidence` flag in our `hid_data` structure.
The value is initially set to `true` at the start of a report and can be
set to `false` if an invalid touch usage is seen.

Link: https://github.com/linuxwacom/input-wacom/issues/270
Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    8 +++++++-
 drivers/hid/wacom_wac.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2433,6 +2433,9 @@ static void wacom_wac_finger_event(struc
 	struct wacom_features *features = &wacom->wacom_wac.features;
 
 	switch (equivalent_usage) {
+	case HID_DG_CONFIDENCE:
+		wacom_wac->hid_data.confidence = value;
+		break;
 	case HID_GD_X:
 		wacom_wac->hid_data.x = value;
 		break;
@@ -2463,7 +2466,8 @@ static void wacom_wac_finger_event(struc
 
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field)
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field &&
+		    wacom_wac->hid_data.confidence)
 			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
 	}
 }
@@ -2476,6 +2480,8 @@ static void wacom_wac_finger_pre_report(
 	struct hid_data* hid_data = &wacom_wac->hid_data;
 	int i;
 
+	hid_data->confidence = true;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -293,6 +293,7 @@ struct hid_data {
 	bool inrange_state;
 	bool invert_state;
 	bool tipswitch;
+	bool confidence;
 	int x;
 	int y;
 	int pressure;


