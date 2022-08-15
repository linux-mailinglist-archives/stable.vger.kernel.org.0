Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0895947E6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345701AbiHOXdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346396AbiHOXao (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC85D14F950;
        Mon, 15 Aug 2022 13:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01260B81142;
        Mon, 15 Aug 2022 20:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E109C433D6;
        Mon, 15 Aug 2022 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594083;
        bh=9i1Nhb73CtqsJWc2qLjCq0sOYWBXl+56IWMx6l6gBc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsfKAxEkxCDY2jxlXQ39saGmKBgRkoTRiTN3m65L5EsZluuQ6eQZK+f9WIelkfFmj
         Ete00OiEZIF9fVuih7X6XTGv3Fo49dlmgkMjPY3ZPuZBe42RKuSK/V2waiMcuzyD5V
         XkTYu09ideW7wkndfd3HuMaL2Wq9c3AIg9kCrV0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZhenGuo Yin <zhenguo.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0343/1157] drm/amdgpu: fix scratch register access method in SRIOV
Date:   Mon, 15 Aug 2022 19:54:59 +0200
Message-Id: <20220815180453.413724273@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhenGuo Yin <zhenguo.yin@amd.com>

[ Upstream commit 851dd8625320fb626b6ab6399b2402fd84abcdfb ]

The scratch register should be accessed through MMIO instead of RLCG
in SRIOV, since it being used in RLCG register access function.

Fixes: d54762cc3e6a ("drm/amdgpu: nuke dynamic gfx scratch reg allocation")
Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index c5f46d264b23..ecbaf92759b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3780,11 +3780,12 @@ static void gfx_v10_0_wait_reg_mem(struct amdgpu_ring *ring, int eng_sel,
 static int gfx_v10_0_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
+	uint32_t scratch = SOC15_REG_OFFSET(GC, 0, mmSCRATCH_REG0);
 	uint32_t tmp = 0;
 	unsigned i;
 	int r;
 
-	WREG32_SOC15(GC, 0, mmSCRATCH_REG0, 0xCAFEDEAD);
+	WREG32(scratch, 0xCAFEDEAD);
 	r = amdgpu_ring_alloc(ring, 3);
 	if (r) {
 		DRM_ERROR("amdgpu: cp failed to lock ring %d (%d).\n",
@@ -3793,13 +3794,13 @@ static int gfx_v10_0_ring_test_ring(struct amdgpu_ring *ring)
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_SET_UCONFIG_REG, 1));
-	amdgpu_ring_write(ring, SOC15_REG_OFFSET(GC, 0, mmSCRATCH_REG0) -
+	amdgpu_ring_write(ring, scratch -
 			  PACKET3_SET_UCONFIG_REG_START);
 	amdgpu_ring_write(ring, 0xDEADBEEF);
 	amdgpu_ring_commit(ring);
 
 	for (i = 0; i < adev->usec_timeout; i++) {
-		tmp = RREG32_SOC15(GC, 0, mmSCRATCH_REG0);
+		tmp = RREG32(scratch);
 		if (tmp == 0xDEADBEEF)
 			break;
 		if (amdgpu_emu_mode == 1)
-- 
2.35.1



