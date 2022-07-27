Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C75830B5
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiG0RlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242774AbiG0RkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551DB61D91;
        Wed, 27 Jul 2022 09:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D91661560;
        Wed, 27 Jul 2022 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E93EC433C1;
        Wed, 27 Jul 2022 16:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940673;
        bh=bM892KhhPAeee0HH8jIulRXOdwogdtlf43M4Vsm/Nmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lohNuymgEliGYh6pDYLbTRVCBsEj9JC5KZayxZOmHlwWxmtHxaNHTTMUZoT9mRkkO
         lVln+gMrQ1kwlDSmbpZGYfNmXHQGy95N9dA/Cj7QT4AAwVkGE6MInaKmBsFbGhMtGW
         j9V9GU7q/Mm3sM1IQ3OXSTysk5blAoaLkgCkN5Nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 108/158] amt: do not use amt->nr_tunnels outside of lock
Date:   Wed, 27 Jul 2022 18:12:52 +0200
Message-Id: <20220727161025.804001140@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 989918482bbccbbce3ba2bb9156eb4c193319983 ]

amt->nr_tunnels is protected by amt->lock.
But, amt_request_handler() has been using this variable without the
amt->lock.
So, it expands context of amt->lock in the amt_request_handler() to
protect amt->nr_tunnels variable.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 4277924ab3b9..acf5ea96652f 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2679,7 +2679,9 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 		if (tunnel->ip4 == iph->saddr)
 			goto send;
 
+	spin_lock_bh(&amt->lock);
 	if (amt->nr_tunnels >= amt->max_tunnels) {
+		spin_unlock_bh(&amt->lock);
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 		return true;
 	}
@@ -2687,8 +2689,10 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 	tunnel = kzalloc(sizeof(*tunnel) +
 			 (sizeof(struct hlist_head) * amt->hash_buckets),
 			 GFP_ATOMIC);
-	if (!tunnel)
+	if (!tunnel) {
+		spin_unlock_bh(&amt->lock);
 		return true;
+	}
 
 	tunnel->source_port = udph->source;
 	tunnel->ip4 = iph->saddr;
@@ -2701,10 +2705,9 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 
 	INIT_DELAYED_WORK(&tunnel->gc_wq, amt_tunnel_expire);
 
-	spin_lock_bh(&amt->lock);
 	list_add_tail_rcu(&tunnel->list, &amt->tunnel_list);
 	tunnel->key = amt->key;
-	amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
+	__amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
 	amt->nr_tunnels++;
 	mod_delayed_work(amt_wq, &tunnel->gc_wq,
 			 msecs_to_jiffies(amt_gmi(amt)));
-- 
2.35.1



