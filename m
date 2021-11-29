Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE999461DC4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348925AbhK2S3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:29:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60082 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378026AbhK2S1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:27:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DE13B815DA;
        Mon, 29 Nov 2021 18:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C160C53FC7;
        Mon, 29 Nov 2021 18:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210223;
        bh=esFw9Hvhgqzl3/OjA1Eb+5I+P7kiG+4KfjIchK0GIz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcrmd6opxjPWIWYwlLBP+4cskZlwXolamK5u3MEEqVpXK+t4GjlKWIKb7J6JWX6Da
         sXkPJxe8I+HgeMFVg8Kf5f/EfMdkvl9TNAOA5Vid+CBDxo0w2ptUxsWJMGmejrMAVD
         RI0dnG/1iRirqD/iW1UnXIBMJi82EOhl4qOWY/y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 13/92] HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts
Date:   Mon, 29 Nov 2021 19:17:42 +0100
Message-Id: <20211129181707.865374312@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
@@ -2578,6 +2578,9 @@ static void wacom_wac_finger_event(struc
 		return;
 
 	switch (equivalent_usage) {
+	case HID_DG_CONFIDENCE:
+		wacom_wac->hid_data.confidence = value;
+		break;
 	case HID_GD_X:
 		wacom_wac->hid_data.x = value;
 		break;
@@ -2610,7 +2613,8 @@ static void wacom_wac_finger_event(struc
 	}
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field)
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field &&
+		    wacom_wac->hid_data.confidence)
 			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
 	}
 }
@@ -2625,6 +2629,8 @@ static void wacom_wac_finger_pre_report(
 
 	wacom_wac->is_invalid_bt_frame = false;
 
+	hid_data->confidence = true;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -300,6 +300,7 @@ struct hid_data {
 	bool tipswitch;
 	bool barrelswitch;
 	bool barrelswitch2;
+	bool confidence;
 	int x;
 	int y;
 	int pressure;


