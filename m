Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F4524F58C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgHXIuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729697AbgHXIud (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:50:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE62E2075B;
        Mon, 24 Aug 2020 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259032;
        bh=KI4nHsoMqAoZx3i9lJvTrT3QIhvE7d2/J9/s0nvnO98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzQ4N27ZjScAQQLeugF1frRvpTwI+T86s88YG7rYu0AOmGvHmgcP5GJZgZS+wqh0M
         WGwlEH4E1/hSOPmMbEXJEwpJtfQJhWsjyBpt/0733TZlIep4L8fcGTD/K0a10DdQpv
         89ESHFGqXe/srMgZKKdMESlGLLYDf0DLohwOusy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lane <tgl@sss.pgh.pa.us>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 28/33] powerpc: Allow 4224 bytes of stack expansion for the signal frame
Date:   Mon, 24 Aug 2020 10:31:24 +0200
Message-Id: <20200824082347.948251307@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082346.498653578@linuxfoundation.org>
References: <20200824082346.498653578@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 63dee5df43a31f3844efabc58972f0a206ca4534 upstream.

We have powerpc specific logic in our page fault handling to decide if
an access to an unmapped address below the stack pointer should expand
the stack VMA.

The code was originally added in 2004 "ported from 2.4". The rough
logic is that the stack is allowed to grow to 1MB with no extra
checking. Over 1MB the access must be within 2048 bytes of the stack
pointer, or be from a user instruction that updates the stack pointer.

The 2048 byte allowance below the stack pointer is there to cover the
288 byte "red zone" as well as the "about 1.5kB" needed by the signal
delivery code.

Unfortunately since then the signal frame has expanded, and is now
4224 bytes on 64-bit kernels with transactional memory enabled. This
means if a process has consumed more than 1MB of stack, and its stack
pointer lies less than 4224 bytes from the next page boundary, signal
delivery will fault when trying to expand the stack and the process
will see a SEGV.

The total size of the signal frame is the size of struct rt_sigframe
(which includes the red zone) plus __SIGNAL_FRAMESIZE (128 bytes on
64-bit).

The 2048 byte allowance was correct until 2008 as the signal frame
was:

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1440 */
        /* --- cacheline 11 boundary (1408 bytes) was 32 bytes ago --- */
        long unsigned int          _unused[2];           /*  1440    16 */
        unsigned int               tramp[6];             /*  1456    24 */
        struct siginfo *           pinfo;                /*  1480     8 */
        void *                     puc;                  /*  1488     8 */
        struct siginfo     info;                         /*  1496   128 */
        /* --- cacheline 12 boundary (1536 bytes) was 88 bytes ago --- */
        char                       abigap[288];          /*  1624   288 */

        /* size: 1920, cachelines: 15, members: 7 */
        /* padding: 8 */
};

1920 + 128 = 2048

Then in commit ce48b2100785 ("powerpc: Add VSX context save/restore,
ptrace and signal support") (Jul 2008) the signal frame expanded to
2304 bytes:

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1696 */	<--
        /* --- cacheline 13 boundary (1664 bytes) was 32 bytes ago --- */
        long unsigned int          _unused[2];           /*  1696    16 */
        unsigned int               tramp[6];             /*  1712    24 */
        struct siginfo *           pinfo;                /*  1736     8 */
        void *                     puc;                  /*  1744     8 */
        struct siginfo     info;                         /*  1752   128 */
        /* --- cacheline 14 boundary (1792 bytes) was 88 bytes ago --- */
        char                       abigap[288];          /*  1880   288 */

        /* size: 2176, cachelines: 17, members: 7 */
        /* padding: 8 */
};

2176 + 128 = 2304

At this point we should have been exposed to the bug, though as far as
I know it was never reported. I no longer have a system old enough to
easily test on.

Then in 2010 commit 320b2b8de126 ("mm: keep a guard page below a
grow-down stack segment") caused our stack expansion code to never
trigger, as there was always a VMA found for a write up to PAGE_SIZE
below r1.

That meant the bug was hidden as we continued to expand the signal
frame in commit 2b0a576d15e0 ("powerpc: Add new transactional memory
state to the signal context") (Feb 2013):

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1696 */
        /* --- cacheline 13 boundary (1664 bytes) was 32 bytes ago --- */
        struct ucontext    uc_transact;                  /*  1696  1696 */	<--
        /* --- cacheline 26 boundary (3328 bytes) was 64 bytes ago --- */
        long unsigned int          _unused[2];           /*  3392    16 */
        unsigned int               tramp[6];             /*  3408    24 */
        struct siginfo *           pinfo;                /*  3432     8 */
        void *                     puc;                  /*  3440     8 */
        struct siginfo     info;                         /*  3448   128 */
        /* --- cacheline 27 boundary (3456 bytes) was 120 bytes ago --- */
        char                       abigap[288];          /*  3576   288 */

        /* size: 3872, cachelines: 31, members: 8 */
        /* padding: 8 */
        /* last cacheline: 32 bytes */
};

3872 + 128 = 4000

And commit 573ebfa6601f ("powerpc: Increase stack redzone for 64-bit
userspace to 512 bytes") (Feb 2014):

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1696 */
        /* --- cacheline 13 boundary (1664 bytes) was 32 bytes ago --- */
        struct ucontext    uc_transact;                  /*  1696  1696 */
        /* --- cacheline 26 boundary (3328 bytes) was 64 bytes ago --- */
        long unsigned int          _unused[2];           /*  3392    16 */
        unsigned int               tramp[6];             /*  3408    24 */
        struct siginfo *           pinfo;                /*  3432     8 */
        void *                     puc;                  /*  3440     8 */
        struct siginfo     info;                         /*  3448   128 */
        /* --- cacheline 27 boundary (3456 bytes) was 120 bytes ago --- */
        char                       abigap[512];          /*  3576   512 */	<--

        /* size: 4096, cachelines: 32, members: 8 */
        /* padding: 8 */
};

4096 + 128 = 4224

Then finally in 2017, commit 1be7107fbe18 ("mm: larger stack guard
gap, between vmas") exposed us to the existing bug, because it changed
the stack VMA to be the correct/real size, meaning our stack expansion
code is now triggered.

Fix it by increasing the allowance to 4224 bytes.

Hard-coding 4224 is obviously unsafe against future expansions of the
signal frame in the same way as the existing code. We can't easily use
sizeof() because the signal frame structure is not in a header. We
will either fix that, or rip out all the custom stack expansion
checking logic entirely.

Fixes: ce48b2100785 ("powerpc: Add VSX context save/restore, ptrace and signal support")
Cc: stable@vger.kernel.org # v2.6.27+
Reported-by: Tom Lane <tgl@sss.pgh.pa.us>
Tested-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200724092528.1578671-2-mpe@ellerman.id.au
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/fault.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -192,6 +192,9 @@ static int mm_fault_error(struct pt_regs
 	return MM_FAULT_CONTINUE;
 }
 
+// This comes from 64-bit struct rt_sigframe + __SIGNAL_FRAMESIZE
+#define SIGFRAME_MAX_SIZE	(4096 + 128)
+
 /*
  * For 600- and 800-family processors, the error_code parameter is DSISR
  * for a data fault, SRR1 for an instruction fault. For 400-family processors
@@ -341,7 +344,7 @@ retry:
 	/*
 	 * N.B. The POWER/Open ABI allows programs to access up to
 	 * 288 bytes below the stack pointer.
-	 * The kernel signal delivery code writes up to about 1.5kB
+	 * The kernel signal delivery code writes up to about 4kB
 	 * below the stack pointer (r1) before decrementing it.
 	 * The exec code can write slightly over 640kB to the stack
 	 * before setting the user r1.  Thus we allow the stack to
@@ -365,7 +368,7 @@ retry:
 		 * between the last mapped region and the stack will
 		 * expand the stack rather than segfaulting.
 		 */
-		if (address + 2048 < uregs->gpr[1] && !store_update_sp)
+		if (address + SIGFRAME_MAX_SIZE < uregs->gpr[1] && !store_update_sp)
 			goto bad_area;
 	}
 	if (expand_stack(vma, address))


