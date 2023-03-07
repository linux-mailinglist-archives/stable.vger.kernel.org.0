Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2596AEF4A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjCGSWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjCGSWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:22:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE2EC173
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7703B6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F9BC433D2;
        Tue,  7 Mar 2023 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212973;
        bh=JkcloqCC/Tql+86QrvcEC6ePPKVOvxwt3OC7b3rY9f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ty63PmXT7GpqKyAJYA3f1NpIJJ4D+F0RZZgJi0noEND1xqNyJhFg0xRRyRLHM3jUg
         JFp8zSF0S4T+8oucMC3JasdCaMqyZZyTdx8LY/ISOSrWjgLDJgeDeM4lsM9VE3O2P3
         ImZeLi6P+LQWTUb9VoqaFfCXmadoUySj9/1UY0Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bastien Nocera <hadess@hadess.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 358/885] HID: logitech-hidpp: Hard-code HID++ 1.0 fast scroll support
Date:   Tue,  7 Mar 2023 17:54:52 +0100
Message-Id: <20230307170017.832667916@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 719acb4d3b7accc9cfbaf21c1c2d51dc7384aee2 ]

HID++ 1.0 devices only export whether Fast Scrolling is enabled, not
whether they are capable of it. Reinstate the original quirks for the 3
supported mice so fast scrolling works again on those devices.

Fixes: 908d325e1665 ("HID: logitech-hidpp: Detect hi-res scrolling support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216903
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20230116130937.391441-1-hadess@hadess.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 07b8506eecc41..19fce82d03f02 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -77,6 +77,7 @@ MODULE_PARM_DESC(disable_tap_to_click,
 #define HIDPP_QUIRK_HIDPP_WHEELS		BIT(26)
 #define HIDPP_QUIRK_HIDPP_EXTRA_MOUSE_BTNS	BIT(27)
 #define HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS	BIT(28)
+#define HIDPP_QUIRK_HI_RES_SCROLL_1P0		BIT(29)
 
 /* These are just aliases for now */
 #define HIDPP_QUIRK_KBD_SCROLL_WHEEL HIDPP_QUIRK_HIDPP_WHEELS
@@ -3472,14 +3473,8 @@ static int hidpp_initialize_hires_scroll(struct hidpp_device *hidpp)
 			hid_dbg(hidpp->hid_dev, "Detected HID++ 2.0 hi-res scrolling\n");
 		}
 	} else {
-		struct hidpp_report response;
-
-		ret = hidpp_send_rap_command_sync(hidpp,
-						  REPORT_ID_HIDPP_SHORT,
-						  HIDPP_GET_REGISTER,
-						  HIDPP_ENABLE_FAST_SCROLL,
-						  NULL, 0, &response);
-		if (!ret) {
+		/* We cannot detect fast scrolling support on HID++ 1.0 devices */
+		if (hidpp->quirks & HIDPP_QUIRK_HI_RES_SCROLL_1P0) {
 			hidpp->capabilities |= HIDPP_CAPABILITY_HIDPP10_FAST_SCROLL;
 			hid_dbg(hidpp->hid_dev, "Detected HID++ 1.0 fast scroll\n");
 		}
@@ -4297,9 +4292,15 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_T651),
 	  .driver_data = HIDPP_QUIRK_CLASS_WTP },
+	{ /* Mouse Logitech Anywhere MX */
+	  LDJ_DEVICE(0x1017), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
 	{ /* Mouse logitech M560 */
 	  LDJ_DEVICE(0x402d),
 	  .driver_data = HIDPP_QUIRK_DELAYED_INIT | HIDPP_QUIRK_CLASS_M560 },
+	{ /* Mouse Logitech M705 (firmware RQM17) */
+	  LDJ_DEVICE(0x101b), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
+	{ /* Mouse Logitech Performance MX */
+	  LDJ_DEVICE(0x101a), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
 	{ /* Keyboard logitech K400 */
 	  LDJ_DEVICE(0x4024),
 	  .driver_data = HIDPP_QUIRK_CLASS_K400 },
-- 
2.39.2



