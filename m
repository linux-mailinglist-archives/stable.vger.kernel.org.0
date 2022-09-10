Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDD5B49B8
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiIJVW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiIJVVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B3E50063;
        Sat, 10 Sep 2022 14:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D02560B4D;
        Sat, 10 Sep 2022 21:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDDFC433D7;
        Sat, 10 Sep 2022 21:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844706;
        bh=3ql1VYg9itb/xt6h5Si74dgyuYXhL3I1F8DJJxHXuNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ln8kGM4cwRv4kNRIwVapz9bmt4qV31SXevrMO0AkxRetyMgvHHbqq3LxrzrrTA+5C
         63Aa5/fCsT6zzaT12Bx3mOWzxDRLbaWf0pdKYXUZAxj0CH4NOcixGcL1v4hxsOqLP1
         ZvG5rlkDryaALji98NofsVgnJp1lhXSnnOx/htcCZMlHD5o0JkDOe5cLL/SI3hvk0A
         73w3rdJ+OVoWaPZQJpR7kPTsvuALqOyCC/hfsxUnk0/hkBCEk8oIbP8Teo2D8g3eGo
         kZZmhGitqIHcoASIzPDF8LF5e5c1yog99eATaiiNA1jZblLTqxX6aDSHXMD3V161Oo
         Sk56anFz33AAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengming Gui <Jack.Gui@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Likun.Gao@amd.com, john.clements@amd.com, candice.li@amd.com,
        guchun.chen@amd.com, tao.zhou1@amd.com, Bokun.Zhang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 17/21] drm/amd/amdgpu: skip ucode loading if ucode_size == 0
Date:   Sat, 10 Sep 2022 17:17:48 -0400
Message-Id: <20220910211752.70291-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
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

From: Chengming Gui <Jack.Gui@amd.com>

[ Upstream commit 39c84b8e929dbd4f63be7e04bf1a2bcd92b44177 ]

Restrict the ucode loading check to avoid frontdoor loading error.

Signed-off-by: Chengming Gui <Jack.Gui@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 57e9932d8a04e..dcb4ad6ecc37b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2505,7 +2505,7 @@ static int psp_load_smu_fw(struct psp_context *psp)
 static bool fw_load_skip_check(struct psp_context *psp,
 			       struct amdgpu_firmware_info *ucode)
 {
-	if (!ucode->fw)
+	if (!ucode->fw || !ucode->ucode_size)
 		return true;
 
 	if (ucode->ucode_id == AMDGPU_UCODE_ID_SMC &&
-- 
2.35.1

