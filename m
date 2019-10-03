Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2BCA1C6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfJCP7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbfJCP7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:59:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900BA207FF;
        Thu,  3 Oct 2019 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118343;
        bh=T/E/BwtN/dI1JDper1M7B7IKOkO6LvSfCJ6TLxvs+Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQpQAOLFwKdRJG8uIB1iIhb+H/Nx4DYFLhAYlPTImb8zpvRK4rfAtLjpra7EgF86g
         zC8UJtFwpUIO4tm/yIe2g1mSGqyvquWSQ9krPC5K/LZ5jum0NjUFLghogsUPen+i8T
         gdlsE0ldYlWq/5xZFIz+G06+rBpABskMTFfMIxwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 75/99] media: omap3isp: Set device on omap3isp subdevs
Date:   Thu,  3 Oct 2019 17:53:38 +0200
Message-Id: <20191003154333.664045608@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
index a6a61cce43dda..e349f5d990b73 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2603,6 +2603,7 @@ int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
 	int ret;
 
 	/* Register the subdev and video node. */
+	ccdc->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccdc->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index 38e6a974c5b1e..e6b19b785c2f4 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1025,6 +1025,7 @@ int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	ccp2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccp2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index a78338d012b4d..029b434b76094 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1201,6 +1201,7 @@ int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	csi2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &csi2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 13803270d1045..c9e8845de1b1d 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2223,6 +2223,7 @@ int omap3isp_preview_register_entities(struct isp_prev_device *prev,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	prev->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &prev->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 7cfb43dc0ffd7..d4e53cbe91936 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1679,6 +1679,7 @@ int omap3isp_resizer_register_entities(struct isp_res_device *res,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	res->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &res->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 94d4c295d3d00..c54c5c494b751 100644
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



