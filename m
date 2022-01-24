Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDE0498B6D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347881AbiAXTNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344994AbiAXTLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563BCC061378;
        Mon, 24 Jan 2022 11:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13AC3B81236;
        Mon, 24 Jan 2022 19:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEF2C340E5;
        Mon, 24 Jan 2022 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050997;
        bh=mzOXgJWu4huwItt9Jb9pt1M7G82FlnWck1CgOhpFlsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qtEoQNoSFaf9oLSWJ1BPMLli775ix9f50ryABUOrTKF5r5ccliVvYnfLm57a7t2dW
         W4vKPgFh2z/aaJyybNiWAbybRQXLLzoo447HuLpPKrcX8drPYNe+EbQGI7uzEt/jXU
         Rt8oUw+Q3Yf/dEOJj+HcktLzkGS0GBfTmmSMfUE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 021/186] media: flexcop-usb: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:41:36 +0100
Message-Id: <20220124183937.802649871@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit cd1798a387825cc4a51282f5a611ad05bb1ad75f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c |   10 +++++-----
 drivers/media/usb/b2c2/flexcop-usb.h |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -86,7 +86,7 @@ static int flexcop_usb_readwrite_dw(stru
 			0,
 			fc_usb->data,
 			sizeof(u32),
-			B2C2_WAIT_FOR_OPERATION_RDW * HZ);
+			B2C2_WAIT_FOR_OPERATION_RDW);
 
 	if (ret != sizeof(u32)) {
 		err("error while %s dword from %d (%d).", read ? "reading" :
@@ -154,7 +154,7 @@ static int flexcop_usb_v8_memory_req(str
 			wIndex,
 			fc_usb->data,
 			buflen,
-			nWaitTime * HZ);
+			nWaitTime);
 	if (ret != buflen)
 		ret = -EIO;
 
@@ -248,13 +248,13 @@ static int flexcop_usb_i2c_req(struct fl
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
@@ -281,7 +281,7 @@ static int flexcop_usb_i2c_req(struct fl
 			wIndex,
 			fc_usb->data,
 			buflen,
-			nWaitTime * HZ);
+			nWaitTime);
 
 	if (ret != buflen)
 		ret = -EIO;
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


