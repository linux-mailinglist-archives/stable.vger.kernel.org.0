Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C8F26F23F
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgIRC5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgIRCGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454AE239D3;
        Fri, 18 Sep 2020 02:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394789;
        bh=Kn9WjV9upfVvnTTOxznfqCRK8sRSDxv/X8OhWVQV4G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSiXV7qvwyLUtjSuCfDUbxuLft62CPQz5HysGdoQoJ+MpEVQZa27/s4w2qYWwYwra
         PU/kR5Aa52QtmZd4ClO9wuvqfmtzxCMdd5kRjWcGOIJUvlwxfeJjVuEI0NFiHibolA
         YY2cioTLUsnosG/sHFfE6YdTfywJ2fIUYdHJiMJ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Bakker <xc-racer2@live.ca>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 260/330] phy: samsung: s5pv210-usb2: Add delay after reset
Date:   Thu, 17 Sep 2020 22:00:00 -0400
Message-Id: <20200918020110.2063155-260-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

