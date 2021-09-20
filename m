Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A206411FDC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348388AbhITRqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:46:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353283AbhITRoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B914617E1;
        Mon, 20 Sep 2021 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157778;
        bh=V1jpyBADksnNFG7AcGXy7W11iY7j4YUBEoXq+iGRPY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACafkDWMe2KE2uGJn/8j7u+BCkbKR4LthJkPh0T6ji7avpZsCOYA3cPNKqKp7RwKL
         ygI1zm6winQOl7fSl7OxijngUa6gKnsd4+YZihMhoLDvZ+gb2/XKdk67Y28lwkKxMH
         HvfrhHFzXEdGQYzB7IrlWKino8UThICsnR5BfefA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 148/293] media: uvc: dont do DMA on stack
Date:   Mon, 20 Sep 2021 18:41:50 +0200
Message-Id: <20210920163938.342669056@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 1a10d7fdb6d0e235e9d230916244cc2769d3f170 upstream.

As warned by smatch:
	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)

those two functions call uvc_query_ctrl passing a pointer to
a data at the DMA stack. those are used to send URBs via
usb_control_msg(). Using DMA stack is not supported and should
not work anymore on modern Linux versions.

So, use a kmalloc'ed buffer.

Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -900,8 +900,8 @@ static int uvc_ioctl_g_input(struct file
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u8 i;
 
 	if (chain->selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -909,22 +909,27 @@ static int uvc_ioctl_g_input(struct file
 		return 0;
 	}
 
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
 			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
-			     &i, 1);
-	if (ret < 0)
-		return ret;
+			     buf, 1);
+	if (!ret)
+		*input = *buf - 1;
 
-	*input = i - 1;
-	return 0;
+	kfree(buf);
+
+	return ret;
 }
 
 static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u32 i;
 
 	ret = uvc_acquire_privileges(handle);
 	if (ret < 0)
@@ -940,10 +945,17 @@ static int uvc_ioctl_s_input(struct file
 	if (input >= chain->selector->bNrInPins)
 		return -EINVAL;
 
-	i = input + 1;
-	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
-			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
-			      &i, 1);
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	*buf = input + 1;
+	ret = uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
+			     chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
+			     buf, 1);
+	kfree(buf);
+
+	return ret;
 }
 
 static int uvc_ioctl_queryctrl(struct file *file, void *fh,


