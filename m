Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC88566D2C
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbiGEMV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiGEMRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AC31164;
        Tue,  5 Jul 2022 05:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F159FCE0B30;
        Tue,  5 Jul 2022 12:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAE4C341C7;
        Tue,  5 Jul 2022 12:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023164;
        bh=yzAS8v6m5CgK6auiL+lv4OCs3UkCk+xlX70L7UqN33A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPhIfP0FKrnrxxXXyB/nXSUeNdX0dP0GYyN05H+b6TKg7JCcPTA3AiRw8FSA4WqbS
         gOD1LQ5ew28tPgFrp7vlK6SRm6IoHhfgFshZlFG2Fts3xbHt93xSuXoh7MA/UKUJab
         msln73AuVUyCb5HBctM9eKFfqkF17jU900ZzJ9jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/98] tcp: add a missing nf_reset_ct() in 3WHS handling
Date:   Tue,  5 Jul 2022 13:58:18 +0200
Message-Id: <20220705115619.285706602@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Dumazet <edumazet@google.com>

commit 6f0012e35160cd08a53e46e3b3bbf724b92dfe68 upstream.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2014,7 +2014,8 @@ process:
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb) ||
+			     tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2061,6 +2062,7 @@ process:
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v4_restore_cb(skb);


