Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8398824B4AC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgHTKKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730896AbgHTKKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:10:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7673C2075E;
        Thu, 20 Aug 2020 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918218;
        bh=XYRT9QlV1V+F9o3hPmuQ8qXMUy5c6QM3eYvpnEST3fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTYn8/TY1/0+2406oKjk+puYPoTyQh7vr7aVEny9YtLHjJxYmUFAM8Tyr0SUeee1F
         4pF/rlHyx/nrOj5LsauUv8LboYKMCUOzlS9Og3H48aFmGKHgKi8WDc62Lw1wuV2x7R
         c3uRfbP0qpTO/mmPfFUS2QecCcHVipZ+vAb8JU6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/228] drm/arm: fix unintentional integer overflow on left shift
Date:   Thu, 20 Aug 2020 11:21:01 +0200
Message-Id: <20200820091611.914793815@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5f368ddea6fec519bdb93b5368f6a844b6ea27a6 ]

Shifting the integer value 1 is evaluated using 32-bit arithmetic
and then used in an expression that expects a long value leads to
a potential integer overflow. Fix this by using the BIT macro to
perform the shift to avoid the overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Fixes: ad49f8602fe8 ("drm/arm: Add support for Mali Display Processors")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200618100400.11464-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_planes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index 16b8b310ae5c7..7072d738b072b 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -369,7 +369,7 @@ int malidp_de_planes_init(struct drm_device *drm)
 	const struct malidp_hw_regmap *map = &malidp->dev->map;
 	struct malidp_plane *plane = NULL;
 	enum drm_plane_type plane_type;
-	unsigned long crtcs = 1 << drm->mode_config.num_crtc;
+	unsigned long crtcs = BIT(drm->mode_config.num_crtc);
 	unsigned long flags = DRM_MODE_ROTATE_0 | DRM_MODE_ROTATE_90 | DRM_MODE_ROTATE_180 |
 			      DRM_MODE_ROTATE_270 | DRM_MODE_REFLECT_X | DRM_MODE_REFLECT_Y;
 	u32 *formats;
-- 
2.25.1



