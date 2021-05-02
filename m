Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1D1370CFF
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhEBOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233108AbhEBOH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB2E613CF;
        Sun,  2 May 2021 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964374;
        bh=iY5VO/qAecZReXICxH7zFWKuItLfZsQA4p/cP2jeyGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEzzr+zBd2JXOLnkv1sQRQ/QgiuPk75InaMpYjZBgXC2Us9+087Jv92E1K+YofpoI
         qxMlIz1W9LsbbhxRaI1fdcBdjUSp/98HrR9jJl1RGZsAcdrgadRNIUgmcQeejNq8D2
         t5AvuQ6Pa5XaFWXVpTVH5vU0gyfI2eUPesIONhBfJcVfSN01ue+IJ2/KBjjzzk8tNd
         AOodo6tuEKlYAwuaJ8LuQxyWimoWl8nrjGCsGPV/AQ+hsn9VLOVWvKklLKqf65mp06
         Qn2bzcBFTQd3c4u+rwo3UNBU/QZQ0xx2d+kbX031DNSnqdXw/MvBkLHdSM1IQICgzw
         3kVYas+dDtQ+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Millikin <john@john-millikin.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 06/12] x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)
Date:   Sun,  2 May 2021 10:06:00 -0400
Message-Id: <20210502140606.2720323-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140606.2720323-1-sashal@kernel.org>
References: <20210502140606.2720323-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Millikin <john@john-millikin.com>

[ Upstream commit 8abe7fc26ad8f28bfdf78adbed56acd1fa93f82d ]

When cross-compiling with Clang, the `$(CLANG_FLAGS)' variable
contains additional flags needed to build C and assembly sources
for the target platform. Normally this variable is automatically
included in `$(KBUILD_CFLAGS)' via the top-level Makefile.

The x86 real-mode makefile builds `$(REALMODE_CFLAGS)' from a
plain assignment and therefore drops the Clang flags. This causes
Clang to not recognize x86-specific assembler directives:

  arch/x86/realmode/rm/header.S:36:1: error: unknown directive
  .type real_mode_header STT_OBJECT ; .size real_mode_header, .-real_mode_header
  ^

Explicit propagation of `$(CLANG_FLAGS)' to `$(REALMODE_CFLAGS)',
which is inherited by real-mode make rules, fixes cross-compilation
with Clang for x86 targets.

Relevant flags:

* `--target' sets the target architecture when cross-compiling. This
  flag must be set for both compilation and assembly (`KBUILD_AFLAGS')
  to support architecture-specific assembler directives.

* `-no-integrated-as' tells clang to assemble with GNU Assembler
  instead of its built-in LLVM assembler. This flag is set by default
  unless `LLVM_IAS=1' is set, because the LLVM assembler can't yet
  parse certain GNU extensions.

Signed-off-by: John Millikin <john@john-millikin.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Link: https://lkml.kernel.org/r/20210326000435.4785-2-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9ebbd4892557..0bc35e3e6c5c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -40,6 +40,7 @@ REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -Wno-address-of-packed-member)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), $(cc_stack_align4))
+REALMODE_CFLAGS += $(CLANG_FLAGS)
 export REALMODE_CFLAGS
 
 # BITS is used as extension for files which are available in a 32 bit
-- 
2.30.2

