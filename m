Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADC961E3E3
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiKFRFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiKFRFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:05:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DA0DF51;
        Sun,  6 Nov 2022 09:04:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 122C560C3F;
        Sun,  6 Nov 2022 17:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157BAC433D6;
        Sun,  6 Nov 2022 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754289;
        bh=J9ji/8TZrXD4KZtfa1JT6SnAI6YRK9WSYwssv/EIJ9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmbYf9wbveCdvt20SYeQgR9V1glIwbOB0fulArkiyf45RQB2h7f7ZHYcTcOuSh/BZ
         dJcWqxKRKuNn7m0+oVmWSohuob7lNobk187kgkbcjg3ekCPRgPAogHRQFbhdCmasiT
         WWbbITAMlLPM25knHOGVxplrK1PNt01x3c1017+hAgpnPLIL+nA3GXCEpeNzgA/ZZ/
         Q/y7SGGrMozL0Xt8zHMEpfwDUVJdYXXcqqf18CXE5GYmYtftBRykFJ0+IPweEUrCsA
         ilN9zQIu1uLXqNfWsjgdi1MJ1Uu/Ouo0DxEWk8PoZuCed07jZVFlGDuhEMgSKzH104
         CjUniAwDo16nA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yiqing Yao <yiqing.yao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Jack.Xiao@amd.com, Hawking.Zhang@amd.com, Graham.Sider@amd.com,
        yifan1.zhang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 24/30] drm/amdgpu: Adjust MES polling timeout for sriov
Date:   Sun,  6 Nov 2022 12:03:36 -0500
Message-Id: <20221106170345.1579893-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
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

From: Yiqing Yao <yiqing.yao@amd.com>

[ Upstream commit 226dcfad349f23f7744d02b24f8ec3bc4f6198ac ]

[why]
MES response time in sriov may be longer than default value
due to reset or init in other VF. A timeout value specific
to sriov is needed.

[how]
When in sriov, adjust the timeout value to calculated
worst case scenario.

Signed-off-by: Yiqing Yao <yiqing.yao@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index f92744b8d79d..e758b4083874 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -96,7 +96,14 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	struct amdgpu_device *adev = mes->adev;
 	struct amdgpu_ring *ring = &mes->ring;
 	unsigned long flags;
+	signed long timeout = adev->usec_timeout;
 
+	if (amdgpu_emu_mode) {
+		timeout *= 100;
+	} else if (amdgpu_sriov_vf(adev)) {
+		/* Worst case in sriov where all other 15 VF timeout, each VF needs about 600ms */
+		timeout = 15 * 600 * 1000;
+	}
 	BUG_ON(size % 4 != 0);
 
 	spin_lock_irqsave(&mes->ring_lock, flags);
@@ -116,7 +123,7 @@ static int mes_v11_0_submit_pkt_and_poll_completion(struct amdgpu_mes *mes,
 	DRM_DEBUG("MES msg=%d was emitted\n", x_pkt->header.opcode);
 
 	r = amdgpu_fence_wait_polling(ring, ring->fence_drv.sync_seq,
-		      adev->usec_timeout * (amdgpu_emu_mode ? 100 : 1));
+		      timeout);
 	if (r < 1) {
 		DRM_ERROR("MES failed to response msg=%d\n",
 			  x_pkt->header.opcode);
-- 
2.35.1

