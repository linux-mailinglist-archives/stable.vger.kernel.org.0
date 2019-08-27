Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A3E9E071
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbfH0IDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731242AbfH0IDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A24521881;
        Tue, 27 Aug 2019 08:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893027;
        bh=HB1+XBlrKA2fnQFn9Mr45kV8E9wDm780oDv+uQwd5z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjosO263LbQKbjpRPL84JAj5lJAyG7N1Jk1Ghn/vAnazs1Oxd8jsj582uy4psElpR
         xI454jx+JYZDV8xsh3iEOsSAhNQCvVFb5HZSeoWcSoKiGhGA49keZxMbs9BXobMTMm
         LDWcRXDIoHVJ7MpIc/Ru71xLByyhrG0nMnEk3gLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 094/162] net: hisilicon: fix hip04-xmit never return TX_BUSY
Date:   Tue, 27 Aug 2019 09:50:22 +0200
Message-Id: <20190827072741.470651593@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f2243b82785942be519016067ee6c55a063bbfe2 ]

TX_DESC_NUM is 256, in tx_count, the maximum value of
mod(TX_DESC_NUM - 1) is 254, the variable "count" in
the hip04_mac_start_xmit function is never equal to
(TX_DESC_NUM - 1), so hip04_mac_start_xmit never
return NETDEV_TX_BUSY.

tx_count is modified to mod(TX_DESC_NUM) so that
the maximum value of tx_count can reach
(TX_DESC_NUM - 1), then hip04_mac_start_xmit can reurn
NETDEV_TX_BUSY.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 5abe88dfe6abf..ee6da8d66cd31 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -181,7 +181,7 @@ struct hip04_priv {
 
 static inline unsigned int tx_count(unsigned int head, unsigned int tail)
 {
-	return (head - tail) % (TX_DESC_NUM - 1);
+	return (head - tail) % TX_DESC_NUM;
 }
 
 static void hip04_config_port(struct net_device *ndev, u32 speed, u32 duplex)
-- 
2.20.1



