Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3C3CDFB3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344920AbhGSPLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346067AbhGSPKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6D76121F;
        Mon, 19 Jul 2021 15:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709806;
        bh=2MfHI0JXdPPqKkga/PxyoJr2w2zYuQO+XvsrgHW0KxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZKlWmwYD+5UT80p8S41F4GZGcdvqCYNCKvVs/pgRIlC/WcV24FMxY17JUYW4TWBx
         o1rPgBn9TVV6usIQk3Sr4MDONzdmLZECjvOx2/Rf8N72RI6NagiyBgrw8PVA0wgs/P
         M7ESO23tDudjAHUXox3DOJCG1QxLSchO/419OC3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sandor Bodo-Merle <sbodomerle@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>, Ray Jui <ray.jui@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/149] PCI: iproc: Fix multi-MSI base vector number allocation
Date:   Mon, 19 Jul 2021 16:53:34 +0200
Message-Id: <20210719144926.446976253@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandor Bodo-Merle <sbodomerle@gmail.com>

[ Upstream commit e673d697b9a234fc3544ac240e173cef8c82b349 ]

Commit fc54bae28818 ("PCI: iproc: Allow allocation of multiple MSIs")
introduced multi-MSI support with a broken allocation mechanism (it failed
to reserve the proper number of bits from the inner domain).  Natural
alignment of the base vector number was also not guaranteed.

Link: https://lore.kernel.org/r/20210622152630.40842-1-sbodomerle@gmail.com
Fixes: fc54bae28818 ("PCI: iproc: Allow allocation of multiple MSIs")
Reported-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Sandor Bodo-Merle <sbodomerle@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Pali Rohár <pali@kernel.org>
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc-msi.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/controller/pcie-iproc-msi.c b/drivers/pci/controller/pcie-iproc-msi.c
index f40d17b285c5..b77811dcead1 100644
--- a/drivers/pci/controller/pcie-iproc-msi.c
+++ b/drivers/pci/controller/pcie-iproc-msi.c
@@ -252,18 +252,18 @@ static int iproc_msi_irq_domain_alloc(struct irq_domain *domain,
 
 	mutex_lock(&msi->bitmap_lock);
 
-	/* Allocate 'nr_cpus' number of MSI vectors each time */
-	hwirq = bitmap_find_next_zero_area(msi->bitmap, msi->nr_msi_vecs, 0,
-					   msi->nr_cpus, 0);
-	if (hwirq < msi->nr_msi_vecs) {
-		bitmap_set(msi->bitmap, hwirq, msi->nr_cpus);
-	} else {
-		mutex_unlock(&msi->bitmap_lock);
-		return -ENOSPC;
-	}
+	/*
+	 * Allocate 'nr_irqs' multiplied by 'nr_cpus' number of MSI vectors
+	 * each time
+	 */
+	hwirq = bitmap_find_free_region(msi->bitmap, msi->nr_msi_vecs,
+					order_base_2(msi->nr_cpus * nr_irqs));
 
 	mutex_unlock(&msi->bitmap_lock);
 
+	if (hwirq < 0)
+		return -ENOSPC;
+
 	for (i = 0; i < nr_irqs; i++) {
 		irq_domain_set_info(domain, virq + i, hwirq + i,
 				    &iproc_msi_bottom_irq_chip,
@@ -284,7 +284,8 @@ static void iproc_msi_irq_domain_free(struct irq_domain *domain,
 	mutex_lock(&msi->bitmap_lock);
 
 	hwirq = hwirq_to_canonical_hwirq(msi, data->hwirq);
-	bitmap_clear(msi->bitmap, hwirq, msi->nr_cpus);
+	bitmap_release_region(msi->bitmap, hwirq,
+			      order_base_2(msi->nr_cpus * nr_irqs));
 
 	mutex_unlock(&msi->bitmap_lock);
 
-- 
2.30.2



