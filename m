Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4867EF66FF
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKJCkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfKJCkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38349215EA;
        Sun, 10 Nov 2019 02:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353619;
        bh=Qd/xuIspfGELkLAKANspg6whBWC/YOasqt+zS66jQBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NZQ+jghsGmpfCudcqoFlAHpiTTqmi5bk/Mhl9o3HYrORMHrGX6N0Tv99niDIBjHi
         guyOSW7nKh7pEVq+C0RB48Z5UNd5wZ6Z4xecIWnWlyISgm5rcnfC6J4bDye0fAEI15
         Jc9VAuMZMHY0Hl1Utu3c//2PVWUkhaxpEDexztgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/191] media: vsp1: Fix YCbCr planar formats pitch calculation
Date:   Sat,  9 Nov 2019 21:37:06 -0500
Message-Id: <20191110024013.29782-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

[ Upstream commit 9b2798d5b71c50f64c41a40f0cbcae47c3fbd067 ]

YCbCr planar formats can have different pitch values for the luma and
chroma planes. This isn't taken into account in the driver. Fix it.

Based on a BSP patch from Koji Matsuoka <koji.matsuoka.xm@renesas.com>.

Fixes: 7863ac504bc5 ("drm: rcar-du: Add tri-planar memory formats support")
[Updated documentation of the struct vsp1_du_atomic_config pitch field]

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 11 ++++++++++-
 include/media/vsp1.h                   |  2 +-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index b9c0f695d002b..8d86f618ec776 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -770,6 +770,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
 	const struct vsp1_format_info *fmtinfo;
+	unsigned int chroma_hsub;
 	struct vsp1_rwpf *rpf;
 
 	if (rpf_index >= vsp1->info->rpf_count)
@@ -810,10 +811,18 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 		return -EINVAL;
 	}
 
+	/*
+	 * Only formats with three planes can affect the chroma planes pitch.
+	 * All formats with two planes have a horizontal subsampling value of 2,
+	 * but combine U and V in a single chroma plane, which thus results in
+	 * the luma plane and chroma plane having the same pitch.
+	 */
+	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
+
 	rpf->fmtinfo = fmtinfo;
 	rpf->format.num_planes = fmtinfo->planes;
 	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
-	rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
+	rpf->format.plane_fmt[1].bytesperline = cfg->pitch / chroma_hsub;
 	rpf->alpha = cfg->alpha;
 
 	rpf->mem.addr[0] = cfg->mem[0];
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 3093b9cb9067e..5b383d01c84a0 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -46,7 +46,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 /**
  * struct vsp1_du_atomic_config - VSP atomic configuration parameters
  * @pixelformat: plane pixel format (V4L2 4CC)
- * @pitch: line pitch in bytes, for all planes
+ * @pitch: line pitch in bytes for the first plane
  * @mem: DMA memory address for each plane of the frame buffer
  * @src: source rectangle in the frame buffer (integer coordinates)
  * @dst: destination rectangle on the display (integer coordinates)
-- 
2.20.1

