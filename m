Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464E554FCD3
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 20:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383613AbiFQSPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 14:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383168AbiFQSPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 14:15:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B77B13D49;
        Fri, 17 Jun 2022 11:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC41061F3D;
        Fri, 17 Jun 2022 18:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B7EC3411B;
        Fri, 17 Jun 2022 18:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655489704;
        bh=QUh4kC7NXGm1YEXl3pKZXaJzSvNx6+iaW+R315T3U6U=;
        h=From:To:Cc:Subject:Date:From;
        b=QgZ5tfMIqGFau4nNzCvsqcbXS4Qeth6Xu/MxBTR34OtX0oITanNZUiKgHXIvqx77P
         fQaFNIBsEdeCvzAXC02upYo+kSY/xuyAXeW2lsdTS8hxoFrVM5GxndNEPAtX/aw4Tt
         KnwljZzltunV6Ny+OKAKWV53igJoiXdaEmN5F+Fh2LD0rvnJP+P2QzvicHBozyQIHE
         I8Q/FwQib+OCJ9AvjKhAjqJ/eddzlgUQgnlepxSJebMcbQrxBw9dbJsLKolSWFjXW+
         GDdSalz/bhjOvgYBYOjlPTMLsgXboLgljM3tRPgS0TmigorIOXePej19rLiLAyCkic
         T6Ob51Cv+YXQg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Daniel Kolesa <daniel@octaforge.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] x86/Kconfig: Fix CONFIG_CC_HAS_SANE_STACKPROTECTOR when cross compiling with clang
Date:   Fri, 17 Jun 2022 11:08:46 -0700
Message-Id: <20220617180845.2788442-1-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

Chimera Linux notes that CONFIG_CC_HAS_SANE_STACKPROTECTOR cannot be
enabled when cross compiling an x86_64 kernel with clang, even though it
does work when natively compiling.

When building on aarch64:

  $ make -sj"$(nproc)" ARCH=x86_64 LLVM=1 defconfig

  $ grep STACKPROTECTOR .config

When building on x86_64:

  $ make -sj"$(nproc)" ARCH=x86_64 LLVM=1 defconfig

  $ grep STACKPROTECTOR .config
  CONFIG_CC_HAS_SANE_STACKPROTECTOR=y
  CONFIG_HAVE_STACKPROTECTOR=y
  CONFIG_STACKPROTECTOR=y
  CONFIG_STACKPROTECTOR_STRONG=y

When clang is invoked without a '--target' flag, code is generated for
the default target, which is usually the host (it is configurable via
cmake). As a result, the has-stack-protector scripts will generate code
for the default target but check for x86 specific segment registers,
which cannot succeed if the default target is not x86.

$(CLANG_FLAGS) contains an explicit '--target' flag so pass that
variable along to the has-stack-protector scripts so that the stack
protector can be enabled when cross compiling with clang. The 32-bit
stack protector cannot currently be enabled with clang, as it does not
support '-mstack-protector-guard-symbol', so this results in no
functional change for ARCH=i386 when cross compiling.

Link: https://github.com/chimera-linux/cports/commit/0fb7e506d5f83fdf2104feb22cdac34934561226
Link: https://github.com/llvm/llvm-project/issues/48553
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

Fixes: 2a61f4747eea ("stack-protector: test compiler capability in Kconfig and drop AUTO mode")

might be appropriate; I am conflicted on fixes tags for problems that
that arise due to use cases that were not considered at the time of a
change, as it feels wrong to blame the commit for not looking far enough
into the future where it might be common for people to have workstations
running another architecture other than x86_64.

Chimera appears to use a 5.15 kernel so a

Cc: stable@vger.kernel.org

might be nice but some maintainers are picky about that so I leave it up
to you all.

 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index be0b95e51df6..076adde7ead9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -391,8 +391,8 @@ config PGTABLE_LEVELS
 
 config CC_HAS_SANE_STACKPROTECTOR
 	bool
-	default $(success,$(srctree)/scripts/gcc-x86_64-has-stack-protector.sh $(CC)) if 64BIT
-	default $(success,$(srctree)/scripts/gcc-x86_32-has-stack-protector.sh $(CC))
+	default $(success,$(srctree)/scripts/gcc-x86_64-has-stack-protector.sh $(CC) $(CLANG_FLAGS)) if 64BIT
+	default $(success,$(srctree)/scripts/gcc-x86_32-has-stack-protector.sh $(CC) $(CLANG_FLAGS))
 	help
 	  We have to make sure stack protector is unconditionally disabled if
 	  the compiler produces broken code or if it does not let us control

base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
-- 
2.36.1

