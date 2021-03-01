Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C49328E98
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241983AbhCATdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241712AbhCAT2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E38465207;
        Mon,  1 Mar 2021 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619307;
        bh=lQ68UIbN/FBSWVpJgWvE+MXFTVy5CMuUOenWmCOtPx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVF9m6Xw3cDjx882zvPAfa+y2SkyQcOQOnHCMkzmXEc7eesFnzZrRHNZI0ViWZG5j
         IGaglhYnt1KLrT33s54WTbTfDkzSwxrPxwDWVxPVogIuTAB0OaUuGBlYoa1mpbKYK0
         Dg5oOpymCBjHqtB+JwYQU199iUHaQ/krQM1IajVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iskren Chernev <iskren.chernev@gmail.com>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 408/663] drm/msm: Fix MSM_INFO_GET_IOVA with carveout
Date:   Mon,  1 Mar 2021 17:10:56 +0100
Message-Id: <20210301161202.055355160@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iskren Chernev <iskren.chernev@gmail.com>

[ Upstream commit 6cefa31e810404dafdfcdb94874146cea11626c2 ]

The msm_gem_get_iova should be guarded with gpu != NULL and not aspace
!= NULL, because aspace is NULL when using vram carveout.

Fixes: 933415e24bd0d ("drm/msm: Add support for private address space instances")

Signed-off-by: Iskren Chernev <iskren.chernev@gmail.com>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index d556c353e5aea..3d0adfa6736a5 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -775,9 +775,10 @@ static int msm_ioctl_gem_info_iova(struct drm_device *dev,
 		struct drm_file *file, struct drm_gem_object *obj,
 		uint64_t *iova)
 {
+	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_file_private *ctx = file->driver_priv;
 
-	if (!ctx->aspace)
+	if (!priv->gpu)
 		return -EINVAL;
 
 	/*
-- 
2.27.0



