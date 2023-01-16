Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3138F66C89A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjAPQk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbjAPQkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:40:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D859F36B21
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:28:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BC2BB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6714C433D2;
        Mon, 16 Jan 2023 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886525;
        bh=FxyLmsygnkligAfOlbsQWR/lqkeYbHXqgx9Ya1t0pVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6z0IKr734EHaito/ICCL88ZhmUD/OZQClNEn75By+1imV8RvbBF6IlIL+nUsvDyS
         N0xMB8lHKNG5t0nVCsyQegJUKjhPt5mpVm8P2Os/RVQwIeD4xlgVaK3FEt5FOs/aGL
         JfYN8M2Th9/j48k1nXxX+LV9ZSuNJcMvWSoRpydU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Terry Junge <linuxhid@cosmicgizmosystems.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 464/658] HID: plantronics: Additional PIDs for double volume key presses quirk
Date:   Mon, 16 Jan 2023 16:49:12 +0100
Message-Id: <20230116154930.722497146@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6d550681869f..222f525c3d04 100644
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



