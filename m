Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCED6DF00
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfGSEDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:03:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbfGSEDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68EAC21852;
        Fri, 19 Jul 2019 04:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509022;
        bh=z+8JcC18Jtyh8uyT6UA2/SC24y/hq7VVcY9YA+weTuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INrLGGr2tGkPMzWCVfW7IZQSnJU5FvkBcFX9Nte5umu6BFp+VEIN2YQGAz8wO7cgv
         ePq7jHIb6y/cKRpuje6CSfISwfmptNgxsQM+1c5+8yU8hTPoOIPsWcWBBMS/GtFJNy
         6XywLBdArfldITTMQ3+ljyFF5Z6owR05i8aNZlVo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 026/141] drm/amd/display: CS_TFM_1D only applied post EOTF
Date:   Fri, 19 Jul 2019 00:00:51 -0400
Message-Id: <20190719040246.15945-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krunoslav Kovac <Krunoslav.Kovac@amd.com>

[ Upstream commit 6ad34adeaec5b56a5ba90e90099cabf1c1fe9dd2 ]

[Why]
There's some unnecessary mem allocation for CS_TFM_ID. What's worse, it
depends on LUT size and since it's 4K for CS_TFM_1D, it is 16x bigger
than in regular case when it's actually needed. This leads to some
crashes in stress conditions.

[How]
Skip ramp combining designed for RGB256 and DXGI gamma with CS_TFM_1D.

Signed-off-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index a1055413bade..31f867bb5afe 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1564,7 +1564,8 @@ bool mod_color_calculate_regamma_params(struct dc_transfer_func *output_tf,
 
 	output_tf->type = TF_TYPE_DISTRIBUTED_POINTS;
 
-	if (ramp && (mapUserRamp || ramp->type != GAMMA_RGB_256)) {
+	if (ramp && ramp->type != GAMMA_CS_TFM_1D &&
+			(mapUserRamp || ramp->type != GAMMA_RGB_256)) {
 		rgb_user = kvcalloc(ramp->num_entries + _EXTRA_POINTS,
 			    sizeof(*rgb_user),
 			    GFP_KERNEL);
-- 
2.20.1

