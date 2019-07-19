Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6913E6DE2B
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGSEID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbfGSEID (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:08:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3763021849;
        Fri, 19 Jul 2019 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509282;
        bh=ryHAMkpvySFnwAvOSwZoHnsoul6TqjxB1N4HpedNgZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRDIBXA6rAmGzcQiigrDGOsFRprK68ds6jc+CAqjpgA18vkkKqY514vsLwiCgtqq3
         G9vm2R0VuK0u5+z/fwJBmfgTLKszin1fdPXJcuU0J6Xdw/wAP/0ZOC7fiLUpqOkEMJ
         CFoya/avW0X1ztD9uHCbFzn62SYhf19/ei+vB2Xw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tiecheng Zhou <Tiecheng.Zhou@amd.com>,
        Emily Deng <Emily.Deng@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 011/101] drm/amdgpu/sriov: Need to initialize the HDP_NONSURFACE_BAStE
Date:   Fri, 19 Jul 2019 00:06:02 -0400
Message-Id: <20190719040732.17285-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiecheng Zhou <Tiecheng.Zhou@amd.com>

[ Upstream commit fe2b5323d2c3cedaa3bf943dc7a0d233c853c914 ]

it requires to initialize HDP_NONSURFACE_BASE, so as to avoid
using the value left by a previous VM under sriov scenario.

v2: it should not hurt baremetal, generalize it for both sriov
and baremetal

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Tiecheng Zhou <Tiecheng.Zhou@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 72f8018fa2a8..ede27dab675f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1037,6 +1037,9 @@ static int gmc_v9_0_gart_enable(struct amdgpu_device *adev)
 	tmp = RREG32_SOC15(HDP, 0, mmHDP_HOST_PATH_CNTL);
 	WREG32_SOC15(HDP, 0, mmHDP_HOST_PATH_CNTL, tmp);
 
+	WREG32_SOC15(HDP, 0, mmHDP_NONSURFACE_BASE, (adev->gmc.vram_start >> 8));
+	WREG32_SOC15(HDP, 0, mmHDP_NONSURFACE_BASE_HI, (adev->gmc.vram_start >> 40));
+
 	/* After HDP is initialized, flush HDP.*/
 	adev->nbio_funcs->hdp_flush(adev, NULL);
 
-- 
2.20.1

