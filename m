Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D995491859
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344653AbiARCqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346035AbiARCnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C9CB8123F;
        Tue, 18 Jan 2022 02:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7953C36AE3;
        Tue, 18 Jan 2022 02:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473778;
        bh=0+XfjOPAbLf9sTVRzvQ+1jNIKU4CH6CO3sXWF4+Cn78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1bTJXwQsOrQkGf2DHVVwTWXyDY7zmBF4bd6vckDVlEcQ4wqKOLwpPtMnQEhDaHcO
         F66RuCyRa+z1FtaD2PLNr24u3kke8EnPupMxAjf2akOW3cA9FGzuMis68hPnIDC9Zq
         6LfFESnRfToE1I/M+mke1pHJqtbwYeoR335ML9nUzHcgH5Qh3MLnJq2lQgOBRDQKHZ
         BaHdFes5FvgFAp0lqaC2vqYhZGLIY22K9fU54jaK6F1O8rJVdThj6EzhGvxaPn330t
         iqFV3fkkro73rbWHyHNHlVTMMw3E2OoRkLJQ51VjDp0y/Sereh88T6wslWKAmfB1kU
         McWeoTy/FYK2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 067/116] HID: quirks: Allow inverting the absolute X/Y values
Date:   Mon, 17 Jan 2022 21:39:18 -0500
Message-Id: <20220118024007.1950576-67-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

