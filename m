Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E12A59404B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345773AbiHOV2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348224AbiHOV1E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:27:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAF9E97D0;
        Mon, 15 Aug 2022 12:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5E47BCE12C4;
        Mon, 15 Aug 2022 19:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F708C433D7;
        Mon, 15 Aug 2022 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591377;
        bh=Pb+Su699391mtr7066eQ49nAxJ3tqsKaKrMulCNhQ/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JELQf5TGpBbND2dUNmYbsDsJU+kmcWoMEF/yN5sWefxRCawBCBabnd4kNJysEbBB4
         axo+sxKhXPfpEqbZ3fzOm+p3G1rbTuubsR4AmszO9NpKjTviAqKVdSy2FpaX5vrw+L
         H91NxnpsVEjnaIqaKSTJWW+TRQJ50RYIxb756O7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0560/1095] PCI: microchip: Fix refcount leak in mc_pcie_init_irq_domains()
Date:   Mon, 15 Aug 2022 19:59:19 +0200
Message-Id: <20220815180452.738930098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 2c52a8cef726..932b1c182149 100644
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



