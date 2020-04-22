Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54F31B3D54
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgDVKOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729466AbgDVKOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:14:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A5220775;
        Wed, 22 Apr 2020 10:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550440;
        bh=3Z5JyLwQNBx9DKwIuJSFdTwrYfhOFuoxKbc227IbNgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cdh8giHBOE/HgIAELwMKhvj3Snr4ueaLWgPdpvpPE2NBbGjURrfgVjIk/fEEUBM9f
         ETlxQr0ap+tfX59trXLGunIqwpCZzKX+TeQ/juoCpxap0cDISk5xUXux9e3b91Lshm
         oJ+vr8wjDzGMjXjuzh3f593SZKjfItoIQGNPedm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 09/64] irqchip/mbigen: Free msi_desc on device teardown
Date:   Wed, 22 Apr 2020 11:56:53 +0200
Message-Id: <20200422095014.189446952@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
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
@@ -231,10 +231,16 @@ static int mbigen_irq_domain_alloc(struc
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


