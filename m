Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11203461D81
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351083AbhK2SZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:25:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47108 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhK2SXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:23:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85439CE13D7;
        Mon, 29 Nov 2021 18:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF96C53FAD;
        Mon, 29 Nov 2021 18:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210024;
        bh=GZGDxE8s+2V561z3QS8z0po771bfpbHBVhYMNFTZPXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdRIBtvTmf88vjKsGmMH9hHm+a/vb274PqujYc45fWeJ+2D/XfPivh3HfEdViVr9u
         uGJYOPYnk4jmyK45kkr9b+IO7KxWUpvCKzKI9dpfgxLC/mNVhjXo8gXMGO4yGVq6xp
         fcVsa8a4sJv1MAIaQaKDD3DzIoMrZwMsOgv84pao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 17/69] PCI: aardvark: Fix a leaked reference by adding missing of_node_put()
Date:   Mon, 29 Nov 2021 19:17:59 +0100
Message-Id: <20211129181704.225629103@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -754,6 +754,7 @@ static int advk_pcie_init_irq_domain(str
 	struct device_node *node = dev->of_node;
 	struct device_node *pcie_intc_node;
 	struct irq_chip *irq_chip;
+	int ret = 0;
 
 	raw_spin_lock_init(&pcie->irq_lock);
 
@@ -768,8 +769,8 @@ static int advk_pcie_init_irq_domain(str
 	irq_chip->name = devm_kasprintf(dev, GFP_KERNEL, "%s-irq",
 					dev_name(dev));
 	if (!irq_chip->name) {
-		of_node_put(pcie_intc_node);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_put_node;
 	}
 
 	irq_chip->irq_mask = advk_pcie_irq_mask;
@@ -781,11 +782,13 @@ static int advk_pcie_init_irq_domain(str
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


