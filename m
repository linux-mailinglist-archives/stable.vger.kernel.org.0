Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144353CAACB
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241463AbhGOTPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244362AbhGOTOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72021613F7;
        Thu, 15 Jul 2021 19:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376224;
        bh=Si4Vxg9z75zViVvQUYU2DytxHKzMrElDWzYxqq+uDbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1k8h/1d5vwENOHVEaAGLnZMQMShu+HLx3zg4m4TG3KdhRmAa46Z7nHmyiDFnJieo
         ZaCWXUiCUcywHg4+aJpiz3+0MKKwMkE2pVv29FjIJxrgjN5jLR6hYIKS4KtOhc4PPS
         f8rYHD360zT1dzcpz7cIHM0fmEJahsSlKT3y6ZgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 180/266] powerpc/mm: Fix lockup on kernel exec fault
Date:   Thu, 15 Jul 2021 20:38:55 +0200
Message-Id: <20210715182643.441378880@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit cd5d5e602f502895e47e18cd46804d6d7014e65c upstream.

The powerpc kernel is not prepared to handle exec faults from kernel.
Especially, the function is_exec_fault() will return 'false' when an
exec fault is taken by kernel, because the check is based on reading
current->thread.regs->trap which contains the trap from user.

For instance, when provoking a LKDTM EXEC_USERSPACE test,
current->thread.regs->trap is set to SYSCALL trap (0xc00), and
the fault taken by the kernel is not seen as an exec fault by
set_access_flags_filter().

Commit d7df2443cd5f ("powerpc/mm: Fix spurious segfaults on radix
with autonuma") made it clear and handled it properly. But later on
commit d3ca587404b3 ("powerpc/mm: Fix reporting of kernel execute
faults") removed that handling, introducing test based on error_code.
And here is the problem, because on the 603 all upper bits of SRR1
get cleared when the TLB instruction miss handler bails out to ISI.

Until commit cbd7e6ca0210 ("powerpc/fault: Avoid heavy
search_exception_tables() verification"), an exec fault from kernel
at a userspace address was indirectly caught by the lack of entry for
that address in the exception tables. But after that commit the
kernel mainly relies on KUAP or on core mm handling to catch wrong
user accesses. Here the access is not wrong, so mm handles it.
It is a minor fault because PAGE_EXEC is not set,
set_access_flags_filter() should set PAGE_EXEC and voila.
But as is_exec_fault() returns false as explained in the beginning,
set_access_flags_filter() bails out without setting PAGE_EXEC flag,
which leads to a forever minor exec fault.

As the kernel is not prepared to handle such exec faults, the thing to
do is to fire in bad_kernel_fault() for any exec fault taken by the
kernel, as it was prior to commit d3ca587404b3.

Fixes: d3ca587404b3 ("powerpc/mm: Fix reporting of kernel execute faults")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/024bb05105050f704743a0083fe3548702be5706.1625138205.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/fault.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -199,9 +199,7 @@ static bool bad_kernel_fault(struct pt_r
 {
 	int is_exec = TRAP(regs) == INTERRUPT_INST_STORAGE;
 
-	/* NX faults set DSISR_PROTFAULT on the 8xx, DSISR_NOEXEC_OR_G on others */
-	if (is_exec && (error_code & (DSISR_NOEXEC_OR_G | DSISR_KEYFAULT |
-				      DSISR_PROTFAULT))) {
+	if (is_exec) {
 		pr_crit_ratelimited("kernel tried to execute %s page (%lx) - exploit attempt? (uid: %d)\n",
 				    address >= TASK_SIZE ? "exec-protected" : "user",
 				    address,


