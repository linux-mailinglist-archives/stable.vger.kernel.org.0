Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9458E5F954D
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiJJASN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiJJARi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:17:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1145C96A;
        Sun,  9 Oct 2022 16:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2674860D17;
        Sun,  9 Oct 2022 23:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FCDC43470;
        Sun,  9 Oct 2022 23:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359576;
        bh=D57F51nhXs+6rwTKvULIB5lh9K58TqPulJrZALO2lFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enQFCB6L9MIc5T3r0cwbsHiVtp1Nc0s/EcA5DmsQFPG0VilIxWFr3G4/j1CLF6JjE
         0X4eQ1HGMCPHZmNVDv+mNb6vyJeGxVDXfFradgrKG3CU5UctMZsjSeZupLIGv4pyiJ
         mI8jBKanLb9gU9BnjAJgzKLRsrMu0xHckeb8nGslNDWV/gU3ZUL608KBermg2pvCMC
         pMJiKHlKCPRKy6LCTBkQm0604xXukF2XuPTR8KD1cWN+mwQcPW6F91tOHmnTIqy2+5
         Bsl+MNznd2WKI1ftn1XBJiYgOscyyOPs5ncn2+IrGNRnRVTM7MtZb1pzsd0Bn9eOGn
         9Yk1LLNIzZ1uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zha <Yifan.Zha@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, aaron.liu@amd.com,
        tianci.yin@amd.com, ray.huang@amd.com, Jack.Xiao@amd.com,
        evan.quan@amd.com, Jack.Gui@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 11/36] drm/amdgpu: Skip the program of MMMC_VM_AGP_* in SRIOV on MMHUB v3_0_0
Date:   Sun,  9 Oct 2022 19:51:57 -0400
Message-Id: <20221009235222.1230786-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235222.1230786-1-sashal@kernel.org>
References: <20221009235222.1230786-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

