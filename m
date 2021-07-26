Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6633D6203
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhGZPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233815AbhGZPco (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3735F60C41;
        Mon, 26 Jul 2021 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315990;
        bh=/aK46BEswsVzmlL26U3BUGNtTe0tRTAP0o1AQVzklaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUMa8gUfEv6kVqz8shRJTE2taLAO8SpGEG1xSjLDolyLo5VBKxqKCAXrKzR174tsT
         UI/8Af3bS3dxgH4v34lDlspGaBuetjJ8tZeQkMoLosdUkxKtOe/iMQYllEysBOOkvV
         R1YK68+cSBhrf3OMJGacjyV6hIKfb9wk9n1kAE5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 110/223] net: hisilicon: rename CACHE_LINE_MASK to avoid redefinition
Date:   Mon, 26 Jul 2021 17:38:22 +0200
Message-Id: <20210726153849.874937312@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b16f3299ae1aa3c327e1fb742d0379ae4d6e86f2 ]

Building on ARCH=arc causes a "redefined" warning, so rename this
driver's CACHE_LINE_MASK to avoid the warning.

../drivers/net/ethernet/hisilicon/hip04_eth.c:134: warning: "CACHE_LINE_MASK" redefined
  134 | #define CACHE_LINE_MASK   0x3F
In file included from ../include/linux/cache.h:6,
                 from ../include/linux/printk.h:9,
                 from ../include/linux/kernel.h:19,
                 from ../include/linux/list.h:9,
                 from ../include/linux/module.h:12,
                 from ../drivers/net/ethernet/hisilicon/hip04_eth.c:7:
../arch/arc/include/asm/cache.h:17: note: this is the location of the previous definition
   17 | #define CACHE_LINE_MASK  (~(L1_CACHE_BYTES - 1))

Fixes: d413779cdd93 ("net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 12f6c2442a7a..e53512f6878a 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -131,7 +131,7 @@
 /* buf unit size is cache_line_size, which is 64, so the shift is 6 */
 #define PPE_BUF_SIZE_SHIFT		6
 #define PPE_TX_BUF_HOLD			BIT(31)
-#define CACHE_LINE_MASK			0x3F
+#define SOC_CACHE_LINE_MASK		0x3F
 #else
 #define PPE_CFG_QOS_VMID_GRP_SHIFT	8
 #define PPE_CFG_RX_CTRL_ALIGN_SHIFT	11
@@ -531,8 +531,8 @@ hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 #if defined(CONFIG_HI13X1_GMAC)
 	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV
 		| TX_RELEASE_TO_PPE | priv->port << TX_POOL_SHIFT);
-	desc->data_offset = (__force u32)cpu_to_be32(phys & CACHE_LINE_MASK);
-	desc->send_addr =  (__force u32)cpu_to_be32(phys & ~CACHE_LINE_MASK);
+	desc->data_offset = (__force u32)cpu_to_be32(phys & SOC_CACHE_LINE_MASK);
+	desc->send_addr =  (__force u32)cpu_to_be32(phys & ~SOC_CACHE_LINE_MASK);
 #else
 	desc->cfg = (__force u32)cpu_to_be32(TX_CLEAR_WB | TX_FINISH_CACHE_INV);
 	desc->send_addr = (__force u32)cpu_to_be32(phys);
-- 
2.30.2



