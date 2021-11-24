Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3889345C68F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352429AbhKXOKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354079AbhKXOGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0BA961A8A;
        Wed, 24 Nov 2021 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759557;
        bh=TIJM1pxBBJ+mMUKMF2ObPNl1rqFzcxcbvLVor8dt0d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ws+KyHC/HIWBwluhG7UmCw28zSyqEmLXos8rUGLxsnLqWEwLvGtGj6jRhAfrfxVH6
         ODF7E3FKzSLRHrG6dInzzjk1Q40CsAyqvC6/4GTpQlSK3FlYo6Q1ciQx2/D/1dSi5b
         LM97+iycXT8z4y9GFuossLJOeztmSoZ4t/q6848I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, H Peter Anvin <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 262/279] signal/vm86_32: Properly send SIGSEGV when the vm86 state cannot be saved.
Date:   Wed, 24 Nov 2021 12:59:09 +0100
Message-Id: <20211124115727.763428513@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 1fbd60df8a852d9c55de8cd3621899cf4c72a5b7 upstream.

Update save_v86_state to always complete all of it's work except
possibly some of the copies to userspace even if save_v86_state takes
a fault.  This ensures that the kernel is always in a sane state, even
if userspace has done something silly.

When save_v86_state takes a fault update it to force userspace to take
a SIGSEGV and terminate the userspace application.

As Andy pointed out in review of the first version of this change
there are races between sigaction and the application terinating.  Now
that the code has been modified to always perform all save_v86_state's
work (except possibly copying to userspace) those races do not matter
from a kernel perspective.

Forcing the userspace application to terminate (by resetting it's
handler to SIGDFL) is there to keep everything as close to the current
behavior as possible while removing the unique (and difficult to
maintain) use of do_exit.

If this new SIGSEGV happens during handle_signal the next time around
the exit_to_user_mode_loop, SIGSEGV will be delivered to userspace.

All of the callers of handle_vm86_trap and handle_vm86_fault run the
exit_to_user_mode_loop before they return to userspace any signal sent
to the current task during their execution will be delivered to the
current task before that tasks exits to usermode.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
v1: https://lkml.kernel.org/r/20211020174406.17889-10-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/877de1xcr6.fsf_-_@disp2133
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/vm86_32.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -142,6 +142,7 @@ void save_v86_state(struct kernel_vm86_r
 
 	user_access_end();
 
+exit_vm86:
 	preempt_disable();
 	tsk->thread.sp0 = vm86->saved_sp0;
 	tsk->thread.sysenter_cs = __KERNEL_CS;
@@ -161,7 +162,8 @@ Efault_end:
 	user_access_end();
 Efault:
 	pr_alert("could not access userspace vm86 info\n");
-	do_exit(SIGSEGV);
+	force_sigsegv(SIGSEGV);
+	goto exit_vm86;
 }
 
 static int do_vm86_irq_handling(int subfunction, int irqnumber);


