Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33C1482C3
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404039AbgAXLag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391679AbgAXLag (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:30:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2577C24658;
        Fri, 24 Jan 2020 11:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865434;
        bh=IMvMgTvmXA/X0cRlwO7yY8WTvXjfr41rRPJBUM6+wz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3Q/+hsIzvWbyFP4yFTW6dATfNgOKQvIoGxXca5TdOle40LvJSH5S1MnPWSGcCsqS
         aJuf1xWG8Rl4yafRRJ/PSV2DDdfmQMP2yhBQsiw0dCt71cDuuFrd2TsZr2KXd1JVn3
         0ySjcSBOw+oVVbuqzzRPxfVqDdQkMxGhpVjpg/sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Eli Friedman <efriedma@quicinc.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Paul Burton <paul.burton@mips.com>, ralf@linux-mips.org,
        jhogan@kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Stephen Kitt <steve@sk2.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>, linux-mips@vger.kernel.org,
        clang-built-linux@googlegroups.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 522/639] mips: avoid explicit UB in assignment of mips_io_port_base
Date:   Fri, 24 Jan 2020 10:31:32 +0100
Message-Id: <20200124093154.161499157@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 12051b318bc3ce5b42d6d786191008284b067d83 ]

The code in question is modifying a variable declared const through
pointer manipulation.  Such code is explicitly undefined behavior, and
is the lone issue preventing malta_defconfig from booting when built
with Clang:

If an attempt is made to modify an object defined with a const-qualified
type through use of an lvalue with non-const-qualified type, the
behavior is undefined.

LLVM is removing such assignments. A simple fix is to not declare
variables const that you plan on modifying.  Limiting the scope would be
a better method of preventing unwanted writes to such a variable.

Further, the code in question mentions "compiler bugs" without any links
to bug reports, so it is difficult to know if the issue is resolved in
GCC. The patch was authored in 2006, which would have been GCC 4.0.3 or
4.1.1. The minimal supported version of GCC in the Linux kernel is
currently 4.6.

For what its worth, there was UB before the commit in question, it just
added a barrier and got lucky IRT codegen. I don't think there's any
actual compiler bugs related, just runtime bugs due to UB.

Link: https://github.com/ClangBuiltLinux/linux/issues/610
Fixes: 966f4406d903 ("[MIPS] Work around bad code generation for <asm/io.h>.")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Debugged-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Eli Friedman <efriedma@quicinc.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: ralf@linux-mips.org
Cc: jhogan@kernel.org
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Hassan Naveed <hnaveed@wavecomp.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Serge Semin <fancer.lancer@gmail.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: clang-built-linux@googlegroups.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/io.h | 14 ++------------
 arch/mips/kernel/setup.c   |  2 +-
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/mips/include/asm/io.h b/arch/mips/include/asm/io.h
index 54c730aed3271..df1eaa3652794 100644
--- a/arch/mips/include/asm/io.h
+++ b/arch/mips/include/asm/io.h
@@ -62,21 +62,11 @@
  * instruction, so the lower 16 bits must be zero.  Should be true on
  * on any sane architecture; generic code does not use this assumption.
  */
-extern const unsigned long mips_io_port_base;
+extern unsigned long mips_io_port_base;
 
-/*
- * Gcc will generate code to load the value of mips_io_port_base after each
- * function call which may be fairly wasteful in some cases.  So we don't
- * play quite by the book.  We tell gcc mips_io_port_base is a long variable
- * which solves the code generation issue.  Now we need to violate the
- * aliasing rules a little to make initialization possible and finally we
- * will need the barrier() to fight side effects of the aliasing chat.
- * This trickery will eventually collapse under gcc's optimizer.  Oh well.
- */
 static inline void set_io_port_base(unsigned long base)
 {
-	* (unsigned long *) &mips_io_port_base = base;
-	barrier();
+	mips_io_port_base = base;
 }
 
 /*
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 8aaaa42f91ed6..e87c98b8a72c0 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -76,7 +76,7 @@ static char __initdata builtin_cmdline[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
  * mips_io_port_base is the begin of the address space to which x86 style
  * I/O ports are mapped.
  */
-const unsigned long mips_io_port_base = -1;
+unsigned long mips_io_port_base = -1;
 EXPORT_SYMBOL(mips_io_port_base);
 
 static struct resource code_resource = { .name = "Kernel code", };
-- 
2.20.1



