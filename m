Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B1C45BCB9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbhKXMcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344084AbhKXMa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B37E560240;
        Wed, 24 Nov 2021 12:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756332;
        bh=KBBIBhEHEYoNBE6xqmrxaNTxUXviafPn9GuKMSAPz/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYIJimGdYP6VRWu2oUUFOpZqbM5Xll5CfjsqTsEWCQZgHMoYaslvzTR9UnRwK3rH6
         Tl+v0bg/FMZ+wTnH4ldJplEAMzSqfSwrkHEB2R1+d73z4+BNC7fyMg1KBua0sNQwMa
         nHH400HLQTWsSKdCO3bxWRSQHxUHunm2MtlhQjRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Maciej Rozycki <macro@orcam.me.uk>, linux-mips@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.14 050/251] signal/mips: Update (_save|_restore)_fp_context to fail with -EFAULT
Date:   Wed, 24 Nov 2021 12:54:52 +0100
Message-Id: <20211124115711.983161552@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 95bf9d646c3c3f95cb0be7e703b371db8da5be68 upstream.

When an instruction to save or restore a register from the stack fails
in _save_fp_context or _restore_fp_context return with -EFAULT.  This
change was made to r2300_fpu.S[1] but it looks like it got lost with
the introduction of EX2[2].  This is also what the other implementation
of _save_fp_context and _restore_fp_context in r4k_fpu.S does, and
what is needed for the callers to be able to handle the error.

Furthermore calling do_exit(SIGSEGV) from bad_stack is wrong because
it does not terminate the entire process it just terminates a single
thread.

As the changed code was the only caller of arch/mips/kernel/syscall.c:bad_stack
remove the problematic and now unused helper function.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Maciej Rozycki <macro@orcam.me.uk>
Cc: linux-mips@vger.kernel.org
[1] 35938a00ba86 ("MIPS: Fix ISA I FP sigcontext access violation handling")
[2] f92722dc4545 ("MIPS: Correct MIPS I FP sigcontext layout")
Cc: stable@vger.kernel.org
Fixes: f92722dc4545 ("MIPS: Correct MIPS I FP sigcontext layout")
Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://lkml.kernel.org/r/20211020174406.17889-5-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/r2300_fpu.S |    4 ++--
 arch/mips/kernel/syscall.c   |    9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

--- a/arch/mips/kernel/r2300_fpu.S
+++ b/arch/mips/kernel/r2300_fpu.S
@@ -29,8 +29,8 @@
 #define EX2(a,b)						\
 9:	a,##b;							\
 	.section __ex_table,"a";				\
-	PTR	9b,bad_stack;					\
-	PTR	9b+4,bad_stack;					\
+	PTR	9b,fault;					\
+	PTR	9b+4,fault;					\
 	.previous
 
 	.set	mips1
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -233,12 +233,3 @@ SYSCALL_DEFINE3(cachectl, char *, addr,
 {
 	return -ENOSYS;
 }
-
-/*
- * If we ever come here the user sp is bad.  Zap the process right away.
- * Due to the bad stack signaling wouldn't work.
- */
-asmlinkage void bad_stack(void)
-{
-	do_exit(SIGSEGV);
-}


