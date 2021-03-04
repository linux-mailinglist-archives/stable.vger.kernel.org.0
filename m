Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7533732DA06
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 20:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbhCDTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 14:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236901AbhCDTGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 14:06:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C97C64F65;
        Thu,  4 Mar 2021 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614884768;
        bh=rlGf/oT/ypp/ZZ3p8t+E+bSAIAvHSsBTAdh6Zi5Tr8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrqMDqgvOlH4U91uwr/pUUsxiocuM/3gBqr5jRxYGXuK1r+NzrLxpF5vOu+LY9cz+
         OMRRiELHZAF3v44dNXYaVMuZyFRHDR9U50CilPMoRv1Pd+T4xt7o5787JPt39FX5qX
         K7NDAg3RNp6+7bsqUOrx+oCOWfRcW7/DpUP0aElw730ajDK0VcJBjauICuvniYukO2
         teXyFc1YD4o31zYX+T/DQ5xe2PPfJeMWIVKLccHgoolyLqNBKVkDO40YVBce3CHLuD
         YLwYuQ1UYUe68aLygj/BlDRlix4/qNaKfoi1BDFk9x0SUQRQB+cWeylXTY9TVeliBT
         Oye/XHcgM64tA==
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 01/11] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
Date:   Thu,  4 Mar 2021 11:05:54 -0800
Message-Id: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614884673.git.luto@kernel.org>
References: <cover.1614884673.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On a 32-bit fast syscall that fails to read its arguments from user
memory, the kernel currently does syscall exit work but not
syscall entry work.  This confuses audit and ptrace.  For example:

    $ ./tools/testing/selftests/x86/syscall_arg_fault_32
    ...
    strace: pid 264258: entering, ptrace_syscall_info.op == 2
    ...

This is a minimal fix intended for ease of backporting.  A more
complete cleanup is coming.

Cc: stable@vger.kernel.org
Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 0904f5676e4d..8fdb4cb27efe 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32(struct pt_regs *regs)
 		regs->ax = -EFAULT;
 
 		instrumentation_end();
-		syscall_exit_to_user_mode(regs);
+		local_irq_disable();
+		irqentry_exit_to_user_mode(regs);
 		return false;
 	}
 
-- 
2.29.2

