Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2A1B409B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgDVKQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbgDVKQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796EB2075A;
        Wed, 22 Apr 2020 10:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550585;
        bh=ZaYqdeRvQZPigS+ANvJSCa11Eqd6O2GHEYnBCZcLTBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jb8S1kHJGiz2hLB84li+8eFRniquru5rFnFXLVbBfPKvrc3wIKckVQ7huau1aXMzu
         I7zHnZGmh1BGIMS3Ihv2quBFkkC3QyB4d6nl4kpcUcza8CGEALCdWi6T1IkoJ0y0/w
         5au1exWSsXGr7F/KORV3lEBPJGhJdsAVi0J4jPS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 012/118] irqchip/mbigen: Free msi_desc on device teardown
Date:   Wed, 22 Apr 2020 11:56:13 +0200
Message-Id: <20200422095033.567991077@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

commit edfc23f6f9fdbd7825d50ac1f380243cde19b679 upstream.

Using irq_domain_free_irqs_common() on the irqdomain free path will
leave the MSI descriptor unfreed when platform devices get removed.
Properly free it by MSI domain free function.

Fixes: 9650c60ebfec0 ("irqchip/mbigen: Create irq domain for each mbigen device")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200408114352.1604-1-yuzenghui@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-mbigen.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-mbigen.c
+++ b/drivers/irqchip/irq-mbigen.c
@@ -220,10 +220,16 @@ static int mbigen_irq_domain_alloc(struc
 	return 0;
 }
 
+static void mbigen_irq_domain_free(struct irq_domain *domain, unsigned int virq,
+				   unsigned int nr_irqs)
+{
+	platform_msi_domain_free(domain, virq, nr_irqs);
+}
+
 static const struct irq_domain_ops mbigen_domain_ops = {
 	.translate	= mbigen_domain_translate,
 	.alloc		= mbigen_irq_domain_alloc,
-	.free		= irq_domain_free_irqs_common,
+	.free		= mbigen_irq_domain_free,
 };
 
 static int mbigen_of_create_domain(struct platform_device *pdev,


