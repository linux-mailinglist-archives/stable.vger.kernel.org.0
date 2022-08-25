Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F905A05F9
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiHYBg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiHYBgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:36:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC89097EDB;
        Wed, 24 Aug 2022 18:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F30261AD5;
        Thu, 25 Aug 2022 01:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B3DC433D7;
        Thu, 25 Aug 2022 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391351;
        bh=XC0NY0L9hKEaSRA9m9ucx64KeCvrmjDC6f1GpPfHChc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXPkDdX/kTa0qh1kKaRAB6Vp0JYjp9b2RRJ6Ej+7DTnWHB+J5++mOmk0ykHtyOskk
         uxvsyLgpDBfCFa0dltheri1qW+gIrpaBjDI9px1yPF7ICNzea11keusvQ/X7MtGxwr
         MECfZeVdDPINVCZSzqdhRbwpuopPwBn6pFx4MCDpZ2r88cqBghDzbpL/jjOKMVd3Yj
         8fTZqZ3eFX67pJ4R5maowOhH3+og0pt8XisgG4pYlc+v/Y8BVYeN8ZseVEg2EbAn3m
         ntpqxleuCOqrnbfsY4slmsX+lwIlNXBMkRMgUiYcOLwUXQaDXrJa4mEqjhL1xPPYIB
         gUKTZNucFpH7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, James.Zhu@amd.com, sonny.jiang@amd.com,
        tim.huang@amd.com, Likun.Gao@amd.com, kenneth.feng@amd.com,
        Stanley.Yang@amd.com, leo.liu@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 21/38] drm/amdgpu: disable 3DCGCG/CGLS temporarily due to stability issue
Date:   Wed, 24 Aug 2022 21:33:44 -0400
Message-Id: <20220825013401.22096-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 1b586595df6d04c27088ef348b8202204ce26d45 ]

Some stability issues were reported with these features.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 9e18a2b22607..8d5c452a9100 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -530,8 +530,10 @@ static int soc21_common_early_init(void *handle)
 	case IP_VERSION(11, 0, 0):
 		adev->cg_flags = AMD_CG_SUPPORT_GFX_CGCG |
 			AMD_CG_SUPPORT_GFX_CGLS |
+#if 0
 			AMD_CG_SUPPORT_GFX_3D_CGCG |
 			AMD_CG_SUPPORT_GFX_3D_CGLS |
+#endif
 			AMD_CG_SUPPORT_GFX_MGCG |
 			AMD_CG_SUPPORT_REPEATER_FGCG |
 			AMD_CG_SUPPORT_GFX_FGCG |
-- 
2.35.1

