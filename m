Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA795AAF79
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbiIBMj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiIBMi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:38:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C713DC1;
        Fri,  2 Sep 2022 05:30:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC43B62175;
        Fri,  2 Sep 2022 12:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A0BC433D6;
        Fri,  2 Sep 2022 12:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121767;
        bh=9NWEiSryDCA9PIKWIcExTflup0XRLRkcGw2V8ePGtIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guereO6JVavvwR5KAE+ln0vN0JQJfg9TD05HSONDZvNjPAlvm3JZOkNQwVMZ9ElkY
         BI1p4bcMOz1QUB1KC+FmPVdn2T78cg1UTgpAkRK0e6wlD6Ihg8j4OLLPsm3of+iKqT
         kFlB330EENnoDTFhvDOBcQzv9TG9YOeLzIMjImi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 27/77] net: Fix data-races around netdev_tstamp_prequeue.
Date:   Fri,  2 Sep 2022 14:18:36 +0200
Message-Id: <20220902121404.544964153@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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
index 517fb03a0bb89..99b0025864984 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4411,7 +4411,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_rx(skb);
 
@@ -4753,7 +4753,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	int ret = NET_RX_DROP;
 	__be16 type;
 
-	net_timestamp_check(!netdev_tstamp_prequeue, skb);
+	net_timestamp_check(!READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	trace_netif_receive_skb(skb);
 
@@ -5135,7 +5135,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 {
 	int ret;
 
-	net_timestamp_check(netdev_tstamp_prequeue, skb);
+	net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
@@ -5165,7 +5165,7 @@ static void netif_receive_skb_list_internal(struct list_head *head)
 
 	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
-		net_timestamp_check(netdev_tstamp_prequeue, skb);
+		net_timestamp_check(READ_ONCE(netdev_tstamp_prequeue), skb);
 		skb_list_del_init(skb);
 		if (!skb_defer_rx_timestamp(skb))
 			list_add_tail(&skb->list, &sublist);
-- 
2.35.1



