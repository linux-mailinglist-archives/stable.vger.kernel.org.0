Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672D145D0BD
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352403AbhKXXIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352370AbhKXXIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B413610A1;
        Wed, 24 Nov 2021 23:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795107;
        bh=wHpvNaIZ8v0pug4/Z5vHHcFvT4++TpzarXrssDbXZVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGT8hJLa2T+zGc61SnGCNTlnCroqIHmL02VnEYJ8IKaHCz0ACCroW2zdcRzkCXRws
         0yhPDJqQzRDta3EdUNkwNXJ1tA+JmTat7s/SaYhp8niRmbS2ULzqzQxxiJTHcIatYi
         pfSDscfnre3vain3keXiz5NzW+riNSxKoXcdvnR4JrcS1lm49EA6zsvHNMwTfjx0ZA
         OZL4AcSt9zmGWtDj0TfdNAnSqlTeye/2peXEkqzsYP0wsJfth+6Hrhp1wnakDGQQav
         4dYLZR1Qauh3O7hRE+d0Ed3CDNPmq08Dk3DYv3xPES80YJSdSrAh1wnmYT0Z0be3lU
         2rVuqxjXwmQxA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Wen Yang <wen.yang99@zte.com.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 01/20] PCI: aardvark: Fix a leaked reference by adding missing of_node_put()
Date:   Thu, 25 Nov 2021 00:04:41 +0100
Message-Id: <20211124230500.27109-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

commit 3842f5166bf1ef286fe7a39f262b5c9581308366 upstream.

The call to of_get_next_child() returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

irq_domain_add_linear() also calls of_node_get() to increase refcount,
so irq_domain will not be affected when it is released.

Detected by coccinelle with the following warnings:
  ./drivers/pci/controller/pci-aardvark.c:826:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 798, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 98fb3c1f45e4..3625d73e016a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -754,6 +754,7 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	struct device_node *node = dev->of_node;
 	struct device_node *pcie_intc_node;
 	struct irq_chip *irq_chip;
+	int ret = 0;
 
 	raw_spin_lock_init(&pcie->irq_lock);
 
@@ -768,8 +769,8 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	irq_chip->name = devm_kasprintf(dev, GFP_KERNEL, "%s-irq",
 					dev_name(dev));
 	if (!irq_chip->name) {
-		of_node_put(pcie_intc_node);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_put_node;
 	}
 
 	irq_chip->irq_mask = advk_pcie_irq_mask;
@@ -781,11 +782,13 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 				      &advk_pcie_irq_domain_ops, pcie);
 	if (!pcie->irq_domain) {
 		dev_err(dev, "Failed to get a INTx IRQ domain\n");
-		of_node_put(pcie_intc_node);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_put_node;
 	}
 
-	return 0;
+out_put_node:
+	of_node_put(pcie_intc_node);
+	return ret;
 }
 
 static void advk_pcie_remove_irq_domain(struct advk_pcie *pcie)
-- 
2.32.0

