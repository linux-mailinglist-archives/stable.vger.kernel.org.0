Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98785656E4
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiGDNUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiGDNUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0512BB42
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:20:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9417861526
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCE4C3411E;
        Mon,  4 Jul 2022 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656940844;
        bh=hQn9TSbDjqCGTuJOp8qkz4phBxaueOqzU/W0fX6nM94=;
        h=Subject:To:Cc:From:Date:From;
        b=w7E6N+ugwsJvCtZjcVjc4NwRxxSeI4KHO7EGY2VTRkzUHy9PRg/zaLVEHrDDkWRm1
         sB7VtdmXi28S5zRoVISbaIzn+19WrMOj6I1PcLWYchHg56mqXyDz7j+fD68FSG/nlh
         +jRvi5UoKOzVukTAoakchDjjTZoX6GZ5GSXnRmUc=
Subject: FAILED: patch "[PATCH] tcp: add a missing nf_reset_ct() in 3WHS handling" failed to apply to 5.15-stable tree
To:     edumazet@google.com, fw@strlen.de, i.maximets@ovn.org,
        kuba@kernel.org, pablo@netfilter.org, steffen.klassert@secunet.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:20:41 +0200
Message-ID: <1656940841199204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6f0012e35160cd08a53e46e3b3bbf724b92dfe68 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 23 Jun 2022 05:04:36 +0000
Subject: [PATCH] tcp: add a missing nf_reset_ct() in 3WHS handling

When the third packet of 3WHS connection establishment
contains payload, it is added into socket receive queue
without the XFRM check and the drop of connection tracking
context.

This means that if the data is left unread in the socket
receive queue, conntrack module can not be unloaded.

As most applications usually reads the incoming data
immediately after accept(), bug has been hiding for
quite a long time.

Commit 68822bdf76f1 ("net: generalize skb freeing
deferral to per-cpu lists") exposed this bug because
even if the application reads this data, the skb
with nfct state could stay in a per-cpu cache for
an arbitrary time, if said cpu no longer process RX softirqs.

Many thanks to Ilya Maximets for reporting this issue,
and for testing various patches:
https://lore.kernel.org/netdev/20220619003919.394622-1-i.maximets@ovn.org/

Note that I also added a missing xfrm4_policy_check() call,
although this is probably not a big issue, as the SYN
packet should have been dropped earlier.

Fixes: b59c270104f0 ("[NETFILTER]: Keep conntrack reference until IPsec policy checks are done")
Reported-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Tested-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://lore.kernel.org/r/20220623050436.1290307-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe8f23b95d32..da5a3c44c4fb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1964,7 +1964,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		drop_reason = tcp_inbound_md5_hash(sk, skb,
+		if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+		else
+			drop_reason = tcp_inbound_md5_hash(sk, skb,
 						   &iph->saddr, &iph->daddr,
 						   AF_INET, dif, sdif);
 		if (unlikely(drop_reason)) {
@@ -2016,6 +2019,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);

