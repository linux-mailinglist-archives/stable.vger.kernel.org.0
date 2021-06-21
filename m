Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057B23AEF90
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhFUQkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232099AbhFUQiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E1560698;
        Mon, 21 Jun 2021 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292976;
        bh=dB/Ejp+KEceRyiGU0o4t7O8oibqrIpwNwrngwRmZoZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1NSRIrnVh7FMLpUAfTTq56BwYtTWsAhqcQjxo7WppnvyRuZeNU0kRZU3QgufMZI6
         ET4aDg4KqNVtkrhEkeLlQx0ZnunBBkUqZ0xzb7XSuGEUOzhdrJZ//HIjEhv+OUBobX
         czLt2z0xsfWdNgjoKXfRO0WFHuTh88tjJybYjNyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 051/178] cxgb4: fix sleep in atomic when flashing PHY firmware
Date:   Mon, 21 Jun 2021 18:14:25 +0200
Message-Id: <20210621154924.111663250@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit f046bd0ae15d8a0bbe57d4647da182420f720c3d ]

Before writing new PHY firmware to on-chip memory, driver queries
firmware for current running PHY firmware version, which can result
in sleep waiting for reply. So, move spinlock closer to the actual
on-chip memory write operation, instead of taking it at the callers.

Fixes: 5fff701c838e ("cxgb4: always sync access when flashing PHY firmware")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c | 2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 2 --
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 61ea3ec5c3fc..bc2de01d0539 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -1337,9 +1337,7 @@ static int cxgb4_ethtool_flash_phy(struct net_device *netdev,
 		return ret;
 	}
 
-	spin_lock_bh(&adap->win0_lock);
 	ret = t4_load_phy_fw(adap, MEMWIN_NIC, NULL, data, size);
-	spin_unlock_bh(&adap->win0_lock);
 	if (ret)
 		dev_err(adap->pdev_dev, "Failed to load PHY FW\n");
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 1f601de02e70..762113a04dde 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -4424,10 +4424,8 @@ static int adap_init0_phy(struct adapter *adap)
 
 	/* Load PHY Firmware onto adapter.
 	 */
-	spin_lock_bh(&adap->win0_lock);
 	ret = t4_load_phy_fw(adap, MEMWIN_NIC, phy_info->phy_fw_version,
 			     (u8 *)phyf->data, phyf->size);
-	spin_unlock_bh(&adap->win0_lock);
 	if (ret < 0)
 		dev_err(adap->pdev_dev, "PHY Firmware transfer error %d\n",
 			-ret);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 029f0c83d785..601853bb34c9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3820,9 +3820,11 @@ int t4_load_phy_fw(struct adapter *adap, int win,
 	/* Copy the supplied PHY Firmware image to the adapter memory location
 	 * allocated by the adapter firmware.
 	 */
+	spin_lock_bh(&adap->win0_lock);
 	ret = t4_memory_rw(adap, win, mtype, maddr,
 			   phy_fw_size, (__be32 *)phy_fw_data,
 			   T4_MEMORY_WRITE);
+	spin_unlock_bh(&adap->win0_lock);
 	if (ret)
 		return ret;
 
-- 
2.30.2



