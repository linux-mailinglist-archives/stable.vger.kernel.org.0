Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1072856FD71
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiGKJzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiGKJy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:54:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F25537FAB;
        Mon, 11 Jul 2022 02:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3913E61363;
        Mon, 11 Jul 2022 09:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4758CC341C8;
        Mon, 11 Jul 2022 09:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531568;
        bh=0ZU9bBInoWO4Pr+JFp/0wb2t3sXUPYu60GbCWbRRfjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qboiURjxQnxnG82HHCyQmn6+4VxD03iFkbrnKG0dlLKCUZwxYkM0W8+skQO4wH66j
         uWr8g/+4/fzetSQ/DzEmJR+b93f0U0iTY2jWzENwKNtdquxVntOzIrJcuRNaXpIEaO
         oCbi/PTuygzN3UFhddupqOq4Wfvzsht8pxkhqmuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/230] irqchip/gic-v3: Ensure pseudo-NMIs have an ISB between ack and handling
Date:   Mon, 11 Jul 2022 11:06:48 +0200
Message-Id: <20220711090608.371572311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fd4fb1b35787..d8ea330454f4 100644
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



