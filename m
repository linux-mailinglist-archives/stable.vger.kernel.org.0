Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8035A48AC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiH2LOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiH2LNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FF56A487;
        Mon, 29 Aug 2022 04:09:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31326B80F9A;
        Mon, 29 Aug 2022 11:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B79CC433D6;
        Mon, 29 Aug 2022 11:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771296;
        bh=AhGtrVBP7bDxvnER6WTSl2DiSMmDV+/B2DOAWezXJQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tytShonrGEv/w78+lLrtgpxvF/GM7Gb2kZdzAGe3U1F1P0uL6eLUoQ+7J1nI5Ycdw
         4caGbvws91EyD8Jh0OzdKBhSbyhmEDm9VGMfMYnmw2Nr2P7wk13YkhGJl3ofTQ6w35
         /WEjp6wDJkNHdO1BCJeJZLvj0SB6s5CoNf5u/rB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/86] net: Fix data-races around netdev_max_backlog.
Date:   Mon, 29 Aug 2022 12:59:14 +0200
Message-Id: <20220829105758.493453346@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5dcd08cd19912892586c6082d56718333e2d19db ]

While reading netdev_max_backlog, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

While at it, we remove the unnecessary spaces in the doc.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/sysctl/net.rst | 2 +-
 net/core/dev.c                           | 4 ++--
 net/core/gro_cells.c                     | 2 +-
 net/xfrm/espintcp.c                      | 2 +-
 net/xfrm/xfrm_input.c                    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f2ab8a5b6a4b8..7f553859dba82 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -271,7 +271,7 @@ poll cycle or the number of packets processed reaches netdev_budget.
 netdev_max_backlog
 ------------------
 
-Maximum number  of  packets,  queued  on  the  INPUT  side, when the interface
+Maximum number of packets, queued on the INPUT side, when the interface
 receives packets faster than kernel can process them.
 
 netdev_rss_key
diff --git a/net/core/dev.c b/net/core/dev.c
index 701a1afc91ff1..215c43aecc67e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4516,7 +4516,7 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 	struct softnet_data *sd;
 	unsigned int old_flow, new_flow;
 
-	if (qlen < (netdev_max_backlog >> 1))
+	if (qlen < (READ_ONCE(netdev_max_backlog) >> 1))
 		return false;
 
 	sd = this_cpu_ptr(&softnet_data);
@@ -4564,7 +4564,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	if (!netif_running(skb->dev))
 		goto drop;
 	qlen = skb_queue_len(&sd->input_pkt_queue);
-	if (qlen <= netdev_max_backlog && !skb_flow_limit(skb, qlen)) {
+	if (qlen <= READ_ONCE(netdev_max_backlog) && !skb_flow_limit(skb, qlen)) {
 		if (qlen) {
 enqueue:
 			__skb_queue_tail(&sd->input_pkt_queue, skb);
diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 6eb2e5ec2c506..2f66f3f295630 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -26,7 +26,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
 
 	cell = this_cpu_ptr(gcells->cells);
 
-	if (skb_queue_len(&cell->napi_skbs) > netdev_max_backlog) {
+	if (skb_queue_len(&cell->napi_skbs) > READ_ONCE(netdev_max_backlog)) {
 drop:
 		atomic_long_inc(&dev->rx_dropped);
 		kfree_skb(skb);
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 1f08ebf7d80c5..24ca49ecebea3 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -170,7 +170,7 @@ int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
-	if (skb_queue_len(&ctx->out_queue) >= netdev_max_backlog)
+	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog))
 		return -ENOBUFS;
 
 	__skb_queue_tail(&ctx->out_queue, skb);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 61e6220ddd5ae..77e82033ad700 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -782,7 +782,7 @@ int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
 
 	trans = this_cpu_ptr(&xfrm_trans_tasklet);
 
-	if (skb_queue_len(&trans->queue) >= netdev_max_backlog)
+	if (skb_queue_len(&trans->queue) >= READ_ONCE(netdev_max_backlog))
 		return -ENOBUFS;
 
 	BUILD_BUG_ON(sizeof(struct xfrm_trans_cb) > sizeof(skb->cb));
-- 
2.35.1



