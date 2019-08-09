Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FB087BFD
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407091AbfHINqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436543AbfHINqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C42621773;
        Fri,  9 Aug 2019 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358397;
        bh=N84LXan8RF73ksNujkrM9YmqGJ0e0sGU1lfU1OBoylM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQLVRWePzhSafzx+kq1eCDua7LXoPYUkBF5k2zQkVOFMn+n20vxK3t+pTeCqZefVE
         LyQd6rT8GdKdyNB4/VYMncH4T4BmErMU0RvnBwF1m83HMkYXlW9pAs+pagg8GCiQ+e
         P7lamaEn5jjfLoyOXwZEyCyfDcucaQ9n4WlkFyxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpeng.li@hotmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 17/21] x86/entry/64: Fix context tracking state warning when load_gs_index fails
Date:   Fri,  9 Aug 2019 15:45:21 +0200
Message-Id: <20190809134242.281419373@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpeng.li@hotmail.com>

commit 2fa5f04f85730d0c4f49f984b7efeb4f8d5bd1fc upstream.

This warning:

 WARNING: CPU: 0 PID: 3331 at arch/x86/entry/common.c:45 enter_from_user_mode+0x32/0x50
 CPU: 0 PID: 3331 Comm: ldt_gdt_64 Not tainted 4.8.0-rc7+ #13
 Call Trace:
  dump_stack+0x99/0xd0
  __warn+0xd1/0xf0
  warn_slowpath_null+0x1d/0x20
  enter_from_user_mode+0x32/0x50
  error_entry+0x6d/0xc0
  ? general_protection+0x12/0x30
  ? native_load_gs_index+0xd/0x20
  ? do_set_thread_area+0x19c/0x1f0
  SyS_set_thread_area+0x24/0x30
  do_int80_syscall_32+0x7c/0x220
  entry_INT80_compat+0x38/0x50

... can be reproduced by running the GS testcase of the ldt_gdt test unit in
the x86 selftests.

do_int80_syscall_32() will call enter_form_user_mode() to convert context
tracking state from user state to kernel state. The load_gs_index() call
can fail with user gsbase, gsbase will be fixed up and proceed if this
happen.

However, enter_from_user_mode() will be called again in the fixed up path
though it is context tracking kernel state currently.

This patch fixes it by just fixing up gsbase and telling lockdep that IRQs
are off once load_gs_index() failed with user gsbase.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1475197266-3440-1-git-send-email-wanpeng.li@hotmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1133,7 +1133,6 @@ ENTRY(error_entry)
 	testb	$3, CS+8(%rsp)
 	jz	.Lerror_kernelspace
 
-.Lerror_entry_from_usermode_swapgs:
 	/*
 	 * We entered from user mode or we're pretending to have entered
 	 * from user mode due to an IRET fault.
@@ -1177,7 +1176,8 @@ ENTRY(error_entry)
 	 * gsbase and proceed.  We'll fix up the exception and land in
 	 * gs_change's error handler with kernel gsbase.
 	 */
-	jmp	.Lerror_entry_from_usermode_swapgs
+	SWAPGS
+	jmp .Lerror_entry_done
 
 .Lbstep_iret:
 	/* Fix truncated RIP */


