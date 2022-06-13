Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C60549207
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376330AbiFMNV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377088AbiFMNUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920B06973E;
        Mon, 13 Jun 2022 04:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F1160F18;
        Mon, 13 Jun 2022 11:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95224C3411C;
        Mon, 13 Jun 2022 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119358;
        bh=2hBjMjiZ041N5Z0Yg7mhxSGjvQprD2H+8vtm5RyJEns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgY2wEzjC2rWgYkQRF6vyOMQ631nz59nOqCJz1L20ogVEyRyFV6freIFbbOmppsUo
         hG2KZ1rO4nqbtqi2P1w4wzZyo4U9nXbIXnQA6byhCVeZfOUDebZ0mulbBwfMhKGiaj
         WtSVCB+GKBI5T4o6loKTw/i7eOg27/v8EC2IemRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 234/247] powerpc: Dont select HAVE_IRQ_EXIT_ON_IRQ_STACK
Date:   Mon, 13 Jun 2022 12:12:16 +0200
Message-Id: <20220613094930.041280594@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 1346d00e1bdfd4067f92bc14e8a6131a01de4190 upstream.

The HAVE_IRQ_EXIT_ON_IRQ_STACK option tells generic code that irq_exit()
is called while still running on the hard irq stack (hardirq_ctx[] in
the powerpc code).

Selecting the option means the generic code will *not* switch to the
softirq stack before running softirqs, because the code is already
running on the (mostly empty) hard irq stack.

But since commit 1b1b6a6f4cc0 ("powerpc: handle irq_enter/irq_exit in
interrupt handler wrappers"), irq_exit() is now called on the regular task
stack, not the hard irq stack.

That's because previously irq_exit() was called in __do_irq() which is
run on the hard irq stack, but now it is called in
interrupt_async_exit_prepare() which is called from do_irq() constructed
by the wrapper macro, which is after the switch back to the task stack.

So drop HAVE_IRQ_EXIT_ON_IRQ_STACK from the Kconfig. This will mean an
extra stack switch when processing some interrupts, but should
significantly reduce the likelihood of stack overflow.

It also means the softirq stack will be used for running softirqs from
other interrupts that don't use the hard irq stack, eg. timer interrupts.

Fixes: 1b1b6a6f4cc0 ("powerpc: handle irq_enter/irq_exit in interrupt handler wrappers")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220525032639.1947280-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -217,7 +217,6 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_HW_BREAKPOINT		if PERF_EVENTS && (PPC_BOOK3S || PPC_8xx)
 	select HAVE_IOREMAP_PROT
-	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZMA			if DEFAULT_UIMAGE


