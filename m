Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9D6593B05
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347313AbiHOU1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347633AbiHOU0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:26:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFE39D11F;
        Mon, 15 Aug 2022 12:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2878D612A3;
        Mon, 15 Aug 2022 19:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16858C433D6;
        Mon, 15 Aug 2022 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590195;
        bh=G6z55BCnM9EFXJvqKHhQOx84UM7dS+cHpqatbRvC6C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xg4c0M8HG8vVlDokI0CPtx/xDIZgVCP6fvMP64lRybwZpkckM0cMQ1LCOyeDGxNPP
         UFx6+xPGFZUijXGJE4g3n84B7D2En9p2JoXLE7gAlOWvLb8ks4teVDlfmsLV9L62zc
         aYwhvRDecBh60FqmdiUo2zc4JCRivYXoBLaUqqHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0182/1095] drm/amdgpu: Remove one duplicated ef removal
Date:   Mon, 15 Aug 2022 19:53:01 +0200
Message-Id: <20220815180437.170658697@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit e1aadbab445b06e072013a1365fd0cf2aa25e843 ]

That has been done in BO release notify.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2074
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index f4509656ea8c..e9a8eb070766 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1401,16 +1401,10 @@ void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
 				    struct amdgpu_vm *vm)
 {
 	struct amdkfd_process_info *process_info = vm->process_info;
-	struct amdgpu_bo *pd = vm->root.bo;
 
 	if (!process_info)
 		return;
 
-	/* Release eviction fence from PD */
-	amdgpu_bo_reserve(pd, false);
-	amdgpu_bo_fence(pd, NULL, false);
-	amdgpu_bo_unreserve(pd);
-
 	/* Update process info */
 	mutex_lock(&process_info->lock);
 	process_info->n_vms--;
-- 
2.35.1



