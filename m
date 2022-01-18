Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68E491A2A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345457AbiARC6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54926 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348734AbiARCp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:45:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 146E4B81136;
        Tue, 18 Jan 2022 02:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED6CC36AEF;
        Tue, 18 Jan 2022 02:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473954;
        bh=pgsZHp9ixRySTOMnwePYjcM7jO08VdKO54ioWL4fvKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4hhEVbGmvpa66gwiBDq5neg2CSHV+PE536uUcxYPfZXx3DW+BJSfinvquxADyN9D
         84fUKFLGPSfcZKgZdKocKwt1Eigu844lXwWAMaczr0m+8sNzs8yDtL5ZVgYXUnnxAw
         jSnl9jITrxn+RDWiYiVkvg+2f1SWElVkWPszIWQJr8WT8dlzxWyVauZNFGZkeNIx0E
         RBY7o2xUmvTHjplxnBPDsQQRhjduo2QcGVzpiz7Jdhu3Hyz+EVVxTE0dKF3Ujbw/7q
         3qFmtazJ8lb9W4CVBFZRNJ6Xviwq4fsIeXnvYc948myiNHvCEUyBPWFa1uEB95dRi7
         WMWnKaR0yBU+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 39/73] HID: quirks: Allow inverting the absolute X/Y values
Date:   Mon, 17 Jan 2022 21:43:58 -0500
Message-Id: <20220118024432.1952028-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index ea4c97f5b0736..749558aa27e78 100644
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
index ad46ed41e8836..d5f9bbf8afa51 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -344,6 +344,8 @@ struct hid_item {
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

