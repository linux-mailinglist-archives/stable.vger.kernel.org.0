Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0071A5B66
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgDKXt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgDKXEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8315214D8;
        Sat, 11 Apr 2020 23:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646256;
        bh=b9PSEA+YG/1WY21aDwSoSP7Lj/mwh9DIxAkoaspyNac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVIYHio23RN4BzYBpS9VtpxCDtuSlMVnIDGUz1V2B8PouGi3q4w2ZmdY2+CM361RB
         +VRyIHFPRiQvsUE6j0gXo/of6n4w7bQCLiXdC2B3iVoBVOBFywdwJ3tR98SiFvPu3/
         dGqCBNl5tw4soaBdCo+l1unDZ/Eq64nXNjhcdgsg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hawking Zhang <Hawking.Zhang@amd.com>, Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 023/149] drm/amdgpu: check GFX RAS capability before reset counters
Date:   Sat, 11 Apr 2020 19:01:40 -0400
Message-Id: <20200411230347.22371-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 06dcd7eb83ee65382305ce48686e3dadaad42088 ]

disallow the logical to be enabled on platforms that
don't support gfx ras at this stage, like sriov skus,
dgpu with legacy ras.etc

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Monk Liu <monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 3 +++
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 889154a78c4a8..beba9c596c493 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -6326,6 +6326,9 @@ static void gfx_v9_0_clear_ras_edc_counter(struct amdgpu_device *adev)
 {
 	int i, j, k;
 
+	if (!amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__GFX))
+		return;
+
 	/* read back registers to clear the counters */
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < ARRAY_SIZE(gfx_v9_0_edc_counter_regs); i++) {
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4.c
index f099f13d7f1e9..9955532345ec0 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4.c
@@ -897,6 +897,9 @@ void gfx_v9_4_clear_ras_edc_counter(struct amdgpu_device *adev)
 {
 	int i, j, k;
 
+	if (!amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__GFX))
+		return;
+
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < ARRAY_SIZE(gfx_v9_4_edc_counter_regs); i++) {
 		for (j = 0; j < gfx_v9_4_edc_counter_regs[i].se_num; j++) {
-- 
2.20.1

