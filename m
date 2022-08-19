Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A36599F4A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351983AbiHSQSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352307AbiHSQQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957B8EE6B7;
        Fri, 19 Aug 2022 08:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92416612DF;
        Fri, 19 Aug 2022 15:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88285C433C1;
        Fri, 19 Aug 2022 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924760;
        bh=eONovvnXJTkG7yY9lIPAgekg5IfXBFKBNBbY6mwdv6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Igw++CdLmyuYpst/RmMptmy1LifIv7zWXVZz1BqB9uexYQTHkEKhkxWK4k5unP7O+
         V6LJYCQm9mMCz15vdhxkyVilO7rWyiWzuWqADqxdOHDsxQJyJQpc4W0qzCYfqvu8z5
         JBn9xKOZYO4xuxzKH6YGawwNvclT2tKZIu1eSibs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/545] PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()
Date:   Fri, 19 Aug 2022 17:40:43 +0200
Message-Id: <20220819153841.557556633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit e8fbd344a5ea62663554b8546b6bf9f88b93785a ]

pm_runtime_enable() will increase power disable depth.  If
dw_pcie_ep_init() fails, we should use pm_runtime_disable() to balance it
with pm_runtime_enable().

Add missing pm_runtime_disable() for tegra_pcie_config_ep().

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Link: https://lore.kernel.org/r/20220602031910.55859-1-linmq006@gmail.com
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index a5b677ec0769..845f1e1de3ab 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1970,6 +1970,7 @@ static int tegra_pcie_config_ep(struct tegra_pcie_dw *pcie,
 	if (ret) {
 		dev_err(dev, "Failed to initialize DWC Endpoint subsystem: %d\n",
 			ret);
+		pm_runtime_disable(dev);
 		return ret;
 	}
 
-- 
2.35.1



