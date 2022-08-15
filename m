Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AF4593801
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245612AbiHOTHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245530AbiHOTFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:05:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9666237197;
        Mon, 15 Aug 2022 11:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFA3B81081;
        Mon, 15 Aug 2022 18:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AA8C433D7;
        Mon, 15 Aug 2022 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588466;
        bh=nU4IgZFphg6AoJaV+SrFVf3iKL/JaX8zy6tYKTj6tXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYt+gip9PTveLGstnxXginz+3wLmAnKFEO6vH6uUMZBuaYqgE5Q8MRUqVc4Kd+WEl
         FOmsatQ4hmHIrYOJQqoa2Ge67hGSM8iGqoSCkuAMTRpTLXfFFDv/QJc/SBndMg3q3S
         QPOGkmrJBxMZQiyzeVJpgl/ipY3LYTfwWcET4G6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Jianjun Wang <jianjun.wang@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/779] PCI: mediatek-gen3: Fix refcount leak in mtk_pcie_init_irq_domains()
Date:   Mon, 15 Aug 2022 20:00:56 +0200
Message-Id: <20220815180354.881759498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
 drivers/pci/controller/pcie-mediatek-gen3.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 21207df680cc..36c8702439e9 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -600,7 +600,8 @@ static int mtk_pcie_init_irq_domains(struct mtk_pcie_port *port)
 						  &intx_domain_ops, port);
 	if (!port->intx_domain) {
 		dev_err(dev, "failed to create INTx IRQ domain\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_put_node;
 	}
 
 	/* Setup MSI */
@@ -623,6 +624,7 @@ static int mtk_pcie_init_irq_domains(struct mtk_pcie_port *port)
 		goto err_msi_domain;
 	}
 
+	of_node_put(intc_node);
 	return 0;
 
 err_msi_domain:
@@ -630,6 +632,8 @@ static int mtk_pcie_init_irq_domains(struct mtk_pcie_port *port)
 err_msi_bottom_domain:
 	irq_domain_remove(port->intx_domain);
 
+out_put_node:
+	of_node_put(intc_node);
 	return ret;
 }
 
-- 
2.35.1



