Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4C139D96
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfFHLmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfFHLmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:42:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2E1214AF;
        Sat,  8 Jun 2019 11:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994120;
        bh=KONoMY5xfzCr9/DlteeSfuXG9I776qMQMMarA4039s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1o0SNX2reG9ggqM2ZyH4jip2mNWJE09Lno5LH1ovf5fUmpK9fCkp0+dyVyrXUkajI
         Ea15F9tVf9SNRcmprBQnBHK/a6KY/B1akGCC64dnkz0zGu13CoKP6gWr2A0zHmMqPZ
         2oRXfI9aIMc1PvRYTxW4j9IzYdjFSKX4rumhfCWA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 57/70] arm64: use the correct function type in SYSCALL_DEFINE0
Date:   Sat,  8 Jun 2019 07:39:36 -0400
Message-Id: <20190608113950.8033-57-sashal@kernel.org>
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

[ Upstream commit 0e358bd7b7ebd27e491dabed938eae254c17fe3b ]

Although a syscall defined using SYSCALL_DEFINE0 doesn't accept
parameters, use the correct function type to avoid indirect call
type mismatches with Control-Flow Integrity checking.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/syscall_wrapper.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/syscall_wrapper.h b/arch/arm64/include/asm/syscall_wrapper.h
index a4477e515b79..507d0ee6bc69 100644
--- a/arch/arm64/include/asm/syscall_wrapper.h
+++ b/arch/arm64/include/asm/syscall_wrapper.h
@@ -30,10 +30,10 @@
 	}										\
 	static inline long __do_compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
-#define COMPAT_SYSCALL_DEFINE0(sname)					\
-	asmlinkage long __arm64_compat_sys_##sname(void);		\
-	ALLOW_ERROR_INJECTION(__arm64_compat_sys_##sname, ERRNO);	\
-	asmlinkage long __arm64_compat_sys_##sname(void)
+#define COMPAT_SYSCALL_DEFINE0(sname)							\
+	asmlinkage long __arm64_compat_sys_##sname(const struct pt_regs *__unused);	\
+	ALLOW_ERROR_INJECTION(__arm64_compat_sys_##sname, ERRNO);			\
+	asmlinkage long __arm64_compat_sys_##sname(const struct pt_regs *__unused)
 
 #define COND_SYSCALL_COMPAT(name) \
 	cond_syscall(__arm64_compat_sys_##name);
@@ -62,11 +62,11 @@
 	static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 #ifndef SYSCALL_DEFINE0
-#define SYSCALL_DEFINE0(sname)					\
-	SYSCALL_METADATA(_##sname, 0);				\
-	asmlinkage long __arm64_sys_##sname(void);		\
-	ALLOW_ERROR_INJECTION(__arm64_sys_##sname, ERRNO);	\
-	asmlinkage long __arm64_sys_##sname(void)
+#define SYSCALL_DEFINE0(sname)							\
+	SYSCALL_METADATA(_##sname, 0);						\
+	asmlinkage long __arm64_sys_##sname(const struct pt_regs *__unused);	\
+	ALLOW_ERROR_INJECTION(__arm64_sys_##sname, ERRNO);			\
+	asmlinkage long __arm64_sys_##sname(const struct pt_regs *__unused)
 #endif
 
 #ifndef COND_SYSCALL
-- 
2.20.1

