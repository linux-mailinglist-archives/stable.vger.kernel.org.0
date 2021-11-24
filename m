Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3E45C648
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351563AbhKXOGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356557AbhKXOE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D98E6335B;
        Wed, 24 Nov 2021 13:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759490;
        bh=HtLgXUO4bcEZdiWz+WrqF/fvocMQ1RU/S8Yp2K/eZn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjX5GZBFS8Uly9ZfSB5ZMSRd4YWrvBOAG5WinHD62rFdFEtth8JUiU8vkc5GjQrXt
         4sUCAXsfPFpu1+NH8BiXLiT+d4nHBL6jBgqZhDKPrfo1RnKGlYAa7M5udfg/fx1A9D
         PARN6qIkdZgf0MEYmtWKY+23F+dyUnOST+EkXDo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 258/279] signal/powerpc: On swapcontext failure force SIGSEGV
Date:   Wed, 24 Nov 2021 12:59:05 +0100
Message-Id: <20211124115727.632627138@linuxfoundation.org>
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

commit 83a1f27ad773b1d8f0460d3a676114c7651918cc upstream.

If the register state may be partial and corrupted instead of calling
do_exit, call force_sigsegv(SIGSEGV).  Which properly kills the
process with SIGSEGV and does not let any more userspace code execute,
instead of just killing one thread of the process and potentially
confusing everything.

Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
History-tree: git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Fixes: 756f1ae8a44e ("PPC32: Rework signal code and add a swapcontext system call.")
Fixes: 04879b04bf50 ("[PATCH] ppc64: VMX (Altivec) support & signal32 rework, from Ben Herrenschmidt")
Link: https://lkml.kernel.org/r/20211020174406.17889-7-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/signal_32.c |    6 ++++--
 arch/powerpc/kernel/signal_64.c |    9 ++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1062,8 +1062,10 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 	 * or if another thread unmaps the region containing the context.
 	 * We kill the task with a SIGSEGV in this situation.
 	 */
-	if (do_setcontext(new_ctx, regs, 0))
-		do_exit(SIGSEGV);
+	if (do_setcontext(new_ctx, regs, 0)) {
+		force_sigsegv(SIGSEGV);
+		return -EFAULT;
+	}
 
 	set_thread_flag(TIF_RESTOREALL);
 	return 0;
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -703,15 +703,18 @@ SYSCALL_DEFINE3(swapcontext, struct ucon
 	 * We kill the task with a SIGSEGV in this situation.
 	 */
 
-	if (__get_user_sigset(&set, &new_ctx->uc_sigmask))
-		do_exit(SIGSEGV);
+	if (__get_user_sigset(&set, &new_ctx->uc_sigmask)) {
+		force_sigsegv(SIGSEGV);
+		return -EFAULT;
+	}
 	set_current_blocked(&set);
 
 	if (!user_read_access_begin(new_ctx, ctx_size))
 		return -EFAULT;
 	if (__unsafe_restore_sigcontext(current, NULL, 0, &new_ctx->uc_mcontext)) {
 		user_read_access_end();
-		do_exit(SIGSEGV);
+		force_sigsegv(SIGSEGV);
+		return -EFAULT;
 	}
 	user_read_access_end();
 


