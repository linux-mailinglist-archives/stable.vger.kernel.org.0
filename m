Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0666F69CDB2
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjBTNvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjBTNvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C656D1E5E4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A6160E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAEDC433EF;
        Mon, 20 Feb 2023 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901108;
        bh=i+O2QE7ECDHdDy0YYxQm3+SVGfxD/NJ028txP+HoMKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZCMMq3aa9yWWLemGi+/kfHOmY87ow/HdrSwePpK+GPgD7wf7WKRtECKGSfALOtsr
         2+ltxxMCCC55TgzH36g7kApDoDEAhtv6SQqZ0fgjnX5Kkbhcp/Zw6OxLWQMqQdvqv/
         vw2IyOX05xEPRXSOF+TAgWELHIZgjtUINbCmnqg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/83] bpf, sockmap: Dont let sock_map_{close,destroy,unhash} call itself
Date:   Mon, 20 Feb 2023 14:35:42 +0100
Message-Id: <20230220133554.018002701@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 5b4a79ba65a1ab479903fff2e604865d229b70a9 ]

sock_map proto callbacks should never call themselves by design. Protect
against bugs like [1] and break out of the recursive loop to avoid a stack
overflow in favor of a resource leak.

[1] https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20230113-sockmap-fix-v2-1-1e0ee7ac2f90@cloudflare.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 61 +++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ae6013a8bce53..86b4e8909ad1e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1514,15 +1514,16 @@ void sock_map_unhash(struct sock *sk)
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
-		if (sk->sk_prot->unhash)
-			sk->sk_prot->unhash(sk);
-		return;
+		saved_unhash = READ_ONCE(sk->sk_prot)->unhash;
+	} else {
+		saved_unhash = psock->saved_unhash;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
 	}
-
-	saved_unhash = psock->saved_unhash;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	saved_unhash(sk);
+	if (WARN_ON_ONCE(saved_unhash == sock_map_unhash))
+		return;
+	if (saved_unhash)
+		saved_unhash(sk);
 }
 EXPORT_SYMBOL_GPL(sock_map_unhash);
 
@@ -1535,17 +1536,18 @@ void sock_map_destroy(struct sock *sk)
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
-		if (sk->sk_prot->destroy)
-			sk->sk_prot->destroy(sk);
-		return;
+		saved_destroy = READ_ONCE(sk->sk_prot)->destroy;
+	} else {
+		saved_destroy = psock->saved_destroy;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
+		sk_psock_stop(psock);
+		sk_psock_put(sk, psock);
 	}
-
-	saved_destroy = psock->saved_destroy;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	sk_psock_stop(psock);
-	sk_psock_put(sk, psock);
-	saved_destroy(sk);
+	if (WARN_ON_ONCE(saved_destroy == sock_map_destroy))
+		return;
+	if (saved_destroy)
+		saved_destroy(sk);
 }
 EXPORT_SYMBOL_GPL(sock_map_destroy);
 
@@ -1560,16 +1562,21 @@ void sock_map_close(struct sock *sk, long timeout)
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
 		release_sock(sk);
-		return sk->sk_prot->close(sk, timeout);
+		saved_close = READ_ONCE(sk->sk_prot)->close;
+	} else {
+		saved_close = psock->saved_close;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
+		sk_psock_stop(psock);
+		release_sock(sk);
+		cancel_work_sync(&psock->work);
+		sk_psock_put(sk, psock);
 	}
-
-	saved_close = psock->saved_close;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	sk_psock_stop(psock);
-	release_sock(sk);
-	cancel_work_sync(&psock->work);
-	sk_psock_put(sk, psock);
+	/* Make sure we do not recurse. This is a bug.
+	 * Leak the socket instead of crashing on a stack overflow.
+	 */
+	if (WARN_ON_ONCE(saved_close == sock_map_close))
+		return;
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
-- 
2.39.0



