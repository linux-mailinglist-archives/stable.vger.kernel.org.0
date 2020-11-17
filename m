Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86EBA2B632A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbgKQNfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732483AbgKQNfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C642466D;
        Tue, 17 Nov 2020 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620131;
        bh=AP6pVVw5RwvLGC+PQA4oknoecm72fp98lcftAkqVifE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEvJVFGraRe3jZhpH5gCG/xhRjDb7qEvmvjiSrrhcRSZa2dZax3WTseVXfu1EYiGl
         cQD9jOMw3QESRFCbOF9t6K0UtyfaGOHxY1tvXv+GA7UTStEivme7fagByGgYB/q0F0
         FifglMbHcoZXiztzrv/P3Z55jSXyX0+DYqb3uRF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabadhran Gopalakrishnan <veerabadhran.gopalakrishnan@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 117/255] amd/amdgpu: Disable VCN DPG mode for Picasso
Date:   Tue, 17 Nov 2020 14:04:17 +0100
Message-Id: <20201117122144.635014515@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



