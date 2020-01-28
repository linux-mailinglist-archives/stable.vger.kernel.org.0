Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A3D14BA37
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgA1OTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbgA1OTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83F8024681;
        Tue, 28 Jan 2020 14:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221191;
        bh=Oib6y4GU4rzaCn9AhuQjfgeSuoiUMJQL0ZwShrBJF4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDYVAu07rPZ44RQXPCodmZ9Os8DAmtj7aVNDgXkPNYbjIj09EJwhafHxfP09sg7j+
         7cLIiRVM1XYVAoz1dHjG8KHqj9on1/Ap4m0IR8TvsLTv/PM19ih1nKRZ2RturKFY3n
         61Du96lnrIxGpjJCi5Nc3DubZbvA47WVlkmjId54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 126/271] usb: gadget: fsl: fix link error against usb-gadget module
Date:   Tue, 28 Jan 2020 15:04:35 +0100
Message-Id: <20200128135901.975479865@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 19ce615455c1b..de70e70d02bed 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -19,7 +19,7 @@ config AB8500_USB
 	  in host mode, low speed.
 
 config FSL_USB2_OTG
-	bool "Freescale USB OTG Transceiver Driver"
+	tristate "Freescale USB OTG Transceiver Driver"
 	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM=y && PM
 	depends on USB_GADGET || !USB_GADGET # if USB_GADGET=m, this can't be 'y'
 	select USB_PHY
-- 
2.20.1



