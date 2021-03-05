Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0C532F400
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 20:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCETfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 14:35:51 -0500
Received: from svr21.theemailshop.co.uk ([185.119.110.12]:45706 "EHLO
        svr21.theemailshop.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCETfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 14:35:25 -0500
X-Greylist: delayed 1391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2021 14:35:25 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=majoroak.me.uk; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fNj8NYcf7Px9yGJS6mFKujckCNgJ6vf2/9pl9FUCTgo=; b=zC4JjlxtGYF31xHENDAjbncA/s
        YwPZuamSk+EukdxXzYkhhtO8A9j7eVyMlygL2EQZhQ+9GvE8xR1XOnftbCH+Yj2y0rk51lURzOydB
        2l9D0Ghl/tmWpCq91jiDwRZYJOE1EiNv0bi7thh7I9/a/Eo2IVUrRxhgB7iZVztNsYtu2mtrQ1v68
        O6ZYVXcWVBnwgtA/+GTApJ9hYn4Q0czM01Y2Sfbu1S15GtVzV/zQeg5xTR5m8v2ff2qQyKWzBiPwG
        aICN/mCxeoNJNEeODenCTbrNaWQAmOAe3t+DlmcOBT5VxUJTE0G0W+fcV/X8RcabRnx5FyF1yOVkD
        5Kq/we5w==;
Received: from [31.132.33.241] (port=54168 helo=localhost.localdomain)
        by svr21.theemailshop.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <T.E.Baldwin99@members.leeds.ac.uk>)
        id 1lIFrp-0009jP-Sm; Fri, 05 Mar 2021 19:12:05 +0000
From:   Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
To:     tim@majoroak.me.uk
Cc:     Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH] arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)
Date:   Fri,  5 Mar 2021 19:12:05 +0000
Message-Id: <20210305191205.2239589-1-T.E.Baldwin99@members.leeds.ac.uk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210301131000.avqjoi4vousakiq2@bogus>
References: <20210301131000.avqjoi4vousakiq2@bogus>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - svr21.theemailshop.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - members.leeds.ac.uk
X-Get-Message-Sender-Via: svr21.theemailshop.co.uk: authenticated_id: tim@majoroak.me.uk
X-Authenticated-Sender: svr21.theemailshop.co.uk: tim@majoroak.me.uk
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit df84fe94708985cdfb78a83148322bcd0a699472 upstream.

Backported to Linux 5.4 by changing "return NO_SYSCALL" to "return -1"
in patch context.

Since commit f086f67485c5 ("arm64: ptrace: add support for syscall
emulation"), if system call number -1 is called and the process is being
traced with PTRACE_SYSCALL, for example by strace, the seccomp check is
skipped and -ENOSYS is returned unconditionally (unless altered by the
tracer) rather than carrying out action specified in the seccomp filter.

The consequence of this is that it is not possible to reliably strace
a seccomp based implementation of a foreign system call interface in
which r7/x8 is permitted to be -1 on entry to a system call.

Also trace_sys_enter and audit_syscall_entry are skipped if a system
call is skipped.

Fix by removing the in_syscall(regs) check restoring the previous
behaviour which is like AArch32, x86 (which uses generic code) and
everything else.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Fixes: f086f67485c5 ("arm64: ptrace: add support for syscall emulation")
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
Link: https://lore.kernel.org/r/90edd33b-6353-1228-791f-0336d94d5f8c@majoroak.me.uk
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 30b877f8b85e..0cfd68577489 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1844,7 +1844,7 @@ int syscall_trace_enter(struct pt_regs *regs)
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
-		if (!in_syscall(regs) || (flags & _TIF_SYSCALL_EMU))
+		if (flags & _TIF_SYSCALL_EMU)
 			return -1;
 	}
 
-- 
2.27.0

