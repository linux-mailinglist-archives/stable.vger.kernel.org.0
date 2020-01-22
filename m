Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B38B14563F
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgAVNXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:23:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730009AbgAVNXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:23:51 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056F72467B;
        Wed, 22 Jan 2020 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699430;
        bh=htLogQ1exQb6Tbgh6oLLzXYdn/pzCzc2t9ke4pJ0jzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJ/KP5AYCVfPCTyHmznibJOcveCSzO2OXntBeQ3ihkGsgUZ13ORnpDPXPx01uBKgc
         BwJCVOr7ujdnW4ziZcQrHgaO+34/s2YgF1p3HVYQZ64vk+1Eg+SUZgxgqbmIPDB2cY
         x1CFhtDKJdjeCQ7XlGMw8SCoAQF0N41h5FF4hGSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 141/222] net: hns: fix soft lockup when there is not enough memory
Date:   Wed, 22 Jan 2020 10:28:47 +0100
Message-Id: <20200122092843.829070021@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 49edd6a2c456150870ddcef5b7ed11b21d849e13 ]

When there is not enough memory and napi_alloc_skb() return NULL,
the HNS driver will print error message, and than try again, if
the memory is not enough for a while, huge error message and the
retry operation will cause soft lockup.

When napi_alloc_skb() return NULL because of no memory, we can
get a warn_alloc() call trace, so this patch deletes the error
message. We already use polling mode to handle irq, but the
retry operation will render the polling weight inactive, this
patch just return budget when the rx is not completed to avoid
dead loop.

Fixes: 36eedfde1a36 ("net: hns: Optimize hns_nic_common_poll for better performance")
Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -565,7 +565,6 @@ static int hns_nic_poll_rx_skb(struct hn
 	skb = *out_skb = napi_alloc_skb(&ring_data->napi,
 					HNS_RX_HEAD_SIZE);
 	if (unlikely(!skb)) {
-		netdev_err(ndev, "alloc rx skb fail\n");
 		ring->stats.sw_err_cnt++;
 		return -ENOMEM;
 	}
@@ -1056,7 +1055,6 @@ static int hns_nic_common_poll(struct na
 		container_of(napi, struct hns_nic_ring_data, napi);
 	struct hnae_ring *ring = ring_data->ring;
 
-try_again:
 	clean_complete += ring_data->poll_one(
 				ring_data, budget - clean_complete,
 				ring_data->ex_process);
@@ -1066,7 +1064,7 @@ try_again:
 			napi_complete(napi);
 			ring->q->handle->dev->ops->toggle_ring_irq(ring, 0);
 		} else {
-			goto try_again;
+			return budget;
 		}
 	}
 


