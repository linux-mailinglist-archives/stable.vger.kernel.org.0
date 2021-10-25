Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C87443A32E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbhJYT4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237952AbhJYTxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04C73611AF;
        Mon, 25 Oct 2021 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191042;
        bh=G23Nqwrx7i6SnVXY5vCcbIdbDoKMBTZ/MVDmtylSRcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fuk7YbA3HFwOwehsYqRYtaNwMAlgCRTiU8P1Rw8wOtiWLFb5skUKja1NZUnTZNdm5
         b6CkiogYxgQt+TCsaqoVtrKaBq6GibI8pJ69sLwaIyJK/XbnLPhgHNn7cjFc28PsU1
         clnn8NlnAPNylV0UnXv0oxCvr0j6E1CuoSRhPK3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 123/169] net: hns3: fix the max tx size according to user manual
Date:   Mon, 25 Oct 2021 21:15:04 +0200
Message-Id: <20211025191033.413361268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

commit adfb7b4966c0c4c63a791f202b8b3837b07a9ece upstream.

Currently the max tx size supported by the hw is calculated by
using the max BD num supported by the hw. According to the hw
user manual, the max tx size is fixed value for both non-TSO and
TSO skb.

This patch updates the max tx size according to the manual.

Fixes: 8ae10cfb5089("net: hns3: support tx-scatter-gather-fraglist feature")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |    7 ++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |    6 ++----
 2 files changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1845,7 +1845,6 @@ void hns3_shinfo_pack(struct skb_shared_
 
 static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 			      struct sk_buff *skb,
-			      u8 max_non_tso_bd_num,
 			      unsigned int bd_num)
 {
 	/* 'bd_num == UINT_MAX' means the skb' fraglist has a
@@ -1862,8 +1861,7 @@ static int hns3_skb_linearize(struct hns
 	 * will not help.
 	 */
 	if (skb->len > HNS3_MAX_TSO_SIZE ||
-	    (!skb_is_gso(skb) && skb->len >
-	     HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num))) {
+	    (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)) {
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.hw_limitation++;
 		u64_stats_update_end(&ring->syncp);
@@ -1898,8 +1896,7 @@ static int hns3_nic_maybe_stop_tx(struct
 			goto out;
 		}
 
-		if (hns3_skb_linearize(ring, skb, max_non_tso_bd_num,
-				       bd_num))
+		if (hns3_skb_linearize(ring, skb, bd_num))
 			return -ENOMEM;
 
 		bd_num = hns3_tx_bd_count(skb->len);
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -185,11 +185,9 @@ enum hns3_nic_state {
 
 #define HNS3_MAX_BD_SIZE			65535
 #define HNS3_MAX_TSO_BD_NUM			63U
-#define HNS3_MAX_TSO_SIZE \
-	(HNS3_MAX_BD_SIZE * HNS3_MAX_TSO_BD_NUM)
+#define HNS3_MAX_TSO_SIZE			1048576U
+#define HNS3_MAX_NON_TSO_SIZE			9728U
 
-#define HNS3_MAX_NON_TSO_SIZE(max_non_tso_bd_num) \
-	(HNS3_MAX_BD_SIZE * (max_non_tso_bd_num))
 
 #define HNS3_VECTOR_GL0_OFFSET			0x100
 #define HNS3_VECTOR_GL1_OFFSET			0x200


