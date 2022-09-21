Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653895C03D3
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiIUQOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiIUQOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:14:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3A585A84;
        Wed, 21 Sep 2022 09:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D557EB830C6;
        Wed, 21 Sep 2022 15:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F95AC433D6;
        Wed, 21 Sep 2022 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775626;
        bh=0zA5pwf1OCRIFOM7AXpOQOvVEQbh6eetXLifEDLltvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTTXKm/qr2jTK8MVoP+dkFTYIfeN2UCdtpSSMQUQXebtNRIYG1yzOxwgn9XJQ5zjQ
         I6TpCYXlxGAphBiYQ+KuaQ7PlT85jvioU09GDQnC3R+2Qqom0gqRUBjdNJ2HpHMXBh
         vQS2sEB1oIjnK4ifO6uMluFH8pTp6cUQagxWEPH9QHDNDEcfc8SXj9oz6vpvymNNlq
         rNcqYsGgYvmIns/akc0nJiB7DnRY03HHhlEjasYJ4n9ST/fjjngC1rtXC8QMBqpgf4
         Lfz2ctbj8iLr709rjxhSYtCClpM9syR4FVfDp8VfnmPLByeAucoeLYFKrnzaH3ssRa
         X3grjCasjnrRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Wang <KevinYang.Wang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Likun.Gao@amd.com, john.clements@amd.com, tao.zhou1@amd.com,
        candice.li@amd.com, guchun.chen@amd.com, Bokun.Zhang@amd.com,
        andrey.grodzovsky@amd.com, Xiaojian.Du@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 08/16] drm/amdgpu: change the alignment size of TMR BO to 1M
Date:   Wed, 21 Sep 2022 11:53:24 -0400
Message-Id: <20220921155332.234913-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155332.234913-1-sashal@kernel.org>
References: <20220921155332.234913-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Yang Wang <KevinYang.Wang@amd.com>

[ Upstream commit 36de13fdb04abef3ee03ade5129ab146de63983b ]

align TMR BO size TO tmr size is not necessary,
modify the size to 1M to avoid re-create BO fail
when serious VRAM fragmentation.

v2:
add new macro PSP_TMR_ALIGNMENT for TMR BO alignment size

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 2b00f8fe15a8..7b8d4484c3c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -748,7 +748,7 @@ static int psp_tmr_init(struct psp_context *psp)
 	}
 
 	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
-	ret = amdgpu_bo_create_kernel(psp->adev, tmr_size, PSP_TMR_SIZE(psp->adev),
+	ret = amdgpu_bo_create_kernel(psp->adev, tmr_size, PSP_TMR_ALIGNMENT,
 				      AMDGPU_GEM_DOMAIN_VRAM,
 				      &psp->tmr_bo, &psp->tmr_mc_addr, pptr);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
index e431f4994931..cd366c7f311f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -36,6 +36,7 @@
 #define PSP_CMD_BUFFER_SIZE	0x1000
 #define PSP_1_MEG		0x100000
 #define PSP_TMR_SIZE(adev)	((adev)->asic_type == CHIP_ALDEBARAN ? 0x800000 : 0x400000)
+#define PSP_TMR_ALIGNMENT	0x100000
 #define PSP_FW_NAME_LEN		0x24
 
 enum psp_shared_mem_size {
-- 
2.35.1

