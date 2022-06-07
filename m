Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC0541C95
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382194AbiFGWCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382203AbiFGVuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:50:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7469C190D22;
        Tue,  7 Jun 2022 12:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D39A1B8220B;
        Tue,  7 Jun 2022 19:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C685C385A5;
        Tue,  7 Jun 2022 19:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628915;
        bh=7ADwI4ceJ9tEh1nUpeN96td1EOsOqnWLQPLVG7+l0rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDxBsa2wHxHxlkz7O5p3KWa4gLp1OuTUrwpekJYrlNse7Pb70g/TwsUc7Pum/WcoB
         DZ3NoU1Nh4RxF+hbvXS7l3Jeqoc33AjlWAbUinslWGOpA1iAfk8KsP9WeZcda+iTQf
         vaKU1TjXi1yMwc+gasCwmes/UyUso43jZqplCWEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 462/879] irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling
Date:   Tue,  7 Jun 2022 18:59:40 +0200
Message-Id: <20220607165016.284240302@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit adf14453d2c037ab529040c1186ea32e277e783a ]

There are cases where a context synchronization event is necessary
between an IRQ being raised and being handled, and there are races such
that we cannot rely upon the exception entry being subsequent to the
interrupt being raised.

We identified and fixes this for regular IRQs in commit:

  39a06b67c2c1256b ("irqchip/gic: Ensure we have an ISB between ack and ->handle_irq")

Unfortunately, we forgot to do the same for psuedo-NMIs when support for
those was added in commit:

  f32c926651dcd168 ("irqchip/gic-v3: Handle pseudo-NMIs")

Which means that when pseudo-NMIs are used for PMU support, we'll hit
the same problem.

Apply the same fix as for regular IRQs. Note that when EOI mode 1 is in
use, the call to gic_write_eoir() will provide an ISB.

Fixes: f32c926651dcd168 ("irqchip/gic-v3: Handle pseudo-NMIs")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220513133038.226182-2-mark.rutland@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index b252d5534547..7305d84f2df5 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -654,6 +654,9 @@ static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 
 	if (static_branch_likely(&supports_deactivate_key))
 		gic_write_eoir(irqnr);
+	else
+		isb()
+
 	/*
 	 * Leave the PSR.I bit set to prevent other NMIs to be
 	 * received while handling this one.
-- 
2.35.1



