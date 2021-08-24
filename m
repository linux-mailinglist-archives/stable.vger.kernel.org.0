Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35503F658D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbhHXROK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239598AbhHXRMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B546127B;
        Tue, 24 Aug 2021 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824477;
        bh=cwUrmVyOSUBhwTQWvfLxuyLUHzKvEJK2Gfu7ZqeYEhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHBN1LZ/bugZRGXwZpf1XSOhIAJs6LtGi344wCCgBzggDriwKB6CeNLiAoUqIXa+j
         BBW1CQhFjfMzyNjvGtcwOUxq0O0cJvgD9AARiCuxx4+celza9g3Rsu2swdCpCAiaTK
         Mqh2//BCLBQnInJxX6EjuTS3EAqwMmaFogVluIyhBJ0KE791YE7nkcJ4SEYixhm3B0
         Wv5ePN9bSPu+95ny9ByE1RTqiU/+nLEsQ3J4c9VzR1zS33CzYdKlnpre8SwtdnYts2
         Qi/RhAqx51dA6Ia+n75miPro20xUHz6HSWFJtHyzwjbzuiaYkKmUZtQQWdmNG6VgsN
         /PVviNFI/vDww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/61] media: zr364xx: propagate errors from zr364xx_start_readpipe()
Date:   Tue, 24 Aug 2021 13:00:14 -0400
Message-Id: <20210824170106.710221-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 02458c9cb5dc..22b34690a016 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1331,6 +1331,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 {
 	struct zr364xx_pipeinfo *pipe = cam->pipe;
 	unsigned long i;
+	int err;
 
 	DBG("board init: %p\n", cam);
 	memset(pipe, 0, sizeof(*pipe));
@@ -1363,9 +1364,8 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 
 	if (i == 0) {
 		printk(KERN_INFO KBUILD_MODNAME ": out of memory. Aborting\n");
-		kfree(cam->pipe->transfer_buffer);
-		cam->pipe->transfer_buffer = NULL;
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_free;
 	} else
 		cam->buffer.dwFrames = i;
 
@@ -1380,9 +1380,17 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
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
@@ -1579,10 +1587,19 @@ static int zr364xx_resume(struct usb_interface *intf)
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
2.30.2

