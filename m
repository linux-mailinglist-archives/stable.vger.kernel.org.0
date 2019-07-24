Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4D6737F4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387958AbfGXTYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387949AbfGXTYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:24:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D65FD21951;
        Wed, 24 Jul 2019 19:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996273;
        bh=z4Oacyr6gfrrDcPTUMschTDgCCpcNUMEoJIVQ8Kzt/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFAsKYgmrsx686CSJ+sa/8nq+QzBK0eBleNXIUic47JNkZh9/QqUfFTcWeoX26mKi
         fhpqKGb0op4m3XMHvzbXYjitFPTozuTaq389wD7B90eamxq0u1hNKJyKaYucJofec6
         ADUH6NigAWifrIAJ2Kv2jcxQHwkBAFBF9FCQ9iIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hulk Robot <hulkci@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 041/413] media: vim2m: fix two double-free issues
Date:   Wed, 24 Jul 2019 21:15:32 +0200
Message-Id: <20190724191738.538383857@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 20059cbbf981ca954be56f7963ae494d18e2dda1 ]

vim2m_device_release() will be called by video_unregister_device() to release
various objects.

There are two double-free issue,
1. dev->m2m_dev will be freed twice in error_m2m path/vim2m_device_release
2. the error_v4l2 and error_free path in vim2m_probe() will release
   same objects, since vim2m_device_release has done.

Fixes: ea6c7e34f3b2 ("media: vim2m: replace devm_kzalloc by kzalloc")

Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 243c82b5d537..acd3bd48c7e2 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1359,7 +1359,7 @@ static int vim2m_probe(struct platform_device *pdev)
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto error_m2m;
+		goto error_dev;
 	}
 
 	ret = media_device_register(&dev->mdev);
@@ -1373,11 +1373,11 @@ static int vim2m_probe(struct platform_device *pdev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 error_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
-error_m2m:
-	v4l2_m2m_release(dev->m2m_dev);
 #endif
 error_dev:
 	video_unregister_device(&dev->vfd);
+	/* vim2m_device_release called by video_unregister_device to release various objects */
+	return ret;
 error_v4l2:
 	v4l2_device_unregister(&dev->v4l2_dev);
 error_free:
-- 
2.20.1



