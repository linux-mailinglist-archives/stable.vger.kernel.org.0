Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85FC328BC8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbhCASiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhCASdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:33:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC92865090;
        Mon,  1 Mar 2021 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619922;
        bh=mmLEWm9/Uv+UU8Nw93WgttKPyP8rae+RYS5MLgLdluk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8q5GZ8AgGnXJ3mQnSI8Rcb2u/g7gL82aTQ+eg7Edobzy1tAmrbQ+DFg1TIZSuFPr
         wSmk5Br/a2u1npXVICOjO/bpzTbepgsE72lY/LS84VYZ1vIDlCEsdFRghuoOlc3alN
         h+vGPCzcmMlx3toGYoE8o41Mg3CbLYRpDc+5sXnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhuacai@loongson.cn>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 630/663] irqchip/loongson-pch-msi: Use bitmap_zalloc() to allocate bitmap
Date:   Mon,  1 Mar 2021 17:14:38 +0100
Message-Id: <20210301161213.024738231@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


