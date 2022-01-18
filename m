Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26C4491A17
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344677AbiARC6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347704AbiARCmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:42:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC05CC0613AF;
        Mon, 17 Jan 2022 18:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 943C1B81258;
        Tue, 18 Jan 2022 02:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B657EC36AEF;
        Tue, 18 Jan 2022 02:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473414;
        bh=0aMDBuj6ZlSu13MWg/s4a1z77NewLu9gY9a/TM7cMwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liGtp+wvqGPOL4t5yqHOplr4kNR9pk6WRPSBb8aKHmveXwWLYCfGEHxx4rjwDqF1A
         WI/0LUsv6dBQTd6LdE3of6Px01dctxxN8xL/hv2ruRM0Il8gBjlUYYk5XEaUh4x/iK
         Ne0bmgHkHy0jGEGxzFHAaeUMlp/1XT+HweXjfqhXqsjvDqZIHzTSIAQD3T3VOXULXG
         rVn6TY3zNK5K3R8bskGIH4dVqnUCP6yhx6/ZaBeX8/x6Vm7qsHXOUQPLkKS0iCVcKc
         zhjGP96FOw9E1ZcmroZrnhNFC3nuAV5hgWEnviyWHZXurGY2sd5pYA+X2UvSnbf3cd
         oAvF67V1grm2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 112/188] HID: quirks: Allow inverting the absolute X/Y values
Date:   Mon, 17 Jan 2022 21:30:36 -0500
Message-Id: <20220118023152.1948105-112-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 55017db98d896..69a0a290327a7 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1330,6 +1330,12 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 
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
index f453be385bd47..26742ca14609a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -349,6 +349,8 @@ struct hid_item {
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

