Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5012F4125AA
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349529AbhITSqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383381AbhITSo2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 629B263355;
        Mon, 20 Sep 2021 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159163;
        bh=KZx2coV5sDm2IWpgob1FGB4ClO7nRf9NDLHt8uR2oMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUqhvJ6SNxfaN7u8FvRSGVGh9wysoT5wswQEwu+qrA0AAvCKcTrZw0CebvYfDWKqh
         M+7wwQtS5ziwOl3TpB6xbpYLkD3Zeg7eaL3LmbroERz/leqcG4cUfEv7DZG7ISuEtQ
         XPdb/FGzPMzcb9rLMOhQeQAnOIY0SKOqfiY6J9Yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 106/168] PCI: j721e: Add PCIe support for AM64
Date:   Mon, 20 Sep 2021 18:44:04 +0200
Message-Id: <20210920163925.121932739@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



