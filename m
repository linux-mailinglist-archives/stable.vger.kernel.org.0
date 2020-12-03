Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D632CD6B7
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbgLCN3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgLCN3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:29:17 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH AUTOSEL 5.9 01/39] phy: usb: Fix incorrect clearing of tca_drv_sel bit in SETUP reg for 7211
Date:   Thu,  3 Dec 2020 08:27:55 -0500
Message-Id: <20201203132834.930999-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit 209c805835b29495cf66cc705b206da8f4a68e6e ]

The 7211a0 has a tca_drv_sel bit in the USB SETUP register that
should never be enabled. This feature is only used if there is a
USB Type-C PHY, and the 7211 does not have one. If the bit is
enabled, the VBUS signal will never be asserted. In the 7211a0,
the bit was incorrectly defaulted to on so the driver had to clear
the bit. In the 7211c0 the state was inverted so the driver should
no longer clear the bit. This hasn't been a problem because all
current 7211 boards don't use the VBUS signal, but there are some
future customer boards that may use it.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201002190115.48017-1-alcooperx@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
index 456dc4a100c20..e63457e145c71 100644
--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -270,11 +270,6 @@ static void usb_init_common_7211b0(struct brcm_usb_init_params *params)
 	reg |= params->mode << USB_PHY_UTMI_CTL_1_PHY_MODE_SHIFT;
 	brcm_usb_writel(reg, usb_phy + USB_PHY_UTMI_CTL_1);
 
-	/* Fix the incorrect default */
-	reg = brcm_usb_readl(ctrl + USB_CTRL_SETUP);
-	reg &= ~USB_CTRL_SETUP_tca_drv_sel_MASK;
-	brcm_usb_writel(reg, ctrl + USB_CTRL_SETUP);
-
 	usb_init_common(params);
 
 	/*
-- 
2.27.0

