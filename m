Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774BF66E2E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfGLMb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbfGLMb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B09D21670;
        Fri, 12 Jul 2019 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934686;
        bh=olJftJlAQ6DDBMLKiEdImLF1HG2V6dQWw8Atvy841GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOmVg4wprhb40w/pj6cIHur78P3BrJjxeLNUNP7chPar38CeNtr0a0QEfMvSTzTG7
         x1/QC5CAAJwqY3MQ1DUbGT+jwQna0KqaWt/WplMk6yRsTbGLgxqk/EQbM8w4LdOOIR
         SHuP1lp+dKfXqEoxGFD816pjo/1wB4thAHgR2kN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 137/138] staging: bcm2835-camera: Handle empty EOS buffers whilst streaming
Date:   Fri, 12 Jul 2019 14:20:01 +0200
Message-Id: <20190712121633.965683307@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.org>

commit a26be06d6d96c10a9ab005e99d93fbb5d3babd98 upstream.

The change to mapping V4L2 to MMAL buffers 1:1 didn't handle
the condition we get with raw pixel buffers (eg YUV and RGB)
direct from the camera's stills port. That sends the pixel buffer
and then an empty buffer with the EOS flag set. The EOS buffer
wasn't handled and returned an error up the stack.

Handle the condition correctly by returning it to the component
if streaming, or returning with an error if stopping streaming.

Fixes: 938416707071 ("staging: bcm2835-camera: Remove V4L2/MMAL buffer remapping")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |   21 +++++-----
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c     |    5 +-
 2 files changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -337,16 +337,13 @@ static void buffer_cb(struct vchiq_mmal_
 		return;
 	} else if (length == 0) {
 		/* stream ended */
-		if (buf) {
-			/* this should only ever happen if the port is
-			 * disabled and there are buffers still queued
+		if (dev->capture.frame_count) {
+			/* empty buffer whilst capturing - expected to be an
+			 * EOS, so grab another frame
 			 */
-			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
-			pr_debug("Empty buffer");
-		} else if (dev->capture.frame_count) {
-			/* grab another frame */
 			if (is_capturing(dev)) {
-				pr_debug("Grab another frame");
+				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+					 "Grab another frame");
 				vchiq_mmal_port_parameter_set(
 					instance,
 					dev->capture.camera_port,
@@ -354,8 +351,14 @@ static void buffer_cb(struct vchiq_mmal_
 					&dev->capture.frame_count,
 					sizeof(dev->capture.frame_count));
 			}
+			if (vchiq_mmal_submit_buffer(instance, port, buf))
+				v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+					 "Failed to return EOS buffer");
 		} else {
-			/* signal frame completion */
+			/* stopping streaming.
+			 * return buffer, and signal frame completion
+			 */
+			vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 			complete(&dev->capture.frame_cmplt);
 		}
 	} else {
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -290,8 +290,6 @@ static int bulk_receive(struct vchiq_mma
 
 	/* store length */
 	msg_context->u.bulk.buffer_used = rd_len;
-	msg_context->u.bulk.mmal_flags =
-	    msg->u.buffer_from_host.buffer_header.flags;
 	msg_context->u.bulk.dts = msg->u.buffer_from_host.buffer_header.dts;
 	msg_context->u.bulk.pts = msg->u.buffer_from_host.buffer_header.pts;
 
@@ -452,6 +450,9 @@ static void buffer_to_host_cb(struct vch
 		return;
 	}
 
+	msg_context->u.bulk.mmal_flags =
+				msg->u.buffer_from_host.buffer_header.flags;
+
 	if (msg->h.status != MMAL_MSG_STATUS_SUCCESS) {
 		/* message reception had an error */
 		pr_warn("error %d in reply\n", msg->h.status);


