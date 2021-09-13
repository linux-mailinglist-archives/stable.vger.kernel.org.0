Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EB840946B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345057AbhIMObL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344727AbhIMO2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 801E6615A4;
        Mon, 13 Sep 2021 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540993;
        bh=0eVmFigmvePfK0NtKm7EzbzuJ3ya/9SnuQww5F3AvfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzRMXypW9gq9lS0my+Ht3rsw5wtpHGUKTS6uW/sHWBtpKhhnCxyzWbSTf+0X9/sOx
         OtsjaaRGKzqDQmOsXa/ldaytI7PPHtyxzbvFx/T8p17hddq9ZGguVHi91J6pd3cf7u
         z5EylH7jfP0aD1VbdyjYPNy2q3kFmgRop9t7xB8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 118/334] media: rockchip/rga: fix error handling in probe
Date:   Mon, 13 Sep 2021 15:12:52 +0200
Message-Id: <20210913131117.359127531@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e58430e1d4fd01b74475d2fbe2e25b5817b729a9 ]

There are a few bugs in this code.  1)  No checks for whether
dma_alloc_attrs() or __get_free_pages() failed.  2)  If
video_register_device() fails it doesn't clean up the dma attrs or the
free pages.  3)  The video_device_release() function frees "vfd" which
leads to a use after free on the next line.  The call to
video_unregister_device() is not required so I have just removed that.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 27 ++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index bf3fd71ec3af..6759091b15e0 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -863,12 +863,12 @@ static int rga_probe(struct platform_device *pdev)
 	if (IS_ERR(rga->m2m_dev)) {
 		v4l2_err(&rga->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(rga->m2m_dev);
-		goto unreg_video_dev;
+		goto rel_vdev;
 	}
 
 	ret = pm_runtime_resume_and_get(rga->dev);
 	if (ret < 0)
-		goto unreg_video_dev;
+		goto rel_vdev;
 
 	rga->version.major = (rga_read(rga, RGA_VERSION_INFO) >> 24) & 0xFF;
 	rga->version.minor = (rga_read(rga, RGA_VERSION_INFO) >> 20) & 0x0F;
@@ -882,11 +882,23 @@ static int rga_probe(struct platform_device *pdev)
 	rga->cmdbuf_virt = dma_alloc_attrs(rga->dev, RGA_CMDBUF_SIZE,
 					   &rga->cmdbuf_phy, GFP_KERNEL,
 					   DMA_ATTR_WRITE_COMBINE);
+	if (!rga->cmdbuf_virt) {
+		ret = -ENOMEM;
+		goto rel_vdev;
+	}
 
 	rga->src_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (!rga->src_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_dma;
+	}
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
+	if (rga->dst_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_src_pages;
+	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 	def_frame.size = def_frame.stride * def_frame.height;
@@ -894,7 +906,7 @@ static int rga_probe(struct platform_device *pdev)
 	ret = video_register_device(vfd, VFL_TYPE_VIDEO, -1);
 	if (ret) {
 		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
-		goto rel_vdev;
+		goto free_dst_pages;
 	}
 
 	v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
@@ -902,10 +914,15 @@ static int rga_probe(struct platform_device *pdev)
 
 	return 0;
 
+free_dst_pages:
+	free_pages((unsigned long)rga->dst_mmu_pages, 3);
+free_src_pages:
+	free_pages((unsigned long)rga->src_mmu_pages, 3);
+free_dma:
+	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, rga->cmdbuf_virt,
+		       rga->cmdbuf_phy, DMA_ATTR_WRITE_COMBINE);
 rel_vdev:
 	video_device_release(vfd);
-unreg_video_dev:
-	video_unregister_device(rga->vfd);
 unreg_v4l2_dev:
 	v4l2_device_unregister(&rga->v4l2_dev);
 err_put_clk:
-- 
2.30.2



