Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB88406334
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbhIJArD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234333AbhIJAXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C694B604DC;
        Fri, 10 Sep 2021 00:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233321;
        bh=clTN2ElM5rZvt7kmmgVJXHpVifOKOUFmA0jDeON8ICQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+M8TYrLQE9ri8z+3sUcfGaxkkUHJMn/xxxuiaeaMc3FRXPBloMUnyhfNexbhHG4w
         kRIzlR00mtOU+j+IXGeUoSbHRXLlUqTjCcYp/ocRjqcc73PUL6Z+nOAt5SyUdVuZ51
         4D31HjwagEKHUuKV6apV1LsI7K9Hjj7QCewxIcJ0IC2WqNzTaWbaflo35cMXvW6uYS
         GLh0MP+oQtPp/o0w/YYOHqICrPFysLZuI/IO1+6+NbI0hQaYzWMUSfj/acVvRGqx+T
         t4rYcueFhyTM0er3iKPjIQV3zpMLURQhKXz2wVzbCfhmtiT9U5gRDw6BLLudVHQtsz
         H3L8JCsPS5GjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 13/37] KVM: PPC: Book3S HV: XICS: Fix mapping of passthrough interrupts
Date:   Thu,  9 Sep 2021 20:21:18 -0400
Message-Id: <20210910002143.175731-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

[ Upstream commit 1753081f2d445f9157550692fcc4221cd3ff0958 ]

PCI MSIs now live in an MSI domain but the underlying calls, which
will EOI the interrupt in real mode, need an HW IRQ number mapped in
the XICS IRQ domain. Grab it there.

Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210701132750.1475580-31-clg@kaod.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index bba358f13471..dc897dff8eb9 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5020,6 +5020,7 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
 	struct kvmppc_passthru_irqmap *pimap;
 	struct irq_chip *chip;
 	int i, rc = 0;
+	struct irq_data *host_data;
 
 	if (!kvm_irq_bypass)
 		return 1;
@@ -5084,7 +5085,14 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
 	 * the KVM real mode handler.
 	 */
 	smp_wmb();
-	irq_map->r_hwirq = desc->irq_data.hwirq;
+
+	/*
+	 * The 'host_irq' number is mapped in the PCI-MSI domain but
+	 * the underlying calls, which will EOI the interrupt in real
+	 * mode, need an HW IRQ number mapped in the XICS IRQ domain.
+	 */
+	host_data = irq_domain_get_irq_data(irq_get_default_host(), host_irq);
+	irq_map->r_hwirq = (unsigned int)irqd_to_hwirq(host_data);
 
 	if (i == pimap->n_mapped)
 		pimap->n_mapped++;
@@ -5092,7 +5100,7 @@ static int kvmppc_set_passthru_irq(struct kvm *kvm, int host_irq, int guest_gsi)
 	if (xics_on_xive())
 		rc = kvmppc_xive_set_mapped(kvm, guest_gsi, desc);
 	else
-		kvmppc_xics_set_mapped(kvm, guest_gsi, desc->irq_data.hwirq);
+		kvmppc_xics_set_mapped(kvm, guest_gsi, irq_map->r_hwirq);
 	if (rc)
 		irq_map->r_hwirq = 0;
 
-- 
2.30.2

