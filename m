Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1232E5FC
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCEKQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhCEKQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 05:16:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B0CC061574;
        Fri,  5 Mar 2021 02:16:19 -0800 (PST)
Date:   Fri, 05 Mar 2021 10:16:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1614939376;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04a0H18vqlVyjuYMpzIQ3AUdAEbsDZ3RETQN/UKYFIs=;
        b=SaAiazyP7Dr21NPycWSv+FO2vziRF3n/93uJXdZoaDZgjWs2W3Ta2Y9Tt3dSozxdOjZPQ9
        RjfYacSwkVCl/ENFjQ/veO+v4A2OvCbKPjHrNhJg9LVurVRXhMc5M8jaqzNWkukAgiB9wP
        fU+U37TcBpV5gj2zZQC64OogYrh1oZZ0iaWXZIUslTuUU220MrjceoisJ5yZPA0nvVGrou
        zVF5ZprHC0fiOWwGg3T6lE3pUa4mUCj0bhN4vV0pwHTKQnRqRsdGdLt1Undq/cKZFDI9AG
        McceutUGCYPDOaJeT0l3XHtBeFxLqF2Y4yA4zz8HkMm5gy2L0EMx7WnAM0+cig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1614939376;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04a0H18vqlVyjuYMpzIQ3AUdAEbsDZ3RETQN/UKYFIs=;
        b=YQOb34SeftEK6dssbdyJq3YlthyYu33kM38rQ5XHjGWt8i6Zcrt1TkgRGp1hr8WGQUttoW
        7Sza71QrH6+YKUAA==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/entry: Fix entry/exit mismatch on failed fast
 32-bit syscalls
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
References: <8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <161493937508.398.8936209544992148886.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     dabf017539988a9bfc40a38dbafd35c501bacc44
Gitweb:        https://git.kernel.org/tip/dabf017539988a9bfc40a38dbafd35c501bacc44
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Thu, 04 Mar 2021 11:05:54 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Fri, 05 Mar 2021 11:10:13 +01:00

x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls

On a 32-bit fast syscall that fails to read its arguments from user
memory, the kernel currently does syscall exit work but not
syscall entry work.  This confuses audit and ptrace.  For example:

    $ ./tools/testing/selftests/x86/syscall_arg_fault_32
    ...
    strace: pid 264258: entering, ptrace_syscall_info.op == 2
    ...

This is a minimal fix intended for ease of backporting.  A more
complete cleanup is coming.

Fixes: 0b085e68f407 ("x86/entry: Consolidate 32/64 bit syscall entry")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org

---
 arch/x86/entry/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index a2433ae..4efd39a 100644
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
 
