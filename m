Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB54076C9
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbhIKNNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236107AbhIKNN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1551D61213;
        Sat, 11 Sep 2021 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365934;
        bh=KZx2coV5sDm2IWpgob1FGB4ClO7nRf9NDLHt8uR2oMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huMEOhFopZuVpVTQx3cAMmhsAqsbCHng7RL10MfHIpa23DQ4LMqTGEZFbCrVckZBc
         tQepvD4mN5/M1bzGlAwO1VG0aHQtB5WQv0j8ScaGm76l/RPRUDpie1iUHrks+IjUWp
         ciKkOIxOSxG0KmK7PjoPdZL27MYfjvC3UQ5oCS/avgYCFDYWJ4VjbBYl3wIJg3C4Pi
         ZV9ZVk6ERdAkktTILRJKqGQLBz7QRH4iIIyyynfKdAZrqHSCfMD+Ygi0SC4lLiEktt
         bM+Vf/8ewJQZtmWe4jfEMH0aS9IceBw1VOUOHH9A995iopY5tnJJbfUaRrfjm5FQmm
         b8GK/EP8gFJ3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 18/32] PCI: j721e: Add PCIe support for AM64
Date:   Sat, 11 Sep 2021 09:11:35 -0400
Message-Id: <20210911131149.284397-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
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
index 10b13b728284..ffb176d288cd 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -310,6 +310,17 @@ static const struct j721e_pcie_data j7200_pcie_ep_data = {
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
@@ -327,6 +338,14 @@ static const struct of_device_id of_j721e_pcie_match[] = {
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

