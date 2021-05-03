Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A53371B18
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhECQnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhECQkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35FA2613BA;
        Mon,  3 May 2021 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059860;
        bh=AZe2vZ5ADJJaJ4xV8wf/15PTru8F8h0rROcmQxBeQO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E85J0BqqWcUHUfVOO20jVpmRJYuxWF9PsmZTC+X2JpGJTPAa18/G2KG4tsLamNpF7
         0xcXOBNNcfjWzPDK5e7e3rmYoHqGrIzJ8lDEfkWX7OK2XxsFfyXC2GH1Oz2sQFmAJS
         gkZx+1DQALv6W+kKNER+qncI1R+VkzAevu08FIIW+IQM5R15fkPg0TC+MZsM6rJw0+
         asxs+SmS+E21KBAFbRSeoAMzmM2uwIVX/rXAG5ncsakjvp38eKHdqmwk0mn7GxvXRW
         f7z++wUX6AvWEPPF7jVb5jiTrDZOsj24v3wRwt1mHshLNMAlCcdBYiQOf30FB+mT8w
         6FBYVDjEZKskA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+efe9aefc31ae1e6f7675@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 026/115] media: drivers/media/usb: fix memory leak in zr364xx_probe
Date:   Mon,  3 May 2021 12:35:30 -0400
Message-Id: <20210503163700.2852194-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
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
index d29b861367ea..1ef611e08323 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1430,7 +1430,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (hdl->error) {
 		err = hdl->error;
 		dev_err(&udev->dev, "couldn't register control\n");
-		goto unregister;
+		goto free_hdlr_and_unreg_dev;
 	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
@@ -1503,7 +1503,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	if (!cam->read_endpoint) {
 		err = -ENOMEM;
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
-		goto unregister;
+		goto free_hdlr_and_unreg_dev;
 	}
 
 	/* v4l */
@@ -1515,7 +1515,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	/* load zr364xx board specific */
 	err = zr364xx_board_init(cam);
 	if (err)
-		goto unregister;
+		goto free_hdlr_and_unreg_dev;
 	err = v4l2_ctrl_handler_setup(hdl);
 	if (err)
 		goto board_uninit;
@@ -1533,7 +1533,7 @@ static int zr364xx_probe(struct usb_interface *intf,
 	err = video_register_device(&cam->vdev, VFL_TYPE_VIDEO, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
-		goto free_handler;
+		goto board_uninit;
 	}
 	cam->v4l2_dev.release = zr364xx_release;
 
@@ -1541,11 +1541,10 @@ static int zr364xx_probe(struct usb_interface *intf,
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

