Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B5F14B684
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgA1OFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbgA1OFa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC602468E;
        Tue, 28 Jan 2020 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220330;
        bh=tGDZBRoshrw5xaOaC8h89pZSKcEEwCnkWWYwTwUhhgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIhFCeRAiT9PbeUHTHHTp3Mlcr1qfU7hGqmdi3RSXi/Psu4VjwfB2nLmOaQdILQ8G
         tXEQxVXtDoMVTBeDwrWO/z5ibe/GlCWHibgiK7T+iowyqFs6fqPqTXlJ8FzZ2259+P
         +/ifHnrxUkNOPHGrrpm4Z0gg/kzsm7W/rBWSYjiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 084/104] net, sk_msg: Dont check if sock is locked when tearing down psock
Date:   Tue, 28 Jan 2020 15:00:45 +0100
Message-Id: <20200128135828.791836526@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 58c8db929db1c1d785a6f5d8f8692e5dbcc35e84 upstream.

As John Fastabend reports [0], psock state tear-down can happen on receive
path *after* unlocking the socket, if the only other psock user, that is
sockmap or sockhash, releases its psock reference before tcp_bpf_recvmsg
does so:

 tcp_bpf_recvmsg()
  psock = sk_psock_get(sk)                         <- refcnt 2
  lock_sock(sk);
  ...
                                  sock_map_free()  <- refcnt 1
  release_sock(sk)
  sk_psock_put()                                   <- refcnt 0

Remove the lockdep check for socket lock in psock tear-down that got
introduced in 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during
tear down").

[0] https://lore.kernel.org/netdev/5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch/

Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
Suggested-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skmsg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -594,8 +594,6 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
-	sock_owned_by_me(sk);
-
 	sk_psock_cork_free(psock);
 	sk_psock_zap_ingress(psock);
 


