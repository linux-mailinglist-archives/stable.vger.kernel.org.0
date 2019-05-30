Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C1F2F5D8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfE3DLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbfE3DK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33DF6244C4;
        Thu, 30 May 2019 03:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185857;
        bh=CFHpKQ5oae7IeuktP+0eXItHEKAAiouHz0Wj9+kpRHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLPfDHOs/fvGKzYT4aJmppWl/MG4PJmymS6PZZdhQ5vjBwodZ8bOrXd7tvOSr4C+F
         u1r6jWErLpmGSJak2/ngvmXgwj1lVeANPWn2wzuGxjUAnCqb7U50k7Ui1IOyHR8mgd
         ZV6wtmbuUeZw4lttiiXkAHLGpncowOdj+6NlXXOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 185/405] phy: ti: usb2: fix OMAP_CONTROL_PHY dependency
Date:   Wed, 29 May 2019 20:03:03 -0700
Message-Id: <20190530030550.416501119@linuxfoundation.org>
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

[ Upstream commit d41ce98a122c13ea77938af04ef06fb12ae0c69e ]

With randconfig build testing on arm64, we can run into a configuration
that has CONFIG_OMAP_CONTROL_PHY=m and CONFIG_OMAP_USB2=y, which in turn
causes a link failure:

drivers/phy/ti/phy-omap-usb2.o: In function `omap_usb_phy_power':
phy-omap-usb2.c:(.text+0x17c): undefined reference to `omap_control_phy_power'

I could not come up with a good way to correctly describe the relation
of the two symbols, but if we just select CONFIG_OMAP_CONTROL_PHY
during compile testing, we can no longer run into the broken configuration.

Fixes: 6777cee3a872 ("phy: ti: usb2: Add support for AM654 USB2 PHY")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/ti/Kconfig b/drivers/phy/ti/Kconfig
index 103efc456a12e..022ac16f626cf 100644
--- a/drivers/phy/ti/Kconfig
+++ b/drivers/phy/ti/Kconfig
@@ -37,7 +37,7 @@ config OMAP_USB2
 	depends on USB_SUPPORT
 	select GENERIC_PHY
 	select USB_PHY
-	select OMAP_CONTROL_PHY if ARCH_OMAP2PLUS
+	select OMAP_CONTROL_PHY if ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  Enable this to support the transceiver that is part of SOC. This
 	  driver takes care of all the PHY functionality apart from comparator.
-- 
2.20.1



