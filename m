Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733FF314D69
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 11:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhBIKq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 05:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbhBIKox (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 05:44:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E9DC06178C;
        Tue,  9 Feb 2021 02:44:13 -0800 (PST)
Date:   Tue, 09 Feb 2021 10:44:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612867445;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uwpeo3Pc3rJ7rsLPJvMVrXq2Xz/8Zo2qpdp9T3CjP+A=;
        b=4lnjtjhMBByXj5Un84y0tpQPHXN1AcHBulU+B887OhzllNhTSBdQ0U+Xo2MExeX3RxNotj
        AuRHxkBwkLuDnxLKVNeq7+zU9sGN931bVCyFuolU5uGceA76wnb00xNOJ2ScFWl0hwuZpT
        d13viJaq1jNYHW0OA8/Zmqw15fNapzAq6GvwMjtaeulEpRN/CbebYgdEMXxDoxJtsz3nJy
        2DCaoJ4pHsKVhSrGddvZKbJ9QJQmuj8IsDSI4lNE9C8EedEeR1sK5ir/znpeOWVktNDZUu
        CGg8eO+/G1MDL+MtWyEcGn9BX9SZmvaDedNFqyh3onUPT80sMCkNXzNEGnyKNg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612867445;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uwpeo3Pc3rJ7rsLPJvMVrXq2Xz/8Zo2qpdp9T3CjP+A=;
        b=7jDFlVdOIJGu9Ybix5yN9yNjJZwPDCZ50q7lPP/dFiI73avwDgMliEw6r1cuvBH4zdyK2f
        wCJVdMasPDwuSxDg==
From:   "irqchip-bot for Huacai Chen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/loongson-pch-msi: Use
 bitmap_zalloc() to allocate bitmap
Cc:     stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20210209071051.2078435-1-chenhuacai@loongson.cn>
References: <20210209071051.2078435-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Message-ID: <161286744434.23325.15913380078296596924.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     c1f664d2400e73d5ca0fcd067fa5847d2c789c11
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/c1f664d2400e73d5ca0fcd067fa5847d2c789c11
Author:        Huacai Chen <chenhuacai@loongson.cn>
AuthorDate:    Tue, 09 Feb 2021 15:10:51 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Tue, 09 Feb 2021 10:41:40 

irqchip/loongson-pch-msi: Use bitmap_zalloc() to allocate bitmap

Currently we use bitmap_alloc() to allocate msi bitmap which should be
initialized with zero. This is obviously wrong but it works because msi
can fallback to legacy interrupt mode. So use bitmap_zalloc() instead.

Fixes: 632dcc2c75ef6de3272aa ("irqchip: Add Loongson PCH MSI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210209071051.2078435-1-chenhuacai@loongson.cn
---
 drivers/irqchip/irq-loongson-pch-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-msi.c b/drivers/irqchip/irq-loongson-pch-msi.c
index 12aeeab..32562b7 100644
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
