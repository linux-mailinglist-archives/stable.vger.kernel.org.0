Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792A229B7E6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798459AbgJ0P2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797151AbgJ0PVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:21:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BABB21527;
        Tue, 27 Oct 2020 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812112;
        bh=U3vO92lsyXzc2mm4IVenesA7XJKdMDlQWyd4Ek9E9qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/0pvupA7nPNnFgxtl82kFc8gY6Gr0XPQowEN6kuNpYXoxhq9NEQO2wkmd4ph31Qb
         969Vy3d507FNaaa2eY7lMrAm1WSTX7NaHDBk9YFKgK+vR7OUiRXF2Y1dju9r82Wu8g
         VH5pACiitmhVOwUXyE+OdhUbfZ4laXg9wR/PAnF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 096/757] irqchip/ti-sci-inta: Fix unsigned comparison to zero
Date:   Tue, 27 Oct 2020 14:45:46 +0100
Message-Id: <20201027135455.052013671@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 4c9b1bfaa5039fee650f4de514a8e70ae976fc2f ]

ti_sci_inta_xlate_irq() return -ENOENT on fail, p_hwirq
should be int type.

Fixes: 5c4b585d2910 ("irqchip/ti-sci-inta: Add support for INTA directly connecting to GIC")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Lokesh Vutla <lokeshvutla@ti.com>
Link: https://lore.kernel.org/r/20200826035430.21060-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-inta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-ti-sci-inta.c b/drivers/irqchip/irq-ti-sci-inta.c
index d4e97605456bb..05bf94b87b938 100644
--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -175,8 +175,8 @@ static struct ti_sci_inta_vint_desc *ti_sci_inta_alloc_parent_irq(struct irq_dom
 	struct irq_fwspec parent_fwspec;
 	struct device_node *parent_node;
 	unsigned int parent_virq;
-	u16 vint_id, p_hwirq;
-	int ret;
+	int p_hwirq, ret;
+	u16 vint_id;
 
 	vint_id = ti_sci_get_free_resource(inta->vint);
 	if (vint_id == TI_SCI_RESOURCE_NULL)
-- 
2.25.1



