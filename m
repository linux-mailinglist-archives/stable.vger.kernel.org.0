Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E5E683063
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbjAaPBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbjAaPBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008BB530CB;
        Tue, 31 Jan 2023 07:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C4BB81D4B;
        Tue, 31 Jan 2023 15:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC78C433EF;
        Tue, 31 Jan 2023 15:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177229;
        bh=IR2ghLgr2g4QmwmZiIXnJ7xh3SC++vSjGxGy/gKx3gY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUBKvfG0BosAafqvTJF1dOqKOpUfQmASK+Q4g/Vx+Cj8KNowP8g+d/YhhM1lPRH9p
         NLqLt7Dpsao+qkEHSnRGKQHP+0UAOXIcwHUDdyABAqBZYhnfgi0kqeW2ukayuyNdtr
         zaqH6xvR7OGckqnEyLNlLAtWAy8MosMwRjcEpME7q2lBbm6kU3bLFNtZyaGNMQ+2YN
         RxVWauXnQ5Vc6+NK9QulVVOUYCfUPnGoSFn6trJZQawAwLgu6TIziuHSgtS8nKqa/S
         WOA/VF/F+EotpFasfaQAh/kK7VNKEEVpUEF8EKmu2+0/iXFDVuJWlzGvr7nfhHT+Ke
         XktkPhuoHXi6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Airlie <airlied@redhat.com>, Sasha Levin <sashal@kernel.org>,
        harry.wentland@amd.com, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, roman.li@amd.com, stylon.wang@amd.com,
        aurabindo.pillai@amd.com, Jerry.Zuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 20/20] amdgpu: fix build on non-DCN platforms.
Date:   Tue, 31 Jan 2023 09:59:46 -0500
Message-Id: <20230131145946.1249850-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131145946.1249850-1-sashal@kernel.org>
References: <20230131145946.1249850-1-sashal@kernel.org>
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
index 15b408e3a705..d756a606b5e2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9411,6 +9411,8 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	bool lock_and_validation_needed = false;
 	struct dm_crtc_state *dm_old_crtc_state, *dm_new_crtc_state;
 #if defined(CONFIG_DRM_AMD_DC_DCN)
+	struct drm_dp_mst_topology_mgr *mgr;
+	struct drm_dp_mst_topology_state *mst_state;
 	struct dsc_mst_fairness_vars vars[MAX_PIPES];
 #endif
 
-- 
2.39.0

