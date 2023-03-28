Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DA6CC32D
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjC1Ovt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbjC1Ovb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323CEE07D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACCD0617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEE4C433EF;
        Tue, 28 Mar 2023 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015079;
        bh=obqkoNb62PsRjF2yf7nUVQjnq9ted1J5Oc+NeWU/zgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgVeoOROTqXgOzXxGbrT8rHh93k5Y/8zW3inGvT2KJprZXkbX9Dbm+eBGektAwFUR
         SAQkSQtTir48cKnS5U0nvdUI10f/auAzFG5e+MqaIC794+fLFmRpvULSjBeSiRHOPq
         gvlRQw8W3aY3GF9TXjQAIuVN9ifKlw9VJYqdTYpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, lyndonli <Lyndon.Li@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 158/240] drm/amdgpu: Fix call trace warning and hang when removing amdgpu device
Date:   Tue, 28 Mar 2023 16:42:01 +0200
Message-Id: <20230328142626.265192007@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: lyndonli <Lyndon.Li@amd.com>

[ Upstream commit 93bb18d2a873d2fa9625c8ea927723660a868b95 ]

On GPUs with RAS enabled, below call trace and hang are observed when
shutting down device.

v2: use DRM device unplugged flag instead of shutdown flag as the check to
prevent memory wipe in shutdown stage.

[ +0.000000] RIP: 0010:amdgpu_vram_mgr_fini+0x18d/0x1c0 [amdgpu]
[ +0.000001] PKRU: 55555554
[ +0.000001] Call Trace:
[ +0.000001] <TASK>
[ +0.000002] amdgpu_ttm_fini+0x140/0x1c0 [amdgpu]
[ +0.000183] amdgpu_bo_fini+0x27/0xa0 [amdgpu]
[ +0.000184] gmc_v11_0_sw_fini+0x2b/0x40 [amdgpu]
[ +0.000163] amdgpu_device_fini_sw+0xb6/0x510 [amdgpu]
[ +0.000152] amdgpu_driver_release_kms+0x16/0x30 [amdgpu]
[ +0.000090] drm_dev_release+0x28/0x50 [drm]
[ +0.000016] devm_drm_dev_init_release+0x38/0x60 [drm]
[ +0.000011] devm_action_release+0x15/0x20
[ +0.000003] release_nodes+0x40/0xc0
[ +0.000001] devres_release_all+0x9e/0xe0
[ +0.000001] device_unbind_cleanup+0x12/0x80
[ +0.000003] device_release_driver_internal+0xff/0x160
[ +0.000001] driver_detach+0x4a/0x90
[ +0.000001] bus_remove_driver+0x6c/0xf0
[ +0.000001] driver_unregister+0x31/0x50
[ +0.000001] pci_unregister_driver+0x40/0x90
[ +0.000003] amdgpu_exit+0x15/0x120 [amdgpu]

Signed-off-by: lyndonli <Lyndon.Li@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 25a68d8888e0d..5d4649b8bfd33 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1315,7 +1315,7 @@ void amdgpu_bo_release_notify(struct ttm_buffer_object *bo)
 
 	if (!bo->resource || bo->resource->mem_type != TTM_PL_VRAM ||
 	    !(abo->flags & AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE) ||
-	    adev->in_suspend || adev->shutdown)
+	    adev->in_suspend || drm_dev_is_unplugged(adev_to_drm(adev)))
 		return;
 
 	if (WARN_ON_ONCE(!dma_resv_trylock(bo->base.resv)))
-- 
2.39.2



