Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D65057AC77
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiGTBWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240841AbiGTBVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:21:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18E56F7EE;
        Tue, 19 Jul 2022 18:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9BE6B81DF8;
        Wed, 20 Jul 2022 01:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E620C385A2;
        Wed, 20 Jul 2022 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279775;
        bh=3q1KGC79xM4M51k9jnVzklERtP8wwcR0fIXjBe2Pv7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvgEivpyEA12jXHfc+sCevBla2f58XppaanSgS4Luhj01yl05KTyXWgMB0O0Pdd3l
         WdT6FPlFtID7sPgH6fIvE+eXp3uOnQ47O95zViUodiiFSvGc2t463dwlUXP4sSZ6NC
         tTP8OdM+vNKl/mIuBcVJhg4qcI2y/+F/YvEdNcOveEayZ8c36X/gUQiBRShnKiH3gM
         ehzqBWSYMCpCrqjL+fmw2nYD0L4U7n5hUSSGT1Fm+Wo5PEgiVUwU5UIP3Cmhur94qc
         zvpz6z9fhckhz4hRvkq3THlb52j85fqHYS+UKoG0XN5NdKCLyHvUlgNaLIEfHYeHCA
         m6nd3nweQx6Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, akpm@linux-foundation.org,
        elver@google.com, jpoimboe@kernel.org, keescook@chromium.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 42/42] ubsan: disable UBSAN_DIV_ZERO for clang
Date:   Tue, 19 Jul 2022 21:13:50 -0400
Message-Id: <20220720011350.1024134-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit e5d523f1ae8f2cef01f8e071aeee432654166708 ]

Building with UBSAN_DIV_ZERO with clang produces numerous fallthrough
warnings from objtool.

In the case of uncheck division, UBSAN_DIV_ZERO may introduce new
control flow to check for division by zero.

Because the result of the division is undefined, LLVM may optimize the
control flow such that after the call to __ubsan_handle_divrem_overflow
doesn't matter.  If panic_on_warn was set,
__ubsan_handle_divrem_overflow would panic.

The problem is is that panic_on_warn is run time configurable.  If it's
disabled, then we cannot guarantee that we will be able to recover
safely.  Disable this config for clang until we can come up with a
solution in LLVM.

Link: https://github.com/ClangBuiltLinux/linux/issues/1657
Link: https://github.com/llvm/llvm-project/issues/56289
Link: https://lore.kernel.org/lkml/CAHk-=wj1qhf7y3VNACEexyp5EbkNpdcu_542k-xZpzmYLOjiCg@mail.gmail.com/
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.ubsan | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 236c5cefc4cc..641ac2d0477c 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -96,6 +96,9 @@ config UBSAN_SHIFT
 config UBSAN_DIV_ZERO
 	bool "Perform checking for integer divide-by-zero"
 	depends on $(cc-option,-fsanitize=integer-divide-by-zero)
+	# https://github.com/ClangBuiltLinux/linux/issues/1657
+	# https://github.com/llvm/llvm-project/issues/56289
+	depends on !CC_IS_CLANG
 	help
 	  This option enables -fsanitize=integer-divide-by-zero which checks
 	  for integer division by zero. This is effectively redundant with the
-- 
2.35.1

