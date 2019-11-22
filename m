Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66705106C51
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfKVKvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbfKVKvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:51:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9EAD2075B;
        Fri, 22 Nov 2019 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419865;
        bh=aO/bn3g/L37I+yaRgds2a8RKO4/vCXQ9XJIrNV99pwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=behkjgG3VRMJ4WXZsBUtIb5DfQCSr0NHrblIhI1ub/WI5lp1pfo3QrMQaaWgFEWpp
         z7cUpog5ndesky5lNktv2gXgdjpwMOXzaLnmcEh8Fcg58gszebhU+R+mM7f9xz5qdk
         qEhVM/7+EDBabXr1i6tXN3xhb1o0LnBGKgF61hBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/122] irqchip/irq-mvebu-icu: Fix wrong private data retrieval
Date:   Fri, 22 Nov 2019 11:28:01 +0100
Message-Id: <20191122100744.712952402@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 2b4dab69dcca13c5be2ddaf1337ae4accd087de6 ]

The irq_domain structure has an host_data pointer that just stores
private data. It is meant to not be touched by the IRQ core. However,
when it comes to MSI, the MSI layer adds its own private data there
with a structure that also has a host_data pointer.

Because this IRQ domain is an MSI domain, to access private data we
should do a d->host_data->host_data, also wrapped as
'platform_msi_get_host_data()'.

This bug was lying there silently because the 'icu' structure retrieved
this way was just called by dev_err(), only producing a
'(NULL device *):' output on the console.

Reviewed-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mvebu-icu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mvebu-icu.c b/drivers/irqchip/irq-mvebu-icu.c
index e18c48d3a92e7..6a77b9ea8e418 100644
--- a/drivers/irqchip/irq-mvebu-icu.c
+++ b/drivers/irqchip/irq-mvebu-icu.c
@@ -92,7 +92,7 @@ static int
 mvebu_icu_irq_domain_translate(struct irq_domain *d, struct irq_fwspec *fwspec,
 			       unsigned long *hwirq, unsigned int *type)
 {
-	struct mvebu_icu *icu = d->host_data;
+	struct mvebu_icu *icu = platform_msi_get_host_data(d);
 	unsigned int icu_group;
 
 	/* Check the count of the parameters in dt */
-- 
2.20.1



