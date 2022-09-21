Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09605C0233
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiIUPt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiIUPtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:49:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4379DB71;
        Wed, 21 Sep 2022 08:47:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E2B2B82DF4;
        Wed, 21 Sep 2022 15:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F22C433D7;
        Wed, 21 Sep 2022 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775261;
        bh=mydkNH3nKlmwcuJ7kkDzlu/pTI9/TP0+hAPsjtCuyKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0d17w9raxXdMcvNfOuIgSrKco7UiMEjO4EYIUpNB1nCfDkZ3HGFRSBPwUMw+BHf2o
         p4qEUcsCdgZk4S/owNo8i8byYVUix4rww4OcaOLYw13JW2pDrU2V4+ra3IkRwHxViI
         UlMtJixh6QWz+c6iQaaQPGKGB2EzycjzpQegqbK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 33/38] drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega
Date:   Wed, 21 Sep 2022 17:46:17 +0200
Message-Id: <20220921153647.321201114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit e3163bc8ffdfdb405e10530b140135b2ee487f89 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    5 +++++
 drivers/gpu/drm/amd/amdgpu/soc15.c     |   22 ----------------------
 2 files changed, 5 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1504,6 +1504,11 @@ static int sdma_v4_0_start(struct amdgpu
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
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1211,22 +1211,6 @@ static int soc15_common_sw_fini(void *ha
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
-	}
-}
-
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1246,12 +1230,6 @@ static int soc15_common_hw_init(void *ha
 
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


