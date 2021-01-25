Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D011D303342
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbhAZEtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbhAYSpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A9FD2067B;
        Mon, 25 Jan 2021 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600312;
        bh=dtHWywZcjIYTvK9Xnj3nvbbc7zy5dcn9/5bvnLGxh/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQbJq6SKkn8RUM1a8gPBfPlNa0DXfA+t6QZEbWOjgmr+EKCQEdUVh86/FjEOAP+5G
         29W2UR0kLjW/U5QWKnoizEJK1xcSZxh90mqI4cGFuyAn2AWOKDCiG/OecankRvnnQn
         kw2rlZ8veFkVa9mx+CtH2lc8JLrwfpfgbFZqepEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 54/86] irqchip/mips-cpu: Set IPI domain parent chip
Date:   Mon, 25 Jan 2021 19:39:36 +0100
Message-Id: <20210125183203.334026031@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Kresin <dev@kresin.me>

commit 599b3063adf4bf041a87a69244ee36aded0d878f upstream.

Since commit 55567976629e ("genirq/irqdomain: Allow partial trimming of
irq_data hierarchy") the irq_data chain is valided.

The irq_domain_trim_hierarchy() function doesn't consider the irq + ipi
domain hierarchy as valid, since the ipi domain has the irq domain set
as parent, but the parent domain has no chip set. Hence the boot ends in
a kernel panic.

Set the chip for the parent domain as it is done in the mips gic irq
driver, to have a valid irq_data chain.

Fixes: 3838a547fda2 ("irqchip: mips-cpu: Introduce IPI IRQ domain support")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210107213603.1637781-1-dev@kresin.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-mips-cpu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/irqchip/irq-mips-cpu.c
+++ b/drivers/irqchip/irq-mips-cpu.c
@@ -197,6 +197,13 @@ static int mips_cpu_ipi_alloc(struct irq
 		if (ret)
 			return ret;
 
+		ret = irq_domain_set_hwirq_and_chip(domain->parent, virq + i, hwirq,
+						    &mips_mt_cpu_irq_controller,
+						    NULL);
+
+		if (ret)
+			return ret;
+
 		ret = irq_set_irq_type(virq + i, IRQ_TYPE_LEVEL_HIGH);
 		if (ret)
 			return ret;


