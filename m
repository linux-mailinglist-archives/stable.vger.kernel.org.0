Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458146357B9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbiKWJqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiKWJpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:45:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624CBE917A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEF92B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D260FC433D7;
        Wed, 23 Nov 2022 09:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196578;
        bh=gjdMWEiszGHlgAUbV/wraW2CCRlUI9SwcqtTzT00osE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXcsWjOnOJBw+UvYvOyhVgxaJaUGsFhl2EItAtZLJqOUZwpV1smpw91vRkgJTJqZB
         yB8CYLZ0j70KoQ5kLyoUIEDtvNQygCCjjCYnFqoEtSTWw8GTkVBygbEqreDpqArnIb
         9BoCJFbHPqaxFYeGgh3VY3nt9aYzXk/43UtHxERM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 041/314] powerpc/64e: Fix amdgpu build on Book3E w/o AltiVec
Date:   Wed, 23 Nov 2022 09:48:06 +0100
Message-Id: <20221123084627.377703970@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 2153fc9623e5465f503d793d4c94ad65e9ec9b5f ]

There's a build failure for Book3E without AltiVec:
  Error: cc1: error: AltiVec not supported in this target
  make[6]: *** [/linux/scripts/Makefile.build:250:
  drivers/gpu/drm/amd/amdgpu/../display/dc/dml/display_mode_lib.o] Error 1

This happens because the amdgpu build is only gated by
PPC_LONG_DOUBLE_128, but that symbol can be enabled even though AltiVec
is disabled.

The only user of PPC_LONG_DOUBLE_128 is amdgpu, so just add a dependency
on AltiVec to that symbol to fix the build.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221027125626.1383092-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index cbe7bb029aec..c1d36a22de30 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -284,7 +284,7 @@ config PPC
 	#
 
 config PPC_LONG_DOUBLE_128
-	depends on PPC64
+	depends on PPC64 && ALTIVEC
 	def_bool $(success,test "$(shell,echo __LONG_DOUBLE_128__ | $(CC) -E -P -)" = 1)
 
 config PPC_BARRIER_NOSPEC
-- 
2.35.1



