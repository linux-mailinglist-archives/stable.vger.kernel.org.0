Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA703CD777
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbhGSOQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241619AbhGSOQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D13B8610F7;
        Mon, 19 Jul 2021 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706635;
        bh=qBkLDj45rb1PF1V9JD3djCM3r5QgQxga8StteyAHacw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmyiWz/WzXOtI3+xbJ/TKyamNZrH87+yHZUbCK0KVqzmaplsyi91fukmgxmDptQZW
         SaLlYP7MbuTtBcvc8+fqFlD9bdHhmQbRvwmv220IFQ5zfHAbRpngXaA1yvE5QE9m7E
         wof8KaQE0IsRNvHdDFpXyDicfa7hV4cvCTH7vaPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d1e69c888f0d3866ead4@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 030/188] media: cpia2: fix memory leak in cpia2_usb_probe
Date:   Mon, 19 Jul 2021 16:50:14 +0200
Message-Id: <20210719144920.076983524@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit be8656e62e9e791837b606a027802b504a945c97 ]

syzbot reported leak in cpia2 usb driver. The problem was
in invalid error handling.

v4l2_device_register() is called in cpia2_init_camera_struct(), but
all error cases after cpia2_init_camera_struct() did not call the
v4l2_device_unregister()

Reported-by: syzbot+d1e69c888f0d3866ead4@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cpia2/cpia2.h      |  1 +
 drivers/media/usb/cpia2/cpia2_core.c | 12 ++++++++++++
 drivers/media/usb/cpia2/cpia2_usb.c  | 13 +++++++------
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2.h b/drivers/media/usb/cpia2/cpia2.h
index cdef677d57ec..80a7af6482ae 100644
--- a/drivers/media/usb/cpia2/cpia2.h
+++ b/drivers/media/usb/cpia2/cpia2.h
@@ -442,6 +442,7 @@ int cpia2_send_command(struct camera_data *cam, struct cpia2_command *cmd);
 int cpia2_do_command(struct camera_data *cam,
 		     unsigned int command,
 		     unsigned char direction, unsigned char param);
+void cpia2_deinit_camera_struct(struct camera_data *cam, struct usb_interface *intf);
 struct camera_data *cpia2_init_camera_struct(struct usb_interface *intf);
 int cpia2_init_camera(struct camera_data *cam);
 int cpia2_allocate_buffers(struct camera_data *cam);
diff --git a/drivers/media/usb/cpia2/cpia2_core.c b/drivers/media/usb/cpia2/cpia2_core.c
index 187012ce444b..35c9e00267d5 100644
--- a/drivers/media/usb/cpia2/cpia2_core.c
+++ b/drivers/media/usb/cpia2/cpia2_core.c
@@ -2158,6 +2158,18 @@ static void reset_camera_struct(struct camera_data *cam)
 	cam->height = cam->params.roi.height;
 }
 
+/******************************************************************************
+ *
+ *  cpia2_init_camera_struct
+ *
+ *  Deinitialize camera struct
+ *****************************************************************************/
+void cpia2_deinit_camera_struct(struct camera_data *cam, struct usb_interface *intf)
+{
+	v4l2_device_unregister(&cam->v4l2_dev);
+	kfree(cam);
+}
+
 /******************************************************************************
  *
  *  cpia2_init_camera_struct
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 76b9cb940b87..7bd50feadfe4 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -835,15 +835,13 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	ret = set_alternate(cam, USBIF_CMDONLY);
 	if (ret < 0) {
 		ERR("%s: usb_set_interface error (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto alt_err;
 	}
 
 
 	if((ret = cpia2_init_camera(cam)) < 0) {
 		ERR("%s: failed to initialize cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto alt_err;
 	}
 	LOG("  CPiA Version: %d.%02d (%d.%d)\n",
 	       cam->params.version.firmware_revision_hi,
@@ -863,11 +861,14 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	ret = cpia2_register_camera(cam);
 	if (ret < 0) {
 		ERR("%s: Failed to register cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto alt_err;
 	}
 
 	return 0;
+
+alt_err:
+	cpia2_deinit_camera_struct(cam, intf);
+	return ret;
 }
 
 /******************************************************************************
-- 
2.30.2



