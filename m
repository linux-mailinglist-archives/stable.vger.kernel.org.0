Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72C64A4411
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377089AbiAaLZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378245AbiAaLXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD3CC061756;
        Mon, 31 Jan 2022 03:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BA0EB82A74;
        Mon, 31 Jan 2022 11:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CDFC340E8;
        Mon, 31 Jan 2022 11:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627685;
        bh=Exd2l5co6Rjj9v95rwrcLjP0ecH68GmgHFV3YrX0Lds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOfnYvOIgQ6sIJZOFG68zQNasoSMsh0x0N1PcDmOegrv4k0rn4cdlDmxpj166U0+A
         ogyf7FdusrEz633AKrj4CNsLbeBQcIEAjoCRs1q6HYDH3OQYvfOZN5y700fqANPFAy
         8Qkt3HDcl0R6eu1Bgh6KgAYlPZK0+wgh6RLFLjuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sander Vanheule <sander@svanheule.net>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/171] irqchip/realtek-rtl: Fix off-by-one in routing
Date:   Mon, 31 Jan 2022 11:57:08 +0100
Message-Id: <20220131105235.524654480@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

commit 91351b5dd0fd494eb2d85e1bb6aca77b067447e0 upstream.

There is an offset between routing values (1..6) and the connected MIPS
CPU interrupts (2..7), but no distinction was made between these two
values.

This issue was previously hidden during testing, because an interrupt
mapping was used where for each required interrupt another (unused)
routing was configured, with an offset of +1.

Offset the CPU IRQ numbers by -1 to retrieve the correct routing value.

Fixes: 9f3a0f34b84a ("irqchip: Add support for Realtek RTL838x/RTL839x interrupt controller")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/177b920aa8d8610615692d0e657e509f363c85ca.1641739718.git.sander@svanheule.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-realtek-rtl.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-realtek-rtl.c
+++ b/drivers/irqchip/irq-realtek-rtl.c
@@ -95,7 +95,8 @@ out:
  * SoC interrupts are cascaded to MIPS CPU interrupts according to the
  * interrupt-map in the device tree. Each SoC interrupt gets 4 bits for
  * the CPU interrupt in an Interrupt Routing Register. Max 32 SoC interrupts
- * thus go into 4 IRRs.
+ * thus go into 4 IRRs. A routing value of '0' means the interrupt is left
+ * disconnected. Routing values {1..15} connect to output lines {0..14}.
  */
 static int __init map_interrupts(struct device_node *node, struct irq_domain *domain)
 {
@@ -134,7 +135,7 @@ static int __init map_interrupts(struct
 		of_node_put(cpu_ictl);
 
 		cpu_int = be32_to_cpup(imap + 2);
-		if (cpu_int > 7)
+		if (cpu_int > 7 || cpu_int < 2)
 			return -EINVAL;
 
 		if (!(mips_irqs_set & BIT(cpu_int))) {
@@ -143,7 +144,8 @@ static int __init map_interrupts(struct
 			mips_irqs_set |= BIT(cpu_int);
 		}
 
-		regs[(soc_int * 4) / 32] |= cpu_int << (soc_int * 4) % 32;
+		/* Use routing values (1..6) for CPU interrupts (2..7) */
+		regs[(soc_int * 4) / 32] |= (cpu_int - 1) << (soc_int * 4) % 32;
 		imap += 3;
 	}
 


