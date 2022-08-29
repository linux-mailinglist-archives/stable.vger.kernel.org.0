Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0C5A497C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbiH2LZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiH2LYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:24:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A44B75FFB;
        Mon, 29 Aug 2022 04:15:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B91F3B80F9E;
        Mon, 29 Aug 2022 11:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBD7C433C1;
        Mon, 29 Aug 2022 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771701;
        bh=zcFtYupD55r4uIEvmlK//9EZbe0vYseDVvN24OdsBI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ksvaejBhrbJ+fET4u7zqJFWJmf+0nOra+cHNBPVoH0qSwObXOGzW2CMf3DlrfZ+zx
         iKNv0a124h0US+78XtgRfSC0ioh5KhUFRB8NzJcW0Y06jEluegQ0nL02OqlW6y4rdV
         ntDz7ir8aeA+094xBMtPHLdH3cN7BV2K4RzzliM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 067/158] net: Fix data-races around netdev_max_backlog.
Date:   Mon, 29 Aug 2022 12:58:37 +0200
Message-Id: <20220829105811.800791161@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
index fcd650bdbc7e2..01d9858197832 100644
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
index 2a7d81cd9e2ea..e1496e626a532 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4623,7 +4623,7 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 	struct softnet_data *sd;
 	unsigned int old_flow, new_flow;
 
-	if (qlen < (netdev_max_backlog >> 1))
+	if (qlen < (READ_ONCE(netdev_max_backlog) >> 1))
 		return false;
 
 	sd = this_cpu_ptr(&softnet_data);
@@ -4671,7 +4671,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	if (!netif_running(skb->dev))
 		goto drop;
 	qlen = skb_queue_len(&sd->input_pkt_queue);
-	if (qlen <= netdev_max_backlog && !skb_flow_limit(skb, qlen)) {
+	if (qlen <= READ_ONCE(netdev_max_backlog) && !skb_flow_limit(skb, qlen)) {
 		if (qlen) {
 enqueue:
 			__skb_queue_tail(&sd->input_pkt_queue, skb);
diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 541c7a72a28a4..21619c70a82b7 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -26,7 +26,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
 
 	cell = this_cpu_ptr(gcells->cells);
 
-	if (skb_queue_len(&cell->napi_skbs) > netdev_max_backlog) {
+	if (skb_queue_len(&cell->napi_skbs) > READ_ONCE(netdev_max_backlog)) {
 drop:
 		dev_core_stats_rx_dropped_inc(dev);
 		kfree_skb(skb);
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 82d14eea1b5ad..974eb97b77d22 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -168,7 +168,7 @@ int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
-	if (skb_queue_len(&ctx->out_queue) >= netdev_max_backlog)
+	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog))
 		return -ENOBUFS;
 
 	__skb_queue_tail(&ctx->out_queue, skb);
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 70a8c36f0ba6e..b2f4ec9c537f0 100644
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



