Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CA3491868
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348856AbiARCqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347922AbiARCn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604BCC061768;
        Mon, 17 Jan 2022 18:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A7A5B811CC;
        Tue, 18 Jan 2022 02:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352E7C36AE3;
        Tue, 18 Jan 2022 02:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473443;
        bh=vtWjHQg35ZYsG3cvoxDYlP7bz7YRDF4DFA/Z3UcxwWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InFRHjm59dc2eNa7HdL0UYgetFBd7Prk39lzU3HDeSCHdcxTR7onVA06309ReXa/G
         ngHXNXQGeSuijfw8WKGjBV5omGYEgKuguxxENvcwmUkBaxGzuX+pWWoQyziWTSSs3+
         HIpYWo5uGIjoskgPloKtwW6IXuzpOBiVWZiJwSesb3lxdpLwYWhmWihdwF9XLJ1DlW
         pO1cJQTaqvwbJFKrjmlm1U1MRJm8fjF9bdef/bHjPVUDNXu8Cefcj4ZXw3EkJyxoHI
         dmUEevkFvh/qUU6JDyBxQGnFjNeCJprr9TeUVlxFY33xPkO1b+bvDuQtsARI7WhLAQ
         f8XuS+nWsgujw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, john.clements@amd.com, candice.li@amd.com,
        lijo.lazar@amd.com, lang.yu@amd.com, Oak.Zeng@amd.com,
        jonathan.kim@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 119/188] drm/amd/amdgpu: fix psp tmr bo pin count leak in SRIOV
Date:   Mon, 17 Jan 2022 21:30:43 -0500
Message-Id: <20220118023152.1948105-119-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingwen Chen <Jingwen.Chen2@amd.com>

[ Upstream commit 85dfc1d692c9434c37842e610be37cd4ae4e0081 ]

[Why]
psp tmr bo will be pinned during loading amdgpu and reset in SRIOV while
only unpinned in unload amdgpu

[How]
add amdgpu_in_reset and sriov judgement to skip pin bo

v2: fix wrong judgement

Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Horace Chen <horace.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 9b41cb8c3de54..86e2090bbd6e0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2207,12 +2207,16 @@ static int psp_hw_start(struct psp_context *psp)
 		return ret;
 	}
 
+	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
+		goto skip_pin_bo;
+
 	ret = psp_tmr_init(psp);
 	if (ret) {
 		DRM_ERROR("PSP tmr init failed!\n");
 		return ret;
 	}
 
+skip_pin_bo:
 	/*
 	 * For ASICs with DF Cstate management centralized
 	 * to PMFW, TMR setup should be performed after PMFW
-- 
2.34.1

