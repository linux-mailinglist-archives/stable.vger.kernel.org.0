Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8C582B70
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiG0QdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237778AbiG0Qcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:32:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415E953D04;
        Wed, 27 Jul 2022 09:26:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CBC2B821BF;
        Wed, 27 Jul 2022 16:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC04FC433C1;
        Wed, 27 Jul 2022 16:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939179;
        bh=ZNOEerogwL3QPkDGQqI5U5SJ+ivJ/Zl/Vr1t0W0P1UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4jXdI5fpZELXJPRlxVcY1Kwm//Nyt1foA6OLCc0vlafc45RlzNHVn7wCahCqz1tP
         bdYFfm0ZGkwx3DPVBJuP0NHGjsef3I+CHvxsbEJZxYCNWZ61tGWnHdNQeAK1H2Ya+6
         Tx6tMwEXN4ocjuGfnKD7Y5sUmc8uWrJEdYciowFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [PATCH 4.19 40/62] HID: multitouch: add support for the Smart Tech panel
Date:   Wed, 27 Jul 2022 18:10:49 +0200
Message-Id: <20220727161005.764401878@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

[ Upstream commit 69ecd44d68a7bf4caeda39825af720362db69233 ]

This panel is not very friendly to us:
it exposes multiple multitouch collections, some of them being of
logical application stylus.

Usually, a device has only one report per application, and that is
what I assumed in commit 8dfe14b3b47f ("HID: multitouch: ditch mt_report_id")

To avoid breaking all working device, add a new class and a new quirk
for that situation.

Reported-and-tested-by: Matthias Fend <Matthias.Fend@wolfvision.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1c4426c60972..ce027eda9b17 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -72,6 +72,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_STICKY_FINGERS		BIT(16)
 #define MT_QUIRK_ASUS_CUSTOM_UP		BIT(17)
 #define MT_QUIRK_WIN8_PTP_BUTTONS	BIT(18)
+#define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -107,6 +108,7 @@ struct mt_usages {
 struct mt_application {
 	struct list_head list;
 	unsigned int application;
+	unsigned int report_id;
 	struct list_head mt_usages;	/* mt usages list */
 
 	__s32 quirks;
@@ -207,6 +209,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_VTL				0x0110
 #define MT_CLS_GOOGLE				0x0111
 #define MT_CLS_RAZER_BLADE_STEALTH		0x0112
+#define MT_CLS_SMART_TECH			0x0113
 
 #define MT_DEFAULT_MAXCONTACT	10
 #define MT_MAX_MAXCONTACT	250
@@ -357,6 +360,12 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_WIN8_PTP_BUTTONS,
 	},
+	{ .name = MT_CLS_SMART_TECH,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_SEPARATE_APP_REPORT,
+	},
 	{ }
 };
 
@@ -513,8 +522,9 @@ static struct mt_usages *mt_allocate_usage(struct hid_device *hdev,
 }
 
 static struct mt_application *mt_allocate_application(struct mt_device *td,
-						      unsigned int application)
+						      struct hid_report *report)
 {
+	unsigned int application = report->application;
 	struct mt_application *mt_application;
 
 	mt_application = devm_kzalloc(&td->hdev->dev, sizeof(*mt_application),
@@ -539,6 +549,7 @@ static struct mt_application *mt_allocate_application(struct mt_device *td,
 	mt_application->scantime = DEFAULT_ZERO;
 	mt_application->raw_cc = DEFAULT_ZERO;
 	mt_application->quirks = td->mtclass.quirks;
+	mt_application->report_id = report->id;
 
 	list_add_tail(&mt_application->list, &td->applications);
 
@@ -546,19 +557,23 @@ static struct mt_application *mt_allocate_application(struct mt_device *td,
 }
 
 static struct mt_application *mt_find_application(struct mt_device *td,
-						  unsigned int application)
+						  struct hid_report *report)
 {
+	unsigned int application = report->application;
 	struct mt_application *tmp, *mt_application = NULL;
 
 	list_for_each_entry(tmp, &td->applications, list) {
 		if (application == tmp->application) {
-			mt_application = tmp;
-			break;
+			if (!(td->mtclass.quirks & MT_QUIRK_SEPARATE_APP_REPORT) ||
+			    tmp->report_id == report->id) {
+				mt_application = tmp;
+				break;
+			}
 		}
 	}
 
 	if (!mt_application)
-		mt_application = mt_allocate_application(td, application);
+		mt_application = mt_allocate_application(td, report);
 
 	return mt_application;
 }
@@ -575,7 +590,7 @@ static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
 		return NULL;
 
 	rdata->report = report;
-	rdata->application = mt_find_application(td, report->application);
+	rdata->application = mt_find_application(td, report);
 
 	if (!rdata->application) {
 		devm_kfree(&td->hdev->dev, rdata);
@@ -1571,6 +1586,9 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	case HID_VD_ASUS_CUSTOM_MEDIA_KEYS:
 		suffix = "Custom Media Keys";
 		break;
+	case HID_DG_PEN:
+		suffix = "Stylus";
+		break;
 	default:
 		suffix = "UNKNOWN";
 		break;
@@ -2038,6 +2056,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_SYNAPTICS, 0x8323) },
 
+	/* Smart Tech panels */
+	{ .driver_data = MT_CLS_SMART_TECH,
+		MT_USB_DEVICE(0x0b8c, 0x0092)},
+
 	/* Stantum panels */
 	{ .driver_data = MT_CLS_CONFIDENCE,
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
-- 
2.35.1



