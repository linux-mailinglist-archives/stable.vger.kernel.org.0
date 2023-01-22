Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D13676FDB
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjAVP0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjAVP0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:26:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE0522A28
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAA40B80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259BEC4339B;
        Sun, 22 Jan 2023 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401156;
        bh=43xr4FgWKFFquChX0jKpvibNYUbsckHPDl1XFC8dU8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2tozyR7TD3HB84GB+pBtaU/PgR8K3iIrQex0B4nDUtvst9hs2sSXJ/usNOoJysJM
         Twl8MQXdVpr8PAy5PNgSS8NciY/XvmHLcADCZlJIj6tXWQkqRxsETqR5nzaGdZ8Cjv
         o5JiVtnFhj6POC4Pg3v/sHSN+74wsim1a2EcErR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 101/193] mptcp: explicitly specify sock family at subflow creation time
Date:   Sun, 22 Jan 2023 16:03:50 +0100
Message-Id: <20230122150250.941466903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 6bc1fe7dd748ba5e76e7917d110837cafe7b931c upstream.

Let the caller specify the to-be-created subflow family.

For a given MPTCP socket created with the AF_INET6 family, the current
userspace PM can already ask the kernel to create subflows in v4 and v6.
If "plain" IPv4 addresses are passed to the kernel, they are
automatically mapped in v6 addresses "by accident". This can be
problematic because the userspace will need to pass different addresses,
now the v4-mapped-v6 addresses to destroy this new subflow.

On the other hand, if the MPTCP socket has been created with the AF_INET
family, the command to create a subflow in v6 will be accepted but the
result will not be the one as expected as new subflow will be created in
IPv4 using part of the v6 addresses passed to the kernel: not creating
the expected subflow then.

No functional change intended for the in-kernel PM where an explicit
enforcement is currently in place. This arbitrary enforcement will be
leveraged by other patches in a future version.

Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 +-
 net/mptcp/protocol.h |    3 ++-
 net/mptcp/subflow.c  |    9 +++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -107,7 +107,7 @@ static int __mptcp_socket_create(struct
 	struct socket *ssock;
 	int err;
 
-	err = mptcp_subflow_create_socket(sk, &ssock);
+	err = mptcp_subflow_create_socket(sk, sk->sk_family, &ssock);
 	if (err)
 		return err;
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -626,7 +626,8 @@ bool mptcp_addresses_equal(const struct
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 			    const struct mptcp_addr_info *remote);
-int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
+int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
+				struct socket **new_sock);
 void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 			 struct sockaddr_storage *addr,
 			 unsigned short family);
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1492,7 +1492,7 @@ int __mptcp_subflow_connect(struct sock
 	if (!mptcp_is_fully_established(sk))
 		goto err_out;
 
-	err = mptcp_subflow_create_socket(sk, &sf);
+	err = mptcp_subflow_create_socket(sk, loc->family, &sf);
 	if (err)
 		goto err_out;
 
@@ -1604,7 +1604,9 @@ static void mptcp_subflow_ops_undo_overr
 #endif
 		ssk->sk_prot = &tcp_prot;
 }
-int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
+
+int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
+				struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
 	struct net *net = sock_net(sk);
@@ -1617,8 +1619,7 @@ int mptcp_subflow_create_socket(struct s
 	if (unlikely(!sk->sk_socket))
 		return -EINVAL;
 
-	err = sock_create_kern(net, sk->sk_family, SOCK_STREAM, IPPROTO_TCP,
-			       &sf);
+	err = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP, &sf);
 	if (err)
 		return err;
 


