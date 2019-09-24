Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2CBCFDE
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfIXRB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2632887AbfIXQnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:43:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5072720872;
        Tue, 24 Sep 2019 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343383;
        bh=RXz6wrou/rLsSHwyEPfyPMYLuJ/X2bB/HTRQZPCvBoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFc/DJIiwKQYvB6FwneZOvQp/91RIcxs68MGdfTNgixpYX/Kmf3Iwe28eBh7hvSGH
         kl9DDB3tYyUI2hCbV/smOu4kZaBB7G9gIPiWrCQv9PRrsR35eu9c4etD+0+XTi6lgm
         A7cQmalKLpEKO+JHjWtetbXzhn0itnUXPy+qQeNk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anthony Koo <Anthony.Koo@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 30/87] drm/amd/display: fix issue where 252-255 values are clipped
Date:   Tue, 24 Sep 2019 12:40:46 -0400
Message-Id: <20190924164144.25591-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Koo <Anthony.Koo@amd.com>

[ Upstream commit 1cbcfc975164f397b449efb17f59d81a703090db ]

[Why]
When endpoint is at the boundary of a region, such as at 2^0=1
we find that the last segment has a sharp slope and some points
are clipped at the top.

[How]
If end point is 1, which is exactly at the 2^0 region boundary, we
need to program an additional region beyond this point.

Signed-off-by: Anthony Koo <Anthony.Koo@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
index 7469333a2c8a5..8166fdbacd732 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c
@@ -357,9 +357,10 @@ bool cm_helper_translate_curve_to_hw_format(
 		seg_distr[7] = 4;
 		seg_distr[8] = 4;
 		seg_distr[9] = 4;
+		seg_distr[10] = 1;
 
 		region_start = -10;
-		region_end = 0;
+		region_end = 1;
 	}
 
 	for (i = region_end - region_start; i < MAX_REGIONS_NUMBER ; i++)
-- 
2.20.1

