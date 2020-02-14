Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68ABF15DC63
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgBNPws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731061AbgBNPwr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EBAA222C4;
        Fri, 14 Feb 2020 15:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695567;
        bh=vMAIxQCEcBteBvTjRTi8zaQHQRbcimfsWflvIWcKtRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vDL04vJppJ0l+GABfBMUIv6b6NtLE2FsRO9U0wMUGo9gTfxkZId1yqNmCYbYSt1SA
         VIicDTk8+PyuIvvX7uVIohyZIK4hneJaJBgaHMVlZ2g5XhvY4pjj4Caq2+W/L5H8wy
         GLBvvxFABO79+xCE/Aw0g/zxdwG+PWAZDME+Xoho=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thong Thai <thong.thai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 179/542] Revert "drm/amdgpu: enable VCN DPG on Raven and Raven2"
Date:   Fri, 14 Feb 2020 10:42:51 -0500
Message-Id: <20200214154854.6746-179-sashal@kernel.org>
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

From: Thong Thai <thong.thai@amd.com>

[ Upstream commit d515959125f24767d02e82587a11e444eeba0e7b ]

This reverts commit a4840d91c984f93b2acdcd44441d624bbc1af0d2.

Reverting due to power efficiency issues seen on Raven 1 and 2
when DPG mode is enabled.

Signed-off-by: Thong Thai <thong.thai@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 8e1640bc07aff..04ea7cd692955 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1145,9 +1145,7 @@ static int soc15_common_early_init(void *handle)
 				AMD_CG_SUPPORT_SDMA_LS |
 				AMD_CG_SUPPORT_VCN_MGCG;
 
-			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
-				AMD_PG_SUPPORT_VCN |
-				AMD_PG_SUPPORT_VCN_DPG;
+			adev->pg_flags = AMD_PG_SUPPORT_SDMA | AMD_PG_SUPPORT_VCN;
 		} else if (adev->pdev->device == 0x15d8) {
 			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |
 				AMD_CG_SUPPORT_GFX_MGLS |
@@ -1190,9 +1188,7 @@ static int soc15_common_early_init(void *handle)
 				AMD_CG_SUPPORT_SDMA_LS |
 				AMD_CG_SUPPORT_VCN_MGCG;
 
-			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
-				AMD_PG_SUPPORT_VCN |
-				AMD_PG_SUPPORT_VCN_DPG;
+			adev->pg_flags = AMD_PG_SUPPORT_SDMA | AMD_PG_SUPPORT_VCN;
 		}
 		break;
 	case CHIP_ARCTURUS:
-- 
2.20.1

