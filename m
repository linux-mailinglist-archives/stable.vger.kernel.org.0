Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C4113E5F7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391222AbgAPRRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730182AbgAPRR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:17:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BFD424687;
        Thu, 16 Jan 2020 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195048;
        bh=mrqyG+s5KkU79YeSwsbvGa5llda5DIJSBZQHAAEAfXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gri+YUbMHmrrWGG0PpnQrCWTR9VCp9aNDhFoK9fCIGIlG25CBc4W7s+yi0B6n4EmW
         LTOz6R708xpzjd12QUiWD2yfR4Nt+tqJrZQdlIWlj08I9rrE2J35TDWk/R8EtG3EGY
         vj3iepamFEFRb7EVtSNqeeeLHGpGyq5C+/g3jUUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Xinliang Liu <z.liuxinliang@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 006/371] drm/hisilicon: hibmc: Don't overwrite fb helper surface depth
Date:   Thu, 16 Jan 2020 12:11:14 -0500
Message-Id: <20200116171719.16965-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 0ff9f49646353ce31312411e7e7bd2281492a40e ]

Currently the driver overwrites the surface depth provided by the fb
helper to give an invalid bpp/surface depth combination.

This has been exposed by commit 70109354fed2 ("drm: Reject unknown legacy
bpp and depth for drm_mode_addfb ioctl"), which now causes the driver to
fail to probe.

Fix by not overwriting the surface depth.

Fixes: d1667b86795a ("drm/hisilicon/hibmc: Add support for frame buffer")
Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xinliang Liu <z.liuxinliang@hisilicon.com>
Signed-off-by: Xinliang Liu <z.liuxinliang@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c
index 8bd29075ae4e..edcca1761500 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_fbdev.c
@@ -71,7 +71,6 @@ static int hibmc_drm_fb_create(struct drm_fb_helper *helper,
 	DRM_DEBUG_DRIVER("surface width(%d), height(%d) and bpp(%d)\n",
 			 sizes->surface_width, sizes->surface_height,
 			 sizes->surface_bpp);
-	sizes->surface_depth = 32;
 
 	bytes_per_pixel = DIV_ROUND_UP(sizes->surface_bpp, 8);
 
-- 
2.20.1

