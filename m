Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319912F311A
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403855AbhALM5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403844AbhALM5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3433B23339;
        Tue, 12 Jan 2021 12:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456192;
        bh=atM/We5CsFzw3dFfBXTIftb+fTP0t+mUCTgaENwNCyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEZZ8B2NN1srkM4m/lUuwASw+1abM0tKgK8x9j7n2s/M/ci8S3sQSLSpYAZtMVGE8
         MYDSEZ8kX4Sk6BLnSNss5sf7MVsRTFH2/Opm0Y5O3A7ZzP6owWV2mCsdgU80dJgVO0
         4ClJRWXFZtBjLiyAQpXzD9XZCrDpRfAdfkTlNcbsAfAGCG9PdCo9i4ag0xapfDi8b8
         yFB+01Al7mSIxFG770IkvT6qxhAw0lwyNSbxikPGC8FnrJv4wrBMMceFYZcL3XbfE2
         vIjdJc53op/Hkl+bB68JYLXtxvZcNnqmac+9icMS+G+eyqkF+RLpgLBSqBgmUqxAdS
         c6gLD19RwXmqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaojian Du <Xiaojian.Du@amd.com>, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 43/51] drm/amd/pm: fix the failure when change power profile for renoir
Date:   Tue, 12 Jan 2021 07:55:25 -0500
Message-Id: <20210112125534.70280-43-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojian Du <Xiaojian.Du@amd.com>

[ Upstream commit 44cb39e19a05ca711bcb6e776e0a4399223204a0 ]

This patch is to fix the failure when change power profile to
"profile_peak" for renoir.

Signed-off-by: Xiaojian Du <Xiaojian.Du@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c | 1 +
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
index 66c1026489bee..425c48e100e4f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -188,6 +188,7 @@ static int renoir_get_dpm_clk_limited(struct smu_context *smu, enum smu_clk_type
 			return -EINVAL;
 		*freq = clk_table->SocClocks[dpm_level].Freq;
 		break;
+	case SMU_UCLK:
 	case SMU_MCLK:
 		if (dpm_level >= NUM_FCLK_DPM_LEVELS)
 			return -EINVAL;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
index 660f403d5770c..7907c9e0b5dec 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c
@@ -222,6 +222,7 @@ int smu_v12_0_set_soft_freq_limited_range(struct smu_context *smu, enum smu_clk_
 	break;
 	case SMU_FCLK:
 	case SMU_MCLK:
+	case SMU_UCLK:
 		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetHardMinFclkByFreq, min, NULL);
 		if (ret)
 			return ret;
-- 
2.27.0

