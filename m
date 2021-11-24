Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891DF45D061
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352139AbhKXWxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244982AbhKXWw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:52:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A48661074;
        Wed, 24 Nov 2021 22:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794189;
        bh=lkmT5oUlkagVlqjx9WivqLmmqv3j4oR0Fkd27SiI9C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jb4E+Qe5UZqAUcdCXVzrgNg6QELBAq/wZCszFsb7f7PD5iPp4idomPWsS0TK5HXzI
         xjt5FrWxfRGhd80jw2nAH90/s6GRBebFKW3XbS7DxZkjhSNPn3WX8OnEb1IeteanOW
         x8F9njdXS+z1vjYD0jvWqxVHk1TebD2ojpZb1jA8m0eMPz4sJ6CFaOGJXo6adqnf2e
         nYeD2PigtsY/eprAhUrsqaE7MBusY1UlTTUiJfYJc0W0sJeErTTmOduCX7blzWoeRV
         8aIb3oNxgZ0nsemC+D0BY8DDoAE02ZNfxOo516EOI92n0Hd8nsH9MUeQKCc/SyN7mo
         EfEvIxkP9smkA==
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
Subject: [PATCH 4.14 02/24] PCI: aardvark: Fix a leaked reference by adding missing of_node_put()
Date:   Wed, 24 Nov 2021 23:49:11 +0100
Message-Id: <20211124224933.24275-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
 drivers/pci/host/pci-aardvark.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index fd605796b011..79cd11b1c89a 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -789,6 +789,7 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	struct device_node *node = dev->of_node;
 	struct device_node *pcie_intc_node;
 	struct irq_chip *irq_chip;
+	int ret = 0;
 
 	raw_spin_lock_init(&pcie->irq_lock);
 
@@ -803,8 +804,8 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
 	irq_chip->name = devm_kasprintf(dev, GFP_KERNEL, "%s-irq",
 					dev_name(dev));
 	if (!irq_chip->name) {
-		of_node_put(pcie_intc_node);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_put_node;
 	}
 
 	irq_chip->irq_mask = advk_pcie_irq_mask;
@@ -816,11 +817,13 @@ static int advk_pcie_init_irq_domain(struct advk_pcie *pcie)
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

