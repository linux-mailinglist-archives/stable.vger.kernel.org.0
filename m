Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18115381DD
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiE3OVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbiE3OSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:18:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038179CCB4;
        Mon, 30 May 2022 06:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E173B80DAA;
        Mon, 30 May 2022 13:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA643C3411C;
        Mon, 30 May 2022 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918504;
        bh=D52O2FRzILz9zMg8zYdxD18w6tiNZOOjolfGlqsqKWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apPL99rlBMcvTIYP9yrHyjGDYRgwpGyRbp+O92sdRWKP5JKRr69DuBfzPwkhtEutQ
         ruOWeE2HDvmcsxOJUiVAaPpTpK0UPLcJXlMRaFcxIWuxOEwuk4Em+TmHn+MXqe2hmu
         8OLnjXnSIzZp3yJm9W6Lt0BwUj5yMwEO3P+RdHwoI3ZqZQt9ZOJWgrXJtFY6nklkdT
         IrszjMpuquS8/pRhhvjwaiD7xvrTQNYHAY7Rh5nmSH/7XP4rAeBv93vNYIKrvahiXg
         LYQx138qVxBm2iT9uCvGuerw852G6SyLpCjMatpNjq4Weh1YXHbpNfKUqfieIGAich
         22zFcS5Eyj2PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alice Wong <shiwei.wong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, Likun.Gao@amd.com, john.clements@amd.com,
        candice.li@amd.com, lang.yu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 31/55] drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo
Date:   Mon, 30 May 2022 09:46:37 -0400
Message-Id: <20220530134701.1935933-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
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

From: Alice Wong <shiwei.wong@amd.com>

[ Upstream commit ab0cd4a9ae5b4679b714d8dbfedc0901fecdce9f ]

When psp_hw_init failed, it will set the load_type to AMDGPU_FW_LOAD_DIRECT.
During amdgpu_device_ip_fini, amdgpu_ucode_free_bo checks that load_type is
AMDGPU_FW_LOAD_DIRECT and skips deallocating fw_buf causing memory leak.
Remove load_type check in amdgpu_ucode_free_bo.

Signed-off-by: Alice Wong <shiwei.wong@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
index 3a6115ad0196..f3250db7f9c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -568,8 +568,7 @@ int amdgpu_ucode_create_bo(struct amdgpu_device *adev)
 
 void amdgpu_ucode_free_bo(struct amdgpu_device *adev)
 {
-	if (adev->firmware.load_type != AMDGPU_FW_LOAD_DIRECT)
-		amdgpu_bo_free_kernel(&adev->firmware.fw_buf,
+	amdgpu_bo_free_kernel(&adev->firmware.fw_buf,
 		&adev->firmware.fw_buf_mc,
 		&adev->firmware.fw_buf_ptr);
 }
-- 
2.35.1

