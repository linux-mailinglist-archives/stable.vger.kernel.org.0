Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F19450CA2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhKORlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237968AbhKORiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD948632DC;
        Mon, 15 Nov 2021 17:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997131;
        bh=DfmFMax0EKZNGYfv0ughNR7qspCQmQMZI0Wshws9coM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeeSlSoiXLYYp+76CtlXiDR0aYpd/1NPL/4NG6Jb+h0xm3zmpA/DppS1pF0e3LlbR
         s5dxrzaRZyXKZou+3wMSxYgKssXE00BFvSaLdqsn6Snxho7UJLaZ4d5EtAMoG0gkwd
         7xylTCfOIp86IsHqSxlGXj0EZbO/wKb8/mbHxwR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 035/575] ALSA: 6fire: fix control and bulk message timeouts
Date:   Mon, 15 Nov 2021 17:56:00 +0100
Message-Id: <20211115165344.848586464@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 9b371c6cc37f954360989eec41c2ddc5a6b83917 upstream.

USB control and bulk message timeouts are specified in milliseconds and
should specifically not vary with CONFIG_HZ.

Fixes: c6d43ba816d1 ("ALSA: usb/6fire - Driver for TerraTec DMX 6Fire USB")
Cc: stable@vger.kernel.org      # 2.6.39
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025121142.6531-2-johan@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/comm.c     |    2 +-
 sound/usb/6fire/firmware.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -95,7 +95,7 @@ static int usb6fire_comm_send_buffer(u8
 	int actual_len;
 
 	ret = usb_interrupt_msg(dev, usb_sndintpipe(dev, COMM_EP),
-			buffer, buffer[1] + 2, &actual_len, HZ);
+			buffer, buffer[1] + 2, &actual_len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (actual_len != buffer[1] + 2)
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -160,7 +160,7 @@ static int usb6fire_fw_ezusb_write(struc
 {
 	return usb_control_msg_send(device, 0, type,
 				    USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				    value, 0, data, len, HZ, GFP_KERNEL);
+				    value, 0, data, len, 1000, GFP_KERNEL);
 }
 
 static int usb6fire_fw_ezusb_read(struct usb_device *device,
@@ -168,7 +168,7 @@ static int usb6fire_fw_ezusb_read(struct
 {
 	return usb_control_msg_recv(device, 0, type,
 				    USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				    value, 0, data, len, HZ, GFP_KERNEL);
+				    value, 0, data, len, 1000, GFP_KERNEL);
 }
 
 static int usb6fire_fw_fpga_write(struct usb_device *device,
@@ -178,7 +178,7 @@ static int usb6fire_fw_fpga_write(struct
 	int ret;
 
 	ret = usb_bulk_msg(device, usb_sndbulkpipe(device, FPGA_EP), data, len,
-			&actual_len, HZ);
+			&actual_len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (actual_len != len)


