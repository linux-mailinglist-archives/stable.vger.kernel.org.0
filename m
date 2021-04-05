Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236C4353F95
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239218AbhDEJNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239209AbhDEJNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED3C610E8;
        Mon,  5 Apr 2021 09:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613989;
        bh=Pw3B7YIZFj4sTY+CXiuHColziBuFEczoZScUTK8T/Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=04PfZBmT15Zz0PQdWWz6xD8P4B5Pa6S9yzl/j6FYihaIm0N/6buQskyL+xLAXtelY
         5JVymhxohQ7QTJ7NYDp6iN0ULc17t+GEvEKo3ojqoH58lCt0QQGTgTMV05+aZSHa17
         LSin8LXDROF+LI8ldC7sBEJI2iUJnGfvF4aCvPiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 043/152] mptcp: init mptcp request socket earlier
Date:   Mon,  5 Apr 2021 10:53:12 +0200
Message-Id: <20210405085035.677811188@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit d8b59efa64060d17b7b61f97d891de2d9f2bd9f0 ]

The mptcp subflow route_req() callback performs the subflow
req initialization after the route_req() check. If the latter
fails, mptcp-specific bits of the current request sockets
are left uninitialized.

The above causes bad things at req socket disposal time, when
the mptcp resources are cleared.

This change addresses the issue by splitting subflow_init_req()
into the actual initialization and the mptcp-specific checks.
The initialization is moved before any possibly failing check.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 7ea851d19b23 ("tcp: merge 'init_req' and 'route_req' functions")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6c0205816a5d..f97f29df4505 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -92,7 +92,7 @@ static struct mptcp_sock *subflow_token_join_request(struct request_sock *req,
 	return msk;
 }
 
-static int __subflow_init_req(struct request_sock *req, const struct sock *sk_listener)
+static void subflow_init_req(struct request_sock *req, const struct sock *sk_listener)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 
@@ -100,16 +100,6 @@ static int __subflow_init_req(struct request_sock *req, const struct sock *sk_li
 	subflow_req->mp_join = 0;
 	subflow_req->msk = NULL;
 	mptcp_token_init_request(req);
-
-#ifdef CONFIG_TCP_MD5SIG
-	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
-	 * TCP option space.
-	 */
-	if (rcu_access_pointer(tcp_sk(sk_listener)->md5sig_info))
-		return -EINVAL;
-#endif
-
-	return 0;
 }
 
 /* Init mptcp request socket.
@@ -117,20 +107,23 @@ static int __subflow_init_req(struct request_sock *req, const struct sock *sk_li
  * Returns an error code if a JOIN has failed and a TCP reset
  * should be sent.
  */
-static int subflow_init_req(struct request_sock *req,
-			    const struct sock *sk_listener,
-			    struct sk_buff *skb)
+static int subflow_check_req(struct request_sock *req,
+			     const struct sock *sk_listener,
+			     struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
 	struct mptcp_options_received mp_opt;
-	int ret;
 
 	pr_debug("subflow_req=%p, listener=%p", subflow_req, listener);
 
-	ret = __subflow_init_req(req, sk_listener);
-	if (ret)
-		return 0;
+#ifdef CONFIG_TCP_MD5SIG
+	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
+	 * TCP option space.
+	 */
+	if (rcu_access_pointer(tcp_sk(sk_listener)->md5sig_info))
+		return -EINVAL;
+#endif
 
 	mptcp_get_options(skb, &mp_opt);
 
@@ -205,10 +198,7 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	struct mptcp_options_received mp_opt;
 	int err;
 
-	err = __subflow_init_req(req, sk_listener);
-	if (err)
-		return err;
-
+	subflow_init_req(req, sk_listener);
 	mptcp_get_options(skb, &mp_opt);
 
 	if (mp_opt.mp_capable && mp_opt.mp_join)
@@ -248,12 +238,13 @@ static struct dst_entry *subflow_v4_route_req(const struct sock *sk,
 	int err;
 
 	tcp_rsk(req)->is_mptcp = 1;
+	subflow_init_req(req, sk);
 
 	dst = tcp_request_sock_ipv4_ops.route_req(sk, skb, fl, req);
 	if (!dst)
 		return NULL;
 
-	err = subflow_init_req(req, sk, skb);
+	err = subflow_check_req(req, sk, skb);
 	if (err == 0)
 		return dst;
 
@@ -273,12 +264,13 @@ static struct dst_entry *subflow_v6_route_req(const struct sock *sk,
 	int err;
 
 	tcp_rsk(req)->is_mptcp = 1;
+	subflow_init_req(req, sk);
 
 	dst = tcp_request_sock_ipv6_ops.route_req(sk, skb, fl, req);
 	if (!dst)
 		return NULL;
 
-	err = subflow_init_req(req, sk, skb);
+	err = subflow_check_req(req, sk, skb);
 	if (err == 0)
 		return dst;
 
-- 
2.30.1



