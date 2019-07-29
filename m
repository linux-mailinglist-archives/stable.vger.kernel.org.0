Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD79C79528
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbfG2TjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388677AbfG2TjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:39:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C91C2054F;
        Mon, 29 Jul 2019 19:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429160;
        bh=N/uag7XfyCcol3HpB72xx8NfNWrc1Lx666eOgPtI1LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STqIH/uVnk1Q7nyDe/ExAfGIsbI2dBM1aYztucoRLmW4WjEz4qrV7cB/EN63Kwfs1
         IF2blVak5pO+Htm8lbnPkpb6K0RcLdUTxaEor9sKUPLvj5pB4Qzjar1Ebfo7UY5Chm
         RlxETNcFWGKMT4syLuqvPtLLHCHaq/llryE8AMdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emily Deng <Emily.Deng@amd.com>,
        Tiecheng Zhou <Tiecheng.Zhou@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/113] drm/amdgpu/sriov: Need to initialize the HDP_NONSURFACE_BAStE
Date:   Mon, 29 Jul 2019 21:21:38 +0200
Message-Id: <20190729190658.478971867@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fe2b5323d2c3cedaa3bf943dc7a0d233c853c914 ]

it requires to initialize HDP_NONSURFACE_BASE, so as to avoid
using the value left by a previous VM under sriov scenario.

v2: it should not hurt baremetal, generalize it for both sriov
and baremetal

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Tiecheng Zhou <Tiecheng.Zhou@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index 72f8018fa2a8..ede27dab675f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1037,6 +1037,9 @@ static int gmc_v9_0_gart_enable(struct amdgpu_device *adev)
 	tmp = RREG32_SOC15(HDP, 0, mmHDP_HOST_PATH_CNTL);
 	WREG32_SOC15(HDP, 0, mmHDP_HOST_PATH_CNTL, tmp);
 
+	WREG32_SOC15(HDP, 0, mmHDP_NONSURFACE_BASE, (adev->gmc.vram_start >> 8));
+	WREG32_SOC15(HDP, 0, mmHDP_NONSURFACE_BASE_HI, (adev->gmc.vram_start >> 40));
+
 	/* After HDP is initialized, flush HDP.*/
 	adev->nbio_funcs->hdp_flush(adev, NULL);
 
-- 
2.20.1



