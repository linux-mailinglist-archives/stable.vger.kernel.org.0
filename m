Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4494C657C10
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiL1P2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiL1P22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4CD14D1B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67BB5B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CECC43392;
        Wed, 28 Dec 2022 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241304;
        bh=voRNV1ehR6mL7kdn35OYuaaty47peth5ZS4yX4ausPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORW3uW/27+/kNiK0G268NcGTaFhWPwbrPqClfnHgEChty437QpYquojRrwjANkz6E
         HVUaqChJZ6GF+UqseFiVI9DX5x3pEhvwQ3cVEza7KeGfDBwyan647z23u2cXP/YFYj
         cC0iO2QP3/k9c1/RxS9Swk5MV7IfvfP89z/A145s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0264/1073] drm/ttm: fix undefined behavior in bit shift for TTM_TT_FLAG_PRIV_POPULATED
Date:   Wed, 28 Dec 2022 15:30:52 +0100
Message-Id: <20221228144335.185551995@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 387659939c00156f8d6bab0fbc55b4eaf2b6bc5b ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in ./include/drm/ttm/ttm_tt.h:122:26
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 ttm_bo_move_memcpy+0x3b4/0x460 [ttm]
 bo_driver_move+0x32/0x40 [drm_vram_helper]
 ttm_bo_handle_move_mem+0x118/0x200 [ttm]
 ttm_bo_validate+0xfa/0x220 [ttm]
 drm_gem_vram_pin_locked+0x70/0x1b0 [drm_vram_helper]
 drm_gem_vram_pin+0x48/0xb0 [drm_vram_helper]
 drm_gem_vram_plane_helper_prepare_fb+0x53/0xe0 [drm_vram_helper]
 drm_gem_vram_simple_display_pipe_prepare_fb+0x26/0x30 [drm_vram_helper]
 drm_simple_kms_plane_prepare_fb+0x4d/0xe0 [drm_kms_helper]
 drm_atomic_helper_prepare_planes+0xda/0x210 [drm_kms_helper]
 drm_atomic_helper_commit+0xc3/0x1e0 [drm_kms_helper]
 drm_atomic_commit+0x9c/0x160 [drm]
 drm_client_modeset_commit_atomic+0x33a/0x380 [drm]
 drm_client_modeset_commit_locked+0x77/0x220 [drm]
 drm_client_modeset_commit+0x31/0x60 [drm]
 __drm_fb_helper_restore_fbdev_mode_unlocked+0xa7/0x170 [drm_kms_helper]
 drm_fb_helper_set_par+0x51/0x90 [drm_kms_helper]
 fbcon_init+0x316/0x790
 visual_init+0x113/0x1d0
 do_bind_con_driver+0x2a3/0x5c0
 do_take_over_console+0xa9/0x270
 do_fbcon_takeover+0xa1/0x170
 do_fb_registered+0x2a8/0x340
 fbcon_fb_registered+0x47/0xe0
 register_framebuffer+0x294/0x4a0
 __drm_fb_helper_initial_config_and_unlock+0x43c/0x880 [drm_kms_helper]
 drm_fb_helper_initial_config+0x52/0x80 [drm_kms_helper]
 drm_fbdev_client_hotplug+0x156/0x1b0 [drm_kms_helper]
 drm_fbdev_generic_setup+0xfc/0x290 [drm_kms_helper]
 bochs_pci_probe+0x6ca/0x772 [bochs]
 local_pci_probe+0x4d/0xb0
 pci_device_probe+0x119/0x320
 really_probe+0x181/0x550
 __driver_probe_device+0xc6/0x220
 driver_probe_device+0x32/0x100
 __driver_attach+0x195/0x200
 bus_for_each_dev+0xbb/0x120
 driver_attach+0x27/0x30
 bus_add_driver+0x22e/0x2f0
 driver_register+0xa9/0x190
 __pci_register_driver+0x90/0xa0
 bochs_pci_driver_init+0x52/0x1000 [bochs]
 do_one_initcall+0x76/0x430
 do_init_module+0x61/0x28a
 load_module+0x1f82/0x2e50
 __do_sys_finit_module+0xf8/0x190
 __x64_sys_finit_module+0x23/0x30
 do_syscall_64+0x58/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Fixes: 3312be8f6fc8 ("drm/ttm: move populated state into page flags")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221031113350.4180975-1-cuigaosheng1@huawei.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/ttm/ttm_tt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/ttm/ttm_tt.h b/include/drm/ttm/ttm_tt.h
index 17a0310e8aaa..b7d3f3843f1e 100644
--- a/include/drm/ttm/ttm_tt.h
+++ b/include/drm/ttm/ttm_tt.h
@@ -88,7 +88,7 @@ struct ttm_tt {
 #define TTM_TT_FLAG_EXTERNAL		(1 << 2)
 #define TTM_TT_FLAG_EXTERNAL_MAPPABLE	(1 << 3)
 
-#define TTM_TT_FLAG_PRIV_POPULATED  (1 << 31)
+#define TTM_TT_FLAG_PRIV_POPULATED  (1U << 31)
 	uint32_t page_flags;
 	/** @num_pages: Number of pages in the page array. */
 	uint32_t num_pages;
-- 
2.35.1



