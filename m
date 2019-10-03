Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F48CA7F5
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405697AbfJCQse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405695AbfJCQsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:48:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1765220865;
        Thu,  3 Oct 2019 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121310;
        bh=1X4dbgK86t92uPuoRJwnsA5icgB6cWJxddxWb6aSO5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbTEC7vfv7TurwAc1CTp56/13TwmmkY554/BCVXafkMIuFxAZbPHBCMD1kkNW1E/y
         9hG3T/gLtyh70if43rCqa9M7J0GXrZPQ4fUCtoNmUujvL416c8eQidTK6oo54Pcffy
         Qe7gEZVjHCDYZzO/5J8WCCT6Ld8Y/BrRyapdrnwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 233/344] media: omap3isp: Set device on omap3isp subdevs
Date:   Thu,  3 Oct 2019 17:53:18 +0200
Message-Id: <20191003154603.366281679@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
index 1ba8a5ba343f6..e2f336c715a4d 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2602,6 +2602,7 @@ int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
 	int ret;
 
 	/* Register the subdev and video node. */
+	ccdc->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccdc->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index efca45bb02c8b..d0a49cdfd22d2 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1031,6 +1031,7 @@ int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	ccp2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccp2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index e85917f4a50cc..fd493c5e4e24f 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1198,6 +1198,7 @@ int omap3isp_csi2_register_entities(struct isp_csi2_device *csi2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	csi2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &csi2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 40e22400cf5ec..97d660606d984 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2225,6 +2225,7 @@ int omap3isp_preview_register_entities(struct isp_prev_device *prev,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	prev->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &prev->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 21ca6954df72f..78d9dd7ea2da7 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1681,6 +1681,7 @@ int omap3isp_resizer_register_entities(struct isp_res_device *res,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	res->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &res->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 62b2eacb96fd1..5b9b57f4d9bf8 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1026,6 +1026,8 @@ void omap3isp_stat_unregister_entities(struct ispstat *stat)
 int omap3isp_stat_register_entities(struct ispstat *stat,
 				    struct v4l2_device *vdev)
 {
+	stat->subdev.dev = vdev->mdev->dev;
+
 	return v4l2_device_register_subdev(vdev, &stat->subdev);
 }
 
-- 
2.20.1



