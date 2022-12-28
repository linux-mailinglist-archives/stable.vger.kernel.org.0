Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC689657E88
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiL1Pyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiL1Pym (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:54:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40136186B4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED317B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B72AC433A1;
        Wed, 28 Dec 2022 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242878;
        bh=2GkK5YJnqS2K8+x4XjShdS4yf6xmc9uTVGnxYH8807A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5dClnYfAmleN249qXbSUm2WHIPdAKk5su941OizIgfBkoRnpYpPRwnz5YbgmyTS/
         V3f1yW++QaZFz2ee5Hl+gjG49s1u3s0liw1uY1JRGM5k3Qmz1AAkA/b66hWYy9SxON
         CsghlacUSVvBJlpnYx3QTM3wAa3XYcEmfei0NxhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 645/731] drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback
Date:   Wed, 28 Dec 2022 15:42:32 +0100
Message-Id: <20221228144315.209768724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e4d0ef752081e7aa6ffb7ccac11c499c732a2e05 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/amd/amdgpu/../pm/swsmu/amdgpu_smu.c:3008:29: error: incompatible function pointer types initializing 'int (*)(void *, uint32_t, long *, uint32_t)' (aka 'int (*)(void *, unsigned int, long *, unsigned int)') with an expression of type 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *, uint32_t)' (aka 'int (void *, enum PP_OD_DPM_TABLE_COMMAND, long *, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .odn_edit_dpm_table      = smu_od_edit_dpm_table,
                                     ^~~~~~~~~~~~~~~~~~~~~
  1 error generated.

There are only two implementations of ->odn_edit_dpm_table() in 'struct
amd_pm_funcs': smu_od_edit_dpm_table() and pp_odn_edit_dpm_table(). One
has a second parameter type of 'enum PP_OD_DPM_TABLE_COMMAND' and the
other uses 'u32'. Ultimately, smu_od_edit_dpm_table() calls
->od_edit_dpm_table() from 'struct pptable_funcs' and
pp_odn_edit_dpm_table() calls ->odn_edit_dpm_table() from 'struct
pp_hwmgr_func', which both have a second parameter type of 'enum
PP_OD_DPM_TABLE_COMMAND'.

Update the type parameter in both the prototype in 'struct amd_pm_funcs'
and pp_odn_edit_dpm_table() to 'enum PP_OD_DPM_TABLE_COMMAND', which
cleans up the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/kgd_pp_interface.h   | 3 ++-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/include/kgd_pp_interface.h b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
index bac15c466733..6e27c8b16391 100644
--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -341,7 +341,8 @@ struct amd_pm_funcs {
 	int (*get_power_profile_mode)(void *handle, char *buf);
 	int (*set_power_profile_mode)(void *handle, long *input, uint32_t size);
 	int (*set_fine_grain_clk_vol)(void *handle, uint32_t type, long *input, uint32_t size);
-	int (*odn_edit_dpm_table)(void *handle, uint32_t type, long *input, uint32_t size);
+	int (*odn_edit_dpm_table)(void *handle, enum PP_OD_DPM_TABLE_COMMAND type,
+				  long *input, uint32_t size);
 	int (*set_mp1_state)(void *handle, enum pp_mp1_state mp1_state);
 	int (*smu_i2c_bus_access)(void *handle, bool acquire);
 	int (*gfx_state_change_set)(void *handle, uint32_t state);
diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 321215003643..0f5930e797bd 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -924,7 +924,8 @@ static int pp_set_fine_grain_clk_vol(void *handle, uint32_t type, long *input, u
 	return hwmgr->hwmgr_func->set_fine_grain_clk_vol(hwmgr, type, input, size);
 }
 
-static int pp_odn_edit_dpm_table(void *handle, uint32_t type, long *input, uint32_t size)
+static int pp_odn_edit_dpm_table(void *handle, enum PP_OD_DPM_TABLE_COMMAND type,
+				 long *input, uint32_t size)
 {
 	struct pp_hwmgr *hwmgr = handle;
 
-- 
2.35.1



