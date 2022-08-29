Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74555A49CE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiH2L36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiH2L3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9BD78BD2;
        Mon, 29 Aug 2022 04:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1444A61128;
        Mon, 29 Aug 2022 11:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFD5C433D6;
        Mon, 29 Aug 2022 11:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771150;
        bh=eTejDpS13D/jixJdgnj9+fUID/w5E/ssspcErqeGyTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ck4ZbxrkW9wDjSCgcmvc+/5P8STVcaQgxrkCyBlgbQ6BM63GrI12OI3VBt5e45Ppf
         j/Pf7xDqK+s95e2jTF1nmnWlkEPFfpGA+a3COcsBrPFE2YLaRtg9UB7SYGZZqN4CSv
         0yTu9dZbQWw3n6eg0uBDQpIxpqRYqG3LQQklExK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/136] net: Fix data-races around netdev_max_backlog.
Date:   Mon, 29 Aug 2022 12:58:59 +0200
Message-Id: <20220829105807.589560174@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
index 4150f74c521a8..5310f398794c1 100644
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
index 1a0de071fcf45..87cf2e0d8f6f1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4589,7 +4589,7 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
 	struct softnet_data *sd;
 	unsigned int old_flow, new_flow;
 
-	if (qlen < (netdev_max_backlog >> 1))
+	if (qlen < (READ_ONCE(netdev_max_backlog) >> 1))
 		return false;
 
 	sd = this_cpu_ptr(&softnet_data);
@@ -4637,7 +4637,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
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
index 3df0861d4390f..5f34bc378fdcf 100644
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



