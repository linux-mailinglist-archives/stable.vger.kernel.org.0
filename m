Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5743027C818
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgI2L6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730661AbgI2Lls (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1118E206DB;
        Tue, 29 Sep 2020 11:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379707;
        bh=Kn9WjV9upfVvnTTOxznfqCRK8sRSDxv/X8OhWVQV4G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loOmlsoSw1SgXNJZy+gaeetx8GSWZFsgRE9dJr/3knBTDAT+22uOk70hXBTq5PN9u
         ggC9jiTbwFCaevoJSWq1gl9c37PqAeic3x90Y03+rOn9gtZ5DGJ0KF2fKIVVxwNlcZ
         +OReSVdzuBg7mSfRAZ79OfRHdOr8uvAn4FdSRDpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/388] phy: samsung: s5pv210-usb2: Add delay after reset
Date:   Tue, 29 Sep 2020 12:59:44 +0200
Message-Id: <20200929110022.722350239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit 05942b8c36c7eb5d3fc5e375d4b0d0c49562e85d ]

The USB phy takes some time to reset, so make sure we give it to it. The
delay length was taken from the 4x12 phy driver.

This manifested in issues with the DWC2 driver since commit fe369e1826b3
("usb: dwc2: Make dwc2_readl/writel functions endianness-agnostic.")
where the endianness check would read the DWC ID as 0 due to the phy still
resetting, resulting in the wrong endian mode being chosen.

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/BN6PR04MB06605D52502816E500683553A3D10@BN6PR04MB0660.namprd04.prod.outlook.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/samsung/phy-s5pv210-usb2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/phy/samsung/phy-s5pv210-usb2.c b/drivers/phy/samsung/phy-s5pv210-usb2.c
index 56a5083fe6f94..32be62e498047 100644
--- a/drivers/phy/samsung/phy-s5pv210-usb2.c
+++ b/drivers/phy/samsung/phy-s5pv210-usb2.c
@@ -139,6 +139,10 @@ static void s5pv210_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
 		udelay(10);
 		rst &= ~rstbits;
 		writel(rst, drv->reg_phy + S5PV210_UPHYRST);
+		/* The following delay is necessary for the reset sequence to be
+		 * completed
+		 */
+		udelay(80);
 	} else {
 		pwr = readl(drv->reg_phy + S5PV210_UPHYPWR);
 		pwr |= phypwr;
-- 
2.25.1



