Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D52370CAD
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhEBOHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233127AbhEBOG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADE861423;
        Sun,  2 May 2021 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964329;
        bh=DTWH8NVoZWx4rVhmqGlYuLjfmdZbDkg5InMe1IXTpgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pixoANdd9/K2rA7y/anQvKUD2oSCsAxu28I0Hp1YSrT3HNRSQOtFlHmgaVdj6dxjC
         yWwQ8f0nUb3a/QFW/SuPS11vw/x67CAo40rLlC7PALW/dONEvph95B7VVgGCgZYpTi
         UjZFeQ3Gkc/9nkZKjnMYRipFedSHyMHQnJuCr7lcDrEo57LmP45IKQQdNRqWfKBXA7
         SVLm9w4YbvtBDNlHpqNTaPojInBSXlS+7yOdHO7fDLUIc698eFj4ioZ8c3mYc4yndb
         AfuGVLxT811KEIRU3pZ4Fn72aOKk4CtXTRAFGArhjpqaoCgJBW53SdmqFG7ENmauXG
         0SWWb04GrSgYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Millikin <john@john-millikin.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 09/21] x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)
Date:   Sun,  2 May 2021 10:05:05 -0400
Message-Id: <20210502140517.2719912-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
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
index 6ebdbad21fb2..65a8722e784c 100644
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

