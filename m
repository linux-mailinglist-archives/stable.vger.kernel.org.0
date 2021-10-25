Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE7D439564
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 13:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhJYL6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 07:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhJYL6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 07:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A54486103B;
        Mon, 25 Oct 2021 11:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635162989;
        bh=vqpRZoi93e7o70oGoNc6I9LrPapSYh6Mmot6+2/0THc=;
        h=From:To:Cc:Subject:Date:From;
        b=JE6ytb9hku1WGVzQLZQ+a8v2oABanPqDM2XsvBdSHdBxyRNno/bKRcXlnUlaaORxh
         gGdomLwcD5GVIBS68EYYyYeXEj0ctiU5bM5xxR/mm7gsQN+o3VOlOWTYCs6w73+Ky4
         /r1nL/v+kVVpP/Da6fvKB8bQPIfFCfFWZ+tNxMBgYnRwHjo+6yJ4jwxK8pJqRWxHWK
         WR8aVyrOrxWbzjAOAOBZtJ4mgAHr9qfGPBcKKnUOXKMvJgMIYEYJgdUbOEFxlx5Uwg
         9WGF2KO972jM35buedMUBrE/tKgBaTLXcQ/d2CcTQkxY5xn73sbuFOZk+FjGmbkZMm
         a5rrHyRRf7Zcg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyaK-0001O3-D3; Mon, 25 Oct 2021 13:56:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] mmc: vub300: fix control-message timeouts
Date:   Mon, 25 Oct 2021 13:56:08 +0200
Message-Id: <20211025115608.5287-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/mmc/host/vub300.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 4950d10d3a19..97beece62fec 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -576,7 +576,7 @@ static void check_vub300_port_status(struct vub300_mmc_host *vub300)
 				GET_SYSTEM_PORT_STATUS,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->system_port_status,
-				sizeof(vub300->system_port_status), HZ);
+				sizeof(vub300->system_port_status), 1000);
 	if (sizeof(vub300->system_port_status) == retval)
 		new_system_port_status(vub300);
 }
@@ -1241,7 +1241,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 						SET_INTERRUPT_PSEUDOCODE,
 						USB_DIR_OUT | USB_TYPE_VENDOR |
 						USB_RECIP_DEVICE, 0x0000, 0x0000,
-						xfer_buffer, xfer_length, HZ);
+						xfer_buffer, xfer_length, 1000);
 			kfree(xfer_buffer);
 			if (retval < 0)
 				goto copy_error_message;
@@ -1284,7 +1284,7 @@ static void __download_offload_pseudocode(struct vub300_mmc_host *vub300,
 						SET_TRANSFER_PSEUDOCODE,
 						USB_DIR_OUT | USB_TYPE_VENDOR |
 						USB_RECIP_DEVICE, 0x0000, 0x0000,
-						xfer_buffer, xfer_length, HZ);
+						xfer_buffer, xfer_length, 1000);
 			kfree(xfer_buffer);
 			if (retval < 0)
 				goto copy_error_message;
@@ -1991,7 +1991,7 @@ static void __set_clock_speed(struct vub300_mmc_host *vub300, u8 buf[8],
 		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_CLOCK_SPEED,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-				0x00, 0x00, buf, buf_array_size, HZ);
+				0x00, 0x00, buf, buf_array_size, 1000);
 	if (retval != 8) {
 		dev_err(&vub300->udev->dev, "SET_CLOCK_SPEED"
 			" %dkHz failed with retval=%d\n", kHzClock, retval);
@@ -2013,14 +2013,14 @@ static void vub300_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
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
@@ -2275,14 +2275,14 @@ static int vub300_probe(struct usb_interface *interface,
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
@@ -2297,7 +2297,7 @@ static int vub300_probe(struct usb_interface *interface,
 				GET_SYSTEM_PORT_STATUS,
 				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				0x0000, 0x0000, &vub300->system_port_status,
-				sizeof(vub300->system_port_status), HZ);
+				sizeof(vub300->system_port_status), 1000);
 	if (retval < 0) {
 		goto error4;
 	} else if (sizeof(vub300->system_port_status) == retval) {
-- 
2.32.0

