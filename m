Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F89594AD3
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356003AbiHPAGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351740AbiHPAAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F3233407;
        Mon, 15 Aug 2022 13:21:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C233F61058;
        Mon, 15 Aug 2022 20:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4DAC433C1;
        Mon, 15 Aug 2022 20:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594896;
        bh=dKGeSzlcGwjg9tzsVcq5EvTIrGoJIeRYHb0rFcWwg9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxNeUjdZ6giBid6LvZfuIgT18m7zbFsz+pp0T2PWzVyOkIfpTpCVuN4TZYl2EnmH1
         juDXO3hSJpHM48qFmjNzLEIQwpZJFzZ87jJWfy0gN2mDZb+EP4Orh3BQHhZrbgYy3+
         eJhhXpH17dUiGqMZDtUH/bBZrclv8YxvAyPE44B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0594/1157] PCI: microchip: Fix refcount leak in mc_pcie_init_irq_domains()
Date:   Mon, 15 Aug 2022 19:59:10 +0200
Message-Id: <20220815180503.417993662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit f030304fdeb87ec8f1b518c73703214aec6cc24a ]

of_get_next_child() returns a node pointer with refcount incremented, so we
should use of_node_put() on it when we don't need it anymore.

mc_pcie_init_irq_domains() only calls of_node_put() in the normal path,
missing it in some error paths.  Add missing of_node_put() to avoid
refcount leak.

Fixes: 6f15a9c9f941 ("PCI: microchip: Add Microchip PolarFire PCIe controller driver")
Link: https://lore.kernel.org/r/20220605055123.59127-1-linmq006@gmail.com
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-microchip-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-microchip-host.c b/drivers/pci/controller/pcie-microchip-host.c
index dd5dba419047..7263d175b5ad 100644
--- a/drivers/pci/controller/pcie-microchip-host.c
+++ b/drivers/pci/controller/pcie-microchip-host.c
@@ -904,6 +904,7 @@ static int mc_pcie_init_irq_domains(struct mc_pcie *port)
 						   &event_domain_ops, port);
 	if (!port->event_domain) {
 		dev_err(dev, "failed to get event domain\n");
+		of_node_put(pcie_intc_node);
 		return -ENOMEM;
 	}
 
@@ -913,6 +914,7 @@ static int mc_pcie_init_irq_domains(struct mc_pcie *port)
 						  &intx_domain_ops, port);
 	if (!port->intx_domain) {
 		dev_err(dev, "failed to get an INTx IRQ domain\n");
+		of_node_put(pcie_intc_node);
 		return -ENOMEM;
 	}
 
-- 
2.35.1



