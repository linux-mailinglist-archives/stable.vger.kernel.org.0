Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3CD33BA99
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhCOOJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhCOOER (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:04:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9004564F38;
        Mon, 15 Mar 2021 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817056;
        bh=Rb98AK30FXTm91FB/fPYfEtlEV6qY9o2F3vFXCJscBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxrpORJtvXa76yzrr48QNJg/cPOzYguewzN//g/YI67bzp9Eum4AtHRhVGv9aY++i
         Qf7tGCxmEodJLsVGlbWxtdsvegMV18KGTxRlTr/fXpKcfK30EXb1FBwy7ucigPJVXo
         8t8z13uY/VAgovjAKU6nJb0Ka38jW624JE3luVc8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 266/290] powerpc: Fix inverted SET_FULL_REGS bitop
Date:   Mon, 15 Mar 2021 14:55:59 +0100
Message-Id: <20210315135551.011066306@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nicholas Piggin <npiggin@gmail.com>

commit 73ac79881804eed2e9d76ecdd1018037f8510cb1 upstream.

This bit operation was inverted and set the low bit rather than
cleared it, breaking the ability to ptrace non-volatile GPRs after
exec. Fix.

Only affects 64e and 32-bit.

Fixes: feb9df3462e6 ("powerpc/64s: Always has full regs, so remove remnant checks")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210308085530.3191843-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ptrace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -193,7 +193,7 @@ extern int ptrace_put_reg(struct task_st
 #define TRAP_FLAGS_MASK		0x11
 #define TRAP(regs)		((regs)->trap & ~TRAP_FLAGS_MASK)
 #define FULL_REGS(regs)		(((regs)->trap & 1) == 0)
-#define SET_FULL_REGS(regs)	((regs)->trap |= 1)
+#define SET_FULL_REGS(regs)	((regs)->trap &= ~1)
 #endif
 #define CHECK_FULL_REGS(regs)	BUG_ON(!FULL_REGS(regs))
 #define NV_REG_POISON		0xdeadbeefdeadbeefUL
@@ -208,7 +208,7 @@ extern int ptrace_put_reg(struct task_st
 #define TRAP_FLAGS_MASK		0x1F
 #define TRAP(regs)		((regs)->trap & ~TRAP_FLAGS_MASK)
 #define FULL_REGS(regs)		(((regs)->trap & 1) == 0)
-#define SET_FULL_REGS(regs)	((regs)->trap |= 1)
+#define SET_FULL_REGS(regs)	((regs)->trap &= ~1)
 #define IS_CRITICAL_EXC(regs)	(((regs)->trap & 2) != 0)
 #define IS_MCHECK_EXC(regs)	(((regs)->trap & 4) != 0)
 #define IS_DEBUG_EXC(regs)	(((regs)->trap & 8) != 0)


