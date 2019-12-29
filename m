Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C2212C58C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbfL2Rgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:36:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbfL2Rgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:36:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA0A208C4;
        Sun, 29 Dec 2019 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641001;
        bh=AFjYPlIpzkEGggRVPirwZCBV545+xTXlx6K9jP/SMws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZapntQKQQDzTXLtohi+vXmif3HBc/fV8uHnhmd9JY0K1UCsK7qd3TZHBeCMPk5J4k
         cM4J7LA00M4swlJhpa0xocSp8JqKJRPK5uNmq7ZhqEB/kDEFEpNdKv/bVqPdnTR8mb
         R0EDeIs5y5QOvw131mrKH+6m4syxHqb3xH8pO8j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 212/219] powerpc/irq: fix stack overflow verification
Date:   Sun, 29 Dec 2019 18:20:14 +0100
Message-Id: <20191229162542.397199524@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
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
@@ -634,8 +634,6 @@ void __do_irq(struct pt_regs *regs)
 
 	trace_irq_entry(regs);
 
-	check_stack_overflow();
-
 	/*
 	 * Query the platform PIC for the interrupt & ack it.
 	 *
@@ -667,6 +665,8 @@ void do_IRQ(struct pt_regs *regs)
 	irqtp = hardirq_ctx[raw_smp_processor_id()];
 	sirqtp = softirq_ctx[raw_smp_processor_id()];
 
+	check_stack_overflow();
+
 	/* Already there ? */
 	if (unlikely(curtp == irqtp || curtp == sirqtp)) {
 		__do_irq(regs);


