Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF18E449F8D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 01:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhKIAd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 19:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbhKIAd6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 19:33:58 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC2C061570;
        Mon,  8 Nov 2021 16:31:13 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x131so12505490pfc.12;
        Mon, 08 Nov 2021 16:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gtxRn0w70+QINCMazqLkViCXDpmuDRHITZX0Bqu3KpA=;
        b=B8Dk5T5OUdjz+IzY8QcbesZNOvsavlXM/M6JpFtweM7Ux0RCTeD/An8gulT9anoQyt
         bBhs/ooy2MUtIfCEDyzUVpVhvh8e0zQ9UgB9YRsmGnFBGLwIQvotsTadHElQhI3X9Qbg
         4c3P1zFtqJuGZyEwtholZA+ca+5BWf8f8aUdNwMECdJihkGEQgdyDjQkvpMDnfx3FygA
         sIFah23bIFXl0KSb6kBf7nJNr6sx641xdQSxHKPwp8nvke/0o6i4x4EmTZfKhQ/Q6+xl
         lnJD1JvevXi6Rmu4L+PXERttPNa5l2Cu0yymBya5aNDibtHIZdmrIMo003Se3Kf7zN3G
         m++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gtxRn0w70+QINCMazqLkViCXDpmuDRHITZX0Bqu3KpA=;
        b=mYd6E6d/s8XdlYrQEyGN1ZUBbFX2m9+hIoOQQaFfI2DPM21OvGdV7lYBT0BguMHHvb
         ew0LuwMomLkhvhgtgQV8plxFjGV1mFkZ7i1go5RNV+5B6GEKS3ALZN+QdYrvtalXTEuk
         6iNjvDLeAn1sAUXUURGTKKd5ZRLLzFd3q8YpJjGOa66KeapNpOPP6FE2YH3uQD/awEoP
         6vetLG8gyNmjh6GsSwf/xIeVdrcUU2FvHIUEW4lfoDpvb2bWKcfWKLk17dPHaLDxoZ/c
         nOgWyYcEhmjO1jM1cbEuTPedt51bNpxzcHj0rpYyZdaQ3uloCudqzFUFvxl6FwJ4EOCy
         K0rg==
X-Gm-Message-State: AOAM530FvmxXjrII3Ij5TIylw7wp1/+b6ywAMbKUiUYqQPw11EXUvjOj
        RdSZOwmegtvIN6C9mnK+Etga8bpwSZvGZQ==
X-Google-Smtp-Source: ABdhPJwUjai9ZVJwEdA2CZFtEKrjs3wsvxbaIzrGvS7BnG8nmG8SObGRw5TPrTAQ6Wv+md3xgjdD5g==
X-Received: by 2002:a05:6a00:2186:b0:473:5a61:a7f6 with SMTP id h6-20020a056a00218600b004735a61a7f6mr84857728pfi.15.1636417872733;
        Mon, 08 Nov 2021 16:31:12 -0800 (PST)
Received: from horus.lan (71-34-77-6.ptld.qwest.net. [71.34.77.6])
        by smtp.gmail.com with ESMTPSA id s2sm13110081pgd.13.2021.11.08.16.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 16:31:12 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        stable@vger.kernel.org
Subject: [PATCH] HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts
Date:   Mon,  8 Nov 2021 16:31:01 -0800
Message-Id: <20211109003101.425207-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/hid/wacom_wac.c | 8 +++++++-
 drivers/hid/wacom_wac.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 33a6908995b1..2a4cc39962e7 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2603,6 +2603,9 @@ static void wacom_wac_finger_event(struct hid_device *hdev,
 		return;
 
 	switch (equivalent_usage) {
+	case HID_DG_CONFIDENCE:
+		wacom_wac->hid_data.confidence = value;
+		break;
 	case HID_GD_X:
 		wacom_wac->hid_data.x = value;
 		break;
@@ -2635,7 +2638,8 @@ static void wacom_wac_finger_event(struct hid_device *hdev,
 	}
 
 	if (usage->usage_index + 1 == field->report_count) {
-		if (equivalent_usage == wacom_wac->hid_data.last_slot_field)
+		if (equivalent_usage == wacom_wac->hid_data.last_slot_field &&
+		    wacom_wac->hid_data.confidence)
 			wacom_wac_finger_slot(wacom_wac, wacom_wac->touch_input);
 	}
 }
@@ -2653,6 +2657,8 @@ static void wacom_wac_finger_pre_report(struct hid_device *hdev,
 
 	wacom_wac->is_invalid_bt_frame = false;
 
+	hid_data->confidence = true;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 8b2d4e5b2303..466b62cc16dc 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -301,6 +301,7 @@ struct hid_data {
 	bool barrelswitch;
 	bool barrelswitch2;
 	bool serialhi;
+	bool confidence;
 	int x;
 	int y;
 	int pressure;
-- 
2.33.1

