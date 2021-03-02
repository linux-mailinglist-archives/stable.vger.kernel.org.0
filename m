Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BDA32B021
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhCCAbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351015AbhCBNDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD3B64FB4;
        Tue,  2 Mar 2021 11:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686354;
        bh=jU4kWJYQHfR0aAfQPcS4kqkjBdaWff57P6igI62WjtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O455QuwmnWSs65YGF3JL3LnTAnEKSgVzxHlEv6iqZNP6xm6R/SjEwvzVgm8I9RO7L
         X8i4J3NAiLTrVpdkiOU5YXhKHRmwIGrG73h52pWB4gjvaWeIpDkucyzOQxptU+3GLB
         SQJNjg6cnugrnYTHA74gscbqWyIoCxMa5AfYxxKURZDPkLZu8a5Va1lGj248EJg9Qk
         gyw85MA9/SqYGpNANWIf1eVHQRT6/Dol3p72ZBqkqVuchH4+LThWAeI0HFJvqNPaqB
         xMwFpjBzmz8GfuV1217P7imGIYIzVz3vwXg9Gt/aAYPjlWLveScxl9SUzWaJbf/W/u
         NQNOEJxAK+XUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Kaiser <martin@kaiser.cx>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 08/13] PCI: xgene-msi: Fix race in installing chained irq handler
Date:   Tue,  2 Mar 2021 06:58:58 -0500
Message-Id: <20210302115903.63458-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115903.63458-1-sashal@kernel.org>
References: <20210302115903.63458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit a93c00e5f975f23592895b7e83f35de2d36b7633 ]

Fix a race where a pending interrupt could be received and the handler
called before the handler's data has been setup, by converting to
irq_set_chained_handler_and_data().

See also 2cf5a03cb29d ("PCI/keystone: Fix race in installing chained IRQ
handler").

Based on the mail discussion, it seems ok to drop the error handling.

Link: https://lore.kernel.org/r/20210115212435.19940-3-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pci-xgene-msi.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/host/pci-xgene-msi.c b/drivers/pci/host/pci-xgene-msi.c
index 1f42a202b021..784b3f61199e 100644
--- a/drivers/pci/host/pci-xgene-msi.c
+++ b/drivers/pci/host/pci-xgene-msi.c
@@ -393,13 +393,9 @@ static int xgene_msi_hwirq_alloc(unsigned int cpu)
 		if (!msi_group->gic_irq)
 			continue;
 
-		irq_set_chained_handler(msi_group->gic_irq,
-					xgene_msi_isr);
-		err = irq_set_handler_data(msi_group->gic_irq, msi_group);
-		if (err) {
-			pr_err("failed to register GIC IRQ handler\n");
-			return -EINVAL;
-		}
+		irq_set_chained_handler_and_data(msi_group->gic_irq,
+			xgene_msi_isr, msi_group);
+
 		/*
 		 * Statically allocate MSI GIC IRQs to each CPU core.
 		 * With 8-core X-Gene v1, 2 MSI GIC IRQs are allocated
-- 
2.30.1

