Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB6CAC08
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfJCQEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbfJCQEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4152B207FF;
        Thu,  3 Oct 2019 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118671;
        bh=OZiQOQK6GRMgvpkM/jHIACWmpTyy1Vs+E5l8pYuqDfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyNspbRxr83O63aaPXp58bvqwUj/BBwUSmXvz7KWmGI+PP5aecQ55eoV7juEnnofa
         8MCJ3Ldf1vsXqBtFqIJsyLuwb+WUpi48leqyIuTKbevrtQrDR/EZ1WZ6gS4EG9pyFL
         P3hyd1++PE9dRHIfDYc4vrZVViX4BlECQOJx7S78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 096/129] media: omap3isp: Set device on omap3isp subdevs
Date:   Thu,  3 Oct 2019 17:53:39 +0200
Message-Id: <20191003154403.586416212@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit e9eb103f027725053a4b02f93d7f2858b56747ce ]

The omap3isp driver registered subdevs without the dev field being set. Do
that now.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/ispccdc.c    | 1 +
 drivers/media/platform/omap3isp/ispccp2.c    | 1 +
 drivers/media/platform/omap3isp/ispcsi2.c    | 1 +
 drivers/media/platform/omap3isp/isppreview.c | 1 +
 drivers/media/platform/omap3isp/ispresizer.c | 1 +
 drivers/media/platform/omap3isp/ispstat.c    | 2 ++
 6 files changed, 7 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 882310eb45ccf..fe16fbd95221f 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2608,6 +2608,7 @@ int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
 	int ret;
 
 	/* Register the subdev and video node. */
+	ccdc->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccdc->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index ca095238510d5..b64e218eaea6e 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1030,6 +1030,7 @@ int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	ccp2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccp2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index f75a1be29d84a..27a2913363b62 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1206,6 +1206,7 @@ int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	csi2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &csi2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ac30a0f837801..e981eb2330f18 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2228,6 +2228,7 @@ int omap3isp_preview_register_entities(struct isp_prev_device *prev,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	prev->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &prev->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 0b6a87508584f..2035e3c6a9dee 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1684,6 +1684,7 @@ int omap3isp_resizer_register_entities(struct isp_res_device *res,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	res->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &res->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 1b9217d3b1b6a..4a4ae637655ba 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1010,6 +1010,8 @@ void omap3isp_stat_unregister_entities(struct ispstat *stat)
 int omap3isp_stat_register_entities(struct ispstat *stat,
 				    struct v4l2_device *vdev)
 {
+	stat->subdev.dev = vdev->mdev->dev;
+
 	return v4l2_device_register_subdev(vdev, &stat->subdev);
 }
 
-- 
2.20.1



