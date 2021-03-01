Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80954328C5E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbhCASuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239107AbhCASoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 562BB6525B;
        Mon,  1 Mar 2021 17:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619710;
        bh=TGmsIkonSlL6CLU2vGKsEzCDPcXORtC9nd7WyseilKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1cT+neqtrMSpir2HNfEROyW2aRleTRYt8l9zfFfgiWiw9wBcPf9aRK/6DfPRKe4M
         cVkiSh6niYY7LZ1Hzyc7vT4G0vHJ4Ue2xnmYT9bU02fTDsZOc0uUm+SvWJHdGK3aj3
         7Hu5uhb/g0bXmUzFueh1o8PUY0TLjpZYPDmjGoPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 552/663] arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)
Date:   Mon,  1 Mar 2021 17:13:20 +0100
Message-Id: <20210301161209.186346098@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>

commit df84fe94708985cdfb78a83148322bcd0a699472 upstream.

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
Cc: Catalin Marinas<catalin.marinas@arm.com>
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
 arch/arm64/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1799,7 +1799,7 @@ int syscall_trace_enter(struct pt_regs *
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
-		if (!in_syscall(regs) || (flags & _TIF_SYSCALL_EMU))
+		if (flags & _TIF_SYSCALL_EMU)
 			return NO_SYSCALL;
 	}
 


