Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE34E33BAB7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbhCOOKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234655AbhCOOEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F8464F38;
        Mon, 15 Mar 2021 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817083;
        bh=lv+0TvJd6eDnBA65zQK+qLe6zQ/VSNK8Tkf105+Wgi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYqZvrhLGOpg0fGD7WrofLZtnzcYuY7quSFUZWFsRZIoBsq7PZKRMzilopcQs8cw6
         eOjf5s8yoC2OnC3ygKDdIeV8JPWcT2i6v8SmHLp8hSLc7683IZgSZHpDB1o7tM/24Q
         JSAfU1Wgk65l0WQUyZq5cfXrBgTM/+rDHjCzfqV0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.11 291/306] x86/entry: Fix entry/exit mismatch on failed fast 32-bit syscalls
Date:   Mon, 15 Mar 2021 14:55:54 +0100
Message-Id: <20210315135517.526776954@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Andy Lutomirski <luto@kernel.org>

commit 5d5675df792ff67e74a500c4c94db0f99e6a10ef upstream.

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
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/8c82296ddf803b91f8d1e5eac89e5803ba54ab0e.1614884673.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -128,7 +128,8 @@ static noinstr bool __do_fast_syscall_32
 		regs->ax = -EFAULT;
 
 		instrumentation_end();
-		syscall_exit_to_user_mode(regs);
+		local_irq_disable();
+		irqentry_exit_to_user_mode(regs);
 		return false;
 	}
 


