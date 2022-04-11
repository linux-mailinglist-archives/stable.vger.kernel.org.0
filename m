Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BC84FC2AA
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiDKQp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 12:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348499AbiDKQp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 12:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2B036333
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37CED616DA
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 16:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E101C385AB;
        Mon, 11 Apr 2022 16:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649695423;
        bh=Hd9RIiV9sj4XsiYmPzJvoULwJHhbWbl+m0vIsIQTM28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUFXWr6UK+Y78LvUBr67l+mPoY3/ZX1OUkaqn4LfKMyctVMQzICrlm/JXAZKQiUvo
         MTUNTnWCz8zO5jVAuudmR/BBJ6wvJqph25dyQdfqVq7Dxq9bq7sHuzb7nFxbqXb36F
         2+i3h4O+VS5HwlcK1NMVrzRjIirvf4L29RpuOjnJ6t3PQ5OwvGt/hT+kRYNxPN1mBJ
         OrXb+5j5i69vBouR8ityz4gf9xKHp6KWMrfBBZfXfiwHbtFgQ+cOE5+T+ajDJC9sz0
         e+a5Hs9iszgLlJ7HKHmq9kvJDWVUrNyjI9AZqxFC62K5urGKa0UhEKlGN6svvHpoVr
         MlxZZrOYz811g==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        amd-gfx@lists.freedesktop.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 2/2] drm/amdkfd: Fix -Wstrict-prototypes from amdgpu_amdkfd_gfx_10_0_get_functions()
Date:   Mon, 11 Apr 2022 09:43:08 -0700
Message-Id: <20220411164308.2491139-3-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411164308.2491139-1-nathan@kernel.org>
References: <20220411164308.2491139-1-nathan@kernel.org>
MIME-Version: 1.0
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

This patch is for linux-5.4.y only, it has no equivalent change
upstream.

When building x86_64 allmodconfig with tip of tree clang, there is an
instance of -Wstrict-prototypes:

  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c:168:59: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
  struct kfd2kgd_calls *amdgpu_amdkfd_gfx_10_0_get_functions()
                                                            ^
                                                             void
  1 error generated.

amdgpu_amdkfd_gfx_10_0_get_functions() is prototyped properly in
drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h but its definition in
amdgpu_amdkfd_gfx_v10.c does not have the argument types specified,
which causes the warning. GCC does not warn because it permits an
old-style definition if the prototype has the argument types.

This code was eliminated by commit e392c887df97 ("drm/amdkfd: Use array
to probe kfd2kgd_calls"), which was a part of a larger series that does
not look very suitable for stable. Just fix this one location, as it was
the only instance of this new warning across a variety of builds.

Fixes: 6bdadb207224 ("drm/amdgpu: Add navi10 kfd support for amdgpu (v3)")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
index ce30d4e8bf25..f7c4337c1ffe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
@@ -165,7 +165,7 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.get_tile_config = amdgpu_amdkfd_get_tile_config,
 };
 
-struct kfd2kgd_calls *amdgpu_amdkfd_gfx_10_0_get_functions()
+struct kfd2kgd_calls *amdgpu_amdkfd_gfx_10_0_get_functions(void)
 {
 	return (struct kfd2kgd_calls *)&kfd2kgd;
 }
-- 
2.35.1

