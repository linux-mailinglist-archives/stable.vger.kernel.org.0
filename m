Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D62551A37
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbiFTM4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243072AbiFTMzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:55:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54128193D4;
        Mon, 20 Jun 2022 05:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E72D9614EB;
        Mon, 20 Jun 2022 12:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BBEC3411C;
        Mon, 20 Jun 2022 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729684;
        bh=Nc4h6bd5VOFVAoL8VfnNszRDRrDW6XCZctGLW0J005k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y71f6qeAQNwjtZZVcSQEU2Qszk4MrHCFN37fK/KIBmZbPwaVRoIY2qJiknU2gW7Vd
         O+zGA+UR7xt5NOArOFqGb4h1LhkVt56v87u1GiOXfFh9/CdOYQqaW3Ar/W93lYC/S1
         1fN2qHNgImyWvZOhWPwiyF/kDa7C2mP/96MYTcrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 042/141] gcc-12: disable -Warray-bounds universally for now
Date:   Mon, 20 Jun 2022 14:49:40 +0200
Message-Id: <20220620124730.778643675@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit f0be87c42cbd341d436d06da4792e6b0c83c3aeb ]

In commit 8b202ee21839 ("s390: disable -Warray-bounds") the s390 people
disabled the '-Warray-bounds' warning for gcc-12, because the new logic
in gcc would cause warnings for their use of the S390_lowcore macro,
which accesses absolute pointers.

It turns out gcc-12 has many other issues in this area, so this takes
that s390 warning disable logic, and turns it into a kernel build config
entry instead.

Part of the intent is that we can make this all much more targeted, and
use this conflig flag to disable it in only particular configurations
that cause problems, with the s390 case as an example:

        select GCC12_NO_ARRAY_BOUNDS

and we could do that for other configuration cases that cause issues.

Or we could possibly use the CONFIG_CC_NO_ARRAY_BOUNDS thing in a more
targeted way, and disable the warning only for particular uses: again
the s390 case as an example:

  KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)

but this ends up just doing it globally in the top-level Makefile, since
the current issues are spread fairly widely all over:

  KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds

We'll try to limit this later, since the gcc-12 problems are rare enough
that *much* of the kernel can be built with it without disabling this
warning.

Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile           |  1 +
 arch/s390/Kconfig  |  1 +
 arch/s390/Makefile | 10 +---------
 init/Kconfig       |  9 +++++++++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 476cbe751b17..d19e3b425bd6 100644
--- a/Makefile
+++ b/Makefile
@@ -787,6 +787,7 @@ stackp-flags-$(CONFIG_STACKPROTECTOR_STRONG)      := -fstack-protector-strong
 KBUILD_CFLAGS += $(stackp-flags-y)
 
 KBUILD_CFLAGS-$(CONFIG_WERROR) += -Werror
+KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
 KBUILD_CFLAGS += $(KBUILD_CFLAGS-y) $(CONFIG_CC_IMPLICIT_FALLTHROUGH)
 
 ifdef CONFIG_CC_IS_CLANG
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index e084c72104f8..359b0cc0dc35 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -125,6 +125,7 @@ config S390
 	select CLONE_BACKWARDS2
 	select DMA_OPS if PCI
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
+	select GCC12_NO_ARRAY_BOUNDS
 	select GENERIC_ALLOCATOR
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_CPU_VULNERABILITIES
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index df325eacf62d..eba70d585cb2 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -30,15 +30,7 @@ KBUILD_CFLAGS_DECOMPRESSOR += -fno-stack-protector
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
-
-ifdef CONFIG_CC_IS_GCC
-	ifeq ($(call cc-ifversion, -ge, 1200, y), y)
-		ifeq ($(call cc-ifversion, -lt, 1300, y), y)
-			KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
-			KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, array-bounds)
-		endif
-	endif
-endif
+KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_CC_NO_ARRAY_BOUNDS),-Wno-array-bounds)
 
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,16384)
diff --git a/init/Kconfig b/init/Kconfig
index b19e2eeaae80..fa63cc019ebf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -899,6 +899,15 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
+# Currently, disable gcc-12 array-bounds globally.
+# We may want to target only particular configurations some day.
+config GCC12_NO_ARRAY_BOUNDS
+	def_bool y
+
+config CC_NO_ARRAY_BOUNDS
+	bool
+	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
+
 #
 # For architectures that know their GCC __int128 support is sound
 #
-- 
2.35.1



