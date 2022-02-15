Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569974B7207
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiBOPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:32:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbiBOPb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:31:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26312AEF10;
        Tue, 15 Feb 2022 07:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1494615EE;
        Tue, 15 Feb 2022 15:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D584AC340ED;
        Tue, 15 Feb 2022 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938982;
        bh=Oi/z8FXJe7HaSYVUhQ0ZeCMIKUhAiYSLwLD4ZSc+Jec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHlduCBgsyaB2sBCz7+FJuuN1wKvv/zMrSM2r8ayM2CLQhwnPhFIn7X/c8SgBHzLA
         pqKIdf6kzrkDRd3WUbJX6xXz9piVPkExWICLBZIbHpARbcA4aoJjy4T3OgISHDCbi6
         S5rfyY7v/W3yq0WEcIJv/W4wwJYrCl88vKaUGJsMkclU/7hwj3UYmEW+6trPGJ1nha
         hfjAga9rafXV2lNNlB5JS1y1UZSUA1cAl61/DyZoUQALPt/uG38pE4CcMjsIp57QNV
         OB9bSqSxv8ZOSUMcphqaDdChT2Le53vTcY0VB5bakO/+Veg+z0UqT5dMxyAAZVVOz2
         yY7WC1fLGMShA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <Roman.Li@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, qingqing.zhuo@amd.com, shenshih@amd.com,
        aurabindo.pillai@amd.com, nikola.cornij@amd.com, Wayne.Lin@amd.com,
        Anson.Jacob@amd.com, jun.lei@amd.com,
        meenakshikumar.somasundaram@amd.com, michael.strauss@amd.com,
        haonan.wang2@amd.com, aric.cyr@amd.com, anthony1.wang@amd.com,
        Martin.Leung@amd.com, Jimmy.Kizito@amd.com, Eric.Yang2@amd.com,
        lee.jones@linaro.org, Lewis.Huang@amd.com, roy.chan@amd.com,
        MarkAlbert.Morra@amd.com, Jerry.Zuo@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 29/33] drm/amd/display: Cap pflip irqs per max otg number
Date:   Tue, 15 Feb 2022 10:28:27 -0500
Message-Id: <20220215152831.580780-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152831.580780-1-sashal@kernel.org>
References: <20220215152831.580780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 328e34a5ad227399391891d454043e5d73e598d2 ]

[Why]
pflip interrupt order are mapped 1 to 1 to otg id.
e.g. if irq_src=26 corresponds to otg0 then 27->otg1, 28->otg2...

Linux DM registers pflip interrupts per number of crtcs.
In fused pipe case crtc numbers can be less than otg id.

e.g. if one pipe out of 3(otg#0-2) is fused adev->mode_info.num_crtc=2
so DM only registers irq_src 26,27.
This is a bug since if pipe#2 remains unfused DM never gets
otg2 pflip interrupt (irq_src=28)
That may results in gfx failure due to pflip timeout.

[How]
Register pflip interrupts per max num of otg instead of num_crtc

Signed-off-by: Roman Li <Roman.Li@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 2 ++
 drivers/gpu/drm/amd/display/dc/dc.h               | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 16556ae892d4a..5ae9b8133d6da 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3230,7 +3230,7 @@ static int dcn10_register_irq_handlers(struct amdgpu_device *adev)
 
 	/* Use GRPH_PFLIP interrupt */
 	for (i = DCN_1_0__SRCID__HUBP0_FLIP_INTERRUPT;
-			i <= DCN_1_0__SRCID__HUBP0_FLIP_INTERRUPT + adev->mode_info.num_crtc - 1;
+			i <= DCN_1_0__SRCID__HUBP0_FLIP_INTERRUPT + dc->caps.max_otg_num - 1;
 			i++) {
 		r = amdgpu_irq_add_id(adev, SOC15_IH_CLIENTID_DCE, i, &adev->pageflip_irq);
 		if (r) {
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1860ccc3f4f2c..4fae73478840c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1118,6 +1118,8 @@ struct dc *dc_create(const struct dc_init_data *init_params)
 
 		dc->caps.max_dp_protocol_version = DP_VERSION_1_4;
 
+		dc->caps.max_otg_num = dc->res_pool->res_cap->num_timing_generator;
+
 		if (dc->res_pool->dmcu != NULL)
 			dc->versions.dmcu_version = dc->res_pool->dmcu->dmcu_version;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 3ab52d9a82cf6..e0f58fab5e8ed 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -185,6 +185,7 @@ struct dc_caps {
 	struct dc_color_caps color;
 	bool vbios_lttpr_aware;
 	bool vbios_lttpr_enable;
+	uint32_t max_otg_num;
 };
 
 struct dc_bug_wa {
-- 
2.34.1

