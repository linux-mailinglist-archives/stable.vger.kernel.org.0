Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F855B4956
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiIJVTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiIJVSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:18:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C7E4CA13;
        Sat, 10 Sep 2022 14:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE14C60EBA;
        Sat, 10 Sep 2022 21:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84386C433D7;
        Sat, 10 Sep 2022 21:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844649;
        bh=O8LyJ2dh77oOAtphyWd2GJpRCqwx+s/ZIAoEibIkxp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaxxWCO22RKZL52Q6OLitw866MMydMWtq6yDkIjP0EB1a+6/4KiY9+jCCafYebFLS
         BuULkneZjdZSvVyEABuCF1hLafldFbUH9aOkyc32/aTrbeGzsQnxPfNwPmqn2efNCM
         AvnGe5LnWjbzVgQhuAdeU3GPO826lFl6oEPVSgWfDStu0MVXzqBLFDivCxMyn8GWdr
         4quZYAqzhGC/G2J3DWj1m04FzdgVa7nwik9opb5fuiJ4U3vJYhSd9TLnuojVPgtmFX
         aRWIb9rfjdrKzj0Rg7gNlYWmhX6qJBxQWRTg9GGPeR6vuM4Trt0IR0YjwPCsLW5INx
         6eNXY696zmJDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengming Gui <Jack.Gui@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Likun.Gao@amd.com, john.clements@amd.com, candice.li@amd.com,
        tao.zhou1@amd.com, guchun.chen@amd.com, Bokun.Zhang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 28/38] drm/amd/amdgpu: skip ucode loading if ucode_size == 0
Date:   Sat, 10 Sep 2022 17:16:13 -0400
Message-Id: <20220910211623.69825-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
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
index e9411c28d88ba..c50f0d336e158 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2372,7 +2372,7 @@ static int psp_load_smu_fw(struct psp_context *psp)
 static bool fw_load_skip_check(struct psp_context *psp,
 			       struct amdgpu_firmware_info *ucode)
 {
-	if (!ucode->fw)
+	if (!ucode->fw || !ucode->ucode_size)
 		return true;
 
 	if (ucode->ucode_id == AMDGPU_UCODE_ID_SMC &&
-- 
2.35.1

