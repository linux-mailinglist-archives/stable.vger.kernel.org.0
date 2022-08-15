Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3441D594051
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbiHOV2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348439AbiHOV1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38709EA8AA;
        Mon, 15 Aug 2022 12:23:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0FC060FBE;
        Mon, 15 Aug 2022 19:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90B1C433C1;
        Mon, 15 Aug 2022 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591402;
        bh=UA4CGN5pQUGKiJSR+n6oMVNpzJodTwCIgeiovrvABLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InHLUGGuCBic7HKAYQkqdiaYcotMgw9+Be8unnPR5XWdq6pgpl6bmGLq6wAuYX7fx
         jPgTKQh2mjcs4jIB0Rfc05ijRM8ywC6+iLpsEqJtgQkKcBdF6eDsMd7WgB3fPvIiJY
         NA/yz+ynCRX8wGEnkQcNSQs23ZWvV2YJVtkP/CMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Jianjun Wang <jianjun.wang@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0567/1095] PCI: mediatek-gen3: Fix refcount leak in mtk_pcie_init_irq_domains()
Date:   Mon, 15 Aug 2022 19:59:26 +0200
Message-Id: <20220815180453.036262195@linuxfoundation.org>
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

[ Upstream commit bf038503d5fe90189743124233fe7aeb0984e961 ]

of_get_child_by_name() returns a node pointer with refcount incremented, so
we should use of_node_put() on it when we don't need it anymore.

Add missing of_node_put() to avoid refcount leak.

Fixes: 814cceebba9b ("PCI: mediatek-gen3: Add INTx support")
Link: https://lore.kernel.org/r/20220601041259.56185-1-linmq006@gmail.com
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Jianjun Wang <jianjun.wang@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 5d9fd36b02d1..a02c466a597c 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -600,7 +600,8 @@ static int mtk_pcie_init_irq_domains(struct mtk_gen3_pcie *pcie)
 						  &intx_domain_ops, pcie);
 	if (!pcie->intx_domain) {
 		dev_err(dev, "failed to create INTx IRQ domain\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_put_node;
 	}
 
 	/* Setup MSI */
@@ -623,13 +624,15 @@ static int mtk_pcie_init_irq_domains(struct mtk_gen3_pcie *pcie)
 		goto err_msi_domain;
 	}
 
+	of_node_put(intc_node);
 	return 0;
 
 err_msi_domain:
 	irq_domain_remove(pcie->msi_bottom_domain);
 err_msi_bottom_domain:
 	irq_domain_remove(pcie->intx_domain);
-
+out_put_node:
+	of_node_put(intc_node);
 	return ret;
 }
 
-- 
2.35.1



