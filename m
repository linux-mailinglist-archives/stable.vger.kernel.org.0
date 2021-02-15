Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966F731BD3A
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhBOPmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:42:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhBOPiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C60A664EF1;
        Mon, 15 Feb 2021 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403268;
        bh=bZA6qMxGaBqMadWmdQSrmd9KSoH9VnCZsx1IowzvLZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0gMubGA9fM09y54Rr9AE2B7v3wcPCyUr5nG3SgI2mHOjAsF93TVxcv4a5mmejffQ
         3kq9Cd2eMFZM+Vk9t8WAtJsyJjWaWHbUoVHTYL11GMzxH7UbX9sc370qDgWOB5MiKX
         zZexcx8QmWFGnYVuVPZ2Jf+BaKuPkLfPr96OIXmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>,
        John Sperbeck <jsperbeck@google.com>
Subject: [PATCH 5.10 092/104] net: gro: do not keep too many GRO packets in napi->rx_list
Date:   Mon, 15 Feb 2021 16:27:45 +0100
Message-Id: <20210215152722.427768568@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 8dc1c444df193701910f5e80b5d4caaf705a8fb0 upstream.

Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
listified RX cooperation") had the unfortunate effect of adding
latencies in common workloads.

Before the patch, GRO packets were immediately passed to
upper stacks.

After the patch, we can accumulate quite a lot of GRO
packets (depdending on NAPI budget).

My fix is counting in napi->rx_count number of segments
instead of number of logical packets.

Fixes: c80794323e82 ("net: Fix packet reordering caused by GRO and listified RX cooperation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Bisected-by: John Sperbeck <jsperbeck@google.com>
Tested-by: Jian Yang <jianyang@google.com>
Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Link: https://lore.kernel.org/r/20210204213146.4192368-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5723,10 +5723,11 @@ static void gro_normal_list(struct napi_
 /* Queue one GRO_NORMAL SKB up for list processing. If batch size exceeded,
  * pass the whole batch up to the stack.
  */
-static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
+static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb, int segs)
 {
 	list_add_tail(&skb->list, &napi->rx_list);
-	if (++napi->rx_count >= gro_normal_batch)
+	napi->rx_count += segs;
+	if (napi->rx_count >= gro_normal_batch)
 		gro_normal_list(napi);
 }
 
@@ -5765,7 +5766,7 @@ static int napi_gro_complete(struct napi
 	}
 
 out:
-	gro_normal_one(napi, skb);
+	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
 	return NET_RX_SUCCESS;
 }
 
@@ -6055,7 +6056,7 @@ static gro_result_t napi_skb_finish(stru
 {
 	switch (ret) {
 	case GRO_NORMAL:
-		gro_normal_one(napi, skb);
+		gro_normal_one(napi, skb, 1);
 		break;
 
 	case GRO_DROP:
@@ -6143,7 +6144,7 @@ static gro_result_t napi_frags_finish(st
 		__skb_push(skb, ETH_HLEN);
 		skb->protocol = eth_type_trans(skb, skb->dev);
 		if (ret == GRO_NORMAL)
-			gro_normal_one(napi, skb);
+			gro_normal_one(napi, skb, 1);
 		break;
 
 	case GRO_DROP:


