Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95311B303
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388206AbfLKPkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:40:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388434AbfLKPib (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F198524656;
        Wed, 11 Dec 2019 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078710;
        bh=XAlmk93Kl6MODzxZ/JUg0dDVy2/6qw2U8APbTx7Z2zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i++ElNI3omGOgCjkQ8P6bznUZGCi68ksI6asSyyLjtBap/fpr0I1AqjXQ874vSTxV
         yrSM5GqevGYoerLvluiQdpvcXZZqtu18w2m6j7pFgL6t+ZjQfbLt/WNXEKry4fMZgX
         UOx80aIvTVz2Zlbrw7bW3VHLwxrA/0OyMmyVAIng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-mips@linux-mips.org
Subject: [PATCH AUTOSEL 4.4 16/37] irqchip/irq-bcm7038-l1: Enable parent IRQ if necessary
Date:   Wed, 11 Dec 2019 10:37:52 -0500
Message-Id: <20191211153813.24126-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
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
index 6fb34bf0f3527..34e13623f29d7 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -283,6 +283,10 @@ static int __init bcm7038_l1_init_one(struct device_node *dn,
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

