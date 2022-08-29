Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C825A49B3
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbiH2L2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiH2L0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:26:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6DA78591;
        Mon, 29 Aug 2022 04:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8F04611D7;
        Mon, 29 Aug 2022 11:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB11BC433C1;
        Mon, 29 Aug 2022 11:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771704;
        bh=Rtv0W/RxDptni++jUiUdRolbugDTJsRA+DiimTN3q/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0+4tscDltwC33hEtLsg29hj2SRkSGZf9GWgJg3JcQrWo7WFqryjiLqVEsU3HysA9
         uW4KVRLPDoqvQJRhVALzQxXweoKbqOl+hqFcqxUOnNXCjFBAxYNbQ0I4mobpTEXqfY
         2PQ8bxPDGQOD9virhF1dSqxTwY1RoBIpLemyZIq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 068/158] net: Fix data-races around netdev_tstamp_prequeue.
Date:   Mon, 29 Aug 2022 12:58:38 +0200
Message-Id: <20220829105811.838301381@linuxfoundation.org>
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

[ Upstream commit 61adf447e38664447526698872e21c04623afb8e ]

While reading netdev_tstamp_prequeue, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 3b098e2d7c69 ("net: Consistent skb timestamping")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e1496e626a532..34282b93c3f60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4927,7 +4927,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_rx(skb);
 
@@ -5280,7 +5280,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	int ret = NET_RX_DROP;
 	__be16 type;
 
-	net_timestamp_check(!netdev_tstamp_prequeue, skb);
+	net_timestamp_check(!READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_receive_skb(skb);
 
@@ -5663,7 +5663,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
@@ -5693,7 +5693,7 @@ void netif_receive_skb_list_internal(struct list_head *head)
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		net_timestamp_check(netdev_tstamp_prequeue, skb);
+		net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 		skb_list_del_init(skb);
 		if (!skb_defer_rx_timestamp(skb))
 			list_add_tail(&skb->list, &sublist);
-- 
2.35.1



