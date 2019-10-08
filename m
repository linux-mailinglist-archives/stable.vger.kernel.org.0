Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8377ECFFD5
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfJHR1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:27:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51013 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727496AbfJHR1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:27:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A528215B2;
        Tue,  8 Oct 2019 13:27:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZMCHJG
        2scxR6mqd0Jo0b2YhzurNHSURiMnzo1XdQBNE=; b=WVcJd6rFmxAXI88pk8UofC
        J3/4CxqDQ3K9M4o5DBpElV4db4lj3ObB9QaAT7CSt3WBdgOIQ0a/s2/VNnlz7F5F
        BlACW8tRyw5Tl2P2G1RqkOGbuMkKvi8UjEB3/o77Y16u4cECWK41uR+g2nE4S+05
        Is/RXy7zbjvUsdjTFifreosaHV1Q4K/aSl7nN5ZAYYlZGvAm4o7sIcFnHJ3LjAj6
        DFy+nM9h469Yjru6szWRndYeGEMUkCYqzmxIMHzzoCV0C1z6eQk57FOlwFuX6hUC
        QVUSSZEONjBCM5Qu7/U2PJAXfISjKrIwd4lTJbGxApCyVn36N1yeXwqw6W3bw+Fg
        ==
X-ME-Sender: <xms:EcecXXxrU932WsCxEaPd3AaZzirb8NmMYLST2yq6EgvChdvlysZQ4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpegvnhhtrhihrdhssgenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:EcecXY44xk02lXEjZqV7motZn2lLAwcgbd28RG8SExu1gJ5ljcUhtA>
    <xmx:EcecXd_Vnt6hw5DoHKmvnEJQTBWrWto4gZoA4HUlFQ2-JYYzWkciXA>
    <xmx:EcecXSLibShvIUhfU4o2Ml01a0Z7c708F8TJnKm6EZ6egBEAbbs9BA>
    <xmx:EsecXTBKXsotPYkEwlmu8FF-Db85mQRSxrI8MOA_HWbUpTEAR0NaeQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 432428005B;
        Tue,  8 Oct 2019 13:27:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: Avoid interrupts being erroneously enabled in" failed to apply to 5.3-stable tree
To:     vincent.chen@sifive.com, david.abdurachmanov@sifive.com,
        palmer@sifive.com, paul.walmsley@sifive.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:27:44 +0200
Message-ID: <1570555664182195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c82dd6d078a2bb29d41eda032bb96d05699a524d Mon Sep 17 00:00:00 2001
From: Vincent Chen <vincent.chen@sifive.com>
Date: Mon, 16 Sep 2019 16:47:41 +0800
Subject: [PATCH] riscv: Avoid interrupts being erroneously enabled in
 handle_exception()

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

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 74ccfd464071..da7aa88113c2 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -166,9 +166,13 @@ ENTRY(handle_exception)
 	move a0, sp /* pt_regs */
 	tail do_IRQ
 1:
-	/* Exceptions run with interrupts enabled */
+	/* Exceptions run with interrupts enabled or disabled
+	   depending on the state of sstatus.SR_SPIE */
+	andi t0, s1, SR_SPIE
+	beqz t0, 1f
 	csrs CSR_SSTATUS, SR_SIE
 
+1:
 	/* Handle syscalls */
 	li t0, EXC_SYSCALL
 	beq s4, t0, handle_syscall

