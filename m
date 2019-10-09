Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73C9D04EF
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 02:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfJIAwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 20:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbfJIAwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 20:52:53 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1856D2070B;
        Wed,  9 Oct 2019 00:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570582373;
        bh=WSrFOaAas+ftyehGqxKHsiYEmd3JEZ1enKxTmpDnQJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uyve9kNNI1s3kq3GfUyBgpyows0ylNq8URMpI9pmexqETlc+9hxvd1/MomiAxW+AR
         fbgnTdyE+lXWvlxOjVH9w5Sb/9Z11r25bxMeyNpN7435jbmhcn6YTNLfUiA9VRRC5u
         b4x5ImPyQXGsSfGOQVxVIS3QEghux31O/WLnmqz4=
Date:   Tue, 8 Oct 2019 20:52:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     vincent.chen@sifive.com, david.abdurachmanov@sifive.com,
        palmer@sifive.com, paul.walmsley@sifive.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] riscv: Avoid interrupts being erroneously
 enabled in" failed to apply to 5.3-stable tree
Message-ID: <20191009005252.GQ1396@sasha-vm>
References: <1570555664182195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570555664182195@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 07:27:44PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From c82dd6d078a2bb29d41eda032bb96d05699a524d Mon Sep 17 00:00:00 2001
>From: Vincent Chen <vincent.chen@sifive.com>
>Date: Mon, 16 Sep 2019 16:47:41 +0800
>Subject: [PATCH] riscv: Avoid interrupts being erroneously enabled in
> handle_exception()
>
>When the handle_exception function addresses an exception, the interrupts
>will be unconditionally enabled after finishing the context save. However,
>It may erroneously enable the interrupts if the interrupts are disabled
>before entering the handle_exception.
>
>For example, one of the WARN_ON() condition is satisfied in the scheduling
>where the interrupt is disabled and rq.lock is locked. The WARN_ON will
>trigger a break exception and the handle_exception function will enable the
>interrupts before entering do_trap_break function. During the procedure, if
>a timer interrupt is pending, it will be taken when interrupts are enabled.
>In this case, it may cause a deadlock problem if the rq.lock is locked
>again in the timer ISR.
>
>Hence, the handle_exception() can only enable interrupts when the state of
>sstatus.SPIE is 1.
>
>This patch is tested on HiFive Unleashed board.
>
>Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
>Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
>[paul.walmsley@sifive.com: updated to apply]
>Fixes: bcae803a21317 ("RISC-V: Enable IRQ during exception handling")
>Cc: David Abdurachmanov <david.abdurachmanov@sifive.com>
>Cc: stable@vger.kernel.org
>Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
>
>diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
>index 74ccfd464071..da7aa88113c2 100644
>--- a/arch/riscv/kernel/entry.S
>+++ b/arch/riscv/kernel/entry.S
>@@ -166,9 +166,13 @@ ENTRY(handle_exception)
> 	move a0, sp /* pt_regs */
> 	tail do_IRQ
> 1:
>-	/* Exceptions run with interrupts enabled */
>+	/* Exceptions run with interrupts enabled or disabled
>+	   depending on the state of sstatus.SR_SPIE */
>+	andi t0, s1, SR_SPIE
>+	beqz t0, 1f
> 	csrs CSR_SSTATUS, SR_SIE
>
>+1:

I might be missing something here, but wasn't the label "1" already
declared a few lines above?

--
Thanks,
Sasha
