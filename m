Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1162D4395BA
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhJYMOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhJYMOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9612F60EBC;
        Mon, 25 Oct 2021 12:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163935;
        bh=AIRpCXor1U3q6Kur0f/NIMUI4ChvteaRnPofgExILTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaKp0d2wbZft43JNyI03st7htu3joHqUI07uYXGUBF+J93Ptg1A9m1HLQAFEOTkpq
         FXDl5A3uUwwX0ke103BDG/1EeMujLlz+2WkDTzMdkdNIHrTCw0ktngfI70QRXAXDyg
         5zmIkQD1PxrE6AOb1drDQDt8B0blqisHJb5duNUTrRKuf1gPs2qjaHoCci/nJfDVD7
         Xv6VlLIRAVc+eQP1aPJmxs8pi72I3pGiI6LcbMscT3lzHhOX9D2aTZ4qLKymEYTS7d
         v5lXRxb2OlDSyWPDSu/XmaB3e0+ppn6gjACmZQw7oo71nnCZ2zR19H6iNRnxMuC/hq
         feF2MpoxelV1w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meypa-0001iH-DA; Mon, 25 Oct 2021 14:11:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Takashi Iwai <tiwai@suse.com>
Cc:     Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] sound: 6fire: fix control and bulk message timeouts
Date:   Mon, 25 Oct 2021 14:11:41 +0200
Message-Id: <20211025121142.6531-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025121142.6531-1-johan@kernel.org>
References: <20211025121142.6531-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control and bulk message timeouts are specified in milliseconds and
should specifically not vary with CONFIG_HZ.

Fixes: c6d43ba816d1 ("ALSA: usb/6fire - Driver for TerraTec DMX 6Fire USB")
Cc: stable@vger.kernel.org      # 2.6.39
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 sound/usb/6fire/comm.c     | 2 +-
 sound/usb/6fire/firmware.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/usb/6fire/comm.c b/sound/usb/6fire/comm.c
index 43a2a62d66f7..49629d4bb327 100644
--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -95,7 +95,7 @@ static int usb6fire_comm_send_buffer(u8 *buffer, struct usb_device *dev)
 	int actual_len;
 
 	ret = usb_interrupt_msg(dev, usb_sndintpipe(dev, COMM_EP),
-			buffer, buffer[1] + 2, &actual_len, HZ);
+			buffer, buffer[1] + 2, &actual_len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (actual_len != buffer[1] + 2)
diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index 8981e61f2da4..c51abc54d2f8 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -160,7 +160,7 @@ static int usb6fire_fw_ezusb_write(struct usb_device *device,
 {
 	return usb_control_msg_send(device, 0, type,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				    value, 0, data, len, HZ, GFP_KERNEL);
+				    value, 0, data, len, 1000, GFP_KERNEL);
 }
 
 static int usb6fire_fw_ezusb_read(struct usb_device *device,
@@ -168,7 +168,7 @@ static int usb6fire_fw_ezusb_read(struct usb_device *device,
 {
 	return usb_control_msg_recv(device, 0, type,
 				    USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				    value, 0, data, len, HZ, GFP_KERNEL);
+				    value, 0, data, len, 1000, GFP_KERNEL);
 }
 
 static int usb6fire_fw_fpga_write(struct usb_device *device,
@@ -178,7 +178,7 @@ static int usb6fire_fw_fpga_write(struct usb_device *device,
 	int ret;
 
 	ret = usb_bulk_msg(device, usb_sndbulkpipe(device, FPGA_EP), data, len,
-			&actual_len, HZ);
+			&actual_len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (actual_len != len)
-- 
2.32.0

