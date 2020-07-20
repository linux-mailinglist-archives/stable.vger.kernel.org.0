Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A4F2270DD
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 23:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgGTVjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 17:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728502AbgGTVjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 17:39:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 645F820717;
        Mon, 20 Jul 2020 21:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595281175;
        bh=4JzCQhAGnw2TNVm7WPrALwR6pRDjtp1IIAQIm09Db9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czfauCnyqpae6O78SB6/bTcR394x0tYh0asEf9RV8BQwVLm2ENRwLZJmU8cShLKlG
         +FfdYmCwEGigBaEgxy5Kncin7fcEq7aDrWJ0LcAKlg3LdOc3IOyse+OX05teJsA/be
         jTh7mLJh8DjwSaNTziGxVQwhjIYH8pV5mHfj+k0Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Joao Moreno <mail@joaomoreno.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/9] HID: apple: Disable Fn-key key-re-mapping on clone keyboards
Date:   Mon, 20 Jul 2020 17:39:25 -0400
Message-Id: <20200720213932.408089-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720213932.408089-1-sashal@kernel.org>
References: <20200720213932.408089-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a5d81646fa294eed57786a9310b06ca48902adf8 ]

The Maxxter KB-BT-001 Bluetooth keyboard, which looks somewhat like the
Apple Wireless Keyboard, is using the vendor and product IDs (05AC:0239)
of the Apple Wireless Keyboard (2009 ANSI version) <sigh>.

But its F1 - F10 keys are marked as sending F1 - F10, not the special
functions hid-apple.c maps them too; and since its descriptors do not
contain the HID_UP_CUSTOM | 0x0003 usage apple-hid looks for for the
Fn-key, apple_setup_input() never gets called, so F1 - F6 are mapped
to key-codes which have not been set in the keybit array causing them
to not send any events at all.

The lack of a usage code matching the Fn key in the clone is actually
useful as this allows solving this problem in a generic way.

This commits adds a fn_found flag and it adds a input_configured
callback which checks if this flag is set once all usages have been
mapped. If it is not set, then assume this is a clone and clear the
quirks bitmap so that the hid-apple code does not add any special
handling to this keyboard.

This fixes F1 - F6 not sending anything at all and F7 - F12 sending
the wrong codes on the Maxxter KB-BT-001 Bluetooth keyboard and on
similar clones.

Cc: Joao Moreno <mail@joaomoreno.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 197eb75d10ef2..959a9e38b4f54 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -55,6 +55,7 @@ MODULE_PARM_DESC(swap_opt_cmd, "Swap the Option (\"Alt\") and Command (\"Flag\")
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
+	unsigned int fn_found;
 	DECLARE_BITMAP(pressed_numlock, KEY_CNT);
 };
 
@@ -340,12 +341,15 @@ static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	struct apple_sc *asc = hid_get_drvdata(hdev);
+
 	if (usage->hid == (HID_UP_CUSTOM | 0x0003) ||
 			usage->hid == (HID_UP_MSVENDOR | 0x0003) ||
 			usage->hid == (HID_UP_HPVENDOR2 | 0x0003)) {
 		/* The fn key on Apple USB keyboards */
 		set_bit(EV_REP, hi->input->evbit);
 		hid_map_usage_clear(hi, usage, bit, max, EV_KEY, KEY_FN);
+		asc->fn_found = true;
 		apple_setup_input(hi->input);
 		return 1;
 	}
@@ -372,6 +376,19 @@ static int apple_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 	return 0;
 }
 
+static int apple_input_configured(struct hid_device *hdev,
+		struct hid_input *hidinput)
+{
+	struct apple_sc *asc = hid_get_drvdata(hdev);
+
+	if ((asc->quirks & APPLE_HAS_FN) && !asc->fn_found) {
+		hid_info(hdev, "Fn key not found (Apple Wireless Keyboard clone?), disabling Fn key handling\n");
+		asc->quirks = 0;
+	}
+
+	return 0;
+}
+
 static int apple_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
@@ -593,6 +610,7 @@ static struct hid_driver apple_driver = {
 	.event = apple_event,
 	.input_mapping = apple_input_mapping,
 	.input_mapped = apple_input_mapped,
+	.input_configured = apple_input_configured,
 };
 module_hid_driver(apple_driver);
 
-- 
2.25.1

