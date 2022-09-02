Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABE15AB0FD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiIBNBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiIBM7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676D6FC32F;
        Fri,  2 Sep 2022 05:40:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06693B82ADF;
        Fri,  2 Sep 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508D9C433D6;
        Fri,  2 Sep 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122410;
        bh=qJtlZbyOTsV51PIP1uTB7gctPH/B6Gl+DB+pExHFlyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLcVk9RbfRpPHpATjxZ0FUVlW6m0JrenCE2v61mLeGb9n8ZMDZp0cNpYHFyoyWhSD
         Q2IzTVFp3LeRO9fzk3Bdyc1ADl/PMTqwVhWf34I9mW27Bd3OsU3tpekU87T4qG37rl
         dqzkXuQVPW/8pRGxqk6Cjit6OeZylF23AtjkG48U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 37/37] net: neigh: dont call kfree_skb() under spin_lock_irqsave()
Date:   Fri,  2 Sep 2022 14:19:59 +0200
Message-Id: <20220902121400.327532774@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit d5485d9dd24e1d04e5509916515260186eb1455c upstream.

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So add all skb to
a tmp list, then free them after spin_unlock_irqrestore() at
once.

Fixes: 66ba215cb513 ("neigh: fix possible DoS due to net iface start/stop loop")
Suggested-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -282,21 +282,27 @@ static int neigh_del_timer(struct neighb
 
 static void pneigh_queue_purge(struct sk_buff_head *list, struct net *net)
 {
+	struct sk_buff_head tmp;
 	unsigned long flags;
 	struct sk_buff *skb;
 
+	skb_queue_head_init(&tmp);
 	spin_lock_irqsave(&list->lock, flags);
 	skb = skb_peek(list);
 	while (skb != NULL) {
 		struct sk_buff *skb_next = skb_peek_next(skb, list);
 		if (net == NULL || net_eq(dev_net(skb->dev), net)) {
 			__skb_unlink(skb, list);
-			dev_put(skb->dev);
-			kfree_skb(skb);
+			__skb_queue_tail(&tmp, skb);
 		}
 		skb = skb_next;
 	}
 	spin_unlock_irqrestore(&list->lock, flags);
+
+	while ((skb = __skb_dequeue(&tmp))) {
+		dev_put(skb->dev);
+		kfree_skb(skb);
+	}
 }
 
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,


