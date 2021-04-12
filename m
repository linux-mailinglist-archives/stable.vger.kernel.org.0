Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3003535C097
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbhDLJOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240891AbhDLJLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 292736139F;
        Mon, 12 Apr 2021 09:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218432;
        bh=n5WJa8ngEv7bEquikRAerBZToMl/YvbocI+gERKY1hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8XbyaseH5t6zvMRdwCy/HCHQ4ZSvi3XEN4ckIAHnPBMPLDNgBmMih+5sd32JIumB
         fye/AZGUdOSB4dxjgf7SMKISMEswOp4CjTZhR6jmjOuyTnyIVD0bY6PlSeklGt3Oz4
         Y8q1JZg2/t5DoPck2J/eeRrlODEIZNsrqvRoQ2OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Tai <thomas.tai@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 5.11 195/210] x86/traps: Correct exc_general_protection() and math_error() return paths
Date:   Mon, 12 Apr 2021 10:41:40 +0200
Message-Id: <20210412084022.506578942@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Tai <thomas.tai@oracle.com>

commit 632a1c209b8773cb0119fe3aada9f1db14fa357c upstream.

Commit

  334872a09198 ("x86/traps: Attempt to fixup exceptions in vDSO before signaling")

added return statements which bypass calling cond_local_irq_disable().

According to

  ca4c6a9858c2 ("x86/traps: Make interrupt enable/disable symmetric in C code"),

cond_local_irq_disable() is needed because the asm return code no longer
disables interrupts. Follow the existing code as an example to use "goto
exit" instead of "return" statement.

 [ bp: Massage commit message. ]

Fixes: 334872a09198 ("x86/traps: Attempt to fixup exceptions in vDSO before signaling")
Signed-off-by: Thomas Tai <thomas.tai@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Link: https://lkml.kernel.org/r/1617902914-83245-1-git-send-email-thomas.tai@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -556,7 +556,7 @@ DEFINE_IDTENTRY_ERRORCODE(exc_general_pr
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
 		if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
-			return;
+			goto exit;
 
 		show_signal(tsk, SIGSEGV, "", desc, regs, error_code);
 		force_sig(SIGSEGV);
@@ -1057,7 +1057,7 @@ static void math_error(struct pt_regs *r
 		goto exit;
 
 	if (fixup_vdso_exception(regs, trapnr, 0, 0))
-		return;
+		goto exit;
 
 	force_sig_fault(SIGFPE, si_code,
 			(void __user *)uprobe_get_trap_addr(regs));


