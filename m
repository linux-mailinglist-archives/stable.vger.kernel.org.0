Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0AB79412
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfG2T1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729931AbfG2T1n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:27:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21060217D6;
        Mon, 29 Jul 2019 19:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428462;
        bh=laPnALORfMGbBZMMiWHWqLqwpx6lpXO8LVbDReD48Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkrRqEzzjmfv03tRg6o6fDVDyXu7l36JprNXmbuB62E8sJesV1p14sOK5AyxcsYg6
         H20JIVUdORhVmjfHfuPT9zl1vBKqLsnFfG5p3ffFplm2/Dd2AJCy0fQMeB/GYbHJ3Y
         7taFuxtYN6UcGnC7tOBXGSkMdYP6dYDmC9tyTO6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/293] ixgbe: Check DDM existence in transceiver before access
Date:   Mon, 29 Jul 2019 21:19:35 +0200
Message-Id: <20190729190831.045366155@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index c3e7a8191128..f7e68083200c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -3237,7 +3237,8 @@ static int ixgbe_get_module_info(struct net_device *dev,
 		page_swap = true;
 	}
 
-	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap) {
+	if (sff8472_rev == IXGBE_SFF_SFF_8472_UNSUP || page_swap ||
+	    !(addr_mode & IXGBE_SFF_DDM_IMPLEMENTED)) {
 		/* We have a SFP, but it does not support SFF-8472 */
 		modinfo->type = ETH_MODULE_SFF_8079;
 		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
index b0cac961df3b..94df1d99be95 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h
@@ -70,6 +70,7 @@
 #define IXGBE_SFF_SOFT_RS_SELECT_10G		0x8
 #define IXGBE_SFF_SOFT_RS_SELECT_1G		0x0
 #define IXGBE_SFF_ADDRESSING_MODE		0x4
+#define IXGBE_SFF_DDM_IMPLEMENTED		0x40
 #define IXGBE_SFF_QSFP_DA_ACTIVE_CABLE		0x1
 #define IXGBE_SFF_QSFP_DA_PASSIVE_CABLE		0x8
 #define IXGBE_SFF_QSFP_CONNECTOR_NOT_SEPARABLE	0x23
-- 
2.20.1



