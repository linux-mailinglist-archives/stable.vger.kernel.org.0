Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BFE2E6814
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgL1NEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgL1NEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E285B22A84;
        Mon, 28 Dec 2020 13:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160630;
        bh=1c16DeVlrkOsAw+l3Lm1Es+96/1hWK5NAZRQZL8BiEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2R83XmC2u9YeIxzGtH/XgH4Uj2+gWXWmgqNCU0JNEXGH8zI+ccCGQ1fz6yQEKBZg
         9tnaX6xiKWq8u2MFxo376Sh8NMcitcmxqcXmqQ8AQGrdk/aplcE5dvXNLArcJbrWO7
         5eX5/ubv29hDvWhzkjA3/BzQRQoqFEYyse9uwJaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Tsahee Zidenberg <tsahee@annapurnalabs.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 115/175] irqchip/alpine-msi: Fix freeing of interrupts on allocation error path
Date:   Mon, 28 Dec 2020 13:49:28 +0100
Message-Id: <20201228124858.825585388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 3841245e8498a789c65dedd7ffa8fb2fee2c0684 ]

The alpine-msi driver has an interesting allocation error handling,
where it frees the same interrupts repeatedly. Hilarity follows.

This code is probably never executed, but let's fix it nonetheless.

Fixes: e6b78f2c3e14 ("irqchip: Add the Alpine MSIX interrupt controller")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Cc: Tsahee Zidenberg <tsahee@annapurnalabs.com>
Cc: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/20201129135525.396671-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-alpine-msi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index 63d980995d17d..ac431697ebe1c 100644
--- a/drivers/irqchip/irq-alpine-msi.c
+++ b/drivers/irqchip/irq-alpine-msi.c
@@ -165,8 +165,7 @@ static int alpine_msix_middle_domain_alloc(struct irq_domain *domain,
 	return 0;
 
 err_sgi:
-	while (--i >= 0)
-		irq_domain_free_irqs_parent(domain, virq, i);
+	irq_domain_free_irqs_parent(domain, virq, i - 1);
 	alpine_msix_free_sgi(priv, sgi, nr_irqs);
 	return err;
 }
-- 
2.27.0



