Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C156A3ED4D2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhHPNFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237064AbhHPNFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF2C632A6;
        Mon, 16 Aug 2021 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119091;
        bh=Q6i3T57RX6TV9PUrnLivdr2WkPChCIv41a7zXyC6zxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1SGLO4RAW8w7/62oC6wfi6uJQwYROlZYHCPDBY2I/vlhlIUEtHWkBZy5K4QrTvYU
         znsG6NCnrw5In366RIY4bkwmEJYQ6mw6d+9xYdz8hEmL1460i1EZQ5nxP/jdMpxHjr
         JGUXMBxlxfacXmfIJtX60ME1sPbpuKx6NgGuqxx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bixuan Cui <cuibixuan@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 47/62] genirq/msi: Ensure deactivation on teardown
Date:   Mon, 16 Aug 2021 15:02:19 +0200
Message-Id: <20210816125429.820363920@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

commit dbbc93576e03fbe24b365fab0e901eb442237a8a upstream.

msi_domain_alloc_irqs() invokes irq_domain_activate_irq(), but
msi_domain_free_irqs() does not enforce deactivation before tearing down
the interrupts.

This happens when PCI/MSI interrupts are set up and never used before being
torn down again, e.g. in error handling pathes. The only place which cleans
that up is the error handling path in msi_domain_alloc_irqs().

Move the cleanup from msi_domain_alloc_irqs() into msi_domain_free_irqs()
to cure that.

Fixes: f3b0946d629c ("genirq/msi: Make sure PCI MSIs are activated early")
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210518033117.78104-1-cuibixuan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/msi.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -477,11 +477,6 @@ skip_activate:
 	return 0;
 
 cleanup:
-	for_each_msi_vector(desc, i, dev) {
-		irq_data = irq_domain_get_irq_data(domain, i);
-		if (irqd_is_activated(irq_data))
-			irq_domain_deactivate_irq(irq_data);
-	}
 	msi_domain_free_irqs(domain, dev);
 	return ret;
 }
@@ -494,7 +489,15 @@ cleanup:
  */
 void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
 {
+	struct irq_data *irq_data;
 	struct msi_desc *desc;
+	int i;
+
+	for_each_msi_vector(desc, i, dev) {
+		irq_data = irq_domain_get_irq_data(domain, i);
+		if (irqd_is_activated(irq_data))
+			irq_domain_deactivate_irq(irq_data);
+	}
 
 	for_each_msi_entry(desc, dev) {
 		/*


