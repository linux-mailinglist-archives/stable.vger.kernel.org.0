Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49A1537C26
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiE3N3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiE3N2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:28:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1CA8A070;
        Mon, 30 May 2022 06:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9D0BB80B3A;
        Mon, 30 May 2022 13:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D8CC3411A;
        Mon, 30 May 2022 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917163;
        bh=PBnEfVX85LaiNjq5AuHLvIpM2RMwLs/8cNoj0GuK3cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaiY5QduiySj6q98LVJtiMVkMZZk1YUnWUzO3FavxtWZo+Cop0JyBZiPMSpfoiRqu
         xP9hXmV+F8hCIsa5/ELp4W+nqglU5Tg0DsmFwAVe6mi3ADL1bmw5GWNrCPMrzdtFDf
         6WctF2JZVAIItkVpGbVGybnYSYiQr6tXPy1TRWxnYmpWU5NYobAcDoCChZisZQ3uK6
         65Z4zOC0YFNKSP44OjdU/76TA16Z9hnB2UnpdZCa123wuqzz9ST1S1vEtLIv14eDfr
         6fqCOgm5nCGcQkU/MNvddMTv5CBYNai06WEeU15cVcvf2wKif8JNY/LlYynWrOwimf
         U0xe2NO1dio7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huang Rui <ray.huang@amd.com>, Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 042/159] drm/amdgpu/pm: fix the null pointer while the smu is disabled
Date:   Mon, 30 May 2022 09:22:27 -0400
Message-Id: <20220530132425.1929512-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

[ Upstream commit eea5c7b3390c6e006ba4cbd906447dd8cea8cfbf ]

It needs to check if the pp_funcs is initialized while release the
context, otherwise it will trigger null pointer panic while the software
smu is not enabled.

[ 1109.404555] BUG: kernel NULL pointer dereference, address: 0000000000000078
[ 1109.404609] #PF: supervisor read access in kernel mode
[ 1109.404638] #PF: error_code(0x0000) - not-present page
[ 1109.404657] PGD 0 P4D 0
[ 1109.404672] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 1109.404701] CPU: 7 PID: 9150 Comm: amdgpu_test Tainted: G           OEL    5.16.0-custom #1
[ 1109.404732] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[ 1109.404765] RIP: 0010:amdgpu_dpm_force_performance_level+0x1d/0x170 [amdgpu]
[ 1109.405109] Code: 5d c3 44 8b a3 f0 80 00 00 eb e5 66 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 4c 8b b7 f0 7d 00 00 <49> 83 7e 78 00 0f 84 f2 00 00 00 80 bf 87 80 00 00 00 48 89 fb 0f
[ 1109.405176] RSP: 0018:ffffaf3083ad7c20 EFLAGS: 00010282
[ 1109.405203] RAX: 0000000000000000 RBX: ffff9796b1c14600 RCX: 0000000002862007
[ 1109.405229] RDX: ffff97968591c8c0 RSI: 0000000000000001 RDI: ffff9796a3700000
[ 1109.405260] RBP: ffffaf3083ad7c50 R08: ffffffff9897de00 R09: ffff979688d9db60
[ 1109.405286] R10: 0000000000000000 R11: ffff979688d9db90 R12: 0000000000000001
[ 1109.405316] R13: ffff9796a3700000 R14: 0000000000000000 R15: ffff9796a3708fc0
[ 1109.405345] FS:  00007ff055cff180(0000) GS:ffff9796bfdc0000(0000) knlGS:0000000000000000
[ 1109.405378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1109.405400] CR2: 0000000000000078 CR3: 000000000a394000 CR4: 00000000000506e0
[ 1109.405434] Call Trace:
[ 1109.405445]  <TASK>
[ 1109.405456]  ? delete_object_full+0x1d/0x20
[ 1109.405480]  amdgpu_ctx_set_stable_pstate+0x7c/0xa0 [amdgpu]
[ 1109.405698]  amdgpu_ctx_fini.part.0+0xcb/0x100 [amdgpu]
[ 1109.405911]  amdgpu_ctx_do_release+0x71/0x80 [amdgpu]
[ 1109.406121]  amdgpu_ctx_ioctl+0x52d/0x550 [amdgpu]
[ 1109.406327]  ? _raw_spin_unlock+0x1a/0x30
[ 1109.406354]  ? drm_gem_handle_delete+0x81/0xb0 [drm]
[ 1109.406400]  ? amdgpu_ctx_get_entity+0x2c0/0x2c0 [amdgpu]
[ 1109.406609]  drm_ioctl_kernel+0xb6/0x140 [drm]

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 72e7b5d40af6..5472f9936feb 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -790,7 +790,7 @@ int amdgpu_dpm_force_performance_level(struct amdgpu_device *adev,
 					AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK |
 					AMD_DPM_FORCED_LEVEL_PROFILE_PEAK;
 
-	if (!pp_funcs->force_performance_level)
+	if (!pp_funcs || !pp_funcs->force_performance_level)
 		return 0;
 
 	if (adev->pm.dpm.thermal_active)
-- 
2.35.1

