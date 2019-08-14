Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B458DA5B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbfHNRNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730869AbfHNRNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4150D20665;
        Wed, 14 Aug 2019 17:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802802;
        bh=ybXdM9q+D0assHnEXTbPJ7lFEhy1R43tnhHrQ5xnTmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dm8TqVNjc9xMkcFw77UPzeUikXfjeoRZNA+9u0rKnU8zhieOPFyi8QDFOTQSROybs
         n+IrlM1W93L9kfC5M0vqz0ESErrKH87SZ/56zdsfQGbN1nPs/oLif2oqk31UApBasc
         j3TMjYEec8ZPW/RrIii4C2zvkPYbjVL+ZRYeM6rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>,
        Eric Dumazet <edumazet@google.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.14 14/69] tcp: Clear sk_send_head after purging the write queue
Date:   Wed, 14 Aug 2019 19:01:12 +0200
Message-Id: <20190814165746.523313498@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Denis Andzakovic discovered a potential use-after-free in older kernel
versions, using syzkaller.  tcp_write_queue_purge() frees all skbs in
the TCP write queue and can leave sk->sk_send_head pointing to freed
memory.  tcp_disconnect() clears that pointer after calling
tcp_write_queue_purge(), but tcp_connect() does not.  It is
(surprisingly) possible to add to the write queue between
disconnection and reconnection, so this needs to be done in both
places.

This bug was introduced by backports of commit 7f582b248d0a ("tcp:
purge write queue in tcp_connect_init()") and does not exist upstream
because of earlier changes in commit 75c119afe14f ("tcp: implement
rb-tree based retransmit queue").  The latter is a major change that's
not suitable for stable.

Reported-by: Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>
Bisected-by: Salvatore Bonaccorso <carnil@debian.org>
Fixes: 7f582b248d0a ("tcp: purge write queue in tcp_connect_init()")
Cc: <stable@vger.kernel.org> # before 4.15
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1613,6 +1613,8 @@ static inline void tcp_init_send_head(st
 	sk->sk_send_head = NULL;
 }
 
+static inline void tcp_init_send_head(struct sock *sk);
+
 /* write queue abstraction */
 static inline void tcp_write_queue_purge(struct sock *sk)
 {
@@ -1621,6 +1623,7 @@ static inline void tcp_write_queue_purge
 	tcp_chrono_stop(sk, TCP_CHRONO_BUSY);
 	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
 		sk_wmem_free_skb(sk, skb);
+	tcp_init_send_head(sk);
 	sk_mem_reclaim(sk);
 	tcp_clear_all_retrans_hints(tcp_sk(sk));
 	tcp_init_send_head(sk);


