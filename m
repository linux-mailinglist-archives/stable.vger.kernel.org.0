Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B15C2D9FDF
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408812AbgLNTBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502219AbgLNRh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 038/105] phy: usb: Fix incorrect clearing of tca_drv_sel bit in SETUP reg for 7211
Date:   Mon, 14 Dec 2020 18:28:12 +0100
Message-Id: <20201214172557.114450633@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



