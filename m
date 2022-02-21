Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E8C4BE998
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350610AbiBUJjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:39:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351010AbiBUJgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:36:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805A962C4;
        Mon, 21 Feb 2022 01:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B18FBCE0E95;
        Mon, 21 Feb 2022 09:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986F7C36AE7;
        Mon, 21 Feb 2022 09:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434902;
        bh=Oi/z8FXJe7HaSYVUhQ0ZeCMIKUhAiYSLwLD4ZSc+Jec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahNQU9da+jun1EcKscnu+ju/anAPpxjSFruHeq8/UJU2mmUvA5/XAKS3jJCKYxERN
         YcDyvskaDqfEiUF/NRYTH9gwDb4LxqxIByeZPY8Y39pBgBqFStyk2zRqFZpNifYcRt
         lOIUu4JHxIp/FrHaXMuzoWbb0XhZAIFDTcMJT1bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/196] drm/amd/display: Cap pflip irqs per max otg number
Date:   Mon, 21 Feb 2022 09:50:03 +0100
Message-Id: <20220221084936.666545339@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



