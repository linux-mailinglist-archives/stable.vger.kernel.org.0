Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2334266DC7
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfGLMdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727294AbfGLMdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:33:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC9C6208E4;
        Fri, 12 Jul 2019 12:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934811;
        bh=UUpzPaozM63OqOusbQvhU+g8n3GVKU1w9rUL1iNlurA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5+aBPJyb+pnIn8pbr2voQyEnpVuWGCH+BgV2hsCt5FUC6c/1lMGqYG6wjEE524BO
         MG6l3zMOHWQpPcaPMR04S3fB1quVFGg+BY0UpXrJDWpNYWgSilFCTj+ExMbcQdx0yR
         2GTqSUFEuOgqdNK7BL8OP1QIFwGN7V8yFFJ7juLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.2 37/61] staging: bcm2835-camera: Restore return behavior of ctrl_set_bitrate()
Date:   Fri, 12 Jul 2019 14:19:50 +0200
Message-Id: <20190712121622.621605772@linuxfoundation.org>
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

From: Stefan Wahren <wahrenst@gmx.net>

commit f816db1dc17b99b059325f41ed5a78f85d15368c upstream.

The commit 52c4dfcead49 ("Staging: vc04_services: Cleanup in
ctrl_set_bitrate()") changed the return behavior of ctrl_set_bitrate().
We cannot do this because of a bug in the firmware, which breaks probing
of bcm2835-camera:

    bcm2835-v4l2: mmal_init: failed to set all camera controls: -3
    Cleanup: Destroy video encoder
    Cleanup: Destroy image encoder
    Cleanup: Destroy video render
    Cleanup: Destroy camera
    bcm2835-v4l2: bcm2835_mmal_probe: mmal init failed: -3
    bcm2835-camera: probe of bcm2835-camera failed with error -3

So restore the old behavior, add an explaining comment and a debug message
to verify that the bug has been fixed in firmware.

Fixes: 52c4dfcead49 ("Staging: vc04_services: Cleanup in ctrl_set_bitrate()")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/bcm2835-camera/controls.c |   19 +++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/staging/vc04_services/bcm2835-camera/controls.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/controls.c
@@ -603,15 +603,28 @@ static int ctrl_set_bitrate(struct bm283
 			    struct v4l2_ctrl *ctrl,
 			    const struct bm2835_mmal_v4l2_ctrl *mmal_ctrl)
 {
+	int ret;
 	struct vchiq_mmal_port *encoder_out;
 
 	dev->capture.encode_bitrate = ctrl->val;
 
 	encoder_out = &dev->component[MMAL_COMPONENT_VIDEO_ENCODE]->output[0];
 
-	return vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
-					     mmal_ctrl->mmal_id, &ctrl->val,
-					     sizeof(ctrl->val));
+	ret = vchiq_mmal_port_parameter_set(dev->instance, encoder_out,
+					    mmal_ctrl->mmal_id, &ctrl->val,
+					    sizeof(ctrl->val));
+
+	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev,
+		 "%s: After: mmal_ctrl:%p ctrl id:0x%x ctrl val:%d ret %d(%d)\n",
+		 __func__, mmal_ctrl, ctrl->id, ctrl->val, ret,
+		 (ret == 0 ? 0 : -EINVAL));
+
+	/*
+	 * Older firmware versions (pre July 2019) have a bug in handling
+	 * MMAL_PARAMETER_VIDEO_BIT_RATE that result in the call
+	 * returning -MMAL_MSG_STATUS_EINVAL. So ignore errors from this call.
+	 */
+	return 0;
 }
 
 static int ctrl_set_bitrate_mode(struct bm2835_mmal_dev *dev,


