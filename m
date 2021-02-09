Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FA8314951
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 08:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBIHMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhBIHMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 02:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02CDD64E9D;
        Tue,  9 Feb 2021 07:11:59 +0000 (UTC)
From:   Huacai Chen <chenhuacai@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: [PATCH] irqchip/loongson-pch-msi: Use bitmap_zalloc() to allocate bitmap
Date:   Tue,  9 Feb 2021 15:10:51 +0800
Message-Id: <20210209071051.2078435-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently we use bitmap_alloc() to allocate msi bitmap which should be
initialized with zero. This is obviously wrong but it works because msi
can fallback to legacy interrupt mode. So use bitmap_zalloc() instead.

Fixes: 632dcc2c75ef6de3272aa ("irqchip: Add Loongson PCH MSI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/irqchip/irq-loongson-pch-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-msi.c b/drivers/irqchip/irq-loongson-pch-msi.c
index 12aeeab43289..32562b7e681b 100644
--- a/drivers/irqchip/irq-loongson-pch-msi.c
+++ b/drivers/irqchip/irq-loongson-pch-msi.c
@@ -225,7 +225,7 @@ static int pch_msi_init(struct device_node *node,
 		goto err_priv;
 	}
 
-	priv->msi_map = bitmap_alloc(priv->num_irqs, GFP_KERNEL);
+	priv->msi_map = bitmap_zalloc(priv->num_irqs, GFP_KERNEL);
 	if (!priv->msi_map) {
 		ret = -ENOMEM;
 		goto err_priv;
-- 
2.27.0

