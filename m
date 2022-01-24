Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3669F498E98
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245098AbiAXTnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355415AbiAXTlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:41:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058CAC06175D;
        Mon, 24 Jan 2022 11:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0F8DB81235;
        Mon, 24 Jan 2022 19:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F5BC340E5;
        Mon, 24 Jan 2022 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052071;
        bh=FSpJDSpfVsJcYGFNZhFJVzsi85MzAyRlNh/wIUlnzeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVDZ0x9qd64mlpFei8mEBKAsp3bRptpxli9o49sTh9AjWEKqJtsv4YUdGBNgzTgtY
         4dYM0NVBZgcoyXRzxeOEQyle//UKKdlUMIjxX1c4+yxEzrUMCKXkGL3Ine2Ks8uDd8
         EdC+pERj/4JHDX/NB9Q0XLrbeIvYK+gfp+b7f5YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/239] HID: quirks: Allow inverting the absolute X/Y values
Date:   Mon, 24 Jan 2022 19:43:05 +0100
Message-Id: <20220124183947.769204985@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
index d56ef395eb693..dd3f4aa052980 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1246,6 +1246,12 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 
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
index da824ba9fb9a2..c51ebce2197e0 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -353,6 +353,8 @@ struct hid_item {
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



