Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388422F49C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfE3DMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbfE3DM3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:29 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD28B23D8C;
        Thu, 30 May 2019 03:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185948;
        bh=P8gePBADrgXhsO1Zi2TbG1O6yooU/vBCS7897ZqKO8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhyN7l20NTnvQSKfczovwFrCa//VX2wuuXpdiuTdlfesbpBqfou+Hg1YHvtaKNP64
         yQf6d7kA6KFB0dDFzH85aOWo+yj01G1gYBnWFJ1dDrSkqp+ZA6x6dwuBikvAd8lBfg
         0mOKAdrsTHUTCgwGNe/c+aIFPNScaj3cJ9nOz1no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 360/405] media: vim2m: replace devm_kzalloc by kzalloc
Date:   Wed, 29 May 2019 20:05:58 -0700
Message-Id: <20190530030558.828856761@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ea6c7e34f3b28e165988aa7391310752969842e8 ]

It is not possible to use devm_kzalloc since that memory is
freed immediately when the device instance is unbound.

Various objects like the video device may still be in use
since someone has the device node open, and when that is closed
it expects the memory to be around.

So use kzalloc and release it at the appropriate time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 35 +++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 34dcaca45d8bb..dd47821fc661d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1262,6 +1262,15 @@ static int vim2m_release(struct file *file)
 	return 0;
 }
 
+static void vim2m_device_release(struct video_device *vdev)
+{
+	struct vim2m_dev *dev = container_of(vdev, struct vim2m_dev, vfd);
+
+	v4l2_device_unregister(&dev->v4l2_dev);
+	v4l2_m2m_release(dev->m2m_dev);
+	kfree(dev);
+}
+
 static const struct v4l2_file_operations vim2m_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vim2m_open,
@@ -1277,7 +1286,7 @@ static const struct video_device vim2m_videodev = {
 	.fops		= &vim2m_fops,
 	.ioctl_ops	= &vim2m_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release_empty,
+	.release	= vim2m_device_release,
 	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
 };
 
@@ -1298,13 +1307,13 @@ static int vim2m_probe(struct platform_device *pdev)
 	struct video_device *vfd;
 	int ret;
 
-	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		return ret;
+		goto error_free;
 
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
@@ -1317,7 +1326,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto unreg_v4l2;
+		goto error_v4l2;
 	}
 
 	video_set_drvdata(vfd, dev);
@@ -1330,7 +1339,7 @@ static int vim2m_probe(struct platform_device *pdev)
 	if (IS_ERR(dev->m2m_dev)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(dev->m2m_dev);
-		goto unreg_dev;
+		goto error_dev;
 	}
 
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -1346,27 +1355,29 @@ static int vim2m_probe(struct platform_device *pdev)
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto unreg_m2m;
+		goto error_m2m;
 	}
 
 	ret = media_device_register(&dev->mdev);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
-		goto unreg_m2m_mc;
+		goto error_m2m_mc;
 	}
 #endif
 	return 0;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-unreg_m2m_mc:
+error_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
-unreg_m2m:
+error_m2m:
 	v4l2_m2m_release(dev->m2m_dev);
 #endif
-unreg_dev:
+error_dev:
 	video_unregister_device(&dev->vfd);
-unreg_v4l2:
+error_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
+error_free:
+	kfree(dev);
 
 	return ret;
 }
@@ -1382,9 +1393,7 @@ static int vim2m_remove(struct platform_device *pdev)
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 	media_device_cleanup(&dev->mdev);
 #endif
-	v4l2_m2m_release(dev->m2m_dev);
 	video_unregister_device(&dev->vfd);
-	v4l2_device_unregister(&dev->v4l2_dev);
 
 	return 0;
 }
-- 
2.20.1



