Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312963C5516
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348591AbhGLIJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352535AbhGLH71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EBDC611AF;
        Mon, 12 Jul 2021 07:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076403;
        bh=Z0m2Yw9jLVmJyXxPFqhdbgSTKj9AKhBF2Iw2GY95ewI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdANxSm/vtO3o9YFj5E7o1i8ND1D71heO2SzygH99gc8Ds3fuKUeosZRwNq2k5+U2
         aikHenC2D4M/uCz8xLuAAIuc5FKJQI8HpuYf+upVEqUPEVdRDglFvSKfE+R/qv8q/t
         h8XoTGz+uzA54OTIG6zBy2TD3PGZPxSt6Dth6SWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 611/800] phy: ralink: phy-mt7621-pci: properly print pointer address
Date:   Mon, 12 Jul 2021 08:10:34 +0200
Message-Id: <20210712061032.245489441@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 652a6a2e3824ce2ebf79a2d5326940d05c4db036 ]

The way of printing the pointer address for the 'port_base'
address got into compile warnings on some architectures
[-Wpointer-to-int-cast]. Instead of use '%08x' and cast
to an 'unsigned int' just make use of '%px' and avoid the
cast. To avoid not really needed driver verbosity on normal
behaviour change also from 'dev_info' to 'dev_dbg'.

Fixes: d87da32372a0 ("phy: ralink: Add PHY driver for MT7621 PCIe PHY")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20210508070930.5290-7-sergio.paracuellos@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ralink/phy-mt7621-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ralink/phy-mt7621-pci.c b/drivers/phy/ralink/phy-mt7621-pci.c
index 2a9465f4bb3a..3b1245fc5a02 100644
--- a/drivers/phy/ralink/phy-mt7621-pci.c
+++ b/drivers/phy/ralink/phy-mt7621-pci.c
@@ -272,8 +272,8 @@ static struct phy *mt7621_pcie_phy_of_xlate(struct device *dev,
 
 	mt7621_phy->has_dual_port = args->args[0];
 
-	dev_info(dev, "PHY for 0x%08x (dual port = %d)\n",
-		 (unsigned int)mt7621_phy->port_base, mt7621_phy->has_dual_port);
+	dev_dbg(dev, "PHY for 0x%px (dual port = %d)\n",
+		mt7621_phy->port_base, mt7621_phy->has_dual_port);
 
 	return mt7621_phy->phy;
 }
-- 
2.30.2



