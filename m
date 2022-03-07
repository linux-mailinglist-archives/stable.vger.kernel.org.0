Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71494CF6B7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiCGJma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237764AbiCGJgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:36:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827FF6E2AF;
        Mon,  7 Mar 2022 01:31:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CBAF60FF6;
        Mon,  7 Mar 2022 09:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51478C340F3;
        Mon,  7 Mar 2022 09:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645479;
        bh=qIEtfsXV4mFbk4F56zW+/PD3478NpqG9bicT6hHDAkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxSyvD9znO4/8cTy9ep5L14tSRGDSd7s65p3qSJbA7LTvV3c7jFPjkS1sgMOP6ayM
         zNE7yBIFJf1+Uevm3cn+m5sy0mZVb6V/ntFfKPYmeJLTLnA73d7VbEXTB2LIlF+3Zh
         zfhWREGBA+rnQsi63+1N5I0F5sqprmsTFYSgd7zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 044/105] netfilter: nf_queue: fix possible use-after-free
Date:   Mon,  7 Mar 2022 10:18:47 +0100
Message-Id: <20220307091645.425786626@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit c3873070247d9e3c7a6b0cf9bf9b45e8018427b1 upstream.

Eric Dumazet says:
  The sock_hold() side seems suspect, because there is no guarantee
  that sk_refcnt is not already 0.

On failure, we cannot queue the packet and need to indicate an
error.  The packet will be dropped by the caller.

v2: split skb prefetch hunk into separate change

Fixes: 271b72c7fa82c ("udp: RCU handling for Unicast packets.")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_queue.h |    2 +-
 net/netfilter/nf_queue.c         |   13 +++++++++----
 net/netfilter/nfnetlink_queue.c  |   12 +++++++++---
 3 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -37,7 +37,7 @@ void nf_register_queue_handler(struct ne
 void nf_unregister_queue_handler(struct net *net);
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
 void nf_queue_entry_free(struct nf_queue_entry *entry);
 
 static inline void init_hashrandom(u32 *jhash_initval)
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -100,16 +100,17 @@ static void __nf_queue_entry_init_physde
 }
 
 /* Bump dev refs so they don't vanish while packet is out */
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
 
+	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
+		return false;
+
 	if (state->in)
 		dev_hold(state->in);
 	if (state->out)
 		dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	if (entry->physin)
@@ -117,6 +118,7 @@ void nf_queue_entry_get_refs(struct nf_q
 	if (entry->physout)
 		dev_hold(entry->physout);
 #endif
+	return true;
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -205,7 +207,10 @@ static int __nf_queue(struct sk_buff *sk
 
 	__nf_queue_entry_init_physdevs(entry);
 
-	nf_queue_entry_get_refs(entry);
+	if (!nf_queue_entry_get_refs(entry)) {
+		kfree(entry);
+		return -ENOTCONN;
+	}
 
 	switch (entry->state.pf) {
 	case AF_INET:
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -712,9 +712,15 @@ static struct nf_queue_entry *
 nf_queue_entry_dup(struct nf_queue_entry *e)
 {
 	struct nf_queue_entry *entry = kmemdup(e, e->size, GFP_ATOMIC);
-	if (entry)
-		nf_queue_entry_get_refs(entry);
-	return entry;
+
+	if (!entry)
+		return NULL;
+
+	if (nf_queue_entry_get_refs(entry))
+		return entry;
+
+	kfree(entry);
+	return NULL;
 }
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)


