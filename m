Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C009DBCB5
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 07:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfJRFKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 01:10:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45356 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfJRFKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 01:10:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id r1so2654888pgj.12;
        Thu, 17 Oct 2019 22:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+EWYqOMJEOrwAelQrVSj5HwzBo+TWf7YqxT+vg7zDWE=;
        b=b3Iq1OPqK5HQfae2P8Xv3XVKssSkqfpfeT3/1YGT3uEIQvhNcGr2l98icZIPr0/lSJ
         a+t+QiS36I1nWnOkOrwj8SdfSd6sVCN3fz+metWDc3MBvB8OLaNjo7SUzodZUus4MUzM
         4In5+nYEEtfd8pKNrVpwpdvgUfoRxnJd5ALQobye+0vNGu2TJz5S5sT/rpzmo3knCr9u
         Fy9lTaJT+1X5QQ11h/Wcu6m6PYgRzfjr6iDwysJpWEgyAtYmdoRaUIeZKGpHxn3ilsUd
         P71awp+HaIeZQq1/hgktqNapCjB3B5Lp20sY0jnfmwJNffh7x95lfSAoW6Nc+vkeZMM6
         zjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+EWYqOMJEOrwAelQrVSj5HwzBo+TWf7YqxT+vg7zDWE=;
        b=Dp7oD3bFX73sF0Gv2TErfkYDPi+3BP/GWDfKbSsVzPlH4a23dcvLAQrFCHAjXx01Gc
         f0FL/yCq4LgyIrEJp6y2Kg27pfyCifwh0VV4mApN3ur6kHB8nHh4b5tN+2Rd11AIczIk
         FvSJP8feseoousmc0m3OZ4FlUxjWhmUtY0jj1hium4RfWBrjar7UNk6zwfl97ViMO/Po
         T+goCeh9joVsFeecXn6SlUf90SQs1RUF22xIIplmC86cbUKsqofaRUoPHMrtBpjq+pSi
         WSVnQq/HM6EAs40wDfX04QHus7xdVPr3PyKh5Glqu5gjrgiR5CxSmlIQ+P4miGOj/sk/
         IuTQ==
X-Gm-Message-State: APjAAAUwpheooC56ptfaK4puwTfl29Ul8XNMcg4nDseH5Oi+xrmEyfm4
        4cbz8SaWkrTxLhhSMm1ZK3Z+Pz/2dk4=
X-Google-Smtp-Source: APXvYqxa8qrbWzhgY1avVUHnvL095QM2q4yqCnOM+3ueOITrdVvKeq2Qp+8FVXqPqBMYi2/1Fornyg==
X-Received: by 2002:a17:90a:fd83:: with SMTP id cx3mr8614025pjb.64.1571373943189;
        Thu, 17 Oct 2019 21:45:43 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id b3sm3696445pjp.13.2019.10.17.21.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 21:45:42 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Sam Bazely <sambazley@fastmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 2/3] HID: logitech-hidpp: rework device validation
Date:   Thu, 17 Oct 2019 21:45:16 -0700
Message-Id: <20191018044517.6430-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191018044517.6430-1-andrew.smirnov@gmail.com>
References: <20191018044517.6430-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

G920 device only advertises REPORT_ID_HIDPP_LONG and
REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
for REPORT_ID_HIDPP_SHORT with optional=false will always fail and
prevent G920 to be recognized as a valid HID++ device.

To fix this and improve some other aspects, modify
hidpp_validate_device() as follows:

  - Inline the code of hidpp_validate_report() to simplify
    distingushing between non-present and invalid report descriptors

  - Drop the check for id >= HID_MAX_IDS || id < 0 since all of our
    IDs are static and known to satisfy that at compile time

  - Change the algorithms to check all possible report
    types (including very long report) and deem the device as a valid
    HID++ device if it supports at least one

  - Treat invalid report length as a hard stop for the validation
    algorithm, meaning that if any of the supported reports has
    invalid length we assume the worst and treat the device as a
    generic HID device.

  - Fold initialization of hidpp->very_long_report_length into
    hidpp_validate_device() since it already fetches very long report
    length and validates its value

Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be handled by this module")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204191
Reported-by: Sam Bazely <sambazley@fastmail.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@bitmath.org>
Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Cc: Austin Palmer <austinp@valvesoftware.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 5.2+
---
 drivers/hid/hid-logitech-hidpp.c | 54 ++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 85911586b3b6..6e669eb7dc69 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3498,34 +3498,45 @@ static int hidpp_get_report_length(struct hid_device *hdev, int id)
 	return report->field[0]->report_count + 1;
 }
 
-static bool hidpp_validate_report(struct hid_device *hdev, int id,
-				  int expected_length, bool optional)
+static bool hidpp_validate_device(struct hid_device *hdev)
 {
-	int report_length;
+	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
+	int id, report_length, supported_reports = 0;
+
+	id = REPORT_ID_HIDPP_SHORT;
+	report_length = hidpp_get_report_length(hdev, id);
+	if (report_length) {
+		if (report_length < HIDPP_REPORT_SHORT_LENGTH)
+			goto bad_device;
 
-	if (id >= HID_MAX_IDS || id < 0) {
-		hid_err(hdev, "invalid HID report id %u\n", id);
-		return false;
+		supported_reports++;
 	}
 
+	id = REPORT_ID_HIDPP_LONG;
 	report_length = hidpp_get_report_length(hdev, id);
-	if (!report_length)
-		return optional;
+	if (report_length) {
+		if (report_length < HIDPP_REPORT_LONG_LENGTH)
+			goto bad_device;
 
-	if (report_length < expected_length) {
-		hid_warn(hdev, "not enough values in hidpp report %d\n", id);
-		return false;
+		supported_reports++;
 	}
 
-	return true;
-}
+	id = REPORT_ID_HIDPP_VERY_LONG;
+	report_length = hidpp_get_report_length(hdev, id);
+	if (report_length) {
+		if (report_length < HIDPP_REPORT_LONG_LENGTH ||
+		    report_length > HIDPP_REPORT_VERY_LONG_MAX_LENGTH)
+			goto bad_device;
 
-static bool hidpp_validate_device(struct hid_device *hdev)
-{
-	return hidpp_validate_report(hdev, REPORT_ID_HIDPP_SHORT,
-				     HIDPP_REPORT_SHORT_LENGTH, false) &&
-	       hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
-				     HIDPP_REPORT_LONG_LENGTH, true);
+		supported_reports++;
+		hidpp->very_long_report_length = report_length;
+	}
+
+	return supported_reports;
+
+bad_device:
+	hid_warn(hdev, "not enough values in hidpp report %d\n", id);
+	return false;
 }
 
 static bool hidpp_application_equals(struct hid_device *hdev,
@@ -3572,11 +3583,6 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	}
 
-	hidpp->very_long_report_length =
-		hidpp_get_report_length(hdev, REPORT_ID_HIDPP_VERY_LONG);
-	if (hidpp->very_long_report_length > HIDPP_REPORT_VERY_LONG_MAX_LENGTH)
-		hidpp->very_long_report_length = HIDPP_REPORT_VERY_LONG_MAX_LENGTH;
-
 	if (id->group == HID_GROUP_LOGITECH_DJ_DEVICE)
 		hidpp->quirks |= HIDPP_QUIRK_UNIFYING;
 
-- 
2.21.0

