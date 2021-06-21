Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55483AEA3A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFUNmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229747AbhFUNmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 09:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3952860249;
        Mon, 21 Jun 2021 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624282822;
        bh=aE54vXBYYOVCHakiOGtog1mXWNcJcvFeTWSP6fhuM3U=;
        h=From:To:Cc:Subject:Date:From;
        b=T1HubzRdhe1LRsPGuzPq7InSfeB2JKVuRo1mq/860M4Z0oDGUbb0XXxhtQ9Hlq5Q8
         F7Tkku86s8s4c8kqQ+sKq7kpYO6xISdm/sVgTU5MVuRzp5VFeftxMyAlltIw9fBemg
         MnBU0+7u4RLDNLopGN5+P6E7CVIb+DeVKHONZ/oRKcUWzuRQRvqC4oFY51Z5v8yMHa
         KuFn/x4fSa4cd1JAv5t4efijeFJElKQFf7BXgYFOy+cDbBqD4hj/M/bbiSTUhXxtxx
         JkunG/w9PEorO6l4AaMPsye6SZ5fXMO70rZehqaf7BOw0vTCzCMLhh7BvhImjO65lq
         5RZPE6Zo4KomQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lvK9z-000XhC-WB; Mon, 21 Jun 2021 15:40:20 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] media: uvc: don't do DMA on stack
Date:   Mon, 21 Jun 2021 15:40:19 +0200
Message-Id: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
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

So, use a kmalloc'ed buffer.

Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 252136cc885c..a95bf7318848 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	u8 *buf;
 	int ret;
-	u8 i;
 
 	if (chain->selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
@@ -908,13 +908,20 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
 		return 0;
 	}
 
+	buf = kmalloc(1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
 	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
 			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
-			     &i, 1);
+			     buf, 1);
 	if (ret < 0)
 		return ret;
 
-	*input = i - 1;
+	*input = *buf - 1;
+
+	kfree(buf);
+
 	return 0;
 }
 
@@ -922,8 +929,8 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_video_chain *chain = handle->chain;
+	char *buf;
 	int ret;
-	u32 i;
 
 	ret = uvc_acquire_privileges(handle);
 	if (ret < 0)
@@ -939,10 +946,17 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
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
-- 
2.31.1

