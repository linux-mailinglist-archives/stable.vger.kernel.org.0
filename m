Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEAF6D2D48
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbjDABq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbjDABqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:46:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814D92221A;
        Fri, 31 Mar 2023 18:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84E6AB83310;
        Sat,  1 Apr 2023 01:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3164C433D2;
        Sat,  1 Apr 2023 01:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313417;
        bh=2pP/7F7VNBSB7j7XD5swCP3wrTQaO62LKbd0DZpgzp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zh9xZi2WTIGVOjJmuvnp+LM629LrGSh5Frn7+KdKkNm4v+Ko/oqOpTCSE5uSt065i
         nQB4YQAu1RM9IMbPGwLcCU7/4y770cHJG4BQ0FyXMhIhXpfPGthR3rtGnuzuq+Rptl
         tO6V+UPW4jc8uD2L0QAvk83sLCcpBbTt2K5hFIDK8cCntcAamuDqDC7DZJbK6rdaoo
         nHkscqU2iGEeCfG3rpKzXFWF6dobC5+dhEkaDakBGtr58IC344bNM5mI9INw4ySTTW
         Yi5Hw3GbapdVKDMjRJOvjFp1IzG2PcnJFgB8Nyt4NBhu9N4SKi9TN+MRmICZZqkEeD
         UDlkVOEVfiLmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Liu01 <Tong.Liu01@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, tim.huang@amd.com, yifan1.zhang@amd.com,
        Likun.Gao@amd.com, kenneth.feng@amd.com, mario.limonciello@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 21/24] drm/amdgpu: add mes resume when do gfx post soft reset
Date:   Fri, 31 Mar 2023 21:42:37 -0400
Message-Id: <20230401014242.3356780-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index 90e739d9aeee7..7a13129842602 100644
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
@@ -6068,6 +6076,7 @@ static const struct amd_ip_funcs gfx_v11_0_ip_funcs = {
 	.wait_for_idle = gfx_v11_0_wait_for_idle,
 	.soft_reset = gfx_v11_0_soft_reset,
 	.check_soft_reset = gfx_v11_0_check_soft_reset,
+	.post_soft_reset = gfx_v11_0_post_soft_reset,
 	.set_clockgating_state = gfx_v11_0_set_clockgating_state,
 	.set_powergating_state = gfx_v11_0_set_powergating_state,
 	.get_clockgating_state = gfx_v11_0_get_clockgating_state,
-- 
2.39.2

