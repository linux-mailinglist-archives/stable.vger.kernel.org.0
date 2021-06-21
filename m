Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD13AE9EF
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhFUNZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhFUNZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 09:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23777611BD;
        Mon, 21 Jun 2021 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624281819;
        bh=WfMt+2CnAOmcD9w6YclfhB+NcpEBJQj+GsdnDBwKwag=;
        h=From:To:Cc:Subject:Date:From;
        b=sA+aAXvspoGifjqV4cB9p6smfGXfpcOqcSwaLb8Kr76Hah1/cWGfrMPrT6NcSeMOw
         uDTY9yztibFcukLUmXeN4lA7Ab7txzhTTPWmEz0okY8QtoKWFYyKwr7Hp8H4L7hQy4
         Bkfvl7SJBtCiyjxHsjfBTtKjYJX6Vmf5G7Wi+y1J/+nt/mFxU+ydEsuJSEDXroD5dY
         e2sHI9C3p9Gei8s94ZKdJ22HiCX+HxGzHVATIa2t7GhlsizPXNLC18nq6IV1YhBVVI
         PjD/aswMgpyHRCoLuKwpLNbk+CHd5IOD9A8Msfs0RuM9W55dN8Y2iZk5zzs8jYWN3h
         rMw/Q2xHzpVAg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lvJto-000X9q-KM; Mon, 21 Jun 2021 15:23:36 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] media: uvc: don't do DMA on stack
Date:   Mon, 21 Jun 2021 15:23:35 +0200
Message-Id: <aaa1b65bf2b6c1a2da79b44fe7ada63f697ac32e.1624281807.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As warned by smatch:
	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)

those two functions call uvc_query_ctrl passing a pointer to
a data at the DMA stack. those are used to send URBs via
usb_control_msg(). Using DMA stack is not supported and should
not work anymore on modern Linux versions.

So, use a temporary buffer, allocated together with
struct uvc_video_chain.

Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 252136cc885c..d680ae8a5f87 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	char *buf;
 	int ret;
-	u8 i;
 
 	if (chain->selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -908,13 +908,18 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 		return 0;
 	}
 
+	buf = kmalloc(1, GFP_KERNEL);
+
 	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
 			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
-			     &i, 1);
+			     buf, 1);
 	if (ret < 0)
 		return ret;
 
-	*input = i - 1;
+	*input = *buf;
+
+	kfree(buf);
+
 	return 0;
 }
 
@@ -922,8 +927,8 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	char *buf;
 	int ret;
-	u32 i;
 
 	ret = uvc_acquire_privileges(handle);
 	if (ret < 0)
@@ -939,10 +944,15 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 	if (input >= chain->selector->bNrInPins)
 		return -EINVAL;
 
-	i = input + 1;
-	return uvc_query_ctrl(chain->dev, UVC_SET_CUR, chain->selector->id,
-			      chain->dev->intfnum, UVC_SU_INPUT_SELECT_CONTROL,
-			      &i, 1);
+	buf = kmalloc(1, GFP_KERNEL);
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
-- 
2.31.1

