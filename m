Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2AA210BD85
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfK0U46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729982AbfK0U45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7189B20862;
        Wed, 27 Nov 2019 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888216;
        bh=Al3MLSwLyZfkvCTgN5ublWP4WIeHsKA9ZsvFAGAi18w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7hcQr+1eqOOYiWZE6AYIjdx2JaxCbOFbdJrTQ8geVqffASH9JJMuHQ27v8ZAb+2K
         y+ang97hk4tLYbzaJt+tU+8ORUULmFVo4A0eLowi9+DPTKT+sBnqQAavvFp+DoRcq0
         2YU3iHShZN/Dl2lHwi0w9M52r3kDMLiKtM90vsog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Honghui Zhang <honghui.zhang@mediatek.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/306] PCI: mediatek: Fix class type for MT7622 to PCI_CLASS_BRIDGE_PCI
Date:   Wed, 27 Nov 2019 21:28:17 +0100
Message-Id: <20191127203118.246542347@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0d100f56cb884..8d1364c317747 100644
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



