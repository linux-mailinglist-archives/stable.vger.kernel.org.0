Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64393656F72
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiL0Uoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiL0Unq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:43:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCE510547;
        Tue, 27 Dec 2022 12:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D756B61242;
        Tue, 27 Dec 2022 20:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F01BC433F0;
        Tue, 27 Dec 2022 20:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173353;
        bh=yc6MwUUfISVnWBSSWrTX3TsHe81BkuYouhbaE4q+Eco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xi0/13uAQEIR8wjVAtMk/KLkbrtMWcwY0mx4YuGu5NK8RPwpG5GaGOiHnIleq0s/3
         IsdjCM7/yuI7v4bk1ipXO5SnRH+gwKOOkeMRPzGivS2uXL4NyP+RSc/vvATyryl2eG
         m1fB8poG3nwIRjd/WMSUaLXTQSvEJcK1yGXGTbV92KCarjjXfPgUrjv8vAg6lKOkCc
         c7TCnKVJxDAHvSyxvEq493K+KqAgdlX4//XXWX9sp6mVIB30vW5xwRrNRH+wrLCjvc
         kZrNKUqTcJMu9/1cg9iwtkyOZK4rVj0WGV02Qso8GNcwIGquNb+AMSWzIMeHF5daC9
         hdwl7Pg17zVjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Terry Junge <linuxhid@cosmicgizmosystems.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 7/7] HID: plantronics: Additional PIDs for double volume key presses quirk
Date:   Tue, 27 Dec 2022 15:35:32 -0500
Message-Id: <20221227203534.1214640-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203534.1214640-1-sashal@kernel.org>
References: <20221227203534.1214640-1-sashal@kernel.org>
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
index 0d4479f478aa..7320cca1a3e5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -938,7 +938,10 @@
 #define USB_DEVICE_ID_ORTEK_IHOME_IMAC_A210S	0x8003
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES	0xc055
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
diff --git a/drivers/hid/hid-plantronics.c b/drivers/hid/hid-plantronics.c
index e81b7cec2d12..3d414ae194ac 100644
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -198,9 +198,18 @@ static int plantronics_probe(struct hid_device *hdev,
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

