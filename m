Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB884CF512
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiCGJY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbiCGJXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C063B65821;
        Mon,  7 Mar 2022 01:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4823E61027;
        Mon,  7 Mar 2022 09:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5915DC340F3;
        Mon,  7 Mar 2022 09:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644909;
        bh=Fi3GZLIsbutc8SXukSmt00AA/xd56Py1HYugwVIKGAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrLqE4V9wxPTSV4IRlyFmYMdluadsHOIgaGg1SNS+taPXettuL6bg+78rdx9Pea9i
         STZBrQmVxzK0Ma9WsHPVjyvOBgL3DcZdTiswHTBLxtRTAaEQou4oBf24q+FDvb4+ON
         c++xJJeDPf9UPLZkwx9HT4zoOX11r5gJUb8q1YrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.14 19/42] netfilter: nf_queue: fix possible use-after-free
Date:   Mon,  7 Mar 2022 10:18:53 +0100
Message-Id: <20220307091636.710014074@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
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
 net/netfilter/nf_queue.c         |   12 ++++++++++--
 net/netfilter/nfnetlink_queue.c  |   12 +++++++++---
 3 files changed, 20 insertions(+), 6 deletions(-)

--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -32,7 +32,7 @@ void nf_register_queue_handler(struct ne
 void nf_unregister_queue_handler(struct net *net);
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
-void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
+bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
 void nf_queue_entry_release_refs(struct nf_queue_entry *entry);
 
 static inline void init_hashrandom(u32 *jhash_initval)
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -80,10 +80,13 @@ void nf_queue_entry_release_refs(struct
 EXPORT_SYMBOL_GPL(nf_queue_entry_release_refs);
 
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
@@ -102,6 +105,7 @@ void nf_queue_entry_get_refs(struct nf_q
 			dev_hold(physdev);
 	}
 #endif
+	return true;
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -159,7 +163,11 @@ static int __nf_queue(struct sk_buff *sk
 		.size	= sizeof(*entry) + afinfo->route_key_size,
 	};
 
-	nf_queue_entry_get_refs(entry);
+	if (!nf_queue_entry_get_refs(entry)) {
+		kfree(entry);
+		return -ENOTCONN;
+	}
+
 	afinfo->saveroute(skb, entry);
 	status = qh->outfn(entry, queuenum);
 
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -693,9 +693,15 @@ static struct nf_queue_entry *
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


