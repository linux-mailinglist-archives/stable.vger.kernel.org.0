Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2D6BC1503
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfI2N76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbfI2N6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3EFF21835;
        Sun, 29 Sep 2019 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765515;
        bh=fArfNnT5vFYjofUn+0euUGANcA1sp8AW4rWpRpsRnTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/bbLoHaWfVeBl8Hl5LXrEAQqCJw0b8TPw7Jj1aBlT/4RMxYdG2iu6lzX8N850Ia+
         c3YWQeOAUba7kZQJnycky7Tn4NxgRBAaplGe7ZaCNDCi1P2+R9dg12kURpB/p/2nKp
         Bo3F+fbuHFXDL4fiq3UHFgw4XQr9nVlNVwvvZ1BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaxing Luo <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/63] irqchip/gic-v3-its: Fix LPI release for Multi-MSI devices
Date:   Sun, 29 Sep 2019 15:54:16 +0200
Message-Id: <20190929135039.298788031@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9ba73e11757d9..e7549a2b1482b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2514,14 +2514,13 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
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



