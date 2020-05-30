Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A630E1E8F42
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 09:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgE3Hrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 03:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728920AbgE3Hqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 03:46:38 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA6C08C5C9;
        Sat, 30 May 2020 00:46:38 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jewCQ-0001qq-V9; Sat, 30 May 2020 09:46:35 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 85E1F1C0093;
        Sat, 30 May 2020 09:46:34 +0200 (CEST)
Date:   Sat, 30 May 2020 07:46:34 -0000
From:   "tip-bot2 for Anup Patel" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] irqchip/sifive-plic: Set default irq affinity in
 plic_irqdomain_map()
Cc:     Anup Patel <anup.patel@wdc.com>, Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200518091441.94843-2-anup.patel@wdc.com>
References: <20200518091441.94843-2-anup.patel@wdc.com>
MIME-Version: 1.0
Message-ID: <159082479441.17951.16412804370544282566.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     2458ed31e9b9ab40d78a452ab2650a0857556e85
Gitweb:        https://git.kernel.org/tip/2458ed31e9b9ab40d78a452ab2650a0857556e85
Author:        Anup Patel <anup.patel@wdc.com>
AuthorDate:    Mon, 18 May 2020 14:44:39 +05:30
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Mon, 25 May 2020 10:36:09 +01:00

irqchip/sifive-plic: Set default irq affinity in plic_irqdomain_map()

For multiple PLIC instances, each PLIC can only target a subset of
CPUs which is represented by "lmask" in the "struct plic_priv".

Currently, the default irq affinity for each PLIC interrupt is all
online CPUs which is illegal value for default irq affinity when we
have multiple PLIC instances. To fix this, we now set "lmask" as the
default irq affinity in for each interrupt in plic_irqdomain_map().

Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200518091441.94843-2-anup.patel@wdc.com
---
 drivers/irqchip/irq-sifive-plic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index 822e074..9f7f8ce 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -176,9 +176,12 @@ static struct irq_chip plic_chip = {
 static int plic_irqdomain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hwirq)
 {
+	struct plic_priv *priv = d->host_data;
+
 	irq_domain_set_info(d, irq, hwirq, &plic_chip, d->host_data,
 			    handle_fasteoi_irq, NULL, NULL);
 	irq_set_noprobe(irq);
+	irq_set_affinity(irq, &priv->lmask);
 	return 0;
 }
 
