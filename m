Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B424930E5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiARWiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbiARWiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:38:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555FDC061574;
        Tue, 18 Jan 2022 14:38:12 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so4237566pja.1;
        Tue, 18 Jan 2022 14:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqR4N7krQJrOILNCzXEdQTQxOcbR9JvCWiyukEJ9ZNY=;
        b=OKkAj2NEFHHn8Xsv/uA8eGcjb7rHMIU9SMEWXHvaFRPdEtFCOwCcwb4IJk8eJ7I/bz
         2zrzSYWXpYvvYTHM2xw89AFZ2K+S+Y9A2bR3v8VvLkWy8b071ucXYHZR92tC8o5NV8NB
         8RjdsI13fkboKqizvmncCtfFDcLS1ov5d2wsCfMAOEbRRVN+qohpqPi3b7F9kbkrAySb
         fXZzHR126pIuF0RskYM8UrYrXkYhv6dhJRUUleanB9rVzrrBczstHfPyrtTuHfLn2IYW
         qf2iiA7qKBXJOPwI1/f7lWCarUM3RV7B02k12kSD3hINX4+rhZciJNDR1SmEIGbC/cTE
         DwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqR4N7krQJrOILNCzXEdQTQxOcbR9JvCWiyukEJ9ZNY=;
        b=xekxr5DVpV6pRio7/ADiSYqngZ2pbnPu71mWUULdzKK4uciPWj8jO9NnBVyI3K+Zh5
         zIMhq2Z1FpMny8e4c7oPAcZTlwzo48NtN57hoIDSwRs8MvRBqFIVT1WL3ro2V82wHvIO
         exKKv/i+cfCIAtzU0Uku7DECvQyDgsMrC+p9GDBlgWTtLM8A8tcY6RTbD8JY9mb/M/3H
         4Q3ReGgd38HrSva/fkkXFyNH3GrAXg8Ycu0YQswkiZ/sZmp0gMJkG2ISNqXJc2YqanIA
         QTrMcUY1bEniH0g3ajoysPRU6hDr7mDODtMTVXczlJfQA3wevo4Xb6q/gHKp1f+qnQMZ
         EaNw==
X-Gm-Message-State: AOAM530N/aKVs4TyFSAi/5s4SW9TFroAHzapxOhNX3+lB33/afG1jOFw
        zBKkZ6wreuhtMw5nxfOFBqgk9rJ0RaY=
X-Google-Smtp-Source: ABdhPJwOh8YIusc2fX/enHKj0su7dB4pzy4ncSMZAa8QHLZrMlQx9rr8dTnuXh13moQoG2yUdVbMyQ==
X-Received: by 2002:a17:90b:3e8e:: with SMTP id rj14mr823152pjb.179.1642545491603;
        Tue, 18 Jan 2022 14:38:11 -0800 (PST)
Received: from horus.lan (75-164-184-207.ptld.qwest.net. [75.164.184.207])
        by smtp.gmail.com with ESMTPSA id pf16sm3433250pjb.35.2022.01.18.14.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 14:38:10 -0800 (PST)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH 1/2] HID: wacom: Reset expected and received contact counts at the same time
Date:   Tue, 18 Jan 2022 14:37:55 -0800
Message-Id: <20220118223756.45624-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These two values go hand-in-hand and must be valid for the driver to
behave correctly. We are currently lazy about updating the values and
rely on the "expected" code flow to take care of making sure they're
valid at the point they're needed. The "expected" flow changed somewhat
with commit f8b6a74719b5 ("HID: wacom: generic: Support multiple tools
per report"), however. This led to problems with the DTH-2452 due (in
part) to *all* contacts being fully processed -- even those past the
expected contact count. Specifically, the received count gets reset to
0 once all expected fingers are processed, but not the expected count.
The rest of the contacts in the report are then *also* processed since
now the driver thinks we've only processed 0 of N expected contacts.

Later commits such as 7fb0413baa7f (HID: wacom: Use "Confidence" flag to
prevent reporting invalid contacts) worked around the DTH-2452 issue by
skipping the invalid contacts at the end of the report, but this is not
a complete fix. The confidence flag cannot be relied on when a contact
is removed (see the following patch), and dealing with that condition
re-introduces the DTH-2452 issue unless we also address this contact
count laziness. By resetting expected and received counts at the same
time we ensure the driver understands that there are 0 more contacts
expected in the report. Similarly, we also make sure to reset the
received count if for some reason we're out of sync in the pre-report
phase.

Link: https://github.com/linuxwacom/input-wacom/issues/288
Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_wac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 2a4cc39962e7..5978399ae7d2 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2692,11 +2692,14 @@ static void wacom_wac_finger_pre_report(struct hid_device *hdev,
 	    hid_data->cc_index >= 0) {
 		struct hid_field *field = report->field[hid_data->cc_index];
 		int value = field->value[hid_data->cc_value_index];
-		if (value)
+		if (value) {
 			hid_data->num_expected = value;
+			hid_data->num_received = 0;
+		}
 	}
 	else {
 		hid_data->num_expected = wacom_wac->features.touch_max;
+		hid_data->num_received = 0;
 	}
 }
 
@@ -2724,6 +2727,7 @@ static void wacom_wac_finger_report(struct hid_device *hdev,
 
 	input_sync(input);
 	wacom_wac->hid_data.num_received = 0;
+	wacom_wac->hid_data.num_expected = 0;
 
 	/* keep touch state for pen event */
 	wacom_wac->shared->touch_down = wacom_wac_finger_count_touches(wacom_wac);
-- 
2.34.1

