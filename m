Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7776810E8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbjA3OIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbjA3OIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4497734C3F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D77ADB811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E034C433EF;
        Mon, 30 Jan 2023 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087688;
        bh=M/aktztpZwKdVqcLJ+0jxXh5C5RuzZNHsXpKmRhmdJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO7RHamEStDPEqOSfylQF9fTVwwbublG98VRcq75oEzPxs8beApsNX80gER1JBiCt
         EyFFalDkpsZRZTBQaUGgO9MuplEFXpqeXnh3WQlL/kkyO9l4lDP9M8FUh1a4ftlU/B
         KJnw7mmbZVBklCVafG0P+TSJaOcrUdSj3E7LBph0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Noam Rathaus <noamr@ssd-disclosure.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 291/313] net: mctp: hold key reference when looking up a general key
Date:   Mon, 30 Jan 2023 14:52:06 +0100
Message-Id: <20230130134350.292920424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 6e54ea37e344f145665c2dc3cc534b92529e8de5 ]

Currently, we have a race where we look up a sock through a "general"
(ie, not directly associated with the (src,dest,tag) tuple) key, then
drop the key reference while still holding the key's sock.

This change expands the key reference until we've finished using the
sock, and hence the sock reference too.

Commit message changes from Jeremy Kerr <jk@codeconstruct.com.au>.

Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Fixes: 73c618456dc5 ("mctp: locking, lifetime and validity changes for sk_keys")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index ce10ba7ae839..06c0de21984d 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -317,8 +317,8 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 
 static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 {
+	struct mctp_sk_key *key, *any_key = NULL;
 	struct net *net = dev_net(skb->dev);
-	struct mctp_sk_key *key;
 	struct mctp_sock *msk;
 	struct mctp_hdr *mh;
 	unsigned long f;
@@ -363,13 +363,11 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * key for reassembly - we'll create a more specific
 			 * one for future packets if required (ie, !EOM).
 			 */
-			key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
-			if (key) {
-				msk = container_of(key->sk,
+			any_key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
+			if (any_key) {
+				msk = container_of(any_key->sk,
 						   struct mctp_sock, sk);
-				spin_unlock_irqrestore(&key->lock, f);
-				mctp_key_unref(key);
-				key = NULL;
+				spin_unlock_irqrestore(&any_key->lock, f);
 			}
 		}
 
@@ -475,6 +473,8 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		spin_unlock_irqrestore(&key->lock, f);
 		mctp_key_unref(key);
 	}
+	if (any_key)
+		mctp_key_unref(any_key);
 out:
 	if (rc)
 		kfree_skb(skb);
-- 
2.39.0



