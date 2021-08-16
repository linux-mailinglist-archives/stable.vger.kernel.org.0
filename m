Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99983ED6A4
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbhHPNWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239174AbhHPNUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 313CD610E8;
        Mon, 16 Aug 2021 13:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119775;
        bh=lxOA3aSuWyHKSpNa7tRacuT9qo1x35lqn6tdw+aPyC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVStAgEBeNsRfub8rGSwFA7oupE+U4P+uALcq3Kn3zNlSAHiWPTRIaTxZsxiMcHLK
         RI098OzvupSjyeuEzyjCfN+W3Zpht9NCv7tQNiI1qYbNpmTCs55UeIcGhEpDrgGzrV
         669hyGxz6x/P8eIYo7qlGQXioXGDqqfgkSs+DmhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 136/151] powerpc/interrupt: Do not call single_step_exception() from other exceptions
Date:   Mon, 16 Aug 2021 15:02:46 +0200
Message-Id: <20210816125448.532135780@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 01fcac8e4dfc112f420dcaeb70056a74e326cacf upstream.

single_step_exception() is called by emulate_single_step() which
is called from (at least) alignment exception() handler and
program_check_exception() handler.

Redefine it as a regular __single_step_exception() which is called
by both single_step_exception() handler and emulate_single_step()
function.

Fixes: 3a96570ffceb ("powerpc: convert interrupt handlers to use wrappers")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/aed174f5cbc06f2cf95233c071d8aac948e46043.1628611921.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/traps.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1103,7 +1103,7 @@ DEFINE_INTERRUPT_HANDLER(RunModeExceptio
 	_exception(SIGTRAP, regs, TRAP_UNK, 0);
 }
 
-DEFINE_INTERRUPT_HANDLER(single_step_exception)
+static void __single_step_exception(struct pt_regs *regs)
 {
 	clear_single_step(regs);
 	clear_br_trace(regs);
@@ -1120,6 +1120,11 @@ DEFINE_INTERRUPT_HANDLER(single_step_exc
 	_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
 }
 
+DEFINE_INTERRUPT_HANDLER(single_step_exception)
+{
+	__single_step_exception(regs);
+}
+
 /*
  * After we have successfully emulated an instruction, we have to
  * check if the instruction was being single-stepped, and if so,
@@ -1129,7 +1134,7 @@ DEFINE_INTERRUPT_HANDLER(single_step_exc
 static void emulate_single_step(struct pt_regs *regs)
 {
 	if (single_stepping(regs))
-		single_step_exception(regs);
+		__single_step_exception(regs);
 }
 
 static inline int __parse_fpscr(unsigned long fpscr)


