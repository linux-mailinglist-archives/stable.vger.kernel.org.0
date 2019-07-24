Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E92A73D02
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391808AbfGXTzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391809AbfGXTxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:53:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 689A1205C9;
        Wed, 24 Jul 2019 19:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998001;
        bh=oVO4OIooG09V32BefcY6Qz8jrnLQLyos9B1fipRdE9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0L0JL93t/n6m4CzY6MaEebdPYu5zhJReIOalK3BjT3AG+ocw46ZZVvZgMderY+uqg
         7EZhxZctP0oK9GZXE10B7j+msYlReYJPuI+PLoi+t1UZYGUk5O8XHBtTmYeq4u0iZU
         DHV5Yws626Za3j3MJWLZEB1fmkAPxDza7Cn/vSFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 162/371] ixgbe: Check DDM existence in transceiver before access
Date:   Wed, 24 Jul 2019 21:18:34 +0200
Message-Id: <20190724191737.366675467@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 655c91414579d7bb115a4f7898ee726fc18e0984 ]

Some transceivers may comply with SFF-8472 but not implement the Digital
Diagnostic Monitoring (DDM) interface described in it. The existence of
such area is specified by bit 6 of byte 92, set to 1 if implemented.

Currently, due to not checking this bit ixgbe fails trying to read SFP
module's eeprom with the follow message:

ethtool -m enP51p1s0f0
Cannot get Module EEPROM data: Input/output error

Because it fails to read the additional 256 bytes in which it was assumed
to exist the DDM data.

This issue was noticed using a Mellanox Passive DAC PN 01FT738. The eeprom
data was confirmed by Mellanox as correct and present in other Passive
DACs in from other manufacturers.

Signed-off-by: "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index acba067cc15a..7c52ae8ac005 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3226,7 +3226,8 @@ static int ixgbe_get_module_info(struct net_device *dev,
 		page_swap = true;
 	}
 
-	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap) {
+	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap ||
+	    !(addr_mode & IXGBE_SFF_DDM_IMPLEMENTED)) {
 		/* We have a SFP, but it does not support SFF-8472 */
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
index 214b01085718..6544c4539c0d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
@@ -45,6 +45,7 @@
 #define IXGBE_SFF_SOFT_RS_SELECT_10G		0x8
 #define IXGBE_SFF_SOFT_RS_SELECT_1G		0x0
 #define IXGBE_SFF_ADDRESSING_MODE		0x4
+#define IXGBE_SFF_DDM_IMPLEMENTED		0x40
 #define IXGBE_SFF_QSFP_DA_ACTIVE_CABLE		0x1
 #define IXGBE_SFF_QSFP_DA_PASSIVE_CABLE		0x8
 #define IXGBE_SFF_QSFP_CONNECTOR_NOT_SEPARABLE	0x23
-- 
2.20.1



