Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF9595051
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiHPEkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiHPEjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:39:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A36CE309;
        Mon, 15 Aug 2022 13:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F57DB8119A;
        Mon, 15 Aug 2022 20:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19DDC433D6;
        Mon, 15 Aug 2022 20:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595470;
        bh=QlOz2Io+byC6AKMjBO+S+1VJ4N/d58bt7s1z5/Zdtc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmSTxMTsXTCLLRkHDaV1ZlFzxwWffaZJbpEM1Q/Vv1s82Zth1U5dRha4M3+RhBTTy
         kLLASou6rfd6zriRYfnR4xUwtbQ5P+tD3QEG1gRuk4IylO2V0W9k652ugT7wGe2H63
         FAzLL5t3HiszyXSPNQEJZnnj2QCxglHk8H4nBB5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0775/1157] PCI: dwc: Deallocate EPC memory on dw_pcie_ep_init() errors
Date:   Mon, 15 Aug 2022 20:02:11 +0200
Message-Id: <20220815180510.494422349@linuxfoundation.org>
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 8161e9626b50892eaedbd8070ecb1586ecedb109 ]

If dw_pcie_ep_init() fails to perform any action after the EPC memory is
initialized and the MSI memory region is allocated, the latter parts won't
be undone thus causing a memory leak.  Add a cleanup-on-error path to fix
these leaks.

[bhelgaas: commit log]
Fixes: 2fd0c9d966cc ("PCI: designware-ep: Pre-allocate memory for MSI in dw_pcie_ep_init")
Link: https://lore.kernel.org/r/20220624143428.8334-6-Sergey.Semin@baikalelectronics.ru
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c    | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 0eda8236c125..13c2e73f0eaf 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -780,8 +780,9 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
 	ep->msi_mem = pci_epc_mem_alloc_addr(epc, &ep->msi_mem_phys,
 					     epc->mem->window.page_size);
 	if (!ep->msi_mem) {
+		ret = -ENOMEM;
 		dev_err(dev, "Failed to reserve memory for MSI/MSI-X\n");
-		return -ENOMEM;
+		goto err_exit_epc_mem;
 	}
 
 	if (ep->ops->get_features) {
@@ -790,6 +791,19 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
 			return 0;
 	}
 
-	return dw_pcie_ep_init_complete(ep);
+	ret = dw_pcie_ep_init_complete(ep);
+	if (ret)
+		goto err_free_epc_mem;
+
+	return 0;
+
+err_free_epc_mem:
+	pci_epc_mem_free_addr(epc, ep->msi_mem_phys, ep->msi_mem,
+			      epc->mem->window.page_size);
+
+err_exit_epc_mem:
+	pci_epc_mem_exit(epc);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dw_pcie_ep_init);
-- 
2.35.1



