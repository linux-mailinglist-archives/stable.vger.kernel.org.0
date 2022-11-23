Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4A2635790
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238194AbiKWJng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238126AbiKWJmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:42:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA98E3D16
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BB5619F9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83921C433C1;
        Wed, 23 Nov 2022 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196418;
        bh=2FHhCl+8gDNxm4q8X5lF/H2rmAqxjZI+LwQGOZJtzkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbJapUWD1REVL6FLKE0DVTFyO3DxgoJH80uKy0pdJm38PxmWWlKFhmHysq7QPjs6/
         w60iv5AusiT+U+SCdgJqJrFFY+BzSaMM26+5IbQbBDk03zUAZwDoNRvdEm1hn1tFpc
         BZTeyaKeGOa+EIIgUBoEYCwYeAg8HmIM4pLrvAzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yiqing Yao <yiqing.yao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 025/314] drm/amdgpu: Adjust MES polling timeout for sriov
Date:   Wed, 23 Nov 2022 09:47:50 +0100
Message-Id: <20221123084626.634286815@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index 2dd827472d6e..3bff0ae15e64 100644
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



