Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99178499E4C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452501AbiAXWb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584546AbiAXWVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B48C0424CE;
        Mon, 24 Jan 2022 12:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FD92B81057;
        Mon, 24 Jan 2022 20:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04A9C340E5;
        Mon, 24 Jan 2022 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057404;
        bh=n3qzIhkJTs5Zt29pol17QM7Ob/p00R3z1XaX+um3/So=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3zm8Xudss2/2EWkWkCjEGY7taNnZ4Ux+e6AHXZPY9uzDaMcc+Qx624Hsg1wjd3j2
         dTwSrLyHeIBqBwiLKYCogRHMIgaVTpXlHQJ6aRdXw+1jqLjdipWlrtZahY8vQWhV0e
         8o8Mb+xUPrymQEGkbGpqMg3w8S32gyp5lip7V8VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.15 802/846] HID: vivaldi: fix handling devices not using numbered reports
Date:   Mon, 24 Jan 2022 19:45:19 +0100
Message-Id: <20220124184128.608152274@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 3fe6acd4dc922237b30e55473c9349c6ce0690f3 upstream.

Unfortunately details of USB HID transport bled into HID core and
handling of numbered/unnumbered reports is quite a mess, with
hid_report_len() calculating the length according to USB rules,
and hid_hw_raw_request() adding report ID to the buffer for both
numbered and unnumbered reports.

Untangling it all requres a lot of changes in HID, so for now let's
handle this in the driver.

[jkosina@suse.cz: microoptimize field->report->id to report->id]
Fixes: 14c9c014babe ("HID: add vivaldi HID driver")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Stephen Boyd <swboyd@chromium.org> # CoachZ
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-vivaldi.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-vivaldi.c
+++ b/drivers/hid/hid-vivaldi.c
@@ -74,10 +74,11 @@ static void vivaldi_feature_mapping(stru
 				    struct hid_usage *usage)
 {
 	struct vivaldi_data *drvdata = hid_get_drvdata(hdev);
+	struct hid_report *report = field->report;
 	int fn_key;
 	int ret;
 	u32 report_len;
-	u8 *buf;
+	u8 *report_data, *buf;
 
 	if (field->logical != HID_USAGE_FN_ROW_PHYSMAP ||
 	    (usage->hid & HID_USAGE_PAGE) != HID_UP_ORDINAL)
@@ -89,12 +90,24 @@ static void vivaldi_feature_mapping(stru
 	if (fn_key > drvdata->max_function_row_key)
 		drvdata->max_function_row_key = fn_key;
 
-	buf = hid_alloc_report_buf(field->report, GFP_KERNEL);
-	if (!buf)
+	report_data = buf = hid_alloc_report_buf(report, GFP_KERNEL);
+	if (!report_data)
 		return;
 
-	report_len = hid_report_len(field->report);
-	ret = hid_hw_raw_request(hdev, field->report->id, buf,
+	report_len = hid_report_len(report);
+	if (!report->id) {
+		/*
+		 * hid_hw_raw_request() will stuff report ID (which will be 0)
+		 * into the first byte of the buffer even for unnumbered
+		 * reports, so we need to account for this to avoid getting
+		 * -EOVERFLOW in return.
+		 * Note that hid_alloc_report_buf() adds 7 bytes to the size
+		 * so we can safely say that we have space for an extra byte.
+		 */
+		report_len++;
+	}
+
+	ret = hid_hw_raw_request(hdev, report->id, report_data,
 				 report_len, HID_FEATURE_REPORT,
 				 HID_REQ_GET_REPORT);
 	if (ret < 0) {
@@ -103,7 +116,16 @@ static void vivaldi_feature_mapping(stru
 		goto out;
 	}
 
-	ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, buf,
+	if (!report->id) {
+		/*
+		 * Undo the damage from hid_hw_raw_request() for unnumbered
+		 * reports.
+		 */
+		report_data++;
+		report_len--;
+	}
+
+	ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, report_data,
 				   report_len, 0);
 	if (ret) {
 		dev_warn(&hdev->dev, "failed to report feature %d\n",


