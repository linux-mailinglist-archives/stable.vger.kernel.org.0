Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EFB66DE3
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbfGLMeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbfGLMeb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:34:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83BFA216B7;
        Fri, 12 Jul 2019 12:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934870;
        bh=y8I/VZdab5WdTkRjCn3lOhQks0XTwHHV4UXif+RnngE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MxatkRmze0QOLNDP1l2jWFomTvr/vd0zwDlhtpPoCmEj5HtmUdx90Urifdya7qrm7
         GdPsfXLLOxLduEVOnhzB+q6QLHKvyyYXUX7O0Y3ZMFziKvLD1sD+Av9JkLTIheI3+T
         vhABSjmW3lT1skmF8Hggstdq60/FqeHqEC8LM+9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.2 58/61] staging: bcm2835-camera: Ensure all buffers are returned on disable
Date:   Fri, 12 Jul 2019 14:20:11 +0200
Message-Id: <20190712121623.922886882@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.org>

commit 70ec64ccdaac5d8f634338e33b016c1c99831499 upstream.

With the recent change to match MMAL and V4L2 buffers there
is a need to wait for all MMAL buffers to be returned during
stop_streaming.

Fixes: 938416707071 ("staging: bcm2835-camera: Remove V4L2/MMAL buffer remapping")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |   22 +++++++---
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c     |    4 +
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h     |    3 +
 3 files changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -576,6 +576,7 @@ static void stop_streaming(struct vb2_qu
 	int ret;
 	unsigned long timeout;
 	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
+	struct vchiq_mmal_port *port = dev->capture.port;
 
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
 		 __func__, dev);
@@ -599,12 +600,6 @@ static void stop_streaming(struct vb2_qu
 				      &dev->capture.frame_count,
 				      sizeof(dev->capture.frame_count));
 
-	/* wait for last frame to complete */
-	timeout = wait_for_completion_timeout(&dev->capture.frame_cmplt, HZ);
-	if (timeout == 0)
-		v4l2_err(&dev->v4l2_dev,
-			 "timed out waiting for frame completion\n");
-
 	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
 		 "disabling connection\n");
 
@@ -619,6 +614,21 @@ static void stop_streaming(struct vb2_qu
 			 ret);
 	}
 
+	/* wait for all buffers to be returned */
+	while (atomic_read(&port->buffers_with_vpu)) {
+		v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+			 "%s: Waiting for buffers to be returned - %d outstanding\n",
+			 __func__, atomic_read(&port->buffers_with_vpu));
+		timeout = wait_for_completion_timeout(&dev->capture.frame_cmplt,
+						      HZ);
+		if (timeout == 0) {
+			v4l2_err(&dev->v4l2_dev, "%s: Timeout waiting for buffers to be returned - %d outstanding\n",
+				 __func__,
+				 atomic_read(&port->buffers_with_vpu));
+			break;
+		}
+	}
+
 	if (disable_camera(dev) < 0)
 		v4l2_err(&dev->v4l2_dev, "Failed to disable camera\n");
 }
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -240,6 +240,8 @@ static void buffer_work_cb(struct work_s
 	struct mmal_msg_context *msg_context =
 		container_of(work, struct mmal_msg_context, u.bulk.work);
 
+	atomic_dec(&msg_context->u.bulk.port->buffers_with_vpu);
+
 	msg_context->u.bulk.port->buffer_cb(msg_context->u.bulk.instance,
 					    msg_context->u.bulk.port,
 					    msg_context->u.bulk.status,
@@ -380,6 +382,8 @@ buffer_from_host(struct vchiq_mmal_insta
 	/* initialise work structure ready to schedule callback */
 	INIT_WORK(&msg_context->u.bulk.work, buffer_work_cb);
 
+	atomic_inc(&port->buffers_with_vpu);
+
 	/* prep the buffer from host message */
 	memset(&m, 0xbc, sizeof(m));	/* just to make debug clearer */
 
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
@@ -71,6 +71,9 @@ struct vchiq_mmal_port {
 	struct list_head buffers;
 	/* lock to serialise adding and removing buffers from list */
 	spinlock_t slock;
+
+	/* Count of buffers the VPU has yet to return */
+	atomic_t buffers_with_vpu;
 	/* callback on buffer completion */
 	vchiq_mmal_buffer_cb buffer_cb;
 	/* callback context */


