Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E971257D39
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgHaPfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgHaPbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDFB32083E;
        Mon, 31 Aug 2020 15:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887872;
        bh=yQDsG4Dukt9Zl7PbICuxCz2UQrfZce1uCsChE6idIWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qugv0lKSc96wj3kfmUp4a4IReJDoj9u8bmRU/PRnxG//3ZMGGmskVEihr9MJJfsyD
         OetDcDkmj8eWcGB69mOWXjpDAHX3LAm4phgr7ZtjDecT7PLgyNoETza389E1HAdQA+
         4ppPVQ2qn3UAceCAy/I560xm62BhS3iOEqMHK/jI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wayne Lin <Wayne.Lin@amd.com>, Hersen Wu <hersenxs.wu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 20/23] drm/amd/display: Retry AUX write when fail occurs
Date:   Mon, 31 Aug 2020 11:30:36 -0400
Message-Id: <20200831153039.1024302-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153039.1024302-1-sashal@kernel.org>
References: <20200831153039.1024302-1-sashal@kernel.org>
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
index 28a6c7b2ef4bb..2f858507ca702 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -101,7 +101,7 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
-	if (payload.write)
+	if (payload.write && result >= 0)
 		result = msg->size;
 
 	if (result < 0)
-- 
2.25.1

