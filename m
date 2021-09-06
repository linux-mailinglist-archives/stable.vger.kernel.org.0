Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE490401BA0
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbhIFM6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242564AbhIFM6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB7116103D;
        Mon,  6 Sep 2021 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933021;
        bh=u9zluEWB18JkYxp3OuvxqEPeLfuUjRgiLvaU6qfkzmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTdTPRlDK75rld/e06aJAzIiJz5V3FYbV+8KyQ57odEESxEJDf6eBWCJPeD6ynbRr
         /m45FtDk6/l/zhmXMgaA/lFvSW6XVByiDaAsMAtxsRNxA9/wn4szMmqFQ6Z1GOsmlH
         mzCJWIhZjSZD1MEZKG3u3/R03lTdGpelqOD6Prhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 29/29] media: stkwebcam: fix memory leak in stk_camera_probe
Date:   Mon,  6 Sep 2021 14:55:44 +0200
Message-Id: <20210906125450.745519833@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
References: <20210906125449.756437409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 514e97674400462cc09c459a1ddfb9bf39017223 upstream.

My local syzbot instance hit memory leak in usb_set_configuration().
The problem was in unputted usb interface. In case of errors after
usb_get_intf() the reference should be putted to correclty free memory
allocated for this interface.

Fixes: ec16dae5453e ("V4L/DVB (7019): V4L: add support for Syntek DC1125 webcams")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1346,7 +1346,7 @@ static int stk_camera_probe(struct usb_i
 	if (!dev->isoc_ep) {
 		pr_err("Could not find isoc-in endpoint\n");
 		err = -ENODEV;
-		goto error;
+		goto error_put;
 	}
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
@@ -1359,10 +1359,12 @@ static int stk_camera_probe(struct usb_i
 
 	err = stk_register_video_device(dev);
 	if (err)
-		goto error;
+		goto error_put;
 
 	return 0;
 
+error_put:
+	usb_put_intf(interface);
 error:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);


