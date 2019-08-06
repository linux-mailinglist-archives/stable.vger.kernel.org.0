Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5670283C36
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfHFVkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbfHFVgf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:36:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A71D2189F;
        Tue,  6 Aug 2019 21:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127395;
        bh=sJQ0flX8aMdGHMgwBXjvo+Gdotg6G7KS87LzViGvxkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rV8Vh6fAyGLj6Clmlx6h+9CFTXaP8WlJFYPbaLf6PaWCQICxfVweKPqxCXjrUi39D
         FEBdJs703Vzk3o6WY7fdeNLf1rscVYb+1xUs3PYybePC4y9akbS/6kR8JJtslYTttn
         hES34n4wlDRgczs2z/bRR7F9njIg1Sp7ERcpccXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 06/25] irqchip/irq-imx-gpcv2: Forward irq type to parent
Date:   Tue,  6 Aug 2019 17:36:03 -0400
Message-Id: <20190806213624.20194-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213624.20194-1-sashal@kernel.org>
References: <20190806213624.20194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 9a446ef08f3bfc0c3deb9c6be840af2528ef8cf8 ]

The GPCv2 is a stacked IRQ controller below the ARM GIC. It doesn't
care about the IRQ type itself, but needs to forward the type to the
parent IRQ controller, so this one can be configured correctly.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-gpcv2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-imx-gpcv2.c b/drivers/irqchip/irq-imx-gpcv2.c
index 675eda5ff2b85..e4831491a3c49 100644
--- a/drivers/irqchip/irq-imx-gpcv2.c
+++ b/drivers/irqchip/irq-imx-gpcv2.c
@@ -145,6 +145,7 @@ static struct irq_chip gpcv2_irqchip_data_chip = {
 	.irq_unmask		= imx_gpcv2_irq_unmask,
 	.irq_set_wake		= imx_gpcv2_irq_set_wake,
 	.irq_retrigger		= irq_chip_retrigger_hierarchy,
+	.irq_set_type		= irq_chip_set_type_parent,
 #ifdef CONFIG_SMP
 	.irq_set_affinity	= irq_chip_set_affinity_parent,
 #endif
-- 
2.20.1

