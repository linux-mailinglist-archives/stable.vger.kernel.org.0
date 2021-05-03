Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD42371BBA
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhECQry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231636AbhECQp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BFD5615FF;
        Mon,  3 May 2021 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059962;
        bh=Qz5Vk2Lrm8UtrZT+Y8M+F8gOAo823C+dZKCArcdc4Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwYZcMWu8kZRZC1c3b1dPgJjeOxkaCHH5beHtpktARIhEbz3Dukk1hHjYhxfrE2d8
         JQ2xkAUU9DGJgba9xvVCo4lxVo7AEz18Z2zd1eAeyd3rJVbYERsDqffotOQlxN980R
         EDGnAU19ImC2QcXOtM+fI5I9WUirtfA+8XelBLtgX45bxBO3axhR76/OMGbRYk44B2
         JxWraU/WlbOzYr7FyD3PhgeykI4AmT6gndBx/hdb8AUG3/8ZyOQcrep6tK9oSP7TFe
         xaOMBvVGV5kVohele2JYhUp2SOm+tmuGARLpIbIOQsANekM50fZAebJlQZLwc6KanZ
         og6iUuXujYPsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 035/100] drm/amd/pm: fix workload mismatch on vega10
Date:   Mon,  3 May 2021 12:37:24 -0400
Message-Id: <20210503163829.2852775-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 0979d43259e13846d86ba17e451e17fec185d240 ]

Workload number mapped to the correct one.
This issue is only on vega10.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index ed4eafc744d3..132c269c7c89 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5159,7 +5159,7 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 
 out:
 	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
-						1 << power_profile_mode,
+						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
 						NULL);
 	hwmgr->power_profile_mode = power_profile_mode;
 
-- 
2.30.2

