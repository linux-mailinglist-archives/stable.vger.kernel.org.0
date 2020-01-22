Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8C7145086
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgAVJrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387770AbgAVJmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8704A24689;
        Wed, 22 Jan 2020 09:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686163;
        bh=vaofyrLwmOJJ91LZD0XAQw7z34u1sziwFQ2dIIgGd7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UetGTManXrFFxctSzCY6QYDOtZscZkioOCJEOhjvoX9i91FlWOp+BjN+POj+m/v7B
         /h7aVRSNhdelGX6/fHDacggZB97G25WSY6TL2oZOti1lmZ1zJoBKbwiC3BtvHZvmSL
         pxws3sknN8X4smNtuwS8oyFlUECmi96mkaxfDIPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 070/103] net: hns: fix soft lockup when there is not enough memory
Date:   Wed, 22 Jan 2020 10:29:26 +0100
Message-Id: <20200122092813.954240644@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
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
@@ -569,7 +569,6 @@ static int hns_nic_poll_rx_skb(struct hn
 	skb = *out_skb = napi_alloc_skb(&ring_data->napi,
 					HNS_RX_HEAD_SIZE);
 	if (unlikely(!skb)) {
-		netdev_err(ndev, "alloc rx skb fail\n");
 		ring->stats.sw_err_cnt++;
 		return -ENOMEM;
 	}
@@ -1060,7 +1059,6 @@ static int hns_nic_common_poll(struct na
 		container_of(napi, struct hns_nic_ring_data, napi);
 	struct hnae_ring *ring = ring_data->ring;
 
-try_again:
 	clean_complete += ring_data->poll_one(
 				ring_data, budget - clean_complete,
 				ring_data->ex_process);
@@ -1070,7 +1068,7 @@ try_again:
 			napi_complete(napi);
 			ring->q->handle->dev->ops->toggle_ring_irq(ring, 0);
 		} else {
-			goto try_again;
+			return budget;
 		}
 	}
 


