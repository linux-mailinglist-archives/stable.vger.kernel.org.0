Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEC44077A8
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbhIKNTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236452AbhIKNQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:16:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFD3C61269;
        Sat, 11 Sep 2021 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366011;
        bh=2hwgE9jqFCih2UhY0ejZASKjRP5jzaN5qlDFLtjeRss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GI7hi+QGV3eIkoPJRjmLRKL3YAcKv1Fr2mIw9e2OiEI73Odbumm0ncH1TcvxsQeXR
         jghf7grpdAYch7byV6AA9vRq/V7dF0YCq1kMbeSBJ49xgzRfy7f9S0QXFnChkiqeGa
         0BOmriEwwDecS4J4+l8rv1fOjOK3+5ccHQcYnESG67OdE8hplDhXMx7IDp0yA79mfi
         xgNDk+paf+cbBsIpICyJaE8whhlfhSXVQuOdd9PAGX2uPH0MHs4NTYBG0pA7k0ZnHq
         Q6c4Vsqg7vKIgOiNnF+Fkd0gVkjpTLp+MmBK44TwTbX3MrJlmFlalXLBeHha5ALla2
         es4QkOpLFydwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 14/25] PCI: j721e: Add PCIe support for AM64
Date:   Sat, 11 Sep 2021 09:13:01 -0400
Message-Id: <20210911131312.285225-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit c8a375a8e15ac31293d7fda08008d6da8f5df3db ]

AM64 has the same PCIe IP as in J7200 with certain erratas not
applicable (quirk_detect_quiet_flag). Add support for "ti,am64-pcie-host"
compatible and "ti,am64-pcie-ep" compatible that is specific to AM64.

Link: https://lore.kernel.org/r/20210811123336.31357-5-kishon@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 2f5a49c77074..8a6d68e13f30 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -298,6 +298,17 @@ static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.quirk_detect_quiet_flag = true,
 };
 
+static const struct j721e_pcie_data am64_pcie_rc_data = {
+	.mode = PCI_MODE_RC,
+	.linkdown_irq_regfield = J7200_LINK_DOWN,
+	.byte_access_allowed = true,
+};
+
+static const struct j721e_pcie_data am64_pcie_ep_data = {
+	.mode = PCI_MODE_EP,
+	.linkdown_irq_regfield = J7200_LINK_DOWN,
+};
+
 static const struct of_device_id of_j721e_pcie_match[] = {
 	{
 		.compatible = "ti,j721e-pcie-host",
@@ -315,6 +326,14 @@ static const struct of_device_id of_j721e_pcie_match[] = {
 		.compatible = "ti,j7200-pcie-ep",
 		.data = &j7200_pcie_ep_data,
 	},
+	{
+		.compatible = "ti,am64-pcie-host",
+		.data = &am64_pcie_rc_data,
+	},
+	{
+		.compatible = "ti,am64-pcie-ep",
+		.data = &am64_pcie_ep_data,
+	},
 	{},
 };
 
-- 
2.30.2

