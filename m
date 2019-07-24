Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD5073C95
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405152AbfGXT72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405141AbfGXT72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:59:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6529922ADF;
        Wed, 24 Jul 2019 19:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998366;
        bh=kX32MHwNiAOJS5zlY7QwQjiZTmKuh5XWwTr7NoRvoKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt5SGChHUala3KCILM0WCkwfPH3xGec7wBd4IVDThEf3VShyNA7fr+SLeCAn/ol/7
         mW4Iwdmo4Yieuiq/g4Tg8jD9g/1mDY/bjGec27QIq+7QTD1yn1zipNv4EsSiboRyrp
         sFiI78Y4VDNN+JyKIpLdMQhNv1+JlXiE0a7/vK+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.1 338/371] HID: wacom: generic: Correct pad syncing
Date:   Wed, 24 Jul 2019 21:21:30 +0200
Message-Id: <20190724191749.129260134@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Armstrong Skomra <skomra@gmail.com>

commit d4b8efeb46d99a5d02e7f88ac4eaccbe49370770 upstream.

Only sync the pad once per report, not once per collection.
Also avoid syncing the pad on battery reports.

Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2121,14 +2121,12 @@ static void wacom_wac_pad_report(struct
 	bool active = wacom_wac->hid_data.inrange_state != 0;
 
 	/* report prox for expresskey events */
-	if ((wacom_equivalent_usage(field->physical) == HID_DG_TABLETFUNCTIONKEY) &&
-	    wacom_wac->hid_data.pad_input_event_flag) {
+	if (wacom_wac->hid_data.pad_input_event_flag) {
 		input_event(input, EV_ABS, ABS_MISC, active ? PAD_DEVICE_ID : 0);
 		input_sync(input);
 		if (!active)
 			wacom_wac->hid_data.pad_input_event_flag = false;
 	}
-
 }
 
 static void wacom_wac_pen_usage_mapping(struct hid_device *hdev,
@@ -2704,9 +2702,7 @@ static int wacom_wac_collection(struct h
 	if (report->type != HID_INPUT_REPORT)
 		return -1;
 
-	if (WACOM_PAD_FIELD(field) && wacom->wacom_wac.pad_input)
-		wacom_wac_pad_report(hdev, report, field);
-	else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
+	if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
 		wacom_wac_pen_report(hdev, report);
 	else if (WACOM_FINGER_FIELD(field) && wacom->wacom_wac.touch_input)
 		wacom_wac_finger_report(hdev, report);
@@ -2720,7 +2716,7 @@ void wacom_wac_report(struct hid_device
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
 	struct hid_field *field;
 	bool pad_in_hid_field = false, pen_in_hid_field = false,
-		finger_in_hid_field = false;
+		finger_in_hid_field = false, true_pad = false;
 	int r;
 	int prev_collection = -1;
 
@@ -2736,6 +2732,8 @@ void wacom_wac_report(struct hid_device
 			pen_in_hid_field = true;
 		if (WACOM_FINGER_FIELD(field))
 			finger_in_hid_field = true;
+		if (wacom_equivalent_usage(field->physical) == HID_DG_TABLETFUNCTIONKEY)
+			true_pad = true;
 	}
 
 	wacom_wac_battery_pre_report(hdev, report);
@@ -2759,6 +2757,9 @@ void wacom_wac_report(struct hid_device
 	}
 
 	wacom_wac_battery_report(hdev, report);
+
+	if (true_pad && wacom->wacom_wac.pad_input)
+		wacom_wac_pad_report(hdev, report, field);
 }
 
 static int wacom_bpt_touch(struct wacom_wac *wacom)


