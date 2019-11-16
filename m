Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E775FF3B7
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbfKPQ1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbfKPPlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:39 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BEC207DD;
        Sat, 16 Nov 2019 15:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918898;
        bh=UO3XCC42t0obPxpUMFWs3bkB7qRjPJ5pyIs/hvKqYnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaUvNw3DnqYaGrVa1BUAq+bmllDgryEb8i3ElSHsFgXYS64R8ehJ9kVwLUdBljVmR
         htc0M8d65fIa3buSHa4T5IrJUiozRw5dANK6Wsfsya7QTVdfvVWLHQ6l2dtFMvHSHs
         i+aEO0wA+NnDkuDrJGITHGXikaIRzcG585me9k0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Honghui Zhang <honghui.zhang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 026/237] PCI: mediatek: Fix class type for MT7622 to PCI_CLASS_BRIDGE_PCI
Date:   Sat, 16 Nov 2019 10:37:41 -0500
Message-Id: <20191116154113.7417-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Honghui Zhang <honghui.zhang@mediatek.com>

[ Upstream commit a7f172ab6a8e755e60311f27512034b0441ef421 ]

commit 101c92dc80c8 ("PCI: mediatek: Set up vendor ID and class
type for MT7622") erroneously set the class type for MT7622 to
PCI_CLASS_BRIDGE_HOST.

The PCIe controller of MT7622 integrates a Root Port that has type 1
configuration space header and related bridge windows.

The HW default value of this bridge's class type is invalid.

Fix its class type and set it to PCI_CLASS_BRIDGE_PCI to
match the hardware implementation.

Fixes: 101c92dc80c8 ("PCI: mediatek: Set up vendor ID and class type for MT7622")
Signed-off-by: Honghui Zhang <honghui.zhang@mediatek.com>
[lorenzo.pieralisi@arm.com: reworked the commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index c5ff6ca65eab2..abedf8ec11bba 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -432,7 +432,7 @@ static int mtk_pcie_startup_port_v2(struct mtk_pcie_port *port)
 		val = PCI_VENDOR_ID_MEDIATEK;
 		writew(val, port->base + PCIE_CONF_VEND_ID);
 
-		val = PCI_CLASS_BRIDGE_HOST;
+		val = PCI_CLASS_BRIDGE_PCI;
 		writew(val, port->base + PCIE_CONF_CLASS_ID);
 	}
 
-- 
2.20.1

