Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0B1594AAE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353181AbiHPAFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346731AbiHPAA0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA2396FDC;
        Mon, 15 Aug 2022 13:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCAED61007;
        Mon, 15 Aug 2022 20:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF441C433C1;
        Mon, 15 Aug 2022 20:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594900;
        bh=JAMfREOs/4J2zJNaA1OfXY1zsRJpJRl3sXHTYuiV81Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3uPvfiWHcUP7R08oxF0gEKKB9B4Cp7T3VURYqtYpVnLfmn2snygSZpOxBx83Bsqt
         AM7LN3vru3wnJggnP3otEI2VEZ/bTvjpusvCwSjf5zeVPmRhb164YVa93Xmhm6Q047
         p9DvAxnH2f8aXte91pZTDBWmr1W5Gfku81Vn1Ps8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0595/1157] PCI: tegra194: Fix PM error handling in tegra_pcie_config_ep()
Date:   Mon, 15 Aug 2022 19:59:11 +0200
Message-Id: <20220815180503.455600296@linuxfoundation.org>
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
index cc2678490162..d992371a36e6 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1949,6 +1949,7 @@ static int tegra_pcie_config_ep(struct tegra194_pcie *pcie,
 	if (ret) {
 		dev_err(dev, "Failed to initialize DWC Endpoint subsystem: %d\n",
 			ret);
+		pm_runtime_disable(dev);
 		return ret;
 	}
 
-- 
2.35.1



