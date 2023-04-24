Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8136ECF24
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjDXNie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjDXNic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:38:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F9A7EEB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1BF66243D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B109EC4339B;
        Mon, 24 Apr 2023 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343474;
        bh=V5BQsr3kjpmrNU85YSATEXJCjRsQghWvapoHfDmbADI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+fiRyfmvo2wSM0D3DAouH+fJvHQqBbCSLjC5Glx7ZotJ1FTVJv0jRb+O2JU/a8e4
         5tmlM1AaZz6gJmLO87JSgLLUc7KX67NFKNgQX1YxiQmpBuQbuJsAt8lo7ezaZFthl8
         628ix2cyHfKmo0pa+lXH8NoTKaOH0nTIiNDF3iOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/29] selftests: sigaltstack: fix -Wuninitialized
Date:   Mon, 24 Apr 2023 15:18:37 +0200
Message-Id: <20230424131121.491746712@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 05107edc910135d27fe557267dc45be9630bf3dd ]

Building sigaltstack with clang via:
$ ARCH=x86 make LLVM=1 -C tools/testing/selftests/sigaltstack/

produces the following warning:
  warning: variable 'sp' is uninitialized when used here [-Wuninitialized]
  if (sp < (unsigned long)sstack ||
      ^~

Clang expects these to be declared at global scope; we've fixed this in
the kernel proper by using the macro `current_stack_pointer`. This is
defined in different headers for different target architectures, so just
create a new header that defines the arch-specific register names for
the stack pointer register, and define it for more targets (at least the
ones that support current_stack_pointer/ARCH_HAS_CURRENT_STACK_POINTER).

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Link: https://lore.kernel.org/lkml/CA+G9fYsi3OOu7yCsMutpzKDnBMAzJBCPimBp86LhGBa0eCnEpA@mail.gmail.com/
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sigaltstack/current_stack_pointer.h       | 23 +++++++++++++++++++
 tools/testing/selftests/sigaltstack/sas.c     |  7 +-----
 2 files changed, 24 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/sigaltstack/current_stack_pointer.h

diff --git a/tools/testing/selftests/sigaltstack/current_stack_pointer.h b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
new file mode 100644
index 0000000000000..ea9bdf3a90b16
--- /dev/null
+++ b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#if __alpha__
+register unsigned long sp asm("$30");
+#elif __arm__ || __aarch64__ || __csky__ || __m68k__ || __mips__ || __riscv
+register unsigned long sp asm("sp");
+#elif __i386__
+register unsigned long sp asm("esp");
+#elif __loongarch64
+register unsigned long sp asm("$sp");
+#elif __ppc__
+register unsigned long sp asm("r1");
+#elif __s390x__
+register unsigned long sp asm("%15");
+#elif __sh__
+register unsigned long sp asm("r15");
+#elif __x86_64__
+register unsigned long sp asm("rsp");
+#elif __XTENSA__
+register unsigned long sp asm("a1");
+#else
+#error "implement current_stack_pointer equivalent"
+#endif
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index 228c2ae47687d..6069d97bf5063 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -19,6 +19,7 @@
 #include <errno.h>
 
 #include "../kselftest.h"
+#include "current_stack_pointer.h"
 
 #ifndef SS_AUTODISARM
 #define SS_AUTODISARM  (1U << 31)
@@ -40,12 +41,6 @@ void my_usr1(int sig, siginfo_t *si, void *u)
 	stack_t stk;
 	struct stk_data *p;
 
-#if __s390x__
-	register unsigned long sp asm("%15");
-#else
-	register unsigned long sp asm("sp");
-#endif
-
 	if (sp < (unsigned long)sstack ||
 			sp >= (unsigned long)sstack + SIGSTKSZ) {
 		ksft_exit_fail_msg("SP is not on sigaltstack\n");
-- 
2.39.2



