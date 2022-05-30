Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC7538167
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237173AbiE3OTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiE3ORc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C8D8FD44;
        Mon, 30 May 2022 06:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61227B80D6B;
        Mon, 30 May 2022 13:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EF0C3411A;
        Mon, 30 May 2022 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918344;
        bh=D2NjhwYfanFFKXWps4PbKEm6kniN+s25Jjw4sQ6pLPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHvTupQhLe+W3RlcqYqT1xdQ/GEhy5IQaFTdNFhwhMufD6qYmZeP87uj6CssnwZEa
         1et/0Gkf8dev5e4teCclm1Rh7FOcMLMLCGSOZ/C7y/fXgnsC7BGPDJ27GDSkmt6bZK
         xsx/wlUCHi1fFli6UZyt7GDjxiOLaTdChmwQB5uyfTchTp2ZyhK3aJpW9a1vMs/WEh
         XI9nXXdB1mbyZY+FESkRdA2Q2CTtrOm3RtSDBzUO+wEcFeJ+axVQTQgUcCi+79YWai
         ruWdKcHpXDiIaoYsliLgr4vBNgUBDVCDy9Xizcway8TDc1Atm4HjhThHPG7Q7bah8P
         JLbZFVisv9hZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alice Wong <shiwei.wong@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, Likun.Gao@amd.com, john.clements@amd.com,
        candice.li@amd.com, lang.yu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 43/76] drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo
Date:   Mon, 30 May 2022 09:43:33 -0400
Message-Id: <20220530134406.1934928-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index b313ce4c3e97..30005ed8156f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -625,8 +625,7 @@ int amdgpu_ucode_create_bo(struct amdgpu_device *adev)
 
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

