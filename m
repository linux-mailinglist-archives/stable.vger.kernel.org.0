Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACAB32E7DA
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCEMXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229597AbhCEMXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:23:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1716965005;
        Fri,  5 Mar 2021 12:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614946994;
        bh=l0OMyUOsvplIadBk2VtegWoerfuDFNSc0SKgU2cOdAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsjlvI482U1Ha0dtgisHF2INbNBdNx0Eoww3FUZhMYoC7fpzbNnnimYOGjH/0GIQI
         BCQwXiHU9740j4QR3stt3YqPYF1fNgKoANOKrWKB7hTzY2M6QTDodMF3WE8rsDgRd4
         fbIWhm4JHisDW8eKUKySf9Dq3328Z3exeOtBxjAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b4d54814b339b5c6bbd4@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.11 010/104] media: zr364xx: fix memory leaks in probe()
Date:   Fri,  5 Mar 2021 13:20:15 +0100
Message-Id: <20210305120903.699880298@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ea354b6ddd6f09be29424f41fa75a3e637fea234 upstream.

Syzbot discovered that the probe error handling doesn't clean up the
resources allocated in zr364xx_board_init().  There are several
related bugs in this code so I have re-written the error handling.

1)  Introduce a new function zr364xx_board_uninit() which cleans up
    the resources in zr364xx_board_init().
2)  In zr364xx_board_init() if the call to zr364xx_start_readpipe()
    fails then release the "cam->buffer.frame[i].lpvbits" memory
    before returning.  This way every function either allocates
    everything successfully or it cleans up after itself.
3)  Re-write the probe function so that each failure path goto frees
    the most recent allocation.  That way we don't free anything
    before it has been allocated and we can also verify that
    everything is freed.
4)  Originally, in the probe function the "cam->v4l2_dev.release"
    pointer was set to "zr364xx_release" near the start but I moved
    that assignment to the end, after everything had succeeded.  The
    release function was never actually called during the probe cleanup
    process, but with this change I wanted to make it clear that we
    don't want to call zr364xx_release() until everything is
    allocated successfully.

Next I re-wrote the zr364xx_release() function.  Ideally this would
have been a simple matter of copy and pasting the cleanup code from
probe and adding an additional call to video_unregister_device().  But
there are a couple quirks to note.

1)  The probe function does not call videobuf_mmap_free() and I don't
    know where the videobuf_mmap is allocated.  I left the code as-is to
    avoid introducing a bug in code I don't understand.
2)  The zr364xx_board_uninit() has a call to zr364xx_stop_readpipe()
    which is a change from the original behavior with regards to
    unloading the driver.  Calling zr364xx_stop_readpipe() on a stopped
    pipe is not a problem so this is safe and is potentially a bugfix.

Reported-by: syzbot+b4d54814b339b5c6bbd4@syzkaller.appspotmail.com
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/zr364xx/zr364xx.c |   49 ++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 18 deletions(-)

--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1181,15 +1181,11 @@ out:
 	return err;
 }
 
-static void zr364xx_release(struct v4l2_device *v4l2_dev)
+static void zr364xx_board_uninit(struct zr364xx_camera *cam)
 {
-	struct zr364xx_camera *cam =
-		container_of(v4l2_dev, struct zr364xx_camera, v4l2_dev);
 	unsigned long i;
 
-	v4l2_device_unregister(&cam->v4l2_dev);
-
-	videobuf_mmap_free(&cam->vb_vidq);
+	zr364xx_stop_readpipe(cam);
 
 	/* release sys buffers */
 	for (i = 0; i < FRAMES; i++) {
@@ -1200,9 +1196,19 @@ static void zr364xx_release(struct v4l2_
 		cam->buffer.frame[i].lpvbits = NULL;
 	}
 
-	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	/* release transfer buffer */
 	kfree(cam->pipe->transfer_buffer);
+}
+
+static void zr364xx_release(struct v4l2_device *v4l2_dev)
+{
+	struct zr364xx_camera *cam =
+		container_of(v4l2_dev, struct zr364xx_camera, v4l2_dev);
+
+	videobuf_mmap_free(&cam->vb_vidq);
+	v4l2_ctrl_handler_free(&cam->ctrl_handler);
+	zr364xx_board_uninit(cam);
+	v4l2_device_unregister(&cam->v4l2_dev);
 	kfree(cam);
 }
 
@@ -1376,11 +1382,14 @@ static int zr364xx_board_init(struct zr3
 	/* start read pipe */
 	err = zr364xx_start_readpipe(cam);
 	if (err)
-		goto err_free;
+		goto err_free_frames;
 
 	DBG(": board initialized\n");
 	return 0;
 
+err_free_frames:
+	for (i = 0; i < FRAMES; i++)
+		vfree(cam->buffer.frame[i].lpvbits);
 err_free:
 	kfree(cam->pipe->transfer_buffer);
 	cam->pipe->transfer_buffer = NULL;
@@ -1409,12 +1418,10 @@ static int zr364xx_probe(struct usb_inte
 	if (!cam)
 		return -ENOMEM;
 
-	cam->v4l2_dev.release = zr364xx_release;
 	err = v4l2_device_register(&intf->dev, &cam->v4l2_dev);
 	if (err < 0) {
 		dev_err(&udev->dev, "couldn't register v4l2_device\n");
-		kfree(cam);
-		return err;
+		goto free_cam;
 	}
 	hdl = &cam->ctrl_handler;
 	v4l2_ctrl_handler_init(hdl, 1);
@@ -1423,7 +1430,7 @@ static int zr364xx_probe(struct usb_inte
 	if (hdl->error) {
 		err = hdl->error;
 		dev_err(&udev->dev, "couldn't register control\n");
-		goto fail;
+		goto unregister;
 	}
 	/* save the init method used by this camera */
 	cam->method = id->driver_info;
@@ -1496,7 +1503,7 @@ static int zr364xx_probe(struct usb_inte
 	if (!cam->read_endpoint) {
 		err = -ENOMEM;
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
-		goto fail;
+		goto unregister;
 	}
 
 	/* v4l */
@@ -1507,10 +1514,11 @@ static int zr364xx_probe(struct usb_inte
 
 	/* load zr364xx board specific */
 	err = zr364xx_board_init(cam);
-	if (!err)
-		err = v4l2_ctrl_handler_setup(hdl);
 	if (err)
-		goto fail;
+		goto unregister;
+	err = v4l2_ctrl_handler_setup(hdl);
+	if (err)
+		goto board_uninit;
 
 	spin_lock_init(&cam->slock);
 
@@ -1525,16 +1533,21 @@ static int zr364xx_probe(struct usb_inte
 	err = video_register_device(&cam->vdev, VFL_TYPE_VIDEO, -1);
 	if (err) {
 		dev_err(&udev->dev, "video_register_device failed\n");
-		goto fail;
+		goto free_handler;
 	}
+	cam->v4l2_dev.release = zr364xx_release;
 
 	dev_info(&udev->dev, DRIVER_DESC " controlling device %s\n",
 		 video_device_node_name(&cam->vdev));
 	return 0;
 
-fail:
+free_handler:
 	v4l2_ctrl_handler_free(hdl);
+board_uninit:
+	zr364xx_board_uninit(cam);
+unregister:
 	v4l2_device_unregister(&cam->v4l2_dev);
+free_cam:
 	kfree(cam);
 	return err;
 }


