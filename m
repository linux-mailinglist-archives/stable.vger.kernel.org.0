Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0835B2401A1
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 07:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgHJFDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 01:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgHJFDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 01:03:11 -0400
X-Greylist: delayed 577 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 09 Aug 2020 22:03:10 PDT
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3A2C061756
        for <stable@vger.kernel.org>; Sun,  9 Aug 2020 22:03:10 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 2FC833FA28;
        Mon, 10 Aug 2020 04:53:26 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     alsa-devel@alsa-project.org
Cc:     Takashi Iwai <tiwai@suse.de>, Hector Martin <marcan@marcan.st>,
        stable@vger.kernel.org
Subject: [PATCH v2] ALSA: usb-audio: fix overeager device match for MacroSilicon MS2109
Date:   Mon, 10 Aug 2020 13:53:19 +0900
Message-Id: <20200810045319.128745-1-marcan@marcan.st>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <d0567d6f-a5f6-9d3f-e5a9-cebdba7d1fa0@marcan.st>
References: <d0567d6f-a5f6-9d3f-e5a9-cebdba7d1fa0@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Matching by device matches all interfaces, which breaks the video/HID
portions of the device depending on module load order.

Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 sound/usb/quirks-table.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 9092cc0aa807..7cbb3d591a7f 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3645,7 +3645,13 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* Asrock TRX40 Creator */
  * with.
  */
 {
-	USB_DEVICE(0x534d, 0x2109),
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x534d,
+	.idProduct = 0x2109,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIOCONTROL,
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		.vendor_name = "MacroSilicon",
 		.product_name = "MS2109",
-- 
2.27.0

