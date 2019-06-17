Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255FE494B3
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfFQWAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:00:37 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46593 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfFQWAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 18:00:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so4714326pls.13
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 15:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FWfclnziV2iuU2CGAka67TgMbSiiQK5WNBHqWBaBbiA=;
        b=QZqJivG94Hjd8ze4AIcLC7A98zWHB49usGoAIPY4pbi3K8p8CidxIapmZPchzVq3C2
         9O0TpCPN3/5DqeYxvOIitO6x/zyY1gRDaaU45TC4bdu1S349tGuiZ/SVSVmiav42eCYx
         +eTlIcf7HIA7Qhmzfr2+kQ+h+SoCbIA3i2nrbyIMIvR5UJp/NldXp/Tly1dmPHgmDr3F
         BhzGoFdkzpKoJwAHffttruNOtwdTJ1gl/aJ0c5Q9Nk++e0/UK73FYMlmDnfN5NsaZ8ot
         /1mUNkuYeGIkDlqklxBKqNhG6siC2PCiZfbmkM1QRapcKJoxW3T7Kew/70tqhq+Eurz6
         xauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FWfclnziV2iuU2CGAka67TgMbSiiQK5WNBHqWBaBbiA=;
        b=P8ifVqvZz/x4OfHM1KEskusyDNcN6FBKXEo99cvUbyEb7XWJHzvLrv4T8JQEpM+k+Z
         GuX12wUiqf9AKE2qjWO4OFRdB1vlDBDIuE7a7jp7EYpg9W1LnSNuy+3dwKL0klElChIY
         EJmy9b6RFbbV+n6GcOryv3gDaw2g7kx5jSwi4xiPpperhK44LuET0DcjyZ6e3N8QqInp
         OgJ9hr0S1rBK8nYmeGwgguv9XGSMHkljCPDH1Tyfvr8ILC9n0K+NyqYuD2GYWIvoih8D
         WIlBF+WiORAIRcl9mGZcvYPa1TxUsBUiDGWs1JixG+4XIlMmNQkKgKwvPhVVwnff5Ksg
         Y1XA==
X-Gm-Message-State: APjAAAU39XtqAxMJJqX44dsXcXEazvvD2B1oVCo/Rm0LTnh/a9NTHWbg
        HDMzP/ZtIWTtCPgu05lR1xDbIlhR
X-Google-Smtp-Source: APXvYqzO2ccdWZtGvTOnnTOd0FmJ3T0mMMIwB3ggqcYOE5Dy29bLgTsmO8V8yOD2AL5/+d5PevApfQ==
X-Received: by 2002:a17:902:1003:: with SMTP id b3mr111721575pla.172.1560808836206;
        Mon, 17 Jun 2019 15:00:36 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id g5sm19349579pfm.54.2019.06.17.15.00.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 15:00:35 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     stable@vger.kernel.org
Cc:     Aaron Armstrong Skomra <skomra@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Subject: [PATCH 2/3] HID: wacom: Don't report anything prior to the tool entering range
Date:   Mon, 17 Jun 2019 15:00:33 -0700
Message-Id: <20190617220033.13515-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <15606126834326@kroah.com>
References: <15606126834326@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

If the tool spends some time in prox before entering range, a series of
events (e.g. ABS_DISTANCE, MSC_SERIAL) can be sent before we or userspace
have any clue about the pen whose data is being reported. We need to hold
off on reporting anything until the pen has entered range. Since we still
want to report events that occur "in prox" after the pen has *left* range
we use 'wacom-tool[0]' as the indicator that the pen did at one point
enter range and provide us/userspace with tool type and serial number
information.

Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
Original commit in Linus' tree: e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc

 drivers/hid/wacom_wac.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 53363368da8c..274867227d50 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1271,17 +1271,19 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 			input_report_abs(pen_input, ABS_Z, rotation);
 			input_report_abs(pen_input, ABS_WHEEL, get_unaligned_le16(&frame[11]));
 		}
-		input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
-		input_report_abs(pen_input, ABS_DISTANCE, range ? frame[13] : wacom->features.distance_max);
-
-		input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
-		input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
-		input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
-
-		input_report_key(pen_input, wacom->tool[0], prox);
-		input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
-		input_report_abs(pen_input, ABS_MISC,
-				 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+		if (wacom->tool[0]) {
+			input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
+			input_report_abs(pen_input, ABS_DISTANCE, range ? frame[13] : wacom->features.distance_max);
+
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
+			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
+
+			input_report_key(pen_input, wacom->tool[0], prox);
+			input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
+			input_report_abs(pen_input, ABS_MISC,
+					 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+		}
 
 		wacom->shared->stylus_in_proximity = prox;
 
-- 
2.22.0

