Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034DB2E1453
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgLWCXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbgLWCXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7294422A99;
        Wed, 23 Dec 2020 02:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690199;
        bh=emF2QKwDnHejaOpSs86sRk+/kZdCHjtSJ6FcUUjQrvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mClP8FiCav8rBehJWBDdleawUB61TCyq7Z2QucaOe0L1tkWMZjUNEtPGJ8uucmloN
         LmcwBcIf8ddEIuj91b6t/kJ0VmcpGnP9P7XYYHB5BN+xSITU80qxP0TrqFMtyRvFoa
         kyN5FjwomSL2ap4RUu6AoSo9iwpICsNplSSGXHlvvA0VmNVw2HEljTnQVLjEERJaGY
         LW1+IQNvcqBb4mHxzQBWYNRRtdtyX5XDbsrNLhisHiDTl5pCsjosudLltcEdHikguB
         nBc5JWlfvs76juNw3ihei1eWXJ7ViOoPMoK6tn1KaIGDSVssWFBDAgSjiu5q7IAmcA
         rH//35sJO/cnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 21/66] media: zr364xx: propagate errors from zr364xx_start_readpipe()
Date:   Tue, 22 Dec 2020 21:22:07 -0500
Message-Id: <20201223022253.2793452-21-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index d30f129a9db75..fe87e2159dae1 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1352,6 +1352,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 {
 	struct zr364xx_pipeinfo *pipe = cam->pipe;
 	unsigned long i;
+	int err;
 
 	DBG("board init: %p\n", cam);
 	memset(pipe, 0, sizeof(*pipe));
@@ -1384,9 +1385,8 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 
 	if (i == 0) {
 		printk(KERN_INFO KBUILD_MODNAME ": out of memory. Aborting\n");
-		kfree(cam->pipe->transfer_buffer);
-		cam->pipe->transfer_buffer = NULL;
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_free;
 	} else
 		cam->buffer.dwFrames = i;
 
@@ -1401,9 +1401,17 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
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
@@ -1602,10 +1610,19 @@ static int zr364xx_resume(struct usb_interface *intf)
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

