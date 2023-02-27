Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A136A3776
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjB0CJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjB0CJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:09:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB231B57B;
        Sun, 26 Feb 2023 18:08:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 707D460D42;
        Mon, 27 Feb 2023 02:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A9FC4339B;
        Mon, 27 Feb 2023 02:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463610;
        bh=NdN166Culp60wILc1C7dFFLT6XE1dlj3cQL/FIUyu84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAXVUJu1KlBNwTAod3ZfdilUs8mwOw2mgSOix79m8K42QAlteAsg0orT/17yxUbKm
         vHiV7G38SROfpU6reF1iLR/h88fmKZudaofL6vv9QEY7E9JQd6Kh96kqwVzmQ5zMiu
         EJkE/SI23UyH15PKw9B40nQ8YzEjThYts0MR2sNi+j01VmErW68LlFJM8hw+W7SYiY
         5cI9uJQ394NWxFtzgq3oqpwJA7fZUkjUfybRMBR3KUCNQTFqPp2BeHpAmKOIy7DBTb
         iGQT5eui2DLPfwXwonygMOjsTSXXU469nTCpdwJkLsxBVBHwbRZmNdt0jQ6hE5KwAc
         IGmfyxQpjs0dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <roman.li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, aurabindo.pillai@amd.com, hersenxs.wu@amd.com,
        stylon.wang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 28/58] drm/amd/display: Set hvm_enabled flag for S/G mode
Date:   Sun, 26 Feb 2023 21:04:26 -0500
Message-Id: <20230227020457.1048737-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <roman.li@amd.com>

[ Upstream commit 40e9f3f067bc6fb47b878f8ba0a9cc7b93abbf49 ]

[Why]
After enabling S/G on dcn314 a screen corruption may be observed.
HostVM flag should be set in S/G mode to be included in DML calculations.

[How]
In S/G mode gpu_vm_support flag is set.
Use its value to init is_hvm_enabled.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6028e332e35d9..ed74cc7403980 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1248,7 +1248,7 @@ static void mmhub_read_system_context(struct amdgpu_device *adev, struct dc_phy_
 	pa_config->gart_config.page_table_end_addr = page_table_end.quad_part << 12;
 	pa_config->gart_config.page_table_base_addr = page_table_base.quad_part;
 
-	pa_config->is_hvm_enabled = 0;
+	pa_config->is_hvm_enabled = adev->mode_info.gpu_vm_support;
 
 }
 
-- 
2.39.0

