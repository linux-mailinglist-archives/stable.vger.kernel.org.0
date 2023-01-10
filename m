Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3662E664A2C
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbjAJSa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbjAJSa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9AE52C6B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2404617C9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D99C433EF;
        Tue, 10 Jan 2023 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375103;
        bh=H1YgyaGAo+4E/x6dHWOtYbmCXhZmhrAlq31OIZN4sd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEkoqRlnJLZk0/s6DY71iaNJsfRYVFK3d+BBduvvuG5NBz6R8ljLr0nB6LAfTnwVd
         5iu7j71K/YXndm1lAW06N6lG70cFLyedJryQRiq3rsOfd8URuTIvb3KdKkmldOXqes
         br54qZp6NbOUtElPUrWzpvo+OvAE1m84zG2yr3h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 079/290] mptcp: mark ops structures as ro_after_init
Date:   Tue, 10 Jan 2023 19:02:51 +0100
Message-Id: <20230110180034.345013016@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 51fa7f8ebf0e25c7a9039fa3988a623d5f3855aa upstream.

These structures are initialised from the init hooks, so we can't make
them 'const'.  But no writes occur afterwards, so we can use ro_after_init.

Also, remove bogus EXPORT_SYMBOL, the only access comes from ip
stack, not from kernel modules.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -484,8 +484,7 @@ do_reset:
 }
 
 struct request_sock_ops mptcp_subflow_request_sock_ops;
-EXPORT_SYMBOL_GPL(mptcp_subflow_request_sock_ops);
-static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
+static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -506,9 +505,9 @@ drop:
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops;
-static struct inet_connection_sock_af_ops subflow_v6_specific;
-static struct inet_connection_sock_af_ops subflow_v6m_specific;
+static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
+static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
+static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
 static struct proto tcpv6_prot_override;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -790,7 +789,7 @@ dispose_child:
 	return child;
 }
 
-static struct inet_connection_sock_af_ops subflow_specific;
+static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
 static struct proto tcp_prot_override;
 
 enum mapping_status {
@@ -1327,7 +1326,7 @@ static void subflow_write_space(struct s
 	mptcp_write_space(sk);
 }
 
-static struct inet_connection_sock_af_ops *
+static const struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1342,7 +1341,7 @@ void mptcpv6_handle_mapped(struct sock *
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct inet_connection_sock_af_ops *target;
+	const struct inet_connection_sock_af_ops *target;
 
 	target = mapped ? &subflow_v6m_specific : subflow_default_af_ops(sk);
 


