Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C055522874
	for <lists+stable@lfdr.de>; Wed, 11 May 2022 02:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiEKA1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 20:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiEKA1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 20:27:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52BD5D1BE;
        Tue, 10 May 2022 17:27:37 -0700 (PDT)
Date:   Wed, 11 May 2022 00:27:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1652228856;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NuL0QXGzQE4f61TV1wvzJ0QEqgqQg7LnaavuAtJN2XM=;
        b=xbxpE/aueQ3SRa2csZeVrfQOrc6Y188CB4332pQlSguKFf2sIOlXxLgjcnljIlrz6J44Yh
        V9dEJTitZie1K4mwgdI0LMMM42IGMK4iOpx6Ry+BGinnkDmnHPpf6mdxEnQlhiHDg0Bmbu
        W5Bu7Kt7KE6lhNIYL8jgUixJmJX1ehSWLPjZoFlTQ9FMUyPKPXhKhgcIxRp6Sk6/7M+QIk
        DqYhOkkqA5ahSz6fMIbZZhj/0gOoF57xF+g2eFy/l13oHTRD2au+ahrmaqL4AxrehPnYvT
        xsZMG27zCnKX8VtBT3MgQrHN4YvqNzgJZylwYlzDsRIGp+ieXw+g/S+mVqO3zQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1652228856;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NuL0QXGzQE4f61TV1wvzJ0QEqgqQg7LnaavuAtJN2XM=;
        b=S/EkPhEC+g44LnTYgM55PntsA1YCK8U2IFcPqXtNdXoqgLuAo38jv1wMwO75fGpx8KaDa6
        kuNfdEIZta97pCAw==
From:   "tip-bot2 for Lukas Wunner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq: Remove WARN_ON_ONCE() in
 generic_handle_domain_irq()
Cc:     Lukas Wunner <lukas@wunner.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Octavian Purdila <octavian.purdila@nxp.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220505113207.487861b2@kernel.org>
References: <20220505113207.487861b2@kernel.org>
MIME-Version: 1.0
Message-ID: <165222885472.4207.9060710349562031230.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     792ea6a074ae7ea5ab6f1b8b31f76bb0297de66c
Gitweb:        https://git.kernel.org/tip/792ea6a074ae7ea5ab6f1b8b31f76bb0297de66c
Author:        Lukas Wunner <lukas@wunner.de>
AuthorDate:    Tue, 10 May 2022 09:56:05 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 11 May 2022 02:22:52 +02:00

genirq: Remove WARN_ON_ONCE() in generic_handle_domain_irq()

Since commit 0953fb263714 ("irq: remove handle_domain_{irq,nmi}()"),
generic_handle_domain_irq() warns if called outside hardirq context, even
though the function calls down to handle_irq_desc(), which warns about the
same, but conditionally on handle_enforce_irqctx().

The newly added warning is a false positive if the interrupt originates
from any other irqchip than x86 APIC or ARM GIC/GICv3.  Those are the only
ones for which handle_enforce_irqctx() returns true.  Per commit
c16816acd086 ("genirq: Add protection against unsafe usage of
generic_handle_irq()"):

 "In general calling generic_handle_irq() with interrupts disabled from non
  interrupt context is harmless. For some interrupt controllers like the
  x86 trainwrecks this is outright dangerous as it might corrupt state if
  an interrupt affinity change is pending."

Examples for interrupt chips where the warning is a false positive are
USB-attached GPIO controllers such as drivers/gpio/gpio-dln2.c:

  USB gadgets are incapable of directly signaling an interrupt because they
  cannot initiate a bus transaction by themselves.  All communication on
  the bus is initiated by the host controller, which polls a gadget's
  Interrupt Endpoint in regular intervals.  If an interrupt is pending,
  that information is passed up the stack in softirq context, from which a
  hardirq is synthesized via generic_handle_domain_irq().

Remove the warning to eliminate such false positives.

Fixes: 0953fb263714 ("irq: remove handle_domain_{irq,nmi}()")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Jakub Kicinski <kuba@kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Octavian Purdila <octavian.purdila@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220505113207.487861b2@kernel.org
Link: https://lore.kernel.org/r/20220506203242.GA1855@wunner.de
Link: https://lore.kernel.org/r/c3caf60bfa78e5fdbdf483096b7174da65d1813a.1652168866.git.lukas@wunner.de
---
 kernel/irq/irqdesc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 0099b87..d323b18 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -701,7 +701,6 @@ EXPORT_SYMBOL_GPL(generic_handle_irq_safe);
  */
 int generic_handle_domain_irq(struct irq_domain *domain, unsigned int hwirq)
 {
-	WARN_ON_ONCE(!in_hardirq());
 	return handle_irq_desc(irq_resolve_mapping(domain, hwirq));
 }
 EXPORT_SYMBOL_GPL(generic_handle_domain_irq);
