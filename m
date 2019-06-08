Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C354D39EE0
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfFHLmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfFHLmG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41F1214AF;
        Sat,  8 Jun 2019 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994125;
        bh=N+eCfVqoOFIar25lZGLcFa2u00XptyLJiLlDMiiESbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtHUCYq01JwIlRFIM2lC2a46B5uj3mdA60p+rGjyQOQfGbq0NA7vk21yquE/poknf
         /7/R0OYFqGubGJLP3hDOVeBGDgqic5vPVr3hRkLgOL92g53I041i3AFK/boX549eGu
         sph8dpjOlwu4S07oMSaAY+pxu+x6Z3h5GF+ada6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 58/70] arm64: use the correct function type for __arm64_sys_ni_syscall
Date:   Sat,  8 Jun 2019 07:39:37 -0400
Message-Id: <20190608113950.8033-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 1e29ab3186e33c77dbb2d7566172a205b59fa390 ]

Calling sys_ni_syscall through a syscall_fn_t pointer trips indirect
call Control-Flow Integrity checking due to a function type
mismatch. Use SYSCALL_DEFINE0 for __arm64_sys_ni_syscall instead and
remove the now unnecessary casts.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/sys.c   | 14 +++++++++-----
 arch/arm64/kernel/sys32.c |  7 ++-----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 6f91e8116514..d8b35cfe5e94 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -47,22 +47,26 @@ SYSCALL_DEFINE1(arm64_personality, unsigned int, personality)
 	return ksys_personality(personality);
 }
 
+asmlinkage long sys_ni_syscall(void);
+
+asmlinkage long __arm64_sys_ni_syscall(const struct pt_regs *__unused)
+{
+	return sys_ni_syscall();
+}
+
 /*
  * Wrappers to pass the pt_regs argument.
  */
 #define sys_personality		sys_arm64_personality
 
-asmlinkage long sys_ni_syscall(const struct pt_regs *);
-#define __arm64_sys_ni_syscall	sys_ni_syscall
-
 #undef __SYSCALL
 #define __SYSCALL(nr, sym)	asmlinkage long __arm64_##sym(const struct pt_regs *);
 #include <asm/unistd.h>
 
 #undef __SYSCALL
-#define __SYSCALL(nr, sym)	[nr] = (syscall_fn_t)__arm64_##sym,
+#define __SYSCALL(nr, sym)	[nr] = __arm64_##sym,
 
 const syscall_fn_t sys_call_table[__NR_syscalls] = {
-	[0 ... __NR_syscalls - 1] = (syscall_fn_t)sys_ni_syscall,
+	[0 ... __NR_syscalls - 1] = __arm64_sys_ni_syscall,
 #include <asm/unistd.h>
 };
diff --git a/arch/arm64/kernel/sys32.c b/arch/arm64/kernel/sys32.c
index 0f8bcb7de700..3c80a40c1c9d 100644
--- a/arch/arm64/kernel/sys32.c
+++ b/arch/arm64/kernel/sys32.c
@@ -133,17 +133,14 @@ COMPAT_SYSCALL_DEFINE6(aarch32_fallocate, int, fd, int, mode,
 	return ksys_fallocate(fd, mode, arg_u64(offset), arg_u64(len));
 }
 
-asmlinkage long sys_ni_syscall(const struct pt_regs *);
-#define __arm64_sys_ni_syscall	sys_ni_syscall
-
 #undef __SYSCALL
 #define __SYSCALL(nr, sym)	asmlinkage long __arm64_##sym(const struct pt_regs *);
 #include <asm/unistd32.h>
 
 #undef __SYSCALL
-#define __SYSCALL(nr, sym)	[nr] = (syscall_fn_t)__arm64_##sym,
+#define __SYSCALL(nr, sym)	[nr] = __arm64_##sym,
 
 const syscall_fn_t compat_sys_call_table[__NR_compat_syscalls] = {
-	[0 ... __NR_compat_syscalls - 1] = (syscall_fn_t)sys_ni_syscall,
+	[0 ... __NR_compat_syscalls - 1] = __arm64_sys_ni_syscall,
 #include <asm/unistd32.h>
 };
-- 
2.20.1

