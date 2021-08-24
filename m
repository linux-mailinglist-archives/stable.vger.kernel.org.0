Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C633F648D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbhHXRFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239019AbhHXRDQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240906138B;
        Tue, 24 Aug 2021 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824361;
        bh=wH79ToyYDe2xMQpedE9hyjF1u1EBTRwOuFyi+xhOqp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIhUUYliM/nZYeYxscntR8nJ5bPQvcHUNSc4A7+6owMTBNol0bHXpVRV6IWLbkAVg
         9Q9lSknDk88rpo0IqXvr1l1SUVeDhNz7WsQLcvSPoNdobmpZ8zaumGfK68BVm4fXBZ
         fB4M3yvFeYME0GdV7YAJJmWf4+IDXjY/Kn+sBBWNocLpuf0idwb7zsG4uQF9hl8M9K
         7DUQ5e3X/HqM2dmpnetFuaJ/gWsOk0FEO5Un1nxCegeYOCrw4jDPksNHdTJPUGIi0m
         RQT8yV9D8M1tSXCYFTJCD+4u1EBTaIqiuYZpQtCj3HtiJm3O2mL40f3++tBrek4YtQ
         EE623xU9/bxpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+efe9aefc31ae1e6f7675@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/98] media: drivers/media/usb: fix memory leak in zr364xx_probe
Date:   Tue, 24 Aug 2021 12:57:41 -0400
Message-Id: <20210824165908.709932-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 9c39be40c0155c43343f53e3a439290c0fec5542 ]

syzbot reported memory leak in zr364xx_probe()[1].
The problem was in invalid error handling order.
All error conditions rigth after v4l2_ctrl_handler_init()
must call v4l2_ctrl_handler_free().

Reported-by: syzbot+efe9aefc31ae1e6f7675@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/zr364xx/zr364xx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 8636acf2dad0..08b86b22e5e8 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1433,7 +1433,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (hdl->error) {
 		err = hdl->error;
 		dev_err(&udev->dev, "couldn't register control\n");
-		goto unregister;
+		goto free_hdlr_and_unreg_dev;
 	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
@@ -1506,7 +1506,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (!cam->read_endpoint) {
 		err = -ENOMEM;
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
-		goto unregister;
+		goto free_hdlr_and_unreg_dev;
 	}
 
 	/* v4l */
@@ -1518,7 +1518,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	/* load zr364xx board specific */
 	err = zr364xx_board_init(cam);
 	if (err)
-		goto unregister;
+		goto free_hdlr_and_unreg_dev;
 	err = v4l2_ctrl_handler_setup(hdl);
 	if (err)
 		goto board_uninit;
@@ -1536,7 +1536,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	err = video_register_device(&cam->vdev, VFL_TYPE_VIDEO, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
-		goto free_handler;
+		goto board_uninit;
 	}
 	cam->v4l2_dev.release = zr364xx_release;
 
@@ -1544,11 +1544,10 @@ static int zr364xx_probe(struct usb_interface *intf,
 		 video_device_node_name(&cam->vdev));
 	return 0;
 
-free_handler:
-	v4l2_ctrl_handler_free(hdl);
 board_uninit:
 	zr364xx_board_uninit(cam);
-unregister:
+free_hdlr_and_unreg_dev:
+	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&cam->v4l2_dev);
 free_cam:
 	kfree(cam);
-- 
2.30.2

