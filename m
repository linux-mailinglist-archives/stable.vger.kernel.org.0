Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB3D2E1520
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgLWCWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbgLWCWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4865822202;
        Wed, 23 Dec 2020 02:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690096;
        bh=9g7bzIQtYxXcj+/s7VjZyXPXlYUNaBYUi/WCaRjP1fI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvJFckhKIElXYAs+ETYbKOv1oVM1W/jwa4CUNxbG7/AWAkYw+WUS4hu8xRr0IU7m/
         4Fm49gj8w1JtN+wY3PRHPDK30sLpoMUJlb/eMBo3OlCuFnwgNKbeIaXwUdteNKkyQm
         igYvTgI3jQWsXeQG5cqJTJMrngWNjlppgyHeDeo8MAldJNAkDTuHaYPbx6dBIuOhVA
         lkJI4mpat8xBCZmQeNc+GTUaOSIgLBcYvoBapEAoYawRzXqM8H5oc+/2GEP1z+K+ZD
         +6lpqnAebx5SFAn4e5IPrwgMGx/9j2jOH+IgdyzVXDQNlCsgk0iyhsKsDaDk8Qke32
         OzMsMFjTfPu6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/87] media: zr364xx: propagate errors from zr364xx_start_readpipe()
Date:   Tue, 22 Dec 2020 21:20:02 -0500
Message-Id: <20201223022103.2792705-26-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 501030bb2e7d0..ff2d07fa1c6a6 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1349,6 +1349,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 {
 	struct zr364xx_pipeinfo *pipe = cam->pipe;
 	unsigned long i;
+	int err;
 
 	DBG("board init: %p\n", cam);
 	memset(pipe, 0, sizeof(*pipe));
@@ -1381,9 +1382,8 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 
 	if (i == 0) {
 		printk(KERN_INFO KBUILD_MODNAME ": out of memory. Aborting\n");
-		kfree(cam->pipe->transfer_buffer);
-		cam->pipe->transfer_buffer = NULL;
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_free;
 	} else
 		cam->buffer.dwFrames = i;
 
@@ -1398,9 +1398,17 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
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
@@ -1597,10 +1605,19 @@ static int zr364xx_resume(struct usb_interface *intf)
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

