Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59761E2CBE
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391485AbgEZTRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392194AbgEZTOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854DE208B6;
        Tue, 26 May 2020 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520483;
        bh=+CcGc1ePsAEy4vbCoNwEklXLyLYAmR7rlXdXCWM57Is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adaos+ajNlz0M/auPW+kLOxzpSf12qRFk1IWPowfesM3u+fR5NPiT487tJAxjiWsU
         lTdoJWxf1T5pGoeJADIyv1k5dBsjvMWd94G3CcYF1hvmjhSDrg5bhI1SUMhOIwLUB0
         8cBjAkXo+dRCH90QTjiez3nKc3q4z49ZXK3RZ7dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keno Fischer <keno@juliacomputing.com>,
        Will Deacon <will@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>, Bin Lu <Bin.Lu@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.6 070/126] arm64: Fix PTRACE_SYSEMU semantics
Date:   Tue, 26 May 2020 20:53:27 +0200
Message-Id: <20200526183944.066155821@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keno Fischer <keno@juliacomputing.com>

commit 1cf6022bd9161081215028203919c33fcfa6debb upstream.

Quoth the man page:
```
       If the tracee was restarted by PTRACE_SYSCALL or PTRACE_SYSEMU, the
       tracee enters syscall-enter-stop just prior to entering any system
       call (which will not be executed if the restart was using
       PTRACE_SYSEMU, regardless of any change made to registers at this
       point or how the tracee is restarted after this stop).
```

The parenthetical comment is currently true on x86 and powerpc,
but not currently true on arm64. arm64 re-checks the _TIF_SYSCALL_EMU
flag after the syscall entry ptrace stop. However, at this point,
it reflects which method was used to re-start the syscall
at the entry stop, rather than the method that was used to reach it.
Fix that by recording the original flag before performing the ptrace
stop, bringing the behavior in line with documentation and x86/powerpc.

Fixes: f086f67485c5 ("arm64: ptrace: add support for syscall emulation")
Cc: <stable@vger.kernel.org> # 5.3.x-
Signed-off-by: Keno Fischer <keno@juliacomputing.com>
Acked-by: Will Deacon <will@kernel.org>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Bin Lu <Bin.Lu@arm.com>
[catalin.marinas@arm.com: moved 'flags' bit masking]
[catalin.marinas@arm.com: changed 'flags' type to unsigned long]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/ptrace.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1829,10 +1829,11 @@ static void tracehook_report_syscall(str
 
 int syscall_trace_enter(struct pt_regs *regs)
 {
-	if (test_thread_flag(TIF_SYSCALL_TRACE) ||
-		test_thread_flag(TIF_SYSCALL_EMU)) {
+	unsigned long flags = READ_ONCE(current_thread_info()->flags);
+
+	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
-		if (!in_syscall(regs) || test_thread_flag(TIF_SYSCALL_EMU))
+		if (!in_syscall(regs) || (flags & _TIF_SYSCALL_EMU))
 			return -1;
 	}
 


