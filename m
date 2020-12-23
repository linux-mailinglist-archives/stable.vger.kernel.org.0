Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A82E172E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgLWDHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbgLWCSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45DC222257;
        Wed, 23 Dec 2020 02:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689877;
        bh=nN9Ek+XfS7t86dlUxeOWMAuYnxTfcRem9IKOOOBXP6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b16gscDBFh4+Z1vIiE9g2I3Z5kV02iSbHzCMh08lz9F+PT3R2bjMEJbS/mMP9S4Un
         e2gJ0gUOffcKWW5IVhYjo2iZLQzTCCqZjWfH/reKUKsOL8qFl7zHIaIRguQ5q3Ndm4
         9E1K9P/m7gEyAE7g6X0U808xsx/i7oTMGJF8a0iPVSWPDZn2poHWFkL4UNTjCxN0k3
         eciSA/OfTKJghDttYBTyvyMLWYW4vwtt8QhdhfMl6/BlWmrD0ONBjxWWfMpp1RCJU8
         MPom+0VVH6yza4vnwxPkTJodaafuWKCihnNcMUySEiYisWfLC5d22RiNlVXSd6jMmS
         8FCM3nVMNt8/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bokun Zhang <Bokun.Zhang@amd.com>, Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 068/217] drm/amd/amdgpu: Fix incorrect logic to increment VCN doorbell index
Date:   Tue, 22 Dec 2020 21:13:57 -0500
Message-Id: <20201223021626.2790791-68-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bokun Zhang <Bokun.Zhang@amd.com>

[ Upstream commit 25a35065c066496935217748b1662a7fcf26ed58 ]

- The original logic uses a counter based index assignment,
  which is incorrect if we only assign VCN1 to this VF but no VCN0

  The doorbell index is absolute, so we can calculate it by
  using index variable i and j

Signed-off-by: Bokun Zhang <Bokun.Zhang@amd.com>
Reviewed-by: Monk Liu <monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index b5f8f3d731cb0..8ecdddf33e18e 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -155,6 +155,13 @@ static int vcn_v3_0_sw_init(void *handle)
 	if (r)
 		return r;
 
+	/*
+	 * Note: doorbell assignment is fixed for SRIOV multiple VCN engines
+	 * Formula:
+	 *   vcn_db_base  = adev->doorbell_index.vcn.vcn_ring0_1 << 1;
+	 *   dec_ring_i   = vcn_db_base + i * (adev->vcn.num_enc_rings + 1)
+	 *   enc_ring_i,j = vcn_db_base + i * (adev->vcn.num_enc_rings + 1) + 1 + j
+	 */
 	if (amdgpu_sriov_vf(adev)) {
 		vcn_doorbell_index = adev->doorbell_index.vcn.vcn_ring0_1;
 		/* get DWORD offset */
@@ -192,9 +199,7 @@ static int vcn_v3_0_sw_init(void *handle)
 		ring = &adev->vcn.inst[i].ring_dec;
 		ring->use_doorbell = true;
 		if (amdgpu_sriov_vf(adev)) {
-			ring->doorbell_index = vcn_doorbell_index;
-			/* NOTE: increment so next VCN engine use next DOORBELL DWORD */
-			vcn_doorbell_index++;
+			ring->doorbell_index = vcn_doorbell_index + i * (adev->vcn.num_enc_rings + 1);
 		} else {
 			ring->doorbell_index = (adev->doorbell_index.vcn.vcn_ring0_1 << 1) + 8 * i;
 		}
@@ -216,9 +221,7 @@ static int vcn_v3_0_sw_init(void *handle)
 			ring = &adev->vcn.inst[i].ring_enc[j];
 			ring->use_doorbell = true;
 			if (amdgpu_sriov_vf(adev)) {
-				ring->doorbell_index = vcn_doorbell_index;
-				/* NOTE: increment so next VCN engine use next DOORBELL DWORD */
-				vcn_doorbell_index++;
+				ring->doorbell_index = vcn_doorbell_index + i * (adev->vcn.num_enc_rings + 1) + 1 + j;
 			} else {
 				ring->doorbell_index = (adev->doorbell_index.vcn.vcn_ring0_1 << 1) + 2 + j + 8 * i;
 			}
-- 
2.27.0

