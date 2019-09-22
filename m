Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5F5BA8E6
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbfIVTJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395032AbfIVS7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:59:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F0D21D6C;
        Sun, 22 Sep 2019 18:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178750;
        bh=vVO98uKnCrWzvCx0/1+0fFpO60BbjWNePNjbmaUcMxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5Uw7FetXyitxdHjZSFMQuH+Lspyhtrq3EKbVAVLdLcVaE936jiMNvpkrLjQrRV3f
         DkvGkqB7dc3pp4y5f3I4MHa2qRPJkgb43zqQ9g3GC84J7zTkAUqmK4W3aNVSZRpY5/
         1aK1esN9ZeTTYhPXZOqTlPY58He/uSHW1LQIUIWU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Jiaxing Luo <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 75/89] irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices
Date:   Sun, 22 Sep 2019 14:57:03 -0400
Message-Id: <20190922185717.3412-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
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
index f80666acb9efd..52238e6bed392 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2269,14 +2269,13 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 	struct its_node *its = its_dev->its;
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

