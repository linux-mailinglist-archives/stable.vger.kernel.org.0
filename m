Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2754727D7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241774AbhLMKFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:05:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46252 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240533AbhLMKCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:02:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7C67B80E77;
        Mon, 13 Dec 2021 10:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216B7C34600;
        Mon, 13 Dec 2021 10:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389722;
        bh=whCGHq9Jf7S43kKFy5mkFVyuu5pEgSFlTrb85xag2iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jR3Eanw3tuy0JQUAWc7WQ2biKtT4Jz952nokXTygTHcXooxBk1KBMax/cxRR6jqdo
         4VPIBVDT6O8yCSHdKer2Z7qZOuFHovQX1/ZyEmNG1kdnIiWAmxEqUmQJQ24OFfi0Dt
         VaJXOtGvLhZnspzAquc8vHXNTDtXDFRBTXV/76N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 165/171] irqchip/armada-370-xp: Fix support for Multi-MSI interrupts
Date:   Mon, 13 Dec 2021 10:31:20 +0100
Message-Id: <20211213092950.565823474@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit d0a553502efd545c1ce3fd08fc4d423f8e4ac3d6 upstream.

irq-armada-370-xp driver already sets MSI_FLAG_MULTI_PCI_MSI flag into
msi_domain_info structure. But allocated interrupt numbers for Multi-MSI
needs to be properly aligned otherwise devices send MSI interrupt with
wrong number.

Fix this issue by using function bitmap_find_free_region() instead of
bitmap_find_next_zero_area() to allocate aligned interrupt numbers.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: a71b9412c90c ("irqchip/armada-370-xp: Allow allocation of multiple MSIs")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211125130057.26705-2-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-armada-370-xp.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -232,16 +232,12 @@ static int armada_370_xp_msi_alloc(struc
 	int hwirq, i;
 
 	mutex_lock(&msi_used_lock);
+	hwirq = bitmap_find_free_region(msi_used, PCI_MSI_DOORBELL_NR,
+					order_base_2(nr_irqs));
+	mutex_unlock(&msi_used_lock);
 
-	hwirq = bitmap_find_next_zero_area(msi_used, PCI_MSI_DOORBELL_NR,
-					   0, nr_irqs, 0);
-	if (hwirq >= PCI_MSI_DOORBELL_NR) {
-		mutex_unlock(&msi_used_lock);
+	if (hwirq < 0)
 		return -ENOSPC;
-	}
-
-	bitmap_set(msi_used, hwirq, nr_irqs);
-	mutex_unlock(&msi_used_lock);
 
 	for (i = 0; i < nr_irqs; i++) {
 		irq_domain_set_info(domain, virq + i, hwirq + i,
@@ -259,7 +255,7 @@ static void armada_370_xp_msi_free(struc
 	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
 
 	mutex_lock(&msi_used_lock);
-	bitmap_clear(msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&msi_used_lock);
 }
 


