Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5464212EEA9
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbgABWiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731193AbgABWiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:38:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 781E220863;
        Thu,  2 Jan 2020 22:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004695;
        bh=WDMCCQ5lRqNdoSDb5C9ugWuysJjA9Xq8qi7dfFA45vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLTAY2i3bPgo9h2S+6PWlKI0xQhuucVcNkyZ2d8LhZUOunWcLybjHYXojvv0pGkzS
         l0ZYwpxxtQ2fGRoS3+k7znHKP+RFj/cvd0G63VYfdgWeglmV+3aUmVL7b24jkxqRIx
         WuDdAqksb4IMUBXjP+9EPPZBjo24SrMLOPtitJ2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 087/137] powerpc/irq: fix stack overflow verification
Date:   Thu,  2 Jan 2020 23:07:40 +0100
Message-Id: <20200102220558.412954036@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 099bc4812f09155da77eeb960a983470249c9ce1 upstream.

Before commit 0366a1c70b89 ("powerpc/irq: Run softirqs off the top of
the irq stack"), check_stack_overflow() was called by do_IRQ(), before
switching to the irq stack.
In that commit, do_IRQ() was renamed __do_irq(), and is now executing
on the irq stack, so check_stack_overflow() has just become almost
useless.

Move check_stack_overflow() call in do_IRQ() to do the check while
still on the current stack.

Fixes: 0366a1c70b89 ("powerpc/irq: Run softirqs off the top of the irq stack")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/e033aa8116ab12b7ca9a9c75189ad0741e3b9b5f.1575872340.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -484,8 +484,6 @@ void __do_irq(struct pt_regs *regs)
 
 	trace_irq_entry(regs);
 
-	check_stack_overflow();
-
 	/*
 	 * Query the platform PIC for the interrupt & ack it.
 	 *
@@ -517,6 +515,8 @@ void do_IRQ(struct pt_regs *regs)
 	irqtp = hardirq_ctx[raw_smp_processor_id()];
 	sirqtp = softirq_ctx[raw_smp_processor_id()];
 
+	check_stack_overflow();
+
 	/* Already there ? */
 	if (unlikely(curtp == irqtp || curtp == sirqtp)) {
 		__do_irq(regs);


