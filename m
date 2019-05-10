Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D711A539
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 00:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfEJWbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 18:31:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34379 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfEJWbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 18:31:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id n19so3938463pfa.1;
        Fri, 10 May 2019 15:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lFv1Iq80gvrOpz16EdFxXij3OTXcsreYnHEwj2xRAtA=;
        b=EE50nItZ66Nl0djP9SQezKGqpi+0x5zbIIja4ygYFlFyiLqBFRhHbYqgCgeY0pJ/BM
         u7wR2NR6q7P9OYcAnLZA16KKA5j0stsZz9ENWiqW6/+EvHiMKDzRZFt8bGKo/CJ6wWvk
         XAev27tGS6iHNh7knaIMJNC2klCEfbO+GJT/QNzfYcxhLAJFF7m5reYT2580AaThlnrp
         0IWfsSg2K0Uaiph6p2IySqvACkiNK+oEr4/2wkp2LRN8tLKedeFEanh6AHtU5iAxFp8y
         rRzZzoEgxBtFI6RHyxUHS0jj6oOV+DglS9AbTh2sQ/OjqlYV0OkG1DEgK3ItIV9o/Jur
         N9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lFv1Iq80gvrOpz16EdFxXij3OTXcsreYnHEwj2xRAtA=;
        b=Cy0pP00lCBBb/RZvCDPY9tZFerKK7q6vAZxtwp9Q0+/q1KaygugRIxEJd5kBeyyayA
         kShuENCxMJztK368f6o1OSqi+sd16YPMhksB4dtPAYR3PHglooR2pJtKOXl/HGvKyvXL
         JNt12/ohs9R1A3s5ImsukuLE8T/4PiB2PgwcoHDIV1uh3MNb6znhOIKmeAQkB95pdndI
         S+jEzG/h+XttEVyLtknsL+XWr5hPzMO7nJjkYb5H6musH94ycrdDCuvvp/VZCsb9mHO8
         D8UIGNlXslc3fPaz/OtlQfDMT9UxagN+mjy3u3CHtaIV4WPjGtDnDD2TdG0mj57O7fH2
         32bw==
X-Gm-Message-State: APjAAAVdGaM1lYem6Dfg7l7KDG/gxNRaUakSD/5kzsxKcGtf3yPii2m2
        Gp3DkYtx+oo7S5IZM/1xDCkGV5A0
X-Google-Smtp-Source: APXvYqzbEzmWUgHOseTNVtlwbhota1QVglvcChLF/yfewQqxYengQx1JuPpOE2BXtpQQPHvldgHWBA==
X-Received: by 2002:a63:8242:: with SMTP id w63mr16486766pgd.169.1557527512546;
        Fri, 10 May 2019 15:31:52 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id i15sm14601205pfj.167.2019.05.10.15.31.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 May 2019 15:31:51 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, pinglinux@gmail.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 11+" <stable@vger.kernel.org>
Subject: [PATCH 1/4] HID: wacom: generic: only switch the mode on devices with LEDs
Date:   Fri, 10 May 2019 15:31:16 -0700
Message-Id: <1557527479-9242-2-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557527479-9242-1-git-send-email-aaron.skomra@wacom.com>
References: <1557527479-9242-1-git-send-email-aaron.skomra@wacom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, the driver will attempt to set the mode on all
devices with a center button, but some devices with a center
button lack LEDs, and attempting to set the LEDs on devices
without LEDs results in the kernel error message of the form:

"leds input8::wacom-0.1: Setting an LED's brightness failed (-32)"

This is because the generic codepath erroneously assumes that the
BUTTON_CENTER usage indicates that the device has LEDs, the
previously ignored TOUCH_RING_SETTING usage is a more accurate
indication of the existence of LEDs on the device.

Fixes: 10c55cacb8b2 ("HID: wacom: generic: support LEDs")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
---
 drivers/hid/wacom_sys.c | 3 +++
 drivers/hid/wacom_wac.c | 2 --
 drivers/hid/wacom_wac.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index a8633b1437b2..2e3e03df83da 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -307,6 +307,9 @@ static void wacom_feature_mapping(struct hid_device *hdev,
 	wacom_hid_usage_quirk(hdev, field, usage);
 
 	switch (equivalent_usage) {
+	case WACOM_HID_WD_TOUCH_RING_SETTING:
+		wacom->generic_has_leds = true;
+		break;
 	case HID_DG_CONTACTMAX:
 		/* leave touch_max as is if predefined */
 		if (!features->touch_max) {
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 09b8e4aac82f..10cce2ca6301 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1930,8 +1930,6 @@ static void wacom_wac_pad_usage_mapping(struct hid_device *hdev,
 		features->device_type |= WACOM_DEVICETYPE_PAD;
 		break;
 	case WACOM_HID_WD_BUTTONCENTER:
-		wacom->generic_has_leds = true;
-		/* fall through */
 	case WACOM_HID_WD_BUTTONHOME:
 	case WACOM_HID_WD_BUTTONUP:
 	case WACOM_HID_WD_BUTTONDOWN:
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 295fd3718caa..f67d871841c0 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -145,6 +145,7 @@
 #define WACOM_HID_WD_OFFSETBOTTOM       (WACOM_HID_UP_WACOMDIGITIZER | 0x0d33)
 #define WACOM_HID_WD_DATAMODE           (WACOM_HID_UP_WACOMDIGITIZER | 0x1002)
 #define WACOM_HID_WD_DIGITIZERINFO      (WACOM_HID_UP_WACOMDIGITIZER | 0x1013)
+#define WACOM_HID_WD_TOUCH_RING_SETTING (WACOM_HID_UP_WACOMDIGITIZER | 0x1032)
 #define WACOM_HID_UP_G9                 0xff090000
 #define WACOM_HID_G9_PEN                (WACOM_HID_UP_G9 | 0x02)
 #define WACOM_HID_G9_TOUCHSCREEN        (WACOM_HID_UP_G9 | 0x11)
-- 
2.7.4

