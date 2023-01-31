Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1819968309C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbjAaPEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbjAaPEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:04:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ABB53988;
        Tue, 31 Jan 2023 07:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8490BB81D4B;
        Tue, 31 Jan 2023 15:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B0CC433D2;
        Tue, 31 Jan 2023 15:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177258;
        bh=l53l4HHX8VY9mHyviTj/b+FmqBe4Fvyu7A6QkFn7By8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMSIv7X/SqokmX7DzGHdCGPhpn0mrCf0Bi5Rx+Qfp6MAxndwUaTR5Jj1soSfLo5I4
         nXpcdfUoy1pbbDVxVEla/NDHV3Z6vcH1CvO3deUYqfNVwWfulZa4ZnH201uv3Lev3w
         4+T8Mc9BNU38aYdeKeZdb8Tag3tC4GzpemMFEp7PvXKiGjOd3wRTwgZ5vuk3D6tMkq
         TyZ8Mf/0DHPZajO1zNhSpBmTRt6ihAdQJf1OJTBDTpfQBsEWoDENxhTxeV/Y+++SG+
         +r7jcNdBtEja1Ud2Kdf/iLc5E36NLp080x+gLwsch9lxZ3TYTFXPJTA96j2rxWnweP
         CZvhPfY8vXArA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>, Sasha Levin <sashal@kernel.org>,
        harry.wentland@amd.com, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, roman.li@amd.com, Jerry.Zuo@amd.com,
        aurabindo.pillai@amd.com, lyude@redhat.com, stylon.wang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 12/12] amdgpu: fix build on non-DCN platforms.
Date:   Tue, 31 Jan 2023 10:00:30 -0500
Message-Id: <20230131150030.1250104-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150030.1250104-1-sashal@kernel.org>
References: <20230131150030.1250104-1-sashal@kernel.org>
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

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit f439a959dcfb6b39d6fd4b85ca1110a1d1de1587 ]

This fixes the build here locally on my 32-bit arm build.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ee238a16572e..0f0dd9b0d84a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10769,6 +10769,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	bool lock_and_validation_needed = false;
 	struct dm_crtc_state *dm_old_crtc_state;
 #if defined(CONFIG_DRM_AMD_DC_DCN)
+	struct drm_dp_mst_topology_mgr *mgr;
+	struct drm_dp_mst_topology_state *mst_state;
 	struct dsc_mst_fairness_vars vars[MAX_PIPES];
 #endif
 
-- 
2.39.0

