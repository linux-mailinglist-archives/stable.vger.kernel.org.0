Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F8F29B6F3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798442AbgJ0P2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797162AbgJ0PVz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:21:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D7C820728;
        Tue, 27 Oct 2020 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812114;
        bh=ozyLgpXHqosmv35bnuQ3dUi+EEKOVW8d1oUoxx9+eOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsolK2ihHDkm394GLg82y+CU+yqhzsKotk8JkyU1TcFSVGXDSvGe0/OqX2oVkY2cm
         Ug8gZK2bEU0cE1lHVPcrjDmMzgRDRwCJO2AnTZzaDApte9uUWhGV4XuGtpJmo0jbYi
         TX1PPYldKF4z2sJ+5fe1UMDtjwjth0j3+F+VwA6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 097/757] irqchip/ti-sci-intr: Fix unsigned comparison to zero
Date:   Tue, 27 Oct 2020 14:45:47 +0100
Message-Id: <20201027135455.100196817@linuxfoundation.org>
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

[ Upstream commit 8ddf1905a904ca86d71ca1c435e4b0b2a0b70df8 ]

ti_sci_intr_xlate_irq() return -ENOENT on fail, p_hwirq
should be int type.

Fixes: a5b659bd4bc7 ("irqchip/ti-sci-intr: Add support for INTR being a parent to INTR")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Lokesh Vutla <lokeshvutla@ti.com>
Link: https://lore.kernel.org/r/20200826035321.18620-1-yuehaibing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-ti-sci-intr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-ti-sci-intr.c b/drivers/irqchip/irq-ti-sci-intr.c
index cbc1758228d9e..85a72b56177cf 100644
--- a/drivers/irqchip/irq-ti-sci-intr.c
+++ b/drivers/irqchip/irq-ti-sci-intr.c
@@ -137,8 +137,8 @@ static int ti_sci_intr_alloc_parent_irq(struct irq_domain *domain,
 	struct ti_sci_intr_irq_domain *intr = domain->host_data;
 	struct device_node *parent_node;
 	struct irq_fwspec fwspec;
-	u16 out_irq, p_hwirq;
-	int err = 0;
+	int p_hwirq, err = 0;
+	u16 out_irq;
 
 	out_irq = ti_sci_get_free_resource(intr->out_irqs);
 	if (out_irq == TI_SCI_RESOURCE_NULL)
-- 
2.25.1



