Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3103C656F92
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiL0Ur6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiL0Ur0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:47:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6976610B63;
        Tue, 27 Dec 2022 12:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03140B81200;
        Tue, 27 Dec 2022 20:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB44CC433F0;
        Tue, 27 Dec 2022 20:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173397;
        bh=7GAhUVPk5YI7ewRGZ86uAAGhaY7+K7QbOHgacS5sfoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StZcyexodOX4htY5pObw5VH/s6BrU3jvtnGNS33AwnFGk7L2hYvxh/COk++Dzr/eK
         Wc24f67ui3nzvi41i49jLpSfRWuQ9QOOS6kv01a4HlBfsVlxxIfsjaNbX9T0mWze6E
         hGsUxfWB7bTGe7PfvzrcUpYTB9Am1uW25H9bZ9twB5is018CLRV86+UJlKSBFTOZ34
         RTw68FPxLigmGhSWhlaGaGf2Xqh07aBEHT6usiFS6KVJs09dqM/wI1Qa68gO2wcFeK
         Qy4b4KvKyu3Tp1fAiB9e4MGm0bMF+kQeZkWYCmI0qHBL1t/26GWO2kPpquTcYU/9po
         9R3G5d0nKyCDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Terry Junge <linuxhid@cosmicgizmosystems.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/3] HID: plantronics: Additional PIDs for double volume key presses quirk
Date:   Tue, 27 Dec 2022 15:36:25 -0500
Message-Id: <20221227203626.1214890-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203626.1214890-1-sashal@kernel.org>
References: <20221227203626.1214890-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Terry Junge <linuxhid@cosmicgizmosystems.com>

[ Upstream commit 3d57f36c89d8ba32b2c312f397a37fd1a2dc7cfc ]

I no longer work for Plantronics (aka Poly, aka HP) and do not have
access to the headsets in order to test. However, as noted by Maxim,
the other 32xx models that share the same base code set as the 3220
would need the same quirk. This patch adds the PIDs for the rest of
the Blackwire 32XX product family that require the quirk.

Plantronics Blackwire 3210 Series (047f:c055)
Plantronics Blackwire 3215 Series (047f:c057)
Plantronics Blackwire 3225 Series (047f:c058)

Quote from previous patch by Maxim Mikityanskiy
Plantronics Blackwire 3220 Series (047f:c056) sends HID reports twice
for each volume key press. This patch adds a quirk to hid-plantronics
for this product ID, which will ignore the second volume key press if
it happens within 5 ms from the last one that was handled.

The patch was tested on the mentioned model only, it shouldn't affect
other models, however, this quirk might be needed for them too.
Auto-repeat (when a key is held pressed) is not affected, because the
rate is about 3 times per second, which is far less frequent than once
in 5 ms.
End quote

Signed-off-by: Terry Junge <linuxhid@cosmicgizmosystems.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h         | 3 +++
 drivers/hid/hid-plantronics.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1f641870d860..4d69551dbc52 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -816,7 +816,10 @@
 #define USB_DEVICE_ID_ORTEK_WKB2000	0x2000
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES	0xc055
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
diff --git a/drivers/hid/hid-plantronics.c b/drivers/hid/hid-plantronics.c
index 460711c1124a..3b75cadd543f 100644
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -201,9 +201,18 @@ static int plantronics_probe(struct hid_device *hdev,
 }
 
 static const struct hid_device_id plantronics_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
 					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES),
 		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS, HID_ANY_ID) },
 	{ }
 };
-- 
2.35.1

