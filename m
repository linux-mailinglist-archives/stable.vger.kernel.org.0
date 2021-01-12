Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77572F3119
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403876AbhALM5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403846AbhALM5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B22D22333B;
        Tue, 12 Jan 2021 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456193;
        bh=IO07lAPmVIHL6U9iLfamBIZXzOpk67bl0Wv3eCpJyL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDio7TW/YhbSgh15W+Ct9JQQeZjMT2tk8f4xosGw7S3JGGv3RJkM9GFCPHn/QrU7O
         4n4WMKf+d44A4rhX48V6PFetMUX0OThQkNLfxezAFDQMWKM2KqpmoqqKA6wyihODSu
         m6OdbHgeWrt6Pi+Q/9ZKgL8z6MVTgOJKxDBOMO9GIIR+NO6mVT8g4iryq9pkL9Il5c
         0J1ZnW7YGbukA+j9TWzc27odOSU9COYkTdmVpmGY/0PGOjY3lrUqdKTp2SEi5E3SKb
         tcVmRgDCmErCx/jjwEqAxzAuiAV7bpB7u+XLqo2OgMmAmIVyDu9QKA+heJM4uI9XSF
         HvkDV6hCIotpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiawei Gu <Jiawei.Gu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 44/51] drm/amdgpu: fix potential memory leak during navi12 deinitialization
Date:   Tue, 12 Jan 2021 07:55:26 -0500
Message-Id: <20210112125534.70280-44-sashal@kernel.org>
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

From: Jiawei Gu <Jiawei.Gu@amd.com>

[ Upstream commit e6d5c64efaa34aae3815a9afeb1314a976142e83 ]

Navi12 HDCP & DTM deinitialization needs continue to free bo if already
created though initialized flag is not set.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiawei Gu <Jiawei.Gu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index a6dbe4b83533f..2f47f81a74a57 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1283,8 +1283,12 @@ static int psp_hdcp_terminate(struct psp_context *psp)
 	if (amdgpu_sriov_vf(psp->adev))
 		return 0;
 
-	if (!psp->hdcp_context.hdcp_initialized)
-		return 0;
+	if (!psp->hdcp_context.hdcp_initialized) {
+		if (psp->hdcp_context.hdcp_shared_buf)
+			goto out;
+		else
+			return 0;
+	}
 
 	ret = psp_hdcp_unload(psp);
 	if (ret)
@@ -1292,6 +1296,7 @@ static int psp_hdcp_terminate(struct psp_context *psp)
 
 	psp->hdcp_context.hdcp_initialized = false;
 
+out:
 	/* free hdcp shared memory */
 	amdgpu_bo_free_kernel(&psp->hdcp_context.hdcp_shared_bo,
 			      &psp->hdcp_context.hdcp_shared_mc_addr,
@@ -1430,8 +1435,12 @@ static int psp_dtm_terminate(struct psp_context *psp)
 	if (amdgpu_sriov_vf(psp->adev))
 		return 0;
 
-	if (!psp->dtm_context.dtm_initialized)
-		return 0;
+	if (!psp->dtm_context.dtm_initialized) {
+		if (psp->dtm_context.dtm_shared_buf)
+			goto out;
+		else
+			return 0;
+	}
 
 	ret = psp_dtm_unload(psp);
 	if (ret)
@@ -1439,6 +1448,7 @@ static int psp_dtm_terminate(struct psp_context *psp)
 
 	psp->dtm_context.dtm_initialized = false;
 
+out:
 	/* free hdcp shared memory */
 	amdgpu_bo_free_kernel(&psp->dtm_context.dtm_shared_bo,
 			      &psp->dtm_context.dtm_shared_mc_addr,
-- 
2.27.0

