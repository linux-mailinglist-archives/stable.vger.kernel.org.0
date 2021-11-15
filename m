Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6A3452375
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352014AbhKPB0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243364AbhKOTB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C686334E;
        Mon, 15 Nov 2021 18:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000076;
        bh=ezAeIT62f/tVpCMZWeZOT3sGS3hN5GhHS8/eBchGXaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoS9OYbAnr74LklAzBfzA0Qng9OMDPziYcdjbypss7BGkE71r80ybajZn5MIz8rLG
         /VEr3PGMijX4BLrCBXthWyiVC2W6NtNlJCyccvYZyJG9mSndR1eihJZR0cGzJYSgZY
         vT7CT5uF7YESFjp5aTemMDg0lopyzBDFLBaJdiJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 527/849] drm/amdgpu/gmc6: fix DMA mask from 44 to 40 bits
Date:   Mon, 15 Nov 2021 18:00:10 +0100
Message-Id: <20211115165438.098692979@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 0e81e03e9b498..0fe714f54cca9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c
@@ -841,12 +841,12 @@ static int gmc_v6_0_sw_init(void *handle)
 
 	adev->gmc.mc_mask = 0xffffffffffULL;
 
-	r = dma_set_mask_and_coherent(adev->dev, DMA_BIT_MASK(44));
+	r = dma_set_mask_and_coherent(adev->dev, DMA_BIT_MASK(40));
 	if (r) {
 		dev_warn(adev->dev, "No suitable DMA available.\n");
 		return r;
 	}
-	adev->need_swiotlb = drm_need_swiotlb(44);
+	adev->need_swiotlb = drm_need_swiotlb(40);
 
 	r = gmc_v6_0_init_microcode(adev);
 	if (r) {
-- 
2.33.0



