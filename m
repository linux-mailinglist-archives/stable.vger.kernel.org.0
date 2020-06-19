Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2142201114
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393690AbgFSP3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393684AbgFSP3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C45321974;
        Fri, 19 Jun 2020 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580555;
        bh=Cs3C22YWb8uyymZZQokhJ0tYFXc4jC/QBwOhD7NisEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0dVA05RELhnKDAG1NtjBqNHD+0Sh17RZ2Su50ocg0BxLR+DgR4vAEOIQejW8bi1B
         jmtk3hSiN5X89ht6XoI/6g/xDDo1ZHq6FWU4fWEDowA7K4Yn4h1lKmZPcsueDHtMWS
         adetCNJKh9GeEgtEnREiQYe0Bkl/zKN7pKZn8ol4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Marc Zyngier <maz@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.7 295/376] irqchip/sifive-plic: Set default irq affinity in plic_irqdomain_map()
Date:   Fri, 19 Jun 2020 16:33:33 +0200
Message-Id: <20200619141724.305290536@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <anup.patel@wdc.com>

commit 2458ed31e9b9ab40d78a452ab2650a0857556e85 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-sifive-plic.c |    3 +++
 1 file changed, 3 insertions(+)

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
 


