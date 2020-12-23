Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69A82E1356
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgLWCZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbgLWCZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6AEF229C5;
        Wed, 23 Dec 2020 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690335;
        bh=qOD3J0qah8tfhOMeHNnIkftANTBwEaXCTYbcvwhJPZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bou3VYruHW3szheA9nFLvWs8vmBVo4TebgrJErBE6Pw0/+1URcjXzE+nOsL7BOWji
         MfTrqi3GPlECjwO8Wtjqdcb3czeI8s8+NY2RfUWLwrlQmeszf7z6KqTVIzdI7ADAU0
         DlM2ABiel9EGKJxafpVPQZYePFnxzsmQpxq+Ymaaf6eGcBQnyz24pQoIJZ9iRVdtj/
         2JMtudzsfuaUl/scMOCtkk89h4tdAKDlxAKUKo56TuhJH0AL0RTY8jLC9WVAIl1+th
         j/Z28x1wKFcSrz1xyQNUSDEFUHfJwM/k/nHciipMhdNpAOxZJbRGoTKI3XAA5w1lVQ
         K66Sh/1rbhWZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 15/38] media: zr364xx: propagate errors from zr364xx_start_readpipe()
Date:   Tue, 22 Dec 2020 21:24:53 -0500
Message-Id: <20201223022516.2794471-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit af0321a5be3e5647441eb6b79355beaa592df97a ]

zr364xx_start_readpipe() can fail but callers do not care about that.
This can result in various negative consequences. The patch adds missed
error handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/zr364xx/zr364xx.c | 31 ++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 2d56cccaa4747..505e08ddde2bb 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1359,6 +1359,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 {
 	struct zr364xx_pipeinfo *pipe = cam->pipe;
 	unsigned long i;
+	int err;
 
 	DBG("board init: %p\n", cam);
 	memset(pipe, 0, sizeof(*pipe));
@@ -1392,9 +1393,8 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 
 	if (i == 0) {
 		printk(KERN_INFO KBUILD_MODNAME ": out of memory. Aborting\n");
-		kfree(cam->pipe->transfer_buffer);
-		cam->pipe->transfer_buffer = NULL;
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_free;
 	} else
 		cam->buffer.dwFrames = i;
 
@@ -1409,9 +1409,17 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 	/*** end create system buffers ***/
 
 	/* start read pipe */
-	zr364xx_start_readpipe(cam);
+	err = zr364xx_start_readpipe(cam);
+	if (err)
+		goto err_free;
+
 	DBG(": board initialized\n");
 	return 0;
+
+err_free:
+	kfree(cam->pipe->transfer_buffer);
+	cam->pipe->transfer_buffer = NULL;
+	return err;
 }
 
 static int zr364xx_probe(struct usb_interface *intf,
@@ -1610,10 +1618,19 @@ static int zr364xx_resume(struct usb_interface *intf)
 	if (!cam->was_streaming)
 		return 0;
 
-	zr364xx_start_readpipe(cam);
+	res = zr364xx_start_readpipe(cam);
+	if (res)
+		return res;
+
 	res = zr364xx_prepare(cam);
-	if (!res)
-		zr364xx_start_acquire(cam);
+	if (res)
+		goto err_prepare;
+
+	zr364xx_start_acquire(cam);
+	return 0;
+
+err_prepare:
+	zr364xx_stop_readpipe(cam);
 	return res;
 }
 #endif
-- 
2.27.0

