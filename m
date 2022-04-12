Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51B44FD83D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351956AbiDLHdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354706AbiDLH0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2674667D;
        Tue, 12 Apr 2022 00:06:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A5E3616D1;
        Tue, 12 Apr 2022 07:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062B3C385A1;
        Tue, 12 Apr 2022 07:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747186;
        bh=Q3b0PMg5JLkodTK+XtPZfINqw+rpVNUCVbxglG8Bpqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9I4iMaz9yd9KPTg+ZA4uDyLaKQ3hFkNuDoKmlMlDCd9DXVr+C+2c0HeiXXzq+/C2
         XDzUEOyuYaDGsT0qmCdDp+3dHJZLn10luQIXa2CqQOh6wcqFIUCCFYrpJrSM5TCwfU
         +ON2C5Ma2qzR8mTdv0Z0sIc3KrPiwB2wcHExhym4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.16 273/285] ubsan: remove CONFIG_UBSAN_OBJECT_SIZE
Date:   Tue, 12 Apr 2022 08:32:10 +0200
Message-Id: <20220412062951.536113780@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 69d0db01e210e07fe915e5da91b54a867cda040f upstream.

The object-size sanitizer is redundant to -Warray-bounds, and
inappropriately performs its checks at run-time when all information
needed for the evaluation is available at compile-time, making it quite
difficult to use:

  https://bugzilla.kernel.org/show_bug.cgi?id=214861

With -Warray-bounds almost enabled globally, it doesn't make sense to
keep this around.

Link: https://lkml.kernel.org/r/20211203235346.110809-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.ubsan      |   13 -------------
 lib/test_ubsan.c       |   22 ----------------------
 scripts/Makefile.ubsan |    1 -
 3 files changed, 36 deletions(-)

--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -112,19 +112,6 @@ config UBSAN_UNREACHABLE
 	  This option enables -fsanitize=unreachable which checks for control
 	  flow reaching an expected-to-be-unreachable position.
 
-config UBSAN_OBJECT_SIZE
-	bool "Perform checking for accesses beyond the end of objects"
-	default UBSAN
-	# gcc hugely expands stack usage with -fsanitize=object-size
-	# https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
-	depends on !CC_IS_GCC
-	depends on $(cc-option,-fsanitize=object-size)
-	help
-	  This option enables -fsanitize=object-size which checks for accesses
-	  beyond the end of objects where the optimizer can determine both the
-	  object being operated on and its size, usually seen with bad downcasts,
-	  or access to struct members from NULL pointers.
-
 config UBSAN_BOOL
 	bool "Perform checking for non-boolean values used as boolean"
 	default UBSAN
--- a/lib/test_ubsan.c
+++ b/lib/test_ubsan.c
@@ -79,15 +79,6 @@ static void test_ubsan_load_invalid_valu
 	eval2 = eval;
 }
 
-static void test_ubsan_null_ptr_deref(void)
-{
-	volatile int *ptr = NULL;
-	int val;
-
-	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
-	val = *ptr;
-}
-
 static void test_ubsan_misaligned_access(void)
 {
 	volatile char arr[5] __aligned(4) = {1, 2, 3, 4, 5};
@@ -98,29 +89,16 @@ static void test_ubsan_misaligned_access
 	*ptr = val;
 }
 
-static void test_ubsan_object_size_mismatch(void)
-{
-	/* "((aligned(8)))" helps this not into be misaligned for ptr-access. */
-	volatile int val __aligned(8) = 4;
-	volatile long long *ptr, val2;
-
-	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
-	ptr = (long long *)&val;
-	val2 = *ptr;
-}
-
 static const test_ubsan_fp test_ubsan_array[] = {
 	test_ubsan_shift_out_of_bounds,
 	test_ubsan_out_of_bounds,
 	test_ubsan_load_invalid_value,
 	test_ubsan_misaligned_access,
-	test_ubsan_object_size_mismatch,
 };
 
 /* Excluded because they Oops the module. */
 static const test_ubsan_fp skip_ubsan_array[] = {
 	test_ubsan_divrem_overflow,
-	test_ubsan_null_ptr_deref,
 };
 
 static int __init test_ubsan_init(void)
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -8,7 +8,6 @@ ubsan-cflags-$(CONFIG_UBSAN_LOCAL_BOUNDS
 ubsan-cflags-$(CONFIG_UBSAN_SHIFT)		+= -fsanitize=shift
 ubsan-cflags-$(CONFIG_UBSAN_DIV_ZERO)		+= -fsanitize=integer-divide-by-zero
 ubsan-cflags-$(CONFIG_UBSAN_UNREACHABLE)	+= -fsanitize=unreachable
-ubsan-cflags-$(CONFIG_UBSAN_OBJECT_SIZE)	+= -fsanitize=object-size
 ubsan-cflags-$(CONFIG_UBSAN_BOOL)		+= -fsanitize=bool
 ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -fsanitize=enum
 ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= -fsanitize-undefined-trap-on-error


