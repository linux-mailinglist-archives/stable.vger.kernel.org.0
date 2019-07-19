Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23FD6D9E7
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfGSD6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfGSD6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FD32184E;
        Fri, 19 Jul 2019 03:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508693;
        bh=z+8JcC18Jtyh8uyT6UA2/SC24y/hq7VVcY9YA+weTuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1lNXnI+nXdooUfTkRfB1jDqaUZXgNl2kvRsTiJDHEXXe0M+JcNvL9PoxjTclzl27
         QgJwJkQsFwNPXl/oS7LwA03zjFnEmXl1zwsxOGmY8ENxvNEbJiAvX2HnaDYe4iYAal
         TDVCPP+mpJwWrLZgc8/e/KJVc8dVX1vGfowN/uWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 036/171] drm/amd/display: CS_TFM_1D only applied post EOTF
Date:   Thu, 18 Jul 2019 23:54:27 -0400
Message-Id: <20190719035643.14300-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
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

