Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272F75901A7
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiHKP7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiHKP5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:57:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA41FAB41D;
        Thu, 11 Aug 2022 08:47:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F6A6616F9;
        Thu, 11 Aug 2022 15:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80908C433C1;
        Thu, 11 Aug 2022 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232873;
        bh=syuTXR0wXt+ODyN7niY0i2nUXYmaCVBG22yQ70Uh3Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5cbK3paMY5DP+8eVs1+h8ZMTwO7dScFluZ/olTobSo6uM/7azHfaIsS+wZa4SXaP
         bQ8M/PB7j5kv/b1kSSiVEmPXd7SwkmCizHFDVZDqPbXU43dE6QKezuM2Tv4IjhxgLH
         pNhh+eP2GIfarZwZlR4BW70keNy5OLX0mrDeJd1bngQEpAJV/YPVjzVuIB1R1wTnft
         2SZAshyixMspIB06oTy1KTD/vvu4DljPVNntfy9quMzOkqglFGE2Ht30L4gH/Yq1Dg
         jkIhHaa/95IJdtVnSX8L1amim4lbhuWGzmNh+uh5LjNPbeLH2oJoAHikJZi60qV2x1
         i899vovyfPKmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Stanley.Yang" <Stanley.Yang@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Tao Zhou <tao.zhou1@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        YiPeng.Chai@amd.com, john.clements@amd.com, candice.li@amd.com,
        mukul.joshi@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 51/93] drm/amdgpu: skip whole ras bad page framework on sriov
Date:   Thu, 11 Aug 2022 11:41:45 -0400
Message-Id: <20220811154237.1531313-51-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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

From: "Stanley.Yang" <Stanley.Yang@amd.com>

[ Upstream commit e0e146d5567317d6ba7d0169bed55d1d9ea05a61 ]

It should not init whole ras bad page framework on sriov guest side
due to it is handled on host side.

Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 3f96dadf2698..7506b0b9c2cb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2062,7 +2062,7 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	bool exc_err_limit = false;
 	int ret;
 
-	if (!con)
+	if (!con || amdgpu_sriov_vf(adev))
 		return 0;
 
 	/* Allow access to RAS EEPROM via debugfs, when the ASIC
-- 
2.35.1

