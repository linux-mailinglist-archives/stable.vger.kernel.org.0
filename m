Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFD29BDBF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812931AbgJ0Qqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368849AbgJ0Pl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC42D223B0;
        Tue, 27 Oct 2020 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813318;
        bh=uZvYznhCOh2KUWltoYwc68SAGZiMtx1wxn3HeAggEsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbBK2Pb8jF7S1lWrEr8VnO4UTjycxV6Kuf3IiMqlcBMdHU0Ka2HCH/oD2cp+WrAm/
         Y/xPnocPLhY7+d6mQWWOF24OVQexlHYp9ktOsU6Xc3UtPUtF9RFtt0mZth2nam1td5
         2V2Nrpgz83ye1/Z/YOo9m9kKjlLtj6L9p2nqUJMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 481/757] powerpc/64: fix irq replay missing preempt
Date:   Tue, 27 Oct 2020 14:52:11 +0100
Message-Id: <20201027135513.042401296@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 903fd31d3212ab72d564c68f6cfb5d04db68773e ]

Prior to commit 3282a3da25bd ("powerpc/64: Implement soft interrupt
replay in C"), replayed interrupts returned by the regular interrupt
exit code, which performs preemption in case an interrupt had set
need_resched.

This logic was missed by the conversion. Adding preempt_disable/enable
around the interrupt replay and final irq enable will reschedule if
needed.

Fixes: 3282a3da25bd ("powerpc/64: Implement soft interrupt replay in C")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200915114650.3980244-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/irq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index bf21ebd361900..77019699606a5 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -368,6 +368,12 @@ notrace void arch_local_irq_restore(unsigned long mask)
 		}
 	}
 
+	/*
+	 * Disable preempt here, so that the below preempt_enable will
+	 * perform resched if required (a replayed interrupt may set
+	 * need_resched).
+	 */
+	preempt_disable();
 	irq_soft_mask_set(IRQS_ALL_DISABLED);
 	trace_hardirqs_off();
 
@@ -377,6 +383,7 @@ notrace void arch_local_irq_restore(unsigned long mask)
 	trace_hardirqs_on();
 	irq_soft_mask_set(IRQS_ENABLED);
 	__hard_irq_enable();
+	preempt_enable();
 }
 EXPORT_SYMBOL(arch_local_irq_restore);
 
-- 
2.25.1



