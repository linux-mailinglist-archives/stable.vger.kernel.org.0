Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CD760B8B1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbiJXTw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiJXTvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA16712090;
        Mon, 24 Oct 2022 11:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0DB1B81707;
        Mon, 24 Oct 2022 12:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47539C433D6;
        Mon, 24 Oct 2022 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614780;
        bh=KN6zdcrsXcZJMufsfn/WcJ8PZyFn64Q/Y6o20hfW248=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tERuVVmTzteLI3iIfV7qu2cdH85DEEhJ4pT/wwllvo4oywk1Bm2TBZvR1mq5zal9g
         Prg8Js6feaJfHmV7BbHUJH6ZN9UEbSGXEeZKUBGMi+WluAOqCNrk76bzqCZRZ2YG+v
         mXxAGHl6aREbPzb79hil68b46CddpHY6K9X8K61A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 384/390] Revert "drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega"
Date:   Mon, 24 Oct 2022 13:33:01 +0200
Message-Id: <20221024113039.334437223@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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

From: Shuah Khan <skhan@linuxfoundation.org>

This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341 which is
commit e3163bc8ffdfdb405e10530b140135b2ee487f89 upstream.

This commit causes repeated WARN_ONs from

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amd
gpu_dm.c:7391 amdgpu_dm_atomic_commit_tail+0x23b9/0x2430 [amdgpu]

dmesg fills up with the following messages and drm initialization takes
a very long time.

Cc: <stable@vger.kernel.org>    # 5.10
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/soc15.c     |   25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1475,11 +1475,6 @@ static int sdma_v4_0_start(struct amdgpu
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
@@ -1332,6 +1332,25 @@ static int soc15_common_sw_fini(void *ha
 	return 0;
 }
 
+static void soc15_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+	struct amdgpu_ring *ring;
+
+	/* sdma/ih doorbell range are programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			ring = &adev->sdma.instance[i].ring;
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				ring->use_doorbell, ring->doorbell_index,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						adev->irq.ih.doorbell_index);
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1351,6 +1370,12 @@ static int soc15_common_hw_init(void *ha
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA/IH/MM/ACV doorbell range prior
+	 * to CP ip block init and ring test.
+	 */
+	soc15_doorbell_range_init(adev);
 
 	return 0;
 }


