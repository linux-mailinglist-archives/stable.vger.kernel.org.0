Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C552D33B7B8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhCOOBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232749AbhCON7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA9ED64F70;
        Mon, 15 Mar 2021 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816761;
        bh=tgZj3yqf/KXD+4wRT62Trdip7UIaBMoObbf1nVfldlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZtfGnnfMl6ppZHJvs5ZeOLXII5gr9j6kzjDUkixH6DnDpmLPlcbEd5MdHYzqL5l+
         +DtgHUPD8qp0G11le2GNjQpTzIxxmj6yyAv606oZGlY8sFpJN0JTKoidXy5NCLfo3v
         DaQA/0rWbkM4QWX+DNsgw3z5YgXOV+bq78PY/KB8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/120] PCI: xgene-msi: Fix race in installing chained irq handler
Date:   Mon, 15 Mar 2021 14:56:42 +0100
Message-Id: <20210315135721.657402425@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 drivers/pci/controller/pci-xgene-msi.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene-msi.c b/drivers/pci/controller/pci-xgene-msi.c
index f4c02da84e59..0bfa5065b440 100644
--- a/drivers/pci/controller/pci-xgene-msi.c
+++ b/drivers/pci/controller/pci-xgene-msi.c
@@ -384,13 +384,9 @@ static int xgene_msi_hwirq_alloc(unsigned int cpu)
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



