Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DAE5EA16E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbiIZKuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbiIZKtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01D557E3D;
        Mon, 26 Sep 2022 03:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C5EDB80835;
        Mon, 26 Sep 2022 10:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EA4C433D6;
        Mon, 26 Sep 2022 10:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188001;
        bh=nOF7kRm8jGivPH6YjcExgoVyFxqCAoJsNJIcRv3yxjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8Vgk8B6GnwXsmxq3xpLFrZkVmzqWhPYzT1fHu7M5RQ1fdoyeMFN/13ohBZp+0J5r
         tw8XTS+4AYtv9riyVBl9+qF2GMKvqqQ+65kTDvtKUKecDLBmWPYhZSQ9j64qZwCXwD
         oDN8rPiryBlzRwTIbAEsX/dVEaTnY5LEB3hUMcU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/141] drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega
Date:   Mon, 26 Sep 2022 12:10:27 +0200
Message-Id: <20220926100754.689443370@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit e3163bc8ffdfdb405e10530b140135b2ee487f89 ]

This mirrors what we do for other asics and this way we are
sure the sdma doorbell range is properly initialized.

There is a comment about the way doorbells on gfx9 work that
requires that they are initialized for other IPs before GFX
is initialized.  However, the statement says that it applies to
multimedia as well, but the VCN code currently initializes
doorbells after GFX and there are no known issues there.  In my
testing at least I don't see any problems on SDMA.

This is a prerequisite for fixing the Unsupported Request error
reported through AER during driver load.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216373

The error was unnoticed before and got visible because of the commit
referenced below. This doesn't fix anything in the commit below, rather
fixes the issue in amdgpu exposed by the commit. The reference is only
to associate this commit with below one so that both go together.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")

Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |  5 +++++
 drivers/gpu/drm/amd/amdgpu/soc15.c     | 25 -------------------------
 2 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 1f2e2460e121..a1a8e026b9fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1475,6 +1475,11 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
+			ring = &adev->sdma.instance[i].ring;
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				ring->use_doorbell, ring->doorbell_index,
+				adev->doorbell_index.sdma_doorbell_range);
+
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 7212b9900e0a..abd649285a22 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1332,25 +1332,6 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
-static void soc15_doorbell_range_init(struct amdgpu_device *adev)
-{
-	int i;
-	struct amdgpu_ring *ring;
-
-	/* sdma/ih doorbell range are programed by hypervisor */
-	if (!amdgpu_sriov_vf(adev)) {
-		for (i = 0; i < adev->sdma.num_instances; i++) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-		}
-
-		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
-						adev->irq.ih.doorbell_index);
-	}
-}
-
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1370,12 +1351,6 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
-	/* HW doorbell routing policy: doorbell writing not
-	 * in SDMA/IH/MM/ACV range will be routed to CP. So
-	 * we need to init SDMA/IH/MM/ACV doorbell range prior
-	 * to CP ip block init and ring test.
-	 */
-	soc15_doorbell_range_init(adev);
 
 	return 0;
 }
-- 
2.35.1



