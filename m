Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130E82E405D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504238AbgL1Ovh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502074AbgL1OTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F8B9224D2;
        Mon, 28 Dec 2020 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165119;
        bh=rUkhfTFhb6tWMh+zw3onwkkUEj9Ixzld6HoSrjqd8Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJY8ZR5fcdYk89qZNyEG/rTQneeDq4m11isqR43glMEtRZeZDLbxh12CMtZXybcw6
         OWpJDPtBeFU+lL8AZc/J2bMHZFCZRhFFlx9sr3j3lVjZb4BfFoYs0DeuLw1+QT+dzp
         R7fW+lWMoP2xDRpct4RnbMX/kqN+L+oRN/rGUwJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 419/717] irqchip/ti-sci-inta: Fix printing of inta id on probe success
Date:   Mon, 28 Dec 2020 13:46:57 +0100
Message-Id: <20201228125041.035741124@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lokesh Vutla <lokeshvutla@ti.com>

[ Upstream commit b10d5fd489b0c67f59cbdd28d95f4bd9f76a62f2 ]

On a successful probe, the driver tries to print a success message with
INTA device id. It uses pdev->id for printing the id but id is stored in
inta->ti_sci_id. Fix it by correcting the dev_info parameter.

Fixes: 5c4b585d2910 ("irqchip/ti-sci-inta: Add support for INTA directly connecting to GIC")
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201102120614.11109-1-lokeshvutla@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-inta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-ti-sci-inta.c b/drivers/irqchip/irq-ti-sci-inta.c
index b2ab8db439d92..532d0ae172d9f 100644
--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -726,7 +726,7 @@ static int ti_sci_inta_irq_domain_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&inta->vint_list);
 	mutex_init(&inta->vint_mutex);
 
-	dev_info(dev, "Interrupt Aggregator domain %d created\n", pdev->id);
+	dev_info(dev, "Interrupt Aggregator domain %d created\n", inta->ti_sci_id);
 
 	return 0;
 }
-- 
2.27.0



