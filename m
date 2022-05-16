Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B40529099
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346197AbiEPULV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351122AbiEPUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D36B81;
        Mon, 16 May 2022 12:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45458B81611;
        Mon, 16 May 2022 19:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4AFC385AA;
        Mon, 16 May 2022 19:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731155;
        bh=yekZkhx9rr5WJWN+QNU/3YKvBuSdHExCR0fe0QC0v5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBRAsV77pS6dCN4zi1J1r6HUmy//ifirHU34g8VZwVkPg4TBwSFY19d6H85soDjK1
         r1bK0jcbUvM4Y/LzqHlp2xoOmMvJr+1y4+g2D0deaHt1cWZHeXdH05Ak0V8FYk9JRx
         KR6SzLDk792tUFL6HuRCE5T+TMOyWaPG7bFRvyO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Octavian Purdila <octavian.purdila@nxp.com>
Subject: [PATCH 5.17 089/114] genirq: Remove WARN_ON_ONCE() in generic_handle_domain_irq()
Date:   Mon, 16 May 2022 21:37:03 +0200
Message-Id: <20220516193628.034006734@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 792ea6a074ae7ea5ab6f1b8b31f76bb0297de66c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdesc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -678,7 +678,6 @@ EXPORT_SYMBOL_GPL(generic_handle_irq);
  */
 int generic_handle_domain_irq(struct irq_domain *domain, unsigned int hwirq)
 {
-	WARN_ON_ONCE(!in_irq());
 	return handle_irq_desc(irq_resolve_mapping(domain, hwirq));
 }
 EXPORT_SYMBOL_GPL(generic_handle_domain_irq);


