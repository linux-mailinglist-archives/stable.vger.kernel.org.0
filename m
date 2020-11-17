Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCCC2B65A0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbgKQNTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbgKQNTu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA6B24248;
        Tue, 17 Nov 2020 13:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619189;
        bh=9KR9emB6vwp1BsTaAAB3Ljt/BM+q5eDOtc6D+Gvnyh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBEkhufyunQyN2xAjRA9QdIgzIZYZdpMsNp6dIvTrZlHhzcXmQ6UPJvn2T7sU7C3c
         4PH24F8aWeiTxlSxvV7olK1BftYzE4tYAu6Tv/rPdIfEm72fhWz32nhgiroluGFEeZ
         xHFUldpF7D8/s3zBRkf7G8URL3Mnf4P9I+4ANGyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <thesven73@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/101] lan743x: fix "BUG: invalid wait context" when setting rx mode
Date:   Tue, 17 Nov 2020 14:05:25 +0100
Message-Id: <20201117122115.927004640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 2b52a4b65bc8f14520fe6e996ea7fb3f7e400761 ]

In the net core, the struct net_device_ops -> ndo_set_rx_mode()
callback is called with the dev->addr_list_lock spinlock held.

However, this driver's ndo_set_rx_mode callback eventually calls
lan743x_dp_write(), which acquires a mutex. Mutex acquisition
may sleep, and this is not allowed when holding a spinlock.

Fix by removing the dp_lock mutex entirely. Its purpose is to
prevent concurrent accesses to the data port. No concurrent
accesses are possible, because the dev->addr_list_lock
spinlock in the core only lets through one thread at a time.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
Link: https://lore.kernel.org/r/20201109203828.5115-1-TheSven73@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 12 +++---------
 drivers/net/ethernet/microchip/lan743x_main.h |  3 ---
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 208341541087e..085fdceb3821b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -672,14 +672,12 @@ clean_up:
 static int lan743x_dp_write(struct lan743x_adapter *adapter,
 			    u32 select, u32 addr, u32 length, u32 *buf)
 {
-	int ret = -EIO;
 	u32 dp_sel;
 	int i;
 
-	mutex_lock(&adapter->dp_lock);
 	if (lan743x_csr_wait_for_bit(adapter, DP_SEL, DP_SEL_DPRDY_,
 				     1, 40, 100, 100))
-		goto unlock;
+		return -EIO;
 	dp_sel = lan743x_csr_read(adapter, DP_SEL);
 	dp_sel &= ~DP_SEL_MASK_;
 	dp_sel |= select;
@@ -691,13 +689,10 @@ static int lan743x_dp_write(struct lan743x_adapter *adapter,
 		lan743x_csr_write(adapter, DP_CMD, DP_CMD_WRITE_);
 		if (lan743x_csr_wait_for_bit(adapter, DP_SEL, DP_SEL_DPRDY_,
 					     1, 40, 100, 100))
-			goto unlock;
+			return -EIO;
 	}
-	ret = 0;
 
-unlock:
-	mutex_unlock(&adapter->dp_lock);
-	return ret;
+	return 0;
 }
 
 static u32 lan743x_mac_mii_access(u16 id, u16 index, int read)
@@ -2679,7 +2674,6 @@ static int lan743x_hardware_init(struct lan743x_adapter *adapter,
 
 	adapter->intr.irq = adapter->pdev->irq;
 	lan743x_csr_write(adapter, INT_EN_CLR, 0xFFFFFFFF);
-	mutex_init(&adapter->dp_lock);
 
 	ret = lan743x_gpio_init(adapter);
 	if (ret)
diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 2d6eea18973e8..77273be2d1ee0 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -702,9 +702,6 @@ struct lan743x_adapter {
 	struct lan743x_csr      csr;
 	struct lan743x_intr     intr;
 
-	/* lock, used to prevent concurrent access to data port */
-	struct mutex		dp_lock;
-
 	struct lan743x_gpio	gpio;
 	struct lan743x_ptp	ptp;
 
-- 
2.27.0



