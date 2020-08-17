Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE1D247361
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388558AbgHQSzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730904AbgHQPu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85BF2063A;
        Mon, 17 Aug 2020 15:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679457;
        bh=05iKHycDZmcIvSow2mGu/p3lmoFOWIEpyO5G7US79J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joUR7m+85KMESNiTFOPk/6ZH5tKd3ZUV1K+HubcqSoXeOmwsq/9zeDvYq7mAFS8Nq
         aqQBZEziSQteiOKFbFskP5uEmbmcooss2FODCrkomJHFQLPCFiTrzSXyHX6kyNBIGa
         BgSIvJCqpejfwzoZ/9EJS+rZhywRLjyCbHqoeVO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 217/393] media: s5p-g2d: Fix a memory leak in an error handling path in g2d_probe()
Date:   Mon, 17 Aug 2020 17:14:27 +0200
Message-Id: <20200817143830.152473225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 94b9ce6870f9c90ac92505482689818b254312f7 ]

Memory allocated with 'v4l2_m2m_init()' must be freed by a corresponding
call to 'v4l2_m2m_release()'

Also reorder the code at the end of the probe function so that
'video_register_device()' is called last.
Update the error handling path accordingly.

Fixes: 5ce60d790a24 ("[media] s5p-g2d: Add DT based discovery support")
Fixes: 918847341af0 ("[media] v4l: add G2D driver for s5p device family")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: checkpatch: align with parenthesis]
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-g2d/g2d.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 6932fd47071b0..15bcb7f6e113c 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -695,21 +695,13 @@ static int g2d_probe(struct platform_device *pdev)
 	vfd->lock = &dev->mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
-	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
-	}
-	video_set_drvdata(vfd, dev);
-	dev->vfd = vfd;
-	v4l2_info(&dev->v4l2_dev, "device registered as /dev/video%d\n",
-								vfd->num);
+
 	platform_set_drvdata(pdev, dev);
 	dev->m2m_dev = v4l2_m2m_init(&g2d_m2m_ops);
 	if (IS_ERR(dev->m2m_dev)) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(dev->m2m_dev);
-		goto unreg_video_dev;
+		goto rel_vdev;
 	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
@@ -717,14 +709,24 @@ static int g2d_probe(struct platform_device *pdev)
 	of_id = of_match_node(exynos_g2d_match, pdev->dev.of_node);
 	if (!of_id) {
 		ret = -ENODEV;
-		goto unreg_video_dev;
+		goto free_m2m;
 	}
 	dev->variant = (struct g2d_variant *)of_id->data;
 
+	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto free_m2m;
+	}
+	video_set_drvdata(vfd, dev);
+	dev->vfd = vfd;
+	v4l2_info(&dev->v4l2_dev, "device registered as /dev/video%d\n",
+		  vfd->num);
+
 	return 0;
 
-unreg_video_dev:
-	video_unregister_device(dev->vfd);
+free_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
 rel_vdev:
 	video_device_release(vfd);
 unreg_v4l2_dev:
-- 
2.25.1



