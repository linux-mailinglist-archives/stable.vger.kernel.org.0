Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F77497202
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiAWOUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiAWOUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:20:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06543C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B0E760C3A
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F2DC340E5;
        Sun, 23 Jan 2022 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947622;
        bh=wD0NXJA/ZJs+09v/B3qKLCIAbyuwiLXDkTgSG7SVb0o=;
        h=Subject:To:Cc:From:Date:From;
        b=fXjwtPK8fDgPhPPGnwCbsaznx43SYjtFvEUuSCjJB5lsRZENNR5Yd5gjj1mNLiyjj
         L0cdQznZV9hSdpkFTH0+cEjHY+Hq+cnkyYuA7wA3zM5g/6tngzYZagde4Wl/HdE1eE
         mgmJGIQMr0MLctUddaUPexOYwkrEcZnWylV8RM4s=
Subject: FAILED: patch "[PATCH] media: flexcop-usb: fix control-message timeouts" failed to apply to 4.4-stable tree
To:     johan@kernel.org, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:20:19 +0100
Message-ID: <1642947619243247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cd1798a387825cc4a51282f5a611ad05bb1ad75f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 25 Oct 2021 13:16:36 +0100
Subject: [PATCH] media: flexcop-usb: fix control-message timeouts

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Note that the driver was multiplying some of the timeout values with HZ
twice resulting in 3000-second timeouts with HZ=1000.

Also note that two of the timeout defines are currently unused.

Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 5d38171b7638..bfeb92d93de3 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -87,7 +87,7 @@ static int flexcop_usb_readwrite_dw(struct flexcop_device *fc, u16 wRegOffsPCI,
 			0,
 			fc_usb->data,
 			sizeof(u32),
-			B2C2_WAIT_FOR_OPERATION_RDW * HZ);
+			B2C2_WAIT_FOR_OPERATION_RDW);
 
 	if (ret != sizeof(u32)) {
 		err("error while %s dword from %d (%d).", read ? "reading" :
@@ -155,7 +155,7 @@ static int flexcop_usb_v8_memory_req(struct flexcop_usb *fc_usb,
 			wIndex,
 			fc_usb->data,
 			buflen,
-			nWaitTime * HZ);
+			nWaitTime);
 	if (ret != buflen)
 		ret = -EIO;
 
@@ -248,13 +248,13 @@ static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 		/* DKT 020208 - add this to support special case of DiSEqC */
 	case USB_FUNC_I2C_CHECKWRITE:
 		pipe = B2C2_USB_CTRL_PIPE_OUT;
-		nWaitTime = 2;
+		nWaitTime = 2000;
 		request_type |= USB_DIR_OUT;
 		break;
 	case USB_FUNC_I2C_READ:
 	case USB_FUNC_I2C_REPEATREAD:
 		pipe = B2C2_USB_CTRL_PIPE_IN;
-		nWaitTime = 2;
+		nWaitTime = 2000;
 		request_type |= USB_DIR_IN;
 		break;
 	default:
@@ -281,7 +281,7 @@ static int flexcop_usb_i2c_req(struct flexcop_i2c_adapter *i2c,
 			wIndex,
 			fc_usb->data,
 			buflen,
-			nWaitTime * HZ);
+			nWaitTime);
 
 	if (ret != buflen)
 		ret = -EIO;
diff --git a/drivers/media/usb/b2c2/flexcop-usb.h b/drivers/media/usb/b2c2/flexcop-usb.h
index 2f230bf72252..c7cca1a5ee59 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.h
+++ b/drivers/media/usb/b2c2/flexcop-usb.h
@@ -91,13 +91,13 @@ typedef enum {
 	UTILITY_SRAM_TESTVERIFY     = 0x16,
 } flexcop_usb_utility_function_t;
 
-#define B2C2_WAIT_FOR_OPERATION_RW (1*HZ)
-#define B2C2_WAIT_FOR_OPERATION_RDW (3*HZ)
-#define B2C2_WAIT_FOR_OPERATION_WDW (1*HZ)
+#define B2C2_WAIT_FOR_OPERATION_RW 1000
+#define B2C2_WAIT_FOR_OPERATION_RDW 3000
+#define B2C2_WAIT_FOR_OPERATION_WDW 1000
 
-#define B2C2_WAIT_FOR_OPERATION_V8READ (3*HZ)
-#define B2C2_WAIT_FOR_OPERATION_V8WRITE (3*HZ)
-#define B2C2_WAIT_FOR_OPERATION_V8FLASH (3*HZ)
+#define B2C2_WAIT_FOR_OPERATION_V8READ 3000
+#define B2C2_WAIT_FOR_OPERATION_V8WRITE 3000
+#define B2C2_WAIT_FOR_OPERATION_V8FLASH 3000
 
 typedef enum {
 	V8_MEMORY_PAGE_DVB_CI = 0x20,

