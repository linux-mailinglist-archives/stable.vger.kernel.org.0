Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52A6241030
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgHJTLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbgHJTLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:11:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E13C20885;
        Mon, 10 Aug 2020 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086669;
        bh=7wBE4qxQd8JzuuczTOr2/54TrG7cCXcr/aXR5tTrfzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLl4ZN4nYq132Qy00JIW4jLgthVtl6VIhd7ZlMgAD4BMPm/TfwczuynCBjB6b0qRu
         i50wFhXhhyM0sfseIB/5gbl2OYeXbggwZlhvzgrJYEdz7+1vAkeRiMPyZfcpIblXuD
         VNl2EwtU77nNVQAPbHNcsmk3Ip9C5pbzTxcLESD8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 30/60] irqchip/irq-mtk-sysirq: Replace spinlock with raw_spinlock
Date:   Mon, 10 Aug 2020 15:09:58 -0400
Message-Id: <20200810191028.3793884-30-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 6eeb997ab5075e770a002c51351fa4ec2c6b5c39 ]

This driver may take a regular spinlock when a raw spinlock
(irq_desc->lock) is already taken which results in the following
lockdep splat:

=============================
[ BUG: Invalid wait context ]
5.7.0-rc7 #1 Not tainted
-----------------------------
swapper/0/0 is trying to lock:
ffffff800303b798 (&chip_data->lock){....}-{3:3}, at: mtk_sysirq_set_type+0x48/0xc0
other info that might help us debug this:
context-{5:5}
2 locks held by swapper/0/0:
 #0: ffffff800302ee68 (&desc->request_mutex){....}-{4:4}, at: __setup_irq+0xc4/0x8a0
 #1: ffffff800302ecf0 (&irq_desc_lock_class){....}-{2:2}, at: __setup_irq+0xe4/0x8a0
stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.7.0-rc7 #1
Hardware name: Pumpkin MT8516 (DT)
Call trace:
 dump_backtrace+0x0/0x180
 show_stack+0x14/0x20
 dump_stack+0xd0/0x118
 __lock_acquire+0x8c8/0x2270
 lock_acquire+0xf8/0x470
 _raw_spin_lock_irqsave+0x50/0x78
 mtk_sysirq_set_type+0x48/0xc0
 __irq_set_trigger+0x58/0x170
 __setup_irq+0x420/0x8a0
 request_threaded_irq+0xd8/0x190
 timer_of_init+0x1e8/0x2c4
 mtk_gpt_init+0x5c/0x1dc
 timer_probe+0x74/0xf4
 time_init+0x14/0x44
 start_kernel+0x394/0x4f0

Replace the spinlock_t with raw_spinlock_t to avoid this warning.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200615074445.3579-1-brgl@bgdev.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mtk-sysirq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-mtk-sysirq.c b/drivers/irqchip/irq-mtk-sysirq.c
index 73eae5966a403..6ff98b87e5c04 100644
--- a/drivers/irqchip/irq-mtk-sysirq.c
+++ b/drivers/irqchip/irq-mtk-sysirq.c
@@ -15,7 +15,7 @@
 #include <linux/spinlock.h>
 
 struct mtk_sysirq_chip_data {
-	spinlock_t lock;
+	raw_spinlock_t lock;
 	u32 nr_intpol_bases;
 	void __iomem **intpol_bases;
 	u32 *intpol_words;
@@ -37,7 +37,7 @@ static int mtk_sysirq_set_type(struct irq_data *data, unsigned int type)
 	reg_index = chip_data->which_word[hwirq];
 	offset = hwirq & 0x1f;
 
-	spin_lock_irqsave(&chip_data->lock, flags);
+	raw_spin_lock_irqsave(&chip_data->lock, flags);
 	value = readl_relaxed(base + reg_index * 4);
 	if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_EDGE_FALLING) {
 		if (type == IRQ_TYPE_LEVEL_LOW)
@@ -53,7 +53,7 @@ static int mtk_sysirq_set_type(struct irq_data *data, unsigned int type)
 
 	data = data->parent_data;
 	ret = data->chip->irq_set_type(data, type);
-	spin_unlock_irqrestore(&chip_data->lock, flags);
+	raw_spin_unlock_irqrestore(&chip_data->lock, flags);
 	return ret;
 }
 
@@ -212,7 +212,7 @@ static int __init mtk_sysirq_of_init(struct device_node *node,
 		ret = -ENOMEM;
 		goto out_free_which_word;
 	}
-	spin_lock_init(&chip_data->lock);
+	raw_spin_lock_init(&chip_data->lock);
 
 	return 0;
 
-- 
2.25.1

