Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4BF4CF830
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbiCGJwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiCGJuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4A9710EC;
        Mon,  7 Mar 2022 01:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08DF9B810CF;
        Mon,  7 Mar 2022 09:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444A7C340F6;
        Mon,  7 Mar 2022 09:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646192;
        bh=G9AhXJMncP9M8uGCSalT39DSnLh5dH33AtDnouCfyEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjvqQNQy7tb8XrBSlUG8i6k2smLL0+oWzCeCMyHDIL0lhCbKKHYmrEpYZprp4MfUH
         6yry1H37woybgN1rzq5DiokADKanZPfM3syOXd+re/u1/B/rGvnwxhSHs6gz7JK/T5
         GzKVvBztn3N18EcJRUkfUgftmpV7Hn7fsHnh4Xso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Stringer <joe@cilium.io>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 162/262] netfilter: nf_queue: handle socket prefetch
Date:   Mon,  7 Mar 2022 10:18:26 +0100
Message-Id: <20220307091707.003096337@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

commit 3b836da4081fa585cf6c392f62557496f2cb0efe upstream.

In case someone combines bpf socket assign and nf_queue, then we will
queue an skb who references a struct sock that did not have its
reference count incremented.

As we leave rcu protection, there is no guarantee that skb->sk is still
valid.

For refcount-less skb->sk case, try to increment the reference count
and then override the destructor.

In case of failure we have two choices: orphan the skb and 'delete'
preselect or let nf_queue() drop the packet.

Do the latter, it should not happen during normal operation.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Acked-by: Joe Stringer <joe@cilium.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_queue.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -180,6 +180,18 @@ static int __nf_queue(struct sk_buff *sk
 		break;
 	}
 
+	if (skb_sk_is_prefetched(skb)) {
+		struct sock *sk = skb->sk;
+
+		if (!sk_is_refcounted(sk)) {
+			if (!refcount_inc_not_zero(&sk->sk_refcnt))
+				return -ENOTCONN;
+
+			/* drop refcount on skb_orphan */
+			skb->destructor = sock_edemux;
+		}
+	}
+
 	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;


