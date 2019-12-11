Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C3D11B721
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbfLKQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730045AbfLKPMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 801392467D;
        Wed, 11 Dec 2019 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077167;
        bh=0qzmkhe0xFH/EPUkezqD+PQOlzAtaEDDqNdrCSv+N8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtJXMu1NiR2SCl8bAWzEL6qt39s38nEn264MIUJEf/iROLkbiAvCVabzXz19OEvOP
         l1KpAYlE4CZcyEnvy9PpProSLT8WADv5Uya6fimewjiEtOzcCJoXLu7CVwEOBpKCSm
         j2L+h1f3uN50kh/Vr/Q0hcGgVfsCpI1zQ2NjMQ+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mips@linux-mips.org
Subject: [PATCH AUTOSEL 5.4 052/134] irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary
Date:   Wed, 11 Dec 2019 10:10:28 -0500
Message-Id: <20191211151150.19073-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 27eebb60357ed5aa6659442f92907c0f7368d6ae ]

If the 'brcm,irq-can-wake' property is specified, make sure we also
enable the corresponding parent interrupt we are attached to.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20191024201415.23454-4-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm7038-l1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-bcm7038-l1.c b/drivers/irqchip/irq-bcm7038-l1.c
index fc75c61233aaf..58bec21269661 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -281,6 +281,10 @@ static int __init bcm7038_l1_init_one(struct device_node *dn,
 		pr_err("failed to map parent interrupt %d\n", parent_irq);
 		return -EINVAL;
 	}
+
+	if (of_property_read_bool(dn, "brcm,irq-can-wake"))
+		enable_irq_wake(parent_irq);
+
 	irq_set_chained_handler_and_data(parent_irq, bcm7038_l1_irq_handle,
 					 intc);
 
-- 
2.20.1

