Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0834E2ACDC0
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgKJEEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732588AbgKJDyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4FA2080A;
        Tue, 10 Nov 2020 03:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980460;
        bh=AP6pVVw5RwvLGC+PQA4oknoecm72fp98lcftAkqVifE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu6lvdci8k/+N2xDibmjGbNGTVBXcW52pOqgsDjQCu+4VcCjlJ4Q3lzTS9qXVu4Jw
         iqQS9vmkc9eLXRbgN4CE9zHH0T4Gug1jy48OZJPQOuYQwTMP2L+MCcy4EgUpeSTcr3
         Hm6G01nBYxIpd2p5Idpw3dxgCRuo+mUI6cY0Jzio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 43/55] amd/amdgpu: Disable VCN DPG mode for Picasso
Date:   Mon,  9 Nov 2020 22:53:06 -0500
Message-Id: <20201110035318.423757-43-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>

[ Upstream commit c6d2b0fbb893d5c7dda405aa0e7bcbecf1c75f98 ]

Concurrent operation of VCN and JPEG decoder in DPG mode is
causing ring timeout due to power state.

Signed-off-by: Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index c28ebf41530aa..254ab2ada70a0 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1220,8 +1220,7 @@ static int soc15_common_early_init(void *handle)
 
 			adev->pg_flags = AMD_PG_SUPPORT_SDMA |
 				AMD_PG_SUPPORT_MMHUB |
-				AMD_PG_SUPPORT_VCN |
-				AMD_PG_SUPPORT_VCN_DPG;
+				AMD_PG_SUPPORT_VCN;
 		} else {
 			adev->cg_flags = AMD_CG_SUPPORT_GFX_MGCG |
 				AMD_CG_SUPPORT_GFX_MGLS |
-- 
2.27.0

