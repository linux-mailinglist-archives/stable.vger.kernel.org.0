Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C543BCFB0
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhGFLbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233300AbhGFLZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE1C661D6C;
        Tue,  6 Jul 2021 11:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570380;
        bh=P923ERhE2scix0Bmb5FE8KAJFqLGlHL+1sVq8aBO464=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OR1874jyFm7FeT7bRMRXVEZBeZoWS0lqkYy7RkWmGqbQpNAMmS37HTnIDjLxVTZ3z
         IMhf3hiyj43OYYhx4v+uIgY/qofaeGgWJotIlMhZfHcOorpXZUqsxChNDvC90+1Zwc
         3Xy6mU2HJHvx+ZbGfTRhCBZb2/BewUMNg+eCllRYzMg030IO1OebZqvM/RG9AIkT2f
         iRFXEPqRW4Uo6jU9+lyWs1GOGXTlcu5dknlpowzrlhTXNOBIWYh8Aw5eFAm/xz0CQN
         RxraxNankSdqxMQoyX0GBNsqe6QEfdyjk0MRy3ZEJirrgfzCuuBkLYYQ4JuSc3tOxM
         BoVD3JmOVJ1gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Wang <kevin1.wang@amd.com>,
        "Stanley . Yang" <Stanley.Yang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 055/160] drm/amdgpu: fix sdma firmware version error in sriov
Date:   Tue,  6 Jul 2021 07:16:41 -0400
Message-Id: <20210706111827.2060499-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

[ Upstream commit 2b8f731849800e3948763ccaff31cceac526789b ]

Re-adjust the function return order to avoid empty sdma version in the
sriov environment. (read amdgpu_firmware_info)

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index 32c6aa03d267..f884d43d4ff0 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -145,9 +145,6 @@ static int sdma_v5_2_init_microcode(struct amdgpu_device *adev)
 	struct amdgpu_firmware_info *info = NULL;
 	const struct common_firmware_header *header = NULL;
 
-	if (amdgpu_sriov_vf(adev) && (adev->asic_type == CHIP_SIENNA_CICHLID))
-		return 0;
-
 	DRM_DEBUG("\n");
 
 	switch (adev->asic_type) {
@@ -182,6 +179,9 @@ static int sdma_v5_2_init_microcode(struct amdgpu_device *adev)
 		       (void *)&adev->sdma.instance[0],
 		       sizeof(struct amdgpu_sdma_instance));
 
+	if (amdgpu_sriov_vf(adev) && (adev->asic_type == CHIP_SIENNA_CICHLID))
+		return 0;
+
 	DRM_DEBUG("psp_load == '%s'\n",
 		  adev->firmware.load_type == AMDGPU_FW_LOAD_PSP ? "true" : "false");
 
-- 
2.30.2

