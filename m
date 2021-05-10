Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12346378608
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhEJLDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234828AbhEJK5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610B361946;
        Mon, 10 May 2021 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643777;
        bh=AZe2vZ5ADJJaJ4xV8wf/15PTru8F8h0rROcmQxBeQO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwPUq2jF8BTW9d9fQNTPJWksn/Kne2ROidAyx56U4h5an/gmfsEOlbf1TwTBxNKDl
         ZyzL20PgPJ9tvGku9BvmA9I+I1sYtes/tZpXXxnOR/uMbO+VrmiNta0PKy3+kugSiq
         Ky+gaDngOJIHPJqmdBrjth+PMkee8tTetXNI7GNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+efe9aefc31ae1e6f7675@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 154/342] media: drivers/media/usb: fix memory leak in zr364xx_probe
Date:   Mon, 10 May 2021 12:19:04 +0200
Message-Id: <20210510102015.181417815@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



