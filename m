Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B6106EF1
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfKVK5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbfKVK5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:57:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D474120718;
        Fri, 22 Nov 2019 10:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420268;
        bh=k5ZRh2ikyUYWBdoD1qh1lHWr6fCnKfqiDBwbD6/ssmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxQ9l1NRVi0ZZm8SvrlwxOCeIO+JFCr1b4xqyZxquZvs+qXNjfWQCCxXppxGLTXYj
         WSE32ajBIp4glUoIj+5lKouMqth/YWn92n63ETR1O4/tYm57Wf4c+epEyxrFTttiZR
         /XLVgHLeLhJwsS4PRJ9EKorQ5d7yVscBSOZj5yDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/220] irqchip/irq-mvebu-icu: Fix wrong private data retrieval
Date:   Fri, 22 Nov 2019 11:26:54 +0100
Message-Id: <20191122100915.728633762@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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
index 13063339b416d..a2a3acd744911 100644
--- a/drivers/irqchip/irq-mvebu-icu.c
+++ b/drivers/irqchip/irq-mvebu-icu.c
@@ -105,7 +105,7 @@ static int
 mvebu_icu_irq_domain_translate(struct irq_domain *d, struct irq_fwspec *fwspec,
 			       unsigned long *hwirq, unsigned int *type)
 {
-	struct mvebu_icu *icu = d->host_data;
+	struct mvebu_icu *icu = platform_msi_get_host_data(d);
 	unsigned int icu_group;
 
 	/* Check the count of the parameters in dt */
-- 
2.20.1



