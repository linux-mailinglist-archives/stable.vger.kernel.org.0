Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C46CFFD6
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfJHR1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:27:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55025 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfJHR1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:27:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D6B42073F;
        Tue,  8 Oct 2019 13:27:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ON82FO
        WjZFeBCzAYMUAyt98HmMSb5sB6Dls7mALiYis=; b=aa99YQFqEScu2SW1B+4/O/
        9boS7/At8PysB40rLl85YeN/HM8YptCfa0cj3pJbx0QAjs8619q1gok7xtBQ2JAW
        QvKTXqsUz+C/NKcKvSGdgsolWOxa+Ex8ItD0QXNHBkKllNg/uFrdEOb+wSdfVHac
        ZQUmJr4bmQ0XNTeXpOEGp02FuWIT7EzHkwpt1irzbvd4wQtkUA/vMgQCvZB3Zmh0
        wnKAzx/EInBOM5+nkHLWEvhYF4Aey7M1W0WtQL3p0b7Q3MaXwkUhMgM4pCgtKg8W
        IdYiDmkROXzgTVr8RrQgHYUosdarRNF7wttJroTWHkyMS06oCZwTX1gBb87MDAhg
        ==
X-ME-Sender: <xms:GcecXamVTOddlwWws5kPrNZtRFnnTb2liIu80bqcBcnox0p8TTKwHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpegvnhhtrhihrdhssgenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:GcecXdYaVLVATPC0EPoX3g_1I1OS6U1UgUvB1fpws4V6dDsXjbX3Fg>
    <xmx:GcecXQe6eEHsguKULtsgNlkwR3caeGsYb8z1KmsXACzWoHe4VpN-dw>
    <xmx:GcecXV45nH6jVs677hPDvPgeoJb8FszF0BQPg4MEEL9dd-mbkXOAyQ>
    <xmx:GsecXbgOxpi__xQmg5Ki4fNhfvDLvAL3UxZwiNGBWCw6WQElZs5Xdw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8E8CD6005B;
        Tue,  8 Oct 2019 13:27:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: Avoid interrupts being erroneously enabled in" failed to apply to 4.19-stable tree
To:     vincent.chen@sifive.com, david.abdurachmanov@sifive.com,
        palmer@sifive.com, paul.walmsley@sifive.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:27:44 +0200
Message-ID: <1570555664227250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

