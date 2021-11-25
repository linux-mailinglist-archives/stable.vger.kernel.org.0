Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6845DF58
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhKYRI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 12:08:56 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53238 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241477AbhKYRG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 12:06:56 -0500
Date:   Thu, 25 Nov 2021 17:03:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637859822;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHZZWcLj69QRnWUmHhjnyGwDUjHsVOSu1L1htMBIT5s=;
        b=CSyYnIQ8MEA6cMwMP4sHKd2dbfSTJs2t6U1+lCD5mQGnyt2vMixjNUg2/JKjTRMV8W4wJd
        qNlGJs1EKmDzpaK5clmJbvXFtRZRFkdWM5SbW3e+8YOfzM/zVHBsUUjGqLZ5cDI8EJX0bw
        EeO7neEIPplzuURhHA+r/xb8/cghD4TZ52GHFPuLjVQqwJD41yAQvMwUBd5fMznYGkdGms
        UapcKeJfx6dKWbpSSxspOPhTHtpVBAwkpc2oCv6xD7sMFck6j6IoauUPqxZZkOCYNYIe+G
        N+cFDRMuEh3entd330+5dZGcDCthpDiqz7aCsVQkoJcvqyB616pR64yINnyMnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637859822;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHZZWcLj69QRnWUmHhjnyGwDUjHsVOSu1L1htMBIT5s=;
        b=8b33gCCxFNxKSqFgyJV9ABCmhIZHtyfxoI2llznYrkbfgFfdAJig2+IXnzdmxWRwh+Bl6p
        KB3i2xEQxjuqNcBw==
From:   irqchip-bot for Pali =?utf-8?q?Roh=C3=A1r?= 
        <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-fixes] irqchip/armada-370-xp: Fix support for
 Multi-MSI interrupts
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20211125130057.26705-2-pali@kernel.org>
References: <20211125130057.26705-2-pali@kernel.org>
MIME-Version: 1.0
Message-ID: <163785982132.11128.16644475689186546860.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-fixes branch of irq=
chip:

Commit-ID:     d0a553502efd545c1ce3fd08fc4d423f8e4ac3d6
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platfo=
rms/d0a553502efd545c1ce3fd08fc4d423f8e4ac3d6
Author:        Pali Roh=C3=A1r <pali@kernel.org>
AuthorDate:    Thu, 25 Nov 2021 14:00:57 +01:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Thu, 25 Nov 2021 16:49:50=20

irqchip/armada-370-xp: Fix support for Multi-MSI interrupts

irq-armada-370-xp driver already sets MSI_FLAG_MULTI_PCI_MSI flag into
msi_domain_info structure. But allocated interrupt numbers for Multi-MSI
needs to be properly aligned otherwise devices send MSI interrupt with
wrong number.

Fix this issue by using function bitmap_find_free_region() instead of
bitmap_find_next_zero_area() to allocate aligned interrupt numbers.

Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
Fixes: a71b9412c90c ("irqchip/armada-370-xp: Allow allocation of multiple MSI=
s")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211125130057.26705-2-pali@kernel.org
---
 drivers/irqchip/irq-armada-370-xp.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada=
-370-xp.c
index 41ad745..5b8d571 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -232,16 +232,12 @@ static int armada_370_xp_msi_alloc(struct irq_domain *d=
omain, unsigned int virq,
 	int hwirq, i;
=20
 	mutex_lock(&msi_used_lock);
+	hwirq =3D bitmap_find_free_region(msi_used, PCI_MSI_DOORBELL_NR,
+					order_base_2(nr_irqs));
+	mutex_unlock(&msi_used_lock);
=20
-	hwirq =3D bitmap_find_next_zero_area(msi_used, PCI_MSI_DOORBELL_NR,
-					   0, nr_irqs, 0);
-	if (hwirq >=3D PCI_MSI_DOORBELL_NR) {
-		mutex_unlock(&msi_used_lock);
+	if (hwirq < 0)
 		return -ENOSPC;
-	}
-
-	bitmap_set(msi_used, hwirq, nr_irqs);
-	mutex_unlock(&msi_used_lock);
=20
 	for (i =3D 0; i < nr_irqs; i++) {
 		irq_domain_set_info(domain, virq + i, hwirq + i,
@@ -259,7 +255,7 @@ static void armada_370_xp_msi_free(struct irq_domain *dom=
ain,
 	struct irq_data *d =3D irq_domain_get_irq_data(domain, virq);
=20
 	mutex_lock(&msi_used_lock);
-	bitmap_clear(msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&msi_used_lock);
 }
=20
