Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15499411A13
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239931AbhITQrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236904AbhITQrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9211561177;
        Mon, 20 Sep 2021 16:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156337;
        bh=+6b2Pgjx+/2WH6XF7xjweivXSPduCFRwvN5Du56Y924=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=paWapvENhfJ7RkTenmpofFgqAD4J6M/IGU1qLI4/9B3mqYL00q94drJJue0Npwggd
         TJxBvW9Jz08p7UWhVj/2fzCjhx1EN6GRnJrgoMJtt6JDu9TRX2g1zRe7/YLYAaXZzv
         ElgCwj12WFcmM5cJDDi+FgYJju6L2If7dxD/ChEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 013/133] media: stkwebcam: fix memory leak in stk_camera_probe
Date:   Mon, 20 Sep 2021 18:41:31 +0200
Message-Id: <20210920163913.041211033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -1353,7 +1353,7 @@ static int stk_camera_probe(struct usb_i
 	if (!dev->isoc_ep) {
 		STK_ERROR("Could not find isoc-in endpoint");
 		err = -ENODEV;
-		goto error;
+		goto error_put;
 	}
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
@@ -1366,10 +1366,12 @@ static int stk_camera_probe(struct usb_i
 
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


