Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED95922A666
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 06:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgGWEP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 00:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWEP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 00:15:29 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEC9C0619DC;
        Wed, 22 Jul 2020 21:15:27 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l23so4251985qkk.0;
        Wed, 22 Jul 2020 21:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KW20rhBVBSG/GA3kSdVk0F7HWn+qvQaEdDjsOp4a1J0=;
        b=P5Atn+Wlu/TuNhxO3NMCdukgTqLt+JBrLbqJAtk2KYnqs9KyGtbPX646lYVH7fspi7
         f0KpFIwn0rHQnu1mewOb6pKEc7NSspm4wBCKsnTQ/l+ODPGQA7I9NjXJM7nOQ4jJ0I+B
         YBHU+Q0Ir7g55cMVZeHfwA1pbI7vQAKJ5M0Iqkq9o2S+wlKjTqzCPLeNiQV0PaXe7oEN
         4ERQDnPwprD681Z1Hyj3T1e25koJjUT46i4uCT+6rVd0oyzLskCuq0g/PXM2qh6shnND
         EPK/ICcCcj7Aux3EMk3GK+P9AQR4RiYdmAwVBJPuo4WDuVK7YS1vgHmnC1CTxWTj6ahP
         W6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KW20rhBVBSG/GA3kSdVk0F7HWn+qvQaEdDjsOp4a1J0=;
        b=sPVqKNAVwaj5SidEqQFJbcQiLk8RlAlqz8zwh5tbscuuNOaYD+0TEJLv+h7+KAz6la
         F0a4RRnXW5Fxv9XuqmEFBmRHKLMV3uyx8xVZe4pGmJi8fKKGOuE6dFX87j6zQlnOJr8A
         4G8ldiy3aH8gMLWJLbbp9tdEy/WI9kKZ4wcBqxGZzoucmG5WwlBtDTufOQZzGgg5/ckG
         3+3hqxg+53deA1bOpnfGjbPjUoEKPndanghRpNjnm0ottS86POJzXoweem1rPS0zobgq
         ny8xSctDwGlWHQh3ibsx51mlsIO/zJPukvTbFB1sbIyBQatQQd+4gAyxyWa4/08lZFOj
         n3pQ==
X-Gm-Message-State: AOAM531qXLPFRCRLQzTbr5vjL8l/kT53L/6t5oTnR7lvv+0JCTQkRm97
        FCeRYtqwf3oG7nYFNJAdDkw=
X-Google-Smtp-Source: ABdhPJwelgVlZJ/230DMQrEfRCs8dSIaYYAz3DZZHRMyEoiTKhOYK9d9T2s0OmCmd1bPQ06S/l1VHw==
X-Received: by 2002:a05:620a:1315:: with SMTP id o21mr3400085qkj.227.1595477727009;
        Wed, 22 Jul 2020 21:15:27 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id o4sm1662852qkm.25.2020.07.22.21.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 21:15:26 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] arm64: vdso32: Fix '--prefix=' value for newer versions of clang
Date:   Wed, 22 Jul 2020 21:15:10 -0700
Message-Id: <20200723041509.400450-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.28.0.rc1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Newer versions of clang only look for $(COMPAT_GCC_TOOLCHAIN_DIR)as [1],
rather than $(COMPAT_GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE_COMPAT)as,
resulting in the following build error:

$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_COMPAT=arm-linux-gnueabi- LLVM=1 O=out/aarch64 distclean \
defconfig arch/arm64/kernel/vdso32/
...
/home/nathan/cbl/toolchains/llvm-binutils/bin/as: unrecognized option '-EL'
clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
make[3]: *** [arch/arm64/kernel/vdso32/Makefile:181: arch/arm64/kernel/vdso32/note.o] Error 1
...

Adding the value of CROSS_COMPILE_COMPAT (adding notdir to account for a
full path for CROSS_COMPILE_COMPAT) fixes this issue, which matches the
solution done for the main Makefile [2].

[1]: https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90
[2]: https://lore.kernel.org/lkml/20200721173125.1273884-1-maskray@google.com/

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1099
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 arch/arm64/kernel/vdso32/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index d88148bef6b0..5139a5f19256 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -14,7 +14,7 @@ COMPAT_GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE_COMPAT)elfedit))
 COMPAT_GCC_TOOLCHAIN := $(realpath $(COMPAT_GCC_TOOLCHAIN_DIR)/..)
 
 CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
-CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)
+CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE_COMPAT))
 CC_COMPAT_CLANG_FLAGS += -no-integrated-as -Qunused-arguments
 ifneq ($(COMPAT_GCC_TOOLCHAIN),)
 CC_COMPAT_CLANG_FLAGS += --gcc-toolchain=$(COMPAT_GCC_TOOLCHAIN)

base-commit: d15be546031cf65a0fc34879beca02fd90fe7ac7
-- 
2.28.0.rc1

