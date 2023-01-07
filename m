Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA98660B98
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 02:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjAGBqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 20:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjAGBqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 20:46:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2433E87936
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 17:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673056003; x=1704592003;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tdUNtY26CU/G5cw+K8EYRXAPOyGgj13nrX+yMhWgTdE=;
  b=cRNLK68vhOqTKX+uN2da3LF6Hmdt0VsRzKSWBwVSiFFWgRY+UKiXj/vc
   qZ9wWBEeCIwvIzZMUaN1xIbKaQmmJkEXhzNNbCH7WmM2WtlUcu8FiOPZF
   1mjrgS/2D1mc9vYPnbAOdooJHb1gDdtfo5/cRZLUSw3KMLvL4FfgYFwrZ
   jZMPHnVrm78T9foaNRszb9XDhGpfXrwjBeFv+2R2NFLTk3EdUd+sEvC69
   A+pw7KK4NuBj5d06t1K3BnV72lZIE/MvfsVyPeevMJjozo4nPmgsGOzEJ
   PJdkWTNH439JBN8+f94l6O6KiOOE/jwvBDG0Cpd5NpqLnMW2Jba4849li
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="310393551"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="310393551"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 17:46:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="606066134"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="606066134"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 17:46:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Florian Westphal <fw@strlen.de>, matthieu.baerts@tessares.net,
        pabeni@redhat.com, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 1/4] mptcp: mark ops structures as ro_after_init
Date:   Fri,  6 Jan 2023 17:46:28 -0800
Message-Id: <20230107014631.449550-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107014631.449550-1-mathew.j.martineau@linux.intel.com>
References: <20230107014631.449550-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Cc: stable@vger.kernel.org # 5.10
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/mptcp/subflow.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 2e9238490924..61919e2499e7 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -360,8 +360,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 }
 
 struct request_sock_ops mptcp_subflow_request_sock_ops;
-EXPORT_SYMBOL_GPL(mptcp_subflow_request_sock_ops);
-static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
+static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -382,9 +381,9 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
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
@@ -636,7 +635,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	return child;
 }
 
-static struct inet_connection_sock_af_ops subflow_specific;
+static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
 
 enum mapping_status {
 	MAPPING_OK,
@@ -1017,7 +1016,7 @@ static void subflow_write_space(struct sock *sk)
 	}
 }
 
-static struct inet_connection_sock_af_ops *
+static const struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1032,7 +1031,7 @@ void mptcpv6_handle_mapped(struct sock *sk, bool mapped)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct inet_connection_sock_af_ops *target;
+	const struct inet_connection_sock_af_ops *target;
 
 	target = mapped ? &subflow_v6m_specific : subflow_default_af_ops(sk);
 
-- 
2.39.0

