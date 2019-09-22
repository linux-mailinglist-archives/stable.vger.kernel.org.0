Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF87BA861
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfIVTCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438984AbfIVTAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EAF6214D9;
        Sun, 22 Sep 2019 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178842;
        bh=6OBD0aBevgYHmrpLYBQqh87qftSvBxuBak2GXZSsGdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Xq23ExRd4bgi+L+T3SIHthCr3BL+ll8h+z81bZ8erGU0POKG/fuAfpuvvcDbyjAH
         RRFkDKIrWbYJ0rWIfHTbDj4qO4q19hZAJgEO5eEH5EHcVQRnjhNfbIrukQfViU1s8u
         PVtdt8HGHa1PAx9wosGl0k+u6fR3wifIAQUQfzm0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Jiaxing Luo <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 50/60] irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices
Date:   Sun, 22 Sep 2019 14:59:23 -0400
Message-Id: <20190922185934.4305-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit c9c96e30ecaa0aafa225aa1a5392cb7db17c7a82 ]

When allocating a range of LPIs for a Multi-MSI capable device,
this allocation extended to the closest power of 2.

But on the release path, the interrupts are released one by
one. This results in not releasing the "extra" range, leaking
the its_device. Trying to reprobe the device will then fail.

Fix it by releasing the LPIs the same way we allocate them.

Fixes: 8208d1708b88 ("irqchip/gic-v3-its: Align PCI Multi-MSI allocation on their size")
Reported-by: Jiaxing Luo <luojiaxing@huawei.com>
Tested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/f5e948aa-e32f-3f74-ae30-31fee06c2a74@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 83ca754250fb7..0c0cd2768d6e9 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1519,14 +1519,13 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	int i;
 
+	bitmap_release_region(its_dev->event_map.lpi_map,
+			      its_get_event_id(irq_domain_get_irq_data(domain, virq)),
+			      get_count_order(nr_irqs));
+
 	for (i = 0; i < nr_irqs; i++) {
 		struct irq_data *data = irq_domain_get_irq_data(domain,
 								virq + i);
-		u32 event = its_get_event_id(data);
-
-		/* Mark interrupt index as unused */
-		clear_bit(event, its_dev->event_map.lpi_map);
-
 		/* Nuke the entry in the domain */
 		irq_domain_reset_irq_data(data);
 	}
-- 
2.20.1

