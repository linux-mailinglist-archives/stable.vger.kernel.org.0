Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F3024F1F1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 06:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHXE25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 00:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgHXE25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 00:28:57 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469CDC061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 21:28:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q93so2787131pjq.0
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 21:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0WmpjOZ37dqQWtX1ElzM79V03NmaeCvIccYyyNLVEk=;
        b=J4Pk3DEc4f2i40lu3T99CUOsiI5J75zKaYvsJZI8pzK8Nso7SDH0Qe5NM+oFT+ufjG
         k3O9fnKX9YntY7oW5DpDwuv2OzIaJt7ufWdudpjC4/upDYOUHqvUFS/8opBkmcJl4/yo
         c7GjABKPezsopXdHPQtZ/ZCjF9Zy6tq8m636M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0WmpjOZ37dqQWtX1ElzM79V03NmaeCvIccYyyNLVEk=;
        b=WIfRiWw4hw6mnV0bsZTgQp2qpMG7cI0IMoni7SE8T+1c9t0d7r/NJC/M8AUF8vhITg
         hEt+/IW/AAVeK6wcRobmOC7c9E61XhUZjQ1pqqkOP91nal90Rru+jf2dfcC1rwcaEI21
         blHXzRudf2Id11nUNqFlksWNnDndNaUsUCNqabDE/MIvYLBDhpndFylc7ANTFMAA5Lxd
         WwdqPgGAA/KgYniYyziTJ9VVOexT1nsW4LOrTowDzAhZQmEN7u64hY7arS27qk5hxG32
         tWy5bjnmJeE+UZllmG7pyHLSS6NQpfUagOIzRPdcJucEFmOFjxTQnEJTwhc5QN0WKXLh
         GSNg==
X-Gm-Message-State: AOAM532LOBI2dI+mRq92o30QIyN7wQhtBfhoZNRWH0PQGVh5w9WnVblt
        IUExEZNM5pInQ+peBSxYJNqxdI2n5AwtFw==
X-Google-Smtp-Source: ABdhPJxaygaIxZFYxFXDFVvDgSAGUWRbu8cr3+zmHzXkwgOK74wetbDPghgeAPA5h+Tqh4YynVO1Zg==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr2583672plc.70.1598243336389;
        Sun, 23 Aug 2020 21:28:56 -0700 (PDT)
Received: from localhost (2001-44b8-1113-6700-9c73-b98a-9ec7-960a.static.ipv6.internode.on.net. [2001:44b8:1113:6700:9c73:b98a:9ec7:960a])
        by smtp.gmail.com with ESMTPSA id d13sm9748674pfq.118.2020.08.23.21.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 21:28:55 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Tom Lane <tgl@sss.pgh.pa.us>, Daniel Axtens <dja@axtens.net>
Subject: [PATCH v4.9] powerpc: Allow 4224 bytes of stack expansion for the signal frame
Date:   Mon, 24 Aug 2020 14:28:51 +1000
Message-Id: <20200824042851.139162-1-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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
---
 arch/powerpc/mm/fault.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 2791f568bdb2..3e4fb430ae45 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -192,6 +192,9 @@ static int mm_fault_error(struct pt_regs *regs, unsigned long addr, int fault)
 	return MM_FAULT_CONTINUE;
 }
 
+// This comes from 64-bit struct rt_sigframe + __SIGNAL_FRAMESIZE
+#define SIGFRAME_MAX_SIZE	(4096 + 128)
+
 /*
  * For 600- and 800-family processors, the error_code parameter is DSISR
  * for a data fault, SRR1 for an instruction fault. For 400-family processors
@@ -341,7 +344,7 @@ int do_page_fault(struct pt_regs *regs, unsigned long address,
 	/*
 	 * N.B. The POWER/Open ABI allows programs to access up to
 	 * 288 bytes below the stack pointer.
-	 * The kernel signal delivery code writes up to about 1.5kB
+	 * The kernel signal delivery code writes up to about 4kB
 	 * below the stack pointer (r1) before decrementing it.
 	 * The exec code can write slightly over 640kB to the stack
 	 * before setting the user r1.  Thus we allow the stack to
@@ -365,7 +368,7 @@ int do_page_fault(struct pt_regs *regs, unsigned long address,
 		 * between the last mapped region and the stack will
 		 * expand the stack rather than segfaulting.
 		 */
-		if (address + 2048 < uregs->gpr[1] && !store_update_sp)
+		if (address + SIGFRAME_MAX_SIZE < uregs->gpr[1] && !store_update_sp)
 			goto bad_area;
 	}
 	if (expand_stack(vma, address))
-- 
2.25.1

