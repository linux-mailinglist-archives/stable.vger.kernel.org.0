Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4704A6A38B5
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjB0Cfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjB0Cfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:35:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A8DEC64;
        Sun, 26 Feb 2023 18:34:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2114B80CB7;
        Mon, 27 Feb 2023 02:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D561CC4339E;
        Mon, 27 Feb 2023 02:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463679;
        bh=D+qWGq/XCNxJdISHB4pY46SxDQzb4YiyTmZPGVAIJ4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi8oQTmK5KCwWbIpti/PUbQqg04Ow1SUZK4qo191wkDa72sOKp/QrxGm/XrI6/81M
         8V2b3VyB6y2ujAW9ivfbrpysMCqaetTxow9bDk3IWcmF+WZV+OUKyV99Qh04diR/Yu
         UjhppP8OS5mMf9KAd1V4/cq10LaP3Ag9/7OXXH8s5AxYiYe7EfRp+ideZNYTL6FOHH
         TMCY4hnbq3W5A++nmHEC8lsuxkKLqjfqLlL45fIiuw0TEruS/ls0aHTsoKJ4mngHTr
         V74phhYXvwIZnsXplOGELufIPulsH6dKx1hGOglN92IfqGLMcvd56yHRdtYBXR8ZHc
         60nSsxim1+Rcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bastien Nocera <hadess@hadess.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 48/58] HID: logitech-hidpp: Don't restart communication if not necessary
Date:   Sun, 26 Feb 2023 21:04:46 -0500
Message-Id: <20230227020457.1048737-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
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

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 498ba20690357691103de0f766960355247c78be ]

Don't stop and restart communication with the device unless we need to
modify the connect flags used because of a device quirk.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20230125121723.3122-1-hadess@hadess.net
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 07b8506eecc41..74cf4d47013ab 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4107,6 +4107,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	bool connected;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	struct hidpp_ff_private_data data;
+	bool will_restart = false;
 
 	/* report_fixup needs drvdata to be set before we call hid_parse */
 	hidpp = devm_kzalloc(&hdev->dev, sizeof(*hidpp), GFP_KERNEL);
@@ -4162,6 +4163,10 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return ret;
 	}
 
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT ||
+	    hidpp->quirks & HIDPP_QUIRK_UNIFYING)
+		will_restart = true;
+
 	INIT_WORK(&hidpp->work, delayed_work_cb);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
@@ -4176,7 +4181,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * Plain USB connections need to actually call start and open
 	 * on the transport driver to allow incoming data.
 	 */
-	ret = hid_hw_start(hdev, 0);
+	ret = hid_hw_start(hdev, will_restart ? 0 : connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto hid_hw_start_fail;
@@ -4213,6 +4218,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			hidpp->wireless_feature_index = 0;
 		else if (ret)
 			goto hid_hw_init_fail;
+		ret = 0;
 	}
 
 	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
@@ -4227,19 +4233,21 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	hidpp_connect_event(hidpp);
 
-	/* Reset the HID node state */
-	hid_device_io_stop(hdev);
-	hid_hw_close(hdev);
-	hid_hw_stop(hdev);
+	if (will_restart) {
+		/* Reset the HID node state */
+		hid_device_io_stop(hdev);
+		hid_hw_close(hdev);
+		hid_hw_stop(hdev);
 
-	if (hidpp->quirks & HIDPP_QUIRK_NO_HIDINPUT)
-		connect_mask &= ~HID_CONNECT_HIDINPUT;
+		if (hidpp->quirks & HIDPP_QUIRK_NO_HIDINPUT)
+			connect_mask &= ~HID_CONNECT_HIDINPUT;
 
-	/* Now export the actual inputs and hidraw nodes to the world */
-	ret = hid_hw_start(hdev, connect_mask);
-	if (ret) {
-		hid_err(hdev, "%s:hid_hw_start returned error\n", __func__);
-		goto hid_hw_start_fail;
+		/* Now export the actual inputs and hidraw nodes to the world */
+		ret = hid_hw_start(hdev, connect_mask);
+		if (ret) {
+			hid_err(hdev, "%s:hid_hw_start returned error\n", __func__);
+			goto hid_hw_start_fail;
+		}
 	}
 
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
-- 
2.39.0

