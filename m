Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6439F10B7A1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfK0Uff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:35:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbfK0Ufd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED3E920866;
        Wed, 27 Nov 2019 20:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886931;
        bh=ljDiP3g5+8bZOV0s4yL1VTzoE8G8xdTw66PY3Ck1tB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjfv174KKgwbkZxWQuTG31URGAI7MfsRcOrFtl4fUD0u4JlJo9Dx4d6ASi9XWbgAH
         yYzPlh6cj0Ga2Ln3Vx1Vufvk0+gGwRqFpJVu/Y9YJ58EmruuN9gjb131S/iiEoJVaN
         ixxs4FkWrzizY2CVMWp4TKCMAx+BU9C4UtH0RO9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 048/132] atm: zatm: Fix empty body Clang warnings
Date:   Wed, 27 Nov 2019 21:30:39 +0100
Message-Id: <20191127202945.634528993@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 64b9d16e2d02ca6e5dc8fcd30cfd52b0ecaaa8f4 ]

Clang warns:

drivers/atm/zatm.c:513:7: error: while loop has empty body
[-Werror,-Wempty-body]
        zwait;
             ^
drivers/atm/zatm.c:513:7: note: put the semicolon on a separate line to
silence this warning

Get rid of this warning by using an empty do-while loop. While we're at
it, add parentheses to make it clear that this is a function-like macro.

Link: https://github.com/ClangBuiltLinux/linux/issues/42
Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/zatm.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 94712e1c5cf9a..bcdde3e360522 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -126,7 +126,7 @@ static unsigned long dummy[2] = {0,0};
 #define zin_n(r) inl(zatm_dev->base+r*4)
 #define zin(r) inl(zatm_dev->base+uPD98401_##r*4)
 #define zout(v,r) outl(v,zatm_dev->base+uPD98401_##r*4)
-#define zwait while (zin(CMR) & uPD98401_BUSY)
+#define zwait() do {} while (zin(CMR) & uPD98401_BUSY)
 
 /* RX0, RX1, TX0, TX1 */
 static const int mbx_entries[NR_MBX] = { 1024,1024,1024,1024 };
@@ -140,7 +140,7 @@ static const int mbx_esize[NR_MBX] = { 16,16,4,4 }; /* entry size in bytes */
 
 static void zpokel(struct zatm_dev *zatm_dev,u32 value,u32 addr)
 {
-	zwait;
+	zwait();
 	zout(value,CER);
 	zout(uPD98401_IND_ACC | uPD98401_IA_BALL |
 	    (uPD98401_IA_TGT_CM << uPD98401_IA_TGT_SHIFT) | addr,CMR);
@@ -149,10 +149,10 @@ static void zpokel(struct zatm_dev *zatm_dev,u32 value,u32 addr)
 
 static u32 zpeekl(struct zatm_dev *zatm_dev,u32 addr)
 {
-	zwait;
+	zwait();
 	zout(uPD98401_IND_ACC | uPD98401_IA_BALL | uPD98401_IA_RW |
 	  (uPD98401_IA_TGT_CM << uPD98401_IA_TGT_SHIFT) | addr,CMR);
-	zwait;
+	zwait();
 	return zin(CER);
 }
 
@@ -241,7 +241,7 @@ static void refill_pool(struct atm_dev *dev,int pool)
 	}
 	if (first) {
 		spin_lock_irqsave(&zatm_dev->lock, flags);
-		zwait;
+		zwait();
 		zout(virt_to_bus(first),CER);
 		zout(uPD98401_ADD_BAT | (pool << uPD98401_POOL_SHIFT) | count,
 		    CMR);
@@ -508,9 +508,9 @@ static int open_rx_first(struct atm_vcc *vcc)
 	}
 	if (zatm_vcc->pool < 0) return -EMSGSIZE;
 	spin_lock_irqsave(&zatm_dev->lock, flags);
-	zwait;
+	zwait();
 	zout(uPD98401_OPEN_CHAN,CMR);
-	zwait;
+	zwait();
 	DPRINTK("0x%x 0x%x\n",zin(CMR),zin(CER));
 	chan = (zin(CMR) & uPD98401_CHAN_ADDR) >> uPD98401_CHAN_ADDR_SHIFT;
 	spin_unlock_irqrestore(&zatm_dev->lock, flags);
@@ -571,21 +571,21 @@ static void close_rx(struct atm_vcc *vcc)
 		pos = vcc->vci >> 1;
 		shift = (1-(vcc->vci & 1)) << 4;
 		zpokel(zatm_dev,zpeekl(zatm_dev,pos) & ~(0xffff << shift),pos);
-		zwait;
+		zwait();
 		zout(uPD98401_NOP,CMR);
-		zwait;
+		zwait();
 		zout(uPD98401_NOP,CMR);
 		spin_unlock_irqrestore(&zatm_dev->lock, flags);
 	}
 	spin_lock_irqsave(&zatm_dev->lock, flags);
-	zwait;
+	zwait();
 	zout(uPD98401_DEACT_CHAN | uPD98401_CHAN_RT | (zatm_vcc->rx_chan <<
 	    uPD98401_CHAN_ADDR_SHIFT),CMR);
-	zwait;
+	zwait();
 	udelay(10); /* why oh why ... ? */
 	zout(uPD98401_CLOSE_CHAN | uPD98401_CHAN_RT | (zatm_vcc->rx_chan <<
 	    uPD98401_CHAN_ADDR_SHIFT),CMR);
-	zwait;
+	zwait();
 	if (!(zin(CMR) & uPD98401_CHAN_ADDR))
 		printk(KERN_CRIT DEV_LABEL "(itf %d): can't close RX channel "
 		    "%d\n",vcc->dev->number,zatm_vcc->rx_chan);
@@ -698,7 +698,7 @@ printk("NONONONOO!!!!\n");
 	skb_queue_tail(&zatm_vcc->tx_queue,skb);
 	DPRINTK("QRP=0x%08lx\n",zpeekl(zatm_dev,zatm_vcc->tx_chan*VC_SIZE/4+
 	  uPD98401_TXVC_QRP));
-	zwait;
+	zwait();
 	zout(uPD98401_TX_READY | (zatm_vcc->tx_chan <<
 	    uPD98401_CHAN_ADDR_SHIFT),CMR);
 	spin_unlock_irqrestore(&zatm_dev->lock, flags);
@@ -890,12 +890,12 @@ static void close_tx(struct atm_vcc *vcc)
 	}
 	spin_lock_irqsave(&zatm_dev->lock, flags);
 #if 0
-	zwait;
+	zwait();
 	zout(uPD98401_DEACT_CHAN | (chan << uPD98401_CHAN_ADDR_SHIFT),CMR);
 #endif
-	zwait;
+	zwait();
 	zout(uPD98401_CLOSE_CHAN | (chan << uPD98401_CHAN_ADDR_SHIFT),CMR);
-	zwait;
+	zwait();
 	if (!(zin(CMR) & uPD98401_CHAN_ADDR))
 		printk(KERN_CRIT DEV_LABEL "(itf %d): can't close TX channel "
 		    "%d\n",vcc->dev->number,chan);
@@ -925,9 +925,9 @@ static int open_tx_first(struct atm_vcc *vcc)
 	zatm_vcc->tx_chan = 0;
 	if (vcc->qos.txtp.traffic_class == ATM_NONE) return 0;
 	spin_lock_irqsave(&zatm_dev->lock, flags);
-	zwait;
+	zwait();
 	zout(uPD98401_OPEN_CHAN,CMR);
-	zwait;
+	zwait();
 	DPRINTK("0x%x 0x%x\n",zin(CMR),zin(CER));
 	chan = (zin(CMR) & uPD98401_CHAN_ADDR) >> uPD98401_CHAN_ADDR_SHIFT;
 	spin_unlock_irqrestore(&zatm_dev->lock, flags);
@@ -1557,7 +1557,7 @@ static void zatm_phy_put(struct atm_dev *dev,unsigned char value,
 	struct zatm_dev *zatm_dev;
 
 	zatm_dev = ZATM_DEV(dev);
-	zwait;
+	zwait();
 	zout(value,CER);
 	zout(uPD98401_IND_ACC | uPD98401_IA_B0 |
 	    (uPD98401_IA_TGT_PHY << uPD98401_IA_TGT_SHIFT) | addr,CMR);
@@ -1569,10 +1569,10 @@ static unsigned char zatm_phy_get(struct atm_dev *dev,unsigned long addr)
 	struct zatm_dev *zatm_dev;
 
 	zatm_dev = ZATM_DEV(dev);
-	zwait;
+	zwait();
 	zout(uPD98401_IND_ACC | uPD98401_IA_B0 | uPD98401_IA_RW |
 	  (uPD98401_IA_TGT_PHY << uPD98401_IA_TGT_SHIFT) | addr,CMR);
-	zwait;
+	zwait();
 	return zin(CER) & 0xff;
 }
 
-- 
2.20.1



