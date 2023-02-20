Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74E969CEA8
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjBTOBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjBTOBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:01:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB1E1EBE7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 06:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5834D60EAE
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 14:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B59BC433D2;
        Mon, 20 Feb 2023 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901626;
        bh=XcxreMCkMGO+mp/iE3q1I/BxLtlzNPMF3MP8F3LO/sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiXbJ4+coiMvNOnzRPO3SiCMNJyAaTg1ddFtPYQK8y7xay+90Fk1ZRfQPpqIrAAKm
         rvIEKM9XjnUmDOHb3IK9iYAk87tGowUMywen+XUVO7ji8wnlFzASrn8tDUf4bfoPjj
         TXElWPHpInebuEgQ57CoHAjSzPKfcEakl02ZBDHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 089/118] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
Date:   Mon, 20 Feb 2023 14:36:45 +0100
Message-Id: <20230220133603.960426590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit ca43ccf41224b023fc290073d5603a755fd12eed upstream.

Eric Dumazet pointed out [0] that when we call skb_set_owner_r()
for ipv6_pinfo.pktoptions, sk_rmem_schedule() has not been called,
resulting in a negative sk_forward_alloc.

We add a new helper which clones a skb and sets its owner only
when sk_rmem_schedule() succeeds.

Note that we move skb_set_owner_r() forward in (dccp|tcp)_v6_do_rcv()
because tcp_send_synack() can make sk_forward_alloc negative before
ipv6_opt_accepted() in the crossed SYN-ACK or self-connect() cases.

[0]: https://lore.kernel.org/netdev/CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com/

Fixes: 323fbd0edf3f ("net: dccp: Add handling of IPV6_PKTOPTIONS to dccp_v6_do_rcv()")
Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h  |   13 +++++++++++++
 net/dccp/ipv6.c     |    7 ++-----
 net/ipv6/tcp_ipv6.c |   10 +++-------
 3 files changed, 18 insertions(+), 12 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2430,6 +2430,19 @@ static inline __must_check bool skb_set_
 	return false;
 }
 
+static inline struct sk_buff *skb_clone_and_charge_r(struct sk_buff *skb, struct sock *sk)
+{
+	skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+	if (skb) {
+		if (sk_rmem_schedule(sk, skb, skb->truesize)) {
+			skb_set_owner_r(skb, sk);
+			return skb;
+		}
+		__kfree_skb(skb);
+	}
+	return NULL;
+}
+
 static inline void skb_prepare_for_gro(struct sk_buff *skb)
 {
 	if (skb->destructor != sock_wfree) {
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -551,11 +551,9 @@ static struct sock *dccp_v6_request_recv
 	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
-		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
+		newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 		consume_skb(ireq->pktopts);
 		ireq->pktopts = NULL;
-		if (newnp->pktoptions)
-			skb_set_owner_r(newnp->pktoptions, newsk);
 	}
 
 	return newsk;
@@ -615,7 +613,7 @@ static int dccp_v6_do_rcv(struct sock *s
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, GFP_ATOMIC);
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	if (sk->sk_state == DCCP_OPEN) { /* Fast path */
 		if (dccp_rcv_established(sk, skb, dccp_hdr(skb), skb->len))
@@ -679,7 +677,6 @@ ipv6_pktoptions:
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb,
 				      &DCCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			memmove(IP6CB(opt_skb),
 				&DCCP_SKB_CB(opt_skb)->header.h6,
 				sizeof(struct inet6_skb_parm));
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1388,14 +1388,11 @@ static struct sock *tcp_v6_syn_recv_sock
 
 		/* Clone pktoptions received with SYN, if we own the req */
 		if (ireq->pktopts) {
-			newnp->pktoptions = skb_clone(ireq->pktopts,
-						      sk_gfp_mask(sk, GFP_ATOMIC));
+			newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 			consume_skb(ireq->pktopts);
 			ireq->pktopts = NULL;
-			if (newnp->pktoptions) {
+			if (newnp->pktoptions)
 				tcp_v6_restore_cb(newnp->pktoptions);
-				skb_set_owner_r(newnp->pktoptions, newsk);
-			}
 		}
 	} else {
 		if (!req_unhash && found_dup_sk) {
@@ -1467,7 +1464,7 @@ int tcp_v6_do_rcv(struct sock *sk, struc
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1553,7 +1550,6 @@ ipv6_pktoptions:
 		if (np->repflow)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb, &TCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			tcp_v6_restore_cb(opt_skb);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
 		} else {


