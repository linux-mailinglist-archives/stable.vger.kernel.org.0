Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F52F389
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfE3DNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbfE3DNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B284244EF;
        Thu, 30 May 2019 03:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186025;
        bh=3uMj+D0XcaHqhNjcBGc39/zrvuS/hjzi5oRXqURL7zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EriFqvLoXB+6SNrm971yHdYacy3ZpBxxW3V7HmwzUap/fTSxvYDwGSX72AUzOWtL5
         aCkLQDsXFP58HqdO1aIuk1eNDBIespuNjlcIbPTlUe7HpJ01tYuY3uERoKWjjYsi5n
         xJgvK4cIWSPMBuJ5nVS6sTp65jmg/UJJ0JDafUNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 099/346] net: hns3: fix for TX clean num when cleaning TX BD
Date:   Wed, 29 May 2019 20:02:52 -0700
Message-Id: <20190530030546.171533760@linuxfoundation.org>
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

[ Upstream commit 63380a1ae4ced8aef67659ff9547c69ef8b9613a ]

hns3_desc_unused() returns how many BD have been cleaned, but new
buffer has not been attached to them. The register of
HNS3_RING_RX_RING_FBDNUM_REG returns how many BD need allocating new
buffer to or need to cleaned. So the remaining BD need to be clean
is HNS3_RING_RX_RING_FBDNUM_REG - hns3_desc_unused().

Also, new buffer can not attach to the pending BD when the last BD is
not handled, because memcpy has not been done on the first pending BD.

This patch fixes by subtracting the pending BD num from unused_count
after 'HNS3_RING_RX_RING_FBDNUM_REG - unused_count' is used to calculate
the BD bum need to be clean.

Fixes: e55970950556 ("net: hns3: Add handling of GRO Pkts not fully RX'ed in NAPI poll")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 40b69eaf2cb3f..ecadd280ab28d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2708,7 +2708,7 @@ int hns3_clean_rx_ring(
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
 	int recv_pkts, recv_bds, clean_count, err;
-	int unused_count = hns3_desc_unused(ring) - ring->pending_buf;
+	int unused_count = hns3_desc_unused(ring);
 	struct sk_buff *skb = ring->skb;
 	int num;
 
@@ -2717,6 +2717,7 @@ int hns3_clean_rx_ring(
 
 	recv_pkts = 0, recv_bds = 0, clean_count = 0;
 	num -= unused_count;
+	unused_count -= ring->pending_buf;
 
 	while (recv_pkts < budget && recv_bds < num) {
 		/* Reuse or realloc buffers */
-- 
2.20.1



