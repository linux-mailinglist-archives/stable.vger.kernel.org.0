Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2844C63098A
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiKSCOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiKSCMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:12:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000D8776E7;
        Fri, 18 Nov 2022 18:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 914216281A;
        Sat, 19 Nov 2022 02:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04BAC433C1;
        Sat, 19 Nov 2022 02:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823938;
        bh=COaiIcgt9EIbEcLlc1GttK4dQ8KxbQg4sPoMcQWhQJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXV/OVLpHcpRb5kf1+OR28S8USUaKjDwmhnwCaV20no+fzM75v12gdumnNZWJpa+Q
         HIsbQ8/XDsazo6K3czTf/bTzJcCAxzinydHZFJFyiFzEBbitNaBK1xeMxtxdFXKDTN
         G1HlLXvQ7vRj7x5Sb0Spk/zROCed7AgZlQLZpeQ8MZFKicRIzSQ8qyaffwIFOYcOiJ
         Rw4bQSPcyaDeYzS++RrT6QxBgLRBxtvO/mTUSoaz9g1aCQfxR9B9Cs6hoo/WXugM/7
         pIVAZoC35/zMropwtR8PITz5W4YQCdbZp9rKwqOc+9npyp8ifaFk9F/xw9zN6UWTtr
         yr8RuHleHoChA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ma Jun <Jun.Ma2@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, alexander.deucher@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Arunpravin.PaneerSelvam@amd.com, tao.zhou1@amd.com,
        nirmoy.das@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 27/44] drm/amdgpu: Fix the lpfn checking condition in drm buddy
Date:   Fri, 18 Nov 2022 21:11:07 -0500
Message-Id: <20221119021124.1773699-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit e0b26b9482461e9528552f54fa662c2269f75b3f ]

Because the value of man->size is changed during suspend/resume process,
use mgr->mm.size instead of man->size here for lpfn checking.

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220914125331.2467162-1-Jun.Ma2@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 28ec5f8ac1c1..27159f1d112e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -435,7 +435,7 @@ static int amdgpu_vram_mgr_new(struct ttm_resource_manager *man,
 	if (place->flags & TTM_PL_FLAG_TOPDOWN)
 		vres->flags |= DRM_BUDDY_TOPDOWN_ALLOCATION;
 
-	if (fpfn || lpfn != man->size)
+	if (fpfn || lpfn != mgr->mm.size)
 		/* Allocate blocks in desired range */
 		vres->flags |= DRM_BUDDY_RANGE_ALLOCATION;
 
-- 
2.35.1

