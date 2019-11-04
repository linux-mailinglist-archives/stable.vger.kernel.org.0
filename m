Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4461CEEE45
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390370AbfKDWJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390047AbfKDWJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:21 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38FD217F5;
        Mon,  4 Nov 2019 22:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905360;
        bh=F11OIyybmXWTD+0HmLsrSH+TXw7EJfZ/N53pkdzMMPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sX7j5M2N9+i8laADpYSeqVnipO/ZKe8Tzev8bS08kkm/mLtpGJCfOfz1blJo5wMWk
         uElWEBwXSvC1+QyzwtnNDjKSZjUIltTGx21hkAOlqJilTEBR4P9BFElETSwBvlF8ig
         16z3/BbMnMuUYYtSEYfPniu6N8E6E1p3rmNDIhcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bazely <sambazley@fastmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 5.3 119/163] HID: logitech-hidpp: rework device validation
Date:   Mon,  4 Nov 2019 22:45:09 +0100
Message-Id: <20191104212148.837477552@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

commit 905d754c53a522aacf806ea1d3e7c929148c1910 upstream.

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
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-hidpp.c |   54 +++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3498,34 +3498,45 @@ static int hidpp_get_report_length(struc
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
@@ -3572,11 +3583,6 @@ static int hidpp_probe(struct hid_device
 		return hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	}
 
-	hidpp->very_long_report_length =
-		hidpp_get_report_length(hdev, REPORT_ID_HIDPP_VERY_LONG);
-	if (hidpp->very_long_report_length > HIDPP_REPORT_VERY_LONG_MAX_LENGTH)
-		hidpp->very_long_report_length = HIDPP_REPORT_VERY_LONG_MAX_LENGTH;
-
 	if (id->group == HID_GROUP_LOGITECH_DJ_DEVICE)
 		hidpp->quirks |= HIDPP_QUIRK_UNIFYING;
 


