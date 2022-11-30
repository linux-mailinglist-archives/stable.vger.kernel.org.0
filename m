Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34DD63E023
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiK3Sx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiK3Sxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:53:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B75275DE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40EF4B81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA89C433D6;
        Wed, 30 Nov 2022 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834429;
        bh=9CdGFcI6NSYYFit7v8Tf2qp4SHvPUavvWg7w2trO2Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAw/78HUK1AnsUqtG8T0h7oj6KhOZWGZ/dMMvwpT9coiMcaKLcfQ3XUZi+mBtDsud
         paenAF0/u2GUzvc+z+1/cwZErZ4OSXSxvkJG0SWRIKKck0KGRlu5Pa0Gg6usrumrjs
         zK+axXi2itXDIxugM8I4zaZ19M4Xco3JkzyvL4YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Huang <jinhuieric.huang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 250/289] drm/amdkfd: Fix a memory limit issue
Date:   Wed, 30 Nov 2022 19:23:55 +0100
Message-Id: <20221130180549.773768643@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 6f9eea4392a178af19360694b1db64f985d0b459 ]

It is to resolve a regression, which fails to allocate
VRAM due to no free memory in application, the reason
is we add check of vram_pin_size for memory limit, and
application is pinning the memory for Peerdirect, KFD
should not count it in memory limit. So removing
vram_pin_size will resolve it.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 93ad00453f4b..7db4aef9c45c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -170,9 +170,7 @@ int amdgpu_amdkfd_reserve_mem_limit(struct amdgpu_device *adev,
 	    (kfd_mem_limit.ttm_mem_used + ttm_mem_needed >
 	     kfd_mem_limit.max_ttm_mem_limit) ||
 	    (adev && adev->kfd.vram_used + vram_needed >
-	     adev->gmc.real_vram_size -
-	     atomic64_read(&adev->vram_pin_size) -
-	     reserved_for_pt)) {
+	     adev->gmc.real_vram_size - reserved_for_pt)) {
 		ret = -ENOMEM;
 		goto release;
 	}
-- 
2.35.1



