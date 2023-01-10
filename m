Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D450664998
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbjAJSXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239125AbjAJSWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF69152F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:19:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7DAD2CE18DE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AB4C433EF;
        Tue, 10 Jan 2023 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374786;
        bh=mM9hQQdsSaOws+dktzHTN33AcjfUxJ/YEfP2W+5W2u4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/KRkr7wZ7jLDIIXdfMfvrxTi7HXEi305Qn6s0WHE6KhCadVsZcZ7m3K5bTjo3Elt
         sQCZ9Elk51mxRjBV1aq8zkCpeVJrWKIf+zxwTjajw4Egm2nn3nw1fyo62cygZDs9Ri
         NJoX2yGIbHvnYGsVq46b5wJaSofF0xj7/1FlQuok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, slipper <slipper.alive@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/159] net/ulp: prevent ULP without clone op from entering the LISTEN status
Date:   Tue, 10 Jan 2023 19:04:12 +0100
Message-Id: <20230110180021.591659945@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2c02d41d71f90a5168391b6a5f2954112ba2307c ]

When an ULP-enabled socket enters the LISTEN status, the listener ULP data
pointer is copied inside the child/accepted sockets by sk_clone_lock().

The relevant ULP can take care of de-duplicating the context pointer via
the clone() operation, but only MPTCP and SMC implement such op.

Other ULPs may end-up with a double-free at socket disposal time.

We can't simply clear the ULP data at clone time, as TLS replaces the
socket ops with custom ones assuming a valid TLS ULP context is
available.

Instead completely prevent clone-less ULP sockets from entering the
LISTEN status.

Fixes: 734942cc4ea6 ("tcp: ULP infrastructure")
Reported-by: slipper <slipper.alive@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 14 ++++++++++++++
 net/ipv4/tcp_ulp.c              |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0465ada82799..647b3c6b575e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1200,12 +1200,26 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
+static int inet_ulp_can_listen(const struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
+		return -EINVAL;
+
+	return 0;
+}
+
 int inet_csk_listen_start(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
 	int err;
 
+	err = inet_ulp_can_listen(sk);
+	if (unlikely(err))
+		return err;
+
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
 	sk->sk_ack_backlog = 0;
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 9ae50b1bd844..05b6077b9f2c 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -139,6 +139,10 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (sk->sk_socket)
 		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 
+	err = -EINVAL;
+	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
+		goto out_err;
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;
-- 
2.35.1



