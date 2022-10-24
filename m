Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949C560B090
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiJXQGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiJXQFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:05:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C4732B9E;
        Mon, 24 Oct 2022 07:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB57B81649;
        Mon, 24 Oct 2022 12:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB55C433D6;
        Mon, 24 Oct 2022 12:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613974;
        bh=s4PXUvrWJNB2JneVuy9c+iXwcUUBogwyTXM3UHtjRok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENRieYn5gjnLy2gkDBvHv0QCNvizhUdIBOD9HIH5vlJOlW+CuGCnIEx/idGNykN2j
         AKKHutCK8bHNnRnnZCEsO+lcpczm1AVkoOUtZcn6+aX9evS97+JwEv4fiR99hG870S
         i4rvlaaoRBkrMImnD2y6D1aNNqADgT7Y4tefpGSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        llvm@lists.linux.dev, Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 054/390] hardening: Avoid harmless Clang option under CONFIG_INIT_STACK_ALL_ZERO
Date:   Mon, 24 Oct 2022 13:27:31 +0200
Message-Id: <20221024113024.928307739@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit f02003c860d921171be4a27e2893766eb3bc6871 upstream.

Currently under Clang, CC_HAS_AUTO_VAR_INIT_ZERO requires an extra
-enable flag compared to CC_HAS_AUTO_VAR_INIT_PATTERN. GCC 12[1] will
not, and will happily ignore the Clang-specific flag. However, its
presence on the command-line is both cumbersome and confusing. Due to
GCC's tolerant behavior, though, we can continue to use a single Kconfig
cc-option test for the feature on both compilers, but then drop the
Clang-specific option in the Makefile.

In other words, this patch does not change anything other than making the
compiler command line shorter once GCC supports -ftrivial-auto-var-init=zero.

[1] https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=a25e0b5e6ac8a77a71c229e0a7b744603365b0e9

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: llvm@lists.linux.dev
Fixes: dcb7c0b9461c ("hardening: Clarify Kconfig text for auto-var-init")
Suggested-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/lkml/20210914102837.6172-1-will@kernel.org/
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile                   |    6 +++---
 security/Kconfig.hardening |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -816,12 +816,12 @@ endif
 
 # Initialize all stack variables with a zero value.
 ifdef CONFIG_INIT_STACK_ALL_ZERO
-# Future support for zero initialization is still being debated, see
-# https://bugs.llvm.org/show_bug.cgi?id=45497. These flags are subject to being
-# renamed or dropped.
 KBUILD_CFLAGS	+= -ftrivial-auto-var-init=zero
+ifdef CONFIG_CC_IS_CLANG
+# https://bugs.llvm.org/show_bug.cgi?id=45497
 KBUILD_CFLAGS	+= -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
 endif
+endif
 
 DEBUG_CFLAGS	:=
 
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -23,13 +23,16 @@ config CC_HAS_AUTO_VAR_INIT_PATTERN
 	def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
 
 config CC_HAS_AUTO_VAR_INIT_ZERO
+	# GCC ignores the -enable flag, so we can test for the feature with
+	# a single invocation using the flag, but drop it as appropriate in
+	# the Makefile, depending on the presence of Clang.
 	def_bool $(cc-option,-ftrivial-auto-var-init=zero -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang)
 
 choice
 	prompt "Initialize kernel stack variables at function entry"
 	default GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS
 	default INIT_STACK_ALL_PATTERN if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT_PATTERN
-	default INIT_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_PATTERN
+	default INIT_STACK_ALL_ZERO if CC_HAS_AUTO_VAR_INIT_ZERO
 	default INIT_STACK_NONE
 	help
 	  This option enables initialization of stack variables at


