Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E6943FAF
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfFMP7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731485AbfFMItq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:49:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4E43206BA;
        Thu, 13 Jun 2019 08:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415786;
        bh=QXO6KMAi//p5OKgiiB8eqhvn4lP9izoheJSoNKegOUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yH35c+8oPZBKgDpjwAxpCj7zKjxT2i98CFeTDUPGXWaKCfJktRjK5SdUnvfog0mvJ
         2pvupFZiF5N0UbExLaUAvhngiZ1JuzaQhG2eKTj9DeFb0k7nXLlo9RN27bp/01dHme
         od2GVhU8r1EPZTk5aZMbOWjH2Gx7hmR1coNani3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 097/155] PCI: keystone: Invoke phy_reset() API before enabling PHY
Date:   Thu, 13 Jun 2019 10:33:29 +0200
Message-Id: <20190613075658.492671914@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b22af42b3e57c3a49a4c4a54c7d8a1363af75e90 ]

SERDES connected to the PCIe controller in AM654 requires
power on reset enable (POR_EN) to be set in the SERDES. The
SERDES driver sets POR_EN in the reset ops and it has to be
invoked before init or enable ops. In order for SERDES driver
to set POR_EN, invoke the phy_reset() API in pci-keystone driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 14f2b0b4ed5e..94bd31b255a4 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -873,6 +873,10 @@ static int ks_pcie_enable_phy(struct keystone_pcie *ks_pcie)
 	int num_lanes = ks_pcie->num_lanes;
 
 	for (i = 0; i < num_lanes; i++) {
+		ret = phy_reset(ks_pcie->phy[i]);
+		if (ret < 0)
+			goto err_phy;
+
 		ret = phy_init(ks_pcie->phy[i]);
 		if (ret < 0)
 			goto err_phy;
-- 
2.20.1



