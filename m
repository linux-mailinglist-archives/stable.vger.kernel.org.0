Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F773C24DF
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhGINZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232711AbhGINZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5497C6128A;
        Fri,  9 Jul 2021 13:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836950;
        bh=XdEth1K/4h0Z+rdxiuT52VBnTCiRBD9wLtTaRLnUIG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VT6/qXdLwPHAuf2l3QxvFNotdHV9P4pHw+hN7Uv1a3aipG09xc66oLNgX5Ezxmi/X
         e18ff0ZjRNIYC+Ce7qVFhXdWuO8rvyZg9uTikaK93kIDDlccNTj6mDmddnZK1hzY9j
         46Awhi4Cmg0lbzYoozyvZLYXKKX8vBEHBd6sdaME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sid Manning <sidneym@codeaurora.org>,
        Brian Cain <bcain@codeaurora.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.12 01/11] Hexagon: fix build errors
Date:   Fri,  9 Jul 2021 15:21:38 +0200
Message-Id: <20210709131552.000556712@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sid Manning <sidneym@codeaurora.org>

commit 788dcee0306e1bdbae1a76d1b3478bb899c5838e upstream.

Fix type-o in ptrace.c.
Add missing include: asm/hexagon_vm.h
Remove superfluous cast.
Replace 'p3_0' with 'preds'.

Signed-off-by: Sid Manning <sidneym@codeaurora.org>
Add -mlong-calls to build flags.
Signed-off-by: Brian Cain <bcain@codeaurora.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/hexagon/Makefile            |    3 +++
 arch/hexagon/include/asm/timex.h |    3 ++-
 arch/hexagon/kernel/ptrace.c     |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/hexagon/Makefile
+++ b/arch/hexagon/Makefile
@@ -10,6 +10,9 @@ LDFLAGS_vmlinux += -G0
 # Do not use single-byte enums; these will overflow.
 KBUILD_CFLAGS += -fno-short-enums
 
+# We must use long-calls:
+KBUILD_CFLAGS += -mlong-calls
+
 # Modules must use either long-calls, or use pic/plt.
 # Use long-calls for now, it's easier.  And faster.
 # KBUILD_CFLAGS_MODULE += -fPIC
--- a/arch/hexagon/include/asm/timex.h
+++ b/arch/hexagon/include/asm/timex.h
@@ -8,6 +8,7 @@
 
 #include <asm-generic/timex.h>
 #include <asm/timer-regs.h>
+#include <asm/hexagon_vm.h>
 
 /* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
 #define CLOCK_TICK_RATE              TCX0_CLK_RATE
@@ -16,7 +17,7 @@
 
 static inline int read_current_timer(unsigned long *timer_val)
 {
-	*timer_val = (unsigned long) __vmgettime();
+	*timer_val = __vmgettime();
 	return 0;
 }
 
--- a/arch/hexagon/kernel/ptrace.c
+++ b/arch/hexagon/kernel/ptrace.c
@@ -35,7 +35,7 @@ void user_disable_single_step(struct tas
 
 static int genregs_get(struct task_struct *target,
 		   const struct user_regset *regset,
-		   srtuct membuf to)
+		   struct membuf to)
 {
 	struct pt_regs *regs = task_pt_regs(target);
 
@@ -54,7 +54,7 @@ static int genregs_get(struct task_struc
 	membuf_store(&to, regs->m0);
 	membuf_store(&to, regs->m1);
 	membuf_store(&to, regs->usr);
-	membuf_store(&to, regs->p3_0);
+	membuf_store(&to, regs->preds);
 	membuf_store(&to, regs->gp);
 	membuf_store(&to, regs->ugp);
 	membuf_store(&to, pt_elr(regs)); // pc


