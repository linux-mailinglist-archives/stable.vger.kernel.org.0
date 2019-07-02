Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACA85CF87
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGBMec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbfGBMec (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:34:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F9C92054F;
        Tue,  2 Jul 2019 12:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562070871;
        bh=5CgQ4XcaSmQc+CLsab4TbNHADv7Q0aRzEmsoxZkTiE0=;
        h=Subject:To:From:Date:From;
        b=yGIy62a5V8dOIJ2kkOtZnzopHJ/diZ6pe+7vjg1lWYKLbIh2VWcLuMyNFQqojpI8t
         nvlmAZC3tX3hWN/mk9U14QL2J1iUcqldYHe8+ctUfhEDyg2WECKYve/ZKp/m4D5X2O
         TG5PsI0eO0XPZmnUNrveks92/TNS9joAytwkR6og=
Subject: patch "staging: bcm2835-camera: Restore return behavior of" added to staging-next
To:     wahrenst@gmx.net, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Jul 2019 14:29:39 +0200
Message-ID: <156207057920554@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: bcm2835-camera: Restore return behavior of

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From f816db1dc17b99b059325f41ed5a78f85d15368c Mon Sep 17 00:00:00 2001
From: Stefan Wahren <wahrenst@gmx.net>
Date: Wed, 26 Jun 2019 17:48:11 +0200
Subject: staging: bcm2835-camera: Restore return behavior of
 ctrl_set_bitrate()

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
 .../vc04_services/bcm2835-camera/controls.c   | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/controls.c b/drivers/staging/vc04_services/bcm2835-camera/controls.c
index d60e378bdfce..c251164655ba 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/controls.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/controls.c
@@ -604,15 +604,28 @@ static int ctrl_set_bitrate(struct bm2835_mmal_dev *dev,
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
-- 
2.22.0


