Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB6F6D2D51
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbjDABsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbjDABrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:47:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2239265AD;
        Fri, 31 Mar 2023 18:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C791EB83318;
        Sat,  1 Apr 2023 01:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11CCC433D2;
        Sat,  1 Apr 2023 01:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313427;
        bh=DRNAUhd7xodd9PlPJsbvFfafmxww8S+HTLuBkpEHq8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVWqf0i92IcBTgDzcM/wqDUQ7zm+i+MkwN7oJgXIQE6sWLizxpLugHS3DjVjCZ73K
         pPqsDkpuGLgTVBVytbFchS4jAmPn3ZPDHHW34Gglcj+vql76NaWfoHriqJjWJFPvq/
         /R7jwgv4tkXHWlkzfB/1KAuDVm/95B9aHgY1GKd7s1CgOmvN1OQ5Ej2jZ+P4dyMSFd
         5uRC1QC3u3nmSnL+ABgfJFO1jFCCxL+dPW9UMiscUV+Btxdq+/M7DsTvNknDbpXf5W
         tayMgSq/uiV3G+s6Up7FgjlPnT+QY7YZRXl5scR5GnWlZNmmoIe/JITe86ZLPXKQ3w
         y5+oDhuYvk73g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jane Jian <Jane.Jian@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, tim.huang@amd.com, yifan1.zhang@amd.com,
        Likun.Gao@amd.com, kenneth.feng@amd.com, evan.quan@amd.com,
        mario.limonciello@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 23/24] drm/amdgpu/gfx: set cg flags to enter/exit safe mode
Date:   Fri, 31 Mar 2023 21:42:39 -0400
Message-Id: <20230401014242.3356780-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
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

From: Jane Jian <Jane.Jian@amd.com>

[ Upstream commit e06bfcc1a1c41bcb8c31470d437e147ce9f0acfd ]

sriov needs to enter/exit safe mode in update umd p state
add the cg flag to let it enter or exit while needed

Signed-off-by: Jane Jian <Jane.Jian@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 7a13129842602..0dd2fe4f071e8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1316,6 +1316,11 @@ static int gfx_v11_0_sw_init(void *handle)
 		break;
 	}
 
+	/* Enable CG flag in one VF mode for enabling RLC safe mode enter/exit */
+	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(11, 0, 3) &&
+		amdgpu_sriov_is_pp_one_vf(adev))
+		adev->cg_flags = AMD_CG_SUPPORT_GFX_CGCG;
+
 	/* EOP Event */
 	r = amdgpu_irq_add_id(adev, SOC21_IH_CLIENTID_GRBM_CP,
 			      GFX_11_0_0__SRCID__CP_EOP_INTERRUPT,
-- 
2.39.2

