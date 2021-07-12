Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757CD3C53C2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348596AbhGLHzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350653AbhGLHvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE14261C24;
        Mon, 12 Jul 2021 07:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076011;
        bh=dg3B80dzVDBqk3b5MSTbXAt2f3LgBn5loF4Z/t+gt2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4Z/6c1u0J10ztWDNNlcTfJbBJT4rFrJuaycEQuoC2nMXVn7vXgJpR/gWiDU1u2HF
         y8in51W41zXdfVKDsYZYGRSEYM+AKF5Ygn9B9D8/niAiefNuFU68dYJ96+h0kQe9KM
         pB1FDkpKBMlp4p6CgJXnG7530n9nDS+QRu3v137w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 459/800] net: wwan: Fix WWAN config symbols
Date:   Mon, 12 Jul 2021 08:08:02 +0200
Message-Id: <20210712061015.993162635@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 89212e160b81e778f829b89743570665810e3b13 ]

There is not strong reason to have both WWAN and WWAN_CORE symbols,
Let's build the WWAN core framework when WWAN is selected, in the
same way as for other subsystems.

This fixes issue with mhi_net selecting WWAN_CORE without WWAN and
reported by kernel test robot:

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for WWAN_CORE
   Depends on NETDEVICES && WWAN
   Selected by
   - MHI_NET && NETDEVICES && NET_CORE && MHI_BUS

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/Kconfig       |  1 +
 drivers/net/wwan/Kconfig  | 15 ++++++---------
 drivers/net/wwan/Makefile |  2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 74dc8e249faa..9b12a8e110f4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -431,6 +431,7 @@ config VSOCKMON
 config MHI_NET
 	tristate "MHI network driver"
 	depends on MHI_BUS
+	select WWAN
 	help
 	  This is the network driver for MHI bus.  It can be used with
 	  QCOM based WWAN modems (like SDX55).  Say Y or M.
diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 7ad1920120bc..e9d8a1c25e43 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -3,15 +3,9 @@
 # Wireless WAN device configuration
 #
 
-menuconfig WWAN
-	bool "Wireless WAN"
-	help
-	  This section contains Wireless WAN configuration for WWAN framework
-	  and drivers.
-
-if WWAN
+menu "Wireless WAN"
 
-config WWAN_CORE
+config WWAN
 	tristate "WWAN Driver Core"
 	help
 	  Say Y here if you want to use the WWAN driver core. This driver
@@ -20,9 +14,10 @@ config WWAN_CORE
 	  To compile this driver as a module, choose M here: the module will be
 	  called wwan.
 
+if WWAN
+
 config MHI_WWAN_CTRL
 	tristate "MHI WWAN control driver for QCOM-based PCIe modems"
-	select WWAN_CORE
 	depends on MHI_BUS
 	help
 	  MHI WWAN CTRL allows QCOM-based PCIe modems to expose different modem
@@ -35,3 +30,5 @@ config MHI_WWAN_CTRL
 	  called mhi_wwan_ctrl.
 
 endif # WWAN
+
+endmenu
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index 556cd90958ca..289771a4f952 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the Linux WWAN device drivers.
 #
 
-obj-$(CONFIG_WWAN_CORE) += wwan.o
+obj-$(CONFIG_WWAN) += wwan.o
 wwan-objs += wwan_core.o
 
 obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
-- 
2.30.2



