Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2296245BABF
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbhKXMOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243052AbhKXMNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:13:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD9BC6112E;
        Wed, 24 Nov 2021 12:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755658;
        bh=eMdFGeA6beNnLhX4dWjIaybXEdJWId6+fXHCILQan14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHtiiQkUWBmfLhgGqfJLczj8xW3aNyHmC+meeOzNYfXd+pCqIUvdMahZFIdJUbLDv
         kto/huaycplfuLu0Pik3NRODY+/8voyVfvGAdVccWGZcPBX6aWSHPHNr3n6H1ZdIyX
         CTiDUD3J7crgp/gIa65uyTTMpcqa1svjDdMUDEZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 012/207] ALSA: 6fire: fix control and bulk message timeouts
Date:   Wed, 24 Nov 2021 12:54:43 +0100
Message-Id: <20211124115704.350114324@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -99,7 +99,7 @@ static int usb6fire_comm_send_buffer(u8
 	int actual_len;
 
 	ret = usb_interrupt_msg(dev, usb_sndintpipe(dev, COMM_EP),
-			buffer, buffer[1] + 2, &actual_len, HZ);
+			buffer, buffer[1] + 2, &actual_len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (actual_len != buffer[1] + 2)
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -166,7 +166,7 @@ static int usb6fire_fw_ezusb_write(struc
 
 	ret = usb_control_msg(device, usb_sndctrlpipe(device, 0), type,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, 0, data, len, HZ);
+			value, 0, data, len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (ret != len)
@@ -179,7 +179,7 @@ static int usb6fire_fw_ezusb_read(struct
 {
 	int ret = usb_control_msg(device, usb_rcvctrlpipe(device, 0), type,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE, value,
-			0, data, len, HZ);
+			0, data, len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (ret != len)
@@ -194,7 +194,7 @@ static int usb6fire_fw_fpga_write(struct
 	int ret;
 
 	ret = usb_bulk_msg(device, usb_sndbulkpipe(device, FPGA_EP), data, len,
-			&actual_len, HZ);
+			&actual_len, 1000);
 	if (ret < 0)
 		return ret;
 	else if (actual_len != len)


