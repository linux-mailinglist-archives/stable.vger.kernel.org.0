Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1D549939B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385950AbiAXUet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351395AbiAXU2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16260C0612A7;
        Mon, 24 Jan 2022 11:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C65CEB81142;
        Mon, 24 Jan 2022 19:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72E7C340E5;
        Mon, 24 Jan 2022 19:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053319;
        bh=4gyB6Qv06tdS2Y/R6K7VxixzmD3znTGhfuyIXYLQd0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgmzW+P/Pwj18vDVEa8X3XePSLK/cG3lEr8pYOXcy1bSq+sMgkkhGFplvw/hs9oPO
         Jb99+zhi8UJy0tD/sv5czwu2lCXKi3kc0nUkVMkHxopiHUbXMhLA3kG8ncVoYxNsjk
         VB4Yz/ZJcQgDSixHRIajpQhoTzCc4kYis0ygyqck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 026/563] media: redrat3: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:36:31 +0100
Message-Id: <20220124184025.329801638@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2adc965c8bfa224e11ecccf9c92fd458c4236428 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/redrat3.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -404,7 +404,7 @@ static int redrat3_send_cmd(int cmd, str
 	udev = rr3->udev;
 	res = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), cmd,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0x0000, 0x0000, data, sizeof(u8), HZ * 10);
+			      0x0000, 0x0000, data, sizeof(u8), 10000);
 
 	if (res < 0) {
 		dev_err(rr3->dev, "%s: Error sending rr3 cmd res %d, data %d",
@@ -480,7 +480,7 @@ static u32 redrat3_get_timeout(struct re
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_GET_IR_PARAM,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      RR3_IR_IO_SIG_TIMEOUT, 0, tmp, len, HZ * 5);
+			      RR3_IR_IO_SIG_TIMEOUT, 0, tmp, len, 5000);
 	if (ret != len)
 		dev_warn(rr3->dev, "Failed to read timeout from hardware\n");
 	else {
@@ -510,7 +510,7 @@ static int redrat3_set_timeout(struct rc
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
 		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
 		     RR3_IR_IO_SIG_TIMEOUT, 0, timeout, sizeof(*timeout),
-		     HZ * 25);
+		     25000);
 	dev_dbg(dev, "set ir parm timeout %d ret 0x%02x\n",
 						be32_to_cpu(*timeout), ret);
 
@@ -542,32 +542,32 @@ static void redrat3_reset(struct redrat3
 	*val = 0x01;
 	rc = usb_control_msg(udev, rxpipe, RR3_RESET,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			     RR3_CPUCS_REG_ADDR, 0, val, len, HZ * 25);
+			     RR3_CPUCS_REG_ADDR, 0, val, len, 25000);
 	dev_dbg(dev, "reset returned 0x%02x\n", rc);
 
 	*val = length_fuzz;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_LENGTH_FUZZ, 0, val, len, HZ * 25);
+			     RR3_IR_IO_LENGTH_FUZZ, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm len fuzz %d rc 0x%02x\n", *val, rc);
 
 	*val = (65536 - (minimum_pause * 2000)) / 256;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_MIN_PAUSE, 0, val, len, HZ * 25);
+			     RR3_IR_IO_MIN_PAUSE, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm min pause %d rc 0x%02x\n", *val, rc);
 
 	*val = periods_measure_carrier;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_PERIODS_MF, 0, val, len, HZ * 25);
+			     RR3_IR_IO_PERIODS_MF, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm periods measure carrier %d rc 0x%02x", *val,
 									rc);
 
 	*val = RR3_DRIVER_MAXLENS;
 	rc = usb_control_msg(udev, txpipe, RR3_SET_IR_PARAM,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
-			     RR3_IR_IO_MAX_LENGTHS, 0, val, len, HZ * 25);
+			     RR3_IR_IO_MAX_LENGTHS, 0, val, len, 25000);
 	dev_dbg(dev, "set ir parm max lens %d rc 0x%02x\n", *val, rc);
 
 	kfree(val);
@@ -585,7 +585,7 @@ static void redrat3_get_firmware_rev(str
 	rc = usb_control_msg(rr3->udev, usb_rcvctrlpipe(rr3->udev, 0),
 			     RR3_FW_VERSION,
 			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			     0, 0, buffer, RR3_FW_VERSION_LEN, HZ * 5);
+			     0, 0, buffer, RR3_FW_VERSION_LEN, 5000);
 
 	if (rc >= 0)
 		dev_info(rr3->dev, "Firmware rev: %s", buffer);
@@ -825,14 +825,14 @@ static int redrat3_transmit_ir(struct rc
 
 	pipe = usb_sndbulkpipe(rr3->udev, rr3->ep_out->bEndpointAddress);
 	ret = usb_bulk_msg(rr3->udev, pipe, irdata,
-			    sendbuf_len, &ret_len, 10 * HZ);
+			    sendbuf_len, &ret_len, 10000);
 	dev_dbg(dev, "sent %d bytes, (ret %d)\n", ret_len, ret);
 
 	/* now tell the hardware to transmit what we sent it */
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_TX_SEND_SIGNAL,
 			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0, 0, irdata, 2, HZ * 10);
+			      0, 0, irdata, 2, 10000);
 
 	if (ret < 0)
 		dev_err(dev, "Error: control msg send failed, rc %d\n", ret);


