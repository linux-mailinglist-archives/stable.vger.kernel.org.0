Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1BD246979
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgHQPWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbgHQPWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:22:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0334520888;
        Mon, 17 Aug 2020 15:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677741;
        bh=9SWCTvbJ98KOQ9GVIu50Cbq1XurQ6Ach9phYfuzlA6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOnfwM6p3Rv+eRL85obHIRIbwiTSRcfD9ZT5tVXm4urnKRLR1Z9TJfVUqKVIBs2hF
         sT5uRJ0ypQy7hKoV83hh6/F1Auqm3FErOnNUt0E33DI0l5S7KqbKOg+WbHgp7w02VF
         tDr3LTdPtWIfdpMCLOENENw1mP8oLSpRXR/Xh+fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Marc Zyngier <maz@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 060/464] irqchip/ti-sci-inta: Fix return value about devm_ioremap_resource()
Date:   Mon, 17 Aug 2020 17:10:13 +0200
Message-Id: <20200817143836.639682960@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 4b127a14cb1385dd355c7673d975258d5d668922 ]

When call function devm_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Fixes: 9f1463b86c13 ("irqchip/ti-sci-inta: Add support for Interrupt Aggregator driver")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
Link: https://lore.kernel.org/r/1591437017-5295-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-inta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-ti-sci-inta.c b/drivers/irqchip/irq-ti-sci-inta.c
index 7e3ebf6ed2cd1..be0a35d917962 100644
--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -572,7 +572,7 @@ static int ti_sci_inta_irq_domain_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	inta->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(inta->base))
-		return -ENODEV;
+		return PTR_ERR(inta->base);
 
 	domain = irq_domain_add_linear(dev_of_node(dev),
 				       ti_sci_get_num_resources(inta->vint),
-- 
2.25.1



