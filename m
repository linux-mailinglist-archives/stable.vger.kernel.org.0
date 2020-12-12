Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4C22D8812
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439413AbgLLQKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:10:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439401AbgLLQJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:09:56 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xingxing Su <suxingxing@loongson.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Sandipan Das <sandipan@linux.ibm.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Brian Geffon <bgeffon@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 23/23] tools/testing/selftests/vm: fix build error
Date:   Sat, 12 Dec 2020 11:08:04 -0500
Message-Id: <20201212160804.2334982-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xingxing Su <suxingxing@loongson.cn>

[ Upstream commit d8cbe8bfa7df3c680ddfd5e1eee3a5c86d8dc764 ]

Only x86 and PowerPC implement the pkey-xxx.h, and an error was reported
when compiling protection_keys.c.

Add a Arch judgment to compile "protection_keys" in the Makefile.

If other arch implement this, add the arch name to the Makefile.
eg:
    ifneq (,$(findstring $(ARCH),powerpc mips ... ))

Following build errors:

    pkey-helpers.h:93:2: error: #error Architecture not supported
     #error Architecture not supported
    pkey-helpers.h:96:20: error: `PKEY_DISABLE_ACCESS' undeclared
     #define PKEY_MASK (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
                        ^
    protection_keys.c:218:45: error: `PKEY_DISABLE_WRITE' undeclared
     pkey_assert(flags & (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE));
                                                ^

Signed-off-by: Xingxing Su <suxingxing@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Link: https://lkml.kernel.org/r/1606826876-30656-1-git-send-email-suxingxing@loongson.cn
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index a9026706d597d..ac76a78249739 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -43,9 +43,13 @@ ifeq ($(CAN_BUILD_X86_64),1)
 TEST_GEN_FILES += $(BINARIES_64)
 endif
 else
+
+ifneq (,$(findstring $(ARCH),powerpc))
 TEST_GEN_FILES += protection_keys
 endif
 
+endif
+
 ifneq (,$(filter $(MACHINE),arm64 ia64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sh64 sparc64 x86_64))
 TEST_GEN_FILES += va_128TBswitch
 TEST_GEN_FILES += virtual_address_range
-- 
2.27.0

