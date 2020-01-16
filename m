Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709F713E792
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404026AbgAPR0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404020AbgAPR0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3E9246C8;
        Thu, 16 Jan 2020 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195603;
        bh=b5bbwaFLgQvjArAtfG/H2/8OOvBX8ntW6iaFKtCKbvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6vwuRJTTc0FcAuJ8twtbrO1E6x3m40Pxl/ZfBnxS/G3Y4egCnZ2QK5v9iV9GmV6h
         BwL1JIv+6fy9BwDGQtz7YD9eJ96kSj96aHsHzwdd/++d9u3b9wUIf9U0ldInVUOnGB
         AVTbB4urKFHHed0VGNbu+517gJgbdrTsLE1QS7KY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 178/371] usb: gadget: fsl: fix link error against usb-gadget module
Date:   Thu, 16 Jan 2020 12:20:50 -0500
Message-Id: <20200116172403.18149-121-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2100e3ca3676e894fa48b8f6f01d01733387fe81 ]

The dependency to ensure this driver links correctly fails since
it can not be a loadable module:

drivers/usb/phy/phy-fsl-usb.o: In function `fsl_otg_set_peripheral':
phy-fsl-usb.c:(.text+0x2224): undefined reference to `usb_gadget_vbus_disconnect'

Make the option 'tristate' so it can work correctly.

Fixes: 5a8d651a2bde ("usb: gadget: move gadget API functions to udc-core")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 85a92d0813dd..440238061edd 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -20,7 +20,7 @@ config AB8500_USB
 	  in host mode, low speed.
 
 config FSL_USB2_OTG
-	bool "Freescale USB OTG Transceiver Driver"
+	tristate "Freescale USB OTG Transceiver Driver"
 	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM=y && PM
 	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
-- 
2.20.1

