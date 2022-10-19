Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95728604254
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiJSK60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiJSK4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF791165510;
        Wed, 19 Oct 2022 03:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06E74B824C3;
        Wed, 19 Oct 2022 09:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6416CC433D7;
        Wed, 19 Oct 2022 09:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170668;
        bh=D57F51nhXs+6rwTKvULIB5lh9K58TqPulJrZALO2lFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wCDG/DCzII0YUg9RFOd5frXpgCFE0ioVMHXLm6eMS3uqSYaAojbZ8rcsxJkodMjWr
         5WdRlVoCFC942JAOQDA8sABjeoFLyHvejrjLyWY2BW0gmDvo7txNn/moZvzvONnxmy
         ZeTuKJn3GG6e+/mXyeEfnXTrtjNvYgWJOYUfX1DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Yifan Zha <Yifan.Zha@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 741/862] drm/amdgpu: Skip the program of MMMC_VM_AGP_* in SRIOV on MMHUB v3_0_0
Date:   Wed, 19 Oct 2022 10:33:48 +0200
Message-Id: <20221019083322.695644152@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zha <Yifan.Zha@amd.com>

[ Upstream commit c1026c6f319724dc88fc08d9d9d35bcbdf492b42 ]

[Why]
VF should not program these registers, the value were defined in the host.

[How]
Skip writing them in SRIOV environment and program them on host side.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Signed-off-by: Horace Chen <horace.chen@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
index bc11b2de37ae..a1d26c4d80b8 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
@@ -169,17 +169,17 @@ static void mmhub_v3_0_init_system_aperture_regs(struct amdgpu_device *adev)
 	uint64_t value;
 	uint32_t tmp;
 
-	/* Disable AGP. */
-	WREG32_SOC15(MMHUB, 0, regMMMC_VM_AGP_BASE, 0);
-	WREG32_SOC15(MMHUB, 0, regMMMC_VM_AGP_TOP, 0);
-	WREG32_SOC15(MMHUB, 0, regMMMC_VM_AGP_BOT, 0x00FFFFFF);
-
 	if (!amdgpu_sriov_vf(adev)) {
 		/*
 		 * the new L1 policy will block SRIOV guest from writing
 		 * these regs, and they will be programed at host.
 		 * so skip programing these regs.
 		 */
+		/* Disable AGP. */
+		WREG32_SOC15(MMHUB, 0, regMMMC_VM_AGP_BASE, 0);
+		WREG32_SOC15(MMHUB, 0, regMMMC_VM_AGP_TOP, 0);
+		WREG32_SOC15(MMHUB, 0, regMMMC_VM_AGP_BOT, 0x00FFFFFF);
+
 		/* Program the system aperture low logical page number. */
 		WREG32_SOC15(MMHUB, 0, regMMMC_VM_SYSTEM_APERTURE_LOW_ADDR,
 			     adev->gmc.vram_start >> 18);
-- 
2.35.1



