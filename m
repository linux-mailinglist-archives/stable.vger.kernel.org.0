Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3E010BAFC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbfK0VIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732750AbfK0VIb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC6ED217D9;
        Wed, 27 Nov 2019 21:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888910;
        bh=OJZ8AaGi6qccJKH+7gyFpQT2+Q0mktnDPmUzldyvW/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neWnYi2RqfG66CiJNRBO56Qq8PTA/D1heP4aI41MLJjYqe1mhFTXcjFCHK/9i+VTw
         7hmNj3i9T7stTuh1rL9gxWwmA81/wNP285uzbshk6Vn4CM7gBA647aWgzgfSHOpvf1
         wb7iMxu5fNOyimBnsRvczkE0NzR0Bx00lwkghPIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 11/95] net/tls: enable sk_msg redirect to tls socket egress
Date:   Wed, 27 Nov 2019 21:31:28 +0100
Message-Id: <20191127202849.967998412@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit d4ffb02dee2fcb20e0c8086a8d1305bf885820bb ]

Bring back tls_sw_sendpage_locked. sk_msg redirection into a socket
with TLS_TX takes the following path:

  tcp_bpf_sendmsg_redir
    tcp_bpf_push_locked
      tcp_bpf_push
        kernel_sendpage_locked
          sock->ops->sendpage_locked

Also update the flags test in tls_sw_sendpage_locked to allow flag
MSG_NO_SHARED_FRAGS. bpf_tcp_sendmsg sets this.

Link: https://lore.kernel.org/netdev/CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com/T/#t
Link: https://github.com/wdebruij/kerneltools/commits/icept.2
Fixes: 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect through ULP")
Fixes: f3de19af0f5b ("Revert \"net/tls: remove unused function tls_sw_sendpage_locked\"")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tls.h  |    2 ++
 net/tls/tls_main.c |    1 +
 net/tls/tls_sw.c   |   11 +++++++++++
 3 files changed, 14 insertions(+)

--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -364,6 +364,8 @@ int tls_set_sw_offload(struct sock *sk,
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
+			   int offset, size_t size, int flags);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags);
 void tls_sw_cancel_work_tx(struct tls_context *tls_ctx);
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -852,6 +852,7 @@ static int __init tls_register(void)
 {
 	tls_sw_proto_ops = inet_stream_ops;
 	tls_sw_proto_ops.splice_read = tls_sw_splice_read;
+	tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,
 
 #ifdef CONFIG_TLS_DEVICE
 	tls_device_init();
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1204,6 +1204,17 @@ sendpage_end:
 	return copied ? copied : ret;
 }
 
+int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
+			   int offset, size_t size, int flags)
+{
+	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
+		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
+		      MSG_NO_SHARED_FRAGS))
+		return -ENOTSUPP;
+
+	return tls_sw_do_sendpage(sk, page, offset, size, flags);
+}
+
 int tls_sw_sendpage(struct sock *sk, struct page *page,
 		    int offset, size_t size, int flags)
 {


