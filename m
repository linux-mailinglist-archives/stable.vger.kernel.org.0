Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6A341253E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349744AbhITSmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382503AbhITSkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD1961AE4;
        Mon, 20 Sep 2021 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159087;
        bh=V7ZEbAs4e/bVbND/qFeUmE3tyZdZ3MQRAnDCypAfhX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2iqGJ8gWQT2JFqDDYoscaxajhP0iOKaIBU4JRBx0x7Dh66gOU67J9zuO1XeykI8k
         kBkoaDZNkhByjGihbs0Q6RqzTTLEy1qezUh7gmC6bWCZlpe8UioTNbh6vzkKGNELeJ
         TN+4meTsLtUiwuz3MlZbaaasocwv+5JEycizrhbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eirik Fuller <efuller@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 071/168] powerpc/64s: system call rfscv workaround for TM bugs
Date:   Mon, 20 Sep 2021 18:43:29 +0200
Message-Id: <20210920163923.978486843@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit ae7aaecc3f2f78b76ab3a8d6178610f55aadfa56 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -140,6 +140,19 @@ notrace long system_call_exception(long
 	irq_soft_mask_regs_set_state(regs, IRQS_ENABLED);
 
 	/*
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
+	/*
 	 * If the system call was made with a transaction active, doom it and
 	 * return without performing the system call. Unless it was an
 	 * unsupported scv vector, in which case it's treated like an illegal


