Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDCE450BFA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhKORcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237887AbhKORan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:30:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D238632A5;
        Mon, 15 Nov 2021 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996826;
        bh=jSg8kg2xyFEf8knm40qiNJa/BZT06dR9sC5causThuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNUCyLrMrMrID6aCyRMdvp43UFkybO2lMwB0y5oX2STrhYRB7orA1d70hpMsqB58e
         g2LV4NfUFMpnzfSO0JzB1qnh8q/5IE6exKOIJA266JKQYF8rbKh3TsVPwC57EnvdgN
         V78sT+1pFhNDvXTr1Btbad5mu17bGsdhlH1WGmlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/355] drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits
Date:   Mon, 15 Nov 2021 18:02:52 +0100
Message-Id: <20211115165321.759282068@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 403475be6d8b122c3e6b8a47e075926d7299e5ef ]

The DMA mask on SI parts is 40 bits not 44.  Copy
paste typo.

Fixes: 244511f386ccb9 ("drm/amdgpu: simplify and cleanup setting the dma mask")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1762
Acked-by: Christian König <christian.koenig@amd.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c
index 9fb1765e92d15..e9f5de35f7953 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c
@@ -863,12 +863,12 @@ static int gmc_v6_0_sw_init(void *handle)
 
 	adev->gmc.mc_mask = 0xffffffffffULL;
 
-	r = dma_set_mask_and_coherent(adev->dev, DMA_BIT_MASK(44));
+	r = dma_set_mask_and_coherent(adev->dev, DMA_BIT_MASK(40));
 	if (r) {
 		dev_warn(adev->dev, "amdgpu: No suitable DMA available.\n");
 		return r;
 	}
-	adev->need_swiotlb = drm_need_swiotlb(44);
+	adev->need_swiotlb = drm_need_swiotlb(40);
 
 	r = gmc_v6_0_init_microcode(adev);
 	if (r) {
-- 
2.33.0



