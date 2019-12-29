Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605C212C755
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfL2R1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:27:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbfL2R1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:27:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A0221744;
        Sun, 29 Dec 2019 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640438;
        bh=NXKgy41tAGRp9sEKiUiDZzci+nRhDZkq+Sk5LQzhINQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQl0VR579ayJtKKfSzNQpQr9xnEb7qrmlNcHkKnB6N4nJVaC8T8WpC/KkMyg7xuU9
         PkRpwqYgKro5V77bwaD6hTVTQXBE9THMMo04L3xRfwgFPnN664LrqmY6bqd12w72pK
         gvdWUVP06va3Q0Ty6o255zjZg+rgR5maOOL9naGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 157/161] powerpc/irq: fix stack overflow verification
Date:   Sun, 29 Dec 2019 18:20:05 +0100
Message-Id: <20191229162449.457576366@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
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
@@ -561,8 +561,6 @@ void __do_irq(struct pt_regs *regs)
 
 	trace_irq_entry(regs);
 
-	check_stack_overflow();
-
 	/*
 	 * Query the platform PIC for the interrupt & ack it.
 	 *
@@ -594,6 +592,8 @@ void do_IRQ(struct pt_regs *regs)
 	irqtp = hardirq_ctx[raw_smp_processor_id()];
 	sirqtp = softirq_ctx[raw_smp_processor_id()];
 
+	check_stack_overflow();
+
 	/* Already there ? */
 	if (unlikely(curtp == irqtp || curtp == sirqtp)) {
 		__do_irq(regs);


