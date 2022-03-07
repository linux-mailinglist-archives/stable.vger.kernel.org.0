Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC9A4CF98D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbiCGKGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240146AbiCGKFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:05:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA4975E52;
        Mon,  7 Mar 2022 01:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24A21B810A8;
        Mon,  7 Mar 2022 09:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F408C340F3;
        Mon,  7 Mar 2022 09:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646722;
        bh=9gMIlgL6kH8UmnexFxaHtEWTfqVUew7jEhJimxMY+J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rY+iBsxdwBN6NPyDNYMiEIQbiclXv9kss87kwcJSZS7zx9H0Gf5rhfVVUK0WaVJF6
         DhspBFXvXKAcJtw+G1NTf/MG2sWl9QAJXlsk8b5xP96oviwxQFHa5U1exniCa2VYK8
         0nCzFl6+uAV9CPoigb9y5jDMslmP5ozGJus0qkRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksandr Natalenko <oleksandr@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.16 073/186] netfilter: nf_queue: dont assume sk is full socket
Date:   Mon,  7 Mar 2022 10:18:31 +0100
Message-Id: <20220307091656.131404611@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

commit 747670fd9a2d1b7774030dba65ca022ba442ce71 upstream.

There is no guarantee that state->sk refers to a full socket.

If refcount transitions to 0, sock_put calls sk_free which then ends up
with garbage fields.

I'd like to thank Oleksandr Natalenko and Jiri Benc for considerable
debug work and pointing out state->sk oddities.

Fixes: ca6fb0651883 ("tcp: attach SYNACK messages to request sockets instead of listener")
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_queue.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -46,6 +46,15 @@ void nf_unregister_queue_handler(void)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
+static void nf_queue_sock_put(struct sock *sk)
+{
+#ifdef CONFIG_INET
+	sock_gen_put(sk);
+#else
+	sock_put(sk);
+#endif
+}
+
 static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
@@ -54,7 +63,7 @@ static void nf_queue_entry_release_refs(
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
-		sock_put(state->sk);
+		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_put(entry->physin);


