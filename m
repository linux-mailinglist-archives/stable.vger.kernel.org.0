Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7D94F3477
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiDEJ3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245040AbiDEIxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5C4D9F;
        Tue,  5 Apr 2022 01:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66F77B81BAE;
        Tue,  5 Apr 2022 08:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DAC385A1;
        Tue,  5 Apr 2022 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148609;
        bh=sBesF4N2kU9g6gfW9XhFZBEZ95Zswxn1sGEjaW/rxn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4P5kdUkGWUhrDK8RJrV9tzg8L3BW3zyf95A2W/8DyuK9Zz6viGm54RsW7DUMkkQq
         2IOXnv+Qcx0JO5TBXUiIIFyeuSno5gWMXaorB10+zZoyk1D9F8gQjfX+JhwasNUyrJ
         Q+IIzQgGKuaBrePU8W2R9uGM+grS5W990XpmgTC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0416/1017] Bluetooth: btintel: Fix WBS setting for Intel legacy ROM products
Date:   Tue,  5 Apr 2022 09:22:09 +0200
Message-Id: <20220405070406.637289959@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 851a0c9b8fae..a224e5337ef8 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2426,10 +2426,15 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 
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
index c9b24e9299e2..e0060e58573c 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -152,6 +152,7 @@ enum {
 	INTEL_BROKEN_INITIAL_NCMD,
 	INTEL_BROKEN_SHUTDOWN_LED,
 	INTEL_ROM_LEGACY,
+	INTEL_ROM_LEGACY_NO_WBS_SUPPORT,
 
 	__INTEL_NUM_FLAGS,
 };
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c1f1237ddc76..8bb67c56eb7d 100644
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
@@ -3902,6 +3905,9 @@ static int btusb_probe(struct usb_interface *intf,
 		hdev->send = btusb_send_frame_intel;
 		hdev->cmd_timeout = btusb_intel_cmd_timeout;
 
+		if (id->driver_info & BTUSB_INTEL_NO_WBS_SUPPORT)
+			btintel_set_flag(hdev, INTEL_ROM_LEGACY_NO_WBS_SUPPORT);
+
 		if (id->driver_info & BTUSB_INTEL_BROKEN_INITIAL_NCMD)
 			btintel_set_flag(hdev, INTEL_BROKEN_INITIAL_NCMD);
 
-- 
2.34.1



