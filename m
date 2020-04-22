Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB151B3D1B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgDVKLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729222AbgDVKLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DF012075A;
        Wed, 22 Apr 2020 10:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550297;
        bh=nlNAtfmE+7sDz1jRnaVYI4GkYHewHV8jPnDsjl9aIu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBedhuleAVhNbBtdgzsrzxfPi6OqfLAXW0kooXefC9yRyBytu2OzU96T9a5136s4+
         G30a1PIAEDQF7YsLOOhSaNgxJER3FTGtvRNM8oEAMrG/+yy3F7xumnWo9YCa/rWU01
         MhDOcHOIGca80cBJunIL2StKVeOTzCuDNUGFokAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 088/199] powerpc/64/tm: Dont let userspace set regs->trap via sigreturn
Date:   Wed, 22 Apr 2020 11:56:54 +0200
Message-Id: <20200422095106.887852619@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit c7def7fbdeaa25feaa19caf4a27c5d10bd8789e4 upstream.

In restore_tm_sigcontexts() we take the trap value directly from the
user sigcontext with no checking:

	err |= __get_user(regs->trap, &sc->gp_regs[PT_TRAP]);

This means we can be in the kernel with an arbitrary regs->trap value.

Although that's not immediately problematic, there is a risk we could
trigger one of the uses of CHECK_FULL_REGS():

	#define CHECK_FULL_REGS(regs)	BUG_ON(regs->trap & 1)

It can also cause us to unnecessarily save non-volatile GPRs again in
save_nvgprs(), which shouldn't be problematic but is still wrong.

It's also possible it could trick the syscall restart machinery, which
relies on regs->trap not being == 0xc00 (see 9a81c16b5275 ("powerpc:
fix double syscall restarts")), though I haven't been able to make
that happen.

Finally it doesn't match the behaviour of the non-TM case, in
restore_sigcontext() which zeroes regs->trap.

So change restore_tm_sigcontexts() to zero regs->trap.

This was discovered while testing Nick's upcoming rewrite of the
syscall entry path. In that series the call to save_nvgprs() prior to
signal handling (do_notify_resume()) is removed, which leaves the
low-bit of regs->trap uncleared which can then trigger the FULL_REGS()
WARNs in setup_tm_sigcontexts().

Fixes: 2b0a576d15e0 ("powerpc: Add new transactional memory state to the signal context")
Cc: stable@vger.kernel.org # v3.9+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200401023836.3286664-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/signal_64.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -469,8 +469,10 @@ static long restore_tm_sigcontexts(struc
 	err |= __get_user(tsk->thread.ckpt_regs.ccr,
 			  &sc->gp_regs[PT_CCR]);
 
+	/* Don't allow userspace to set the trap value */
+	regs->trap = 0;
+
 	/* These regs are not checkpointed; they can go in 'regs'. */
-	err |= __get_user(regs->trap, &sc->gp_regs[PT_TRAP]);
 	err |= __get_user(regs->dar, &sc->gp_regs[PT_DAR]);
 	err |= __get_user(regs->dsisr, &sc->gp_regs[PT_DSISR]);
 	err |= __get_user(regs->result, &sc->gp_regs[PT_RESULT]);


