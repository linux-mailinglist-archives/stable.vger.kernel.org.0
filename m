Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CE22F36C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfE3E3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:29:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729837AbfE3DOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D1A24569;
        Thu, 30 May 2019 03:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186061;
        bh=35T0qHW0GoLyTvKSX60pYUseUsylkpZKu7B/BgGYgcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhYJVZ5qNzDQJkrbJw2dFj6D/QHUf5x9Az41w4YCSvPPhDqnu5HmOZ9x6wdWmgyIy
         AGWIeDh8R5s92OptFgLlUyNmEDX7nvhdtKRtbIlvg0y//IG2TDQVqYi2IOQDsQR1P5
         TfMc8ob0HVWcf0jXfmtl/12KjD3O/+OGCCXmJ5pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 169/346] phy: mapphone-mdm6600: add gpiolib dependency
Date:   Wed, 29 May 2019 20:04:02 -0700
Message-Id: <20190530030549.721391884@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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



