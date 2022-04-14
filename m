Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B3F5015B7
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245089AbiDNOHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347702AbiDNN7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72563BA334;
        Thu, 14 Apr 2022 06:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F05CB82985;
        Thu, 14 Apr 2022 13:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8270DC385A1;
        Thu, 14 Apr 2022 13:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944304;
        bh=r2IB35UkUQMt3pjuLBJxNIR0DurAilVizkh8rdXZppk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18ASRKXvfIqgFZHfn02W0UnmuTaAOiw4yQg1VBHsSt47OvF7pbjKPDeMntrvKPN12
         7rsRo/lEqj4zSROm4BjoUw1QsuBuAPII8SBjjHhgmpTYvz+b7Y9oelVGKvD+BSWRFm
         XPFE/PYXYWjfmpp+DyxXIyhzyuc8NjX7ksLa0djs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 466/475] drm/amdkfd: Fix -Wstrict-prototypes from amdgpu_amdkfd_gfx_10_0_get_functions()
Date:   Thu, 14 Apr 2022 15:14:11 +0200
Message-Id: <20220414110908.096683236@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Nathan Chancellor <nathan@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10.c
@@ -165,7 +165,7 @@ static const struct kfd2kgd_calls kfd2kg
 	.get_tile_config = amdgpu_amdkfd_get_tile_config,
 };
 
-struct kfd2kgd_calls *amdgpu_amdkfd_gfx_10_0_get_functions()
+struct kfd2kgd_calls *amdgpu_amdkfd_gfx_10_0_get_functions(void)
 {
 	return (struct kfd2kgd_calls *)&kfd2kgd;
 }


