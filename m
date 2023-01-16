Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8707A66C107
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjAPOHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbjAPOF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:05:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD4F233F4;
        Mon, 16 Jan 2023 06:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C730E60FD3;
        Mon, 16 Jan 2023 14:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CAAC433EF;
        Mon, 16 Jan 2023 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877803;
        bh=LrHbGlg411lphMqaUplGm6UeViHuUDxot1Qv3vr1fqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwuX9/SqNHC066ROXd5gvr38sKZM/BzVs01DoOYDmMW4cuNjKgEJltXQlVEjSzDvD
         +f4Hw4U2rquqVGFFCFDlWe300euMPm9LU5JzdRfbBdIcDlFmF1wRvgxqKYcWpgnQgC
         oPbyFw+JVW362tAI2tVMe5oD5ZaFt4Fhmb8WH/YHpnSQF+1w/z7MnsklDGoAOaZc1N
         whfxkNrVTPZ4PVMzqM9wjbGjfI9PksDslyRs0BjtGbgqZhbIZPVtD/TbIQLZoAExxr
         cgNeM1wNVY/mfN/kGJB8TzvirmC7pqBu8LkS4VQyuOfWWjcx07+udluWzoEu570pYM
         A/FH4SjsvP2fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Huang <jinhuieric.huang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 35/53] drm/amdkfd: Add sync after creating vram bo
Date:   Mon, 16 Jan 2023 09:01:35 -0500
Message-Id: <20230116140154.114951-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit ba029e9991d9be90a28b6a0ceb25e9a6fb348829 ]

There will be data corruption on vram allocated by svm
if the initialization is not complete and application is
writting on the memory. Adding sync to wait for the
initialization completion is to resolve this issue.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 64fdf63093a0..63feea08904c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -570,6 +570,15 @@ svm_range_vram_node_new(struct amdgpu_device *adev, struct svm_range *prange,
 		goto reserve_bo_failed;
 	}
 
+	if (clear) {
+		r = amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
+		if (r) {
+			pr_debug("failed %d to sync bo\n", r);
+			amdgpu_bo_unreserve(bo);
+			goto reserve_bo_failed;
+		}
+	}
+
 	r = dma_resv_reserve_fences(bo->tbo.base.resv, 1);
 	if (r) {
 		pr_debug("failed %d to reserve bo\n", r);
-- 
2.35.1

