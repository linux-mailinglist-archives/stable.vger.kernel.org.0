Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0D547FF73
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhL0Phb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238511AbhL0Pgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC8FC061353;
        Mon, 27 Dec 2021 07:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E753610A2;
        Mon, 27 Dec 2021 15:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8359DC36AE7;
        Mon, 27 Dec 2021 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619396;
        bh=TykVT6NdKZpkfUsPedTJatpURiVOWkD5odYud1lDEWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2+j5OV73waEk0yP+UjjXpTJr2eCgkZwiUk9T8696shCkLHilrqSrignd4O5q6KIM
         L5jOZILzo3XxrL0xTdWZAMYemIqNS6rx7DTf59rP2rTZHjbEVdg2o8rQBxovi+j0on
         Rzj/cPB1sjrk8dFQ+kYGSqL8DYaUQVHo4AYMeWpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 01/76] arm64: vdso32: drop -no-integrated-as flag
Date:   Mon, 27 Dec 2021 16:30:16 +0100
Message-Id: <20211227151324.752783426@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit ef94340583eec5cb1544dc41a87baa4f684b3fe1 upstream.

Clang can assemble these files just fine; this is a relic from the top
level Makefile conditionally adding this. We no longer need --prefix,
--gcc-toolchain, or -Qunused-arguments flags either with this change, so
remove those too.

To test building:
$ ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
  CROSS_COMPILE_COMPAT=arm-linux-gnueabi- make LLVM=1 LLVM_IAS=1 \
  defconfig arch/arm64/kernel/vdso32/

Suggested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210420174427.230228-1-ndesaulniers@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/vdso32/Makefile |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -10,15 +10,7 @@ include $(srctree)/lib/vdso/Makefile
 
 # Same as cc-*option, but using CC_COMPAT instead of CC
 ifeq ($(CONFIG_CC_IS_CLANG), y)
-COMPAT_GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE_COMPAT)elfedit))
-COMPAT_GCC_TOOLCHAIN := $(realpath $(COMPAT_GCC_TOOLCHAIN_DIR)/..)
-
 CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
-CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE_COMPAT))
-CC_COMPAT_CLANG_FLAGS += -no-integrated-as -Qunused-arguments
-ifneq ($(COMPAT_GCC_TOOLCHAIN),)
-CC_COMPAT_CLANG_FLAGS += --gcc-toolchain=$(COMPAT_GCC_TOOLCHAIN)
-endif
 
 CC_COMPAT ?= $(CC)
 CC_COMPAT += $(CC_COMPAT_CLANG_FLAGS)


