Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581A8D2531
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbfJJIzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389824AbfJJIta (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2130218AC;
        Thu, 10 Oct 2019 08:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697370;
        bh=65FrNbLESZ8v+zraZfQvP46y83UiFJA0O6qpT20PisE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9V3g4RNqdV6SfBc0gPm2i2kBCVq2eTF07IBg1VghzMhg4TTLAyqYsTbaqXbkT38I
         QXos9BKf5Qgc6dN+bGqi3ICGTvccv+8eHAiEJ4fVsTuMQ5EXXYFgyAIEy9vaSgqvqQ
         fu3TjTjdoQfQeiHnMj1T7MSdH9QqhUv+Nj3hPcKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <vincent.chen@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/114] riscv: Avoid interrupts being erroneously enabled in handle_exception()
Date:   Thu, 10 Oct 2019 10:36:35 +0200
Message-Id: <20191010083612.720750989@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit c82dd6d078a2bb29d41eda032bb96d05699a524d ]

When the handle_exception function addresses an exception, the interrupts
will be unconditionally enabled after finishing the context save. However,
It may erroneously enable the interrupts if the interrupts are disabled
before entering the handle_exception.

For example, one of the WARN_ON() condition is satisfied in the scheduling
where the interrupt is disabled and rq.lock is locked. The WARN_ON will
trigger a break exception and the handle_exception function will enable the
interrupts before entering do_trap_break function. During the procedure, if
a timer interrupt is pending, it will be taken when interrupts are enabled.
In this case, it may cause a deadlock problem if the rq.lock is locked
again in the timer ISR.

Hence, the handle_exception() can only enable interrupts when the state of
sstatus.SPIE is 1.

This patch is tested on HiFive Unleashed board.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
[paul.walmsley@sifive.com: updated to apply]
Fixes: bcae803a21317 ("RISC-V: Enable IRQ during exception handling")
Cc: David Abdurachmanov <david.abdurachmanov@sifive.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index fa2c08e3c05e6..a03821b2656aa 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -171,9 +171,13 @@ ENTRY(handle_exception)
 	move a1, s4 /* scause */
 	tail do_IRQ
 1:
-	/* Exceptions run with interrupts enabled */
+	/* Exceptions run with interrupts enabled or disabled
+	   depending on the state of sstatus.SR_SPIE */
+	andi t0, s1, SR_SPIE
+	beqz t0, 1f
 	csrs sstatus, SR_SIE
 
+1:
 	/* Handle syscalls */
 	li t0, EXC_SYSCALL
 	beq s4, t0, handle_syscall
-- 
2.20.1



