Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB315DC4D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgBNPwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbgBNPwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBD0A24689;
        Fri, 14 Feb 2020 15:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695523;
        bh=lfuItnAjLV1uiBjJIgch9+/5wip+0lLh8/IWZnYQ35w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyzIaee3B1PEUVOpZDVQTxxtaIQlfolOHhEdiaQdNzyVptKk1xIgFpvG2spuosic2
         lpER2CJDqwGmGHcIDXlnAfaZ/TJYlDrg2riLnzbnlv/e9riK8rXg6nzIkLB+8HB9eR
         GMXO6F4Xy7+nIHTEbZl2YpteLo+oR6iVPczw2nXE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Evan Quan <evan.quan@amd.com>,
        Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 145/542] drm/amd/powerplay: remove set but not used variable 'data'
Date:   Fri, 14 Feb 2020 10:42:17 -0500
Message-Id: <20200214154854.6746-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 4bf321c177c74f7d834956387cd74805c3098322 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c: In function vega10_get_performance_level:
drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c:5217:23: warning: variable data set but not used [-Wunused-but-set-variable]

'data' is introduced by commit f688b614b643 ("drm/amd/pp:
Implement get_performance_level for legacy dgpu"), but never used,
so remove it.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
index d71a492c87a32..b29e996df1d47 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c
@@ -5252,13 +5252,11 @@ static int vega10_get_performance_level(struct pp_hwmgr *hwmgr, const struct pp_
 				PHM_PerformanceLevel *level)
 {
 	const struct vega10_power_state *ps;
-	struct vega10_hwmgr *data;
 	uint32_t i;
 
 	if (level == NULL || hwmgr == NULL || state == NULL)
 		return -EINVAL;
 
-	data = hwmgr->backend;
 	ps = cast_const_phw_vega10_power_state(state);
 
 	i = index > ps->performance_level_count - 1 ?
-- 
2.20.1

