Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FDE6D2D1A
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233639AbjDABpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjDABoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:44:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2211D843;
        Fri, 31 Mar 2023 18:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8184B83306;
        Sat,  1 Apr 2023 01:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D9BC433D2;
        Sat,  1 Apr 2023 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313347;
        bh=RvE78KytFAoRhZX6ykIgr1P/kHs/4e9J1365WZ43r7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FeYR4ayCQxmqL1/fn+jKVO/QaM2WfrGqUWJ/bGgq3hz0XUtDrp7mzWyzjxNmWvMj8
         746iPoVROSD+vG542gkCJsNgWzwh4fD9VAmWJgzz6nPsVeZOBppTqlLyMVjTTfrWyD
         WUxhAKHRS8G7OVqLk18wLbwQMZZ4vWJ68BdU1iDv/9shPKzab1Y7L2HivHElxNgXt4
         w/NYQJyJGxA5m+elq9fGyrZ5gCfmGjm+/C4yCkUhVK0x9H1Vhhn1ErVLJlZyJ1vpfH
         iowzkPCI6IcQPkuCBvO01srWjrIZLNPGSBzTNwigFD2OEhnTJQ4RD5BIAAKgroQkeJ
         bn5qWTCJ0WCbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Liu01 <Tong.Liu01@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, tim.huang@amd.com, yifan1.zhang@amd.com,
        Likun.Gao@amd.com, kenneth.feng@amd.com, evan.quan@amd.com,
        mario.limonciello@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 22/25] drm/amdgpu: add mes resume when do gfx post soft reset
Date:   Fri, 31 Mar 2023 21:41:20 -0400
Message-Id: <20230401014126.3356410-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Liu01 <Tong.Liu01@amd.com>

[ Upstream commit 4eb0b49a0ad3e004a6a65b84efe37bc7e66d560f ]

[why]
when gfx do soft reset, mes will also do reset, if mes is not
resumed when do recover from soft reset, mes is unable to respond
in later sequence

[how]
resume mes when do gfx post soft reset

Signed-off-by: Tong Liu01 <Tong.Liu01@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 66eb102cd88fb..c748d92cec8e7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4625,6 +4625,14 @@ static bool gfx_v11_0_check_soft_reset(void *handle)
 	return false;
 }
 
+static int gfx_v11_0_post_soft_reset(void *handle)
+{
+	/**
+	 * GFX soft reset will impact MES, need resume MES when do GFX soft reset
+	 */
+	return amdgpu_mes_resume((struct amdgpu_device *)handle);
+}
+
 static uint64_t gfx_v11_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 {
 	uint64_t clock;
@@ -6096,6 +6104,7 @@ static const struct amd_ip_funcs gfx_v11_0_ip_funcs = {
 	.wait_for_idle = gfx_v11_0_wait_for_idle,
 	.soft_reset = gfx_v11_0_soft_reset,
 	.check_soft_reset = gfx_v11_0_check_soft_reset,
+	.post_soft_reset = gfx_v11_0_post_soft_reset,
 	.set_clockgating_state = gfx_v11_0_set_clockgating_state,
 	.set_powergating_state = gfx_v11_0_set_powergating_state,
 	.get_clockgating_state = gfx_v11_0_get_clockgating_state,
-- 
2.39.2

