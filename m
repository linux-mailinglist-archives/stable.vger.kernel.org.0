Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA1A13EFB3
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404313AbgAPR3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404306AbgAPR3O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D143724709;
        Thu, 16 Jan 2020 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195754;
        bh=JYnzlzmlOi8zxfkZ3gNkyag99DW/iJIorNEPxenw/wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GlNGfiN2Fn+WIZjKKCtnVQ0w/x390ABNcHHglx47Vmt4MIh75odRGCBBZWXABU3p0
         OUOl+XWzuUrK3BnQ/huHJYh66gLSLNlFJRAezDlSNz73r2EdN7xPLr6tMXdz9za6KT
         QMOeSXTRIXI+XNMxdoNrr1+WuInKqVAUu6x4Je4s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 285/371] bcma: fix incorrect update of BCMA_CORE_PCI_MDIO_DATA
Date:   Thu, 16 Jan 2020 12:22:37 -0500
Message-Id: <20200116172403.18149-228-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 420c20be08a4597404d272ae9793b642401146eb ]

An earlier commit re-worked the setting of the bitmask and is now
assigning v with some bit flags rather than bitwise or-ing them
into v, consequently the earlier bit-settings of v are being lost.
Fix this by replacing an assignment with the bitwise or instead.

Addresses-Coverity: ("Unused value")
Fixes: 2be25cac8402 ("bcma: add constants for PCI and use them")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bcma/driver_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index f499a469e66d..12b2cc9a3fbe 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -78,7 +78,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u16 device, u8 address)
 		v |= (address << BCMA_CORE_PCI_MDIODATA_REGADDR_SHF_OLD);
 	}
 
-	v = BCMA_CORE_PCI_MDIODATA_START;
+	v |= BCMA_CORE_PCI_MDIODATA_START;
 	v |= BCMA_CORE_PCI_MDIODATA_READ;
 	v |= BCMA_CORE_PCI_MDIODATA_TA;
 
@@ -121,7 +121,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u16 device,
 		v |= (address << BCMA_CORE_PCI_MDIODATA_REGADDR_SHF_OLD);
 	}
 
-	v = BCMA_CORE_PCI_MDIODATA_START;
+	v |= BCMA_CORE_PCI_MDIODATA_START;
 	v |= BCMA_CORE_PCI_MDIODATA_WRITE;
 	v |= BCMA_CORE_PCI_MDIODATA_TA;
 	v |= data;
-- 
2.20.1

