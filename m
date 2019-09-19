Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B64BEB849B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393628AbfISWM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391973AbfISWM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:12:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1757521924;
        Thu, 19 Sep 2019 22:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931146;
        bh=C352ig95Cnl2hNPEuIRDkw7hNqy6LmYCVfFPyHgPzfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZaMRAGhAFybzbIZv7wq/as8L0P0yBrR+2I9a7lLrr/U1t96MgoUChj22uUYjH3eZ
         QR3ICCNzZdnMsJj//Qs052qAJ7OYTEX+oUX7UFiFDic7eDTqwUEFMEOBojWOD4niER
         gWjtue6ylEfvbwIzHYFMjgQr1SAaJJCUlm5AhYwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 02/79] HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report
Date:   Fri, 20 Sep 2019 00:02:47 +0200
Message-Id: <20190919214807.959879649@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Armstrong Skomra <skomra@gmail.com>

commit 184eccd40389df29abefab88092c4ff33191fd0c upstream.

In the generic code path, HID_DG_CONTACTMAX was previously
only read from the second byte of report 0x23.

Another report (0x82) has the HID_DG_CONTACTMAX in the
higher nibble of the third byte. We should support reading the
value of HID_DG_CONTACTMAX no matter what report we are reading
or which position that value is in.

To do this we submit the feature report as a event report
using hid_report_raw_event(). Our modified finger event path
records the value of HID_DG_CONTACTMAX when it sees that usage.

Fixes: 8ffffd5212846 ("HID: wacom: fix timeout on probe for some wacoms")
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_sys.c |   10 ++++++----
 drivers/hid/wacom_wac.c |    4 ++++
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -282,14 +282,16 @@ static void wacom_feature_mapping(struct
 		/* leave touch_max as is if predefined */
 		if (!features->touch_max) {
 			/* read manually */
-			data = kzalloc(2, GFP_KERNEL);
+			n = hid_report_len(field->report);
+			data = hid_alloc_report_buf(field->report, GFP_KERNEL);
 			if (!data)
 				break;
 			data[0] = field->report->id;
 			ret = wacom_get_report(hdev, HID_FEATURE_REPORT,
-						data, 2, WAC_CMD_RETRIES);
-			if (ret == 2) {
-				features->touch_max = data[1];
+					       data, n, WAC_CMD_RETRIES);
+			if (ret == n) {
+				ret = hid_report_raw_event(hdev,
+					HID_FEATURE_REPORT, data, n, 0);
 			} else {
 				features->touch_max = 16;
 				hid_warn(hdev, "wacom_feature_mapping: "
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2533,6 +2533,7 @@ static void wacom_wac_finger_event(struc
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
 	unsigned equivalent_usage = wacom_equivalent_usage(usage->hid);
+	struct wacom_features *features = &wacom->wacom_wac.features;
 
 	switch (equivalent_usage) {
 	case HID_GD_X:
@@ -2553,6 +2554,9 @@ static void wacom_wac_finger_event(struc
 	case HID_DG_TIPSWITCH:
 		wacom_wac->hid_data.tipswitch = value;
 		break;
+	case HID_DG_CONTACTMAX:
+		features->touch_max = value;
+		return;
 	}
 
 


