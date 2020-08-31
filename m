Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825E5257D5E
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgHaPgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgHaPad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 801CB21527;
        Mon, 31 Aug 2020 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887833;
        bh=eDLK48bT73nERhUd4Rq9S2uiOR78bsJN6ZeA5PmgfgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmgoYRkPwwYRAvvTUCCwnUhZaBj2mRFLJOJqSL8Q5veK/IPo3xgnEliuIhutcOxMC
         dh9WtKd8tmgWOtAylDCmrQ97KKB5+dwpIaVbEPsx4IyTQ+y+qxjrb2nMHPz5iJB96U
         1fU+8LBd17VN5rmnp+BQDtebKOTzP+yUTZvXJ8pE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>, Hersen Wu <hersenxs.wu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 39/42] drm/amd/display: Retry AUX write when fail occurs
Date:   Mon, 31 Aug 2020 11:29:31 -0400
Message-Id: <20200831152934.1023912-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit ef67d792a2fc578319399f605fbec2f99ecc06ea ]

[Why]
In dm_dp_aux_transfer() now, we forget to handle AUX_WR fail cases. We
suppose every write wil get done successfully and hence some AUX
commands might not sent out indeed.

[How]
Check if AUX_WR success. If not, retry it.

Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Hersen Wu <hersenxs.wu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index e5ecc5affa1eb..5098fc98cc255 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -67,7 +67,7 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
-	if (payload.write)
+	if (payload.write && result >= 0)
 		result = msg->size;
 
 	if (result < 0)
-- 
2.25.1

