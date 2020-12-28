Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A662E3B94
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407002AbgL1Nvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405759AbgL1Nvw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A5120715;
        Mon, 28 Dec 2020 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163491;
        bh=FMkKkDgfoQxTyWnUE2Qst9nVebKm1Hc8yMuI6M2USe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2e6RhgZmseLC7L9DxwCUqS91bBscIGx8LYn3rGRj7Uxx5yMV47Kjp3qFImsI4Yxrg
         YFz6UGDq3iGRe0sdn/+sUVVJl57Qt7PxfzWyIMRZQM95jGdAJ9s0sJl75VvfM7EhO1
         qcxmzYLmF/sya8EpjsnQhrhe+yxtlz1iBN39R5wM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Tsahee Zidenberg <tsahee@annapurnalabs.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 274/453] irqchip/alpine-msi: Fix freeing of interrupts on allocation error path
Date:   Mon, 28 Dec 2020 13:48:30 +0100
Message-Id: <20201228124950.415054810@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 23a3b877f7f1d..ede02dc2bcd0b 100644
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



