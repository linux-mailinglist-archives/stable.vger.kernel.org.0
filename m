Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8981C7F28A
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392074AbfHBJqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392071AbfHBJqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0398C2086A;
        Fri,  2 Aug 2019 09:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739208;
        bh=QnRODtU+IhQ9R5ywnjwo5VAXF8+yANFaGCE63gBLPss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5yky6alrmucaqX5P7ID953rcxLrx1gUgRdVuo7mJcnncYoaXlxSos1iXFpgZSAcm
         T/fIqtWvFxxKdTq+/ionSKBRTXCbwjKUubJUKJnuT/+6AT5806W3M3JZQ7Ss0VDQEN
         tU61AYQDA6addrV92u8w8AQ3uyrflPmat0yA7wOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 147/223] tcp: Reset bytes_acked and bytes_received when disconnecting
Date:   Fri,  2 Aug 2019 11:36:12 +0200
Message-Id: <20190802092248.090760100@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>

[ Upstream commit e858faf556d4e14c750ba1e8852783c6f9520a0e ]

If an app is playing tricks to reuse a socket via tcp_disconnect(),
bytes_acked/received needs to be reset to 0. Otherwise tcp_info will
report the sum of the current and the old connection..

Cc: Eric Dumazet <edumazet@google.com>
Fixes: 0df48c26d841 ("tcp: add tcpi_bytes_acked to tcp_info")
Fixes: bdd1f9edacb5 ("tcp: add tcpi_bytes_received to tcp_info")
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2312,6 +2312,8 @@ int tcp_disconnect(struct sock *sk, int
 	dst_release(sk->sk_rx_dst);
 	sk->sk_rx_dst = NULL;
 	tcp_saved_syn_free(tp);
+	tp->bytes_acked = 0;
+	tp->bytes_received = 0;
 
 	WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);
 


