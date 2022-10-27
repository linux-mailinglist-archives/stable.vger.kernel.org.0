Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDC860FDAE
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiJ0Q54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiJ0Q5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:57:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE65FB87A2
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DFBD623E8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AB9C433D6;
        Thu, 27 Oct 2022 16:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889869;
        bh=Fn6K1yuQ4gGmwxBNkFNPH1JYwC1bbUP8vnh7DbNFXwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V40zOKGNIP7WEnJ8CZkxK177KZoNwO97kPFzLUaOstR+CIRPowj3WPmbguSBolzsP
         VhWvR5RaH75xk6f9MEQv7gS/7ImyeAJa/b6PVHhthEjaflv61IwaXO7hPZkEycuG9J
         wZmfMoiPe/yXrFbqtyY/c/K5kkezj4eTQTXRgcvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        skhan@linuxfoundation.org
Subject: [PATCH 6.0 15/94] drm/amdgpu: fix sdma doorbell init ordering on APUs
Date:   Thu, 27 Oct 2022 18:54:17 +0200
Message-Id: <20221027165057.706007715@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 50b0e4d4da09fa501e722af886f97e60a4f820d6 upstream.

Commit 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
uncovered a bug in amdgpu that required a reordering of the driver
init sequence to avoid accessing a special register on the GPU
before it was properly set up leading to an PCI AER error.  This
reordering uncovered a different hw programming ordering dependency
in some APUs where the SDMA doorbells need to be programmed before
the GFX doorbells. To fix this, move the SDMA doorbell programming
back into the soc15 common code, but use the actual doorbell range
values directly rather than the values stored in the ring structure
since those will not be initialized at this point.

This is a partial revert, but with the doorbell assignment
fixed so the proper doorbell index is set before it's used.

Fixes: e3163bc8ffdfdb ("drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: skhan@linuxfoundation.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/soc15.c     |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1504,11 +1504,6 @@ static int sdma_v4_0_start(struct amdgpu
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1211,6 +1211,20 @@ static int soc15_common_sw_fini(void *ha
 	return 0;
 }
 
+static void soc15_sdma_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+
+	/* sdma doorbell range is programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				true, adev->doorbell_index.sdma_engine[i] << 1,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1230,6 +1244,13 @@ static int soc15_common_hw_init(void *ha
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA doorbell range prior
+	 * to CP ip block init and ring test.  IH already
+	 * happens before CP.
+	 */
+	soc15_sdma_doorbell_range_init(adev);
 
 	return 0;
 }


