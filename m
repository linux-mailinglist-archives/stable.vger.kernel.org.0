Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED06B4D74B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729932AbfFTSR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729916AbfFTSR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C9422089C;
        Thu, 20 Jun 2019 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054647;
        bh=TBAws2c/GmHnYBrpWrysQHwua9SqWMmW78aPAlCjFQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvhL19gtAJ3E6HrG7Osj49Z8DNX9OfqSgUy+gsfAuL7W+R3fh6gvRTz/r8dgUQ0tO
         0G0ILxX5vqtWajygez60gxPttK/mkCUIauAWNWoX0Tb7ea4FhJ7/mrnIoZL/wQRC2e
         5PYD0WLcceKCY+lg6V+ekGJd6EPDh1ZVcPstN0+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 81/98] arm64: use the correct function type for __arm64_sys_ni_syscall
Date:   Thu, 20 Jun 2019 19:57:48 +0200
Message-Id: <20190620174353.375988101@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 162a95ed0881..fe20c461582a 100644
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
 #define __arm64_sys_personality		__arm64_sys_arm64_personality
 
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



