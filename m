Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A18F44161D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhKAJWj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhKAJV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71357610E5;
        Mon,  1 Nov 2021 09:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758359;
        bh=o9jBs3v16d2EnvhoyfSgE+PqqBJiZQ/gOXD3hrlgRmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7Zn85SAmFAaJYgR3kpF6hWLAYcIBAkNg+fF/HKNiAcPAQpLYnlR2+PkJrlmVHUrz
         wTGiJNTu67jxHImzB0anIC0Tjya6i0yOzQdfMIndUhZWdegHkkSv8JO0oU8DeoNnQB
         z+1LLAMxn4oO2UTXmE1p4U6AcsD5iZG8v45Lo1+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 11/20] mmc: vub300: fix control-message timeouts
Date:   Mon,  1 Nov 2021 10:17:20 +0100
Message-Id: <20211101082446.593691986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 8c8171929116cc23f74743d99251eedadf62341a upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025115608.5287-1-johan@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/vub300.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -579,7 +579,7 @@ static void check_vub300_port_status(str
 				GET_SYSTEM_PORT_STATUS,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->system_port_status,
-				sizeof(vub300->system_port_status), HZ);
+				sizeof(vub300->system_port_status), 1000);
 	if (sizeof(vub300->system_port_status) == retval)
 		new_system_port_status(vub300);
 }
@@ -1245,7 +1245,7 @@ static void __download_offload_pseudocod
 						SET_INTERRUPT_PSEUDOCODE,
 						USB_DIR_OUT | USB_TYPE_VENDOR |
 						USB_RECIP_DEVICE, 0x0000, 0x0000,
-						xfer_buffer, xfer_length, HZ);
+						xfer_buffer, xfer_length, 1000);
 			kfree(xfer_buffer);
 			if (retval < 0) {
 				strncpy(vub300->vub_name,
@@ -1292,7 +1292,7 @@ static void __download_offload_pseudocod
 						SET_TRANSFER_PSEUDOCODE,
 						USB_DIR_OUT | USB_TYPE_VENDOR |
 						USB_RECIP_DEVICE, 0x0000, 0x0000,
-						xfer_buffer, xfer_length, HZ);
+						xfer_buffer, xfer_length, 1000);
 			kfree(xfer_buffer);
 			if (retval < 0) {
 				strncpy(vub300->vub_name,
@@ -1998,7 +1998,7 @@ static void __set_clock_speed(struct vub
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_CLOCK_SPEED,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x00, 0x00, buf, buf_array_size, HZ);
+				0x00, 0x00, buf, buf_array_size, 1000);
 	if (retval != 8) {
 		dev_err(&vub300->udev->dev, "SET_CLOCK_SPEED"
 			" %dkHz failed with retval=%d\n", kHzClock, retval);
@@ -2020,14 +2020,14 @@ static void vub300_mmc_set_ios(struct mm
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_SD_POWER,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x0000, 0x0000, NULL, 0, HZ);
+				0x0000, 0x0000, NULL, 0, 1000);
 		/* must wait for the VUB300 u-proc to boot up */
 		msleep(600);
 	} else if ((ios->power_mode == MMC_POWER_UP) && !vub300->card_powered) {
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_SD_POWER,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x0001, 0x0000, NULL, 0, HZ);
+				0x0001, 0x0000, NULL, 0, 1000);
 		msleep(600);
 		vub300->card_powered = 1;
 	} else if (ios->power_mode == MMC_POWER_ON) {
@@ -2288,14 +2288,14 @@ static int vub300_probe(struct usb_inter
 				GET_HC_INF0,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->hc_info,
-				sizeof(vub300->hc_info), HZ);
+				sizeof(vub300->hc_info), 1000);
 	if (retval < 0)
 		goto error5;
 	retval =
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);
+				firmware_rom_wait_states, 0x0000, NULL, 0, 1000);
 	if (retval < 0)
 		goto error5;
 	dev_info(&vub300->udev->dev,
@@ -2310,7 +2310,7 @@ static int vub300_probe(struct usb_inter
 				GET_SYSTEM_PORT_STATUS,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->system_port_status,
-				sizeof(vub300->system_port_status), HZ);
+				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
 		goto error4;
 	} else if (sizeof(vub300->system_port_status) == retval) {


