Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816F7CACD0
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730377AbfJCR35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387986AbfJCQMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D97215EA;
        Thu,  3 Oct 2019 16:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119131;
        bh=+f4ZTr+2SP7h876PnC5XxXjoZvv2scMPl8W6mJh7DPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vdz0Qz3PXlcaLYrYM5kXbrHOwc2MkixPz/KIYMXAgIiudXbRPmAL0TQG5zdWQZXqF
         QZ2afeZhu5CZ9YcyNinOTi/eL3hwLfpqC0NE5F2WQNaInIa/p6CpQ2SsPtSX8JWobe
         6Cxt4/2ZWJSQkOTLKL17Ymqtd6E4LX3BG/JNP/sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 138/185] media: omap3isp: Set device on omap3isp subdevs
Date:   Thu,  3 Oct 2019 17:53:36 +0200
Message-Id: <20191003154508.834165159@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
index b66276ab5765d..a2c18ab8167ee 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2605,6 +2605,7 @@ int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
 	int ret;
 
 	/* Register the subdev and video node. */
+	ccdc->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccdc->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index e062939d0d054..47b0d3fe87d80 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1034,6 +1034,7 @@ int omap3isp_ccp2_register_entities(struct isp_ccp2_device *ccp2,
 	int ret;
 
 	/* Register the subdev and video nodes. */
+	ccp2->subdev.dev = vdev->mdev->dev;
 	ret = v4l2_device_register_subdev(vdev, &ccp2->subdev);
 	if (ret < 0)
 		goto error;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index a4d3d030e81e2..e45292a1bf6c5 100644
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
index 47cbc7e3d825a..24c07939aeddb 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -1018,6 +1018,8 @@ void omap3isp_stat_unregister_entities(struct ispstat *stat)
 int omap3isp_stat_register_entities(struct ispstat *stat,
 				    struct v4l2_device *vdev)
 {
+	stat->subdev.dev = vdev->mdev->dev;
+
 	return v4l2_device_register_subdev(vdev, &stat->subdev);
 }
 
-- 
2.20.1



