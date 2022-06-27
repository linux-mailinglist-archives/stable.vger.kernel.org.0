Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5C155CD20
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbiF0Lu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238560AbiF0Lsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E17C101EA;
        Mon, 27 Jun 2022 04:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07633B8113A;
        Mon, 27 Jun 2022 11:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE2DC3411D;
        Mon, 27 Jun 2022 11:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330138;
        bh=LjBH4AifqECpsGBBZJMRgsAzTKBewlo/fHgTiYzDSTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGRyf8Upohve++4ZvrwIPndFI55+p+FMJEqcW9BcvD9KhBKme3vjkcY7YUjRLOzlf
         YwF5USZhwIsUygN/Ni4iex3WNEhCcdFTOn0wTlQU6CzqVWjHbf4AZc+WHFCZj971FD
         Boa40e/lfatqijzSOQj3xzcEjyO5s1wPNAidhZBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 098/181] sock: redo the psock vs ULP protection check
Date:   Mon, 27 Jun 2022 13:21:11 +0200
Message-Id: <20220627111947.400519931@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e34a07c0ae3906f97eb18df50902e2a01c1015b6 ]

Commit 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
has moved the inet_csk_has_ulp(sk) check from sk_psock_init() to
the new tcp_bpf_update_proto() function. I'm guessing that this
was done to allow creating psocks for non-inet sockets.

Unfortunately the destruction path for psock includes the ULP
unwind, so we need to fail the sk_psock_init() itself.
Otherwise if ULP is already present we'll notice that later,
and call tcp_update_ulp() with the sk_proto of the ULP
itself, which will most likely result in the ULP looping
its callbacks.

Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/r/20220620191353.1184629-2-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_sock.h | 5 +++++
 net/core/skmsg.c        | 5 +++++
 net/ipv4/tcp_bpf.c      | 3 ---
 net/tls/tls_main.c      | 2 ++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 234d70ae5f4c..48e4c59d85e2 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -252,6 +252,11 @@ struct inet_sock {
 #define IP_CMSG_CHECKSUM	BIT(7)
 #define IP_CMSG_RECVFRAGSIZE	BIT(8)
 
+static inline bool sk_is_inet(struct sock *sk)
+{
+	return sk->sk_family == AF_INET || sk->sk_family == AF_INET6;
+}
+
 /**
  * sk_to_full_sk - Access to a full socket
  * @sk: pointer to a socket
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cc381165ea08..ede0af308f40 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -695,6 +695,11 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 
 	write_lock_bh(&sk->sk_callback_lock);
 
+	if (sk_is_inet(sk) && inet_csk_has_ulp(sk)) {
+		psock = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
 	if (sk->sk_user_data) {
 		psock = ERR_PTR(-EBUSY);
 		goto out;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1cdcb4df0eb7..2c597a4e429a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -612,9 +612,6 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 		return 0;
 	}
 
-	if (inet_csk_has_ulp(sk))
-		return -EINVAL;
-
 	if (sk->sk_family == AF_INET6) {
 		if (tcp_bpf_assert_proto_ops(psock->sk_proto))
 			return -EINVAL;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7b2b0e7ffee4..5c9697840ef7 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -873,6 +873,8 @@ static void tls_update(struct sock *sk, struct proto *p,
 {
 	struct tls_context *ctx;
 
+	WARN_ON_ONCE(sk->sk_prot == p);
+
 	ctx = tls_get_ctx(sk);
 	if (likely(ctx)) {
 		ctx->sk_write_space = write_space;
-- 
2.35.1



