Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050444F3708
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiDELJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348816AbiDEJsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C04BAD13A;
        Tue,  5 Apr 2022 02:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C87ACB81C6F;
        Tue,  5 Apr 2022 09:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D16C385A3;
        Tue,  5 Apr 2022 09:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151371;
        bh=uh6t0IM5JSArKmFLvESsXuzZXPxoy6hHcZn+C8QRKXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJIRBTjKqolzi648kiExuNtqtfyTLbov8Y/QCV3uaVvkXpQ1LdHLUKzjlX4wm3bnc
         I0IMnVRn08smICWamq5P0j2Kh3PMy+F8ar950P/rwPkly+h28qER69wMnHhxxSAhhb
         NExqL0kTRxaFJhtWbdTyyNd/lLXwyy0fTFVF/mfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/913] Bluetooth: btintel: Fix WBS setting for Intel legacy ROM products
Date:   Tue,  5 Apr 2022 09:24:13 +0200
Message-Id: <20220405070351.567794770@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit 55235304c2560d4a94ccfff2a47ea927b4114064 ]

This patch adds the flag to identify the Intel legacy ROM products that
don't support WBS like WP and StP.

Fixes: 3df4dfbec0f29 ("Bluetooth: btintel: Move hci quirks to setup routine")
Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 11 ++++++++---
 drivers/bluetooth/btintel.h |  1 +
 drivers/bluetooth/btusb.c   |  6 ++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index e73d4c719b0a..d122cc973917 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2263,10 +2263,15 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 
 			/* Apply the device specific HCI quirks
 			 *
-			 * WBS for SdP - SdP and Stp have a same hw_varaint but
-			 * different fw_variant
+			 * WBS for SdP - For the Legacy ROM products, only SdP
+			 * supports the WBS. But the version information is not
+			 * enough to use here because the StP2 and SdP have same
+			 * hw_variant and fw_variant. So, this flag is set by
+			 * the transport driver (btusb) based on the HW info
+			 * (idProduct)
 			 */
-			if (ver.hw_variant == 0x08 && ver.fw_variant == 0x22)
+			if (!btintel_test_flag(hdev,
+					       INTEL_ROM_LEGACY_NO_WBS_SUPPORT))
 				set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 					&hdev->quirks);
 
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index 704e3b7bcb77..2b85ebf63321 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -147,6 +147,7 @@ enum {
 	INTEL_BROKEN_INITIAL_NCMD,
 	INTEL_BROKEN_SHUTDOWN_LED,
 	INTEL_ROM_LEGACY,
+	INTEL_ROM_LEGACY_NO_WBS_SUPPORT,
 
 	__INTEL_NUM_FLAGS,
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0d5539066c0f..a68edbc7be0f 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -61,6 +61,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_QCA_WCN6855	0x1000000
 #define BTUSB_INTEL_BROKEN_SHUTDOWN_LED	0x2000000
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD 0x4000000
+#define BTUSB_INTEL_NO_WBS_SUPPORT	0x8000000
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
@@ -384,9 +385,11 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x8087, 0x0033), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x07da), .driver_info = BTUSB_CSR },
 	{ USB_DEVICE(0x8087, 0x07dc), .driver_info = BTUSB_INTEL_COMBINED |
+						     BTUSB_INTEL_NO_WBS_SUPPORT |
 						     BTUSB_INTEL_BROKEN_INITIAL_NCMD |
 						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
 	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL_COMBINED |
+						     BTUSB_INTEL_NO_WBS_SUPPORT |
 						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
 	{ USB_DEVICE(0x8087, 0x0a2b), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL_COMBINED |
@@ -3863,6 +3866,9 @@ static int btusb_probe(struct usb_interface *intf,
 		hdev->send = btusb_send_frame_intel;
 		hdev->cmd_timeout = btusb_intel_cmd_timeout;
 
+		if (id->driver_info & BTUSB_INTEL_NO_WBS_SUPPORT)
+			btintel_set_flag(hdev, INTEL_ROM_LEGACY_NO_WBS_SUPPORT);
+
 		if (id->driver_info & BTUSB_INTEL_BROKEN_INITIAL_NCMD)
 			btintel_set_flag(hdev, INTEL_BROKEN_INITIAL_NCMD);
 
-- 
2.34.1



