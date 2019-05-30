Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0D72F5EA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfE3Ev2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbfE3DK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79DDD244E6;
        Thu, 30 May 2019 03:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185856;
        bh=35T0qHW0GoLyTvKSX60pYUseUsylkpZKu7B/BgGYgcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMi8XSE4CUf7Fi67W7x31oZQ44LNXTljzqyetqYtIHq19mWXSB57jiK3czPBGafMJ
         w4y38fFnVuTT17epiJQMO7Z31kS34wdAphnPvyNW86NnlSK3M/Biwed+pHq0Zl6Yd4
         /oRvSeR3ysmTVg4j4uugXcWvVEbVKwOHDM0j3yPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 184/405] phy: mapphone-mdm6600: add gpiolib dependency
Date:   Wed, 29 May 2019 20:03:02 -0700
Message-Id: <20190530030550.371521302@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 208d3423ee463ab257908456f6bbca4024ab63f7 ]

gcc points out that when CONFIG_GPIOLIB is disabled,
gpiod_get_array_value_cansleep() returns 0 but fails to set its output:

drivers/phy/motorola/phy-mapphone-mdm6600.c: In function 'phy_mdm6600_status':
drivers/phy/motorola/phy-mapphone-mdm6600.c:220:24: error: 'values[0]' is used uninitialized in this function [-Werror=uninitialized]

This could be fixed more generally in gpiolib by returning a failure
code, but for this specific case, the easier workaround is to add a
gpiolib dependency.

Fixes: 5d1ebbda0318 ("phy: mapphone-mdm6600: Add USB PHY driver for MDM6600 on Droid 4")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/motorola/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/motorola/Kconfig b/drivers/phy/motorola/Kconfig
index 82651524ffb9c..718f8729701df 100644
--- a/drivers/phy/motorola/Kconfig
+++ b/drivers/phy/motorola/Kconfig
@@ -13,7 +13,7 @@ config PHY_CPCAP_USB
 
 config PHY_MAPPHONE_MDM6600
 	tristate "Motorola Mapphone MDM6600 modem USB PHY driver"
-	depends on OF && USB_SUPPORT
+	depends on OF && USB_SUPPORT && GPIOLIB
 	select GENERIC_PHY
 	help
 	  Enable this for MDM6600 USB modem to work on Motorola phones
-- 
2.20.1



