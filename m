Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EF0409469
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbhIMObL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344321AbhIMO2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8C8D615A3;
        Mon, 13 Sep 2021 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540990;
        bh=tNweOmfPT6ce2e92V44yvyf7Jg8MztMluPrsKAcB4Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6StdobX8EtZCaiRrxDm/ZVaYG7E3CTWYz0q3h6S+Zb0+gcDoQbF5NIFG5DYNDNQ9
         UJJKOH/kuJKGCuK7UeQ0chu1M91HU0gyKekraqDjZgQfhhihiTdFP1AYzdzxPy2Q2Z
         /1SDpdSbHZ9lxmEZn0EJQdpK3yOPUbb9vK0erNVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 117/334] media: v4l2-subdev: fix some NULL vs IS_ERR() checks
Date:   Mon, 13 Sep 2021 15:12:51 +0200
Message-Id: <20210913131117.327547204@linuxfoundation.org>
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

[ Upstream commit ba7a93e507f88306d7a19a1dcb53b857b790cfb8 ]

The v4l2_subdev_alloc_state() function returns error pointers, it
doesn't return NULL.

Fixes: 0d346d2a6f54 ("media: v4l2-subdev: add subdev-wide state struct")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 4 ++--
 drivers/media/platform/vsp1/vsp1_entity.c   | 4 ++--
 drivers/staging/media/tegra-video/vi.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index cca15a10c0b3..0d141155f0e3 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -253,8 +253,8 @@ static int rvin_try_format(struct rvin_dev *vin, u32 which,
 	int ret;
 
 	sd_state = v4l2_subdev_alloc_state(sd);
-	if (sd_state == NULL)
-		return -ENOMEM;
+	if (IS_ERR(sd_state))
+		return PTR_ERR(sd_state);
 
 	if (!rvin_format_from_pixel(vin, pix->pixelformat))
 		pix->pixelformat = RVIN_DEFAULT_FORMAT;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 6f51e5c75543..823c15facd1b 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -676,9 +676,9 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	 * rectangles.
 	 */
 	entity->config = v4l2_subdev_alloc_state(&entity->subdev);
-	if (entity->config == NULL) {
+	if (IS_ERR(entity->config)) {
 		media_entity_cleanup(&entity->subdev.entity);
-		return -ENOMEM;
+		return PTR_ERR(entity->config);
 	}
 
 	return 0;
diff --git a/drivers/staging/media/tegra-video/vi.c b/drivers/staging/media/tegra-video/vi.c
index 89709cd06d4d..d321790b07d9 100644
--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -508,8 +508,8 @@ static int __tegra_channel_try_format(struct tegra_vi_channel *chan,
 		return -ENODEV;
 
 	sd_state = v4l2_subdev_alloc_state(subdev);
-	if (!sd_state)
-		return -ENOMEM;
+	if (IS_ERR(sd_state))
+		return PTR_ERR(sd_state);
 	/*
 	 * Retrieve the format information and if requested format isn't
 	 * supported, keep the current format.
-- 
2.30.2



