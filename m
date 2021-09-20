Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9B9411168
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 10:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhITI4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 04:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234238AbhITI4R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 04:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5286160ED8;
        Mon, 20 Sep 2021 08:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632128090;
        bh=Xul3/hiouDFlzC9rrnyMWyx0MlrDQOEUhOkwhE5dm3w=;
        h=Subject:To:Cc:From:Date:From;
        b=UiHtb7H+q8HAVzt+MBm5y9yf7UjmsB8x271WvcOWXbmqNf7iuvjFmRgjYj8dlyI1u
         dRDS44sXB3vcZMq56O7f4fXPcTSu8Cv3bVKUGWz661kbg4QyDx++8Yc2KOyN/CWDc3
         nq8wdl1GPzboMgCzd/L72rjIZmvAcmIokTmv9ODs=
Subject: FAILED: patch "[PATCH] powerpc/64s: system call rfscv workaround for TM bugs" failed to apply to 5.10-stable tree
To:     npiggin@gmail.com, efuller@redhat.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Sep 2021 10:54:48 +0200
Message-ID: <16321280882488@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae7aaecc3f2f78b76ab3a8d6178610f55aadfa56 Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Wed, 8 Sep 2021 20:17:17 +1000
Subject: [PATCH] powerpc/64s: system call rfscv workaround for TM bugs

The rfscv instruction does not work correctly with the fake-suspend mode
in POWER9, which can end up with the hypervisor restoring an incorrect
checkpoint.

Work around this by setting the _TIF_RESTOREALL flag if a system call
returns to a transaction active state, causing rfid to be used instead
of rfscv to return, which will do the right thing. The contents of the
registers are irrelevant because they will be overwritten in this case
anyway.

Fixes: 7fa95f9adaee7 ("powerpc/64s: system call support for scv/rfscv instructions")
Reported-by: Eirik Fuller <efuller@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210908101718.118522-1-npiggin@gmail.com

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index 2ccc7ea5db00..de10a2697258 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -137,6 +137,19 @@ notrace long system_call_exception(long r3, long r4, long r5,
 	 */
 	irq_soft_mask_regs_set_state(regs, IRQS_ENABLED);
 
+	/*
+	 * If system call is called with TM active, set _TIF_RESTOREALL to
+	 * prevent RFSCV being used to return to userspace, because POWER9
+	 * TM implementation has problems with this instruction returning to
+	 * transactional state. Final register values are not relevant because
+	 * the transaction will be aborted upon return anyway. Or in the case
+	 * of unsupported_scv SIGILL fault, the return state does not much
+	 * matter because it's an edge case.
+	 */
+	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
+			unlikely(MSR_TM_TRANSACTIONAL(regs->msr)))
+		current_thread_info()->flags |= _TIF_RESTOREALL;
+
 	/*
 	 * If the system call was made with a transaction active, doom it and
 	 * return without performing the system call. Unless it was an

