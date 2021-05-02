Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C765370CE3
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhEBOH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233709AbhEBOHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A60E4613DC;
        Sun,  2 May 2021 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964355;
        bh=95U2WqULwpNN6/Z3CkkSoHFK88b2el0ua3k+wDTb7cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsZPE++yVuj+eJ+Y+EhCkcDKRB062I2ZSjmKsrIgYxcKrR7vclizU+8Aa9zuSHdZz
         qJUCEJb0la+ls+7sR9Uh0ilOpWeeniMcZ0oXNtxiDLBm/WH/UGImdLxydIRAc2vcrx
         59WtYzJtly12q6ujRWGYCeOnyMVQiF7WzSNq8KYNp/SmETUm1jKba8fh0jARtxVhOe
         R1CJPZU5GAjf1RM/Vpvz4LImw79ZJHGvlV+svqgcJA3Zbhzy5CNIob98rAm9OuyqhT
         GxprBth2EUhYEEM5gQh2VlaPLL4VQITyGdyH2Bjd7jggftZTscgE5ItTMPw7PZ0ZPa
         CnE+9uVRPBRpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Millikin <john@john-millikin.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.14 08/16] x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)
Date:   Sun,  2 May 2021 10:05:36 -0400
Message-Id: <20210502140544.2720138-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
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
index 146aadeb7c8e..844d5a72d2ad 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -41,6 +41,7 @@ REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -Wno-address-of-packed-member)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), $(cc_stack_align4))
+REALMODE_CFLAGS += $(CLANG_FLAGS)
 export REALMODE_CFLAGS
 
 # BITS is used as extension for files which are available in a 32 bit
-- 
2.30.2

