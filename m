Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BF66A389A
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjB0Cbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjB0Cb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5651F90B;
        Sun, 26 Feb 2023 18:29:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F13760DBA;
        Mon, 27 Feb 2023 02:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC27CC433EF;
        Mon, 27 Feb 2023 02:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463788;
        bh=5AsLII2Ke8tJUM7vBCns/QkCtkiZsIEW2BMPlQWBiI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/SElgwz2+f3079LSjcotf4Ai3hIwEBYPzCwihzhmc40/Azc1Oq0fD5NnDtj3/TL3
         wdA1/PEpPy8zH0BdnIewgEHN/m2jHqMuWEuB3VigVNfmtO0b5EUMuy7KD4hCTAlrOD
         vLci9yYH8KUMHen1AQ+XykE6kEJ/uyINCYafkdnRSZCKGi4CiikJDB61hJqfBncn+C
         l3lwoN8K+hqrQQw97oq7jveO1YYG/iJttOoPy74gal4neAqHHhhz7LqDY8wV4oRGkO
         JyE9SYrJoipXRn97FTFYvV6H2IwY28iVkgeUh5/3upx2Ayg7b6KGX6Ba16+FSpNVMk
         7ISeYrxtjV3bA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bastien Nocera <hadess@hadess.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 21/25] HID: logitech-hidpp: Don't restart communication if not necessary
Date:   Sun, 26 Feb 2023 21:08:44 -0500
Message-Id: <20230227020855.1051605-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
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
index 81de88ab2ecc7..601ab673727dc 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4049,6 +4049,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	bool connected;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	struct hidpp_ff_private_data data;
+	bool will_restart = false;
 
 	/* report_fixup needs drvdata to be set before we call hid_parse */
 	hidpp = devm_kzalloc(&hdev->dev, sizeof(*hidpp), GFP_KERNEL);
@@ -4104,6 +4105,10 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return ret;
 	}
 
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT ||
+	    hidpp->quirks & HIDPP_QUIRK_UNIFYING)
+		will_restart = true;
+
 	INIT_WORK(&hidpp->work, delayed_work_cb);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
@@ -4118,7 +4123,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * Plain USB connections need to actually call start and open
 	 * on the transport driver to allow incoming data.
 	 */
-	ret = hid_hw_start(hdev, 0);
+	ret = hid_hw_start(hdev, will_restart ? 0 : connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto hid_hw_start_fail;
@@ -4155,6 +4160,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			hidpp->wireless_feature_index = 0;
 		else if (ret)
 			goto hid_hw_init_fail;
+		ret = 0;
 	}
 
 	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
@@ -4169,19 +4175,21 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
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

