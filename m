Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8CE590473
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiHKQ3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbiHKQ1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD72CB2DA4;
        Thu, 11 Aug 2022 09:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D99B61387;
        Thu, 11 Aug 2022 16:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3122C43142;
        Thu, 11 Aug 2022 16:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234120;
        bh=fUvgNExntJwDfB3JdTq3Eknjh4wICN1LCenpz3VRSiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dPrkXcQQJM7Tadi+2Kek8N6yBO8gHAsp8fRINPrJdFypTEKfp406ieUMM79ZXVVDX
         J5NicqSrc2RmbM1/UsiufUgagTkWEFdsQ04TQZO/b0GJdI50QV62G1KwX0swrj/bdP
         dC2SapKLDytxG5CUA7o6CKEKJ3ylU00DDrxVrtUSJBlKB0zVw017xbmlNaoic2jl47
         u8I8FQGA26cWeq78meaL0Ci8TltXwPSIGVWvwROpAkrAHfLy+uueqvhzsiZJgz+JX7
         1evC3ohbViL1OxD0/8v0r17yTmhPSOAuMh4RFKQult07X4TAJ/gy9H3b2nRO8myNf0
         Fm4kI4n/foNSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 07/25] drm/radeon: integer overflow in radeon_mode_dumb_create()
Date:   Thu, 11 Aug 2022 12:08:02 -0400
Message-Id: <20220811160826.1541971-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160826.1541971-1-sashal@kernel.org>
References: <20220811160826.1541971-1-sashal@kernel.org>
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

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

[ Upstream commit feb54650bae25f2a2adfc493e3e254e7c27a3fba ]

Similar to the handling of amdgpu_mode_dumb_create in commit 54ef0b5461c0
("drm/amdgpu: integer overflow in amdgpu_mode_dumb_create()"),
we thought a patch might be needed here as well.

args->size is a u64.  arg->pitch and args->height are u32.  The
multiplication will overflow instead of using the high 32 bits as
intended.

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index b2b076606f54..cb7ef7ea7138 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -757,7 +757,7 @@ int radeon_mode_dumb_create(struct drm_file *file_priv,
 
 	args->pitch = radeon_align_pitch(rdev, args->width,
 					 DIV_ROUND_UP(args->bpp, 8), 0);
-	args->size = args->pitch * args->height;
+	args->size = (u64)args->pitch * args->height;
 	args->size = ALIGN(args->size, PAGE_SIZE);
 
 	r = radeon_gem_object_create(rdev, args->size, 0,
-- 
2.35.1

