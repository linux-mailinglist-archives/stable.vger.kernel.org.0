Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82437D27F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350097AbhELSKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352668AbhELSD5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E0761438;
        Wed, 12 May 2021 18:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842568;
        bh=PsHQLOY/QTK6HaD3VMkzs/rCtqMkX/d49yP5Jq0xUN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2fjPB0dbAikbnzfdhhFBGq8byDCJKec2K08F5rpiu+SlqhaBXgW8W55aJiQuW9G5
         bcVWG2tBQ36m+HLuKWlSDFOaYIVKk3I/vBuPsT5BrEqncDEjUQrPjqclURHU+iZVnj
         lTWjVTBYhlWeVjuYtXR5FW6nDXigz5oP/YL7YYzU+ts+iT5HsoHT/UzgxhP3lsM0pv
         3YjKPTVeD52TFuQU+UWhl//OTxL+aOC/0yTrGHbFCS+t3e/wrMZglv7Sj4MK6rZN92
         U0km0JIkNr5r2SfWEyZmU4QC3xvmLjq2BMmXVMQz/ZTXb/NH12hkg0wq75fVvJ2t3M
         ETfx7zVvlzKJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Darren Powell <darren.powell@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 25/35] amdgpu/pm: Prevent force of DCEFCLK on NAVI10 and SIENNA_CICHLID
Date:   Wed, 12 May 2021 14:01:55 -0400
Message-Id: <20210512180206.664536-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darren Powell <darren.powell@amd.com>

[ Upstream commit b117b3964f38a988cb79825950dbd607c02237f3 ]

Writing to dcefclk causes the gpu to become unresponsive, and requires a reboot.
Patch ignores a .force_clk_levels(SMU_DCEFCLK) call and issues an
info message.

Signed-off-by: Darren Powell <darren.powell@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         | 5 ++++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index cd7efa923195..ab702e1cd9f0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -1110,7 +1110,6 @@ static int navi10_force_clk_levels(struct smu_context *smu,
 	case SMU_SOCCLK:
 	case SMU_MCLK:
 	case SMU_UCLK:
-	case SMU_DCEFCLK:
 	case SMU_FCLK:
 		/* There is only 2 levels for fine grained DPM */
 		if (navi10_is_support_fine_grained_dpm(smu, clk_type)) {
@@ -1130,6 +1129,10 @@ static int navi10_force_clk_levels(struct smu_context *smu,
 		if (ret)
 			return size;
 		break;
+	case SMU_DCEFCLK:
+		dev_info(smu->adev->dev,"Setting DCEFCLK min/max dpm level is not supported!\n");
+		break;
+
 	default:
 		break;
 	}
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index d68d3dfee51d..aa231336d9f0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1025,7 +1025,6 @@ static int sienna_cichlid_force_clk_levels(struct smu_context *smu,
 	case SMU_SOCCLK:
 	case SMU_MCLK:
 	case SMU_UCLK:
-	case SMU_DCEFCLK:
 	case SMU_FCLK:
 		/* There is only 2 levels for fine grained DPM */
 		if (sienna_cichlid_is_support_fine_grained_dpm(smu, clk_type)) {
@@ -1045,6 +1044,9 @@ static int sienna_cichlid_force_clk_levels(struct smu_context *smu,
 		if (ret)
 			goto forec_level_out;
 		break;
+	case SMU_DCEFCLK:
+		dev_info(smu->adev->dev,"Setting DCEFCLK min/max dpm level is not supported!\n");
+		break;
 	default:
 		break;
 	}
-- 
2.30.2

