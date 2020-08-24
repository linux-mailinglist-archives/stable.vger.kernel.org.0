Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BB02504D5
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgHXRIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgHXQiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B8D2310E;
        Mon, 24 Aug 2020 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287061;
        bh=Td21fzMvy0zTxw1H3Ikwhc/hSA5KxIOZs6Zlok9kupw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAQLqw1iToSdIxY/8T8LJbUoi3BLyexP/Q7b+yK7+WZgcfUDk7xY7gN2eZGRDK3kz
         PaYl13C5dp7Pv3zhKRmODxr/88YH23GnQBRlQbbe7r1bqkPlpfvzAVJDObp7pC2snj
         BExH0iqeFOYdSO4thy3bAVEAmZt+eX+4hEYCfzeE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 48/54] drm/amdkfd: fix the wrong sdma instance query for renoir
Date:   Mon, 24 Aug 2020 12:36:27 -0400
Message-Id: <20200824163634.606093-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

[ Upstream commit 34174b89bfa495bed9cddcc504fb38feca90fab7 ]

Renoir only has one sdma instance, it will get failed once query the
sdma1 registers. So use switch-case instead of static register array.

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c | 31 +++++++++++++------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
index df841c2ac5e74..cdcf3b8e914a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v9.c
@@ -197,19 +197,32 @@ static uint32_t get_sdma_rlc_reg_offset(struct amdgpu_device *adev,
 				unsigned int engine_id,
 				unsigned int queue_id)
 {
-	uint32_t sdma_engine_reg_base[2] = {
-		SOC15_REG_OFFSET(SDMA0, 0,
-				 mmSDMA0_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL,
-		SOC15_REG_OFFSET(SDMA1, 0,
-				 mmSDMA1_RLC0_RB_CNTL) - mmSDMA1_RLC0_RB_CNTL
-	};
-	uint32_t retval = sdma_engine_reg_base[engine_id]
+	uint32_t sdma_engine_reg_base = 0;
+	uint32_t sdma_rlc_reg_offset;
+
+	switch (engine_id) {
+	default:
+		dev_warn(adev->dev,
+			 "Invalid sdma engine id (%d), using engine id 0\n",
+			 engine_id);
+		fallthrough;
+	case 0:
+		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA0, 0,
+				mmSDMA0_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL;
+		break;
+	case 1:
+		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA1, 0,
+				mmSDMA1_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL;
+		break;
+	}
+
+	sdma_rlc_reg_offset = sdma_engine_reg_base
 		+ queue_id * (mmSDMA0_RLC1_RB_CNTL - mmSDMA0_RLC0_RB_CNTL);
 
 	pr_debug("RLC register offset for SDMA%d RLC%d: 0x%x\n", engine_id,
-			queue_id, retval);
+		 queue_id, sdma_rlc_reg_offset);
 
-	return retval;
+	return sdma_rlc_reg_offset;
 }
 
 static inline struct v9_mqd *get_mqd(void *mqd)
-- 
2.25.1

