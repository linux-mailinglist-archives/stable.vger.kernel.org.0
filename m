Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC9A49966F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359817AbiAXVD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354702AbiAXU5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314B0C05486B;
        Mon, 24 Jan 2022 12:00:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6C0A60B88;
        Mon, 24 Jan 2022 20:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A560BC340E5;
        Mon, 24 Jan 2022 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054453;
        bh=0+XfjOPAbLf9sTVRzvQ+1jNIKU4CH6CO3sXWF4+Cn78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ME5svfsQxlOfTrXJEnMUTsGGlsEjpl8wkVs9d36wzWpHX2UnC7l7dfINMPfcQo1i/
         YzxFQq1/7F3i7FNnuwPrQ2oNaACDgyVpgIBsz7kZt6oWGtKZ0LuNGv7fNwZjmkiNMH
         u+wDZTPuKX9voJM8OVeLG+Ly5S4m8+Qk9P+9xZLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/563] HID: quirks: Allow inverting the absolute X/Y values
Date:   Mon, 24 Jan 2022 19:42:07 +0100
Message-Id: <20220124184036.931107513@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Francis <alistair@alistair23.me>

[ Upstream commit fd8d135b2c5e88662f2729e034913f183455a667 ]

Add a HID_QUIRK_X_INVERT/HID_QUIRK_Y_INVERT quirk that can be used
to invert the X/Y values.

Signed-off-by: Alistair Francis <alistair@alistair23.me>
[bentiss: silence checkpatch warning]
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211208124045.61815-2-alistair@alistair23.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 6 ++++++
 include/linux/hid.h     | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 580d378342c41..eb53855898c8d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1288,6 +1288,12 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 
 	input = field->hidinput->input;
 
+	if (usage->type == EV_ABS &&
+	    (((*quirks & HID_QUIRK_X_INVERT) && usage->code == ABS_X) ||
+	     ((*quirks & HID_QUIRK_Y_INVERT) && usage->code == ABS_Y))) {
+		value = field->logical_maximum - value;
+	}
+
 	if (usage->hat_min < usage->hat_max || usage->hat_dir) {
 		int hat_dir = usage->hat_dir;
 		if (!hat_dir)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index fc56d53cc68bf..2ba33d708942c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -345,6 +345,8 @@ struct hid_item {
 /* BIT(9) reserved for backward compatibility, was NO_INIT_INPUT_REPORTS */
 #define HID_QUIRK_ALWAYS_POLL			BIT(10)
 #define HID_QUIRK_INPUT_PER_APP			BIT(11)
+#define HID_QUIRK_X_INVERT			BIT(12)
+#define HID_QUIRK_Y_INVERT			BIT(13)
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		BIT(16)
 #define HID_QUIRK_SKIP_OUTPUT_REPORT_ID		BIT(17)
 #define HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP	BIT(18)
-- 
2.34.1



