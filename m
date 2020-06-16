Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F61FB7CD
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732302AbgFPPtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732519AbgFPPtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:49:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94DFB21473;
        Tue, 16 Jun 2020 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322581;
        bh=7ZXZZYtKZQYMLuPRkXUNG8MFyrdcLd0tNJiKxGN9ECQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1DgsAYLbAvAbJ0VyKdArynCNUW4cjKEoYRCImo2TsNHtzyAB8TF0jl7+PxLMrYs9
         3oxh5urmXB0E27y1EWmtHpWFPPKgsjkdpZmZePAjse0JPnQOlw7HQCx2RILNRsriV3
         jSZymRaUxwR+QVGfavInkd5m5a8ZzOYYGOLrBAuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 023/161] staging: mt7621-pci: properly power off dual-ported pcie phy
Date:   Tue, 16 Jun 2020 17:33:33 +0200
Message-Id: <20200616153107.500127683@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 5fcded5e857cf66c9592e4be28c4dab4520c9177 ]

Pcie phy for pcie0 and pcie1 is shared using a dual ported
one. Current code was assuming that if nothing is connected
in pcie0 it won't be also nothing connected in pcie1. This
assumtion is wrong for some devices such us 'Mikrotik rbm33g'
and 'ZyXEL LTE3301-PLUS' where only connecting a card to the
second bus on the phy is possible. For such devices kernel
hangs in the same point because of the wrong poweroff of the
phy getting the following trace:

mt7621-pci-phy 1e149000.pcie-phy: PHY for 0xbe149000 (dual port = 1)
mt7621-pci-phy 1e14a000.pcie-phy: PHY for 0xbe14a000 (dual port = 0)
mt7621-pci-phy 1e149000.pcie-phy: Xtal is 40MHz
mt7621-pci-phy 1e14a000.pcie-phy: Xtal is 40MHz
mt7621-pci 1e140000.pcie: pcie0 no card, disable it (RST & CLK)
[hangs]

The wrong assumption is located in the 'mt7621_pcie_init_ports'
function where we are just making a power off of the phy for
slots 0 and 2 if nothing is connected in them. Hence, only
poweroff the phy if nothing is connected in both slot 0 and
slot 1 avoiding the kernel to hang.

Fixes: 5737cfe87a9c ("staging: mt7621-pci: avoid to poweroff the phy for slot one")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20200409111652.30964-1-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index a1dafec0890a..6eb7436af462 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -479,17 +479,25 @@ static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 
 	mt7621_perst_gpio_pcie_deassert(pcie);
 
+	tmp = NULL;
 	list_for_each_entry(port, &pcie->ports, list) {
 		u32 slot = port->slot;
 
 		if (!mt7621_pcie_port_is_linkup(port)) {
 			dev_err(dev, "pcie%d no card, disable it (RST & CLK)\n",
 				slot);
-			if (slot != 1)
-				phy_power_off(port->phy);
 			mt7621_control_assert(port);
 			mt7621_pcie_port_clk_disable(port);
 			port->enabled = false;
+
+			if (slot == 0) {
+				tmp = port;
+				continue;
+			}
+
+			if (slot == 1 && tmp && !tmp->enabled)
+				phy_power_off(tmp->phy);
+
 		}
 	}
 
-- 
2.25.1



