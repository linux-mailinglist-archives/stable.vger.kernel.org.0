Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2399A59389D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiHOTGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245199AbiHOTDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:03:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B124D83B;
        Mon, 15 Aug 2022 11:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5945FB81081;
        Mon, 15 Aug 2022 18:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF52C433D6;
        Mon, 15 Aug 2022 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588445;
        bh=aUBihyxrfQBqUNzsva5Gk6hgJt80ouxsOvTzdpdnTTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5V+hnc4C5YqxMtQ6IYALZfKp13QrVqPjB+J/ax80KdDNcZ3rTH/hqkKtTOw6XPIz
         m0iLE5ePSdFIQ/OdvntEEVJIDiZRdedHdRPacpMYGn0vp/qOaQNGEbLbOi6EAAoxDz
         uqVMRNi0MJviljmU4paeUXMNCeP3c4NFuozEhWpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 406/779] PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()
Date:   Mon, 15 Aug 2022 20:00:50 +0200
Message-Id: <20220815180354.641999133@linuxfoundation.org>
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
index 904976913081..98da2578e4db 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1951,6 +1951,7 @@ static int tegra_pcie_config_ep(struct tegra_pcie_dw *pcie,
 	if (ret) {
 		dev_err(dev, "Failed to initialize DWC Endpoint subsystem: %d\n",
 			ret);
+		pm_runtime_disable(dev);
 		return ret;
 	}
 
-- 
2.35.1



