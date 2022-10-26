Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7805560E417
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiJZPHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiJZPHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:07:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9D310B7BD
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:07:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31DBC61F5E
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDFAC433D6;
        Wed, 26 Oct 2022 15:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796828;
        bh=8SLv6uPo/xB1IDdCf8Jaf5N2lPORmz9qGbQQTHbMg6I=;
        h=Subject:To:Cc:From:Date:From;
        b=UtTyfdAddocEZfyqhN9X4Yt9L9efKp7f74fQ9NS302+FMQATWv0X2XGtgfnQ9kciB
         V8nskMyqLBVewop6qyUdcbd74kYONsqLqHy7Y+y6ybaac/Abop/TYyj1TbBxfbg8GE
         wgDZFsbZa5n8L9wMWPDr0iFlTtnoxgLE3fe3PG28=
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix sdma doorbell init ordering on APUs" failed to apply to 5.10-stable tree
To:     alexander.deucher@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:07:06 +0200
Message-ID: <1666796826227113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

50b0e4d4da09 ("drm/amdgpu: fix sdma doorbell init ordering on APUs")
59c43748c7c8 ("drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega")
db10109793bb ("drm/amdgpu: move nbio ih_doorbell_range() into ih code for vega")
b672cb1eee59 ("drm/amdgpu: enable retry fault wptr overflow")
bebd4c79a4eb ("drm/amdgpu: create vega20 ih blocks")
554bdbf6de74 ("drm/amdgpu: use cached ih rb control reg offsets for vega10")
21822b6a968d ("drm/amdgpu: switch to ih_enable_ring for vega10")
fd95e1b1049e ("drm/amdgpu: switch to ih_toggle_interrupts for vega10")
c73750322aaf ("drm/amdgpu: add helper to toggle ih ring interrupts for vega10")
ffa02126e0ef ("drm/amdgpu: add helper to enable an ih ring for vega10")
1ebb4841f064 ("drm/amdgpu: add helper to init ih ring regs for vega10")
4750918978a7 ("drm/amdgpu: enabled software IH ring for Vega")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50b0e4d4da09fa501e722af886f97e60a4f820d6 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Wed, 19 Oct 2022 16:57:42 -0400
Subject: [PATCH] drm/amdgpu: fix sdma doorbell init ordering on APUs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 298fa11702e7..1122bd4eae98 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1417,11 +1417,6 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 183024d7c184..e3b2b6b4f1a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1211,6 +1211,20 @@ static int soc15_common_sw_fini(void *handle)
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
@@ -1230,6 +1244,13 @@ static int soc15_common_hw_init(void *handle)
 
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

