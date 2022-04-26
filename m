Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6E50F4C4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344003AbiDZIkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345660AbiDZIjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B153DA6F;
        Tue, 26 Apr 2022 01:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3936A617A4;
        Tue, 26 Apr 2022 08:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A42FC385A0;
        Tue, 26 Apr 2022 08:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961838;
        bh=XGSb/BaOFZrY1oZd6WGEMKQ89ZzLJwd0bo7KPM/hLO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwFGwYEsJxxYLBIpU6hnO3Vi8ye50WX+rKTytyvXTHarMZo/qWBPZQx8QTSmjwErh
         T9Bu5spuoWvxnceEQO722F2+FyWKAj51zG2fhLtTPsVMAwk4ZafryEzwLQGvCO5Dke
         r8SzrOY53O6baMsLKEUUdu2RVMxn4UH5EF2Gz6Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Dias <rdias@singlestore.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 08/62] tcp: Fix potential use-after-free due to double kfree()
Date:   Tue, 26 Apr 2022 10:20:48 +0200
Message-Id: <20220426081737.460429927@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

commit c89dffc70b340780e5b933832d8c3e045ef3791e upstream.

Receiving ACK with a valid SYN cookie, cookie_v4_check() allocates struct
request_sock and then can allocate inet_rsk(req)->ireq_opt. After that,
tcp_v4_syn_recv_sock() allocates struct sock and copies ireq_opt to
inet_sk(sk)->inet_opt. Normally, tcp_v4_syn_recv_sock() inserts the full
socket into ehash and sets NULL to ireq_opt. Otherwise,
tcp_v4_syn_recv_sock() has to reset inet_opt by NULL and free the full
socket.

The commit 01770a1661657 ("tcp: fix race condition when creating child
sockets from syncookies") added a new path, in which more than one cores
create full sockets for the same SYN cookie. Currently, the core which
loses the race frees the full socket without resetting inet_opt, resulting
in that both sock_put() and reqsk_put() call kfree() for the same memory:

  sock_put
    sk_free
      __sk_free
        sk_destruct
          __sk_destruct
            sk->sk_destruct/inet_sock_destruct
              kfree(rcu_dereference_protected(inet->inet_opt, 1));

  reqsk_put
    reqsk_free
      __reqsk_free
        req->rsk_ops->destructor/tcp_v4_reqsk_destructor
          kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));

Calling kmalloc() between the double kfree() can lead to use-after-free, so
this patch fixes it by setting NULL to inet_opt before sock_put().

As a side note, this kind of issue does not happen for IPv6. This is
because tcp_v6_syn_recv_sock() clones both ipv6_opt and pktopts which
correspond to ireq_opt in IPv4.

Fixes: 01770a166165 ("tcp: fix race condition when creating child sockets from syncookies")
CC: Ricardo Dias <rdias@singlestore.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20210118055920.82516-1-kuniyu@amazon.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1503,6 +1503,8 @@ struct sock *tcp_v4_syn_recv_sock(const
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
+		newinet->inet_opt = NULL;
+
 		if (!req_unhash && found_dup_sk) {
 			/* This code path should only be executed in the
 			 * syncookie case only
@@ -1510,8 +1512,6 @@ struct sock *tcp_v4_syn_recv_sock(const
 			bh_unlock_sock(newsk);
 			sock_put(newsk);
 			newsk = NULL;
-		} else {
-			newinet->inet_opt = NULL;
 		}
 	}
 	return newsk;


