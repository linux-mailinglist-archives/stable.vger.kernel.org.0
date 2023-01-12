Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9058366781B
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbjALOwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbjALOwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:52:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CFA564C2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:39:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD3862031
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B49C433EF;
        Thu, 12 Jan 2023 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534346;
        bh=mkZxIkit+XOEv5TBZVZnM7eu9l5XNTHHlTNyvinujm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emJ7d0oZNKfCuTwb1E5T6i2lNJLjIpIpP7VotyUJDGyNSRseJ/lu5ksLc678Gy7qn
         XhGbVHxZA45+P3KM4ApkoPnZxkrklVD0JgVzbPcZldWLUh7NqgwMbe3uvJMVKB1do6
         MCZ1flMd+P3waYORkXu0PTg+1JQPkKTE+EnD4h2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 778/783] mptcp: mark ops structures as ro_after_init
Date:   Thu, 12 Jan 2023 14:58:14 +0100
Message-Id: <20230112135600.461781060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

From: Florian Westphal <fw@strlen.de>

commit 51fa7f8ebf0e25c7a9039fa3988a623d5f3855aa upstream.

These structures are initialised from the init hooks, so we can't make
them 'const'.  But no writes occur afterwards, so we can use ro_after_init.

Also, remove bogus EXPORT_SYMBOL, the only access comes from ip
stack, not from kernel modules.

Cc: stable@vger.kernel.org # 5.10
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -360,8 +360,7 @@ do_reset:
 }
 
 struct request_sock_ops mptcp_subflow_request_sock_ops;
-EXPORT_SYMBOL_GPL(mptcp_subflow_request_sock_ops);
-static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
+static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -382,9 +381,9 @@ drop:
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops;
-static struct inet_connection_sock_af_ops subflow_v6_specific;
-static struct inet_connection_sock_af_ops subflow_v6m_specific;
+static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
+static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
+static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -636,7 +635,7 @@ dispose_child:
 	return child;
 }
 
-static struct inet_connection_sock_af_ops subflow_specific;
+static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
 
 enum mapping_status {
 	MAPPING_OK,
@@ -1017,7 +1016,7 @@ static void subflow_write_space(struct s
 	}
 }
 
-static struct inet_connection_sock_af_ops *
+static const struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1032,7 +1031,7 @@ void mptcpv6_handle_mapped(struct sock *
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct inet_connection_sock_af_ops *target;
+	const struct inet_connection_sock_af_ops *target;
 
 	target = mapped ? &subflow_v6m_specific : subflow_default_af_ops(sk);
 


