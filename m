Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571A0594502
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245358AbiHOV5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350115AbiHOVzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:55:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0227C2A715;
        Mon, 15 Aug 2022 12:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C534610A5;
        Mon, 15 Aug 2022 19:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266B3C433C1;
        Mon, 15 Aug 2022 19:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592036;
        bh=0wrrhUS/yrhbpDRp/29eoecL0CIsdPgCiNB8JkyesjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8oVru1Q7pLhWWVpSXLODTOpYk7oWp8f+0ai7CrrE45N60z/GAYqPPCezMFBvRuee
         6EP0B8k7dKY7trV1piF/f9z0AgVSsjvwYLcpn01fn+fkVLNV5CHTCWAI3A54Vdyzww
         Y6CqpH1/SPLPwB9KkRnKe7U2whHV+ZQCYE7Sdky4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0721/1095] PCI: dwc: Stop link on host_init errors and de-initialization
Date:   Mon, 15 Aug 2022 20:02:00 +0200
Message-Id: <20220815180459.224705275@linuxfoundation.org>
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 113fa857b74c947137d845e7e635afcf6a59c43a ]

It's logically correct to undo everything that was done when an error is
discovered or in the corresponding cleanup counterpart. Otherwise the host
controller will be left in an undetermined state. Since the link is set up
in the host_init method, deactivate it there in the cleanup-on-error block
and stop the link in the antagonistic routine - dw_pcie_host_deinit(). Link
deactivation is platform-specific and should be implemented in
dw_pcie_ops.stop_link().

Fixes: 886a9c134755 ("PCI: dwc: Move link handling into common code")
Link: https://lore.kernel.org/r/20220624143428.8334-2-Sergey.Semin@baikalelectronics.ru
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-host.c    | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 9979302532b7..bc9a7df130ef 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -421,8 +421,14 @@ int dw_pcie_host_init(struct pcie_port *pp)
 	bridge->sysdata = pp;
 
 	ret = pci_host_probe(bridge);
-	if (!ret)
-		return 0;
+	if (ret)
+		goto err_stop_link;
+
+	return 0;
+
+err_stop_link:
+	if (pci->ops && pci->ops->stop_link)
+		pci->ops->stop_link(pci);
 
 err_free_msi:
 	if (pp->has_msi_ctrl)
@@ -433,8 +439,14 @@ EXPORT_SYMBOL_GPL(dw_pcie_host_init);
 
 void dw_pcie_host_deinit(struct pcie_port *pp)
 {
+	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
+
 	pci_stop_root_bus(pp->bridge->bus);
 	pci_remove_root_bus(pp->bridge->bus);
+
+	if (pci->ops && pci->ops->stop_link)
+		pci->ops->stop_link(pci);
+
 	if (pp->has_msi_ctrl)
 		dw_pcie_free_msi(pp);
 }
-- 
2.35.1



