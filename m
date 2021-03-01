Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE43291E1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243463AbhCAUfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243377AbhCAU2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:28:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE5F6541C;
        Mon,  1 Mar 2021 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622041;
        bh=mmLEWm9/Uv+UU8Nw93WgttKPyP8rae+RYS5MLgLdluk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov3j+QLB+MxUxiFqaLJSOxd+X06CFrBWOOfVF2v3qmhiqtXWG1RL9OGDHCuPfH0yq
         ZnhKcB7+qzaClnpzc7yFre0fp+C3y9JFv0FkDi85M3CrbZwyi2Zu7aVFoLQBr6LB5x
         h3H7WWW4TavVSXQL7/+qyXrM7aGEznq27Svt2bB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.11 736/775] irqchip/loongson-pch-msi: Use bitmap_zalloc() to allocate bitmap
Date:   Mon,  1 Mar 2021 17:15:04 +0100
Message-Id: <20210301161237.714439778@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

commit c1f664d2400e73d5ca0fcd067fa5847d2c789c11 upstream.

Currently we use bitmap_alloc() to allocate msi bitmap which should be
initialized with zero. This is obviously wrong but it works because msi
can fallback to legacy interrupt mode. So use bitmap_zalloc() instead.

Fixes: 632dcc2c75ef6de3272aa ("irqchip: Add Loongson PCH MSI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210209071051.2078435-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-loongson-pch-msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-loongson-pch-msi.c
+++ b/drivers/irqchip/irq-loongson-pch-msi.c
@@ -225,7 +225,7 @@ static int pch_msi_init(struct device_no
 		goto err_priv;
 	}
 
-	priv->msi_map = bitmap_alloc(priv->num_irqs, GFP_KERNEL);
+	priv->msi_map = bitmap_zalloc(priv->num_irqs, GFP_KERNEL);
 	if (!priv->msi_map) {
 		ret = -ENOMEM;
 		goto err_priv;


