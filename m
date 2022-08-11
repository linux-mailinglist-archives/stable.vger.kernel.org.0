Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FFC59030D
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiHKQUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiHKQTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:19:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DED696741;
        Thu, 11 Aug 2022 09:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A9E9CE2256;
        Thu, 11 Aug 2022 16:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F18C433C1;
        Thu, 11 Aug 2022 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233698;
        bh=OiZAxAnQZjkyZ2td/D0/JWcnAdGXseToaBcDirW3jKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTj3+bTo0JUtuH/1VKD3JrDcw9Dl0nvIHYQpikuD8FT15cRSF712eKPPgGQVACSUi
         e524lauuaB7FDNFL0z5S5jSlU94I1nOLF/BZ10Asryww3t5iXQx9sLlvWgr7WoiB6X
         0a6OctrfwYZCSZVjnfF9vYoFJudr5jQ9gqHZ8GPvKcT4vCcGuUxVAWMQWh/VoLPXEP
         /4KqcQO1L9SrDxvAOqn6+X7qWsr2/AXnp3tTgt4IcJPomECDNdJm+mwK0MuEywXae/
         ChykmiYfzZq21ANDo7IpQ7iz1+/xf7g0CDlV+z5V3XU0jwD5MHXNRGluyyFq7cbOFN
         W772kQBtg+ptQ==
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
Subject: [PATCH AUTOSEL 5.15 43/69] drm/amdgpu: skip whole ras bad page framework on sriov
Date:   Thu, 11 Aug 2022 11:55:52 -0400
Message-Id: <20220811155632.1536867-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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
index 96a8fd0ca1df..adea3bfb0760 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1964,7 +1964,7 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev)
 	bool exc_err_limit = false;
 	int ret;
 
-	if (!con)
+	if (!con || amdgpu_sriov_vf(adev))
 		return 0;
 
 	/* Allow access to RAS EEPROM via debugfs, when the ASIC
-- 
2.35.1

