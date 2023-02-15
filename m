Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A267169861E
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBOUsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBOUrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69304344C;
        Wed, 15 Feb 2023 12:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A96461D52;
        Wed, 15 Feb 2023 20:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E089C433EF;
        Wed, 15 Feb 2023 20:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494002;
        bh=/7LYG/t2un+e+jyUyYoutBm1iPp3dYGtaK/RkiDv1hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF6fyAHQ2Yf9gHWn/hbQpF7trlrfN99ueiR5o0T3xe+CSkxw0xuDU9nABLy8H7WZx
         UYGcueUmnY9BiqUFzggLNwHBlwLokoqTEpS7MooiuKanj2Z+kv/LCg28cSLM9yM96P
         T0B/Qj5bIDAvrUX5v8fE5ykKFPiM6iUC42uQLOeA7Qtt1EFn67m16ljIrbobaxgNQg
         pbsgMYbtJHnaKXP7PmWaic1HpmUuOLRqVGGa8Y2YqYZF7SCDmtMxGsizXgpLcOnred
         3h3/16LQTSDK/04OQbSazJSarkgDCIbEXWpeW2js/kIRp/Yh8/pt+ygkww5TfgYEQF
         SzydJfVrOEamQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takahiro Fujii <fujii@xaxxi.net>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/12] HID: elecom: add support for TrackBall 056E:011C
Date:   Wed, 15 Feb 2023 15:46:27 -0500
Message-Id: <20230215204637.2761073-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204637.2761073-1-sashal@kernel.org>
References: <20230215204637.2761073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Fujii <fujii@xaxxi.net>

[ Upstream commit 29f316a1d7e0a570be9a47fa283ece53a67cebb7 ]

Make function buttons on ELECOM M-HT1DRBK trackball mouse work. This model
has two devices with different device IDs (010D and 011C). Both of
them misreports the number of buttons as 5 in the report descriptor, even
though they have 8 buttons. hid-elecom overwrites the report to fix them,
but supports only on 010D and does not work on 011C. This patch fixes
011C in the similar way but with specialized position parameters.
In fact, it is sufficient to rewrite only 17th byte (05 -> 08). However I
followed the existing way.

Signed-off-by: Takahiro Fujii <fujii@xaxxi.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elecom.c | 16 ++++++++++++++--
 drivers/hid/hid-ids.h    |  3 ++-
 drivers/hid/hid-quirks.c |  3 ++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index e59e9911fc370..4fa45ee77503b 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -12,6 +12,7 @@
  *  Copyright (c) 2017 Alex Manoussakis <amanou@gnu.org>
  *  Copyright (c) 2017 Tomasz Kramkowski <tk@the-tk.com>
  *  Copyright (c) 2020 YOSHIOKA Takuma <lo48576@hard-wi.red>
+ *  Copyright (c) 2022 Takahiro Fujii <fujii@xaxxi.net>
  */
 
 /*
@@ -89,7 +90,7 @@ static __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	case USB_DEVICE_ID_ELECOM_M_DT1URBK:
 	case USB_DEVICE_ID_ELECOM_M_DT1DRBK:
 	case USB_DEVICE_ID_ELECOM_M_HT1URBK:
-	case USB_DEVICE_ID_ELECOM_M_HT1DRBK:
+	case USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D:
 		/*
 		 * Report descriptor format:
 		 * 12: button bit count
@@ -99,6 +100,16 @@ static __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		mouse_button_fixup(hdev, rdesc, *rsize, 12, 30, 14, 20, 8);
 		break;
+	case USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C:
+		/*
+		 * Report descriptor format:
+		 * 22: button bit count
+		 * 30: padding bit count
+		 * 24: button report size
+		 * 16: button usage maximum
+		 */
+		mouse_button_fixup(hdev, rdesc, *rsize, 22, 30, 24, 16, 8);
+		break;
 	}
 	return rdesc;
 }
@@ -112,7 +123,8 @@ static const struct hid_device_id elecom_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, elecom_devices);
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index fa1aa22547ea7..b153ddc3319e8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -410,7 +410,8 @@
 #define USB_DEVICE_ID_ELECOM_M_DT1URBK	0x00fe
 #define USB_DEVICE_ID_ELECOM_M_DT1DRBK	0x00ff
 #define USB_DEVICE_ID_ELECOM_M_HT1URBK	0x010c
-#define USB_DEVICE_ID_ELECOM_M_HT1DRBK	0x010d
+#define USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D	0x010d
+#define USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C	0x011c
 
 #define USB_VENDOR_ID_DREAM_CHEEKY	0x1d34
 #define USB_DEVICE_ID_DREAM_CHEEKY_WN	0x0004
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 184029cad014f..4a8c32148e58f 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -381,7 +381,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1URBK) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_010D) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1DRBK_011C) },
 #endif
 #if IS_ENABLED(CONFIG_HID_ELO)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, 0x0009) },
-- 
2.39.0

