Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739152FA2F6
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404772AbhARO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390235AbhARLos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B14522D6E;
        Mon, 18 Jan 2021 11:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970229;
        bh=IO07lAPmVIHL6U9iLfamBIZXzOpk67bl0Wv3eCpJyL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKTuot6k/sEHFBrsWq0/lY6iVCIi4n1ZTdAGheoJXZMhb9bWhQeQ18K4m67gagHqR
         B5uonpUGxFXFGKN3OHCV4Et8Nizq59lhQWmb52whaE8K249QyxSS+0sNo5u7m0U0jk
         eDoZgnvu4r634tPbLLop6CIcnpSbKK0ZZPnvdRJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiawei Gu <Jiawei.Gu@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/152] drm/amdgpu: fix potential memory leak during navi12 deinitialization
Date:   Mon, 18 Jan 2021 12:34:26 +0100
Message-Id: <20210118113357.116223923@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



