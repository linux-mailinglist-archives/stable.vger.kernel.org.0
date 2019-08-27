Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0E59E1CC
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbfH0H4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbfH0H4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A26C720828;
        Tue, 27 Aug 2019 07:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892570;
        bh=szNqJgC9d5Ndna8YoKeMJQN4lU7/tFfd7KS/NIiUoh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoaZ0HVGwbZuuqn/cwmv4o9CCAnohU8NTTx9NUvapEsE8gSC0YWaBDcrGVqo6uXUA
         85CpKLHNntfeMiJPH1DQctPfGlEx+Z8KeV8v8oDppZvzt3Sxt49al2JaVSSfHFggqI
         Y03czUFqGLptppaqhuVtdd+lJxdaUxovEHT9dktQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/98] HID: input: fix a4tech horizontal wheel custom usage
Date:   Tue, 27 Aug 2019 09:50:16 +0200
Message-Id: <20190827072720.155829104@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1c703b53e5bfb5c2205c30f0fb157ce271fd42fb ]

Some a4tech mice use the 'GenericDesktop.00b8' usage to inform whether
the previous wheel report was horizontal or vertical. Before
c01908a14bf73 ("HID: input: add mapping for "Toggle Display" key") this
usage was being mapped to 'Relative.Misc'. After the patch it's simply
ignored (usage->type == 0 & usage->code == 0). Which ultimately makes
hid-a4tech ignore the WHEEL/HWHEEL selection event, as it has no
usage->type.

We shouldn't rely on a mapping for that usage as it's nonstandard and
doesn't really map to an input event. So we bypass the mapping and make
sure the custom event handling properly handles both reports.

Fixes: c01908a14bf73 ("HID: input: add mapping for "Toggle Display" key")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-a4tech.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 9428ea7cdf8a0..c52bd163abb3e 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -26,12 +26,36 @@
 #define A4_2WHEEL_MOUSE_HACK_7	0x01
 #define A4_2WHEEL_MOUSE_HACK_B8	0x02
 
+#define A4_WHEEL_ORIENTATION	(HID_UP_GENDESK | 0x000000b8)
+
 struct a4tech_sc {
 	unsigned long quirks;
 	unsigned int hw_wheel;
 	__s32 delayed_value;
 };
 
+static int a4_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+			    struct hid_field *field, struct hid_usage *usage,
+			    unsigned long **bit, int *max)
+{
+	struct a4tech_sc *a4 = hid_get_drvdata(hdev);
+
+	if (a4->quirks & A4_2WHEEL_MOUSE_HACK_B8 &&
+	    usage->hid == A4_WHEEL_ORIENTATION) {
+		/*
+		 * We do not want to have this usage mapped to anything as it's
+		 * nonstandard and doesn't really behave like an HID report.
+		 * It's only selecting the orientation (vertical/horizontal) of
+		 * the previous mouse wheel report. The input_events will be
+		 * generated once both reports are recorded in a4_event().
+		 */
+		return -1;
+	}
+
+	return 0;
+
+}
+
 static int a4_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -53,8 +77,7 @@ static int a4_event(struct hid_device *hdev, struct hid_field *field,
 	struct a4tech_sc *a4 = hid_get_drvdata(hdev);
 	struct input_dev *input;
 
-	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
-			!usage->type)
+	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput)
 		return 0;
 
 	input = field->hidinput->input;
@@ -65,7 +88,7 @@ static int a4_event(struct hid_device *hdev, struct hid_field *field,
 			return 1;
 		}
 
-		if (usage->hid == 0x000100b8) {
+		if (usage->hid == A4_WHEEL_ORIENTATION) {
 			input_event(input, EV_REL, value ? REL_HWHEEL :
 					REL_WHEEL, a4->delayed_value);
 			return 1;
@@ -129,6 +152,7 @@ MODULE_DEVICE_TABLE(hid, a4_devices);
 static struct hid_driver a4_driver = {
 	.name = "a4tech",
 	.id_table = a4_devices,
+	.input_mapping = a4_input_mapping,
 	.input_mapped = a4_input_mapped,
 	.event = a4_event,
 	.probe = a4_probe,
-- 
2.20.1



