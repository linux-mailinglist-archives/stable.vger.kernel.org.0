Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F8AFA440
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfKMCPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729528AbfKMB4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E572245A;
        Wed, 13 Nov 2019 01:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610210;
        bh=aO/bn3g/L37I+yaRgds2a8RKO4/vCXQ9XJIrNV99pwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRrDGV3RjIMvwKsdFkyDvd9M5M+vI772zSkHXKtzAjyRYU3KOFEu/kpzcomrlRADZ
         WmxOVQMRoj3AvoSv2lsxKOyULjOHQRExdMOLjGrBpKcUdvyV4QNKHkB6o1B2qKZraL
         qcgV4EGtW9E+z9uIH4TPTpFY7yCnn9LnpFUI4LMY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 020/115] irqchip/irq-mvebu-icu: Fix wrong private data retrieval
Date:   Tue, 12 Nov 2019 20:54:47 -0500
Message-Id: <20191113015622.11592-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

