Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B1760A1C8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiJXLdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJXLcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC78563D03;
        Mon, 24 Oct 2022 04:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20BE0B81133;
        Mon, 24 Oct 2022 11:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55457C433D6;
        Mon, 24 Oct 2022 11:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611147;
        bh=lmA2M8bscm+/EI8CH4eNhJyaj0shg8stUorn666SD8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6pUeuDBZKi3zSZKvdL5WBJl/gi4EMJlHs5JT4z6mbqK8HAlvxtOxIg42v5sVofQQ
         fRRnijGRWmvzYJEVkArqbJhXGeKXikGxWyPVkex7rpz9raWFSZLbXcnWPGIobq/2Ej
         vTxW5C7jzkFrNOT6aPB4HpJW6Fs7FNKAONdsW7zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 08/20] net: flag sockets supporting msghdr originated zerocopy
Date:   Mon, 24 Oct 2022 13:31:10 +0200
Message-Id: <20221024112934.784075701@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit e993ffe3da4bcddea0536b03be1031bf35cd8d85 upstream.

We need an efficient way in io_uring to check whether a socket supports
zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
socket flags fields.

Cc: <stable@vger.kernel.org> # 6.0
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/net.h |    1 +
 net/ipv4/tcp.c      |    1 +
 net/ipv4/udp.c      |    1 +
 3 files changed, 3 insertions(+)

--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -41,6 +41,7 @@ struct net;
 #define SOCK_NOSPACE		2
 #define SOCK_PASSCRED		3
 #define SOCK_PASSSEC		4
+#define SOCK_SUPPORT_ZC		5
 
 #ifndef ARCH_HAS_SOCKET_TYPES
 /**
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -457,6 +457,7 @@ void tcp_init_sock(struct sock *sk)
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	sk_sockets_allocated_inc(sk);
 }
 EXPORT_SYMBOL(tcp_init_sock);
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1620,6 +1620,7 @@ int udp_init_sock(struct sock *sk)
 {
 	skb_queue_head_init(&udp_sk(sk)->reader_queue);
 	sk->sk_destruct = udp_destruct_sock;
+	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_init_sock);


