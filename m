Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5716862504F
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiKKCec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiKKCeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:34:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170636586A;
        Thu, 10 Nov 2022 18:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A41C961E8C;
        Fri, 11 Nov 2022 02:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3C1C433B5;
        Fri, 11 Nov 2022 02:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134040;
        bh=gjdMWEiszGHlgAUbV/wraW2CCRlUI9SwcqtTzT00osE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WST3di4BKL3S+8oSeD3XVPe7gNuwOlyrmzBXWK0O/AZN1q0d9KLCsaWUc7RDU7T08
         XqN8C2N6BHlfJher3IvLae7dyOoNzMzBDvlyjZaHpvzgtuDL8wAZigotB2x9nw4tGL
         JR2bDcotFy4Ct8qqHDzUHxMsbkiXwmPrKBoV5xtYsHpPvr/P5DUgQcia5mXa/f+F3v
         HGxSY7yMi90AbPtz01bhusLD1BXVfeja5nnuS3CnR5bIYnZVppOfKYlCW90uQ8eKdv
         Y8fkCCkyrDe95q0iFpiCTI+EZLiZZQIKqrnW0i4EN90eXFpbFfoqiA425lCIh3/45U
         v7NruHhPKOVjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.0 10/30] powerpc/64e: Fix amdgpu build on Book3E w/o AltiVec
Date:   Thu, 10 Nov 2022 21:33:18 -0500
Message-Id: <20221111023340.227279-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
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

