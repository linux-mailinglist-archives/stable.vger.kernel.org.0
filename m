Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E225EA1A5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiIZKzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbiIZKyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551C2491EF;
        Mon, 26 Sep 2022 03:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52BA260B97;
        Mon, 26 Sep 2022 10:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55797C433C1;
        Mon, 26 Sep 2022 10:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188078;
        bh=ElgGnMHwYTMeA5F1ytMRi7JBk0lutpViJezpCT+E+t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLZjdeJCLViPtdexopI3u8YGLi+paWbuzw5VgiF6FnJs0W6y2R/5LtZ7j+SDjJfKo
         W+ZKZYV4gGYCYMcL+YQ6mRN64OfZYvTZVmLn5T6079fRD1qBTB0I4QjSCp5y7NPDrs
         AIymenOv8zdvmLQTIXu5sL8Qg08+34MwJHWdLwP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/141] arm64: Restrict ARM64_BTI_KERNEL to clang 12.0.0 and newer
Date:   Mon, 26 Sep 2022 12:11:00 +0200
Message-Id: <20220926100755.730916580@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 8cdd23c23c3d481a43b4aa03dcb5738812831115 ]

Commit 97fed779f2a6 ("arm64: bti: Provide Kconfig for kernel mode BTI")
disabled CONFIG_ARM64_BTI_KERNEL when CONFIG_GCOV_KERNEL was enabled and
compiling with clang because of warnings that were seen with
allmodconfig because LLVM was not emitting PAC/BTI instructions for
compiler generated functions:

  | warning: some functions compiled with BTI and some compiled without BTI
  | warning: not setting BTI in feature flags

This dependency was fine for avoiding the warnings with allmodconfig
until commit 51c2ee6d121c ("Kconfig: Introduce ARCH_WANTS_NO_INSTR and
CC_HAS_NO_PROFILE_FN_ATTR"), which prevents CONFIG_GCOV_KERNEL from
being enabled with clang 12.0.0 or older because those versions do not
support the no_profile_instrument_function attribute.

As a result, CONFIG_ARM64_BTI_KERNEL gets enabled with allmodconfig and
there are more warnings like the ones above due to CONFIG_KASAN, which
suffers from the same problem as CONFIG_GCOV_KERNEL. This was most
likely not noticed at the time because allmodconfig +
CONFIG_GCOV_KERNEL=n was not tested. defconfig + CONFIG_KASAN=y is
enough to reproduce the same warnings as above.

The root cause of the warnings was resolved in LLVM during the 12.0.0
release so rather than play whack-a-mole with the dependencies, just
update CONFIG_ARM64_BTI_KERNEL to require clang 12.0.0, which will have
all of the issues ironed out.

Link: https://github.com/ClangBuiltLinux/linux/issues/1428
Link: https://github.com/ClangBuiltLinux/continuous-integration2/runs/3010034706?check_suite_focus=true
Link: https://github.com/ClangBuiltLinux/continuous-integration2/runs/3010035725?check_suite_focus=true
Link: https://github.com/llvm/llvm-project/commit/a88c722e687e6780dcd6a58718350dc76fcc4cc9
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210712214636.3134425-1-nathan@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: c0a454b9044f ("arm64/bti: Disable in kernel BTI when cross section thunks are broken")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1116a8d092c0..662311a513f0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1654,7 +1654,8 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
-	depends on !(CC_IS_CLANG && GCOV_KERNEL)
+	# https://github.com/llvm/llvm-project/commit/a88c722e687e6780dcd6a58718350dc76fcc4cc9
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 120000
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)
 	help
 	  Build the kernel with Branch Target Identification annotations
-- 
2.35.1



